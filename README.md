# eMDeck

## **eMDeck** is a highly configurable deployment tool designed for the **eMastercard system**, enabling seamless setup and management of healthcare-related software components. This tool is built with Python and Docker, ensuring flexibility, scalability, and reliability for offline and online deployments.

## Features

1. **Highly Configurable Deployment**:

   - Manage services (e.g., EMR-API, DDE, Frontend) via a centralized `.env` file.
   - Enable or disable specific services during deployment.

2. **Seamless Database Integration**:

   - Supports separate MySQL databases for DDE and EMR-API.
   - Automatic initialization of databases and users.

3. **Docker-Powered Architecture**:

   - Ensures all services are containerized for consistent deployment across environments.

4. **Configuration Management**:

   - Supports copying custom configurations (`database.yml`, `ait.yml`, etc.) for DDE and EMR-API.
   - Automatically excludes `*.example` files to prevent accidental overwrites.

5. **Bash Utility Scripts**:

   - Includes tools for managing backups, restores, and migrations.

6. **Offline and Online Deployment**:
   - Capable of pulling updates from GitHub when online or using pre-built images offline.

---

## Prerequisites

- Ubuntu 20.04 or later
- Python 3.2 or later
- Docker and Docker Compose

---

## Setup Instructions

### 1. Clone the Repository

```bash
# Clone this repository
git clone https://github.com/your-org/emdeck.git
cd emdeck
```

### 2. Configure the Environment

Edit the `.env` file to match your deployment needs:

#### Example `.env` File

```ini
# Enable/Disable Services
ENABLE_EMR_API=true
ENABLE_DDE=true
ENABLE_FRONTEND=false
ENABLE_MYSQL=true
ENABLE_REDIS=true
ENABLE_NGINX=true

# Docker Network Name
DOCKER_NETWORK=emastercard-network

# GitHub Repositories
EMR_API_REPO=https://github.com/HIS-Malawi/emr-api.git
DDE_REPO=https://github.com/HIS-Malawi/dde.git
FRONTEND_REPO=https://github.com/HIS-Malawi/emastercard-frontend.git

# MySQL Configuration (Shared)
MYSQL_ROOT_PASSWORD=root_password

# EMR Database Configuration
EMR_DATABASE=emr_db
EMR_DB_USER=emr_user
EMR_DB_PASSWORD=emr_password

# DDE Database Configuration
DDE_DATABASE=dde_db
DDE_DB_USER=dde_user
DDE_DB_PASSWORD=dde_password

# Backend API Configuration
EMR_API_IMAGE_TAG=latest
DDE_IMAGE_TAG=latest

# Frontend Configuration
FRONTEND_IMAGE_TAG=latest
```

### 3. Deploy the System

Run the Python deployment script:

```bash
python3 deployment.py
```

### 4. Post-Deployment Tasks

- Use the included bash scripts in the `scripts/` directory to manage databases, run migrations, and perform backups/restores:
  ```bash
  ./scripts/backup.sh
  ./scripts/restore.sh
  ./scripts/migrate.sh
  ```

---

## Managing Configurations

### DDE and EMR-API Configurations

Place custom configuration files (e.g., `database.yml`, `ait.yml`) in the respective `config/` directories:

- **DDE Configurations**: `docker/dde/config/`
- **EMR-API Configurations**: `docker/emr-api/config/`

#### Rules:

- All configuration files without the `.example` extension will be copied into the container.
- Example files (`*.example`) are ignored to prevent accidental overwrites.

### Example Directory Structure:

```
project-root/
├── docker/
│   ├── dde/
│   │   ├── config/
│   │   │   ├── database.yml
│   │   │   ├── ait.yml
│   │   │   └── database.yml.example
│   ├── emr-api/
│   │   ├── config/
│   │   │   ├── database.yml
│   │   │   ├── ait.yml
│   │   │   └── database.yml.example
```

---

## Docker Compose Configuration

The deployment uses Docker Compose to manage services. Adjustments can be made in the `docker/docker-compose.yml` file to customize the deployment further.

---

## Support Team Notes

1. **Database Management**:

   - Use the `backup.sh` and `restore.sh` scripts for database backups and restores.

2. **Service Logs**:

   - Access logs with:
     ```bash
     docker-compose logs -f
     ```

3. **Rebuilding Services**:
   - Rebuild individual services if necessary:
     ```bash
     docker-compose build <service-name>
     ```

---

## DevOps Team Notes

1. **Scaling Services**:

   - Adjust replicas in `docker-compose.yml` to scale services.

2. **Updating Images**:

   - Update to the latest GitHub tags by running the deployment script:
     ```bash
     python3 deployment.py
     ```

3. **Offline Deployment**:
   - Use pre-built images stored in your Docker registry.

---

## Contributing

This project is open for contributions from the **HIS-Malawi** team and the broader healthcare community. Submit issues or pull requests via the [GitHub repository](https://github.com/your-org/emdeck).
