#!/bin/bash
sudo apt-get update
sudo apt-get install docker.io -y 
sudo usermod -aG docker $USER
sudo service docker status >/home/ubuntu/status.txt
sudo git clone https://github.com/cdrAbhi/flask-app.git
cd flask-app
sudo docker image build -t flask-app .
sudo docker container run -d --name flask-web -p 5000:5000 flask-app
sudo docker container ls -a >/home/ubuntu/c-status.txt
