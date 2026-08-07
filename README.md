_This project has been created as part of the 42 curriculum by ihajji._

# Inception

## Description

**Inception** is a system administration project focused on building a secure, containerized web infrastructure using Docker.

The infrastructure is composed of multiple isolated services communicating through a dedicated Docker network:

- NGINX (TLS reverse proxy)
- WordPress (PHP-FPM)
- MariaDB
- Redis _(bonus)_
- Adminer _(bonus)_
- FTP Server _(bonus)_
- Static Website _(bonus)_
- Portainer _(bonus)_

The objective is to understand containerization, networking, storage, service isolation, and secure configuration without relying on pre-built images.

### Design Choices

- Custom Docker images built from Dockerfiles (debian as the base image).
- One process per container.
- User-defined Docker network for service communication.
- Docker secrets for sensitive credentials.
- Persistent storage using Docker volumes.
- TLS termination handled by NGINX.

### Docker Concepts

| Topic                                | Choice                                                                                                                                                                                                                 |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Virtual Machines vs Docker**       | Docker containers share the host kernel, making them significantly lighter and faster than virtual machines while still providing process isolation.                                                                   |
| **Secrets vs Environment Variables** | Secrets are used for passwords because they are mounted as files and are not exposed through container environments, unlike environment variables.                                                                     |
| **Docker Network vs Host Network**   | A dedicated bridge network isolates services while allowing secure inter-container communication. Host networking removes this isolation and is unnecessary for this project.                                          |
| **Docker Volumes vs Bind Mounts**    | Docker volumes provide persistent data independent of container lifecycles. In this project, local host directories are exposed through Docker volumes using the local driver for persistence required by the subject. |

---

## Project Structure

```text
.
├── Makefile
├── README.md
├── secrets/
└── srcs/
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        ├── wordpress/
        └── bonus/
```

---

## Instructions

### Requirements

- Docker
- Docker Compose

### Build and Start

```bash
make
```

### Stop

```bash
make down
```

### Clean Containers and Volumes

```bash
make fclean
```

The infrastructure exposes:

- **HTTPS:** `https://ihajji.42.fr`
- **FTP:** `21`
- **Passive FTP:** `50000-50099`

---

## Resources

### References

- https://docs.docker.com/
- https://docs.docker.com/compose/
- https://nginx.org/en/docs/
- https://mariadb.com/kb/
- https://developer.wordpress.org/
- https://redis.io/docs/
- https://security.appspot.com/vsftpd.html

### AI Usage

AI tools were used as learning assistants throughout the project.

- **Claude** was primarily used as a reviewer and mentor to explain Docker concepts, help debug configuration issues, validate design decisions, and suggest topics for further research. All Dockerfiles, initialization scripts, and configuration files were written manually.
- **ChatGPT** was used for quick technical questions, concise explanations, text generation (README.md), and reference information.

All implementation decisions and final code were authored and validated by the project author.
