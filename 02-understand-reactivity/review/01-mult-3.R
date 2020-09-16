# Note: This app is intentionally not fully functional, 
# it is used as part of an exercise

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
  current_x        <- reactive({ mult_3(input$x) })
}

# Create Shiny app object ------------------------------------------------------
shinyApp(ui, server)
