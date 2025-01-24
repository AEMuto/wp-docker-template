# WordPress Development Environment with Docker

This repository provides a dev environment for WordPress. We use Docker Compose to create a consistent and reproducible development environment.

## Prerequisites

- Windows 11 with WSL2 (Debian recommended)
- Docker Desktop with WSL2 backend enabled
- Visual Studio Code with Remote WSL extension
- Git

## Initial Setup

1. Clone the repository and navigate to it:
```bash
git clone <repo-name>
cd <repo-name>
```

2. Set up initial permissions for WordPress directories:
```bash
sudo chown -R www-data:www-data wordpress plugins themes uploads
sudo chmod -R 775 wordpress plugins themes uploads
```

3. Add your user to the www-data group:
```bash
sudo usermod -aG www-data $USER
```

4. **Important**: Log out of WSL completely and log back in for the group changes to take effect. You can verify your groups with:
```bash
groups  # Should show www-data in the list
```

5. Start the Docker environment:
```bash
docker compose up -d
```

6. Wait for all services to initialize. You can monitor the logs with:
```bash
docker compose logs -f
```

7. Once WordPress is running, adjust permissions for development:
```bash
sudo chown -R $USER:www-data wordpress plugins themes uploads
sudo chmod -R g+w wordpress plugins themes uploads
```

## Verification Steps

1. Check container status:
```bash
docker compose ps
```
All containers except wp-cli should show as "running". The wp-cli container should exit after completing initialization.

2. Access your sites:
- WordPress: http://localhost:8080
- phpMyAdmin: http://localhost:8081

## Understanding the Environment

The environment consists of several Docker containers:
- `wordpress`: Main WordPress installation
- `db`: MariaDB database
- `phpmyadmin`: Database management interface
- `wp-cli`: Task runner for WordPress (runs and exits)

## Common Issues and Solutions

### Permission Errors
If you see "Operation not permitted" errors when WordPress tries to write files:
1. Ensure you've completed all permission steps
2. Verify group membership with `groups`
3. Try recreating the environment with:
```bash
docker compose down -v
sudo rm -rf wordpress/* plugins/* themes/* uploads/*
# Then repeat setup steps 2-7
```

### Database Connection Issues
If WordPress can't connect to the database:
1. Wait a few moments - MariaDB takes time to initialize
2. Check database container logs:
```bash
docker compose logs db
```

### WP-CLI Container Exits
This is normal behavior - the wp-cli container is designed to run setup tasks and exit. To run WordPress CLI commands:
```bash
docker compose run --rm wp-cli wp <command>
```

## Development Workflow

1. Plugin development should be done in the `plugins` directory
2. Use VS Code's WSL extension to edit files
3. WordPress core files are in the `wordpress` directory
4. Upload files will be stored in the `uploads` directory

## Available Tools

- WordPress debugging is enabled (check `wp-content/debug.log`)
- Xdebug is configured for VS Code debugging
- phpMyAdmin for database management
- WP-CLI for WordPress management tasks

## Next Steps

1. Start developing your plugin in the `plugins` directory
2. Configure VS Code's debugging capabilities
3. Set up version control for your plugin

Remember to never commit sensitive information like passwords to version control.
