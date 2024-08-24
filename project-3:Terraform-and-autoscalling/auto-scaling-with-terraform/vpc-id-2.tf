
#Method-2 : To retrive attribute value vpc-id from aws-cloud-provider by using filter with cidr-block of vpc
# ====================================================================================================
 
data "aws_vpc" "all-vpc"{
    filter {
     name = "cidr"
     values = ["172.31.0.0/16"]
    }
}


data "aws_subnet" "sub-id" {
  filter { #Apply filter using vpc-id tag and value
    name   = "vpc-id"
    values = [data.aws_vpc.all-vpc.id]
  }
  filter {   #Apply filter using subnet tag and value
    name = "tag:name" #tag : name => tag:tag-key
    values = ["sub-1"] # sub-1 => tag-value
  }
}

output "sub-id"{
    value = data.aws_subnet.sub-id.id
}
output "vpc"{
    value = data.aws_vpc.all-vpc.id
}


