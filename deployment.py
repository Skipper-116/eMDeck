import os
import subprocess
from configparser import ConfigParser

class Deployment:
    def __init__(self):
        self.config = self.load_config()

    def load_config(self):
        config = ConfigParser()
        config.read("config/emdeck.conf")
        return config

    def get_latest_tag(self, repo_path, tag_format="semantic"):
        try:
            print(f"Fetching tags for repository at {repo_path}...")
            os.chdir(repo_path)
            subprocess.run(["git", "fetch", "--tags"], check=True)
            tags = subprocess.check_output(["git", "tag", "--list", "--sort=-v:refname"]).decode("utf-8").strip().split("\n")

            if tag_format == "semantic":
                filtered_tags = [tag for tag in tags if tag.startswith("v") and tag[1].isdigit()]
            elif tag_format == "quarterly":
                filtered_tags = [tag for tag in tags if tag.startswith("v") and ".Q" in tag and ".R" in tag]
            else:
                raise ValueError(f"Unknown tag format: {tag_format}")

            return filtered_tags[0] if filtered_tags else None
        finally:
            os.chdir("../../")

    def clone_repos(self):
        for service, repo, tag_format in [
            ("emr-api", self.config.get("DEFAULT", "EMR_API_REPO"), "semantic"),
            ("dde", self.config.get("DEFAULT", "DDE_REPO"), "semantic"),
            ("frontend", self.config.get("DEFAULT", "FRONTEND_REPO"), "quarterly"),
        ]:
            if repo:
                print(f"Cloning {service} repository...")
                subprocess.run(["git", "clone", repo, f"docker/{service}"])
                latest_tag = self.get_latest_tag(f"docker/{service}", tag_format)
                if latest_tag:
                    print(f"Checking out tag {latest_tag} for {service}...")
                    os.chdir(f"docker/{service}")
                    subprocess.run(["git", "checkout", latest_tag])
                    os.chdir("../../")

    def copy_configs(self):
        for service in ["emr-api", "dde"]:
            config_path = f"docker/{service}/config/"
            print(f"Copying configuration files for {service}...")
            for file in os.listdir(config_path):
                if not file.endswith(".example"):
                    subprocess.run(["cp", os.path.join(config_path, file), f"docker/{service}/app-config/"])

    def deploy(self):
        print("Creating Docker network...")
        subprocess.run(["docker", "network", "create", self.config.get("DEFAULT", "DOCKER_NETWORK")], check=False)

        print("Building and starting services...")
        subprocess.run(["docker-compose", "-f", "docker/docker-compose.yml", "up", "-d"])

if __name__ == "__main__":
    deployment = Deployment()
    deployment.clone_repos()
    deployment.copy_configs()
    deployment.deploy()
