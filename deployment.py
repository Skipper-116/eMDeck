import os
import subprocess
from configparser import ConfigParser

class Deployment:
    def __init__(self):
        self.config = self.load_config()

    def load_config(self):
        config = ConfigParser()
        config.read("./config/emdeck.conf")
        return config

    def ensure_tmp_folder(self, service_path):
        """Ensures the tmp folder exists in the service path."""
        tmp_path = os.path.join(service_path, "tmp")
        os.makedirs(tmp_path, exist_ok=True)
        return tmp_path

    def filter_tags(self, tags, tag_format):
        """Filters tags based on the specified format."""
        if tag_format == "semantic":
            return [tag for tag in tags if tag.startswith("v") and tag[1].isdigit()]
        elif tag_format == "quarterly":
            return [tag for tag in tags if tag.startswith("v") and ".Q" in tag and ".R" in tag]
        else:
            raise ValueError(f"Unknown tag format: {tag_format}")

    def get_latest_tag(self, repo_path, tag_format="semantic"):
        """Fetches the latest tag from the repository."""
        try:
            print(f"Fetching tags for repository at {repo_path}...")
            os.chdir(repo_path)
            subprocess.run(["git", "fetch", "--tags"], check=True)
            tags = subprocess.check_output(["git", "tag", "--list", "--sort=-v:refname"]).decode("utf-8").strip().split("\n")
            filtered_tags = self.filter_tags(tags, tag_format)
            return filtered_tags[0] if filtered_tags else None
        except Exception as e:
            print(f"Error fetching tags for {repo_path}: {e}")
            return None
        finally:
            os.chdir("../../")

    def get_current_tag(self, repo_path):
        """Gets the currently checked out tag in the repository."""
        try:
            os.chdir(repo_path)
            current_tag = subprocess.check_output(["git", "describe", "--tags"], stderr=subprocess.DEVNULL).decode("utf-8").strip()
            return current_tag
        except Exception:
            return None
        finally:
            os.chdir("../../")

    def checkout_tag(self, repo_path, tag):
        """Checks out the specified tag in an existing repository."""
        try:
            os.chdir(repo_path)
            print(f"Checking out tag {tag} for repository at {repo_path}...")
            subprocess.run(["git", "checkout", tag], check=True)
        except Exception as e:
            print(f"Error during checkout: {e}")
        finally:
            os.chdir("../../")

    def clone_or_update_repo(self, service, repo, tag_format):
        """Clones the repository if it doesn't exist, otherwise fetches and checks out the latest tag."""
        service_path = f"docker/{service}"
        tmp_path = self.ensure_tmp_folder(service_path)

        if os.path.exists(service_path):
            print(f"Repository for {service} already exists. Checking the current tag...")
            latest_tag = self.get_latest_tag(service_path, tag_format)
            current_tag = self.get_current_tag(service_path)

            if latest_tag == current_tag:
                print(f"{service} is already on the latest tag {latest_tag}. Skipping fetch and checkout.")
            else:
                print(f"Updating {service} to the latest tag {latest_tag}...")
                self.checkout_tag(service_path, latest_tag)
        else:
            print(f"Cloning {service} repository...")
            subprocess.run(["git", "clone", repo, tmp_path], check=True)
            latest_tag = self.get_latest_tag(tmp_path, tag_format)
            if latest_tag:
                self.checkout_tag(tmp_path, latest_tag)
            subprocess.run(["mv", tmp_path, service_path])

    def clone_repos(self):
        """Clones or updates repositories based on the configuration."""
        repos = [
            ("emr-api", self.config.get("DEFAULT", "EMR_API_REPO"), "semantic"),
            ("dde", self.config.get("DEFAULT", "DDE_REPO"), "semantic"),
            ("frontend", self.config.get("DEFAULT", "FRONTEND_REPO"), "quarterly"),
        ]
        for service, repo, tag_format in repos:
            self.clone_or_update_repo(service, repo, tag_format)
