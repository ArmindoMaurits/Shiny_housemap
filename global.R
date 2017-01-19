#global.R - Global defined variables.
library(leaflet)
 
# Colorpalette used in the legenda
colorPalette <- c('#a50026','#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850','#006837')
buurten2014 <- read.csv(paste(getwd(), "datasets/all_data_buurten_2014.csv", sep="/"), sep = ",")
buurten2016 <- read.csv(paste(getwd(), "datasets/all_data_buurten_2016.csv", sep="/"), sep = ",")

infoIcon <- makeIcon(
  iconUrl = "marker.png",
  iconWidth = 30, iconHeight = 30,
  iconAnchorX = 15, iconAnchorY = 30
)

# Column titles shown in the infowindow, this link the selected column tot the right title
columnTitles <- list("leeftijd_tot15_norm"="Tot 15 jaar",
                     "leeftijd_15.65_norm"="Tussen 15 en 65 jaar",
                     "leeftijd_van65_norm"="Ouder dan 65 jaar",
                     "autochtoon_norm" = "Autochtoon",
                     "allochtoon_w_norm" ="Allochtoon",
                     "aanwezigheid_binnensport_norm" = "Aanwezigheid binnensport",
                     "aanwezigheid_sportveld_norm" ="Aanwezigheid sportvelden",
                     "aanwezigheid_parkeergelegenheid_norm" ="Aanwezigheid parkeergelegenheid",
                     "aanwezigheid_eigenparkeerpl_norm" ="Aanwezigheid eigenparkeerplek",
                     "internetsnelheid_norm" = "Internetsnelheid",
                     "wozwaarde_norm" = "WOZ waarde",
                     "aantal_basisscholen_norm" = "Aantal basisscholen",
                     "aantal_vmboschool_norm" ="Aantal vmbo scholen",
                     "aantal_hav.vwoschool_norm" ="Aantal havo/vwo scholen",
                     "aantal_bushaltes_norm" = "Aantal bushaltes",
                     "aantal_tramhaltes_norm" ="Aantal tramhaltes",
                     "aantal_metrostations_norm" ="Aantal metrostations",
                     "veiligheidsindex_sub_norm" = "Veiligheidsindex subjectief",
                     "veiligheidsindex_ob_norm" ="Veiligheidsindex objectief")

# Sets the choices for each checkbox, corresponds tot the column names from the dataset
ageBoxChoices <- c("Tot 15 jaar" = "leeftijd_tot15_norm",
                   "Tussen 15 en 65 jaar" = "leeftijd_15.65_norm",
                   "Ouder dan 65 jaar" = "leeftijd_van65_norm")
originBoxChoices <- c("Autochtoon" = "autochtoon_norm", "Allochtoon" ="allochtoon_w_norm")
servicesBoxChoices <- c("Binnensport" = "aanwezigheid_binnensport_norm","Sportvelden" ="aanwezigheid_sportveld_norm",
                        "Parkeergelegenheid" ="aanwezigheid_parkeergelegenheid_norm","Eigen parkeerplekken" ="aanwezigheid_eigenparkeerpl_norm", "Internetsnelheid" = "internetsnelheid_norm", "WOZ waarde" = "wozwaarde_norm")
schoolBoxChoices <- c("Basisscholen" = "aantal_basisscholen_norm", "VMBO-scholen" ="aantal_vmboschool_norm","HAVO/VWO-scholen" ="aantal_hav.vwoschool_norm")
publicTransportBoxChoices <- c( "Aantal bushaltes" = "aantal_bushaltes_norm","Aantal tramhaltes" ="aantal_tramhaltes_norm",
                                "Aantal metrostations" ="aantal_metrostations_norm")
safetyIndexBoxChoices <- c("Veiligheidsindex subjectief" = "veiligheidsindex_sub_norm", "Veiligheidsindex objectief" ="veiligheidsindex_ob_norm")

#normalize given column, merge this to the buurten dataset and write a new CSV.
#columnName = Name of the column that has to be scaled.
#loadFromDatasetYear = The year from which dataset the column has to be loaded
#writeToDatasetYear = The year to which dataset the column has to be written
scaleColumnAndMergeToBuurten <- function(columnName, loadFromDatasetYear, writeToDatasetYear){
  if(loadFromDatasetYear == 2014){
    loadBuurten2014()
  }else{
    loadBuurten2016()
  }
  
  normalizedColumnName <- paste(columnName, "_norm", sep="")
  tempDataFrame <- data.frame(buurten$cbs_buurtnummer, normalizeColumn(buurten[[columnName]]))
  colnames(tempDataFrame) <- c("cbs_buurtnummer", normalizedColumnName)
  buurten[[normalizedColumnName]] <- tempDataFrame[[normalizedColumnName]]
  
  writeDatasetToCSV(buurten, writeToDatasetYear)
}

writeBuurten2014CSV <- function(){
  write.csv(buurten, file = paste(getwd(), "/datasets/all_data_buurten_2014.csv", sep=""), row.names = F)
}

writeDatasetToCSV <- function(data, year){
  fileName <- paste("datasets/all_data_buurten_", year, sep="")
  fileName <- paste(fileName, ".csv", sep="")
  fullPath <- paste(getwd(), fileName, sep="/")
  print(fullPath)
  write.csv(data, file = fullPath, row.names = F)
}

writeBuurten2016CSV <- function(){
  write.csv(buurten, file = paste(getwd(), "/datasets/all_data_buurten_2016.csv", sep=""), row.names = F)
}

loadBuurten2014 <- function(){
  buurten2014 <<- read.csv(paste(getwd(), "datasets/all_data_buurten_2014.csv", sep="/"), sep = ",")
  buurten <<- buurten2014
}

loadBuurten2016 <- function(){
  buurten2016 <<- read.csv(paste(getwd(), "datasets/all_data_buurten_2016.csv", sep="/"), sep = ",")
  buurten <<- buurten2016
}

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

# Plot the selected columns with the GeoJSON function from leaflet,
# Give each contour a background color corresponding to the normalised columns value
plotBuurtenWithMultipleColumns <- function(desiredColumns){
  wd <- getwd()
  calculateMultipleColumns(desiredColumns)
  
  for(buurtNummer in buurten$cbs_buurtnummer){
    buurtenFolder <- paste(wd, "/geojsons/buurten/", sep = "")
    fileName <- paste(buurtNummer, ".json", sep="")
    json <- readLines(paste(buurtenFolder, fileName, sep="")) %>% paste(collapse = "\n")
    
    map <<- addGeoJSON(map, json, weight = 2, color = 'gray', fillColor =  colorPalette[tempDataFrame$total[buurten$cbs_buurtnummer == buurtNummer]+1] , fill = T, stroke=T,opacity = 1, fillOpacity=0.75)
  }
}

# Add markers for each neighbourhood to the map
# Fill the infowindow with raw values from the selected columns inside a table
addMarkersToMap <- function(desiredColumns){
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
    
    # vul content en addmarkers
    map <<- addMarkers(map, lng=buurten$long[buurten$buurtnaam == buurt], lat=buurten$lat[buurten$buurtnaam == buurt], layerId=buurt, popup = content, icon = infoIcon)
  }
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

normalizeNAColumnsIn2014Dataset <- function(){
  for(columnName in names(buurten2014)){
    column <- buurten2014[columnName]
    columnDataName <- substr(columnName ,1, nchar(columnName)-5)
    
    if(all(is.na(column))){
      columnData <- buurten2014[columnDataName]
      
      scaleColumnAndMergeToBuurten(columnDataName, 2014, 2014)
    }
  }
}
