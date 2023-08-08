
variable "test-map" {
  type        = map(string)
  description = "Testing Map value"
  default = {
    "Name"    = "local-mapname"
    "content" = "Content from terraform"
    "owner"   = "777"
  }
}

variable "map-file" {
  description = "map variable for multiple files"
  type        = map(any)
  default = {
    "file1" = {
      Name    = "map-file1"
      content = "writing from terraform"
      owner   = 777
    }
    "file2" = {
      Name     = "map-file2"
      content = "writing from terraform"
      owner   = 777
    }
  }
}

variable "test-map1" {
  type = map(object({
    Name    = string
    content = string
    owner   = string
  }))
  default = {
    "file1" = {
      Name    = "file1"
      content = "Content from mapobject"
      owner   = "777"
    },
    "file2" = {
      Name    = "file2"
      content = "Content to file2 from mapobject"
      owner   = "777"
    }
  }
}