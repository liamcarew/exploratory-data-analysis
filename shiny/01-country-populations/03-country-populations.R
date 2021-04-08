library(dplyr)
library(ggplot2)
library(shiny)
library(scales)
#install.packages(DT)
library(DT)

load("country-population.rda")

ui <- fluidPage(
    titlePanel("Population Explosion"),
    sidebarLayout(
        sidebarPanel(
            selectInput("country", "Country", choices = country, selected = NULL, multiple=TRUE),
            sliderInput("size", "Point size", min = 0, max = 5, value = 1),
            checkboxInput("line", "Plot line")
        ),
        mainPanel(
            plotOutput("plot"),
            checkboxInput('table', 'Show Table'),
            dataTableOutput('table')
        )
    )

)

server <- function(input, output) {
    output$plot <- renderPlot({
        data <- populations %>% filter(code %in% input$country)
        p <- ggplot(data, aes(x = year, y = population, colour = code))
        if (input$line) p <- p + geom_line()
        p + geom_point(size = input$size) + scale_y_continuous(labels = label_number(scale = 1e-6)) + labs(y = 'population (millions)')
    })
    output$table <- renderDataTable(if(input$table){populations %>%
        filter(code %in% input$country) %>%
        arrange(desc(year)) %>%
        slice(1)})
}

shinyApp(ui = ui, server = server)
