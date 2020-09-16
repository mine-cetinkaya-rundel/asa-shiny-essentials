# Note: This app is intentionally broken, 
# it is used as part of an exercise

# Goal: Add 2 to the selected value and report the result

# UI ---------------------------------------------------------------------------
ui <- fluidPage(
  titlePanel("Add 2"),
  sidebarLayout(
    sidebarPanel( 
      sliderInput("x", 
                  "Select x", 
                  min = 1, max = 50, 
                  value = 30) 
    ),
    mainPanel( 
      textOutput("x_updated") 
    )
  )
)

# Server -----------------------------------------------------------------------
server <- function(input, output) {
  add_2            <- function(x) { x + 2 }
  current_x        <- add_2(input$x)
  output$x_updated <- current_x
}

# Create Shiny app object ------------------------------------------------------
shinyApp(ui, server)
