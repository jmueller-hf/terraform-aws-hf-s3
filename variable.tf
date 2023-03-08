variable "bucket" {
  type        = string
  description = "S3 Bucket"
}

variable "versioning" {
  type        = string
  description = "Bucket Versioning"
  default     = "Disabled"
}

variable "sse_algorithm" {
  type        = string
  description = "Bucket Versioning"
  default     = null
}

variable "kms_master_key_id" {
  type        = string
  description = "Bucket Versioning"
  default     = null
}
