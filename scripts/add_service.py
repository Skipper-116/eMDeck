import os
import sys

def get_mysql_service():
    return f"""  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: \"{os.environ.get('MYSQL_ROOT_PASSWORD', '')}\"
      MYSQL_ROOT_HOST: \"%\"
    ports:
      - \"8085:3306\"
    volumes:
      - emdeck-mysql:/var/lib/mysql
    networks:
      - emdeck-network
"""

def get_emr_service():
    return f"""  emr:
    build:
      context: ./emr
    container_name: emr-api
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      MYSQL_ROOT_PASSWORD: \"{os.environ.get('MYSQL_ROOT_PASSWORD', '')}\"
      RAILS_MAX_THREADS: 5
    ports:
      - \"8081:3000\"
    depends_on:
      - mysql
    networks:
      - emdeck-network
"""

def get_redis_service():
    return """  redis:
    image: redis:7.0
    ports:
      - \"8084:6379\"
    restart: always
    container_name: redis
    volumes:
      - emdeck-redis:/data
    networks:
      - emdeck-network
"""

def get_dde_service():
    return f"""  dde:
    build:
      context: ./dde
    container_name: dde-api
    environment:
      DB_HOST: mysql
      DB_PORT: 3306
      MYSQL_ROOT_PASSWORD: \"{os.environ.get('MYSQL_ROOT_PASSWORD', '')}\"
      RAILS_MAX_THREADS: 5
      REDIS_HOST: redis
      REDIS_PORT: 6379
    ports:
      - \"8082:3000\"
    depends_on:
      - mysql
    networks:
      - emdeck-network
"""

def get_emc_service():
    return """  emc:
    build:
      context: ./emc
    container_name: emc
    ports:
      - \"8080:80\"
    depends_on:
      - emr
    networks:
      - emdeck-network
"""

def get_portainer_service():
    return f"""  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: always
    ports:
      - \"8083:9000\"
    environment:
      - ADMIN_USERNAME=\"{os.environ.get('PORTAINER_ADMIN_USERNAME', '')}\"
      - ADMIN_PASSWORD=\"{os.environ.get('PORTAINER_ADMIN_PASSWORD', '')}\"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - emdeck-portainer:/data
    networks:
      - emdeck-network
"""

def get_core_service():
    return """  core:
    build:
      context: ./core
    container_name: core
    ports:
      - \"8086:80\"
    depends_on:
      - emr
    networks:
      - emdeck-network
"""

def service_available():
    """Define the services in a dictionary."""
    return {
        "mysql": get_mysql_service(),
        "emr": get_emr_service(),
        "redis": get_redis_service(),
        "dde": get_dde_service(),
        "emc": get_emc_service(),
        "portainer": get_portainer_service(),
        "core": get_core_service(),
    }

def add_service(service_name, enable_flag):
    """Add a service definition to the docker-compose file if enabled."""
    compose_file = "./docker/docker-compose.yml"
    services = service_available()

    if enable_flag.lower() == "true":
        print(f"Adding service: {service_name}")

        service_content = services.get(service_name)
        if service_content:
            # Append the service definition to the compose file
            with open(compose_file, "a") as f:
                f.write(service_content)
        else:
            print(f"Error: Service '{service_name}' not found in SERVICES dictionary.")
    else:
        print(f"Skipping service: {service_name} (disabled in configuration)")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python add_service.py <service_name> <enable_flag>")
        sys.exit(1)

    service_name = sys.argv[1]
    enable_flag = sys.argv[2]

    add_service(service_name, enable_flag)
