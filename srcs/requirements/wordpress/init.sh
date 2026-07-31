#!/bin/sh
set -e

DB_PASSWORD=$(cat /run/secrets/db_password)

until mysql -h mariadb -u"${MYSQL_USER}" -p"${DB_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; do
    sleep 3
done

cd /var/www/html

if [ ! -f /usr/local/bin/wp ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
    WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${DB_PASSWORD}" \
        --dbhost=mariadb:3306 \
        --allow-root

    wp core install --skip-email \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    wp user create \
        "${WP_USER}" \
        "${WP_USER_EMAIL}" \
        --role=author \
        --user_pass="${WP_USER_PASSWORD}" \
        --allow-root

    echo "WordPress installation complete!"
else
    echo "WordPress already configured, skipping setup..."
fi

mkdir -p /run/php
chown -R www-data:www-data /run/php

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm8.2 -F --nodaemonize
