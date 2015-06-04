#ui.R
library(shiny)
require(rCharts)
library(googleVis)
require(markdown)

shinyUI(fluidPage(
  title = "NBA Best Teams",
  includeCSS("style.css"),
  div(class='title',br(),h1("NBA Best Teams"),
      h5("A Compilation of the Teams with the Best Regular Season Records since 1948"),br()),
  sidebarLayout(
    sidebarPanel(
      helpText("Select the options below to filter the results on the tables to the right."),
      helpText("The page will dynamically refresh as you change your selections."),
      checkboxGroupInput("conf", 
                         label = "Select on Conference",
                         choices = c("East" = "East", "West" = "West"),
                         selected = "East"),
      checkboxGroupInput("champ", 
                         label = "Filter on a being a Champion",
                         choices = c("Yes" = "Yes", "No" = "No"),
                         selected = "Yes"),
      radioButtons("filetype", "Download the Data",
                   choices = c("csv", "tsv")),
      downloadButton('downloadData', 'Download')
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
          tabPanel("Overview", helpText(" "), 
                 h3("Coursera - Developing Data Products (Final Project)"),
                 includeMarkdown("docs/overview.md")), 
          tabPanel("Shooting", helpText("The chart below shows a comparison of Field Goal and Free Throw shooting for the best NBA team each season."), htmlOutput("shootingChart")),
          tabPanel("Defense", helpText("The chart below shows a comparison of Steals and Blocks per game for the best NBA team each season."), htmlOutput("defenseChart")),
          tabPanel("Data", helpText(" "), dataTableOutput('data'))
      )
    ))))