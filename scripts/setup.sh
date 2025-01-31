#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to copy example files if target files don't exist
copy_example_files() {
    find . -name "*.example" | while read -r example_file; do
        target_file="${example_file%.example}"
        if [ ! -f "$target_file" ]; then
            cp "$example_file" "$target_file"
        fi
    done
}

# Function to check if all .example files have corresponding target files
all_examples_have_target_files() {
    find . -name "*.example" | while read -r example_file; do
        target_file="${example_file%.example}"
        if [ ! -f "$target_file" ]; then
            return 1
        fi
    done
    return 0
}

# Ensure the configuration file exists
if [ ! -f "./config/emdeck.conf" ]; then
    copy_example_files
    echo -e "${RED}Error:${NC} Please fill out the ${CYAN}config/emdeck.conf${NC} file before continuing."
    exit 1
fi

# Read the configuration file
export $(grep -vE '^\s*#|^\s*$|^\[.*\]' ./config/emdeck.conf | xargs)

# Validate MYSQL_ROOT_PASSWORD
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo -e "${RED}Error:${NC} MYSQL_ROOT_PASSWORD is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ "$MYSQL_ROOT_PASSWORD" == "root_password" ]; then
    echo -e "${RED}Error:${NC} Please change the MYSQL_ROOT_PASSWORD in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if ! [[ "$MYSQL_ROOT_PASSWORD" =~ [A-Z] ]] || ! [[ "$MYSQL_ROOT_PASSWORD" =~ [a-z] ]] ||
    ! [[ "$MYSQL_ROOT_PASSWORD" =~ [0-9] ]] || ! [[ "$MYSQL_ROOT_PASSWORD" =~ [^A-Za-z0-9] ]] ||
    [ ${#MYSQL_ROOT_PASSWORD} -lt 8 ]; then
    echo -e "${RED}Error:${NC} MYSQL_ROOT_PASSWORD is not strong enough. It must contain at least one uppercase letter, one lowercase letter, one number, one special character, and be at least 8 characters long."
    exit 1
fi

# Ensure all example files have target files
if ! all_examples_have_target_files; then
    copy_example_files
    echo -e "${YELLOW}Warning:${NC} Please fill out the example files before continuing."
    exit 1
fi

# we need to ensure we have all the variables set in the config file
if [ -z "$ENABLE_MYSQL" ]; then
    echo -e "${RED}Error:${NC} ENABLE_MYSQL is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_REDIS" ]; then
    echo -e "${RED}Error:${NC} ENABLE_REDIS is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_PORTAINER" ]; then
    echo -e "${RED}Error:${NC} ENABLE_PORTAINER is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_EMR" ]; then
    echo -e "${RED}Error:${NC} ENABLE_EMR is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_DDE" ]; then
    echo -e "${RED}Error:${NC} ENABLE_DDE is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_EMC" ]; then
    echo -e "${RED}Error:${NC} ENABLE_EMC is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$ENABLE_CORE" ]; then
    echo -e "${RED}Error:${NC} ENABLE_CORE is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

# EMR_API_REPO, DDE_REPO, EMC_REPO, CORE_REPO and they can choose between HTTPS and SSH versions
if [ -z "$EMR_API_REPO" ]; then
    echo -e "${RED}Error:${NC} EMR_API_REPO is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$DDE_REPO" ]; then
    echo -e "${RED}Error:${NC} DDE_REPO is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$EMC_REPO" ]; then
    echo -e "${RED}Error:${NC} EMC_REPO is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$CORE_REPO" ]; then
    echo -e "${RED}Error:${NC} CORE_REPO is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

# we need to ensure that the repositories are either HTTPS or SSH
if [[ "$EMR_API_REPO" != "https://"* ]] && [[ "$EMR_API_REPO" != "git@"* ]]; then
    echo -e "${RED}Error:${NC} EMR_API_REPO must be either HTTPS or SSH."
    exit 1
fi

if [[ "$DDE_REPO" != "https://"* ]] && [[ "$DDE_REPO" != "git@"* ]]; then
    echo -e "${RED}Error:${NC} DDE_REPO must be either HTTPS or SSH."
    exit 1
fi

if [[ "$EMC_REPO" != "https://"* ]] && [[ "$EMC_REPO" != "git@"* ]]; then
    echo -e "${RED}Error:${NC} EMC_REPO must be either HTTPS or SSH."
    exit 1
fi

if [[ "$CORE_REPO" != "https://"* ]] && [[ "$CORE_REPO" != "git@"* ]]; then
    echo -e "${RED}Error:${NC} CORE_REPO must be either HTTPS or SSH."
    exit 1
fi

# RAILS_MAX_THREADS, PORTAINER_ADMIN_USERNAME, PORTAINER_ADMIN_PASSWORD
if [ -z "$RAILS_MAX_THREADS" ]; then
    echo -e "${RED}Error:${NC} RAILS_MAX_THREADS is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$PORTAINER_ADMIN_USERNAME" ]; then
    echo -e "${RED}Error:${NC} PORTAINER_ADMIN_USERNAME is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

if [ -z "$PORTAINER_ADMIN_PASSWORD" ]; then
    echo -e "${RED}Error:${NC} PORTAINER_ADMIN_PASSWORD is not set in ${CYAN}config/emdeck.conf${NC}."
    exit 1
fi

# we need to replace all files in docker folder that have the MYSQL_ROOT_PASSWORD placeholder with the actual password
# we should void .example files
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version
    find ./docker -type f -not -name "*.example" -exec sed -i '' "s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" {} +
else
    # Ubuntu (and other Linux distributions) version
    find ./docker -type f -not -name "*.example" -exec sed -i "s/MYSQL_ROOT_PASSWORD/$MYSQL_ROOT_PASSWORD/g" {} +
fi

# lets delete the existing services from the docker-compose.yml
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS version
    sed -i '' '/services:/q' ./docker/docker-compose.yml
else
    # Ubuntu (and other Linux distributions) version
    sed -i '/services:/q' ./docker/docker-compose.yml
fi

# Add the services to the docker-compose.yml
echo "" >>./docker/docker-compose.yml
echo "services:" >>./docker/docker-compose.yml

# Toggle services based on the configuration
python ./scripts/add_service.py "mysql" "$ENABLE_MYSQL"
python ./scripts/add_service.py "redis" "$ENABLE_REDIS"
python ./scripts/add_service.py "portainer" "$ENABLE_PORTAINER"
python ./scripts/add_service.py "emr" "$ENABLE_EMR"
python ./scripts/add_service.py "dde" "$ENABLE_DDE"
python ./scripts/add_service.py "emc" "$ENABLE_EMC"
python ./scripts/add_service.py "core" "$ENABLE_CORE"

# Lets complete the docker-compose.yml file
cat <<EOF >>./docker/docker-compose.yml
networks:
  emdeck-network:
    driver: bridge
volumes:
  emdeck-mysql:
  emdeck-redis:
  emdeck-portainer:
EOF
echo -e "${GREEN}Success:${NC} Configuration looks good."
exit 0
