library(shiny)
library(shinydashboard)
library(leaflet)

source('global.R')

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  width=300,
  sidebarMenu(id="menu",
              menuItem("Start", tabName = "startPage", icon = icon("home")),
              menuItem("Map", tabName = "mapPage", icon = icon("map")),
              
              conditionalPanel(
                condition = "input.menu == 'mapPage'",
                sidebarMenu(
                  menuItem("Leeftijd",
                           checkboxGroupInput("age", NULL,
                                              choices = ageBoxChoices
                                              ,
                                              selected = NULL
                           )
                  ),
                  menuItem("Herkomst",
                           checkboxGroupInput("origin", NULL,
                                              choices = originBoxChoices
                                              ,
                                              selected = NULL
                           )
                  ),
                  menuItem("Voorzieningen",
                           checkboxGroupInput("services", NULL,
                                              choices = servicesBoxChoices
                                              ,
                                              selected = NULL
                           )
                  ),
                  menuItem("Scholen",
                           checkboxGroupInput("schools", NULL,
                                              choices = schoolBoxChoices
                                              ,
                                              selected = NULL
                           )
                  ),
                  menuItem("Openbaarvervoer",
                           checkboxGroupInput("publicTransport", NULL,
                                              choices = publicTransportBoxChoices
                                              ,
                                              selected = NULL
                           )
                  ),
                  menuItem("Veiligheidsindex",
                           checkboxGroupInput("safetyIndex", NULL,
                                              choices = safetyIndexBoxChoices
                                              ,
                                              selected = NULL
                                              )
                           )
                  )
                )
              )
  )
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


body <- dashboardBody(
  tabItems(
 
    tabItem(tabName = "startPage",  
            h2("Startpagina"),
            fluidRow(
              box(title = "Neighbourhood Quality map", solidHeader = T, 
                  status = "info","Welkom bij Neighbourhood quality map",
                  br(),br(), 
                  "Deze applicatie is gemaakt door studenten aan de minor DataScience met het doel om de kwaliteit van buurten
                  in Nederland (momenteel alleen rotterdam) in kaart te brengen door gebruik te maken van diverse publiekelijk beschikbare datasets", 
                  br(), "De beoogde doelgroep van deze applicatie zijn mensen die op zoek zijn naar een nieuwe woning en meer informatie
                  willen verzamelen over de buurt waarin zij terecht gaan komen.", br(), "Uiteraard kan deze applicatie ook gebruikt worden
                  om meer informatie over je eigen wijk op te zoeken",
                  br(), "Hieronder zijn voor u reeds een aantal profielen samengesteld. U kunt een profiel kiezen waarmee enkele filters 
                       voor u aangezet worden. U kunt ook kiezen voor de optie 'geen profiel' om direct vanaf het begin alle filters zelf 
                  toe te kunnen passen"
            )),
           
              h3("Profiel selectie")
            ,
            fluidRow(
              box(title = "Alleenstaand", collapsible = F, status = "warning", solidHeader = T, width = 3, height = 350,
                  br(),"Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(),
                  br(),"- Veiligheidsnorm objectief",
                  br(),"- Leeftijd tot 65 jaar",
                  br(),"- Openbaar vervoer in de buurt",
                  br(),
                  actionButton(inputId = "aloneAction", label = "Ga verder met mijn selectie")),
              
              box(title = "Student", collapsible = F, status = "warning", solidHeader = T, width = 3, 
                  br(),"Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(),
                  br(), "- Veiligheidsnorm objectief",
                  br(), "- leeftijd tussen 15 en 65",
                  br(), "- Openbaar vervoer in de buurt", 
                  br(), "- Winkels in de buurt",
                  br(), "- Internetsnelheid",
                  br(),
                  actionButton(inputId = "studentAction",label = "Ga verder met mijn selectie"), height = 350),
              
              box(title = "Gezin", collapsible = F, status = "warning", solidHeader = T, width = 3, 
                  br(),"Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(), 
                  br(),"- Veiligheidsnorm objectief",
                  br(),"- Basis- en middelbare scholen in de buurt",
                  br(), "- Winkels in de buurt",
                  br(), "- Sport voorzieningen",
                  br(), "- WOZ waarde",
                  br(),
                  actionButton(inputId = "familyAction",label = "Ga verder met mijn selectie"), height = 350),
              
              box(title = "Gepensioneerd", collapsible = F, status = "warning", solidHeader = T, width = 3,
                  br(),"Door dit profiel te kiezen worden de volgende criteria vooraf ingevuld:",
                  br(),
                  br(), "- Veiligheidsnorm objectief",
                  br(), "- Leeftijd >65",
                  br(), "- WOZ waarde",
                  br(),
                  actionButton(inputId = "retiredAction", label = "Ga verder met mijn selectie"), height = 350)
            ),
            fluidRow(
              box(title = "Geen profiel", collapsible = F, status = "warning", solidHeader = T, width = 3, 
                  "Kies dit profiel als u zelf alle selecties en filters wilt toepassen", 
                  br(),
                  br(),
                  br(),
                  br(),
                  actionButton(inputId = "noAction", label = "Ja, geef mij alle keuze vrijheid"))
            )
          ),
    tabItem(tabName = "mapPage",
            fluidRow(
              tags$style(type = "text/css", "#map {height: calc(100vh - 50px) !important; margin: -15px 0px}"),
              leafletOutput("map"),
              absolutePanel(top = 10, right = 10, background="red",
                            checkboxInput("legend", "Toon legenda", F)
              )
            )
        )
    )
  )

dashboardPage(header, sidebar, body)