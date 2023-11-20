resource "aws_acm_certificate" "cert" {
  domain_name       = "aws.zallesov.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "echo-lb" {
  name               = "echo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.echo-security-group.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_security_group" "echo-security-group" {
  name        = "echo-security-group"
  description = "Echo security group"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "echo-lb-target-group" {
  name     = "echo-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

# Target Group for EKS
resource "aws_lb_listener" "echo-lb-listener" {
  load_balancer_arn = aws_lb.echo-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.echo-lb-target-group.arn
  }
}

# Security group for EKS worker nodes allowing traffic from Load Balancer
resource "aws_security_group" "eks_nodes_sg" {
  name        = "eks-nodes-sg"
  description = "Security group for EKS nodes"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.echo-security-group.id]
  }
}
