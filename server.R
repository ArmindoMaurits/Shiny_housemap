library(shiny)
library(shinydashboard)
library(leaflet)

source('global.R')

shinyServer(function(input, output, session) {
  session$onSessionEnded(stopApp)

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
      
    }

    infoIcon <- makeIcon(
      iconUrl = "marker.png",
      iconWidth = 30, iconHeight = 30,
      iconAnchorX = 15, iconAnchorY = 30
    )

    for (buurt in buurten$buurtnaam) {
      content <- paste0('<div style="width: 250px;">
                          <h4>', buurt,' - ',buurten$wijknaam[buurten$buurtnaam == buurt],'</h4>
                          <table style="width:100%">
                            <tr>
                              <th>Onderwerp</th>
                              <th>Score</th>
                            </tr>
                            <tr>
                              <td>Leeftijd tot 15 jaar</td>
                              <td>',buurten$leeftijd_tot15[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Leeftijd van 15 tot 65 jaar</td>
                              <td>',buurten$leeftijd_15.65[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Leeftijd vanaf 65 jaar</td>
                              <td>',buurten$leeftijd_van65[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Autochtoon</td>
                              <td>',buurten$autochtoon[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Allochtoon en werkende</td>
                              <td>',buurten$allochtoon_w[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Allochtoon en niet-werkende</td>
                              <td>',buurten$allochtoon_nw[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid binnensport</td>
                              <td>',buurten$aanwezigheid_binnensport[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid sportveld</td>
                              <td>',buurten$aanwezigheid_sportveld[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid basisscholen</td>
                              <td>',buurten$aanwezigheid_basisscholen[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal basischolen</td>
                              <td>',buurten$aantal_basisscholen[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid middelbarescholen</td>
                              <td>',buurten$aanwezigheid_middelbarescholen[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal vmbo scholen</td>
                              <td>',buurten$aantal_vmboschool[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal havo/vwo scholen</td>
                              <td>',buurten$aantal_hav.vwoschool[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid parkeergelegenheid</td>
                              <td>',buurten$aanwezigheid_parkeergelegenheid[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid eigen parkeerplaats</td>
                              <td>',buurten$aanwezigheid_eigenparkeerpl[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aanwezigheid openbaar vervoer</td>
                              <td>',buurten$aanwezigheid_ov[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal bushaltes</td>
                              <td>',buurten$aantal_bushaltes[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal bushaltes binnen de norm afstand</td>
                              <td>',buurten$norm_bushalte[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal tramhaltes</td>
                              <td>',buurten$aantal_tramhaltes[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal tramhaltes binnen de norm afstand</td>
                              <td>',buurten$norm_tramhalte[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal metrostations</td>
                              <td>',buurten$aantal_metrostations[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Aantal metrostations binnen de norm afstand</td>
                              <td>',buurten$norm_metrostation[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Veiligheids index subjectief</td>
                              <td>',buurten$veiligheidsindex_sub[buurten$buurtnaam == buurt],'</td>
                            </tr>
                            <tr>
                              <td>Veiligheids index objectief</td>
                              <td>',buurten$veiligheidsindex_ob[buurten$buurtnaam == buurt],'</td>
                            </tr>
                          </table>
                        </div>')
      map <<- addMarkers(map, lng=buurten$long[buurten$buurtnaam == buurt], lat=buurten$lat[buurten$buurtnaam == buurt], layerId=buurt, popup = content, icon = infoIcon)
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

resetCheckboxes <- function(session){
  updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
                           , selected = NULL, inline = FALSE)
  
  updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
                           , selected = NULL, inline = FALSE)
  
  updateCheckboxGroupInput(session, "schools", label = "Scholen",  choices = schoolBoxChoices
                           , selected = NULL, inline = FALSE)
  
  updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
                           , selected = NULL, inline = FALSE)
  
  updateCheckboxGroupInput(session, "origin", label = "Herkomst",  choices = originBoxChoices
                           , selected = NULL, inline = FALSE)
  
  updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer",  choices = publicTransportBoxChoices
                           , selected = NULL, inline = FALSE)
}

