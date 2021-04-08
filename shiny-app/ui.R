# Shiny app user interface

library(shiny)
library(shinydashboard)

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
          "Model Detect"
        )
      )
    )
  )
)