#Capstone idea 

#This project aims at collecting information about the discourse above smart cities: 
#I will, first of all, by interacting with the Twitter API, collect and analyze the 
#latest Tweets about smart cities, trying to analyze and discover whether the sentiment 
#related to this debate is positive or negative, which are the most used words and what 
#are the most discussed topics related to it.  I will then focus on India, since it provides,
#on the one hand, clear example of one the most advanced smart cities policy in the world, while,
#on the other hand, representing a sensitive case....... etc 


getwd()
setwd("C:/Users/Carola/Desktop/Capstone project")
getwd()

library(rtweet)
library(readtext)
library(quanteda)
library(ggplot2)
library(ggmap)
library(httpuv)
library(dplyr)
library(stringr)

rt <- search_tweets( "smart city ", n = 2000, lang = "en", include_rts = FALSE)
length(rt$text)

# days covered by our analysis
since <- rt$created_at[100]
latest <- rt$created_at[1]
cat("Twitter data","\n",paste("From:",since),"\n",paste("  To:",latest))

print(rt$text[1:5])


# What are the most popular hashtags at the moment? Using a regular expressions to extract hashtags.
ht <- str_extract_all(rt$text, '#[A-Za-z0-9_]+')
ht <- unlist(ht)
head(sort(table(ht), decreasing = TRUE))

# And who are the most frequently mentioned users?
handles <- str_extract_all(rt$text, '@[0-9_A-Za-z]+')
handles_vector <- unlist(handles)
head(sort(table(handles_vector), decreasing = TRUE), n=10)


# How many tweets mention "India"?
length(grep("india", rt$text, ignore.case=TRUE))


# Saving the results as a .csv file 

# you can then save your results as a csv file
write_as_csv(rt, "twitter.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")


# TS tweets plot 

ts_plot(rt, "1 hours") +
  theme_minimal() +
  theme(plot.title = element_text(face = "bold")) +
  labs(
    x = NULL, y = NULL,
    title = "Frequency of the tweets about smart cities from Feb20 to Feb24",
    subtitle = "Twitter status (tweet) counts aggregated using one-hour intervals",
    caption = "Source: Data collected from Twitter's REST API via rtweet"
  )


# How many locations are there represented between users? 

users <- search_users("smart city", n = 500)
write_as_csv(users, "users.csv", prepend_ids = TRUE, na = "", fileEncoding = "UTF-8")
length(unique(users$user_id))
length(unique(rt$user_id))

length(unique(users$lang))
count(users, lang, sort = TRUE)

length(unique(users$location))
count(users, location, sort = TRUE)


# Plot the top 4 locations 

count <- count(users, location, sort = TRUE)
count <- count [-which(count$location == ""), ]
count <- mutate(count, location = reorder(location, n))
count <- top_n(count, 10)
ggplot(count, aes(x = location, y = n)) +
  geom_col() +
  coord_flip() +
  labs(x = "Count",
       y = "Location",
       title = "Where Twitter users are from - unique locations ")


## search for tweets containing "smart city", including retweets
rtR <- search_tweets("smart city", n = 100)

## plot multiple time series--retweets vs non-retweets
ts_plot(group_by(rtR, is_retweet), "mins")

# What is the most retweeted tweet?
x <- rtR[which.max(rtR$retweet_count),]
print(x$retweet_count)
print(x$text)
print(x$screen_name)




