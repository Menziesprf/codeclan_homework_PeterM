library(shiny)
library(shinyWidgets)

source("prep_script.R")

# Countries vector for selecter
countries_vect <- tb_top20 %>% 
  distinct(country) %>% 
  pull()

# Age brackets for selecter
age_brackets <- c("0-4", "5-14", "15-24", "25-34", "35-44", "45-54", "55-64", "65+" = "65plus")


ui <- fluidPage(
  titlePanel("Estimated Incidence of TB in 2019 for the 20 Countries with the Highest Incidence"),
  tabsetPanel(
    tabPanel("Home",
      sidebarLayout(
        sidebarPanel(
          pickerInput(inputId = "countries",
                      label = NULL,
                      choices = countries_vect,
                      selected = countries_vect,
                      multiple = T,
                      options = list(`actions-box` = TRUE,
                                     `none-selected-text` = "Countries",
                                     `selected-text-format` = "static",
                                     `size` = "auto")
          ),
        ),
        mainPanel(
          plotOutput(outputId = "tbplot")
        )
      )
    ),
    tabPanel("Age and Gender",
      sidebarLayout(
        sidebarPanel(
          radioButtons(inputId = "gender",
                       label = "Gender:",
                       choices = c("Male" = "m",
                                   "Female" = "f"),
                       inline = T),
          checkboxGroupButtons(inputId = "age",
                               label = "Age Group(s):",
                               choices = age_brackets,
                               selected = age_brackets,
                               width = "70%")
        ),
        mainPanel(
          plotOutput(outputId = "tbplot_age_gender")
        )
      )
             
      
    ),
    tabPanel("Risk Factors",
      sidebarLayout(
        sidebarPanel(
          radioButtons(inputId = "riskfactor",
                       label = "Highlight a Risk Factor",
                       choices = c("Total Incidence" = "all",
                                   "Alcohol abuse" = "alc",
                                   "Diabetes" = "dia",
                                   "HIV" = "hiv",
                                   "Smoking" = "smk",
                                   "Malnutrition" = "und"),
                       selected = "all"
          )
        ),
        mainPanel(
          plotOutput(outputId = "tbplot_riskfactors")
        )
             
      )
    )
  )
)


server <- function(input, output) {
  
  output$tbplot <- renderPlot({
    
    tb_top20 %>% 
      filter(age_group == "all",
             sex == "a",
             risk_factor == "all",
             country %in% input$countries) %>% 
      arrange(country) %>% 
      ggplot() +
      aes(x = country, y = best/1000) +
      geom_col() +
      labs(x = "Country", y = "Estimated Incidence (thousands)") +
      scale_y_continuous(n.breaks = 8) +
      theme(axis.text.x = element_text(angle = 90),
            panel.background = element_blank())
  })
  
  output$tbplot_age_gender <- renderPlot({
    
    tb_top20 %>% 
      filter(age_group  %in%  input$age,
             sex == input$gender,
             risk_factor == "all") %>% 
      ggplot() +
      aes(x = country, y = best/1000) +
      geom_col() +
      labs(x = "Country", y = "Estimated Incidence (thousands)") +
      scale_y_continuous(n.breaks = 8) +
      theme(axis.text.x = element_text(angle = 90),
            panel.background = element_blank())
  })
  
  output$tbplot_riskfactors <- renderPlot({
    
    tb_top20 %>% 
      filter(sex == "a",
             risk_factor %in% input$riskfactor) %>% 
      ggplot() +
      aes(x = country, y = best/1000) +
      geom_col() +
      labs(x = "Country", y = "Estimated Incidence (thousands)") +
      scale_y_continuous(n.breaks = 8) +
      theme(axis.text.x = element_text(angle = 90),
            panel.background = element_blank())
  })
}

shinyApp(ui, server)