provider "aws" {
  region = var.region
}

#data soure technique to retrive data from aws cloud 

data "aws_security_group" "sg-id" {
  filter {
    name   = "group-name"
    values = ["${var.security_group_name}"]

  }
}

data "aws_ami" "ami_id" {
  most_recent = true
  owners      = ["${var.ami-owners}"]
  filter {
    name   = "name"
    values = ["${var.ami-name}"]
  }
  filter {
    name   = "virtualization-type"
    values = ["${var.virtualization-type}"]
  }
  filter {
    name   = "root-device-type"
    values = ["${var.root-device-type}"]
  }
}

#aws_instance resource configuraiton
resource "aws_instance" "inst" {
  ami                    = data.aws_ami.ami_id.id
  instance_type                   = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.sg-id.id]
  key_name = aws_key_pair.my_key.key_name
  associate_public_ip_address = true

  connection {
    type = var.c-type #Connection type
    user = var.user #your remote-server user name
    private_key = file("${path.module}/${var.private-key-name}") #private key path on ur local server
    host = self.public_ip 
  }

  #Let'see how to use file(copy script file from local to remote) and remote-exec(execute script) proviosners

  provisioner "file"{
    source = var.script-path-local #ur script-path to install and create docker image on ur local server
    destination = var.script-path-remote #destination on remote server
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu",
      "sudo chmod 400 ${var.docker-script-file-name}",
      "sudo sh ${var.docker-script-file-name}"
    ]
  }

  #meaning : Before creating aws_instance resources first create aws_key_pair   .
  depends_on = [
    aws_key_pair.my_key  
  ]

}

#null_resource : provioner task execution is not depend on provisioner component changing like aws_instance.
resource "null_resource" "script_update" {
  depends_on = [aws_instance.inst]         #meaning : Before creating null_resources first create ec2 instace .
 
  connection {
    type = var.c-type #Connection type
    user = var.user #your remote-server user name
    private_key = file("${path.module}/${var.private-key-name}") #private key path on ur local server
    host = aws_instance.inst.public_ip #this is you instance public-ip
  }

  # use to run single command
  # provisioner "local-exec" {
  #   command = "scp -o StrictHostKeyChecking=no -i id_rsa ubuntu@${aws_instance.inst.public_ip}:/home/ubuntu/status.txt status.txt"
  # }

  # use to run multiple command 
  provisioner "local-exec" {
    #using this command to run more than one command at once 
    command = <<EOT
        scp -o StrictHostKeyChecking=no -i id_rsa ubuntu@${aws_instance.inst.public_ip}:/home/ubuntu/${var.file-docker-status} ${var.file-docker-status}  &&
        scp -o StrictHostKeyChecking=no -i id_rsa ubuntu@${aws_instance.inst.public_ip}:/home/ubuntu/${var.file-container-status} ${var.file-container-status}
      EOT
}

  #alwas_run ==> always run whenever timestamp() reutrun diff value of time
  triggers = {
    always_run = "${timestamp()}"          
  }
}

