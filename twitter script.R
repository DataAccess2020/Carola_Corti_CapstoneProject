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



# Retriving the tweets via geolocalization interacting with the Google Maps API

rt <- search_tweets( "smart city", n = 1000, lang = "en", include_rts = FALSE, geocode = lookup_coords("india"))
length(rt$text) #774 texts

# Adding latitude and longitude 

rtll <- lat_lng(rt)

# Saving the results of the query in a .csv file 

write_as_csv(rtll, "rtll.csv", prepend_ids = TRUE, na = "", 
             fileEncoding = "UTF-8")




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

# Most frequent ht 

ht <- str_extract_all(sctwitter$text, '#[A-Za-z0-9_]+')
ht <- unlist(ht)
head(sort(table(ht), decreasing = TRUE))


####

# Creating the corpus 

Twittercorp <- corpus(sctwitter)

#Creating the Dfm

to_remove <- c("<", ">", "+", "-")

myDfmtwitt <- dfm(Twittercorp, remove = stopwords("english"), remove_punct = TRUE, remove_numbers=TRUE, tolower = TRUE, stem = TRUE, remove_url = TRUE)%>%
  dfm_remove(to_remove)

# wordcloud for features frequency 

set.seed(100)
textplot_wordcloud(myDfmtwitt , min.count = 6, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))

