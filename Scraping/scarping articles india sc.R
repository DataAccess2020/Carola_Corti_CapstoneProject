##########################################################
##########################################################
##                                                      ##
##  inspect + scrape the "FINANCIAL EXPRESS" site       ##
##  to scrape the articles about smart cities in India  ##
##                                                      ##
##                                                      ##
##########################################################
##########################################################

browseURL("https://www.financialexpress.com/robots.txt")


# 1) Robots.txt already inspected: I am allowed to scrape! I have now to ask politely using rvest + httr   

library(stringr)
library(httr)
library(rvest)

  url <-"https://www.financialexpress.com/about/smart-cities/ "


  
  session <- RCurl::getURL(url, 
                        useragent = str_c(R.version$platform,
                                          R.version$version.string,
                                          sep = ", "),
                        httpheader = c(From = "barosa.carola@gmail.com"))
  
  

#get the titles

page <- read_html(x = "https://www.financialexpress.com/about/smart-cities/")
nodes <- html_nodes(x = page, css = "h3 a")
html_text(x = nodes)

#download and get the links

link_to_pages <- str_c("https://www.financialexpress.com/about/smart-cities/page/", 1:5)
dir.create("SmartCityArticles")

for(i in seq_along(link_to_pages)) {
  download.file(url = link_to_pages[i], destfile = here::here("SmartCityArticles", str_c("page", i, ".html")))
  Sys.sleep(1)
}

out <- vector(mode = "list", length = 5)

for(i in seq_along(link_to_pages)) {
  out[[i]]<-read_html(x = here::here("SmartCityArticles", str_c("page", i, ".html")))%>%
    html_nodes(css="h3 a")%>%
    html_attr("href")
}

out

#scrape main text 

text<- rep(list(vector(mode="list", length = 27)), 5)
View(text)
for(z in 1:5){
  text[[z]][1:27] <- read_html(link_to_pages[z]) %>% 
    html_nodes("h4") %>% 
    html_text()
}

text
View(text)

texts <- unlist(text)

texts

#getting the publication date 

date <- rep(list(vector(mode="list", length = 27)), 5)
View(date)
for(t in 1:5){
  date[[t]][1:27] <- read_html(link_to_pages[t]) %>% 
    html_nodes(".minsago") %>% 
    html_text()
}

View(date)
date

dates <- unlist(date)
dates


# putting texts and dates of pubb in a DF 

articles_df <- data.frame(texts, dates)

articles_df

# tidying dates 

library(lubridate)
articles_df$dates <- mdy(articles_df$dates)
articles_df$dates

is.Date(articles_df$dates)

articles_df

# saving the data frame as a .csv (to use it in the next op to create a text via readtext)

articles_docs <- write.csv(articles_df,"articles_docs.csv", row.names = TRUE)

#read .csv

x <- read.csv(file = "articles_docs.csv", header = TRUE)

typeof(x$texts)


#########################################################
#########################################################
###                                                   ###
###        Creating the corpus in Quanteda            ###
###                                                   ###
#########################################################
#########################################################

library(quanteda)
library(quanteda)
library(ggplot2)
library(quanteda.textstats)


# creating the corpus 



# creating the dfm

myDfm <- dfm(Corpus , remove = stopwords("english"), tolower = TRUE, 
             remove_punct = TRUE, remove_numbers=TRUE)

myDfm

# knitr::kable(myDfm[,1:10])

# 20 top features in the dfm
topfeatures(myDfm , 20) 



# frequency of the top features in a text.
features_dfm <- textstat_frequency(myDfm, n = 20)
features_dfm

ggplot(features_dfm, aes(x = feature, y = frequency)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))


# wordcloud 
set.seed(100)
textplot_wordcloud(myDfm , min.count = 6, random.order = FALSE,
                   rot.per = .25, 
                   colors = RColorBrewer::brewer.pal(8,"Dark2"))


