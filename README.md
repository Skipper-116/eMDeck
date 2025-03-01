# eMDeck

**eMDeck** is a highly configurable deployment tool designed for the **eMastercard system**, enabling seamless setup and management of healthcare-related software components. This tool is built with Python and Docker, ensuring flexibility, scalability, and reliability for offline and online deployments.

## Features

1. **Highly Configurable Deployment**:

   - Manage services (e.g., EMR, DDE, EMC, HIS CORE, MySQL, Redis, Portainer) via a centralized `config/emdeck.conf` file.
   - Enable or disable specific services during deployment.

2. **Seamless Database Integration**:

   - Supports separate MySQL databases for DDE and EMR.
   - Automatic initialization of databases and users.

3. **Docker-Powered Architecture**:

   - Ensures all services are containerized for consistent deployment across environments.

4. **Configuration Management**:

   - Supports copying custom configurations (`database.yml`, `ait.yml`, etc.) for DDE and EMR.
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
- dotenv Python package

---

## Setup Instructions

### 1. Clone the Repository

```bash
# Clone this repository
git clone https://github.com/Skipper-116/eMDeck.git
cd emdeck
```

### 2. Deploy the System

Setup the python environment by running the following command:

```bash
python3 -m venv emdeck_venv
```

Activate the python environment by running the following command:

```bash
source emdeck_venv/bin/activate
```

Install the required python packages by running the following command:

```bash
pip3 install -r requirements.txt
```

Run the deployment script:

```bash
./scripts/start.sh
```

### 3. Post-Deployment Tasks

- Use the included bash scripts in the `scripts/` directory to manage databases, run migrations, and perform backups/restores:
  ```bash
  ./scripts/backup.sh
  ./scripts/restore.sh
  ./scripts/migrate.sh
  ```

---

## Managing Configurations

### DDE and EMR Configurations

Place custom configuration files (e.g., `database.yml`, `ait.yml`) in the respective `config/` directories:

- **DDE Configurations**: `docker/dde/config/`
- **EMR Configurations**: `docker/emr/config/`
- **EMR-Emc Configurations**: `docker/emc/config/`

#### Rules:

- All configuration files without the `.example` extension will be copied into the container.
- Example files (`*.example`) are ignored to prevent accidental overwrites.

### Example Directory Structure:

```
eMDeck/
├── config/
│   ├── emdeck.conf.example
│   ├── version.conf
├── docker/
│   ├── docker-compose.yml
│   ├── mysql/
│   │   ├── init.sql
│   ├── emr/
│   │   ├── Dockerfile
│   │   ├── config/
│   │   │   ├── database.yml.example
│   │   │   ├── ait.yml.example
│   ├── dde/
│   │   ├── Dockerfile
│   │   ├── config/
│   │   │   ├── database.yml.example
│   │   │   ├── ait.yml.example
│   ├── nginx/
│   │   ├── Dockerfile
│   │   ├── default.conf
│   ├── emc/
│   │   ├── Dockerfile
├── scripts/
│   ├── add_service.py
│   ├── backup.sh
│   ├── clean.sh
│   ├── migrate.sh
│   ├── restore.sh
│   ├── remove.sh
│   ├── setup.sh
│   ├── start.sh
├── deployment.py
├── .gitignore
├── main.py
├── README.md
├── requirements.txt
├── SECURITY.md
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
     ./scripts/start.sh
     ```

3. **Offline Deployment**:
   - Use pre-built images stored in your Docker registry.

---

## Contributing

This project is open for contributions from the **HIS-Malawi** team and the broader healthcare community. Submit issues or pull requests via the [GitHub repository](https://github.com/Skipper-116/eMDeck.git).
