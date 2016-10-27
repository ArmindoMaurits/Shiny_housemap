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
  )#,
  #sidebarMenu(
    #menuItem("Categorien",
             
    )


body <- dashboardBody(
  tabItems(
    tabItem(tabName = "mapPage",
    fluidRow(
    tags$style(type = "text/css", "#map {height: calc(100vh - 80px) !important;}"),
    leafletOutput("map"),
    absolutePanel(top = 10, right = 10, background="red",
                 checkboxInput("legend", "Toon legenda", F)
    )
  )
),
  tabItem(tabName = "startPage", h2("Dit is een pagina in ontwikkeling"),
          fluidRow(
            box(title = "Kies uw categorie", collapsible = T),
            box(title = "test 2", collapsible = T),
            box(title = "test 3", collapsible = T),
            box(title = "test 4", collapsible = T)
            ))
)
)



dashboardPage(header, sidebar, body)