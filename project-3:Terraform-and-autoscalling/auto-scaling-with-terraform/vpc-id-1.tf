provider "aws"{

   region = "ap-south-1"

}

#Method-1 : To retrive attribute value from aws-cloud-provider
 
# data "aws_vpc" "default-vpc"{
# 	filter {
# 	  name = "tag:Name"
#      values = ["default"]

# 	}

# }


# output "vpc_id-1"{
# 	value = data.aws_vpc.default-vpc.id
# }





