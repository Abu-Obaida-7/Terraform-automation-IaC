#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

echo "<h1>Welcome to Nginx Web Server</h1>" | sudo tee /var/www/html/index.html
