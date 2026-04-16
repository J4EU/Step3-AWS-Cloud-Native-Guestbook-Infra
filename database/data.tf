data "terraform_remote_state" "core_link" {
  backend = "local"

  config = {
    path = "../core/terraform.tfstate"
  }
}
