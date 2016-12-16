#global.R - Global defined variables.
colorPalette <<- c('#a50026','#d73027','#f46d43','#fdae61','#fee08b','#ffffbf','#d9ef8b','#a6d96a','#66bd63','#1a9850','#006837')
wijken <<- read.csv(paste(getwd(), "datasets/all_data_wijken.csv", sep="/"), sep = ";")
buurten <<- read.csv(paste(getwd(), "datasets/all_data_buurten.csv", sep="/"), sep = ";")

ageBoxChoices <- c("Tot 15 jaar" = "leeftijd_tot15",
                   "Tussen 15 en 65 jaar" = "leeftijd_15.65",
                   "Ouder dan 65 jaar" = "leeftijd_van65")

originBoxChoices <- c("Autochtoon" = "autochtoon", "Allochtoon" ="allochtoon_w")

servicesBoxChoices <- c("Binnensport" = "aanwezigheid_binnensport","Sportvelden" ="aanwezigheid_sportveld",
                        "Parkeergelegenheid" ="aanwezigheid_parkeergelegenheid","Eigen parkeerplekken" ="aanwezigheid_eigenparkeerpl", "Internetsnelheid" = "internetsnelheid_norm", "WOZ waarde" = "wozwaarde_norm")

schoolBoxChoices <- c("Basisscholen" = "aantal_basisscholen_norm", "VMBO-scholen" ="aantal_vmboschool_norm","HAVO/VWO-scholen" ="aantal_hav.vwoschool_norm")

publicTransportBoxChoices <- c( "Aantal bushaltes" = "aantal_bushaltes_norm","Aantal tramhaltes" ="aantal_tramhaltes_norm",
                                "Aantal metrostations" ="aantal_metrostations_norm")

safetyIndexBoxChoices <- c("Veiligheidsindex subjectief" = "veiligheidsindex_sub_norm", "Veiligheidsindex objectief" ="veiligheidsindex_ob_norm")

infoIcon <- makeIcon(
  iconUrl = "marker.png",
  iconWidth = 30, iconHeight = 30,
  iconAnchorX = 15, iconAnchorY = 30
)