library(shiny)
library(shinydashboard)
library(leaflet)

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  width=300,
  sidebarMenu(id="menu",
              menuItem("Map", tabName = "mapPage", icon = icon("map")),
              menuItem("Start", tabName = "startPage", icon = icon("home")),
              
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
              box(title = "Neighbourhood Quality map", solidHeader = T, status = "info","Welkom bij Neighbourhood quality map", br(), "Deze applicatie is gemaakt door...om...", br(), "het werkt zo en zo. geniet ervan Tjiwaa")
            ),
            fluidRow(
              box(title = "Profiel selectie", solidHeader = T, width = 12, status = "success" )
              
            ),
            fluidRow(
              box(title = "Alleenstaand", collapsible = F, status = "warning", solidHeader = T, width = 3, "Add text here", br(),
                      "add more text here", br(), "even more text here", background = "light-blue"),
              
              box(title = "Student", collapsible = F, status = "warning", solidHeader = T, width = 3, 
                  checkboxGroupInput(inputId = "studentselect",label = "Selecteer de gewenste opties", choices = c("A", "B", "C"), selected = c("A", "B", "C")),
                  br(), br(), "text", br(),br(), actionButton(inputId = "studentactie",label = "Ga verder met geselecteerd opties")),
              
              box(title = "Gezin", collapsible = F, status = "warning", solidHeader = T, width = 3, 
                  checkboxGroupInput(inputId = "gezinselect",label = "Selecteer de gewenste opties", choices = c("A", "B", "C"), selected = c("A", "B", "C"))),
              
              box(title = "Gepensioneerd", collapsible = F, status = "warning", solidHeader = T, width = 3,
                  checkboxGroupInput(inputId = "pensioenselect",label = "Selecteer de gewenste opties", choices = c("A", "B", "C"), selected = c("A", "B", "C")))
            ),
            fluidRow(
              box(title = "Geen profiel", collapsible = F, status = "warning", solidHeader = T, width = 3, "kies dit profiel als u zelf alle selecties en filters wilt toepassen")
            )
              )
    )
  )



dashboardPage(header, sidebar, body)