library(shiny)
library(maps)
library(mapproj)
source("helpers.R")
counties <- readRDS("data/counties.rds")


# Define UI ----
ui <- fluidPage(
  titlePanel("Quest for Meaning on Networks"),
  
  sidebarLayout(
    sidebarPanel(
      #logo section
      img(src = "logo.png", 
          height = 100, 
          width = 100
      )
      ,
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = list("Percent White", 
                                 "Percent Black",
                                 "Percent Hispanic", 
                                 "Percent Asian"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100)
      )
    )
    
    ,
    mainPanel(
      
      #content section
      p("This is information that "), 
      strong("is strong"), 
      em("or italic"),
      #output section              
      textOutput("selected_var"),
      textOutput("min_max"),
      plotOutput("map")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  
  #  output$selected_var <- renderText({ 
  #    paste0("You have selected ", input$var)
  #  })
  # 
  # output$selected_range <- renderText({ 
  #   paste("You have chosen a range that goes from",
  #         input$range[1], "to", input$range[2])
  # })
  
  output$selected_var <- renderText({ 
    paste("You have selected", input$var)
  })
  
  output$min_max <- renderText({ 
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })
  
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian
    )
    
    color <- switch(input$var, 
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")
    
    legend <- switch(input$var, 
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")
    
    
    percent_map( # some arguments 
      var = data, 
      color = color,
      legend.title = legend,
      min = input$range[1],
      max = input$range[2]
    )
  })
  
}

# Run the app ----
shinyApp(ui = ui, server = server)