
#data.dwld.r----
#May 8 2023

#Prepares data sample for radial profiles analyses
#Two sets based on GHSL and Copernicus Urban Atlas
#CBD's from own list

#Libraries----
#terra
#sf

#GHSL----
download.file(url = "https://jeodpp.jrc.ec.europa.eu/ftp/jrc-opendata/GHSL/GHS_BUILT_S_GLOBE_R2023A/GHS_BUILT_S_E2020_GLOBE_R2023A_54009_100/V1-0/tiles/GHS_BUILT_S_E2020_GLOBE_R2023A_54009_100_V1_0_R4_C18.zip",
              destfile = "Data/GHSL/GHSL_West.zip")

GHSL_West_dwld <- utils::unzip("Data/GHSL/GHSL_West.zip", exdir = "Data/GHSL")

GHSL_West <- terra::rast(GHSL_West_dwld[1])

centers_CBD <- sf::st_transform (sf::st_read("Data/centers/cbd_europe.gpkg"),
                                 sf::st_crs(GHSL_West))

centers_west <- sf::st_crop(centers_CBD, 
                            terra::ext(GHSL_West))

saveRDS(GHSL_West, "Sample/GHSL_West_Built_m2.rds")
saveRDS(centers_west, "Sample/GHSL_West_CBD.rds")


#Urban Atlas----

#We download the data from the Urban Atlas

download.file(url = "https://land.copernicus.eu/land-files/96dbfd02d38edb48b2d65b3964a816ed92f41c4c.zip",
              destfile = "Data/UA/UA_West.zip")

UA_West_dwld <- utils::unzip("Data/UA/UA_West.zip", exdir = "Data/UA")

land_use <- sf::st_sf(sf::st_sfc(crs = 3035))

for (i in 1:length(UA_West_dwld)){
  
  data <- utils::unzip(UA_West_dwld[i], exdir = "Data/UA")
  
  land_use_city <- sf::st_read(data[1], layer = substr(UA_West_dwld[i],9,nchar(UA_West_dwld[i])-9))
  
  land_use <- rbind(land_use, land_use_city)
}

saveRDS(land_use, "Sample/UA_West.rds")



