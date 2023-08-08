locals {
  
}
resource "local_file" "fi-name" {
  filename        = var.test-map["Name"]
  content         = var.test-map["content"]
  file_permission = var.test-map["owner"]
}

resource "local_file" "fi-for" {
  
  for_each        = var.test-map1
  filename        = each.value.Name
  content         = each.value.content
  file_permission = each.value.owner
}

resource "local_file" "for-map-file" {
  for_each        = var.map-file
  filename        = each.value.Name
  content         = each.value.content
  file_permission = each.value.owner

}