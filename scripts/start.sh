#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Start the app
./scripts/setup.sh
python3 main.py
# pyton main.py without any exit errors means that the app has been configured out correctly
echo -e "${GREEN}Success:${NC} The app has been configured successfully."
# we need to start the docker-compose services which are in docker/docker-compose.yml
echo -e "${YELLOW}Starting Docker services...${NC}"
echo -e "${YELLOW}This may take a few minutes.${NC}"
echo -e "${YELLOW}Please wait...${NC}"
# we need to inform which ports to access each service
echo -e "${GREEN}You can mysql on port 8085.${NC}"
echo -e "${GREEN}You can redis on port 8084.${NC}"
echo -e "${GREEN}You can portainer on port 8083.${NC}"
echo -e "${GREEN}You can EMR API on port 8081.${NC}"
echo -e "${GREEN}You can DDE on port 8082.${NC}"
echo -e "${GREEN}You can EMC on port 8080.${NC}"
echo -e "${GREEN}You can CORE on port 8086.${NC}"
docker-compose -f ./docker/docker-compose.yml up -d
