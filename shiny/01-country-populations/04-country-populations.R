library(dplyr)
library(ggplot2)
library(shiny)
#install.packages(DT)
library(DT)
library(plotly)

load("country-population.rda")

ui <- fluidPage(
    titlePanel("Population Explosion"),
    sidebarLayout(
        sidebarPanel(
            selectInput("country", "Country", choices = country, selected = "ZAF", multiple = TRUE),
            sliderInput("size", "Point size", min = 0, max = 5, value = 1),
            checkboxInput("line", "Plot line")
        ),
        mainPanel(
            plotlyOutput("plot"),
            DTOutput("table")
        )
    )
)

server <- function(input, output) {
    output$plot <- renderPlotly({
        data <- populations %>% filter(code %in% input$country)
        p <- ggplot(data, aes(x = year, y = population / 1000000)) +
            scale_y_log10("Population (million)")
        if (input$line) p <- p + geom_line(aes(group = code))
        ggplotly(p + geom_point(aes(color = code), size = input$size))
    })
    output$table <- DT::renderDataTable({
        data <- populations %>%
            filter(code %in% input$country) %>%
            group_by(code) %>%
            arrange(code, desc(year)) %>%
            slice(1)
    })
}

shinyApp(ui = ui, server = server)
