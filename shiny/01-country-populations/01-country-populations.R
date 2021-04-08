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
                choices = country[c('Lesotho',
                            'Swaziland',
                            'South Africa')]
            )
        ),
        mainPanel(
            plotOutput("plot")
        )
    )
)

server <- function(input, output) {
    output$plot <- renderPlot({
        data <- populations %>% filter(code == input$country)# %>% filter(name == 'South Africa')
        ggplot(data, aes(x = year, y = population)) + 
        geom_point()
    })
}

shinyApp(ui = ui, server = server)

##What happens when you change the country selector? Is this what you would expect?

#>>There is no change in the graphic when changing between countries which is what one would expect when running the app

##Check the data for the problem

#>>choices are shown as character in side panel but these aren't linked to any data