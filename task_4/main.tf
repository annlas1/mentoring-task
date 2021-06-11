terraform {
  required_providers {
    google = {
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)
  region      = var.region
}


resource "google_project" "project" {
  name            = var.project
  project_id      = var.project_id

}