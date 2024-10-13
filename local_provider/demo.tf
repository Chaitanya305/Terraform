resource "local_file" "demo-txt" {
  count = 2
  filename = "demo.txt-${count.index}"
  content = "this is demo-${count.index} file craeted by terraform"
}

output "file_name"{ 
  value = local_file.demo-txt[*].filename
}

#achieve same thing with for_each lopp

variable "file_names" {
  type = list(string)
  default = [ "file-1", "file-2", "file-3" ]  
}

resource "local_file" "for_each_files" {
  for_each = toset(var.file_names)
  filename = each.value
  content = "this is file created from terraform using for each loop with name of ${each.value}"
}

output "for_each_file_names" {
  value = "first file name is ${local_file.for_each_files["file-1"].filename}"
}

output "for_loop" {
  value = [for file_name in var.file_names: "name of files are ${file_name}"]
}
