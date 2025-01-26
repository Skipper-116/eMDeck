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

    def filter_tags(self, tags, tag_format):
        if tag_format == "semantic":
            return [tag for tag in tags if tag.startswith("v") and tag[1].isdigit()]
        elif tag_format == "quarterly":
            return [tag for tag in tags if tag.startswith("v") and ".Q" in tag and ".R" in tag]
        else:
            raise ValueError(f"Unknown tag format: {tag_format}")

    def get_latest_tag(self, repo_path, tag_format="semantic"):
        try:
            print(f"Fetching tags for repository at {repo_path}...")
            os.chdir(repo_path)
            subprocess.run(["git", "fetch", "--tags"], check=True)
            tags = subprocess.check_output(["git", "tag", "--list", "--sort=-v:refname"]).decode("utf-8").strip().split("\n")
            filtered_tags = self.filter_tags(tags, tag_format)
            return filtered_tags[0] if filtered_tags else None
        finally:
            os.chdir("../../")

    def clone_repo(self, service, repo, tag_format):
        if repo:
            print(f"Cloning {service} repository...")
            subprocess.run(["git", "clone", repo, f"docker/{service}"])
            latest_tag = self.get_latest_tag(f"docker/{service}", tag_format)
            if latest_tag:
                print(f"Checking out tag {latest_tag} for {service}...")
                os.chdir(f"docker/{service}")
                subprocess.run(["git", "checkout", latest_tag])
                os.chdir("../../")

    def clone_repos(self):
        repos = [
            ("emr-api", self.config.get("DEFAULT", "EMR_API_REPO"), "semantic"),
            ("dde", self.config.get("DEFAULT", "DDE_REPO"), "semantic"),
            ("frontend", self.config.get("DEFAULT", "FRONTEND_REPO"), "quarterly"),
        ]
        for service, repo, tag_format in repos:
            self.clone_repo(service, repo, tag_format)