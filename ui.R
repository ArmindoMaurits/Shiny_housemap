library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  width=300,
  sidebarMenu(id="menu",
              menuItem("Start", tabName = "startPage", icon = icon("home")),
              menuItem("Map", tabName = "mapPage", icon = icon("map")),
              conditionalPanel(
                condition = "input.menu == 'mapPage'",
                sidebarMenu(
                  selectInput('selectedDataset', 'Dataset column', choices = names(buurten), selected = "veiligheidsindex_sub_norm"),
                  menuItem("Categoriën",
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
                )
              )
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