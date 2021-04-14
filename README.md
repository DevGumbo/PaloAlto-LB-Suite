# PaloAlto-LB-Suite - AZ
This repo will build out all necessary resources for testing a palo alto with a load balancer in Azure !

It will have a load balancer, 3 seperate subnets (/27's), a vnet (10.0.0.0/24), routing will be pressing internet traffic for default and making the trust traffic head out the trust interface to the core network.

I have also included the config for the firewall that should be useful for the correct routes and polices needed to make mgmt connect if you change the NSG ips in the config to your specific ip.

MAKE SURE TO CHANGE THE ADMIN LEVEL CREDS ON THE PAN

That is becuase after you upload the config into the palo alto nit will want to set the kermit and admin login which you would not have the password for. So please make sure you add a specific admin user after uploading the config to the firewall.

Core will route all 10.0.0.0/24 traffic to the lb throguh the fw and 0.0.0.0/0 to the internet with the untrust interface which has a public ip associated to it.

Untrust routes all traffic to the untrust subnet at the first ip in the untrust subnet (10.0.0.65/27) so that it will use the internet gw of the untrust subnet.

OOB has all routes to the internet and is not firewalled. There is an NSG on this Subnet as well that allows the specified ip address in the config for the mgmt nsg.

I will upload diagrams when i am able.

thanks.
