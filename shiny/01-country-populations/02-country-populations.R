library(dplyr)
library(ggplot2)
library(shiny)

load("./shiny/01-country-populations/country-population.rda")

ui <- fluidPage(
    titlePanel("Population Explosion"),
    sidebarLayout(
        sidebarPanel(
            selectInput(
                inputId = "country",
                label = "Country",
                choices = country,
                selected = "ZAF"
            ),
            sliderInput(min = 0,
                        max = 5,
                        value = 1,
                        label = 'Point size',
                        inputId = 'size'),
            checkboxInput(label='Plot line',
                          inputId = 'line')
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server <- function(input, output) {
    output$plot <- renderPlot({
        data <- populations %>% filter(code == input$country)
        p <- ggplot(data, aes(x = year, y = population)) + geom_point(size=input$size)
        if (input$line){
            p <- p + geom_line()
        }
        p
    })
}

shinyApp(ui = ui, server = server)
