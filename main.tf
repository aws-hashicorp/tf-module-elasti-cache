# --- CloudWatch Logs ---
resource "aws_cloudwatch_log_group" "cloud_watch_slow_logs" {
  name              = "/elasticache/slow/${var.elasticache_name}"
  retention_in_days = var.log_group_retention

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "cloud_watch_engine_logs" {
  name              = "/elasticache/engine/${var.elasticache_name}"
  retention_in_days = var.log_group_retention

  tags = var.tags
}

# --- Security Group ---
resource "aws_security_group" "sg_elasticache" {
  name   = "${var.elasticache_name}-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_cidrs != null && length(var.allowed_cidrs) > 0 ? [1] : []
    content {
      from_port   = var.sg_listener_port_from
      to_port     = var.sg_listener_port_to
      protocol    = var.sg_listener_protocol
      cidr_blocks = var.allowed_cidrs
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_security_groups != null && length(var.allowed_security_groups) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      security_groups = var.allowed_security_groups
      description     = "Allow from security groups"
    }
  }

  dynamic "ingress" {
    for_each = var.allowed_prefix_list_ids != null && length(var.allowed_prefix_list_ids) > 0 ? [1] : []
    content {
      from_port       = var.sg_listener_port_from
      to_port         = var.sg_listener_port_to
      protocol        = var.sg_listener_protocol
      prefix_list_ids = var.allowed_prefix_list_ids
      description     = "Allow from prefix lists"
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "${var.elasticache_name}-sg" })
}

# --- Elasticache Subnet Group ---
resource "aws_elasticache_subnet_group" "elasticache_subnet_group" {
  name        = "elasticache-subnet-groups-${var.elasticache_name}"
  subnet_ids  = var.private_subnets_id
  description = lower("Elasticache subnet group for ${var.elasticache_name}")

  tags = var.tags

  depends_on = [
    var.private_subnets_id
  ]
}

# --- Elasticache Replication Group ---
resource "aws_elasticache_replication_group" "elasticache_replica_group" {
  replication_group_id = lower("elasticache-cluster-${var.elasticache_name}")
  description          = lower("Elasticache cluster for ${var.elasticache_name}")
  node_type            = var.elasticache_node_type

  port                       = 6379
  engine_version             = var.elasticache_engine_version
  num_node_groups            = var.elasticache_num_node_groups
  parameter_group_name       = var.create_elasticache_parameter_group ? aws_elasticache_parameter_group.elasticache_parameter_group[0].name : var.elasticache_parameter_group
  engine                     = var.elasticache_engine
  subnet_group_name          = aws_elasticache_subnet_group.elasticache_subnet_group.name
  automatic_failover_enabled = var.elasticache_automatic_failover_enabled
  multi_az_enabled           = var.elasticache_multi_az_enabled

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  apply_immediately          = true


  security_group_ids = [aws_security_group.sg_elasticache.id]

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.cloud_watch_slow_logs.arn
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.cloud_watch_engine_logs.arn
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }

  tags = var.tags
}

# --- Elasticache Parameter Group ---
resource "aws_elasticache_parameter_group" "elasticache_parameter_group" {
  count  = var.create_elasticache_parameter_group ? 1 : 0
  name   = "elasticache-parameter-group-${var.elasticache_name}"
  family = "redis6.x"

  dynamic "parameter" {
    for_each = var.elasticache_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }

  tags = var.tags
}
