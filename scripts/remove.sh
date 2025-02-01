#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# prompt user to confirm the immediate removal of all configurations, temp folders, docker containers and images
echo -e "${CYAN}!!! WARNING !!!${NC}"
echo -e "Remove all configs, temp folders, Docker containers and images? (${GREEN}y = proceed${NC}, ${RED}any other key = abort${NC})"
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
    containers=$(docker ps -aq)
    images=$(docker images -aq)
    if [ -n "$containers" ]; then
        docker rm -vf $containers
    fi
    if [ -n "$images" ]; then
        docker rmi -f $images
    fi
else
    containers=$(sudo docker ps -aq)
    images=$(sudo docker images -aq)
    if [ -n "$containers" ]; then
        sudo docker rm -vf $containers
    fi
    if [ -n "$images" ]; then
        sudo docker rmi -f $images
    fi
fi

echo -e "${GREEN}Success:${NC} All Configurations, Temp Folders, Docker containers and images have been removed."
