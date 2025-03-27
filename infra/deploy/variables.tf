variable "prefix" {
  description = "Prefix for resources in AWS"
  default     = "raa"
}

variable "project" {
  description = "Project name for tagging resources"
  default     = "recipe-app-api"
}

variable "contact" {
  description = "Contact name for tagging resources"
  default     = "sivanishasalearnsa@outlook.com"
}

variable "db_username" {
  description = "Username for the recipe app api database"
  default     = "recipeapp"
}

variable "db_password" {
  description = "Password for the Terraform database"
  type        = string
  # validation {
  #   condition     = length(var.db_password) > 7 && length(var.db_password) < 41
  #   error_message = "Password must be between 8 and 40 characters long."
  # }
}

variable "ecr_proxy_image" {
  description = "Path to the ECR repo with the proxy image"
}
