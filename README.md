🇫🇷 Version française disponible [ici](README_FR.md)
* * *
# Project presentation - `inception`
## Description

This project consists of setting up a **containerized web infrastructure** using **Docker** and **Docker Compose**.

It is intended to run on **Debian Bullseye**, and both the host system and the **Docker images** are based on this distribution to ensure consistency and stability.  
The development was carried out inside a **virtual machine**, providing a controlled and isolated environment.

The infrastructure includes a reverse proxy (**NGINX**), a **WordPress** application, and a **MariaDB** database, all running in separate containers.


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
- Docker images and containers
- Docker Compose orchestration
- Service isolation
- Volumes and data persistence
- Environment variables
- Networking between containers
- HTTPS configuration
- Infrastructure as code

* * *
## System Environment

- **Host OS** : Debian Bullseye  
- **Docker base images** : Debian Bullseye
- **Container runtime** : Docker
- **Orchestration** : Docker Compose

* * *
## Services Architecture

The infrastructure is composed of the following services:

**1. NGINX**
- Acts as a reverse proxy
- Handles HTTPS connections
- Uses TLS certificates

**2. WordPress**
- PHP-FPM application
- Serves dynamic content
- Connected to the MariaDB database

**3. MariaDB**
- Relational database
- Stores WordPress data
- Runs in its own container

Each service runs in a dedicated container and communicates through a Docker network.
* * *
## Volumes & Persistence

Persistent data is stored using **Docker volumes**:
- WordPress files
- MariaDB database data

This ensures that data is preserved even if containers are stopped or rebuilt.
* * *
## Security Considerations

- No service runs as root unnecessarily
- Secrets are managed using environment variables
- HTTPS enforced via NGINX
- Containers expose only required ports

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
## Environment Variables

The project uses a `.env` file located in `srcs/` to configure database credentials and WordPress settings.

⚠️ The real `.env` file **should not** be committed.

Below is a generic example for demonstration purposes:
```
# ==========================
# MariaDB Configuration
# ==========================

SQL_DATABASE=wordpress_db
SQL_USER=wordpress_user
SQL_ROOT_PASSWORD=your_root_password
SQL_PASSWORD=your_user_password
SQL_HOST=mariadb

# ==========================
# WordPress Configuration
# ==========================

WP_URL=yourdomain.local
WP_TITLE=My WordPress Site

WP_ADMIN_USER=admin_user
WP_ADMIN_PASSWORD=secure_admin_password
WP_ADMIN_EMAIL=admin@example.com

WP_AUTHOR_USER=author_user
WP_AUTHOR_PASS=secure_author_password
WP_AUTHOR_EMAIL=author@example.com
```

* * *
## Database Access

List of command to manually access the **MariaDB container** and **inspect the database** :

1. Enter the MariaDB container : `docker exec -it <mariadb_container_name> bash`
2. Connect to **MariaDB** : `mysql -u root -p`
3. Enter the `SQL_ROOT_PASSWORD` defined in your `.env` file.
3. Show **available** **databases** : `SHOW DATABASES;`, you should see :  
```
wordpress
information_schema
mysql
performance_schema
```
4. Use the **WordPress** **database** : `USE wordpress;`
5. List tables `SHOW TABLES;`
6. **Display** **WordPress** users `SELECT * FROM wp_users;`, you should see the admin and author users defined in your `.env`
7. **Exit** **MariaDB** : `exit;`
8. Then **exit the container** : `exit`

* * *
# Using `inception`
## Makefile rules
1. **first** as *default rule* : creates the required directories for Docker volumes (`/home/$USER/data/wordpress` and `/home/$USER/data/mariadb`) if they do not already exist.  
Displays the current Docker containers, images, volumes, and networks.
2. **run** : builds and starts the Docker infrastructure using:
`docker-compose -f srcs/docker-compose.yml up --build`
3. **clean** : stops all running Docker containers.
4. **fclean** : runs *clean containers_clean images_clean volumes_clean networks_clean list* rules then runs `docker system prune -a`.  
Deletes the local volume directories (`/home/$USER/data`)
5. **re** : *fclean* then *first* rule
6. **containers_clean** : removes all Docker containers.
7. **images_clean** : removes all Docker images.
8. **volumes_clean** : removes all Docker volumes.
9. **networks_clean** : removes the project Docker network (`srcs_inception`).
10. **list** : displays: running containers, available images, docker volumes, docker networks

* * *

## How to use `inception`

1. Clone `inception` in a folder first  : `git clone git@github.com:bibickette/inception.git`
2. Go to the `inception` folder then create an environment file (`.env`) (*see [environment variables](#environment-variables) for more details*)
3. Build and start the infrastructure with `make`, this will : **create** the required local **volume** directories (`/home/$USER/data`); **build docker images** then **start all containers**
4. Access the Services :  
- **WordPress** : navigate `https://localhost`
- **MariaDB** : accessible internally through the **Docker network** (mariadb service name) (*see [database access](#database-access) for more details*)


* * *
*Project validation date : August 26, 2025*