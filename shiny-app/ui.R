# Shiny app user interface

library(shiny)
library(shinydashboard)
library(dashboardthemes)

dashboardPage(
  dashboardHeader(
    title = "Detecting Fake News"
  ),
  dashboardSidebar(
    sidebarMenu(
      id = "menu",
      menuItem("Background", tabName = "background", icon = icon("question")),
      menuItem("Summary Stats", tabName = "stats", icon = icon("chart-bar"),
        menuSubItem("General", tabName = "stats-general", icon = icon("chart-area")),
        menuSubItem("Governmental Influence", tabName = "stats-gov", icon = icon("globe-americas"))
      ),
      menuItem("Detecting Fake News", tabName = "model", icon = icon("search"),
        menuSubItem("Overview", tabName = "model-overview", icon = icon("map-signs")),
        menuSubItem("Detection", tabName = "model-detect", icon = icon("check"))
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
          "Background"
        )
      ),
      tabItem(
        tabName = "stats-general",
        fluidRow(
          "General Stats"
        )
      ),
      tabItem(
        tabName = "stats-gov",
        fluidRow(
          "Gov Stats"
        )
      ),
      tabItem(
        tabName = "model-overview",
        fluidRow(
          "Model Overview"
        )
      ),
      tabItem(
        tabName = "model-detect",
        fluidRow(
          box(
            textAreaInput(
              "article_text",
              label = h3("Input Article to Detect Here"),
              placeholder = "Enter the article's body text here",
              height = "300px"
            ),
            actionButton("run_model", "Detect Fake News", icon = icon("fingerprint")),
            helpText("Usage:", tags$br(), "Copy and paste the article you would like to detect
            in the text box above. Use ctrl + shift + v to paste only unformatted text. Please 
            enter just the article's body for the best results. Press the Detect Fake News button
            after entering the body text to run the model and see your results.")
          )
        )
      )
    )
  )
)