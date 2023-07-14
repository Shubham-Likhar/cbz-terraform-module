variable "env" {
  type = string
}

variable "appname" {
  type = string
}

variable "internal" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}


variable "listener_rule" {
    type = any  
}

variable "target_groups" {
  type = any
}

# variable "target_group_port" {
#   type = string
  
# }
# variable "tatget_group_protocol" {
#   type = string
# }

variable "subnets" {
  type = list(any)
  
}
variable "security_group" {
  type = string
  
}


variable "vpc_id" {
  type = string
  default = ""
}
