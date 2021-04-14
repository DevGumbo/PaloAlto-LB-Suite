

variable "Allowed_Mgmt_IP" {
  type        = list(any)
  description = "(optional) describe your variable"
  default     = ["47.202.65.44/32"]
}

variable "Untrust_Allow_IP" {
  type        = list(any)
  description = "(optional) describe your variable"
  default     = ["47.202.65.44/32"]
}







variable "Vnet_Subnets" {

  description = "This list of subnets needs to be made in order for there to be a systemtic approach to the cidr subnet that is applied.(core = 0, oob = 1, untrust = 2) of the subnets in a scpoe"
  default     = ["core", "oob", "untrust"]
}

variable "Vnet_Scopes" {
  type        = list
  description = "This is looking for only one scope. If more are given then the code must be reviewed to reflect that. Right now it is looking to the 0 index of this list to make the subnets from"
  default     = ["10.0.0.0/24"]
}

variable "Pub_IP" {
  type        = list(any)
  description = "These are the interface names that will be associated a public ip and that public ip will be associated to the interfaces that are on the palo by the same name."
  default     = ["mgmt", "untrust"]
}



variable "palo_rg_name" {
  type = string
  description = "This will be the name of the resource group to be created that will house all the running config (interfaces, subnets, vnets, loadbalancers, firewalls, nsg, public ip, rt tables, route, rt-tab-associations etc..)"
  default = "Palo-Spoke"
}

variable "rg_location" {
  type = string
  description = "This will be the azure specific regional location"
  default =  "eastus2"
}

variable "Palo_Spoke_Name" {
  type = string
  description = "This will be the name of the VNET after it is created and represnets the specific Scope of a Spoke (hub or child spoke)"
  default = "Palo-Spoke-Net"
}

variable "existing_vnet" {
  type = string
  description = "(optional) describe your variable"
  default = ""
}



variable "pan_version" {
  type = string
  description = "(optional) describe your variable"
  default = "latest"
}

variable "pan_user" {
  type = string
  description = "This is the login user account that will be provisioned for primary login to the palo altos"
}

variable "pan_pass" {
  type = string
  description = "This is the password for the pan_userused to login to the palo alto deployed with this script."
}


variable "existing_resource_group" {
  type = string
  description = "This must match the RG that hold the VNET you will be speciying instead of creating a new one."
  default = ""
}

variable "exist_vnet_scope_index" {
  type = number
  description = "This is the index of the range you would like to use for the the imported vnet, and will be used for the creation of the subnets"
  default = 0
}

variable "Org_Name" {
  type = string
  description = "(optional) describe your variable"
  default = "ACME"
}