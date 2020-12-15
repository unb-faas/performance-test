variable "prefix" {
    type = string
    default = "faasevaluation"
}

variable "table_name" {
    type = string
    default = "covid19"
}

variable "location" {
    type = string
    default = "East US"
}


variable "environment" {
    type = string
    default = "dev"
}

variable "functionpost" {
    type = string
    default = "../../faas/azure/post/post.zip"
}

variable "client_secret" {
    type = string
}

variable "client_id" {
    type = string
}

variable "tenant_id" {
    type = string
}

variable "subscription_id" {
    type = string
}
