#!/bin/sh
set -e

DB_ROOT_PASSWORD="$(cat /run/secrets/db_root_password)"
DB_PASSWORD="$(cat /run/secrets/db_password)"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/lib/mysql

# Initialize the data directory only once.
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."

    mariadb-install-db \
        --user=mysql \
        --datadir=/var/lib/mysql \
        >/dev/null

    echo "Starting temporary MariaDB server..."

    mysqld \
        --user=mysql \
        --skip-networking \
        --socket=/run/mysqld/mysqld.sock &

    pid="$!"

    # Wait until the server accepts connections.
    until mariadb-admin \
        --socket=/run/mysqld/mysqld.sock \
        ping >/dev/null 2>&1
    do
        sleep 1
    done

    echo "Creating database and users..."

    mariadb --socket=/run/mysqld/mysqld.sock <<EOF
ALTER USER 'root'@'localhost'
IDENTIFIED BY '${DB_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%'
IDENTIFIED BY '${DB_PASSWORD}';

GRANT ALL PRIVILEGES
ON \`${MYSQL_DATABASE}\`.*
TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

    echo "Stopping temporary server..."

    mariadb-admin \
        --socket=/run/mysqld/mysqld.sock \
        -u root \
        -p"${DB_ROOT_PASSWORD}" \
        shutdown

    wait "$pid"
fi

echo "Starting MariaDB..."

exec mysqld \
    --user=mysql \
    --console
