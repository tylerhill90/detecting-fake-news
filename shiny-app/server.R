# Shiny app server

library(shiny)
library(shinyjs)
library(reticulate)
use_virtualenv('/home/tyler/School/INSH5302/FreeProj/env', required = TRUE)
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
  observeEvent(input$run_model, {
    df <- data.frame(text = input$article_text)
    write.csv(df, "article.csv", row.names = FALSE)
    results <- predict_results()
    message(results)
  })
}