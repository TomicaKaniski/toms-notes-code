# providers
provider "azurerm" {
  version = "~> 2.24"

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret

  features {}
}

provider "cloudflare" {
  version = "~> 2.10.0"

  email      = var.cf_email
  api_key    = var.cf_apikey
  account_id = var.cf_accountid
}

# resource group
resource "azurerm_resource_group" "example-rg" {
  name     = "example-rg"
  location = "West Europe"
}

# network
resource "azurerm_virtual_network" "example-net" {
  name                = "example-net"
  location            = azurerm_resource_group.example-rg.location
  resource_group_name = azurerm_resource_group.example-rg.name
  address_space       = ["10.11.0.0/16"]
}

# subnet
resource "azurerm_subnet" "example-sub" {
  name                 = "example-sub"
  resource_group_name  = azurerm_resource_group.example-rg.name
  virtual_network_name = azurerm_virtual_network.example-net.name
  address_prefixes     = ["10.11.12.0/24"]
}

# nics
resource "azurerm_network_interface" "myvm-nic" {
  name                 = "myvm-nic"
  location             = azurerm_resource_group.example-rg.location
  resource_group_name  = azurerm_resource_group.example-rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "myvm-nic-ip-config"
    subnet_id                     = azurerm_subnet.example-sub.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "10.11.12.4"
    public_ip_address_id          = azurerm_public_ip.myvm-ip.id
  }
}

# public ips
resource "azurerm_public_ip" "myvm-ip" {
  name                = "myvm-ip"
  location            = azurerm_resource_group.example-rg.location
  resource_group_name = azurerm_resource_group.example-rg.name
  allocation_method   = "Static"
}

# network security group
resource "azurerm_network_security_group" "example-nsg" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example-rg.location
  resource_group_name = azurerm_resource_group.example-rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "10.11.12.4"
  }
}

resource "azurerm_subnet_network_security_group_association" "example-sub-nsg-assoc" {
  subnet_id                 = azurerm_subnet.example-sub.id
  network_security_group_id = azurerm_network_security_group.example-nsg.id
}

# vms
resource "azurerm_virtual_machine" "myvm" {
  name                          = "myvm"
  location                      = azurerm_resource_group.example-rg.location
  resource_group_name           = azurerm_resource_group.example-rg.name
  network_interface_ids         = [azurerm_network_interface.myvm-nic.id]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "19_10-daily-gen2"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myvm-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "myvm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("~/.ssh/id_rsa.pub")
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
    }
  }
}

# cloudflare dns
resource "cloudflare_record" "myvm-dns" {
  zone_id = var.cf_zoneid
  name    = "myvm"
  value   = azurerm_public_ip.myvm-ip.ip_address
  type    = "A"
}
