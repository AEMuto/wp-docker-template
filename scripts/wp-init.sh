#!/bin/bash

# Wait for WordPress files to be present
while [ ! -f /var/www/html/wp-settings.php ]
do
    echo "Waiting for WordPress files..."
    sleep 1
done

# Database connection check
wait_for_db() {
    echo "Waiting for database connection..."
    while ! mysqladmin ping -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" --silent; do
        echo "Database is not ready... waiting"
        sleep 1
    done
    echo "Database is ready!"
}

wait_for_db

# Only install if not already installed
if ! $(wp core is-installed --path=/var/www/html --allow-root); then
    wp core install \
        --path=/var/www/html \
        --url=http://localhost:8080 \
        --title="WordPress Dev" \
        --admin_user=admin \
        --admin_password=admin \
        --admin_email=admin@example.com \
        --skip-email \
        --allow-root
    echo "WordPress installed successfully!"
fi
