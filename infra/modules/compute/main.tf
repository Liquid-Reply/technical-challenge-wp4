data "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
}

resource "azurerm_virtual_network" "wp4" {
  name = "${var.name_prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
}

resource "azurerm_public_ip" "public_ip" {
  count = 6
  name = "${var.name_prefix}-public-ip-${count.index}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  allocation_method   = "Static"
}

resource "azurerm_subnet" "wp4" {
  name                 = "internal"
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.wp4.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "wp4" {
  count = 6
  name = "${var.name_prefix}-nic-${count.index}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.wp4.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip[count.index].id
  }
}

resource "azurerm_network_security_group" "security_group" {
  name = "${var.name_prefix}-security-group"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "sg_association" {
  subnet_id                 = azurerm_subnet.wp4.id
  network_security_group_id = azurerm_network_security_group.security_group.id
}

# Create User assigned identity
resource "azurerm_user_assigned_identity" "vm" {
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  name = "${var.name_prefix}-identity"
}

resource "azurerm_linux_virtual_machine" "wp4" {
  count = 6
  name = "${var.name_prefix}-machine-${count.index}"
  resource_group_name = data.azurerm_resource_group.resource_group.name
  location            = data.azurerm_resource_group.resource_group.location
  size                = "Standard_A1_v2"
  admin_username      = "ubuntu"
  network_interface_ids = [
    azurerm_network_interface.wp4[count.index].id,
  ]

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.vm.id]
  }

  admin_ssh_key {
    username   = "ubuntu"
    public_key = file("${var.ssh_public_key_file}")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Add logging and monitoring extensions. This extension is needed for other extensions
resource "azurerm_virtual_machine_extension" "azure-monitor-agent" {
  for_each = {
    for vm in azurerm_linux_virtual_machine.wp4 : vm.name => vm.id
    }
  name = "${var.name_prefix}-monitor-agent-${each.key}"
  virtual_machine_id    = each.value
  publisher             = "Microsoft.Azure.Monitor"
  type                  = "AzureMonitorLinuxAgent"
  type_handler_version  =  "1.33"
  automatic_upgrade_enabled  = true
  auto_upgrade_minor_version = true
  
  settings = jsonencode({
    authentication = {
      managedIdentity = {
        identifier-name  = "mi_res_id"
        identifier-value = azurerm_user_assigned_identity.vm.id
      }
    }

  })
}
