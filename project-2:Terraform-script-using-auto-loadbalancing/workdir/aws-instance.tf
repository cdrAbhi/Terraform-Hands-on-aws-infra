# provider "aws" {  
# 	region = var.region
# } 


#aws_instance Block
resource "aws_instance" "inst" {
	count = var.num-instance
	
	ami	= data.aws_ami.public.id
	instance_type = var.type
	key_name = aws_key_pair.key.key_name
	# availability_zone = "ap-south-1b"
	
	subnet_id = element(aws_subnet.custom-sub.*.id, count.index % length(aws_subnet.custom-sub))
	vpc_security_group_ids = [aws_security_group.custom-sg.id]
    
	associate_public_ip_address = true
	# user_data = <<-EOF
	#     #!/bin/bash
	# 	sudo apt-get update
	# 	sudo apt-get install nginx -y 
	# 	sudo sytemctl start nginx
	# 	sudo systemctl enable nginx
	# 	echo "Hi Body This is Abhishek Kumar 😎😎😎 This is ${var.my-env}">/var/www/html/index.html
    #     EOF
    user_data = file("${path.module}/user.sh")
	tags = {
        	Name = "${var.my-env}-server-${count.index+1}"
        }
    depends_on = [
		aws_key_pair.key,
		data.aws_ami.public,
		aws_security_group.custom-sg
	]
}


# aws_ec2_instance_state
# resource "aws_ec2_instance_state" "state"{
# 	count = var.num-instance
# 	instance_id = aws_instance.inst[count.index].id
# 	state	= "running"
# } 


