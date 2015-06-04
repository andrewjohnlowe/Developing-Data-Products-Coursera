#server.R
library(shiny)
require(rCharts)
library(googleVis)
load('data/nba.Rda')
shinyServer(function(input, output) {
  
  nbaDataSet <- reactive({
    working <- subset(nba,Champion %in% input$champ)
    working <- subset(working,Conference %in% input$conf)
    working$team_and_year<-paste(working$Team,working$Year, sep = " - ")
    return(working)
  })
  
  output$shootingChart <- renderGvis({
    gvisBubbleChart(nbaDataSet(), idvar="team_and_year", xvar="FG_Percent", yvar="FT_Percent", colorvar="Champion",
    options=list(
      title="Shooting Comparison",
      #legend='none', 
      width=500, height=500,
      hAxis="{title:'Field Goal %'}", vAxis="{title:'Free Throw %'}", 
      bubble="{textStyle:{color: 'none'}}", 
      sizeAxis = '{minValue: 0,  maxSize: 5}')
    )
  })
  
  output$defenseChart <- renderGvis({
    gvisBubbleChart(nbaDataSet(), idvar="team_and_year", xvar="Steals", yvar="Blocks", colorvar="Champion",
                    options=list(
                      title="Defense Comparison",
                      legend='none', width=500, height=500,
                      hAxis="{title:'Steals'}", vAxis="{title:'Blocks'}", 
                      bubble="{textStyle:{color: 'none'}}", 
                      sizeAxis = '{minValue: 0,  maxSize: 5}')
    )
  })
  
  output$data <- renderDataTable({
    nbaDataSet()
    },options = list(pageLength = 10)
  )
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, input$filetype, sep = ".")
    },
    content = function(file) {
      sep <- switch(input$filetype, "csv" = ",", "tsv" = "\t")
      write.table(nbaDataSet(), file, sep = sep,
                  row.names = FALSE)
    }
  )
  
})