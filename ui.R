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
                  selectInput('selectedDataset', 'Selecteer data', choices = names(buurten), selected = "veiligheidsindex_sub_norm"),
                  menuItem("Leeftijd",
                           checkboxGroupInput("age", NULL,
                                              choices = c(
                                                "Tot 15 jaar" = "age_until15",
                                                "Tussen 15 en 65 jaar" = "age_between15and65",
                                                "Ouder dan 65 jaar" = "age_olderThan65"
                                              ),
                                              selected = c("age_until15", "age_olderThan65")
                           )
                  ),
                  menuItem("Herkomst",
                           checkboxGroupInput("origin", NULL,
                                              choices = c(
                                                "Autochtoon" = "origin_native",
                                                "Allochtoon" ="origin_ethnicMinority"
                                              ),
                                              selected = c("origin_native","origin_ethnicMinority")
                           )
                  ),
                  menuItem("Voorzieningen",
                           checkboxGroupInput("services", NULL,
                                              choices = c(
                                                "Binnensport" = "services_insideFields",
                                                "Sportvelden" ="services_outsideFields",
                                                "Parkeergelegenheid" ="services_parkingLots",
                                                "Eigen parkeerplekken" ="services_parkingLotsOwn"
                                              )
                           )
                  ),
                  menuItem("Scholen",
                           checkboxGroupInput("schools", NULL,
                                              choices = c(
                                                "Basisscholen" = "schools_elementary",
                                                "Middelbarescholen" ="schools_secundary",
                                                "VMBO-scholen" ="schools_secundary_vmbo",
                                                "HAVO/VWO-scholen" ="schools_secundary_havo_vwo"
                                              )
                           )
                  ),
                  menuItem("Openbaarvervoer",
                           checkboxGroupInput("publicTransport", NULL,
                                              choices = c(
                                                "Aantal bushaltes" = "publicTransport_busStops",
                                                "Aantal tramhaltes" ="publicTransport_tramStops",
                                                "Aantal metrostations" ="publicTransport_subwayStations"
                                              )
                           )
                  ),
                  menuItem("Veiligheidsindex",
                           checkboxGroupInput("safetyIndex", NULL,
                                              choices = c(
                                                "Veiligheidsindex subjectief" = "safetyIndex_subjective",
                                                "Veiligheidsindex objectief" ="safetyIndex_objective"
                                              )
                           )
                  )
                )
              )
  ),
  tags$head(tags$style(HTML
                       (
                       'section.sidebar .shiny-input-container.shiny-input-checkboxgroup {
                          padding: 5px 15px 5px 15px;
                          margin-bottom: 0px;
                        }'
                       )
  ))
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "mapPage",
            fluidRow(
              tags$style(type = "text/css", "#map {height: calc(100vh - 50px) !important; margin: -15px 0px}"),
              leafletOutput("map"),
              absolutePanel(top = 10, right = 10, background="red",
                            checkboxInput("legend", "Toon legenda", F)
              )
            )
    ),
    tabItem(tabName = "startPage", 
            h2("Startpagina"),
            fluidRow(
              box(title = "Kies uw profiel")
            ),
            fluidRow(
              box(title = "Profiel: Alleenstaand", collapsible = T),
              box(title = "Profiel: Student", collapsible = T),
              box(title = "Profiel: Gezin", collapsible = T),
              box(title = "Profiel: Gepensioneerd", collapsible = T)
            )
    )
  )
)



dashboardPage(header, sidebar, body)