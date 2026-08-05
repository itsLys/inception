#!/bin/sh
set -eu

FTP_PASSWORD="$(cat /run/secrets/ftp_user_password)"

FTP_HOME="/var/www/html"

mkdir -p $FTP_HOME

mkdir -p /var/run/vsftpd/empty
chmod 755 /var/run/vsftpd
chmod 555 /var/run/vsftpd/empty

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd \
        -m \
        -d "$FTP_HOME" \
        "$FTP_USER"
fi

echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
mkdir -p "$FTP_HOME"
chown -R "$FTP_USER:$FTP_USER" "$FTP_HOME"
echo "Starting vsftpd..."
exec /usr/sbin/vsftpd /etc/vsftpd.conf
