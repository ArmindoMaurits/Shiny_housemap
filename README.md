# Neighbourhood quality map
This project was build for a Data Science (IT) Minor course for the Hogeschool Rotterdam, build by 3 graduating students with various backgrounds. The goal of the project was to make a neighbourhood quality map based on publically available Open/Big Data, where users can see the quality of their neighbourhood based on some numbers. 
The scope of this project was neighbourhood data for two years from the city of Rotterdam, because that data was publically available from [RotterdamOpenData](http://rotterdamopendata.nl/dataset). Other datasets have been retreived from the [Wijkprofiel](http://wijkprofiel.rotterdam.nl/nl/2016/rotterdam) website of the municipality of Rotterdam. We have made a selection of columns from all  raw data that seemed interesting to us and that could be used in our webapp. In theory any column of structured data could be loaded, as long as they're based on the CBSbuurtnummer from the [CBS](https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische%20data/wijk-en-buurtkaart-2013) in the Netherlands.

The starting page of this website gives the user an explanation on how to use this webapp and gives the user a selection of user profiles. These profiles differ from one another, because they check different categories and then show the user the map.
On this map people can also manually select or alter checkboxes to show different categories of data. 

Created with [Shiny](https://shiny.rstudio.com/), [Shiny Dashboard](https://rstudio.github.io/shinydashboard/) and [Leaflet for R](https://rstudio.github.io/leaflet/).
