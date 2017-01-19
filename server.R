library(shiny)
library(shinydashboard)
library(leaflet)

# Load up the global R so the variables are loaded
source('global.R')

shinyServer(function(input, output, session) {
  session$onSessionEnded(stopApp)
  
  # Observe the slider input for changing the years.
  # Load the selected year and plot the new information on the map
  observeEvent(input$yearSlider, {
    if(input$yearSlider == 2014){
      loadBuurten2014()
    }else{
      loadBuurten2016()
    }
    
    resetCheckboxes(session)
    desiredColumns <- getDesiredColumns()

    if(length(desiredColumns) > 0){
      plotBuurtenWithMultipleColumns(desiredColumns)
      addMarkersToMap(desiredColumns)
    }
    
  })
  
  # Initialise the leaflet map in the map output element
  # Check which columns are selected, normalise and plot them on the leaflet map
  output$map <- renderLeaflet({
    map <<- leaflet(data = buurten)
    map <<- addTiles(map)
    map <<- setView(map, 4.477733, 51.92442, zoom = 12)
    map <<- addLegend(map, "bottomright", colors = rev(colorPalette), labels = 10:0,opacity = 1, title = "Totaalscore")
    
    desiredColumns <- getDesiredColumns()
    
    if(length(desiredColumns) > 0){
      plotBuurtenWithMultipleColumns(desiredColumns)
      addMarkersToMap(desiredColumns)
    }

    map  # Show the map
  })
  
  # This function returns all the selected filters/columns
  getDesiredColumns <- function(){
    desiredColumns <- character()
    age <- input$age
    origin <- input$origin
    services <- input$services
    schools <- input$schools
    publicTransport <- input$publicTransport
    safetyIndex <- input$safetyIndex
    
    if(!is.null(age)){
      desiredColumns <- append(desiredColumns, age)
    }
    if(!is.null(origin)){
      desiredColumns <- append(desiredColumns, origin)
    }
    if(!is.null(services)){
      desiredColumns <- append(desiredColumns, services)
    }
    if(!is.null(schools)){
      desiredColumns <- append(desiredColumns, schools)
    }
    if(!is.null(publicTransport)){
      desiredColumns <- append(desiredColumns, publicTransport)
    }
    if(!is.null(safetyIndex)){
      desiredColumns <- append(desiredColumns, safetyIndex)
    }
    
    return(desiredColumns)
  }

  # These observe events take care of the ability to switch between tabs after the profile selection and update the checkboxes.
  observeEvent(input$studentAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    
    resetCheckboxes(session)

    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices,
                            selected = c("leeftijd_15.65"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices, 
                             selected = c("veiligheidsindex_ob_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer", choices = publicTransportBoxChoices, 
                             selected = c("aantal_bushaltes_norm", "aantal_tramhaltes_norm", "aantal_metrostations_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
                             , selected = c("internetsnelheid_norm"), inline = FALSE)
  
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })
  
  observeEvent(input$retiredAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
                            , selected = c("leeftijd_van65"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
                             , selected = c("veiligheidsindex_sub_norm", "veiligheidsindex_ob_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
                             , selected = c("aanwezigheid_binnensport","aanwezigheid_parkeergelegenheid","aanwezigheid_eigenparkeerpl", "wozwaarde_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer",  choices = publicTransportBoxChoices
                             , selected = publicTransportBoxChoices, inline = FALSE)
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })    
  
  observeEvent(input$aloneAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
                            , selected = c("leeftijd_15", "leeftijd_tot15"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
                             , selected = c("veiligheidsindex_ob_norm"), inline = FALSE)

    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer",  choices = publicTransportBoxChoices
                             , selected = publicTransportBoxChoices, inline = FALSE)
    
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })    
  
  observeEvent(input$familyAction,{
    selectedTab <- switch (input$menu,
                          "startPage" = "mapPage")
    
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
    , selected = c("leeftijd_15.65", "leeftijd_tot15"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
    , selected = c("veiligheidsindex_ob_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "schools", label = "Scholen",  choices = schoolBoxChoices
    , selected = c("aantal_basisscholen_norm", "aantal_vmboschool_norm"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
    , selected = c("aanwezigheid_binnensport", "aanwezigheid_sportveld", "wozwaarde_norm"), inline = FALSE)

    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })    
  
  observeEvent(input$noAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    resetCheckboxes(session)
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })
  
  # This function resets all filters
  observeEvent(input$resetCheckboxesButton,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    resetCheckboxes(session)
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })
})