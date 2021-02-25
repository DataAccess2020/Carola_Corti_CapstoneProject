#######################################################
#######################################################

# let's inspect the "urbanet" site -> to scrape the articles about india smart cities criticism 
# url is this one -->  https://www.urbanet.info/tag/india/
# intent to scrape the articles to lead text analysis in quanteda + sentiment analysis + dictionary analysis
# + topic analysis to discuss how it is perceived 

#######################################################
#######################################################


# robots.txt already inspected: I am allowed to do it!! 

library(rvest)
library(tidyverse)

url <-"https://www.urbanet.info/tag/india/" 

download.file(url, destfile = here::here ("mypage.html"))

smart_c_debate <- read_html(here::here("mypage.html")) %>%
  html_nodes("#posts-container :nth-child(1)") %>%
  html_text()

smart_c_debate

#EXTRACTING JUST THE CONTENT IN THE OREVIEW OF THE ARTICLES: OK 

smart_c_debate_content <- read_html(here::here("mypage.html")) %>%
  html_nodes (".fusion-post-content-container p") %>%
  html_text()
 
smart_c_debate_content


# CORPUS IN QUANTEDA 

library(quanteda)
mycorp <-corpus(smart_c_debate)



myDfm <- dfm(mycorp , remove = stopwords("english"), tolower = TRUE,
             remove_punct = TRUE, remove_numbers=TRUE, remove_symbols=TRUE)

textplot_wordcloud(myDfm ,
                   color = c('black', 'red', 'green', 'purple', 'orange', 'blue'))





