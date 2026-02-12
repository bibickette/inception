# ENGLISH VERSION
# Project presentation - `inception`
## Description

This project consists of setting up a containerized web infrastructure using Docker and Docker Compose.

It is intended to run on **Debian Bullseye**, and both the host system and the Docker images are based on this distribution to ensure consistency and stability.  
The development was carried out inside a **virtual machine**, providing a controlled and isolated environment.

The infrastructure includes a reverse proxy (NGINX), a WordPress application, and a MariaDB database, all running in separate containers.


* * *

## Languages & Technologies

**Languages**
- Bash
- Dockerfile
- YAML

**Technologies**
- Docker & Docker Compose
- NGINX
- WordPress
- MariaDB
- Linux (Debian Bullseye)


* * *
## Key Concepts

* * *
## System Environment

Host OS: Debian Bullseye  
Docker base images: Debian Bullseye
Container runtime: Docker
Orchestration: Docker Compose

* * *
## Services Architecture

The infrastructure is composed of the following services:

### 1. NGINX

Acts as a reverse proxy
Handles HTTPS connections
Uses TLS certificates

### 2. WordPress

PHP-FPM application
Serves dynamic content
Connected to the MariaDB database

### 3. MariaDB

Relational database
Stores WordPress data
Runs in its own container

Each service runs in a dedicated container and communicates through a Docker network.
* * *
## Volumes & Persistence

Persistent data is stored using Docker volumes:

WordPress files

MariaDB database data

This ensures that data is preserved even if containers are stopped or rebuilt.
* * *
## Security Considerations

No service runs as root unnecessarily

Secrets are managed using environment variables

HTTPS enforced via NGINX

Containers expose only required ports

* * *
## Project Structure
```
inception/
├── srcs/
│   ├── docker-compose.yml
│   ├── .env
│   └── requirements/
│       ├── mariadb/
│		│	├── conf/
│		│	├── tools/
│       │   └── Dockerfile
│       ├── nginx/
│		│	├── conf/
│       │   └── Dockerfile
│       └── wordpress/
│			├── conf/
│		 	├── tools/
│           └── Dockerfile
│  
└── Makefile
```
* * *
# Using `inception`
## Makefile rules
1. **first** as *default rule* : Creates the required directories for Docker volumes (`/home/phwang/data/wordpress` and `/home/phwang/data/mariadb`) if they do not already exist.  
Displays the current Docker containers, images, volumes, and networks.
2. **run** : Builds and starts the Docker infrastructure using:
`docker-compose -f srcs/docker-compose.yml up --build`
3. **clean** : Stops all running Docker containers.
4. **fclean** : runs *clean containers_clean images_clean volumes_clean networks_clean list* rules then runs `docker system prune -a`.  
Deletes the local volume directories (`/home/phwang/data`)
5. **re** : *fclean* then *first* rule
6. **containers_clean** : Removes all Docker containers.
7. **images_clean** : Removes all Docker images.
8. **volumes_clean** : Removes all Docker volumes.
9. **networks_clean** : Removes the project Docker network (`srcs_inception`).
10. **list** : Displays:  
- Running containers
- Available images
- Docker volumes
- Docker networks

* * *

## How to use `inception`

1. Clone `inception` in a folder first  : `git clone git@github.com:bibickette/inception.git`
2. Go to the `inception` folder then compile it : `cd inception && make`
3.


* * *
*Project validation date : August 26, 2025*