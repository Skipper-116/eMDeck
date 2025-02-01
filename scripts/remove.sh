#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# prompt user to confirm the removal of all configurations, temp folders, docker containers and images
echo -e "${YELLOW}Warning:${NC} This will remove all configurations, temp folders, docker containers and images. Do you want to continue? (y/n)"
read -r response

if [ "$response" != "y" ]; then
    echo -e "${RED}Aborted:${NC} Removal of configurations, temp folders, docker containers and images."
    exit 1
fi

# now removing configurations
echo -e "${YELLOW}Removing configurations...${NC}"
find . -name "*.example" | while read example_file; do
    target_file="${example_file%.example}"
    if [ -f "$target_file" ]; then
        rm "$target_file"
    fi
done

# now removing temp folders
echo -e "${YELLOW}Removing temp folders...${NC}"
./scripts/clean.sh

# we need to test whether we need to use sudo or not with docker
echo -e "${YELLOW}Removing Docker containers and images...${NC}"
if docker ps &>/dev/null; then
    docker rm -vf $(docker ps -aq)
    docker rmi -f $(docker images -aq)
else
    sudo docker rm -vf $(sudo docker ps -aq)
    sudo docker rmi -f $(sudo docker images -aq)
fi

echo -e "${GREEN}Success:${NC} All Configurations, Temp Folders, Docker containers and images have been removed."
