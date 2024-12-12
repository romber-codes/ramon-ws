variable "ARM_CLIENT_ID" {
  type = string
}
variable "ARM_CLIENT_SECRET" {
  type      = string
  sensitive = true
}
variable "ARM_SUBSCRIPTION_ID" {
  type = string
}
variable "ARM_TENANT_ID" {
  type = string
}
variable "RESOURCE_GROUP_NAME" {
  type = string
}
variable "STORAGE_ACCOUNT_NAME" {
  type = string
}