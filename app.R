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

library(shiny)
library(DBI)

ui <- fluidPage(
    numericInput("nrows", "Enter the number of rows to display:", 5),
    tableOutput("tbl")
)

server <- function(input, output, session) {
    output$tbl <- renderTable({
        conn <- dbConnect(
            drv = RMySQL::MySQL(),
            dbname = "shinydemo",
            host = "shiny-demo.csa7qlmguqrf.us-east-1.rds.amazonaws.com",
            username = "guest",
            password = "guest")
        on.exit(dbDisconnect(conn), add = TRUE)
        dbGetQuery(conn, paste0(
            "SELECT * FROM City LIMIT ", input$nrows, ";"))
    })
}

shinyApp(ui, server)
