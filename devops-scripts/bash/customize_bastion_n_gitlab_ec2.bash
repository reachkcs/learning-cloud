#!/bin/bash

# DevOps related
useradd --create-home --comment "Nominis DevOps" --shell /bin/bash --base-dir /home devops
chmod 700 /home/devops/.ssh
chown -R devops:devops /home/devops/.ssh


# Python related
dnf install python3-pip -y
pip3 install boto3
pip3 install colorama
pip3 install prettytable
pip3 install slack_sdk
pip3 install requests

# Crontab related
dnf install cronie
systemctl enable crond
systemctl start crond
crontab --version
systemctl status crond

