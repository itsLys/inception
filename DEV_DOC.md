# Developer Documentation

## Overview

This project is a Docker Compose-based infrastructure composed of multiple custom-built services. Each service is built from its own Dockerfile and communicates over a dedicated Docker network.

---

# Prerequisites

Before building the project, install:

- Docker
- Docker Compose
- GNU Make

The project should be executed on a Linux environment.

---

# Initial Setup

## 1. Clone the Repository

```bash
git clone <repository-url>
cd inception
```

## 2. Create the Required Directories

Persistent data is stored outside the containers.

```bash
mkdir -p \
    /home/$USER/data/mysql \
    /home/$USER/data/wordpress \
    /home/$USER/data/portainer
```

## 3. Configure Environment Variables

Create a `.env` file in `srcs/` containing the required configuration values, such as:

- `DOMAIN_NAME`
- `LOGIN`
- MariaDB settings
- WordPress usernames
- FTP username

## 4. Configure Secrets

Populate the files inside the `secrets/` directory:

```text
secrets/
├── db_root_password.txt
├── db_password.txt
├── wp_admin_password.txt
├── wp_user_password.txt
└── ftp_user_password.txt
```

These files are mounted into containers as Docker secrets.

---

# Building the Project

Build all images and start the infrastructure:

```bash
make
```

The Makefile invokes Docker Compose to build every service and create the required network and volumes.

---

# Managing the Project

Start existing containers:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

Rebuild everything:

```bash
docker compose -f srcs/docker-compose.yml up --build -d
```

Rebuild a single service:

```bash
docker compose -f srcs/docker-compose.yml up --build -d <service>
```

Restart a service:

```bash
docker compose -f srcs/docker-compose.yml restart <service>
```

Stop the infrastructure:

```bash
make down
```

Remove containers, networks, and volumes:

```bash
make fclean
```

---

# Useful Docker Commands

View running containers:

```bash
docker ps
```

View logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

Follow logs for one service:

```bash
docker compose -f srcs/docker-compose.yml logs -f <service>
```

Open a shell inside a container:

```bash
docker exec -it <container> sh
```

List Docker volumes:

```bash
docker volume ls
```

Inspect the Docker network:

```bash
docker network inspect inception
```

---

# Data Persistence

Project data is stored in Docker volumes backed by host directories:

| Volume | Host Directory | Contents |
|--------|----------------|----------|
| `db_data` | `/home/$LOGIN/data/mysql` | MariaDB database files |
| `wp_data` | `/home/$LOGIN/data/wordpress` | WordPress installation and uploads |
| `portainer_data` | `/home/$LOGIN/data/portainer` | Portainer data |

Because the data resides outside the containers, it remains available after containers are recreated.

---

# Project Structure

```text
.
├── Makefile
├── secrets/
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        ├── wordpress/
        └── bonus/
```

Each service directory contains its own Dockerfile and any initialization scripts or configuration files required during container startup.