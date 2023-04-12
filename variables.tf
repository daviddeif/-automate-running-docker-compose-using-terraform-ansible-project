variable "cidr" {
     description = "pvc-main"
     default = "10.0.0.0/16"
     type = string

}
variable "public-subnet-cidr" {
     description = "public-subnet"
     default = "10.0.0.0/24"
     
}

variable "route_table_cidr" {
     description = "route-table"
     default =  "0.0.0.0/0" 
}