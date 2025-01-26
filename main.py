from deployment import Deployment

if __name__ == "__main__":
    deployment = Deployment()
    deployment.clone_repos()
    deployment.copy_configs()
    deployment.deploy()
