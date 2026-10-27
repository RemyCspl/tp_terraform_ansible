# Image « cible » : un mini-serveur Ubuntu 24.04 administrable par Ansible.
# - systemd tourne en PID 1 (comme sur une vraie VM) : on pourra gérer des services ;
# - un serveur SSH écoute sur le port 22 ;
# - l'utilisateur « ansible » se connecte avec VOTRE clé publique et a sudo sans mot de passe ;
# - python3 est présent : Ansible en a besoin sur la machine cible.
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
      systemd systemd-sysv openssh-server python3 sudo \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ansible \
 && echo "ansible ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ansible \
 && chmod 0440 /etc/sudoers.d/ansible \
 && mkdir -p /home/ansible/.ssh

COPY authorized_keys /home/ansible/.ssh/authorized_keys

RUN chown -R ansible:ansible /home/ansible/.ssh \
 && chmod 700 /home/ansible/.ssh \
 && chmod 600 /home/ansible/.ssh/authorized_keys

EXPOSE 22
# Signal d'arrêt propre de systemd (sinon « docker stop » attend 10 s puis tue le conteneur)
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]
