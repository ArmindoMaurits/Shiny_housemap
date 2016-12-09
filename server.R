library(shiny)
library(shinydashboard)
library(leaflet)

source('global.R')

shinyServer(function(input, output, session) {
  output$map <- renderLeaflet({
    map <<- leaflet(data = wijken)
    map <<- addTiles(map)
    map <<- setView(map, 4.477733, 51.92442, zoom = 12)
    map <<- addLegend(map, "bottomright", colors = rev(colorPalette), labels = 10:0,opacity = 1, title = "Totaalscore")
    
    plotBuurtenWithColumn(buurten[, input$selectedDataset])
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
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices, 
                             selected = c("Tussen 15 en 65 jaar"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices, 
                             selected = c("Veiligheidsindex objectief"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer", choices = publicTransportBoxChoices, 
                             selected = c("Aantal bushaltes", "Aantal tramhaltes", "Aantal metrostations"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
                             , selected = c("Internetsnelheid"), inline = FALSE)
  
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })
  
  
        #gepensioneerd selects! 
  
  
  observeEvent(input$retiredAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
                             , selected = c("Ouder dan 65 jaar"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
                             , selected = c("Veiligheidsindex subjectief", "Veiligheidsindex objectief"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
                             , selected = c("Binnensport","Parkeergelegenheid","Eigen parkeerplekken", "WOZ waarde"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer",  choices = publicTransportBoxChoices
                             , selected = publicTransportBoxChoices, inline = FALSE)
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })    
  
  observeEvent(input$aloneAction,{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
                             , selected = c("Tussen 15 en 65 jaar", "Tot 15 jaar"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
                             , selected = c("Veiligheidsindex objectief"), inline = FALSE)

    updateCheckboxGroupInput(session, "publicTransport", label = "Openbaarvervoer",  choices = publicTransportBoxChoices
                             , selected = publicTransportBoxChoices, inline = FALSE)
    
    
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })    
  
  observeEvent(input$familyAction,{
    selectedTab <- switch (input$menu,
                          "startPage" = "mapPage")
    
    resetCheckboxes(session)
    
    updateCheckboxGroupInput(session, "age", label = "Leeftijd", choices = ageBoxChoices
    , selected = c("Tussen 15 en 65 jaar", "Tot 15 jaar"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "safetyIndex", label = "Veiligheidsindex", choices = safetyIndexBoxChoices
    , selected = c("Veiligheidsindex objectief"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "schools", label = "Scholen",  choices = schoolBoxChoices
    , selected = c("Basisscholen", "Middelbarescholen"), inline = FALSE)
    
    updateCheckboxGroupInput(session, "services", label = "Voorzieningen",  choices = servicesBoxChoices
    , selected = c("Binnensport", "Sportvelden", "WOZ waarde"), inline = FALSE)

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

# selectedColumns <- c(aantal_bushaltes_norm = "aantal_bushaltes_norm", veiligheidsindex_sub_norm = "veiligheidsindex_sub_norm")
# tempDataFrame <- data.frame()


# 
# for(columnName in selectedColumns){
#   print(columnName)
#   selectedColumnFromBuurten <- buurten[, columnName]
#   tempDataFrame[, columnName] <- selectedColumnFromBuurten
# }
# 
# #testFunction(aantal_bushaltes_norm = "aantal_bushaltes_norm", veiligheidsindex_sub_norm = "veiligheidsindex_sub_norm")
# testFunction <- function(...){
#   tempDataFrame <- data.frame()
# 
#   for(columnName in names(list(...))){
#   
#     iterator <- 1
#     tempDataFrame[, columnName] <<- buurten[, columnName]
#     #Get column
#     # column<- buurten[, columnName]
#     # #Get entry on index in column
#     # entry <- column[iterator]
#     # #Put entry in new data.frame on position of iterator
#     #
#     # print(columnName)
#   }
# 
# }


#Plots all buurten with the colour of a given column from the buurten data.frame
plotBuurtenWithColumn <- function(column){
  wd <- getwd()
  
  for(buurtNummer in buurten$cbs_buurtnummer){
    buurtenFolder <- paste(wd, "/geojsons/buurten/", sep = "")
    fileName <- paste(buurtNummer, ".json", sep="")
    json <- readLines(paste(buurtenFolder, fileName, sep="")) %>% paste(collapse = "\n")
    map <<- addGeoJSON(map, json, weight = 2, color = colorPalette[column[buurten$cbs_buurtnummer == buurtNummer]+1], fillColor =  colorPalette[column[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
  }
}

#
#tempDataFrame <- data.frame(buurten$cbs_buurtnummer, normalizeColumn(buurten$aantal_hav.vwoschool))
#colnames(tempDataFrame) <- c("cbs_buurtnummer", "aantal_hav.vwoschool_norm")
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
