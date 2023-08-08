output "out-file" {
  value = [
    for i in local_file.fi-for : i.filename
  ]
}

output "name" {
  value = values(local_file.fi-for).*.content
}

output "out-count" {
  value = length(local_file.for-map-file)
}