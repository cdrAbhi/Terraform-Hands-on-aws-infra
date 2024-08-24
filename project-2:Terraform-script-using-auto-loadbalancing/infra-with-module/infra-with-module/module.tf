provider "aws" {
  region = "us-east-1"
}

locals {
  environments = {
    web = {
      ports        = [22,80,8080]
      num-instance = 2
      type         = "t2.micro"

    }
    # dev = {
    #   ports        = [22,80,8080,443]
    #   num-instance = 1
    #   type         = "t2.micro"

    # }


  }


}





module "infra" {
  for_each = local.environments
  source   = "../workdir"
  #provider
  region = "us-east-1"
  #env
  my-env = each.key

  #Security group detail
  ports = each.value.ports
  
  #instance detail
  num-instance = each.value.num-instance
  type         = each.value.type
  #ALB
  alb_name               = "${each.key}-ALB"
  alb_access_logs_bucket = "my-alb-logs-bucket-${each.key}"
  alb_access_logs_prefix = "alb_logs"

}




