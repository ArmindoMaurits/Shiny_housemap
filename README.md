# Neighbourhood quality map
This project was build for a Data Science (IT) Minor course for the Hogeschool Rotterdam, build by 3 graduating students with various backgrounds. The goal of the project was to make a neighbourhood quality map based on publically available Open/Big Data, where users can see the quality of their neighbourhood based on some numbers. 

First concept design
![Concept idea](https://drive.google.com/uc?export=download&id=0B-nqiYFaJ3yOUWQ0dDB1UGV3TGc)

### Scope
The scope of this project was neighbourhood data for two years from the city of Rotterdam, because that data was publically available from [RotterdamOpenData](http://rotterdamopendata.nl/dataset). Other datasets have been retreived from the [Wijkprofiel](http://wijkprofiel.rotterdam.nl/nl/2016/rotterdam) website of the municipality of Rotterdam. We have made a selection of columns from all  raw data that seemed interesting to us and that could be used in our webapp. In theory any column of structured data could be loaded, as long as they're based on the CBSbuurtnummer from the [CBS](https://www.cbs.nl/nl-nl/dossier/nederland-regionaal/geografische%20data/wijk-en-buurtkaart-2013) in the Netherlands.

### The app - functionalities
The starting page of this website gives the user an explanation on how to use this webapp and gives the user a selection of user profiles. These profiles differ from one another, because they check different categories and then show the user the map.
On this map people can also manually select or alter checkboxes to show different categories of data. 

- Profile choice
  - Preselect filters based on user profiles
- Filter data
  - Edit selected filters to fit personal needs
- Normalise selected filters
  - Normalise columns and give each neighbourhood a score
- Interactive map
- Information windows
  - Show the raw data based on the selected filters

### Tools
Created with [Shiny](https://shiny.rstudio.com/), [Shiny Dashboard](https://rstudio.github.io/shinydashboard/) and [Leaflet for R](https://rstudio.github.io/leaflet/).

### Live demo
The online demo can be found hosted at [ShinyApps.io](https://amaurits.shinyapps.io/Neighbourhood_quality_map/)

### Screenshots
Startpage
![Startpage](https://drive.google.com/uc?export=download&id=0B-nqiYFaJ3yOdHUxMlh4V3d6OWc)

Main page
![Main page](https://drive.google.com/uc?export=download&id=0B-nqiYFaJ3yOMENDeWNpaTRoUVk)
