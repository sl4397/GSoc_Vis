library(shiny)
library(plotly)
library(tidyverse)

temperature <- read.csv("../output/CleanedTemperaturesByCountry.csv")

shinyServer(function(input, output){
  
  output$line <- renderPlotly({
    g1 <- temperature %>% 
      filter(Country == input$c1) %>% 
      ggplot(., aes(year, AvgTemp))+
      geom_line()+
      ggtitle(paste("Average Temperature of", input$c1))+
      ylab("Average Temperature")
    
    g1.uncertain <- g1 + geom_ribbon(aes(ymin=LowerQuantile,ymax=UpperQuantile), alpha=0.3)
    g1.smooth <- g1 + geom_smooth(se = F, span = input$s)
    g1.both <- g1.uncertain + geom_smooth(se = F, span = input$s)
    
    if(input$checkbox1  & input$checkbox2 ){
      ggplotly(g1.both)
    } else if(input$checkbox1){
      ggplotly(g1.uncertain)
    } else if(input$checkbox2){
      ggplotly(g1.smooth)
    } else{ggplotly(g1)}
    
  })
  
 
  
  
  output$scatter <- renderPlotly({
    g2 <- temperature %>% 
      filter(Country %in% c(input$c2,input$c3)) %>% 
      select(year, Country, AvgTemp) %>% 
      spread(Country, AvgTemp) %>%
      ggplot(., aes(get(input$c2), get(input$c3)))+
      geom_point(aes(text = paste(input$c2, round(get(input$c2),2), 
                                  "<br>", input$c3, round(get(input$c3),2))))+
      ggtitle(paste("Temperatures of", input$c2, "and", input$c3))+
      xlab(input$c2)+
      ylab(input$c3)
    
    
    if(input$checkbox3){
      g2plus <- g2 + geom_smooth(method = "lm", se = F)
      ggplotly(g2plus, tooltip = "text")
    }
    else{
      ggplotly(g2, tooltip = "text")
    }
    
  })
  
  
 
  
  output$bar <- renderPlotly({
    g3 <- temperature %>% 
      group_by(Country) %>% 
      summarise(AvgTempByCountry = mean(AvgTemp, na.rm = T)) %>% 
      ggplot(., aes(x = reorder(Country, AvgTempByCountry), y = AvgTempByCountry))+
      geom_col(aes(text = paste(Country, ":", round(AvgTempByCountry,2))))+
      coord_flip()+
      ggtitle("Bar Chart of Average Temperature by Country")+
      xlab("")+
      ylab("Average Temperature")
    
    
    ggplotly(g3, tooltip = "text")
    
  })
  


})