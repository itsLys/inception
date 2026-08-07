# User Documentation

## Overview

This project deploys a complete web infrastructure using Docker Compose.

### Core Services

| Service | Purpose |
|---------|---------|
| NGINX | HTTPS reverse proxy |
| WordPress | Website and CMS |
| MariaDB | WordPress database |

### Bonus Services

| Service | Purpose |
|---------|---------|
| Redis | WordPress object cache |
| Adminer | Database management interface |
| FTP Server | File transfer to the WordPress volume |
| Static Site | Additional website |
| Portainer | Docker container management |

---

# Starting the Project

Build and start the infrastructure:

```bash
make
```

Start existing containers:

```bash
docker compose -f srcs/docker-compose.yml up -d
```

---

# Stopping the Project

Stop all services:

```bash
make down
```

or

```bash
docker compose -f srcs/docker-compose.yml down
```

To remove containers, networks, and volumes:

```bash
make fclean
```

---

# Accessing the Services

## Website

Open:

```
https://<DOMAIN_NAME>
```

The domain name must resolve to the machine running the project.

---

## WordPress Administration

```
https://<DOMAIN_NAME>/wp-admin
```

Log in using the administrator account configured during initialization.

---

## Adminer (Bonus)

Access through the URL configured by the NGINX reverse proxy.

Use:

- Database: MariaDB
- Server: `mariadb`
- Username: WordPress database user
- Password: Database password

---

## Portainer (Bonus)

Open the Portainer web interface and complete the initial administrator setup on first launch.

---

## FTP (Bonus)

Connect using any FTP client.

- Host: `<DOMAIN_NAME>`
- Port: `21`
- Passive mode: Enabled

---

# Credentials

Sensitive credentials are stored in the `secrets/` directory.

| File | Description |
|------|-------------|
| `db_root_password.txt` | MariaDB root password |
| `db_password.txt` | WordPress database user password |
| `wp_admin_password.txt` | WordPress administrator password |
| `wp_user_password.txt` | Default WordPress user password |
| `ftp_user_password.txt` | FTP user password |

Other configuration values (domain name, usernames, etc.) are defined in the project's `.env` file.

---

# Checking Service Status

List running containers:

```bash
docker ps
```

View all containers:

```bash
docker ps -a
```

Check logs:

```bash
docker compose -f srcs/docker-compose.yml logs
```

View logs for a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs <service>
```

Example:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
```

---

# Verifying the Deployment

A successful deployment should satisfy the following:

- All containers are running (`docker ps`).
- The website is accessible over HTTPS.
- WordPress loads correctly.
- Login to `/wp-admin` succeeds.
- Redis is enabled (bonus).
- Adminer connects to MariaDB (bonus).
- FTP login succeeds (bonus).
- Portainer displays the running containers (bonus).

If a service fails to start, inspect its logs first to identify the cause.