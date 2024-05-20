
resource "aws_glue_connection" "sample_jdbc_connection" {
  name = var.glue_connection_nme
  description = "sample JDBC connection"

  connection_properties = {
    "JDBC_CONNECTION_URL"  = var.JDBC_CONNECTION_URL
    "SECRET_ID"           = "glue-jdbc-secret"
  }
  connection_type = "JDBC"
}
/*
  physical_connection_requirements {
    security_group_id_list  = var.security_group_ids
    subnet_id               = data.aws_subnet.selected.id
    availability_zone       = data.aws_subnet.selected.availability_zone

  }
}
*/