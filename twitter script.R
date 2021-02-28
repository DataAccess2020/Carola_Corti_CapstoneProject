library(rtweet)
library(readtext)
library(quanteda)
library(ggplot2)
library(ggmap)
library(httpuv)
library(dplyr)
library(maps)
library(leaflet)
library(stringr)
library(rtweet)

### interacting with both twitter and Google Maps APIs

api <- "AIzaSyBgzA4GK6xdVyMqTRplawcqJ0iwar6OEnU"


lookup_coords("india", apikey = api) 

#   rt <- search_tweets( "smart city", n = 1000, geocode = lookup_coords("india"))

#   rt
#   0
#   AIzaSyBgzA4GK6xdVyMqTRplawcqJ0iwar6OEnU

rt

## create lat/lng variables 

rtll <- lat_lng(rt)

## write as csv the file 

write_as_csv(rtll, "rtll.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")

## read my csv 

sctwitter <- read.csv("rtll.csv", fileEncoding = "UTF-8")


## created at 

since <- sctwitter$created_at[100]
latest <- sctwitter$created_at[1]
cat("Twitter data","\n",paste("From:",since),"\n",paste(" To:",latest))


## plot via leaflet

m2 <- leaflet(rtll)
m2 <- addTiles(m2) 
m2 <- addMarkers(m2, lng=sctwitter$lng, lat=sctwitter$lat, popup=sctwitter$text)
m2




