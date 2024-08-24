variable "region"{
    type = string
    default = "us-east-1" 
}

#vpc_security_group_id retrive detail data
variable "security_group_name"{
    type = string
    default = "default"
}

#aws_ami_id retrive detail data
variable "ami-owners"{
    type = string
    default = "099720109477"
}

variable "ami-name"{
    type = string
    default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240801"
}

variable "virtualization-type"{
    type = string
    default = "hvm"
}
variable "root-device-type"{
    type = string
    default = "ebs"
}



# aws_instance

variable "instance_type"{
    type = string
    default = "t2.micro"
}

# connection to remote
variable "c-type"{
    type = string
    default = "ssh"
}

variable "user"{
    type = string
    default = "ubuntu"
}

variable "private-key-name"{
    type = string
    default = "id_rsa"
}

#file provisioner to install and create docker image and run container
variable "script-path-local"{
    type = string
    default = "scr-docker.sh"
}
variable "script-path-remote"{
    type = string
    default = "/home/ubuntu/scr-docker.sh"
}
variable "docker-script-file-name"{
    type = string
    default = "scr-docker.sh"
}

variable "file-docker-status"{
    type = string
    default = "status.txt"
}
variable "file-container-status"{
    type = string
    default = "c-status.txt"
}




