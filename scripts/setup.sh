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

# lets delete the existing services from the docker-compose.yml
sed -i '' '/services:/q' ./docker/docker-compose.yml

# Add the services to the docker-compose.yml
echo "version: '3.8'" >./docker/docker-compose.yml
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
