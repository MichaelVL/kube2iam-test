variable "name_prefix" {
  type    = string
  default = "nn-"
}

variable "aws_account_id" {
  type    = string
}

variable "worker_iam_role" {
  type    = string
}
