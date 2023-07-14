variable "vpc_cidr_block" {
  type = string

}

variable "public_subnet" {
  type = list(string)

}

variable "private_subnet" {
  type = list(string)

}

variable "tags" {
  type = map(string)

}


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

variable "availability_zones" {
  type = list(any)
}

variable "port" {
  type = list(any)
}
