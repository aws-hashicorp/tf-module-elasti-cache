output "elasticache_primary_endpoint" {
  value = aws_elasticache_replication_group.elasticache_replica_group.primary_endpoint_address
}
