library(shiny)
library(shinydashboard)
library(leaflet)

shinyServer(function(input, output, session) {
  initVariables()
  
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
  observeEvent(c(input$noAction, input$studentAction, input$aloneAction, input$familyAction, input$retiredAction),{
    selectedTab <- switch (input$menu,
                           "startPage" = "mapPage")
    
    #TODO: Fix this function with the correct parameters.
    updateAllCheckboxInputGroups()
    updateTabItems(session,inputId = "menu", selected = selectedTab)
  })  
    
})

updateAllCheckboxInputGroups <- function(selectedProfile, session){
  #Select the right options in the desired checkboxGroupInput
  if(selectedProfile == "aloneAction"){
    #TODO: set the right "selected" values on multiple checkboxGroupInput.
    #updateCheckboxGroupInput(session, inputId, label = NULL, choices = NULL, selected = NULL, inline = FALSE)
  }else if(selectedProfile == "studentAction"){
    
  }else if(selectedProfile == "familyAction"){
    
  }else if(selectedProfile == "retiredAction"){
    
  }
  
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

#Loads all variables into the workspace.
initVariables <- function(){
  colorPalette <<- c('#a50026','#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850','#006837')
  #To view the color palette
  #pie(rep(1, 11), col = colorPalette)
  
  wijken <<- read.csv(paste(getwd(), "datasets/all_data_wijken.csv", sep="/"), sep = ";")
  buurten <<- read.csv(paste(getwd(), "datasets/all_data_buurten.csv", sep="/"), sep = ";")
}