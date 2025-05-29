# tf-module-elasti-cache

Terraform module to provision an AWS ElastiCache Replication Group with associated resources.

## Features

- Creates CloudWatch Log Groups for slow and engine logs.
- Configures a Security Group with flexible ingress rules (CIDRs, Security Groups, Prefix Lists).
- Provisions an ElastiCache Subnet Group.
- Deploys an ElastiCache Replication Group with encryption, multi-AZ, and log delivery.

## Usage

```hcl
module "elasticache" {
    source = "path/to/tf-module-elasti-cache"

    elasticache_name                    = "example"
    elasticache_node_type               = "cache.t3.medium"
    elasticache_engine                  = "redis"
    elasticache_engine_version          = "7.0"
    elasticache_num_node_groups         = 2
    elasticache_parameter_group         = "default.redis7"
    elasticache_automatic_failover_enabled = true
    elasticache_multi_az_enabled        = true

    vpc_id                  = "vpc-xxxxxxx"
    private_subnets_id      = ["subnet-xxxxxx", "subnet-yyyyyy"]
    log_group_retention     = 7

    sg_listener_port_from   = 6379
    sg_listener_port_to     = 6379
    sg_listener_protocol    = "tcp"
    allowed_cidrs           = ["10.0.0.0/16"]
    allowed_security_groups = []
    allowed_prefix_list_ids = []

    tags = {
        Environment = "dev"
        Project     = "example"
    }
}
```

## Inputs

| Name                          | Description                                  | Type     | Default | Required |
|-------------------------------|----------------------------------------------|----------|---------|----------|
| elasticache_name              | Name for ElastiCache resources               | string   | n/a     | yes      |
| elasticache_node_type         | Node type for ElastiCache                    | string   | n/a     | yes      |
| elasticache_engine            | Engine type (e.g., redis)                    | string   | n/a     | yes      |
| elasticache_engine_version    | Engine version                               | string   | n/a     | yes      |
| elasticache_num_node_groups   | Number of node groups                        | number   | n/a     | yes      |
| elasticache_parameter_group   | Parameter group name                         | string   | n/a     | yes      |
| elasticache_automatic_failover_enabled | Enable automatic failover           | bool     | true    | no       |
| elasticache_multi_az_enabled  | Enable multi-AZ                              | bool     | true    | no       |
| vpc_id                        | VPC ID                                       | string   | n/a     | yes      |
| private_subnets_id            | List of private subnet IDs                   | list     | n/a     | yes      |
| log_group_retention           | Log group retention in days                  | number   | 7       | no       |
| sg_listener_port_from         | Security group ingress port (from)           | number   | 6379    | no       |
| sg_listener_port_to           | Security group ingress port (to)             | number   | 6379    | no       |
| sg_listener_protocol          | Security group ingress protocol              | string   | "tcp"   | no       |
| allowed_cidrs                 | List of allowed CIDRs                        | list     | []      | no       |
| allowed_security_groups       | List of allowed security group IDs           | list     | []      | no       |
| allowed_prefix_list_ids       | List of allowed prefix list IDs              | list     | []      | no       |
| tags                          | Tags to apply to resources                   | map      | {}      | no       |

## Outputs

- `replication_group_id` - The ID of the ElastiCache replication group.
- `security_group_id` - The ID of the created security group.
- `subnet_group_name` - The name of the ElastiCache subnet group.

## License

MIT
