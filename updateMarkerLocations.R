observeEvent(input$map_click, {
  click<-input$map_click
  if(is.null(click))
    return()
  buurten$long[buurten$buurtnaam == lastMarker] <<- click$lng
  buurten$lat[buurten$buurtnaam == lastMarker] <<- click$lat
  write.csv(buurten, file = paste(getwd(), "/datasets/all_data_buurten.csv", sep=""), row.names = F)
})

observeEvent(input$map_marker_click, {
  click<-input$map_marker_click
  if(is.null(click))
    return()
  lastMarker <<- click$id
})