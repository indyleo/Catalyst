#!/bin/env bash

sudo ufw limit 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3389/tcp
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo cp -v sunshine /etc/ufw/applications.d/sunshine
sudo ufw app update Sunshine
sudo ufw allow Sunshine

sudo ufw enable
