library(shiny)
library(shinythemes)
library(tidyverse)
library(CodeClanData)


ui <- fluidPage(
    theme = shinytheme("slate"),
    
    titlePanel(h1("Top Olympic Medals", align = "center")),
    
    fluidRow(
        column(3,
               radioButtons(inputId = "Season",
                            label = "Choose Season",
                            choices = c("Summer", "Winter")
               )
        ),
        column(3,
               radioButtons(inputId = "Medal",
                            label = "Choose Medal Type",
                            choices = c("Bronze", "Silver", "Gold")
               )
        ),
        column(6,
               sliderInput(inputId = "num_of_countries",
                           label = "Number of Countries",
                           min = 1,
                           max = 20,
                           value = 3,
                           ticks = T)
        )
    ),
    plotOutput(outputId = "medal_plot")
)

server <- function(input, output) {
    
    output$medal_plot <- renderPlot({
        
        olympics_overall_medals %>%
            filter(medal == input$Medal) %>%
            filter(season == input$Season) %>%
            arrange(desc(count)) %>% 
            head(input$num_of_countries) %>% 
            ggplot() +
            aes(x = reorder(team, -count), y = count, fill = medal) +
            geom_col(show.legend = F) +
            scale_fill_manual(
                values = c(
                    "Bronze" = "#e67300",
                    "Silver" = "#b3b3b3",
                    "Gold" = "#ffc61a"
                )
            ) +
            labs(x = "Country", y = "Number of Medals") +
            theme(axis.text.x = element_text(colour = "white", size = 10, angle = 40, vjust = 0.7),
                  axis.text.y = element_text(colour = "white"),
                  panel.background = element_rect(fill = "#272B30", colour = NA),
                  plot.background = element_rect(fill = "#272B30", colour = NA),
                  text = element_text(size = 15, colour = "white", face = "bold"),
                  panel.grid = element_blank())
    })
}

shinyApp(ui = ui, server = server)