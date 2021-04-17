# Shiny app user interface

# Load libraries and helper functions
source("helpers.R")

dashboardPage(
  dashboardHeader(
    title = "Detecting Political Fake News",
    titleWidth = 300
  ),
  dashboardSidebar(
    sidebarMenu(
      id = "menu",
      menuItem("Background", tabName = "background", icon = icon("question")),
      menuItem("Fake News Stats", tabName = "stats", icon = icon("chart-bar"),
        menuSubItem("General", tabName = "stats-general", icon = icon("chart-area")),
        menuSubItem("Governmental Influence", tabName = "stats-gov", icon = icon("globe-americas"))
      ),
      menuItem("Detection Model", tabName = "model", icon = icon("search"),
        menuSubItem("Model Overview", tabName = "model-overview", icon = icon("map-signs")),
        menuSubItem("Run the Detection Model", tabName = "model-detect", icon = icon("check")),
        menuSubItem("Model Performance", tabName = "model-performance", icon = icon("poll"))
      )
    )
  ),
  dashboardBody(
    
    useShinyjs(),
    
    # Set the theme
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),
    
    tabItems(
      ################
      ## BACKGROUND ##
      ################
      tabItem(
        tabName = "background",
        fluidRow(
          
          box(
            status = "primary",
            h3("A Historical Perspective"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            h3("The Role of Social Media"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            h3("Government’s Role"),
            p("TODO")
          )
          
        )
      ),
      
      ################
      ## STATISTICS ##
      ################
      
      ## Fake News Stats
      tabItem(
        tabName = "stats-general",
        fluidRow(
          
          box(
            status = "primary",
            h3("Summary Stats"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            highchartOutput("google_trends"),
            tags$br(),
            selectInput(
              "gtrends_query", "Select a Google Trends search",
              c(
                "fake news" = "fake_news",
                "misinformation" = "misinformation",
                "alternative facts" = "alternative_facts",
                "lamestream media" = "lamestream_media",
                "pizza gate" = "pizza_gate",
                "qanon" = "qanon"
              ),
              selected = "fake_news"
            ),
            p(tags$strong("Explaination")),
            p("Google Trends is... TODO")
          )
          
        )
      ),
      
      ## World Govs
      tabItem(
        tabName = "stats-gov",
        fluidRow(
          
          box(
            status = "primary",
            shinycssloaders::withSpinner(
              highchartOutput("world_govs")
            ),
            tags$br(),
            selectInput(
              "world_map_var",
              "Select a variable to examine",
              c(
                "Government media censorship" = "v2mecenefm_mean",
                "Government dissemination of false information domestic" = "v2smgovdom_mean",
                "Foreign governments dissemination of false information" = "v2smfordom_mean"
              ),
              selected = "v2mecenefm"
            ),
            selectInput(
              "world_map_year",
              "Select a year",
              c(2000:2020),
              selected = 2020
            ),
            p(tags$strong("Variable Explanation")),
            conditionalPanel(
              condition = "input.world_map_var == 'v2mecenefm_mean'",
              p(
                "Does the government directly or indirectly attempt to censor the print or broadcast media?", tags$br(), tags$br(),
              "0: Attempts to censor are direct and routine.", tags$br(),
              "1: Attempts to censor are indirect but nevertheless routine.", tags$br(),
              "2: Attempts to censor are direct but limited to especially sensitive issues.", tags$br(),
              "3: Attempts to censor are indirect and limited to especially sensitive issues.", tags$br(),
              "4: The government rarely attempts to censor major media in any way, and when such exceptional
              attempts are discovered, the responsible officials are usually punished."
              )
            ),
            conditionalPanel(
              condition = "input.world_map_var == 'v2smgovdom_mean'",
              p(
                "How often do the government and its agents use social media to disseminate misleading
                viewpoints or false information to influence its own population?", tags$br(), tags$br(),
                "0: Extremely often. The government disseminates false information on all key political issues.", tags$br(),
                "1: Often. The government disseminates false information on many key political issues.", tags$br(),
                "2: About half the time. The government disseminates false information on some key political
                issues, but not others.", tags$br(),
                "3: Rarely. The government disseminates false information on only a few key political issues.", tags$br(),
                "4: Never, or almost never. The government never disseminates false information on key political issues."
              )
            ),
            conditionalPanel(
              condition = "input.world_map_var == 'v2smfordom_mean'",
              p(
                "How routinely do foreign governments and their agents use social media to disseminate misleading viewpoints
                or false information to influence domestic politics in this country?", tags$br(), tags$br(),
                "0: Extremely often. Foreign governments disseminate false information on all key political issues.", tags$br(),
                "1: Often. Foreign governments disseminate false information on many key political issues.", tags$br(),
                "2: About half the time. Foreign governments disseminate false information on some key political issues,
                but not others.", tags$br(),
                "3: Rarely. Foreign governments disseminate false information on only a few key political issues.", tags$br(),
                "4: Never, or almost never. Foreign governments never disseminate false information on key political issues."
              )
            )
            
          ),
          
          box(
            status = "primary",
            h3("A Global Perspective"),
            p("TODO")
          )
          
        )
      ),
      
      ###########
      ## MODEL ##
      ###########
      
      ## Model background
      tabItem(
        tabName = "model-overview",
        fluidRow(
          
          box(
            status = "primary",
            h3("Fake News Detection with Machine Learning"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            h3("Overview of the Models Used"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            h3("The Training and Testing Data"),
            p("TODO")
          )
          
        )
      ),
      
      ## Run the model
      tabItem(
        tabName = "model-detect",
        fluidRow(
          
          box(
            status = "primary",
            textAreaInput(
              "article_text",
              label = h3("Enter Article to Detect Here"),
              placeholder = "Enter the article's body text here",
              height = "250px"
            ),
            actionButton("run_model", "Detect Fake News", icon = icon("fingerprint")),
            tags$br(),
            helpText("Usage:", tags$br(), "Copy and paste the article you would like to detect
            in the text box above. Use ctrl + shift + v to paste only unformatted text. Please 
            enter just the article's body for the best results. Press the Detect Fake News button
            after entering the body text to run the model and see your results."),
            p(
              tags$strong("Resources for reliable articles:"), tags$br(),
              tags$a(href = "https://www.npr.org/sections/politics/", "NPR - Politics"), tags$br(),
              tags$a(href = "https://www.politico.com/news/politics", "Politico - Politics"), tags$br()
            ),
            p(
              tags$strong("Resources for controversial/biased articles:"), tags$br(),
              tags$a(href = "https://www.cnn.com/politics", "CNN - Politics"), tags$br(),
              tags$a(href = "https://www.foxnews.com/politics", "Fox News - Politics"), tags$br()
            ),
            p(
              tags$strong("Resources for dubious articles:"), tags$br(),
              tags$a(href = "https://www.infowars.com/category/3/", "Info Wars - Politics"), tags$br(),
              tags$a(href = "https://www.breitbart.com/politics/", "Breitbart News - Politics"), tags$br()
            )
          ),
          
          box(
            status = "primary",
            conditionalPanel(
              condition = "input.run_model == 0",
              h3("Input Article Results"),
              p("Please run the model to see your results.")
            ),
            conditionalPanel(
              condition = "input.run_model != 0",
              h3("Input Article Results"),
              shinycssloaders::withSpinner(
                highchartOutput("results_pie", height = "300px")
              ),
              tags$br(),
              shinycssloaders::withSpinner(
                highchartOutput("results_word_cloud", height = "300px")
              )
            )
          )
          
        )
      ),
      
      ## Model performance
      tabItem(
        tabName = "model-performance",
        fluidRow(
          
          box(
            status = "primary",
            h3("Testing the Model on a Custom Data Set"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            h3("Test Reults"),
            p("TODO")
          )
          
        )
      )
      
    )
  )
)