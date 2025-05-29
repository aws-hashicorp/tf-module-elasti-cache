# --- Global Variables ---
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

# --- Security Group Variables ---
variable "allowed_cidrs" {
  description = "The CIDR blocks to allow"
  type        = list(string)
  default     = []
}

variable "allowed_security_groups" {
  description = "The security groups to allow"
  type        = list(string)
  default     = []
}

variable "allowed_prefix_list_ids" {
  description = "The prefix list IDs to allow"
  type        = list(string)
  default     = []
}

variable "sg_listener_port_from" {
  description = "The starting port for the security group listener"
  type        = number
  default     = 6379
}

variable "sg_listener_port_to" {
  description = "The ending port for the security group listener"
  type        = number
  default     = 6379
}

variable "sg_listener_protocol" {
  description = "The protocol for the security group listener"
  type        = string
  default     = "tcp"
}

# --- CloudWatch Logs Variables ---
variable "log_group_retention" {
  description = "The retention period (in days) for the CloudWatch log group"
  type        = number
}

# --- Elasticache Variables ---
variable "elasticache_name" {
  description = "The name of the Elasticache instance"
  type        = string
}

variable "private_subnets_id" {
  description = "The list of private subnet IDs"
  type        = list(string)
}

variable "elasticache_node_type" {
  description = "The node type for the Elasticache instance"
  type        = string
}

variable "elasticache_engine_version" {
  description = "The engine version for the Elasticache instance"
  type        = string
}

variable "elasticache_num_node_groups" {
  description = "The number of node groups for the Elasticache instance"
  type        = number
}

variable "elasticache_parameter_group" {
  description = "The parameter group for the Elasticache instance"
  type        = string
}

variable "elasticache_engine" {
  description = "The engine for the Elasticache instance"
  type        = string
}

variable "elasticache_automatic_failover_enabled" {
  description = "Whether automatic failover is enabled for the Elasticache instance"
  type        = bool
  default     = false
}

variable "elasticache_multi_az_enabled" {
  description = "Whether Multi-AZ is enabled for the Elasticache instance"
  type        = bool
  default     = false
}
