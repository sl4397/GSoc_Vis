library(shiny)
library(plotly)

navbarPage(
  title = 'Global Temperature Visualization',
  tabPanel('line plot',
           sidebarPanel(
             selectInput("c1", label = "Country", selected = "United States",
                         choices = as.character(unique(data$Country))),
             br(),
             
             checkboxInput("checkbox1", label = "Show Uncertainty", value = F),
             checkboxInput("checkbox2", label = "Fit a Smoother", value = F),
             
             br(),
             sliderInput("s", "Smoothing Parameter",
                         min = 0, max = 1,
                         value = 0.5, step = 0.1)
           ),
           
           mainPanel(plotlyOutput("line", height = 600))
  ),
        
  tabPanel('scatter plot',
           sidebarPanel(
             selectInput("c2", label = "Select Country 1", selected = "United States",
                         choices = as.character(unique(data$Country))),
             selectInput("c3", label = "Select Country 2", 
                         choices = as.character(unique(data$Country))),
             br(),
             checkboxInput("checkbox3", label = "Fit Linear Regression", value = F)
           ),
           
           
           mainPanel(plotlyOutput("scatter", height = 600))
  ),
  
  tabPanel('bar plot', plotlyOutput("bar", height = 2500))


)