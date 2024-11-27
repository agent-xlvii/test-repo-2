module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.4.0"

  load_balancer_type = "application"
  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets

  security_groups = [aws_security_group.alb_sg.id]

  security_group_rules = {
    ingress_http = {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "TCP"
      description = "Allow HTTP traffic from the internet"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all egress traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      backend_protocol = "HTTP"
      backend_port     = 3000
      target_type      = "ip"
    }
  ]
}
3. ALB Security Group
Created ALB Security Group: Added a standalone security group to allow incoming traffic on port 80 for HTTP.
Security Group for ALB:

hcl
Copy code
resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}