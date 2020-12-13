provider "google" {
  credentials = "${file("/home/marcelo.cmotta/utils/alpine-charge-262122-91429b2ecb24.json")}"
  project     = "${var.project_id}"
  region      = "${var.regiao}"

}

terraform {
  required_version = ">= 0.13.1" # see https://releases.hashicorp.com/terraform/
}
