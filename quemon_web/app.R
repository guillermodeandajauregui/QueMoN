library(shiny)

# Define UI ----
ui <- fluidPage(
  titlePanel("Quest for Meaning on Networks"),
  
  sidebarLayout(
    sidebarPanel("Panel A"),
    mainPanel(      
              img(src = "logo.png", 
                  height = 140, 
                  width = 400),
              h1("First level title"),
              h2("Second level title"),
              h3("Third level title"),
              h4("Fourth level title"),
              h5("Fifth level title"),
              h6("Sixth level title"))
)
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)