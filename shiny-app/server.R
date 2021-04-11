# Shiny app server

library(shiny)
library(shinyjs)
library(tidyverse)
library(highcharter)
library(tm)
library(SnowballC)
library(reticulate)

# Python resources
virtualenv_create(envname = "python_environment", python= "python3")
virtualenv_install("python_environment", packages = c(
  "joblib", "pandas", "numpy", "python-dateutil", "pytz", "scikit-learn", "scipy", "six", "sklearn", "threadpoolctl"
))
reticulate::use_virtualenv("python_environment", required = TRUE)
source_python("./predict.py")

function(input, output) {
  
  observe({
    if(is.null(input$article_text) || input$article_text == "") {
      disable("run_model")
    }
    else {
      enable("run_model")
    }
  })
  
  get_results <- eventReactive(input$run_model, {
    df <- data.frame(text = input$article_text)
    write.csv(df, "article.csv", row.names = FALSE)
    results <- predict_results()
    prediction <- results[1]
    probs_df <- data.frame(label = c("Fake", "Real"),
                           prob = c(as.numeric(results[2]), 
                                    as.numeric(results[3])))
    assign("prediction", prediction, envir = .GlobalEnv)
    assign("probs_df", probs_df, envir = .GlobalEnv)
  })
  
  output$results_pie <- renderHighchart(({
    get_results()
    probs_df %>% 
      hchart(
        "pie",
        hcaes(x = label, y = round(prob, 3)*100),
        name = "Percent"
      ) %>% 
      hc_title(text = "Results Probability")
  }))
  
  output$results_word_cloud <- renderHighchart((({
    get_results()
    article <- read.csv("article.csv")
    text <- article[1,1]
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
    
    # Show only the top 20 words
    dm_df %>% 
      head(20) %>% 
      hchart(
        "wordcloud",
        hcaes(
          name = word,
          weight = freq
        ),
        name = "Word Count"
      ) %>% 
      hc_title(text = "Article Word Cloud")
  })))
}