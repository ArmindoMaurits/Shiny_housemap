#load up the ggmap library
library(ggmap)

#initialise a dataframe to hold the results
geocoded <- data.frame()

#define a function that will process googles server responses for us.
getGeoDetails <- function(buurtnaam){   
  #use the gecode function to query google servers
  geo_reply = geocode(paste0(buurtnaam, ", Rotterdam"), messaging=TRUE)
  #now extract the bits that we need from the returned list
  answer <- data.frame(lat=NA, long=NA)

  #else, extract what we need from the Google server reply into a dataframe:
  answer$lat <- geo_reply$lat
  answer$long <- geo_reply$lon
  
  return(answer)
}

# Start the geocoding process - address by address. geocode() function takes care of query speed limit.
for (buurtnaam in buurten$buurtnaam){
  print(paste("Working on address", buurtnaam))
  #query the google geocoder - this will pause here if we are over the limit.
  result = getGeoDetails(buurtnaam)     
  result$buurtnaam <- buurtnaam
  #append the answer to the results file.
  geocoded <- rbind(geocoded, result)
}

buurten <- merge(buurten,geocoded,by="buurtnaam")