#Normalize a given column to a range from 0 to 10
normalizeColumn <- function(column) {
  library("scales")
  scaled <- round(rescale(column)*10)
}

calculateMultipleColumns <- function(desiredColumns){
  iterator <- 1
  
  for(columnName in desiredColumns){
    if(iterator == 1){
      tempDataFrame <<- data.frame(buurten[, columnName])
    }else{
      tempDataFrame[, columnName] <<- buurten[, columnName]
    }
    iterator <- iterator+1
  }
  
  tempDataFrame[, "sum"] <<- rowSums(tempDataFrame)
  tempDataFrame[, "total"] <<- round((tempDataFrame$sum / (ncol(tempDataFrame)-1)))
}

#Plots all buurten with the colour of a given column from the buurten data.frame
plotBuurtenWithColumn <- function(column){
  wd <- getwd()
  
  for(buurtNummer in buurten$cbs_buurtnummer){
    buurtenFolder <- paste(wd, "/geojsons/buurten/", sep = "")
    fileName <- paste(buurtNummer, ".json", sep="")
    json <- readLines(paste(buurtenFolder, fileName, sep="")) %>% paste(collapse = "\n")
    map <<- addGeoJSON(map, json, weight = 2, color = "grey", fillColor =  colorPalette[column[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
  }
}

plotBuurtenWithMultipleColumns <- function(desiredColumns){
  wd <- getwd()
  calculateMultipleColumns(desiredColumns)

  for(buurtNummer in buurten$cbs_buurtnummer){
    buurtenFolder <- paste(wd, "/geojsons/buurten/", sep = "")
    fileName <- paste(buurtNummer, ".json", sep="")
    json <- readLines(paste(buurtenFolder, fileName, sep="")) %>% paste(collapse = "\n")
    
    map <<- addGeoJSON(map, json, weight = 2, color = "gray", fillColor =  colorPalette[tempDataFrame$total[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
  }
}

#
#tempDataFrame <- data.frame(buurten$cbs_buurtnummer, normalizeColumn(buurten$wozwaarde))
#colnames(tempDataFrame) <- c("cbs_buurtnummer", "wozwaarde_norm")
#buurten <- merge(buurten, tempDataFrame, by.y = "cbs_buurtnummer")
#write.csv2(buurten, file = paste(getwd(), "/datasets/all_data_buurten.csv", sep=""), row.names = F)
#

addGeoJsonByNumberAndCategory <- function(nummer, category){
  if(category == "wijken"){
    folderLocation <- paste(getwd(), "/geojsons/wijken/", sep = "")  
  }else{
    folderLocation <- paste(getwd(), "/geojsons/buurten/", sep = "")
  }
  
  fileName <- paste(nummer, ".json", sep="")
  fileLocation <-paste(folderLocation, fileName, sep="")
  json <- readLines(fileLocation) %>% paste(collapse = "\n")
  
  return(json)
}

#Delfshaven - http://thesaurus.erfgeo.nl/pit/?id=gemeentegeschiedenis-geometries/Delfshaven-1812
addGeoJsonFromDatasetToMap<- function(datasetName, columnName){
  wd <- getwd()
  
  if(datasetName == "wijken"){
    for(wijknummer in wijken$cbs_wijknummer){
      wijkenFolder <- paste(wd, "/geojsons/wijken/", sep = "")
      fileName <- paste(wijknummer, ".json", sep="")
      
      json <- readLines(paste(wijkenFolder, fileName, sep="")) %>% paste(collapse = "\n")
      
      map <<- addGeoJSON(map, json, weight = 2, color = "#000", fill = T)
    }
  }else{
    
    for(buurtNummer in buurten$cbs_buurtnummer){
      buurtenFolder <- paste(wd, "/geojsons/buurten/", sep = "")
      fileName <- paste(buurtNummer, ".json", sep="")
      
      json <- readLines(paste(buurtenFolder, fileName, sep="")) %>% paste(collapse = "\n")
      map <<- addGeoJSON(map, json, weight = 2, color = colorPalette[buurten$veiligheidsindex_sub_norm[buurten$cbs_buurtnummer == buurtNummer]+1], fillColor =  colorPalette[buurten$veiligheidsindex_sub_norm[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
    }
  }
}
