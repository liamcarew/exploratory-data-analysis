library(dplyr)
library(ggplot2)
library(sf)
library(leaflet)

# read in data on informal settlements in Cape Town
# source: https://open.africa/dataset/city-of-cape-town-gis-data
ct_inf <- st_read("spatial-data/data/informal.shp") 

# read in data with quarter degree grid cells
ct_qdgc <- st_read("spatial-data/data/pent_sa_mini.shp")

# extract center of each informal settlement polygon
ct_inf_center <- st_centroid(ct_inf)

# convert to lat-long coordinates 
# (the st_zm() is not usually needed, here fixes a weird error)
ct_inf <- ct_inf %>% st_transform(crs = 4326) %>% st_zm()
ct_inf_center <- ct_inf_center %>% st_transform(crs = 4326) 

# plot a "base map" only
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) 

# plot the informal settlement polygons
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf) 

# plot the informal settlement polygons shaded by Traveltime
pal <- colorNumeric("Blues", domain = ct_inf$Traveltime)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Traveltime), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~Traveltime) 

# EXERCISE: shade the polygons by the number of households (HHs), or the predominant age (Predom_Age)

#HHs
pal <- colorNumeric("Blues", domain = ct_inf$HHs)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(HHs), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~HHs)

#Predom_Age

#handle missing values using imputation of mode value or removal

#removal
ct_inf$Predom_Age <- !is.na(ct_inf$Predom_Age)
pal <- colorNumeric("Blues", domain = ct_inf$Predom_Age)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Predom_Age), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~ Predom_Age)

# add markers for each settlement
pal <- colorNumeric("Blues", domain = ct_inf$Traveltime)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Traveltime), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~Traveltime) %>% 
  addMarkers(data = ct_inf_center)

# use the "popup" and "label" arguments to addMarkers so that the settlement name
# is displayed on a mouseclick (InformalSe) and the travel time is shown on mouse over (Traveltime)

pal <- colorNumeric("Blues", domain = ct_inf$Traveltime)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Traveltime), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~Traveltime) %>%
  addMarkers(data = ct_inf_center, popup = ~InformalSe, label = ~as.character(Traveltime))
  
# EXERCISE: overlay the quarter-degree grid cells in the ct_qdgc dataset

pal <- colorNumeric("Blues", domain = ct_inf$Traveltime)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Traveltime), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~Traveltime) %>%
  addMarkers(data = ct_inf_center, popup = ~InformalSe, label = ~as.character(Traveltime)) %>%
  addPolygons(data = ct_qdgc)

# EXERCISE: count how many informal settlements are in each grid cell, and 
# shade each grid cell by the number of informal settlements it contains

##COME BACK TO THIS ONE

pal <- colorNumeric("YlOrRd", domain = ct_inf$Traveltime)
leaflet() %>% 
  addProviderTiles("Esri.WorldStreetMap") %>%
  setView(lng = 18.4241, lat = -33.9249, zoom = 10) %>%
  addPolygons(data = ct_inf, color = ~pal(Traveltime), fillOpacity = 1) %>%
  addLegend(data = ct_inf, pal = pal, values = ~Traveltime) %>%
  addMarkers(data = ct_inf_center, popup = ~InformalSe, label = ~as.character(Traveltime)) %>%
  addPolygons(data = ct_qdgc, fillColor = ~pal(ct_inf), fillOpacity = 1)

# EXERCISE (unrelated to the above): work through the application in Ch 13 of 
# Geocomputation with R (https://geocompr.robinlovelace.net/location.html)

#in 'Geocomputation-in-R.Rmd' file