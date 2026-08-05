FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    vsftpd \
    vim

COPY vsftpd.conf /etc/vsftpd.conf
COPY init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

ENTRYPOINT [ "init.sh" ]
