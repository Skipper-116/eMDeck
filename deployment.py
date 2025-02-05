import os
import subprocess
from dotenv import load_dotenv

class Deployment:
    def __init__(self):
        self.load_environment()
    
    def load_environment(self):
        """Loads the environment variables from the configuration files."""
        emdeck_path = os.path.join(os.getcwd(), "config/emdeck.conf")
        version_path = os.path.join(os.getcwd(), "config/version.conf")
        load_dotenv(emdeck_path)
        load_dotenv(version_path)

    def ensure_tmp_folder(self, service_path):
        """Ensures the tmp folder exists in the service path."""
        tmp_path = os.path.join(service_path, "tmp")
        os.makedirs(tmp_path, exist_ok=True)
        return tmp_path

    def get_tag(self, repo_path, tag):
        """Fetches the latest tag from the repository."""
        try:
            os.chdir(repo_path)
            # we need to get the results of the git describe command and compare it to the tag we want to checkout
            # if the tag we want to checkout is in the list of tags, we can just checkout the tag
            # if the tag we want to checkout is not in the list of tags, we need to fetch it
            describe_output = subprocess.run(["git", "describe"], check=True, capture_output=True)
            if tag in describe_output.stdout.decode("utf-8"):
                print(f"Tag {tag} already checked out.")
                return
            print(f"Fetching tags for repository at {repo_path}...")
            subprocess.run(["git", "fetch", "--depth=1", "origin", "tag", tag], check=True)
            subprocess.run(["git", "checkout", tag], check=True)
            subprocess.run(["git", "describe", "--tags"], check=True)
        except Exception as e:
            print(f"Error fetching tags for {repo_path}: {e}")
            exit(1)
        finally:
            os.chdir("../../../")


    def clone_or_update_repo(self, service, repo, tag_format):
        """Clones the repository if it doesn't exist, otherwise fetches and checks out the latest tag."""
        service_path = f"docker/{service}"
        tmp_path = self.ensure_tmp_folder(service_path)
        latest_tag = os.environ.get(f"{service.upper()}_TAG")

        if os.path.exists(service_path + "/tmp/.git"):
            print(f"Repository for {service} already exists. Checking the current tag...")
            self.get_tag(service_path + "/tmp", latest_tag)
        else:
            print(f"Cloning {service} repository...")
            subprocess.run(["git", "clone", "--depth=1", "--single-branch", repo, tmp_path], check=True)
            self.get_tag(tmp_path, latest_tag)

    def clone_repos(self):
        """Clones or updates repositories based on the configuration."""
        repos = [
            ("emr", os.environ.get("EMR_API_REPO"), "semantic"),
            ("dde", os.environ.get("DDE_REPO"), "semantic"),
            ("emc", os.environ.get("EMC_REPO"), "quarterly"),
            ('core', os.environ.get("CORE_REPO"), "quarterly"),
        ]
        for service, repo, tag_format in repos:
            if os.environ.get(f"ENABLE_{service.upper()}").lower() == "true":
                self.clone_or_update_repo(service, repo, tag_format)
            else:
                print(f"Skipping {service} repository (disabled in configuration)")

    def deploy(self):
        """
        Orchestrates the deployment process:
        - Ensures repositories are cloned or updated to the latest tag.
        - Copies necessary configurations.
        - Builds and starts the Docker Compose services.
        """
        try:
            print("Starting deployment...")
            self.clone_repos()
            print("Building and starting Docker Compose services...")
            subprocess.run(["docker-compose", "-f", "docker/docker-compose.yml", "up", "-d"], check=True)
            print("Deployment completed successfully!")
        except subprocess.CalledProcessError as e:
            print(f"Error during deployment: {e}")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")
            exit(1)

