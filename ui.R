library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  width=300,
  fluidRow(
    column(12,
      h4("Kolom"),
      selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm")
    )
  ),
  sidebarMenu(id="menu",
    menuItem("Categorien",
             checkboxGroupInput("categories", NULL,
                                choices = c(
                                  "Leeftijd" ="age",
                                  "Herkomst" = "origin",
                                  "Voorzieningen" = "services",
                                  "Scholen" = "schools",
                                  "Openbaarvervoer" = "publicTransport",
                                  "Veiligheidsindex" = "safetyIndex"
                                ),
                                selected= c("age", "origin")
             )
    ),
    menuItemOutput("menuLeeftijd"),
    menuItemOutput("menuHerkomst")
  ),
  tags$head(tags$style(HTML('
      section.sidebar .shiny-input-container.shiny-input-checkboxgroup {
        padding: 5px 15px 5px 15px;
        margin-bottom: 0px;
      }
    ')
  ))
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