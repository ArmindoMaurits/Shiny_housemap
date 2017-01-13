library(shiny)
library(shinydashboard)
library(leaflet)

source('global.R')

shinyServer(function(input, output, session) {
  session$onSessionEnded(stopApp)
  
  observeEvent(input$yearSlider, {
    if(input$yearSlider == 2014){
      loadBuurten2014()
    }else{
      loadBuurten2016()
    }
  })
  
  output$map <- renderLeaflet({
    map <<- leaflet(data = buurten)
    map <<- addTiles(map)
    map <<- setView(map, 4.477733, 51.92442, zoom = 12)
    map <<- addLegend(map, "bottomright", colors = rev(colorPalette), labels = 10:0,opacity = 1, title = "Totaalscore")
    
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

    if(length(desiredColumns) > 0){
      plotBuurtenWithMultipleColumns(desiredColumns)

      # Plaats een infowindow in de center van iedere buurt
      # In iedere infowindow een tabel met de aangevinte kolommen en hun waardes
      for (buurt in buurten$buurtnaam) {
        columns <- ''
        
        for (column in desiredColumns) {
          columnName <- as.character(strsplit(column, "_norm"))
          columns <- paste0(columns, '<tr>
                            <td>',columnTitles[column],'</td>
                            <td>', buurten[[columnName]][buurten$buurtnaam == buurt],'</td>
                            </tr>')
        }

        content <- paste0('<div style="width: 250px;">
                            <h4>', buurt,' - ',buurten$wijknaam[buurten$buurtnaam == buurt],'</h4>
                            <table style="width:100%">
                              <tr>
                                <th>Onderwerp</th>
                                <th>Meting</th>
                              </tr>', columns,
                            '</table>
                          </div>')
        # vul content en addmarker
        map <<- addMarkers(map, lng=buurten$long[buurten$buurtnaam == buurt], lat=buurten$lat[buurten$buurtnaam == buurt], layerId=buurt, popup = content, icon = infoIcon)
      }
    }

    map  # Show the map
  })
  
  output$buurtenPlot <- renderPlot({
    barplot(buurten$veiligheidsindex_sub_norm, names=buurten$buurtnaam, las=2, col=colorPalette[buurten$veiligheidsindex_sub_norm+1], main="Veiligheidsindex per buurt", ylab="veiligheidsindex")
    grid(nx = 0, ny=NULL)
  })

  #onderstaande observeevents zorgen voor het schakelen tussen de pagina's na profiel selectie.
  # observeEvent(c(input$noAction, input$studentAction, input$aloneAction, input$familyAction, input$retiredAction),{
  #   selectedTab <- switch (input$menu,
  #                          "startPage" = "mapPage")
  #   
  #   #TODO: Fix this function with the correct parameters.
  #   updateAllCheckboxInputGroups()
  #   updateTabItems(session,inputId = "menu", selected = selectedTab)
  # })
  
  
  #onderstaande observeevents zorgen voor het schakelen tussen de pagina's na profiel selectie en het aanvinken van de pre-set checkboxes. 
  observeEvent(input$studentAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    
    resetCheckboxes(session)
    
    #updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices, 
    #                         selected = c("leeftijd_15.65"), inline = FALSE)
    
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
    
    #updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
    #                         , selected = c("leeftijd_van65"), inline = FALSE)
    
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
    
    #updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
    #                         , selected = c("leeftijd_15", "leeftijd_tot15"), inline = FALSE)
    
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
    
    #updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
    #, selected = c("leeftijd_15.65", "leeftijd_tot15"), inline = FALSE)
    
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
})