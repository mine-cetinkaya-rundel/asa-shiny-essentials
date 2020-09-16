# Note: This is the solution for 01-mult-3.R
# Resist to urge to look before you give the exercise a try!

# Goal: Multiply the selected value by 3 and report the result

# UI ---------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Multiply by 3"),
  sidebarLayout(
    sidebarPanel( 
      sliderInput("x", 
                  "Select x", 
                  min = 1, max = 50, 
                  value = 30) 
    ),
    mainPanel( 
      textOutput("current_x") 
    ) 
  )
)

# Server -----------------------------------------------------------------------
server <- function(input, output) {
  mult_3           <- function(x) { x * 3 }
  output$current_x <- renderText({ mult_3(input$x) }) # renderText() <----------
}

# Create Shiny app object ------------------------------------------------------
shinyApp(ui, server)
