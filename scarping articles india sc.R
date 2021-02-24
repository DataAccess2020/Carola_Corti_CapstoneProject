#let's inspect the "urbanet" site -> to scrape the articles about india sc criticism 


library(rvest)
library(tidyverse)


url <-"https://www.urbanet.info/tag/india/" 

download.file(url, destfile = here::here ("mypage.html"))


smart_c_debate <- read_html(here::here("mypage.html")) %>%
  html_nodes(".fusion-post-content-wrapper div div :nth-child(1)") %>%
  html_text()

smart_c_debate

#maybe something better 





