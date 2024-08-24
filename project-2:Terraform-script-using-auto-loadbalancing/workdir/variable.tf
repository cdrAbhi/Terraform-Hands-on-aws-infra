variable "image_name" {
  type    = string
  default = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20240701.1"
}

variable "region" {
  type = string
}

variable "my-env" {
  type = string
}

variable "ports" {
  type = list(number)
}

variable "num-instance" {
  type = number
}

variable "type" {
  type = string
}

# New variable for ALB configuration
variable "alb_name" {
  type    = string
  default = "my-alb"
}

variable "alb_access_logs_bucket" {
  type    = string
}

variable "alb_access_logs_prefix" {
  type    = string

}

variable "alb_idle_timeout" {
  type    = number
  default = 400
}

variable "alb_enable_http2" {
  type    = bool
  default = true
}

variable "alb_enable_deletion_protection" {
  type    = bool
  default = false
}

variable "alb_drop_invalid_header_fields" {
  type    = bool
  default = true
}

variable "alb_target_group_port" {
  type    = number
  default = 80
}

variable "alb_target_group_protocol" {
  type    = string
  default = "HTTP"
}
