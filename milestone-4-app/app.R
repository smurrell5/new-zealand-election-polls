
library(shiny)
library(nzelect)
library(ggplot2)
library(tidyverse)
library(rvest)

data <- nzelect::polls

data1 <- data %>%
    filter(Party %in% c("Labour", "National", "ACT", "NZ First", "Green")) %>%
    mutate(VotingIntention = VotingIntention * 100) %>%
    slice_tail(n = 144)

source("election_data.R")

# Define UI for application that draws a histogram
ui <- fluidPage(
    titlePanel("Comparing the 2017 and 2020 New Zealand Election Polls"),
    
    mainPanel(tabsetPanel(
        tabPanel("Plots", plotOutput("ggplot1"), plotOutput("ggplot2")),
        tabPanel("About", verbatimTextOutput("about"),
                 h3("Project Progress"),
                 p("A visualization of data for the 2017 and 2020 New Zealand general elections."),
                 h3("About Me"),
                 p("My name is Sammy, and I'm a senior studying Neuroscience and Health Policy. 
             You can reach me at samanthamurrell@college.harvard.edu.")))
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$ggplot1 <- renderPlot({
        
        data1 %>%
            ggplot(aes(x = WikipediaDates, y = VotingIntention, fill = Party)) +
            geom_col(position = "dodge", color = "white") +
            labs(title = "2017 Election Polls", subtitle = "Parties above the dashed line were expected to enter parliament", 
                 x = "Date", y = "Voting Intention (%)", 
                 caption = "Source: nzelect") +
            theme_linedraw() +
            scale_fill_manual(name = "Party", values = c("yellow2", "darkseagreen", "salmon1", "dodgerblue",
                                                         "slategrey")) +
            geom_hline(lty = "dashed", yintercept = 5, color = "black") +
            theme(axis.text = element_text(angle = 90))
        
        
    })
    
    output$ggplot2 <- renderPlot({
        
        tt_data3 %>%
            ggplot(aes(x = Year, y = VotingIntention, fill = Party)) +
            geom_col(position = "dodge") +
            labs(title = "2020 Election Polls", subtitle = "Parties above the dashed line are expected to enter Parliament",
                 x = "Date", y = "Voting Intention (%)",
                 caption = "Source: Wikipedia") +
            theme_linedraw() +
            scale_fill_manual(name = "Party", values = c("yellow2", "darkseagreen", "salmon1", "dodgerblue",
                                                         "slategrey")) +
            geom_hline(lty = "dashed", yintercept = 5, color = "black") +
            theme(axis.text = element_text(angle = 90))
        
        
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
