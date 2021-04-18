library(shiny)
library(shinyjs)
library(shinyalert)
library(shinydashboard)
library(dashboardthemes)
library(reticulate)
library(stringr)
library(dplyr)
library(tm)
library(SnowballC)
library(highcharter)
library(xts)

# Func to process article text for analysis
process_text <- function(text) {
  # Remove emojis, hashtags, and usernames
  text <- gsub("[^[:ascii:]]|#[^\\s]*|@[^\\s]*", "", text, perl=T)
  # Create Corpus object
  text_corp <- Corpus(VectorSource(text))
  
  # COnvert to lowercase
  text_corp <- tm_map(text_corp, content_transformer(tolower))
  # Remove numbers, stopwords, and punctuation
  text_corp <- tm_map(text_corp, removeNumbers)
  text_corp <- tm_map(text_corp, removeWords, stopwords("english"))
  text_corp <- tm_map(text_corp, removePunctuation)
  # Strip whitespace
  text_corp <- tm_map(text_corp, stripWhitespace)
  # Perform word stemming
  text_corp <- tm_map(text_corp, stemDocument)
  # Build Document Matrix
  text_dm <- TermDocumentMatrix(text_corp)
  dm <- as.matrix(text_dm)
  # Sort by descending value
  dm_v <- sort(rowSums(dm),decreasing=TRUE)
  dm_df <- data.frame(word = names(dm_v),freq=dm_v)
  
  return(dm_df)
}

# Retrieve data for world map of gov misinfo 
df_govs <<- read.csv("vdem_data.csv")

# Retrieve the data for google trends data 
df_gtrends <- read.csv("gtrends_data.csv")
df_gtrends <<- df_gtrends %>%
  mutate(date = as.Date(date))
