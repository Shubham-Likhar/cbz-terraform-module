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
    default = {}

}
variable "env" {
    type = string
  
}
variable "appname" {
    type = string
  
}
variable "availability_zones" {
  type = list(string) #required
}