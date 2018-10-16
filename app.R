#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Shiny database interface
# https://shiny.rstudio.com/articles/overview.html

library(ggplot2)
library(dplyr)
library(shiny)
library(DBI)
library(odbc)
library(plotly)
library(here)
library(DT)

options(shiny.maxRequestSize = 30*1024^2)

ui <- fluidPage(
    # App title ----
    titlePanel("Explore Trawl Database"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Select a file ----
            fileInput("db", "Choose .accdb File",
                      multiple = FALSE,
                      accept = c(".accdb")),
            
            # Input: Select number of rows to display ----
            numericInput("nrows", "Enter the number of rows to display:", 5)
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Data file ----
            tableOutput("tbl")
            
        )
        
    )
)

server <- function(input, output, session) {
    output$tbl <- renderTable({
        conn  <- dbConnect(odbc(),
                           Driver = "Microsoft Access Driver (*.mdb, *.accdb)", 
                           DBQ = here("data/trawl_db.accdb"))
        on.exit(dbDisconnect(conn), add = TRUE)
        tbl(conn, "Specimen") %>% filter(species == 161828) %>% collect()
    })
}

shinyApp(ui, server)
