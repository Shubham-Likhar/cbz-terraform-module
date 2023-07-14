


module "vpc" {
  source         = "../../modules/vpc"
  env            = var.env
  appname        = var.appname
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet  = var.public_subnet
  private_subnet = var.private_subnet
  availability_zones = var.availability_zones
  tags           = var.tags

}


module "alb" {
  source             = "../../modules/load-balancer"
  env                = var.env
  appname            = var.appname
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  vpc_id             = module.vpc.vpc_id
  tags               = var.tags
  security_group    = aws_security_group.test1.id
  subnets = var.internal == "true" ? module.vpc.private_subnet : module.vpc.public_subnet
  listener_rule = {
    laptop = {
      priority         = "100"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:703737828106:targetgroup/web-app-dev-tg/48831ea43008123f"
      path_pattern     = ["/laptop/*"]
    }
    mobile = {
      priority         = "20"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:703737828106:targetgroup/web-app-dev-tg/48831ea43008123f"
      path_pattern     = ["/mobile/*"]
    }
    home = {
      priority         = "30"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:703737828106:targetgroup/web-app-dev-tg/48831ea43008123f"
      path_pattern     = ["/home/*"]
    }
    footware = {
      priority         = "300"
      type             = "forward"
      target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:703737828106:targetgroup/web-app-dev-tg/48831ea43008123f"
      path_pattern     = ["/footware/*"]
    }

  }
  target_groups = [
    {
      name = "tg1"
      port = "8080"


      health_check = {
        enabled           = true
        healthy_threshold = "5"
        matcher           = "200-299"
        path              = "/app/index.html"
        protocol          = "HTTP"
      }
    },
    {
      name = "tg2"
      port = "8081"

      health_check = {
        enabled           = true
        healthy_threshold = "5"
        matcher           = "200-299"
        path              = "/app/index.html"
        protocol          = "HTTP"
      }
    }

  ]
}


resource "aws_security_group" "test1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.port
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-sg-1"
  }
}