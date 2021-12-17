library(lubridate)
library(sp)
library(surveillance)
library(mapproj)
library(rdist)
library(sf)
library(mapview)

data_y2d <- read.csv("data/NYPD_Shooting_Incident_Data__Year_To_Date_.csv")

test_date <- as.Date(data_y2d$OCCUR_DATE, format = "%m/%d/%y")

startdate <- as.Date("01/01/2021", "%d/%m/%y")

test_date_number <- difftime(test_date, startdate, units = "days")

test_date_numeric <- as.data.frame(as.numeric(test_date_number))

dt_mat <- dist(test_date_numeric, diag = TRUE, upper = FALSE)

coordinates(data_y2d) <- ~ Longitude + Latitude
proj4string(data_y2d) <- CRS("+init=epsg:4326")
coords <- data.frame(spTransform(data_y2d, CRS("+init=epsg:2263")))
coords_lonlat <- data.frame(coords$Longitude, coords$Latitude)
dist_mat <- dist(coords_lonlat, method = "euclidean", diag = TRUE, upper = FALSE)

knox(dt = dt_mat, ds = dist_mat, eps.t = 3, eps.s = 10)

mapView(data_y2d, xcol = "Longitude", ycol = "Latitude", crs = "+init=epsg:2263")
