/*
Copyright 2022 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    https://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

resource "google_cloud_run_service" "default" {
  name     = var.cloud_run_service_name
  location = var.region

  metadata {
    annotations = {
      "run.googleapis.com/ingress" = "internal"
    }
  }

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
    
    metadata {
      annotations = {
        "run.googleapis.com/ingress" = "internal"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_compute_region_backend_service" "backend-service" {
  project = var.project_id
  region = var.region
  name = "region-service"
  protocol = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_health_check" "health-check" {
  name = "health-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "cloudrun-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = google_cloud_run_service.default.name
  }
}

resource "google_compute_region_url_map" "regionurlmap" {
  project         = var.project_id
  name            = "regionurlmap"
  description     = "Created with Terraform"
  region          = var.region
  default_service = google_compute_region_backend_service.backend-service.id
}

resource "google_compute_region_target_http_proxy" "targethttpproxy" {
  project = var.project_id
  region  = var.region
  name    = "test-proxy"
  url_map = google_compute_region_url_map.regionurlmap.id
}

resource "google_compute_forwarding_rule" "forwarding_rule" {
  name                  = "l7-ilb-forwarding-rule"
  provider              = google-beta
  region                = var.region
  depends_on            = [google_compute_subnetwork.vpc_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = var.ilb_ip_address
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.targethttpproxy.id
  network               = google_compute_network.vpc_network.id
  subnetwork            = google_compute_subnetwork.vpc_subnet.id
}
