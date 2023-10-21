

variable "image-id" {
  description = "Image AMI"
  type = string
}

variable "pub-sub-id" {
  description = "Public subnet ID"
  type = list(string)
}

variable "key-name" {
  description = "Key name for authentication"
  type = string
}

variable "sg-ids" {
  description = "Security group ids"
  type = list(string)
}

variable "ENV" {
  description = "Type of Environment"
  type = string
}