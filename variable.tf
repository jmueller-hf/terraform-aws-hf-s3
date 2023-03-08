variable "bucket" {
  type        = string
  description = "S3 Bucket"
  validation {
    condition = can(regex("^hf-[a-z0-9-]*", lower(var.bucket)))
    error_message = "Bucket name must be start with hf- and contain only alphanumeric characters [a-z0-9-]"
  }
}

variable "policies" {
  type = list(string)
  default     = [""]
}
