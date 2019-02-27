library(shiny)

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
                  #a text box for loading text
                  textAreaInput("my_terms", 
                            h3("Your terms"), 
                            value = "Enter text...")
                  
    )
    
    ,
    mainPanel(
      
      #content section
              strong("paste text, get network"), 
              
      #output section
        #how many terms 
        textOutput("noTerms")
      #,
        #the D3 network
        #the scatter plot
        #the ranked data
              
              
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
  
  output$noTerms <- renderText({ 
    
    howMany <- reactive({
      #length(input$my_terms)
      #input$my_terms
      #str(input$my_terms)
      aaa = stringr::str_split(string = input$my_terms, 
                                pattern = "\n")
             
      bbb = length(unlist(aaa))
      print(bbb)
      return(bbb)
    })
    
    paste0(howMany())
    #paste("You introduced this many terms", howMany)
  })
  
  
  
}

# Run the app ----
shinyApp(ui = ui, server = server)