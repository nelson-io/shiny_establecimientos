library(shiny)
library(dplyr)
library(leaflet)
library(sf)


load("data_est.Rdata")
choices <- c("Todos", sort(unique(x$choices)))







ui <- navbarPage(
  "Domicilios Fiscales",
  tabPanel("Mapa",
           
           
           bootstrapPage(
             div(
               class = "outer",
               tags$style(
                 type = "text/css",
                 ".outer {position: fixed; top: 41px; left: 0; right: 0; bottom: 0; overflow: hidden; padding: 0}"
               ),
               leafletOutput("mapa_caba", width = "100%", height = "100%"),
               absolutePanel(
                 top = 105, 
                 right = 10, 
                 left = "auto",
                 bottom = "auto",
                 
                 
                 selectInput(
                   "code_2d",
                   "Código CLAE a 2 dígitos",
                   choices = choices,
                   selected = "Todos",
                   multiple = F,
                   selectize = T
                 )
               )
             )
             
             
             
           )),
  tabPanel("Tabla",
           
           dataTableOutput("table"))
)

server <- function(input, output, session) {
  
  
  filtered_data <- reactive({
    if("Todos" %in% input$code_2d){x}
    else{x %>% filter(choices %in% input$code_2d)}
  })
  
  filtered_data_table <- reactive({
    filtered_data() %>% 
      select(`Razon Social` = razon_social,
             CUIT = cuit,
             `Código de actividad` = id_actividad,
             Barrio = barrio,
             Comuna = comuna)
  })
  
  output$mapa_caba <- renderLeaflet({
    leaflet() %>% 
      addTiles() %>% 
      fitBounds(lng1 = -58.45,lat1 = -34.69, lng2 = -58.35,lat2 = -34.53)
  
  })
  
  observe({

    leafletProxy("mapa_caba", data = filtered_data()) %>%
      clearMarkerClusters() %>% 
      addMarkers(clusterOptions = markerClusterOptions(),popup = filtered_data()$data_label)
  })
  
  output$table <- renderDataTable({filtered_data_table()})
  
  
  
}

shinyApp(ui, server)