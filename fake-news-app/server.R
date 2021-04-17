# Shiny app server

# Load libraries and helper functions
source("helpers.R")

# Set highcharter options
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 2)))

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
  
  ## Google Trends Chart ##
  
  get_gtrends_data <- reactive({
    # Query Google Trends
    chart_df <- df_gtrends %>% 
      select(date, input$gtrends_query)
    chart_df <<- xts(chart_df[-1], order.by = chart_df$date)
    
    title_ <<- paste('Google Trends Results: "', gsub("_", " ", input$gtrends_query), '"', sep = '')
  })
  
  output$google_trends <- renderHighchart((({
    get_gtrends_data()
    
    hchart(
      chart_df,
      name = "Relative Interest"
    ) %>% 
      hc_title(text = title_) %>% 
      hc_add_theme(hc_theme_smpl(tooltip = list(valueDecimals = 0)))
  })))
  
  ## World Map - Gov Influence ##
  output$world_govs <- renderHighchart((({
    chart_df <- df_govs %>% 
      filter(year == input$world_map_year) %>% 
      select(country_name, input$world_map_var)
    
    if (input$world_map_var == "v2mecenefm_mean") {subtitle <- "Government media censorship"}
    if (input$world_map_var == "v2smgovdom_mean") {subtitle <- "Government dissemination of false information domestic"}
    if (input$world_map_var == "v2smfordom_mean") {subtitle <- "Foreign governments dissemination of false information"}
    
    subtitle <- paste(subtitle, "in", input$world_map_year)
    
    highchart(type = "map") %>% 
      hc_add_series_map(
        worldgeojson,
        chart_df,
        value = input$world_map_var,
        joinBy = c("name", "country_name"),
        name = "Index Score"
      ) %>% 
      hc_colorAxis(
        stops = color_stops()
      ) %>% 
      hc_mapNavigation(enabled = TRUE) %>% 
      hc_title(text = subtitle)
  })))
  
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
    prediction <<- results[1]
    probs_df <<- data.frame(label = c("Fake", "Real"),
                           prob = c(as.numeric(results[2]), 
                                    as.numeric(results[3])))
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
          weight = as.integer(freq)
        ),
        name = "Word Count"
      ) %>% 
      hc_title(text = "Article Word Cloud") %>% 
      hc_add_theme(hc_theme_smpl(tooltip = list(valueDecimals = 0)))
  })))
}