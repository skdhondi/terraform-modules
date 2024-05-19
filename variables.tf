
variable "JDBC_CONNECTION_URL" {
  type=string
  default = "jdbc:mysql://your-database-host:3306/your_database"
}

variable "USERNAME" {
  type=string
  default = "your_username"
}

variable "PASSWORD" {
  type=string
  default = "your_password"
}

variable "glue_connection_nme" {
  type=string
  default = "test-jdbc-connection"
}

variable "subnet_id" {
  description = "The subnet ID for the Glue connection"
  type        = string
  default     = "subnet-0940e60ed703d2312"
}

variable "security_group_ids" {
  description = "A list of security group IDs for the Glue connection"
  type        = list(string)
  default     = ["sgr-0c4a2edcd1a642f69"]
}