FROM alpine:3.20

RUN apk add --no-cache openssh openssh-sftp-server rsync \
  && ssh-keygen -A \
  && adduser -D -s /bin/sh shelltut \
  && passwd -u shelltut \
  && mkdir -p /home/shelltut/.ssh /data/incoming \
  && chown -R shelltut:shelltut /home/shelltut /data

COPY sshd_config /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
