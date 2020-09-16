# Load packages ----------------------------------------------------------------
library(shiny)
library(tidyverse)
library(DT)
library(glue)

# Load data --------------------------------------------------------------------
load("data/movies.Rdata")

# Define UI for application that plots features of movies ----------------------
ui <- fluidPage(
  
  # Application title ----------------------------------------------------------
  titlePanel("Movie browser"),
  
  # Sidebar layout with a input and output definitions -------------------------
  sidebarLayout(
    
    # Inputs: Select variables to plot -----------------------------------------
    sidebarPanel(
      
      # Subtitle ---------------------------------------------------------------
      h4("Sample"),
      
      # Set sample size --------------------------------------------------------
      numericInput(inputId = "n_samp", 
                   label = "Enter a sample size between 1 and 651:", 
                   min = 1, max = nrow(movies), 
                   value = 50),
      
      # Take random sample -----------------------------------------------------
      actionButton(inputId = "sample_button", 
                   label = "Take random sample"),
      
      # Visual separation ------------------------------------------------------
      br(), hr(),
      
      # Subtitle ---------------------------------------------------------------
      h4("Plot"),
      
      # Select variable for y-axis ---------------------------------------------
      selectInput(inputId = "y", 
                  label = "Y-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "audience_score"),
      
      # Select variable for x-axis ---------------------------------------------
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("IMDB rating" = "imdb_rating", 
                              "IMDB number of votes" = "imdb_num_votes", 
                              "Critics Score" = "critics_score", 
                              "Audience Score" = "audience_score", 
                              "Runtime" = "runtime"), 
                  selected = "critics_score"),
      
      # Select variable for color ----------------------------------------------
      selectInput(inputId = "z", 
                  label = "Color by:",
                  choices = c("Title Type" = "title_type", 
                              "Genre" = "genre", 
                              "MPAA Rating" = "mpaa_rating", 
                              "Critics Rating" = "critics_rating", 
                              "Audience Rating" = "audience_rating"),
                  selected = "mpaa_rating"),
      
      # Set alpha level --------------------------------------------------------
      sliderInput(inputId = "alpha", 
                  label = "Alpha:", 
                  min = 0, max = 1, 
                  value = 0.5),
      
      # Set point size ---------------------------------------------------------
      sliderInput(inputId = "size", 
                  label = "Size:", 
                  min = 0, max = 5, 
                  value = 2, step = 0.5),
      
      # Visual separation ------------------------------------------------------
      br(), hr(),
      
      # Subtitle ---------------------------------------------------------------
      h4("Data"),
      
      # Show data table --------------------------------------------------------
      checkboxInput(inputId = "showdata",
                    label = "Show data table",
                    value = FALSE)
      
    ),
    
    # Output: ------------------------------------------------------------------
    mainPanel(
      
      # Show scatterplot -------------------------------------------------------
      plotOutput(outputId = "scatterplot"),
      br(),
      
      # Print number of obs plotted --------------------------------------------
      uiOutput(outputId = "n"),
      br(), br(),
      
      # Show data table --------------------------------------------------------
      DT::dataTableOutput(outputId = "moviestable")
    )
  )
)

# Define server function -------------------------------------------------------
server <- function(input, output) {
  
  # Take a random sample -------------------------------------------------------
  movies_sample <- eventReactive(      
    input$sample_button, {
      movies %>% sample_n(input$n_samp)
    },
    ignoreNULL = FALSE                     # perform calculation upon launch <--
  )
  
  # Create scatterplot object the plotOutput function is expecting -------------
  output$scatterplot <- renderPlot({
    ggplot(data = movies_sample(), aes_string(x = input$x, y = input$y, color = input$z)) +
      geom_point(alpha = input$alpha, size = input$size) + 
      labs(x = prettify_label(input$x),
           y = prettify_label(input$y),
           color = prettify_label(input$z)
      )
  })
  
  # Print number of movies plotted ---------------------------------------------
  output$n <- renderUI({
    movies_sample() %>% 
      count(title_type) %>% 
      mutate(description = glue("There are {n} {title_type} movies in this dataset. <br>")) %>% 
      pull(description) %>%
      HTML()
  })
  
  # Print data table -----------------------------------------------------------
  output$moviestable <- DT::renderDataTable({
    if(input$showdata){
      DT::datatable(data = movies_sample()[, 1:7],
                    options = list(pageLength = 10), 
                    rownames = FALSE)  
    }
  })
  
}

# Create the Shiny app object --------------------------------------------------
shinyApp(ui, server)
