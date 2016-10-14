library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(title = "Quality Map")

sidebar <- dashboardSidebar(
  fluidRow(
    column(12,
      h4("Kolom"),
      selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm")
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