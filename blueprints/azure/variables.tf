variable "prefix" {
    type = "string"
    default = "motta"
}

variable "location" {
    type = "string"
    default = "East US"
}


variable "environment" {
    type = "string"
    default = "dev"
}

variable "functionapp" {
    type = "string"
    default = "../../faas/azure/post/post.zip"
}
