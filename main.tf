resource "aws_elasticache_cluster" "elasticache" {
  cluster_id           = "${var.env}-elasticache-roboshop"
  engine               = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  engine_version       = var.engine_version
  port                 = var.port
  subnet_group_name    = aws_elasticache_subnet_group.elasticache-subnet.name
  security_group_ids = [aws_security_group.elasticache-sg.id]
}


resource "aws_security_group" "elasticache-sg" {
  name        = "${var.env}-roboshop-elasticache-SG"
  description = "Security groups for elasticache"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = var.allow_subnets

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env}-roboshop-elasticache-SG"
  }
}

resource "aws_elasticache_subnet_group" "elasticache-subnet" {
  name       = "${var.env}-elasticache-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env} elasticache subnet group"
  }
}

resource "aws_ssm_parameter" "elasticache_endpoint" {
  name="${var.env}.elasticache.endpoint"
  type="String"
  value=aws_elasticache_cluster.elasticache.cache_nodes[0].address

  
}

