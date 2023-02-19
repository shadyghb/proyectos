# Crear un Plan App Service con Linux
resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "${azurerm_resource_group.rg-terra.name}-plan"
  location            = azurerm_resource_group.rg-terra.location
  resource_group_name = azurerm_resource_group.rg-terra.name
  reserved            = true # Obligario para planes de Linux

  # Definir SO del Host Linux
  kind = "Linux"

  # Elegir el tamaño
  sku {
    tier = "Standard"
    size = "S1"
  }

}

# Crear un Azure Webapp para containers en el App Service Plan
resource "azurerm_app_service" "dockerapp" {
  name                = "${azurerm_resource_group.rg-terra.name}-dockerapp"
  location            = azurerm_resource_group.rg-terra.location
  resource_group_name = azurerm_resource_group.rg-terra.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id

  # No adjuntar el almacenamiento por defecto
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false

    /*
    # Settings for private Container Registires  
    DOCKER_REGISTRY_SERVER_URL      = ""
    DOCKER_REGISTRY_SERVER_USERNAME = ""
    DOCKER_REGISTRY_SERVER_PASSWORD = ""
    */
  }

  # Configurar la imagen del Docker para el arranque
  site_config {
    linux_fx_version = "DOCKER|appsvcsample/static-site:latest"
    always_on        = "true"
  }

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_container_group" "database-container" {
name = "database-container"
location = azurerm_resource_group.rg-terra.location
resource_group_name = azurerm_resource_group.rg-terra.name
ip_address_type = "public"
dns_name_label = "containerdatabaseterraformdns"
os_type = "Linux"
 
container {
name = "BBDD"
image = "mcr.microsoft.com/mssql/server:2019-latest"
cpu = "1.0"
memory = "2.0"
 
ports {
port = 1433
protocol = "TCP"
}
 
environment_variables = {
"ACCEPT_EULA" = "Y"
"SA_PASSWORD" = "Pruebame1234"
}
}
}