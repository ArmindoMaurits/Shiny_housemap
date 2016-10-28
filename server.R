library(shiny)
library(shinydashboard)
library(leaflet)

shinyServer(function(input, output) {
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
  
  output$menuAge <- renderMenu({
    menuItem("Leeftijd",
             checkboxGroupInput("age", NULL,
                                choices = c(
                                  "Tot 15 jaar" = "age_until15",
                                  "Tussen 15 en 65 jaar" = "age_between15and65",
                                  "Ouder dan 65 jaar" = "age_olderThan65"
                                ),
                                selected = c("age_until15", "age_olderThan65")
             )
    )
  })
  output$menuOrigin <- renderMenu({
    menuItem("Herkomst",
             checkboxGroupInput("origin", NULL,
                                choices = c(
                                  "Autochtoon" = "origin_native",
                                  "Allochtoon" ="origin_ethnicMinority"
                                ),
                                selected = c("origin_native","origin_ethnicMinority")
             )
    )
  })
  output$menuServices <- renderMenu({
    menuItem("Voorzieningen",
             checkboxGroupInput("services", NULL,
                                choices = c(
                                  "Binnensport" = "services_insideFields",
                                  "Sportvelden" ="services_outsideFields",
                                  "Parkeergelegenheid" ="services_parkingLots",
                                  "Eigen parkeerplekken" ="services_parkingLotsOwn"
                                )
             )
    )
  })
  output$menuSchools <- renderMenu({
    menuItem("Scholen",
             checkboxGroupInput("schools", NULL,
                                choices = c(
                                  "Basisscholen" = "schools_elementary",
                                  "Middelbarescholen" ="schools_secundary",
                                  "VMBO-scholen" ="schools_secundary_vmbo",
                                  "HAVO/VWO-scholen" ="schools_secundary_havo_vwo"
                                )
             )
    )
  })
  output$menuPublicTransport <- renderMenu({
    menuItem("Openbaarvervoer",
             checkboxGroupInput("publicTransport", NULL,
                                choices = c(
                                  "Aantal bushaltes" = "publicTransport_busStops",
                                  "Aantal tramhaltes" ="publicTransport_tramStops",
                                  "Aantal metrostations" ="publicTransport_subwayStations"
                                )
             )
    )
  })
  output$menuSafetyIndex <- renderMenu({
    menuItem("Veiligheidsindex",
             checkboxGroupInput("safetyIndex", NULL,
                                choices = c(
                                  "Veiligheidsindex subjectief" = "safetyIndex_subjective",
                                  "Veiligheidsindex objectief" ="safetyIndex_objective"
                                )
             )
    )
  })
})

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