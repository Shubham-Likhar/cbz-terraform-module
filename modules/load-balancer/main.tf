resource "aws_lb" "application" {
  count              = var.load_balancer_type == "application" ? 1 : 0
  name               = format("%s-%s-alb",var.appname,var.env)
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_group]
  subnets            = var.subnets

  tags = {
    Environment = "production"
  }
}
resource "aws_lb" "network" {
  count              = var.load_balancer_type == "network" ? 1 : 0
  name               = format("%s-%s-nlb",var.appname,var.env)
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "listener" {
  count            = var.load_balancer_type == "application" ? 1 : 0
  load_balancer_arn = aws_lb.application[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
   
 for_each = var.load_balancer_type == "application" ? var.listener_rule : null
    listener_arn = aws_lb_listener.listener[0].arn 
    priority = each.value.priority
  action {
    type = each.value.type
    target_group_arn = aws_lb_target_group.this[0].arn
  }
  condition {
    path_pattern {
      values = each.value.path_pattern
    }
  }
 }

resource "aws_lb_target_group" "this" {
   count    = var.load_balancer_type == "application" ? length(var.target_groups) : null
  name     = lookup(var.target_groups[count.index], "name", null)
  port     = lookup(var.target_groups[count.index], "port", null)
  protocol = lookup(var.target_groups[count.index], "protocol", "HTTP")
   vpc_id = var.vpc_id
  
  dynamic "health_check" {
    for_each = [lookup(var.target_groups[count.index], "health_check", {})]
    content {
      enabled             = lookup(health_check.value, "enabled", null)
      healthy_threshold   = lookup(health_check.value, "healthy_threshold", null)
      interval            = lookup(health_check.value, "interval", null)
      matcher             = lookup(health_check.value, "matcher", null)
      path                = lookup(health_check.value, "path", null)
      port                = lookup(health_check.value, "port", null)
      protocol            = lookup(health_check.value, "protocol", null)
      timeout             = lookup(health_check.value, "timeout", null)
      unhealthy_threshold = lookup(health_check.value, "unhealthy_threshold", null)
    }
  }
}





