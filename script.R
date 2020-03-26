library(tidyverse)
library(rio)
library(leaflet)
library(sf)
library(spData)
library(htmltools)



#importamos los datos


data_est <- import("establecimientos.xlsx",which = 1) %>% 
  clean_names() %>% 
  st_as_sf(coords = c('longitud', 'latitud')) %>% 
  st_set_crs(4326) %>% 
  mutate(data_label = paste(sep = "<br/>",
                            paste0("<b>",razon_social,"</b>"),
                            paste0("CUIT ",cuit),
                            paste0(id_actividad," - ",act_1)),
         choices = paste0(clae_2_digitos," - ",descripcio_2d))



export(data_est, "data_est.Rdata")


#probamos


# leaflet(data = data) %>% 
#   addTiles() %>% 
#   addMarkers(clusterOptions = markerClusterOptions(),label = ~htmlEscape(razon_social))
  

# Generamos nueva variable

View(head(data))

data <- data %>% 
  mutate(data_label = paste(sep = "<br/>",
                            razon_social,
                            id_actividad,
                            act_1),
         choices = paste0(clae_2_digitos,"-",descripcio_2d))


#ahora ploteamos con los labels


leaflet(data = data) %>% 
  addTiles() %>% 
  addMarkers(clusterOptions = markerClusterOptions(),popup = data$data_label)

# funciona a la perfection

