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
      menuItem("Summary Stats", tabName = "stats", icon = icon("chart-bar"),
        menuSubItem("General", tabName = "stats-general", icon = icon("chart-area")),
        menuSubItem("Governmental Influence", tabName = "stats-gov", icon = icon("globe-americas"))
      ),
      menuItem("Detection Model", tabName = "model", icon = icon("search"),
        menuSubItem("Model Overview", tabName = "model-overview", icon = icon("map-signs")),
        menuSubItem("Run the Detection Model", tabName = "model-detect", icon = icon("check"))
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
            conditionalPanel(
              condition = "input.gtrends_search != 0",
              shinycssloaders::withSpinner(
                highchartOutput("google_trends")
              )
            ),
            conditionalPanel(
              condition = "input.gtrends_search == 0",
              h3("Google Trends Widget"),
              tags$br(), 
              p("Please enter a Google Trends query below to see it's relative popularity over time.")
            ),
            textInput("gtrends_query", "", placeholder = "Enter query here"),
            actionButton("gtrends_search", "Search Google Trends", icon = icon("search")),
            tags$br(), tags$br(), 
            p("Google Trends is... TODO"),
            p("Some search ideas are... TODO")
          )
          
        )
      ),
      
      tabItem(
        tabName = "stats-gov",
        fluidRow(
          
          box(
            status = "primary",
            h3("A Global Perspective"),
            p("TODO")
          ),
          
          box(
            status = "primary",
            shinycssloaders::withSpinner(
              highchartOutput("world_govs")
            ),
            selectInput(
              "world_map_var",
              "Select a variable to examine",
              c(
                "Government media censorship" = "v2mecenefm_mean",
                "Government dissemination of false information domestic" = "v2smgovdom_mean",
                "Government dissemination of false information abroad" = "v2smgovab_mean",
                "Party dissemination of false information domestic" = "v2smpardom_mean",
                "Party dissemination of false information abroad" = "v2smparab_mean",
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
            p(tags$strong("Selected Variable Explanation")),
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
              condition = "input.world_map_var == 'v2smgovab_mean'",
              p(
                "How often do the government and its agents use social media to disseminate misleading viewpoints or false
                information to influence citizens of other countries abroad?", tags$br(), tags$br(),
                "0: Extremely often. The government disseminates false information on all key political issues.", tags$br(),
                "1: Often. The government disseminates false information on many key political issues.", tags$br(),
                "2: About half the time. The government disseminates false information on some key political
                issues, but not others.", tags$br(),
                "3: Rarely. The government disseminates false information on only a few key political issues.", tags$br(),
                "4: Never, or almost never. The government never disseminates false information on key political issues."
              )
            ),
            conditionalPanel(
              condition = "input.world_map_var == 'v2smpardom_mean'",
              p(
                "How often do major political parties and candidates for office use social media to disseminate misleading
                viewpoints or false information to influence their own population?", tags$br(), tags$br(),
                "0: Extremely often. Major political parties and candidates disseminate false information on all key
                political issues.", tags$br(),
                "1: Often. Major political parties and candidates disseminate false information on many key political
                issues.", tags$br(),
                "2: About half the time. Major political parties and candidates disseminate false information on some key
                political issues, but not others.", tags$br(),
                "3: Rarely. Major political parties and candidates disseminate false information on only a few key political
                issues.", tags$br(),
                "4: Never, or almost never. Major political parties and candidates never disseminate false information on
                key political issues."
              )
            ),
            conditionalPanel(
              condition = "input.world_map_var == 'v2smparab_mean'",
              p(
                "How often do major political parties and candidates for office use social media to disseminate misleading
                viewpoints or false information to influence citizens of other countries abroad?", tags$br(), tags$br(),
                "0: Extremely often. Major political parties and candidates disseminate false information on all key
                political issues.", tags$br(),
                "1: Often. Major political parties and candidates disseminate false information on many key political
                issues.", tags$br(),
                "2: About half the time. Major political parties and candidates disseminate false information on some key
                political issues, but not others.", tags$br(),
                "3: Rarely. Major political parties and candidates disseminate false information on only a few key political
                issues.", tags$br(),
                "4: Never, or almost never. Major political parties and candidates never disseminate false information on
                key political issues."
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
            
          )
          
        )
      ),
      
      ###########
      ## MODEL ##
      ###########
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
            h3("Input Article Results"),
            highchartOutput("results_pie", height = "300px"),
            tags$br(),
            highchartOutput("results_word_cloud", height = "300px")
          )
          
        )
      )
    )
  )
)