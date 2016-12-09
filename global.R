#global.R - Global defined variables.
colorPalette <<- c('#a50026','#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850','#006837')
wijken <<- read.csv(paste(getwd(), "datasets/all_data_wijken.csv", sep="/"), sep = ";")
buurten <<- read.csv(paste(getwd(), "datasets/all_data_buurten.csv", sep="/"), sep = ";")

ageBoxChoices <- c("Tot 15 jaar" = "age_until15","Tussen 15 en 65 jaar" = "age_between15and65",
                   "Ouder dan 65 jaar" = "age_olderThan65")
originBoxChoices <- c("Autochtoon" = "origin_native", "Allochtoon" ="origin_ethnicMinority")
servicesBoxChoices <- c("Binnensport" = "services_insideFields","Sportvelden" ="services_outsideFields",
                        "Parkeergelegenheid" ="services_parkingLots","Eigen parkeerplekken" ="services_parkingLotsOwn")
schoolBoxChoices <- c("Basisscholen" = "schools_elementary","Middelbarescholen" ="schools_secundary",
                      "VMBO-scholen" ="schools_secundary_vmbo","HAVO/VWO-scholen" ="schools_secundary_havo_vwo")
publicTransportBoxChoices <- c( "Aantal bushaltes" = "publicTransport_busStops","Aantal tramhaltes" ="publicTransport_tramStops",
                                "Aantal metrostations" ="publicTransport_subwayStations")
safetyIndexBoxChoices <- c("Veiligheidsindex subjectief" = "safetyIndex_subjective", "Veiligheidsindex objectief" ="safetyIndex_objective")

