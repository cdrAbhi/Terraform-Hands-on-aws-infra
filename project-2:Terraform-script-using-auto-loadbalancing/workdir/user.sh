#!/bin/bash
sudo apt-get update
sudo apt-get install nginx -y
echo "Hi Body This is Abhishek Kumar 😎😎😎 This is ${var.my-env}" >/var/www/html/index.nginx-debian.html
