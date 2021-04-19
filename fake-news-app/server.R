# Shiny app server

# Load libraries and helper functions
source("helpers.R")

# Set highcharter options
options(highcharter.theme = hc_theme_smpl(tooltip = list(valueDecimals = 0)))

# Python resources
virtualenv_create(envname = "python_environment", python= "python3")
virtualenv_install("python_environment", packages = c("pandas", "numpy", "sklearn"))
reticulate::use_virtualenv("python_environment", required = TRUE)
source_python("./predict.py")

function(input, output) {
  # Inform user how to toggle sidebar menu
  observe({
    shinyalert(
      title = 'Press the &nbsp; <i class="fas fa-bars"></i> &nbsp; button at the top of the page to toggle the sidebar menu off and on.',
      html = TRUE
    )
  }) 
  
  ################
  ## BACKGROUND ##
  ################
  
  ## Social media usage for news
  # https://www.journalism.org/2021/01/12/news-use-across-social-media-platforms-in-2020/
  output$sm_usage <- renderHighchart((({
    df_usage <- data.frame(type = c("Often", "Sometimes", "Rarely",
                                    "Never", "Doesn't  get digital news"),
                           freq = c(23, 30, 18, 21, 7))
    df_usage %>% 
      hchart(
        "pie",
        hcaes(
          x = type,
          y = freq
        ),
        name = "Percent"
      ) %>% 
      hc_title(text = "Percent of U.S. adults who get news from social media in 2020")
  })))
  
  output$sm_trust <- renderHighchart((({
    df_trust <- data.frame(type = rev(c("Largely accurate", "Largely inaccurate",
                                    "Largely accurate", "Largely inaccurate",
                                    "Largely accurate", "Largely inaccurate")),
                           freq = rev(c(39, 59, 40, 59, 42, 57)),
                           year = rev(c(2020, 2020, 2019, 2019, 2018, 2018)))
    df_trust %>% 
      hchart(
        "bar",
        hcaes(
          x = year,
          y = freq,
          group = type
        ),
        stacking = "normal"
      ) %>% 
      hc_title(text = "Percent of social media consumers who expect news they see on social media to be...") %>% 
      hc_xAxis(
        title = list(text = "Year"),
        reversed = FALSE
      ) %>%
      hc_yAxis(
        title = list(text = "Percent"),
        max = 100
      ) %>% 
      hc_legend(reversed = TRUE, align = "center")
  })))
  
  ## Google Trends Chart
  output$google_trends <- renderHighchart((({
    chart_df <- df_gtrends %>% 
      select(date, input$gtrends_query)
    chart_df <- xts(chart_df[-1], order.by = chart_df$date)
    
    title_ <- paste('Google Trends Results: "', gsub("_", " ", input$gtrends_query), '"', sep = '')
    
    chart_df %>% 
      hchart(
        name = "Relative Interest"
      ) %>% 
        hc_title(text = title_)
  })))
  
  ## World Map - Gov Influence
  output$world_govs <- renderHighchart((({
    chart_df <- df_govs %>% 
      filter(year == input$world_map_year) %>% 
      select(country_name, input$world_map_var)
    
    if (input$world_map_var == "v2mecenefm_mean") {subtitle <- "Government media censorship"}
    if (input$world_map_var == "v2smgovdom_mean") {subtitle <- "Government dissemination of false information domestic"}
    if (input$world_map_var == "v2smfordom_mean") {subtitle <- "Foreign governments dissemination of false information"}
    
    subtitle <- paste(subtitle, "in", input$world_map_year)
    
    highchart() %>% 
      hc_add_series_map(
        worldgeojson,
        chart_df,
        value = input$world_map_var,
        joinBy = c("name", "country_name"),
        name = "Index Score"
      ) %>% 
      hc_colorAxis(stops = color_stops()) %>% 
      hc_mapNavigation(enabled = TRUE) %>% 
      hc_title(text = subtitle) %>% 
      hc_add_theme(hc_theme_smpl(tooltip = list(valueDecimals = 2))) %>%
      hc_credits(enabled = TRUE, text = "Scale: 0 = Worse to 4 = Best<br>", style = list(fontSize = "12px"))
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
      hc_title(text = "Article Word Cloud")
  })))
  
  ## Model test results
  output$confusion_matrix <- renderHighchart((({
    con_mat <- confusionMatrix(data = factor(df_test$prediction), reference = factor(df_test$label))
    as.data.frame(con_mat$table) %>% 
      mutate(Freq = Freq / sum(Freq)) %>%
      mutate(name = ifelse(Prediction == "FAKE" & Reference == "FAKE", "True Negative", NA)) %>% 
      mutate(name = ifelse(Prediction == "REAL" & Reference == "FAKE", "False Positive", name)) %>% 
      mutate(name = ifelse(Prediction == "FAKE" & Reference == "REAL", "False Negative", name)) %>% 
      mutate(name = ifelse(Prediction == "REAL" & Reference == "REAL", "True Positive", name)) %>% 
      hchart(
        "heatmap",
        hcaes(
          x = Prediction,
          y = Reference,
          value = Freq,
          group = name
        ),
        dataLabels = list(enabled = TRUE, visible = FALSE)
      ) %>% 
      hc_xAxis(reversed = TRUE, opposite = TRUE) %>% 
      hc_legend(enabled = FALSE) %>% 
      hc_add_theme(hc_theme_smpl(tooltip = list(valueDecimals = 2))) %>% 
      hc_tooltip(pointFormat = '{name}') %>% 
      hc_title(text = "Confusion matrix of model testing")
  })))
}