resource "google_container_cluster" "primary" {
  name   = "wiki-project"
  region = "europe-west4-a"
#  zone   = "europe-west4-a"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true

#  node_pool {
#    name = "default-pool"
#  }

  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
#  master_auth {
#    username = ""
#    password = ""
#  }


  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      test = "development"
    }

#    tags = ["test", "bar"]
  }
}


provider "google" {
  project     = "interview-3436b446"
  region      = "europe-west4-a"
#  zone        = "europe-west4-a"


}



resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "wiki-project"
  region     = "europe-west4-a"
#  zone       = "europe-west4-a"

  cluster    = "${google_container_cluster.primary.name}"
  node_count = 3

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.primary.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.primary.master_auth.0.cluster_ca_certificate}"
}

