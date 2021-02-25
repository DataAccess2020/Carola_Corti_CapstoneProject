#######################################################
#######################################################

# inspect + scrape the "URBANET" site -> to scrape the articles about smart cities in India 
# url -->  https://www.urbanet.info/tag/india/
# intent to scrape the articles to run text analyses in quanteda + sentiment analysis + dictionary analysis
# + topic analysis 

#######################################################
#######################################################


# 1) Robots.txt already inspected: I am allowed to scrape! I have now to ask politely using rvest + httr   


library(httr)
library(rvest)

url <-"https://www.urbanet.info/tag/india/"
session <- html_session(url, 
                        add_headers(version = version$version.string
                        ))


# 2) Download the URL

download.file(url, destfile = here::here ("mypage.html"))

# 3) Insert the selected CSS path  

Date <- read_html(here::here("mypage.html")) %>%
  html_nodes(".rich-snippet-hidden+ span") %>% html_text()

Article <- read_html(here::here("mypage.html")) %>%
  html_nodes("#posts-container .fusion-alignleft") %>% html_text()

Article
