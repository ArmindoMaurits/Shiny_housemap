library(shiny)
library(shinydashboard)
library(leaflet)

shinyServer(function(input, output, session) {
  session$onSessionEnded(stopApp)

  initVariables()
  
  output$map <- renderLeaflet({
    map <<- leaflet(data = buurten)
    map <<- addTiles(map)
    map <<- setView(map, 4.477733, 51.92442, zoom = 12)
    map <<- addLegend(map, "bottomright", colors = rev(colorPalette), labels = 10:0,opacity = 1, title = "Totaalscore")

    #plotBuurtenWithColumn(buurten[, input$selectedDataset])

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
      content <- paste0("<div><b>", buurt, "</b></br><p>", buurten$wijknaam[buurten$buurtnaam == buurt], "</p></div>")
      map <<- addMarkers(map, lng=buurten$long[buurten$buurtnaam == buurt], lat=buurten$lat[buurten$buurtnaam == buurt], layerId=buurt, popup = content, icon = infoIcon)
    }

    map  # Show the map
  })

  output$buurtenPlot <- renderPlot({
    barplot(buurten$veiligheidsindex_sub_norm, names=buurten$buurtnaam, las=2, col=colorPalette[buurten$veiligheidsindex_sub_norm+1], main="Veiligheidsindex per buurt", ylab="veiligheidsindex")
    grid(nx = 0, ny=NULL)
  })
})

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
    
    map <<- addGeoJSON(map, json, weight = 2, color = colorPalette[tempDataFrame$total[buurten$cbs_buurtnummer == buurtNummer]+1], fillColor =  colorPalette[tempDataFrame$total[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
  }
}

#
#tempDataFrame <- data.frame(buurten$cbs_buurtnummer, normalizeColumn(buurten$aantal_hav.vwoschool))
#colnames(tempDataFrame) <- c("cbs_buurtnummer", "aantal_hav.vwoschool_norm")
#buurten <- merge(buurten, tempDataFrame, by.y = "cbs_buurtnummer")
# write.csv(buurten, file = paste(getwd(), "/datasets/all_data_buurten.csv", sep=""), row.names = F)
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
  buurten <<- read.csv(paste(getwd(), "datasets/all_data_buurten.csv", sep="/"), sep = ",")
  tempDataFrame <<- data.frame()
}