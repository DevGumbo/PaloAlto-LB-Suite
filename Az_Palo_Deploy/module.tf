module "PaloSpokeLB-Deploy" {
  source = "./PaloLBDeploy"
    ### This code will generate a  list of subnets in order, and the order must be preserved for the logic to work.  
## for there to be a systemtic approach to the cidr subnet that is applied the following is observed
## (core = 0, oob = 1, untrust = 2) of the subnets in a scpoe"

Org_Name = "ACME1"

##pan_user = This should be an environment variable and ran with that managed ID
##pan_pass = This should be an environment variable and ran with that managed ID
pan_user = var.pan_user
pan_pass = var.pan_pass

# export ARM_CLIENT_ID=""
# export ARM_CLIENT_SECRET=""
# export ARM_TENANT_ID=""
# export ARM_SUBSCRIPTION_ID=""



pan_version = "latest"
Palo_Spoke_Name = "Palo-Spoke-Net"
palo_rg_name = "Palo-Spoke"
rg_location = "eastus2"


## The Allows_Mgmt_IP is for all port access to the palo being created on the ip's in the list.
Allowed_Mgmt_IP = ["47.202.65.44/32"] 
##The Untrust_Allow_IP is tied to an NSG rule that will allow all ports to the ip's in the list.
Untrust_Allow_IP = ["47.202.65.44/32"]
##The Vnet_Scopes represents a list of subnet_scopes. Take in mind that the order is important as the logic nested within the config is keying on the first scope in this list.
Vnet_Scopes = ["10.0.0.0/24"]




##Only use hte below config if you have a specific VNET already created and would like to put this configuration in that vnet.
##I have not vetted all of that functional flow so will need to tweak it to make sure the routing makes sense.
##This was really meant to be a net new config, but thought i would create a port to allow for the integration of existing Vnet of this pan/lb config.

#existing_vnet = NAME_OF_EXISTING_VNET_FOR_PAN_DEPLOYMENT
#existing_resource_group = NAME_OF_VNET_SPEC
#exist_vnet_scope_index = NUMBER

}

variable "pan_pass" {
    type = string
    description = "(optional) describe your variable"
}

variable "pan_user" {
    type = string
    description = "(optional) describe your variable"
}