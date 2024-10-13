variable "name" {
    type = list(string)
    default = ["sagar", "chaitanya", "sakshi"]
}

output "display_name" {
  value = [for name in var.name: name]
}