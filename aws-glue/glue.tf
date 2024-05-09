resource "aws_s3_object" "test_deploy_script_s3" {
  bucket = var.s3_bucket
  key = "glue/scripts/TestDeployScript.py"
  source = "${local.glue_src_path}TestDeployScript.py"
  etag = filemd5("${local.glue_src_path}TestDeployScript.py")
}

resource "aws_glue_connection" "sample_jdbc_connection" {
  name = "sample-jdbc-connection"
  description = "sample JDBC connection"

  connection_properties = {
    "JDBC_CONNECTION_URL"  = "jdbc:mysql://your-database-host:3306/your_database"
    "USERNAME"             = "your_username"
    "PASSWORD"             = "your_password"
  }
  connection_type = "JDBC"
}

resource "aws_glue_job" "test_deploy_script" {
  glue_version = "4.0" #optional
  max_retries = 0 #optional
  name = "TestDeployScript" #required
  description = "test the deployment of an aws glue job to aws glue service with terraform" #description
  role_arn = aws_iam_role.glue_service_role.arn #required
  number_of_workers = 10 #optional, defaults to 5 if not set
  worker_type = "G.2X" #optional
 // max_capacity = 20
  execution_property {
    max_concurrent_runs = 10  # Maximum number of concurrent runs allowed for the job
  }
  timeout = "60" #optional
  execution_class = "FLEX" #optional
  tags = {
    project = var.project #optional
  }
  command {
    name="glueetl" #optional
    script_location = "s3://${var.s3_bucket}/glue/scripts/TestDeployScript.py" #required
  }
  connections = [
        aws_glue_connection.sample_jdbc_connection.name
    ]
  default_arguments = {
    "--class"                   = "GlueApp"
    "--enable-job-insights"     = "true"
    "--enable-auto-scaling"     = "false"
    "--enable-glue-datacatalog" = "true"
    "--job-language"            = "python"
    "--job-bookmark-option"     = "job-bookmark-disable"
    "--datalake-formats"        = "iceberg"
    "--conf"                    = "spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions  --conf spark.sql.catalog.glue_catalog=org.apache.iceberg.spark.SparkCatalog  --conf spark.sql.catalog.glue_catalog.warehouse=s3://tnt-erp-sql/ --conf spark.sql.catalog.glue_catalog.catalog-impl=org.apache.iceberg.aws.glue.GlueCatalog  --conf spark.sql.catalog.glue_catalog.io-impl=org.apache.iceberg.aws.s3.S3FileIO"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
  }
}

resource "aws_glue_trigger" "test_glue_trigger" {
  name       = "test-glue-trigger"
  type       = "SCHEDULED"
  schedule   = "cron(0 0 * * ? *)"  # Specify your desired schedule
 // workflow_name = aws_glue_job.test_deploy_script.name

  actions {
    job_name = aws_glue_job.test_deploy_script.name
  }
}