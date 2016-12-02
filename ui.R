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
                                                "Tot 15 jaar" = "leeftijd_tot15",
                                                "Tussen 15 en 65 jaar" = "leeftijd_15.65",
                                                "Ouder dan 65 jaar" = "lefetijd_van65"
                                              )
                           )
                  ),
                  menuItem("Herkomst",
                           checkboxGroupInput("origin", NULL,
                                              choices = c(
                                                "Autochtoon" = "autochtoon",
                                                "Allochtoon" ="allochtoon_w"
                                              )
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
                                                "Basisscholen" = "aantal_basisscholen_norm",
                                                "VMBO-scholen" ="aantal_vmboschool_norm",
                                                "HAVO/VWO-scholen" ="aantal_hav.vwoschool_norm"
                                              )
                           )
                  ),
                  menuItem("Openbaarvervoer",
                           checkboxGroupInput("publicTransport", NULL,
                                              choices = c(
                                                "Aantal bushaltes" = "aantal_bushaltes_norm",
                                                "Aantal tramhaltes" ="aantal_tramhaltes_norm",
                                                "Aantal metrostations" ="aantal_metrostations_norm"
                                              )
                           )
                  ),
                  menuItem("Veiligheidsindex",
                           checkboxGroupInput("safetyIndex", NULL,
                                              choices = c(
                                                "Veiligheidsindex subjectief" = "veiligheidsindex_sub_norm",
                                                "Veiligheidsindex objectief" ="veiligheidsindex_ob_norm"
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
                        }
                        .leaflet-popup {
                          bottom: 20px !important;
                        }
                        table {
                          border-collapse: collapse;
                          width: 100%;
                        }
                        th {
                          font-weight:bold;
                        }
                        td, th {
                          border: 1px solid #bbbbbb;
                          text-align: left;
                          padding: 8px;
                        }
                        tr:nth-child(even) {
                          background-color: #dddddd;
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