Need to

* Create terraform.tfvars with these settings

# get this from az account list
"ARM_SUBSCRIPTION_ID" = "XXXXXXXXX"

# the service principal used for access to Azure
#
# Create by:
#   az ad sp create-for-rbac --name terraform --role contributor
#
# client_id = appId
"ARM_CLIENT_ID"       = "XXXXXXX"
# client_secret = password
"ARM_CLIENT_SECRET"   = "XXXXXXX"
"ARM_TENANT_ID"       = "XXXXXXXXXX"


Then run
- terraform init 
- terraform plan
