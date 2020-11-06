resource "google_sql_database_instance" "master" {
  name = "${var.project_name}-master"
  project = var.project_id
  database_version = "POSTGRES_13"
  region = lower(var.region)
  deletion_protection = "true"

  settings {
    tier = "db-f1-micro"
    disk_size = 10
    disk_type = "PD_SSD"
    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  name = var.project_name
  project = var.project_id
  instance = google_sql_database_instance.master.name
}

resource "random_password" "sql_password" {
  length = 30
  special = true
}

resource "google_sql_user" "users" {
  name = var.project_name
  instance = google_sql_database_instance.master.name
  password = random_password.sql_password.result
}
