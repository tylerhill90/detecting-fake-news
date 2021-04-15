library(shiny)
library(shinyjs)
library(reticulate)
library(tidyverse)
library(shinydashboard)
library(dashboardthemes)
library(tm)
library(SnowballC)
library(highcharter)
library(vdemdata)
library(gtrendsR)
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

# Retrieve data for world map of gov misinfo and assign globally
df_govs <- vdem %>% 
  select(
    country_name,
    year,
    v2mecenefm_mean,    # Government media censorship
    v2smgovdom_mean,    # Government dissemination of false information domestic
    v2smgovab_mean,     # Government dissemination of false information abroad
    v2smpardom_mean,    # Party dissemination of false information domestic
    v2smparab_mean,     # Party dissemination of false information abroad
    v2smfordom_mean     # Foreign governments dissemination of false information
  ) %>% 
  filter(year %in% 2000:2020)
assign("df_govs", df_govs, envir = .GlobalEnv)
