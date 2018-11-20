################################################
################################################
library(shiny)
library(ggplot2)
library(stats)
library(lubridate)
library(DT)
library(sqldf)

options(shiny.maxRequestSize = 15*1024^2)
shinyServer(function(input,output){
  
  # Importing data and save it temporary in data variable
  data <- reactive({
    read.table(file = ".....\\TopBullets\\R Codes\\Countries-Continents-csv.csv",
               sep = ",", header = T,
               stringsAsFactors = F)
  })
  

  
  # Showing the original data
  output$table <- DT::renderDataTable({
    if(is.null(data())){return()}
    DT::datatable(data(), options = list(scrollX = T))
  })



  # Creating filters
  output$continent <- renderUI({
    selectInput(inputId = "Continent", "Select Continent",choices = var_continent(), selected = "Asia")
  })
  output$country <- renderUI({
    selectInput(inputId = "Country", "Select Country",choices = var_country(), selected = "India")
  })
  output$state <- renderUI({
    selectInput(inputId = "State", "Select State",choices = var_state(),selected = "Goa")
  })

  
  
  # Cascasing filter for state
  
  var_continent <- reactive({
    file1 <- data()
    if(is.null(data())){return()}
    as.list(unique(file1$Continent))
  })
  
  # Creating reactive function to subset data
  continent_function <- reactive({
    file1 <- data()
    continent <- input$Continent
    file2 <- sqldf(sprintf("select * from file1 where Continent = '%s' ", continent))
    return (file2)
    
  })
  
  var_country <- reactive({
    file1 <- continent_function()
    if(is.null(file1)){return()}
    as.list(unique(file1$Country))

  })
  

  state_function <- reactive({
    file1 <- continent_function()
    country <- input$Country
    file2 <- sqldf(sprintf("select * from file1 where Country = '%s' ", country))
    return (file2)
    
  })
  
  var_state <- reactive({
    file1 <- state_function()
    as.list(unique(file1$State))
  })
  
  output$table_subset <- DT::renderDataTable({
    file1 <- state_function()
    state <- input$State
    file2 <- sqldf(sprintf("select * from file1 where State = '%s' ", state))
    DT::datatable(file2, options = list(scrollX = T))
    
  })
 
})
############################ CODE ENDS HERE ###########################################
