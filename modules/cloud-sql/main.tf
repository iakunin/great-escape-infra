resource "google_sql_database_instance" "master" {
  name                = var.instance.name
  project             = var.project.id
  database_version    = "POSTGRES_13"
  region              = lower(var.project.region)
  deletion_protection = "true"

  settings {
    tier      = "db-f1-micro"
    disk_size = 10
    disk_type = "PD_SSD"
    backup_configuration {
      enabled = true
    }
  }
}

resource "google_sql_database" "database" {
  name     = var.database.name
  project  = var.project.id
  instance = google_sql_database_instance.master.name
}

resource "random_password" "sql_password" {
  length  = 30
  special = true
}

resource "google_sql_user" "users" {
  name     = var.database.user
  password = random_password.sql_password.result
  instance = google_sql_database_instance.master.name
}
