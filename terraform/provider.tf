provider "aws" {
  region = "us-east-1"

  allowed_account_ids = ["888458450351"]

  assume_role {
    role_arn = "arn:aws:iam::888458450351:role/JsllcMainAccountAdministratorAccess"
  }
}
