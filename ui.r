########################################################################
############################ R SHINY TUTORIAL #########################
########################################################################

# The code will help user to make cascading filters
# Author: Deepesh Singh
# https://rstudio.github.io/shinydashboard/structure.html

#install.packages("shinyjs")

library(shinyjs)
library(stats)
library(shinydashboard)
library(sqldf)
#library(dplyr)
#library(shinyFilters)

setwd("....\\TopBullets\\R Codes")

header <- dashboardHeader(
  title = "TopBullets.com Dashboard",
  dropdownMenu(type = "notifications",
               notificationItem(
                 text = "Designed by Deepesh Singh",
                 icon("cog", lib = "glyphicon")
               )
  )
)
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Data", tabName = "ShowData", icon = icon("dashboard")),
    menuItem("Summary", tabName = "ShowSummary", icon = icon("bar-chart-o"))
  )
)

body <- dashboardBody(
  useShinyjs(),
  tabItems(
    tabItem(tabName = "ShowData",
            DT::dataTableOutput("table")
    ),
    tabItem(tabName = "ShowSummary",
            box(width =3,
              h3("Tutorial by TopBullets.com"),
              helpText("Please Continent, Country and State Combition"),
              uiOutput("continent"),
              uiOutput("country"),
              uiOutput("state")
            ),
            
            box(width =9,
                #h3("Plot"),
                #DT::dataTableOutput("subsetRegion"),
                DT::dataTableOutput("table_subset")
            )
    )

    
  )
)

# Put them together into a dashboardPage
dashboardPage(
  header,
  sidebar,
  body
)