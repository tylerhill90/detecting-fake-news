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
      menuItem("Background", tabName = "background", icon = icon("question"),
        menuSubItem("Overview", tabName = "overview", icon = icon("info")),
        menuSubItem("Social Media", tabName = "social-media", icon = icon("hashtag")),
        menuSubItem("Governmental Influence", tabName = "gov", icon = icon("globe-americas"))
      ),
      menuItem("Detection Model", tabName = "model", icon = icon("search"),
        menuSubItem("Model Overview", tabName = "model-overview", icon = icon("map-signs")),
        menuSubItem("Run the Model", tabName = "model-detect", icon = icon("check"))
      )
    )
  ),
  dashboardBody(
    
    useShinyjs(),
    useShinyalert(),
    
    # Set the theme
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),
    
    # Custom CSS
    tags$style(
      HTML("
      img {
        display: block;
        margin-left: auto;
        margin-right: auto;
      }
    ")
    ),
    
    tabItems(
      ################
      ## BACKGROUND ##
      ################
      
      ## Overview
      tabItem(
        tabName = "overview",
        fluidRow(
          
          box(
            status = "primary",
            h3("What is fake news?"),
            p(tags$img(src = "icon.png", width = "33%", style = "align: top; clear:left; float: right"),
              "As you may have already guessed or known, fake news is any news that presents itself as truthful
              when in fact it is false or misleading. There are two major distinctions to be made here,
              misinformation and disinformation.", tags$strong("Misinformation"), "is false information that
              is spread regardless of the intent to mislead.", tags$strong("Disinformation"), "is false information
              that is spread WITH the intent to mislead. Put another way, disinformation is when misinformation is
              knowingly disseminated."),
            tags$br(),
            h3("Historical Perspective"),
            h4("Ancient Times"),
            p("Fake news has been used as a propaganda tool throughout all of human history, from",
              tags$a(href = "https://theconversation.com/the-fake-news-that-sealed-the-fate-of-antony-and-cleopatra-71287",
                     "Octavian slandering Marc Antony"), "in ancient Rome, to the sensational",
              tags$a(href = "https://en.wikipedia.org/wiki/Yellow_journalism", "yellow journalism"),
                     "of the early 20th century."),
            tags$img(src = "yellow-journalism.jpg", width = "75%"),
            h4("Modern Times"),
            p("Fake news may well be at an all time high right now with the advent of the internet and social media as tools for
              the rapid and widespread dissemination for information, real or fake. Entire websites like",
              tags$a(href = "https://www.snopes.com/", "Snopes.com"), "and",
              tags$a(href = "http://factcheck.org/", "FactCheck.org"),
              "now exist to fact investigate the claims that make their way across the internet and into the public
              consciousness.")
          ),
          
          box(
            status = "primary",
            h3("Modern public interest in fake news"),
            p("Below is a tool for exploring",
              tags$a(href = "https://trends.google.com/trends/", "Google Trends"),
              "data for search terms related to fake news and popular conspiracy theories.
              The data is from 2004 to the preseent, as this is when Google Trends began tacking
              public interest in search terms, and tracks the global interest in the queried term."),
            highchartOutput("google_trends"),
            tags$br(),
            selectInput(
              "gtrends_query", "Select a Google Trends search",
              c(
                "fake news" = "fake_news",
                "misinformation" = "misinformation",
                "disinformation" = "disinformation",
                "lamestream media" = "lamestream_media",
                "pizza gate" = "pizza_gate",
                "qanon" = "qanon"
              ),
              selected = "fake_news"
            ),
            p('We can see that many of these search terms are at their highest in more recent years, especially around
              the US presidential elections in 2016 and 2020. The role of politics and governments in fake news goes
              hand in hand as a tool swaying for public opinion and is explored further in the "Governmental Influence" page
              of this site.')
          )
          
        )
      ),

      ## Social Media
      tabItem(
        tabName = "social-media",
        fluidRow(

          box(
            status = "primary",
            h3("The Role of Social Media"),
            p('It is undeniable that social media has forever changed the social landscape of our modern world.
              We can now curate our identities online through these platforms and through them even find community.
              Unfortunately, this can often lead to echo chambers where misleading and potentiallly harmful information
              is spread between members quickly. A',
              tags$a(href = "https://science.sciencemag.org/content/359/6380/1146", "2018 MIT study"), 'found that
              "...falsehood diffuses significantly farther,
              faster, deeper, and more broadly than the truth, in all categories of information, and in many cases by an order
              of magnitude..." on the Twitter platform. Still, the public seems to be catching on.
              Over the years a growing mistrust has been built for
              the news that pops up in social media feeds. A',
              tags$a(href = "https://www.journalism.org/2021/01/12/news-use-across-social-media-platforms-in-2020/", 
              "2020 Pew Research poll"), 'found that while more than half of American
              adults surveyed got their news from social media at least sometimes, only 39% of those surveyed thought that this
              news was largely accurate.',
              tags$br(), tags$br(),
              tags$img(src = "social-media.png", width = "50%"))
          ),

          box(
            status = "primary",
            highchartOutput("sm_usage", height = "320px"),
            tags$br(),
            highchartOutput("sm_trust", height = "320px"),
            tags$br(),
            helpText(p(
              "Source:", tags$br(),
              tags$a(href = "https://www.journalism.org/2021/01/12/news-use-across-social-media-platforms-in-2020/",
                     "Pew Research Center - News Use Across Social Media Platforms in 2020")
            ))
          )

        )
      ),
      
      ## Government Influence
      tabItem(
        tabName = "gov",
        fluidRow(
          
          box(
            status = "primary",
            h3("A Government's Role"),
            p("Fake news has been employed by governments around the world as a tool for swaying public opinion
              for all of recorded history. For a government to not employ some form of disinformation, foreign or
              domestic, seems to be the exception not the rule. Some modern examples include the disinformation
              campaign by Russia during the",
              tags$a(href = "https://www.reuters.com/article/us-ukraine-crisis-russia-media-idUSKBN15Q0MG", "annexing of Crimea"),
              "in 2014 and China's use of fake news during the",
              tags$a(href = "https://www.theguardian.com/world/2019/aug/11/hong-kong-china-unrest-beijing-media-response",
                     "2019-2020 Hong Kong protests."),
              tags$br(), tags$br(),
              tags$img(src = "cencorship.png", width = "50%"),
              tags$br(),
              "In the infographic on this page we are able to explore the use of disinformation by governments across the world from 2000 to 2020
              through the", tags$a(href = "https://www.v-dem.net/en/data/data/v-dem-dataset-v111/", "V-Dem Version 11.1 data set."),
              'Varieties of Democracy (V-Dem) is an independent research institute that, in their own words, "provide[s] a
              multidimensional and disaggregated dataset that reflects the complexity of the concept of democracy as a system of rule
              that goes beyond the simple presence of elections."'
            )
          ),
          
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
            h3("Model overview"),
            p(tags$img(src = "ml.png", width = "33%", style = "clear: left; float: right"),
              "To build this machine learning model I employed a TF-IDF Vectorizer and Passive Aggressive Classifier
              from the python package scikit-learn.",
              tags$br(), tags$br(),
              "A TF-IDF Vectorizer takes text as an input and computes the
              Term Frequency (TF), which measures how many times each word occurs in a text, and the Inverse Document Frequency (IDF)
              , which gives a measures how common or rare a word is across all the texts examined. This essentially transforms the text
              input into a more computer friendly format that can then be fed into a machine learning algorithm.",
              tags$br(), tags$br(),
              "A Passive Aggressive Classifier (PAC) is a machine learning algorithm that takes input in sequentially and
              updates it's model with each new piece of input step by step and is particualry good at dealing with large
              streams of continuously updating data. PACs are passive because as they are trained, if the
              prediction is correct the model is not changed. PACs are also aggressive because as they are trained, if the prediction
              is NOT correct it will update and change the model according to some penalizing parameter. A PAC will be trained on the
              given data a certain number of times defined and stops when it reaches a defined stopping criterion associated with the
              model's loss."
              ),
            h3("The training and testing data"),
            p("To build a robust training and testing data set for my model I found three Kaggle data sets and
              the ISOT Fake News data set from the University of Victoria.
              I compiled all of these data sets into a single, non-redunant data set that comprised 64,845 labled articles of
              at least 50 words in length from the years 2016 to 2020."
            ),
            p(
              tags$strong("Data Sets:"), tags$br(),
              tags$a(href = "https://www.kaggle.com/c/fakenewskdd2020", "Kaggle data set #1"), tags$br(),
              tags$a(href = "https://www.kaggle.com/c/fake-news", "Kaggle data set #2"), tags$br(),
              tags$a(href = "https://www.kaggle.com/c/classifying-the-fake-news", "Kaggle data set #3"), tags$br(),
              tags$a(href = "https://www.uvic.ca/engineering/ece/isot/datasets/fake-news/index.php", "ISOT Fake News data set")
            )
          ),
          
          box(
            status = "primary",
            h3("Model performance"),
            highchartOutput("accuracy", height = "160px"),
            tags$br(),
            highchartOutput("confusion_matrix", height = "400px")
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
      )
      
    )
  )
)