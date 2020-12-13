# ----------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------

# variable "name_suffix" {
#   description = "An arbitrary suffix that will be added to the end of the resource name(s). For example: an environment name, a business-case name, a numeric id, etc."
#   type        = string
#   validation {
#     condition     = length(var.name_suffix) <= 14
#     error_message = "A max of 14 character(s) are allowed."
#   }
# }

# ----------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# ----------------------------------------------------------------------------------------------------------------------
variable "name_suffix" {
  type        = "string"
  default     = "mmotta"
}

variable "funcbasic" {
    type = "string"
    default = "../../faas/gcp/basic/basic.zip"
}
variable "funcdelete" {
    type = "string"
    default = "../../faas/gcp/delete/delete.zip"
}
variable "funcget" {
    type = "string"
    default = "../../faas/gcp/get/get.zip"
}
variable "funcpost" {
    type = "string"
    default = "../../faas/gcp/post/post.zip"
}
variable "user_groups" {
  description = "List of usergroup emails that maybe allowed to access Firestore console."
  type        = list(string)
  default     = []
}

variable "project_id" {
  type    = "string"
  default = "terraform-mmotta"
}

variable "regiao" {
  type = "string"
  default = "northamerica-northeast1"
}
