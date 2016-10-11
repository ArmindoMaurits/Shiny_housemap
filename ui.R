library(shiny)
library(leaflet)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Neighbourhood Quality Map"),
  fluidRow(
    column(6,
           h4("Persoonlijke informatie"),
           sliderInput('age', 'leeftijd', min=0, max=100, value=25),
           selectInput('status', 'status', c("student", "werkend", "werkloos", "gepensioneerd"))
           
    ),
    column(6,
           h4("Eisen"),
           checkboxInput('airQuality', 'Luchtkwaliteit'),
           checkboxInput('sound', 'Geluid in de omgeving'),
           checkboxInput('safetyIndex', 'Veiligheidsindex'),
           checkboxInput('parkingLots', 'Parkeerplaatsen'),
           checkboxInput('services', 'Voorzieningen'),
           selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm")
    ),
    column(12, align="center",
           actionButton('search', 'Zoeken'))
  ),
  hr(),
  fluidRow(
    column(12,
           leafletOutput("map", width="100%", height="500px"),
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
