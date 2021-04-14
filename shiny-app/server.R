# Shiny app server

# Load libraries and helper functions
source("helpers.R")

# Python resources
virtualenv_create(envname = "python_environment", python= "python3")
virtualenv_install("python_environment", packages = c("pandas", "numpy", "sklearn"))
reticulate::use_virtualenv("python_environment", required = TRUE)
source_python("./predict.py")

function(input, output) {
  ################
  ## BACKGROUND ##
  ################
  
  ###########
  ## STATS ##
  ###########
  
  ###########
  ## MODEL ##
  ###########
  observe({
    dm_df <- process_text(input$article_text)
    if(
      is.null(input$article_text) ||  # Check for empty cell
      is.null(dm_df$word)  # Check for only stop words and/or whitespace entered
    ) {
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
    
    dm_df <- process_text(text)  # From helpers.R
    
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