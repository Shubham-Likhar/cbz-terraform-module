


# module "vpc" {
#   env = "dev"
#   appname = "web-app"
#   source         = "../../modules/vpc"
#   vpc_cidr_block = "10.0.0.0/16"
#   public_subnet  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
#   private_subnet = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
#   tags = {
#     Name = "cloudblitz"
#     owner = "shubham likhar"
#   }

# }


module "alb" {
  source = "../../modules/load-balancer"
  env = "dev"
  appname = "web-app"
  internal = true
  load_balancer_type = "application"
  


  
}