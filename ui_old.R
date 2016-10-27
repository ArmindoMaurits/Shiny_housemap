library(shiny)
library(leaflet)

shinyUI(fluidPage(
  titlePanel(
    "Neighbourhood Quality Map"
  ),
  fluidRow(
    column(6,
           h4("Persoonlijke informatie"),
           selectInput("status", "Status", c("student", "werkend", "werkloos", "gepensioneerd"))
           
    ),
    column(6,
           h4("Kolom"),
           selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm")
    )
  ),
  checkboxInput("manual", "Handmatig filteren"),
  conditionalPanel(
    condition = "input.manual == true",
    fluidRow(
      h4("Eigenschappen"),
      column(2,
             checkboxInput("age", "Leeftijd"),
             
             conditionalPanel(
               condition = "input.age == true",
               checkboxInput("age_until15", "Tot 15 jaar", value = T),
               checkboxInput("age_between15and65", "Tussen 15 en 65 jaar", value = T),
               checkboxInput("age_olderThan15", "Ouder dan 65 jaar", value = T)
             )
      ),
      column(2,
             checkboxInput("origin", "Herkomst"),
             conditionalPanel(
               condition = "input.origin == true",
               checkboxInput("origin_native", "Autochtoon", value = T),
               checkboxInput("origin_ethnicMinority", "Allochtoon", value = T)
             )
      ),
      column(2,
             checkboxInput("services", "Voorzieningen"),
             conditionalPanel(
               condition = "input.services == true",
               checkboxInput("services_insideFields", "Binnensport", value = T),
               checkboxInput("services_outsideFields", "Sportvelden", value = T),
               checkboxInput("services_parkingLots", "Parkeergelegenheid", value = T),
               checkboxInput("services_parkingLotsOwn", "Eigen parkeerplek", value = T)
             )
      ),
      column(2,
             checkboxInput("schools", "Scholen"),
             conditionalPanel(
               condition = "input.schools == true",
               checkboxInput("schools_elementary", "Basisscholen", value = T),
               checkboxInput("schools_secundary", "Middelbarescholen", value = T),
               checkboxInput("schools_secundary_vmbo", "VMBO-scholen", value = T),
               checkboxInput("schools_secundary_havo_vwo", "HAVO/VWO-scholen", value = T)
             )
      ),
      column(2,
             checkboxInput("publicTransport", "Openbaarvervoer"),
             conditionalPanel(
               condition = "input.publicTransport == true",
               checkboxInput("publicTransport_busStops", "Aantal bushaltes", value = T),
               checkboxInput("publicTransport_tramStops", "Aantal tramhaltes", value = T),
               checkboxInput("publicTransport_subwayStations", "Aantal metrostations", value = T)
             )
      ),
      column(2,
             checkboxInput("safetyIndex", "Veiligheidsindex"),
             conditionalPanel(
               condition = "input.safetyIndex == true",
               checkboxInput("safetyIndex_subjective", "Veiligheidsindex subjectief", value = T),
               checkboxInput("safetyIndex_objective", "Veiligheidsindex", value = T) 
             )
      )
    ) 
  ),
  hr(),
  fluidRow(
    column(12,
           leafletOutput("map", width="100%", height="750px"),
           absolutePanel(top = 10, right = 10, background="red",
                         checkboxInput("legend", "Toon legenda", F)
           )
    )
  ),
  fluidRow(
    column(12,
           plotOutput("buurtenPlot")
    )
  ),
  fluidRow(
    column(12,
           plotOutput("wijkenPlot")
    )
  )
  
  
))
