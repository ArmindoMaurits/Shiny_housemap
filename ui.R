library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Start", tabName = "startPage", icon = icon("dashboard")),
    menuItem("Map", tabName = "mapPage", icon = icon("dashboard"))
  ),
  width=300,
  fluidRow(
    column(12,
      h4("Kolom"),
      selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm")
    )
  ),
  sidebarMenu(
    menuItem("Categorien",
             checkboxInput("age", "Leeftijd"),
             checkboxInput("origin", "Herkomst"),
             checkboxInput("services", "Voorzieningen"),
             checkboxInput("schools", "Scholen"),
             checkboxInput("publicTransport", "Openbaarvervoer"),
             checkboxInput("safetyIndex", "Veiligheidsindex")
    )
  )
)

body <- dashboardBody(
  fluidRow(
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    leafletOutput("map"),
    absolutePanel(top = 10, right = 10, background="red",
                 checkboxInput("legend", "Toon legenda", F)
    )
  )
)


dashboardPage(header, sidebar, body)