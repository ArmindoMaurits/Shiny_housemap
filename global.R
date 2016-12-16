#global.R - Global defined variables.
colorPalette <<- c('#a50026','#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850','#006837')
wijken <<- read.csv(paste(getwd(), "datasets/all_data_wijken.csv", sep="/"), sep = ";")
buurten <<- read.csv(paste(getwd(), "datasets/all_data_buurten.csv", sep="/"), sep = ";")

infoIcon <- makeIcon(
  iconUrl = "marker.png",
  iconWidth = 30, iconHeight = 30,
  iconAnchorX = 15, iconAnchorY = 30
)

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
scaleColumnAndMergeToBuurten <- function(columnName){
  normalizedColumnName <- paste(columnName, "_norm", sep="")
  tempDataFrame <- data.frame(buurten$cbs_buurtnummer, normalizeColumn(buurten[[columnName]]))
  colnames(tempDataFrame) <- c("cbs_buurtnummer", normalizedColumnName)
  buurten <<- merge(buurten, tempDataFrame, by.y = "cbs_buurtnummer")
  writeBuurtenCSV()
}

writeBuurtenCSV <- function(){
  write.csv2(buurten, file = paste(getwd(), "/datasets/all_data_buurten.csv", sep=""), row.names = F)
}

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