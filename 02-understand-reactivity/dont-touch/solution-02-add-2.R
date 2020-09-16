# Note: This is the solution for 02-add-2.R
# Resist to urge to look before you give the exercise a try!

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
  current_x        <- reactive({ add_2(input$x) }) # reactive() <---------------
  output$x_updated <- renderText({ current_x() })  # renderText() <-------------
}

# Create Shiny app object ------------------------------------------------------
shinyApp(ui, server)
