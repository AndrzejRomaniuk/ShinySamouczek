#Instalacja wymaganych bibliotek
if (!require("ggplot2")) install.packages("ggplot2")
if (!require("shiny")) install.packages("shiny")
if (!require("DT")) install.packages("DT")
if (!require("shinythemes")) install.packages("shinythemes")

#Wczytywnanie wymaganych bibliotek
library(ggplot2)
library(shiny)
library(DT)
library(shinythemes)

#Interfejs Użytkownika (standardowy układ z paskiem bocznym)
ui <- fluidPage(
  theme = shinytheme("yeti"),           #Wybrany motyw (biblioteka shinythemes)
  h1("Exploring Iris data set",         #Tytuł aplikacji,
     align = "center"),                 #wyrównany do środka
  sidebarLayout(                        #Układ z paskiem bocznym
    sidebarPanel(                       #Pasek boczny z możliwością
      selectInput(                      #wyboru danych wejściowych  
        inputId = "Measurements",        #Najpierw dajemy użytkownikowi wybór 
        label = h4("Measurement"),       #co dokładnie chce przeanalizować
        choices = list(                  #(lista pomiarów do wyboru)
          "Sepal.Length" = "Sepal.Length", 
          "Sepal.Width"  = "Sepal.Width",
          "Petal.Length" = "Petal.Length",
          "Petal.Width"  = "Petal.Width"), 
        selected = "Sepal.Length"
      ),
      
      checkboxGroupInput(                  #Po drugie, które gatunki powinny 
        inputId = "Species",               #być wziete pod uwagę
        label = h4("Species"),             #(pole wielokrotnego wyboru)
        choices = list(
          "setosa" = "setosa",
          "versicolor" = "versicolor",
          "virginica" = "virginica"
        ),
        selected = "setosa"
      ),
      
      conditionalPanel(                    #Po trzecie, użytkowni precyzuje, czy
        condition = (                      #wszystkie gatunki wybrane
          "input.Species.length > 1"),     #analizować razem czy oddzielnie
        checkboxInput(                     #(pojedyńcze pole wyboru, widoczne
        inputId = "Joint",                 #tylko gdy wiecej niż jeden gatunek
        label = "Joint Species?",          #jest wybrany w poprzednim punkcie)   
        value = TRUE)),                       
      
      sliderInput(                         #Na końcu, jak duże powinny być kosze 
        inputId = "BinSize",               #w generowanym histogramie
        label = h4("Bin size"),
        min = 0.1,
        max = 1,
        value = 0.3)
    )
    ,
    mainPanel(                             #Panel wyświetląjacy wyniki 
      tabsetPanel(                         #w formie zakładek
        tabPanel(                          #(3 wyniki przewidziane)  
          "Plot", 
          plotOutput(                      #histogram
            "resultPlot")            
        ),
        tabPanel(
          "Summary",   
          verbatimTextOutput(              #podsumowanie pomiarów
            "resultPrint")                 #(min/max, kwartyle etc.)
        ),                                    
        tabPanel(
          "Table",  
          dataTableOutput(                 #Tablica z oryignalnymi danymi
            'resultTable')                 #wybranymi do analizy
        ),
        tabPanel(                          #Zakładka z informacjami o aplikacji
          "About the app",                 #(czysto informacyjne, dla 
          p(" "),                          #użytkownika)
          strong("Example of a working Shiny app"),
          p(" "),
          p("This Shiny app was written as an 
             example for the tutorial teaching 
             how to create a Shiny app. It is 
             based on Fisher/Anderson’s Iris data 
             set, enabling interactive exploration
            of the data."),
          p(" "),
          p("To run this app from GitHub 
            locally use either the code below (Eng, with Pl explanation):"),
          code('shiny::runGitHub("ShinySamouczek","AndrzejRomaniuk", 
               ref = "main", subdir = "appexample")'),
          p(" "),
          p("(Eng, original):"),
          code('shiny::runGitHub("ShinyTutorial","DCS-training", 
               ref = "main", subdir = "appexample")'),
          p(" "),
          p("See the link below for Shiny official page:"),
          tags$a(href="https://shiny.rstudio.com/", 
                 "shiny.rstudio.com"),
          p(" "),
          p("See the link below for the tutorial GitHub page (Pl)"),
          tags$a(href="https://github.com/AndrzejRomaniuk/ShinySamouczek", 
                 "github.com/AndrzejRomaniuk/ShinySamouczek"),
          p(" "),          
          p("(ENG)"),
          tags$a(href="https://github.com/DCS-training/ShinyTutorial", 
                 "github.com/DCS-training/ShinyTutorial"),
          p(" "),
          p("App and related tutorial originally created fo CDCS UoE 
            by Andrzej A. Romaniuk, later translated for CAA Poland")
        )
      )
    )
    
  )
)

#Część serwerowa aplikacji (zawierąca kod odpowiedzialny za właściwą analizę
#danych, na bazie danych wejsciowych od użytkownika; wyniki zapisane jako dane
#wyjściowe)
server <- function(input,output) {
  
  dataReactive <- reactive({               #Po pierwsze, tworzymy podzbiór                    
    subset(iris,                           #potrzebnych danych z oryginalnego
           Species %in% input$Species,     #zbioru Iris
           select = c(                     #(gatunki wybrane, plus kolumna 
             input$Measurements,           #tekstowa z gatunkami)
             "Species")                    
    )
  })
  
  output$resultPlot <- renderPlot(         #Renderowanie wymaganego histogramu
    ggplot(                                #Przy użyciu biblioteki ggplot
      dataReactive(),                      #z wcześniej przygotowanym podzbiorem
      aes(x=dataReactive()[,1],            #Pomiar wybrany jako X
          fill = Species)                  #gatunki jako wypełnienie
    ) +                                    #dla lepszej czytelności wykresu
      geom_histogram(                         
        binwidth = input$BinSize,          #wielkość kosza, ustalona przez
        boundary = 0,                      #użytkownika
        colour="black"
      ) + 
      theme_classic() + 
      labs(y=NULL,x=NULL) +
      if (input$Joint == FALSE) {       #Jeżeli użytkownik zaznaczył
        facet_wrap(~Species)            #oddzielną analizę wybranych gatunków
      } else {                          #zamiast jenego wykresu dla wszystkich
      })                                #wygenerowane zostaną 
                                        #oddzielne wykresy dla każdego gatunku
  
  output$resultPrint <- renderPrint(       #Podsumowanie wyników
    if (input$Joint == FALSE) {            #(Jeżeli analizowane oddzielnie)
      for (i in 1:length(input$Species)) {
        print(
          input$Species[i],                #Wydruk oddzielnie...
          row.names = FALSE                
        )
        print(
          summary(
            subset(
              dataReactive(), 
              Species == input$Species[i]  #analizy opisowej dla każdego gatunku 
            )[,1]                          
          ),                               
          row.names = FALSE
        )
      }
    } else {
      {summary(dataReactive())}            #(jeżeli analizowane razem)
    })                                     #Wydruk analizy opisowej
  
  
  output$resultTable <- renderDataTable(   #Na końcu, tworzenie tabeli
    dataReactive(),                        #z wcześniej utworzonego podzbioru,
    options = list(dom = 'ltp'),           #dla wglądu przez użytkownika
    rownames= FALSE                        #(interaktywność organiczona)
  )
}

#shinyApp() ostatecznie łączy dwie strony aplikacji w funkjonalną całość
shinyApp(ui = ui, server = server)
