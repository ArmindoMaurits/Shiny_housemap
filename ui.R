library(shiny)
library(shinydashboard)
library(leaflet)

source('global.R')

header <- dashboardHeader(titleWidth=300, title = "Neighbourhood Quality Map")

sidebar <- dashboardSidebar(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  width=300,
  sidebarMenu(id="menu",
              menuItem("Start", tabName = "startPage", icon = icon("home")),
              menuItem("Map", tabName = "mapPage", icon = icon("map")),
              conditionalPanel(
                condition = "input.menu == 'mapPage'",
                sidebarMenu(
                  sliderInput("yearSlider", "Jaar", min = 2014, max = 2016, step = 2, value = 2016, animate = F, sep = ""),
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
                  ),
                fluidRow(12, 
                         actionButton("resetCheckboxesButton", "Reset"))
                )
              )
  )


body <- dashboardBody(
  tabItems(
 
    tabItem(tabName = "startPage",  
            h2("Startpagina"),
            fluidRow(
              box(title = "Neighbourhood Quality map", solidHeader = T,  width = 6, 
                  status = "info","Welkom bij de Neighbourhood Quality Map",
                  "Deze applicatie is gemaakt door studenten van de minor DataScience van de Hogeschool Rotterdam met het doel om de kwaliteit van buurten
                  in Nederland (momenteel alleen Rotterdam) in kaart te brengen door gebruik te maken van diverse publiekelijk beschikbare data.", 
                  br(), 
                  "De beoogde doelgroep van deze applicatie zijn mensen die op zoek zijn naar een nieuwe woning en meer informatie
                  willen verzamelen over de buurt waarin zij terecht gaan komen. 
                  Uiteraard kan deze applicatie ook gebruikt worden om meer inzicht te krijgen over de kwaliteit van uw eigen wijk.",
                  br(), 
                  "Hieronder zijn voor u reeds een aantal profielen samengesteld. U kunt een profiel kiezen waarmee enkele filters 
                  voor u aangezet worden. U kunt ook kiezen voor de optie 'geen profiel' om direct te beginnen en handmatig filters in te stellen."
              )
            ),
            h3("Profielen"),
            fluidRow(
              box(title = "Alleenstaand", collapsible = F, status = "warning", solidHeader = T, width = 4,
                  "Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(),
                  br(),"- Veiligheidsnorm objectief",
                  br(),"- Leeftijd tot 65 jaar",
                  br(),"- Openbaar vervoer in de buurt",
                  actionButton(inputId = "aloneAction", label = "Ga verder met mijn selectie")),
              
              box(title = "Student", collapsible = F, status = "warning", solidHeader = T, width = 4, 
                  "Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(),
                  br(), "- Veiligheidsnorm objectief",
                  br(), "- leeftijd tussen 15 en 65",
                  br(), "- Openbaar vervoer in de buurt", 
                  br(), "- Winkels in de buurt",
                  br(), "- Internetsnelheid",
                  actionButton(inputId = "studentAction",label = "Ga verder met mijn selectie")),
              
              box(title = "Gezin", collapsible = F, status = "warning", solidHeader = T, width = 4, 
                  "Door dit profiel te kiezen worden de volgende filters toegepast:",
                  br(), 
                  br(), "- Veiligheidsnorm objectief",
                  br(), "- Basis- en middelbare scholen in de buurt",
                  br(), "- Winkels in de buurt",
                  br(), "- Sport voorzieningen",
                  br(), "- WOZ waarde",
                  actionButton(inputId = "familyAction",label = "Ga verder met mijn selectie"))
              ),
            fluidRow(
              box(title = "Gepensioneerd", collapsible = F, status = "warning", solidHeader = T, width = 4,
                  "Door dit profiel te kiezen worden de volgende criteria vooraf ingevuld:",
                  br(),
                  br(), "- Veiligheidsnorm objectief",
                  br(), "- Leeftijd >65",
                  br(), "- WOZ waarde",
                  actionButton(inputId = "retiredAction", label = "Ga verder met mijn selectie")),
              
              box(title = "Geen profiel", collapsible = F, status = "warning", solidHeader = T, width = 4, 
                  "Kies dit profiel als u handmatig selecties en filters wilt toepassen", 
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