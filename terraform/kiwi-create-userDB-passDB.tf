resource "google_sql_database_instance" "master" {
  name = "master-instance"

  settings {
    tier = "D0"
  }
}

resource "google_sql_user" "users" {
  name     = "kiwi-user"
  instance = "${google_sql_database_instance.master.name}"
  host     = "localhost"
  password = "PassworD1!"
}

