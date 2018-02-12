# About this repository.

This is a playground for my Terraform resources.  They're not production ready, but typically
used to learn a concept or try something out.

# Useful notes follow

## Authenticate via a service principal

Assuming a single subscription:

 * chocolatey install azure-cli -y
 * az login
   (log in to the browser window, the subscription ID is the returned 'id')
 * az ad sp create-for-rbac --name terraform --role contributor --scopes="/subscriptions/SUBSCRIPTION_ID" 

This command will output 5 values:

{
  "appId": "00000000-0000-0000-0000-000000000000",
  "displayName": "terraform",
  "name": "http://terraform",
  "password": "0000-0000-0000-0000-000000000000",
  "tenant": "00000000-0000-0000-0000-000000000000"
}
These values map to the Terraform variables like so:

* appId is the client_id defined above.
* password is the client_secret defined above.
* tenant is the tenant_id defined above.

For more details see https://www.terraform.io/docs/providers/azurerm/authenticating_via_service_principal.html

## Suggested naming conventions for Azure resources;

https://docs.microsoft.com/en-us/azure/architecture/best-practices/naming-conventions

