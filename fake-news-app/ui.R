# Shiny app user interface

# Load libraries and helper functions
source("helpers.R")

appCSS <- "
#loading-content {
  position: absolute;
  background: #f5f5f5;
  opacity: 0.9;
  z-index: 100;
  left: 0;
  right: 0;
  height: 100%;
  text-align: center;
  color: #045ed9;
}
.loader,
.loader:before,
.loader:after {
  background: #045ed9;
  -webkit-animation: load1 1s infinite ease-in-out;
  animation: load1 1s infinite ease-in-out;
  width: 1em;
  height: 4em;
}
.loader {
  color: #045ed9;
  text-indent: -9999em;
  margin: 88px auto;
  position: relative;
  font-size: 11px;
  -webkit-transform: translateZ(0);
  -ms-transform: translateZ(0);
  transform: translateZ(0);
  -webkit-animation-delay: -0.16s;
  animation-delay: -0.16s;
}
.loader:before,
.loader:after {
  position: absolute;
  top: 0;
  content: '';
}
.loader:before {
  left: -1.5em;
  -webkit-animation-delay: -0.32s;
  animation-delay: -0.32s;
}
.loader:after {
  left: 1.5em;
}
@-webkit-keyframes load1 {
  0%,
  80%,
  100% {
    box-shadow: 0 0;
    height: 4em;
  }
  40% {
    box-shadow: 0 -2em;
    height: 5em;
  }
}
@keyframes load1 {
  0%,
  80%,
  100% {
    box-shadow: 0 0;
    height: 4em;
  }
  40% {
    box-shadow: 0 -2em;
    height: 5em;
  }
}
"

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
        menuSubItem("Government Influence", tabName = "gov", icon = icon("globe-americas"))
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
    inlineCSS(appCSS),
    
    # Fix header at top of page
    tags$script(HTML("$('body').addClass('fixed');")),
    
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
    
    # Loading message
    div(
      id = "loading-content",
      h3("Please wait while the app loads..."),
        tags$div(
          class="loader",
          "Loading..."
        )
    ),
    
    
    hidden(
      div(
        id = "app-content",
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
                  "As you may have already known, fake news is any news that presents itself as truthful
              when in fact it is false or misleading. The difference between misinformation and disinformation is
              worth delineating when discussing this topic.", tags$strong("Misinformation"), "is false information that
              is spread regardless of the intent to mislead.", tags$strong("Disinformation"), "is false information
              that is spread WITH the intent to mislead."),
                tags$br(),
                h3("Historical Perspective"),
                h4("Ancient Times"),
                p("Fake news has been used as a propaganda tool throughout all of human history, from",
                  tags$a(href = "https://theconversation.com/the-fake-news-that-sealed-the-fate-of-antony-and-cleopatra-71287",
                         "Octavian slandering Marc Antony"), "in ancient Rome, to the sensational",
                  tags$a(href = "https://en.wikipedia.org/wiki/Yellow_journalism", "yellow journalism"),
                  "of the early 20th century."),
                tags$img(src = "yellow-journalism.jpg", width = "50%"),
                h4("Modern Times"),
                p("Fake news may well be at an all time high right now with the advent of the internet and social media as tools for
              the rapid and widespread dissemination of information, real or fake. Entire websites like",
                  tags$a(href = "https://www.snopes.com/", "Snopes.com"), "and",
                  tags$a(href = "http://factcheck.org/", "FactCheck.org"),
                  'now exist to fact check the claims that make their way across the internet and into the public
              consciousness. Artificial intelligence is now  beginning to be employed as a tool for spotting fake news
              and this project does exactly that. Check out the "Detection Model" section to learn more 
              about using machine learning to predict the legitimacy of a news article or
              continue to read through the "Background" section for more context.')
              ),
              
              box(
                status = "primary",
                h3("Modern public interest in fake news"),
                p("Below is a tool for exploring",
                  tags$a(href = "https://trends.google.com/trends/", "Google Trends"),
                  "data for search terms related to fake news and popular conspiracy theories.
              The data is from 2004 to the present and displays the normalized global interest in the queried term."),
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
              hand in hand as a tool for swaying public opinion and is explored further in the "Government Influence" page
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
              We can now curate our identities online through these platforms and through them find community.
              Unfortunately, this can often lead to echo chambers where misleading and potentiallly harmful information
              is spread between members quickly. A',
                  tags$a(href = "https://science.sciencemag.org/content/359/6380/1146", "2018 MIT study"), 'found that on
              the Twitter platform "...falsehood diffuses significantly farther, faster, deeper, and more broadly than
              the truth, in all categories of information, and in many cases by an order
              of magnitude." Still, the public seems to be catching on.
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
                p(
                  "Source:", tags$br(),
                  tags$a(href = "https://www.journalism.org/2021/01/12/news-use-across-social-media-platforms-in-2020/",
                         "Pew Research Center - News Use Across Social Media Platforms in 2020")
                )
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
              for all of recorded history. Some modern examples include the disinformation
              campaign by Russia during the",
                  tags$a(href = "https://www.reuters.com/article/us-ukraine-crisis-russia-media-idUSKBN15Q0MG", "annexing of Crimea"),
                  "in 2014 and China's use of fake news during the",
                  tags$a(href = "https://www.theguardian.com/world/2019/aug/11/hong-kong-china-unrest-beijing-media-response",
                         "2019-2020 Hong Kong protests."),
                  tags$br(), tags$br(),
                  tags$img(src = "cencorship.jpg", width = "50%"),
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
                  highchartOutput("world_govs", width = "98%")
                ),
                tags$br(),
                selectInput(
                  "world_map_year",
                  "Select a year",
                  c(2000:2020),
                  selected = 2020
                ),
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
                  "To build this machine learning model for detecting political fake news I employed a TF-IDF Vectorizer and Passive Aggressive Classifier
              from the python package scikit-learn.",
                  tags$br(), tags$br(),
                  "A TF-IDF Vectorizer takes text as an input and computes the
              Term Frequency (TF) and the Inverse Document Frequency (IDF). TF measures how many times each word occurs in a text.
              IDF gives a measures of how common or rare a word is across all the texts examined. These calculations transform the text
              input into a more computer readable format that can then be passed into a machine learning algorithm.",
                  tags$br(), tags$br(),
                  "A Passive Aggressive Classifier (PAC) is a machine learning algorithm that takes input in sequentially and
              updates a prediction model with each new piece of input step by step. It is particualry good at dealing with large
              streams of continuously updating data, like in the 24 hour news cycle. PACs are passive because if the
              prediction they make is correct the model is not changed but they are also aggressive because if the prediction
              is NOT correct it will change the model according to some predefined penalization score."
                ),
                h3("The training and testing data"),
                p("To build a robust training and testing data set for the model I found three fake news data sets from Kaggle and
              one more from the University of Victoria.
              I compiled all of these data sets into a single data set that comprised 64,845 unique articles of
              at least 50 words in length from the years 2016 to 2020. These articles are primarily about political news
              and thus this model is best suited for articles about politics and the government."
                ),
                p(
                  tags$strong("Data Sets:"), tags$br(),
                  tags$a(href = "https://www.kaggle.com/c/fakenewskdd2020", "Kaggle data set #1"), tags$br(),
                  tags$a(href = "https://www.kaggle.com/c/fake-news", "Kaggle data set #2"), tags$br(),
                  tags$a(href = "https://www.kaggle.com/c/classifying-the-fake-news", "Kaggle data set #3"), tags$br(),
                  tags$a(href = "https://www.uvic.ca/engineering/ece/isot/datasets/fake-news/index.php", "University of Victoria data set")
                )
              ),
              
              box(
                status = "primary",
                h3("Model performance"),
                highchartOutput("accuracy", height = "160px"),
                tags$br(),
                p("A machine learning model's accuracy is calculated by dividing the number of correct predictions in the
                 test set by the total number of predictions made. Here we see the model is performing quite well with
              an accuracy of over 90%."),
                tags$br(),
                highchartOutput("confusion_matrix", height = "400px"),
                tags$br(),
                p("A confusion matrix shows the proportion of true positives, true negative, false positive, and
                 false negatives that the model predicted during testing. Here we can see that the model performed
                 very well on the testing data with an overall low amount of false positives and false negatives.")
              )
              
            )
          ),
          
          ## Run the model
          tabItem(
            tabName = "model-detect",
            fluidRow(
              
              box(
                status = "primary",
                h3("Enter Article to Detect Here"),
                textAreaInput(
                  "article_text",
                  label = NULL,
                  placeholder = "Copy and paste the article you would like to detect here. Use ctrl + shift + v to paste unformatted text. Please use a politically focused article and enter just the article's body text for the best results. Results will appear below/to the right.",
                  height = "150px"
                ),
                actionButton("run_model", "Detect Fake News", icon = icon("fingerprint")),
                tags$br(), tags$br(),
                actionButton("resources", "Resources for political articles", icon = icon("newspaper")),
                conditionalPanel(
                  condition = "input.resources % 2 != 0",
                  tags$br(),
                  p("Open links in a new tab to keep the app open."),
                  p(tags$strong("Trustworthy"), tags$br(),
                    tags$a(href = "https://www.npr.org/sections/politics/", "NPR"), tags$br(),
                    tags$a(href = "https://www.wsj.com/news/politics", "Wall Street Journal"), tags$br()
                  ),
                  p(
                    tags$strong("Biased"), tags$br(),
                    tags$a(href = "https://www.cnn.com/politics", "CNN"), tags$br(),
                    tags$a(href = "https://www.foxnews.com/politics", "Fox News"), tags$br()
                  ),
                  p(
                    tags$strong("Potentially dubious and satirical"), tags$br(),
                    tags$a(href = "https://www.infowars.com/category/3/", "Info Wars"), tags$br(),
                    tags$a(href = "https://www.breitbart.com/politics/", "Breitbart News"), tags$br(),
                    tags$a(href = "https://politics.theonion.com/", "The Onion")
                  )
                )
              ),
              
              box(
                status = "primary",
                conditionalPanel(
                  condition = "input.run_model == 0",
                  h3("Input Article Results"),
                  p("Please run the model to see your results. For best results use political news articles as these
                types of articles more accurately reflect what the model was trained on.")
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
    
  )
)