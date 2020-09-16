# Note: This is the solution for 03-calculate.R
# Resist to urge to look before you give the exercise a try!

# Goal: Multiply the selected value by a given value and report the result

# UI ---------------------------------------------------------------------------
ui <- fluidPage(
  
  titlePanel("Let's do simple math!"),
  
  sidebarLayout(
  
    sidebarPanel(
      
      sliderInput("x", 
                  "Select x", 
                  min = 1, max = 50, 
                  value = 30),
      
      numericInput("multiplier",
                   "Multiply by", 
                   min = 1, max = 50, 
                   value = 5),
      
      actionButton("calculate_button",
                   "Calculate")
      
    ),
    
    mainPanel( 
      textOutput("result") 
    )
    
  )
)

# Server -----------------------------------------------------------------------
server <- function(input, output) {
  
  output$result <- eventReactive(     # eventReactive() <-----------------------
    input$calculate_button, {
      input$x * input$multiplier
    },
    ignoreNULL = FALSE
  )
  
}

# Create Shiny app object ------------------------------------------------------
shinyApp(ui, server)
