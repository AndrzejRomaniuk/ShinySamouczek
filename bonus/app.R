#Wczytywnanie wymaganych bibliotek
library(ggplot2)
library(shiny)
library(DT)
library(shinythemes)

#Interfejs Użytkownika (standardowy układ z paskiem bocznym)
ui <- fluidPage(
  theme = shinytheme("yeti"),          
  
  h1("Basic dataset exploration",      
     align = "center"),                 
  
  sidebarLayout(                       
    
    sidebarPanel(                      
      h3("Iput Data"),     
      fileInput(                        
        "Dataset",                     
        "Input dataset",                
        accept = c(
          "text/csv",
          "text/comma-separated-values,text/plain",
          ".csv"
        )
      ),
      textInput(                        
        "ColumnFactor",                 
        "Factor column name",
        value = NULL
      ),
      textInput(                        
        "ColumnData",
        "Data column name",
        value = NULL
      ),
      checkboxInput(                    
        inputId = "Joint",                
        label = "Factors Joint?",           
        value = TRUE
      ),                       
      selectInput(                       
        inputId = "BinsHow",          
        label = h4("Bin Scale"),         
        choices = list(
                    "Small (Scale)"  = 0,
                    "Large (Input)" = 1 
        ), selected = "Small (Scale)"
      ),
      conditionalPanel( 
        condition = (        
          "input.BinsHow == 0"), 
              sliderInput(                        
        inputId = "BinSize1",          
        label = h4("Bin size"),
        min = 0.1,
        max = 1,
        value = 0.3
        )
        ),
      conditionalPanel( 
        condition = (        
          "input.BinsHow == 1"), 
        numericInput(                        
          inputId = "BinSize2",          
          label = h4("Bin size"),
          min = 1,
          max = 1000,
          value = 10
        )
      ), 
      
      
      h3("Results Download"),
      downloadButton("downloadData", "Summary statistics"),                       
      downloadButton("downloadData2", "Box plots")                            
    )
    ,
    mainPanel(                            
      tabsetPanel(                         
        tabPanel(
          "Input Table",  
          dataTableOutput(               
            'inputTable')               
        ),
        tabPanel(
          "Data Chosen",  
          dataTableOutput(                 
            'resultTable')                 
        ),
        tabPanel(                       
          "Plot", 
          plotOutput(                      
            "resultPlot")            
        ),
        tabPanel(
          "Summary",   
          verbatimTextOutput(            
            "resultPrint")                 
        ),
        tabPanel(
          "About the app", 
          strong("Example of a more complex Shiny app"),
          p(" "),
          p("This Shiny app was rewritten from a tutorial example,
            to showcase some more complex possibilites that Shiny library enables,
            including user data input and exporting output data."),
          p(" "),
          p("To run this app from GitHub 
            locally use either the code below:"),
          code('shiny::runGitHub("ShinySamouczek","AndrzejRomaniuk", 
               ref = "main", subdir = "bonus")'),
          p(" "),
          p("See the link below for Shiny official page:"),
          tags$a(href="https://shiny.rstudio.com/", 
                 "shiny.rstudio.com"),
          p(" "),
          p("See the link below for the tutorial GitHub page (Pl)"),
          tags$a(href="https://github.com/AndrzejRomaniuk/ShinySamouczek", 
                 "github.com/AndrzejRomaniuk/ShinySamouczek"),
          p(" "),
          p("App and related tutorial originally created fo CDCS UoE 
            by Andrzej A. Romaniuk, later translated for CAA Poland")
        )
      )
    )
    
  )
)

server <- function(input,output) {
  
  dataReactive <- reactive({               
    Input <- input$Dataset
    
    if (is.null(Input)){
      return(NULL)
    } else{
      DatasetUsed <- as.data.frame(read.csv(Input$datapath))
      return(DatasetUsed)
    }
  })
  
  stringReactive <- reactive({            
    StringsUsed <- c(
      input$ColumnFactor,
      input$ColumnData
    )
    return(StringsUsed)
  })
  
  dataReactive2 <- reactive({              
    Input <- input$Dataset
    
    if (is.null(Input)){
      return(NULL)
    } else{
      DatasetUsed <- as.data.frame(read.csv(Input$datapath))
      if (input$ColumnData == "" & input$ColumnFactor == "") {
        return(NULL)
      } else { 
        DatasetUsed <- DatasetUsed[stringReactive()]
        DatasetUsed[,input$ColumnFactor] <- as.factor(
          DatasetUsed[,input$ColumnFactor])
      }
      return(DatasetUsed)
    }
  })
  
  vals <- reactiveValues()  
  
  output$resultPlot <- renderPlot(        
    if (is.null(dataReactive2())){          
      return(NULL)                         
      
    } else{
      PlottedData <- ggplot(                
        dataReactive2(),                     
        aes(x=dataReactive2()[,2],          
            fill = dataReactive2()[,1])      
      ) +                                    
        geom_histogram(                         
          binwidth = 
            if (input$BinsHow == 0) {
             input$BinSize1 
            } else if (input$BinsHow == 1) {
              input$BinSize2  
            }
            ,          
          boundary = 0,                      
          colour="black"
        ) + 
        theme_classic() + 
        labs(y=NULL,x=NULL) +
        guides(fill=guide_legend(title=colnames(dataReactive2())[1])) +
        if (input$Joint == FALSE) {       
          facet_wrap(~dataReactive2()[,1])
        } else {                          
        }
      vals$ggpl <-PlottedData
      return(PlottedData)
    }                                   
  )                                                                       
  

SummaryData <- reactive({
    if (is.null(dataReactive2())){         
      return(NULL)                        
      
    } else{    
      if (input$Joint == FALSE) {           
        for (i in 1:nlevels(dataReactive2()[,1])) {
          print(
            levels(dataReactive2()[,1])[i],                
            row.names = FALSE                
          )
          print(
            summary(
              subset(
                dataReactive2(), 
                dataReactive2()[,1] == levels(dataReactive2()[,1])[i]
              )[,2]                          
            ),                               
            row.names = FALSE
          )
        }
      } else {
        {summary(dataReactive2())}            
      }                                    
    }
  })
  
  
  output$resultPrint <- renderPrint(       
    SummaryData()
  )                                   
  
  output$inputTable <- renderDataTable(  
    dataReactive(),                        
    options = list(dom = 'ltp'),          
    rownames= FALSE                      
  )
  
  output$resultTable <- renderDataTable(   
    dataReactive2(),                 
    options = list(dom = 'ltp'),  
    rownames= FALSE                        
  )
  
  output$downloadData <- downloadHandler(                                      
    filename = function(){
      paste("results.txt")
    },
    content = function(file) {
      writeLines(paste(capture.output( {SummaryData()} )), file)                                                                 
    }
  )
  
  output$downloadData2 <- downloadHandler(                              
    filename = function() {"Boxplot.png"},
    content = function(file) {
      png(file)
      print(vals$ggpl)
      dev.off()
    }, contentType = 'image/png'
  )    
}

shinyApp(ui = ui, server = server)
