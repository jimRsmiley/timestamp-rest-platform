terraform {
  backend "remote" {
    organization = "jsllc"

    workspaces {
      name = "timestamp-rest-platform"
    }
  }
}
