# Shiny app user interface

library(shiny)
library(shinyjs)
library(tidyverse)
library(shinydashboard)
library(dashboardthemes)
library(tm)
library(SnowballC)
library(highcharter)

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
    
    ### changing theme
    shinyDashboardThemes(
      theme = "poor_mans_flatly"
    ),
    
    tabItems(
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
            h3("Google Trends Stats"),
            p("TODO")
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
            h3("Map of the world"),
            p("TODO")
          )
          
        )
      ),
      
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