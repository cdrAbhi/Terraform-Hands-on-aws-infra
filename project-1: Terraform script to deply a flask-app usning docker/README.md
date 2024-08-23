Here's the same content formatted as Markdown code for your `README.md` file on GitHub:

```markdown
# Deploy Flask App on AWS EC2 Using Docker and Terraform

This guide walks you through deploying a Flask application on an AWS EC2 instance using Docker for containerization and Terraform for infrastructure management.

## Step 1: Install Terraform

Install Terraform on your machine by following the official [Terraform installation guide](https://learn.hashicorp.com/tutorials/terraform/install-cli).

## Step 2: Write a Dockerfile for the Flask App

### Project Structure
    ```
    flask_app/
    │
    ├── templates/
    │   └── index.html
    ├── app.py
    └── Dockerfile
    ```
    source github-link : https://github.com/cdrAbhi/flask-app
```

### Dockerfile
In the `flask_app/` directory, create a `Dockerfile` to containerize your Flask app:

```Dockerfile
# Use an official Python runtime as a parent image
FROM python:3.8-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV NAME World

# Run app.py when the container launches
CMD ["python", "app.py"]
```

## Step 3: Create `main.tf` File for Terraform Configuration

### Step 3.1: Write Code for Provider Configuration

In the `main.tf` file, configure the AWS provider:

```hcl
provider "aws" {
  region = var.region
}
```

### Step 3.2: Retrieve AWS Data Using `data` Block

Retrieve the necessary AWS data, such as the security group ID and AMI ID:

```hcl
data "aws_security_group" "sg-id" {
  filter {
    name   = "group-name"
    values = [var.security_group_name]
  }
}

data "aws_ami" "ami_id" {
  most_recent = true
  owners      = [var.ami-owners]
  filter {
    name   = "name"
    values = [var.ami-name]
  }
  filter {
    name   = "virtualization-type"
    values = [var.virtualization-type]
  }
  filter {
    name   = "root-device-type"
    values = [var.root-device-type]
  }
}
```

### Step 3.3: Write Script to Install Docker and Deploy Flask App

Create a script `scr-docker.sh` to install Docker, clone the Flask app repository, build the Docker image, and run the container:

```bash
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
```

### Step 3.4: Configure AWS EC2 Instance

Use the `aws_instance` resource to configure the EC2 instance:

```hcl
resource "aws_instance" "inst" {
  ami                    = data.aws_ami.ami_id.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg-id.id]
  key_name               = aws_key_pair.my_key.key_name
  associate_public_ip_address = true

  connection {
    type        = var.c-type
    user        = var.user
    private_key = file("${path.module}/${var.private-key-name}")
    host        = self.public_ip 
  }

  provisioner "file" {
    source      = var.script-path-local
    destination = var.script-path-remote
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu",
      "sudo chmod 400 ${var.docker-script-file-name}",
      "sudo sh ${var.docker-script-file-name}"
    ]
  }

  depends_on = [aws_key_pair.my_key]
}
```

### Step 3.5: Create `variable.tf` File and Define Variables

Define variables for your configuration in the `variable.tf` file:

```hcl
variable "region" {
    type    = string
    default = "us-east-1" 
}

variable "security_group_name" {
    type    = string
    default = "default"
}

variable "ami-owners" {
    type    = string
    default = "099720109477"
}

variable "ami-name" {
    type    = string
    default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240801"
}

variable "virtualization-type" {
    type    = string
    default = "hvm"
}

variable "root-device-type" {
    type    = string
    default = "ebs"
}

variable "instance_type" {
    type    = string
    default = "t2.micro"
}

variable "c-type" {
    type    = string
    default = "ssh"
}

variable "user" {
    type    = string
    default = "ubuntu"
}

variable "private-key-name" {
    type    = string
    default = "id_rsa"
}

variable "script-path-local" {
    type    = string
    default = "scr-docker.sh"
}

variable "script-path-remote" {
    type    = string
    default = "/home/ubuntu/scr-docker.sh"
}

variable "docker-script-file-name" {
    type    = string
    default = "scr-docker.sh"
}

variable "file-docker-status" {
    type    = string
    default = "status.txt"
}

variable "file-container-status" {
    type    = string
    default = "c-status.txt"
}
```

## Step 4: Create `key.tf` to Manage SSH Key Pair

### Step 4.1: Generate SSH Key Pair on Your Machine

Generate an SSH key pair with the following command:

```bash
ssh-keygen -t rsa
```

This will create two files:
- `id_rsa` (private key)
- `id_rsa.pub` (public key)

### Step 4.2: Configure Terraform to Use the SSH Key

Use the `aws_key_pair` resource to manage the key:

```hcl
resource "aws_key_pair" "my_key" {
    key_name   = "test-web"
    public_key = file("${path.module}/id_rsa.pub")
}
```

## Step 5: Create Files to Store Docker Status

Create two files on the remote server to store Docker status:
1. **`status.txt`:** Stores Docker status.
2. **`c-status.txt`:** Stores Docker container list.

These files will be generated and updated by the `scr-docker.sh` script as described in Step 3.3.

---

Following this guide will help you successfully deploy a Flask application on AWS EC2 using Docker, all managed with Terraform.
```

This Markdown code will render nicely formatted content on your GitHub `README.md` file, making it easy for others to follow the guide.
