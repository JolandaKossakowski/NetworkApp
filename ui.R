
# Network App - UI --------------------------------------------------------

shinyUI(pageWithSidebar(
  titlePanel("Network App"),
  sidebarPanel(position = "right",
               
               p("The options below are needed to specify how your file looks like. If you do not have any data but you want to see how the application works, click “Demo version”  and a dataset is automatically updated that is available via the psych package. The example dataset comprises of 25 NEO-PI-R items: 5 items per trait."),
               
               br(),
               
               # Specify if demo data is to be used
               checkboxInput("demo", 
                             label = "Demo Version", 
                             value = FALSE),
               
               # Specify type of data
               selectInput('typedata', 
                           label = "Specify your type of data here:",
                           choices = list(".csv",
                                          ".sav",
                                          ".txt"), selected = ".txt"),   
               
               # Specify kind of data
               selectInput('sortdata', 
                           label = "Specify the kind of data that is uploaded:",
                           choices = list("Raw Data",
                                          "Adjacency Matrix",
                                          "Edgelist",
                                          "Correlation Matrix"), selected = "Raw Data"),  
               
               # Upload file
               fileInput('input', 'Choose file'),
               
               
               # Specify the columns that are to be used
               
               fluidRow(
                 column(4,
                        numericInput("columnrangefrom",
                                     label = "From column",
                                     value = 1)),
                 column(4,
                        
                        numericInput("columnrangeto",
                                     label = "To column",
                                     value = 1)),
                 column(4,
                        # use all columns in datafile
                        checkboxInput("allcolumns", "All columns", TRUE))),
               
               
               fluidRow(
                 column(4,
                        # Are string to be coded as factor objects?
                        checkboxInput("stringfactors", "Strings as factors", FALSE)),
                 
                 column(4,
                        numericInput("samplesize",
                                     label = "Sample size",
                                     value = 1))),
               
               
               
               # Specify coding for NAs
               textInput("missing",
                         label = "Missing value coding:"),
               
               # Choose network estimation method
               selectInput("method",
                           label = "Network Estimation Method:",
                           choices = c("GLASSO",
                                       "Partial Correlation",
                                       "Pearson Correlation"),
                           selected = "GLASSO"),
               
               tags$hr(),
               
               fluidRow(
                 column(4,
                        # Download example data
                        downloadButton('downloadexample', 'Download Example Data'))),
               
               
               
               h5("Authors"),
               p("Jolanda Kossakowski <mail[at]jolandakossakowski[dot]eu> & Sacha Epskamp & Claudia van Borkulo"),
               br(),
               p("If you want to run the application in R, please run the following R-code:"),
               tags$a(href = "https://raw.githubusercontent.com/JolandaKossakowski/NetworkApp/master/runapp.R", "R-code")),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Network", 
               br(),
               br(),
               
               plotOutput("network", width = "100%", height = "100%"),
               
               br(),
               br(),
               br(),
               br(),
               br(),
               br(),
               br(),
               
               
               p("The Small-World Index of this network is"),
               
               verbatimTextOutput("swi"),
               
               br(),
               
               downloadButton('downloadnetwork', 'Download PDF'),
               
               br(),
               br(),
               br(),
               
               fluidRow(
                 column(4,
                        
                        # Insert title plot
                        textInput("title",
                                  label = "Title:")),
                 
                 column(3,
                        
                        # Abbreviate node labels
                        sliderInput("abbreviate",
                                    label = "Abbreviate node labels",
                                    min = 1,
                                    max = 20,
                                    value = 3)),
                 
                 column(3,
                        
                        # Use node labels TRUE/FALSE
                        checkboxInput("node_labels",
                                      label = "Node Labels", 
                                      value = TRUE))),
               
               
               fluidRow(
                 column(4,
                        
                        # Select network layout
                        selectInput("layout",
                                    label = "Network Layout:",
                                    choices = c("Circle", 
                                                "Spring"),
                                    selected = "Spring")),
                 
                 column(3,
                        
                        # Set threshold for edge weight
                        sliderInput("threshold",
                                    label = "Edge Threshold:",
                                    min = 0,
                                    max = 1,
                                    value = 0)),
                 
                 column(3,
                        
                        # Weighted graph TRUE/FALSE
                        checkboxInput("weighted",
                                      label = "Edge Weights",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        
                        # Select node shape
                        selectInput("nodeshape",
                                    label = "Node shape:",
                                    choices = c("Circle",
                                                "Diamond",
                                                "Heart",
                                                "Square",
                                                "Triangle"),
                                    selected = "Circle")),
                 
                 column(3,
                        
                        # Select minimum value edge weights
                        sliderInput("minimum",
                                    label = "Minimum Edge Weight:",
                                    min = 0,
                                    max = 1,
                                    value = 0)),
                 
                 column(3,    
                        
                        # Directed edges TRUE/FALSE
                        checkboxInput("direction",
                                      label = "Directed Edges",
                                      value = FALSE))),
               
               fluidRow(
                 
                 column(4),
                 
                 column(3,
                        
                        # Select maximum value edge weights
                        sliderInput("maximum",
                                    label = "Maximum Edge Weight:",
                                    min = 0,
                                    max = 1,
                                    value = 1)),
                 
                 column(3,
                        
                        # Plot graph details TRUE/FALSE
                        checkboxInput("details",
                                      label = "Graph Details",
                                      value = FALSE))),
               
               fluidRow(
                 column(4),
                 
                 column(3,
                        
                        # Select cut-off value edge weights
                        sliderInput("cut",
                                    label = "Edge Cut-Off Value:",
                                    min = 0,
                                    max = 1,
                                    value = 0.1)),
                 
                 column(3,
                        
                        # apply non-paranormal transformation TRUE/FALSE
                        checkboxInput("normal",
                                      label = "Non-Paranormal Transformation",
                                      value = FALSE))),
               
               fluidRow(
                 column(4),
                 column(3,
                        # Select width edge
                        sliderInput("edgesize",
                                    label = "Edge Size:",
                                    min = 0,
                                    max = 25,
                                    value = 5)),
                 
                 column(3,
                        
                        # Plot self-loops TRUE/FALSE
                        checkboxInput("diagonal",
                                      label = "Self-Loops",
                                      value = FALSE))),
               
               fluidRow(
                 column(4),
                 column(3,
                        
                        # Select size of nodes
                        sliderInput("nodesize",
                                    label = "Node Size:",
                                    min = 0,
                                    max = 25,
                                    value = 6.1)))),
      
      tabPanel("Centrality Plot", 
               br(),
               br(),
               plotOutput("centplot"),
               
               
               fluidRow(
                 column(4,
                        # Visualize strength measure
                        checkboxInput("strength",
                                      label = "Strength",
                                      value = FALSE)),
                 
                 column(3,
                        # Flip centrality plots 90 degrees
                        checkboxInput("horizontal",
                                      label = "Flip plot", 
                                      value = FALSE))),
               
               fluidRow(
                 column(4,
                        # Visualize betweenness measure
                        checkboxInput("betweenness",
                                      label = "Betweenness",
                                      value = TRUE)),
                 
                 column(3,
                        # return standardized values
                        checkboxInput("standardizedcentplot",
                                      label = "Standardized",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Visualize closeness measure
                        checkboxInput("closeness",
                                      label = "Closeness",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Visualize indegree measure
                        # ONLY WITH ADJACENCY MATRIX OR EDGELIST
                        checkboxInput("indegree",
                                      label = "In Strength",
                                      value = FALSE))),
               
               fluidRow(
                 column(4,
                        # Visualize outdegree measure
                        # ONLY WITH ADJACENCY MATRIX OR EDGELIST
                        checkboxInput("outdegree",
                                      label = "Out Strength",
                                      value = FALSE))),
               
               tags$hr(),   
               
               # Download centrality plot
               downloadButton('downloadcentralityplot', 'Download Centrality Plot'),
               br(),
               br()),
      
      
      tabPanel("Centrality Table",
               br(),
               br(),
               tableOutput("centtable"),
               
               
               fluidRow(
                 column(4,
                        # Print strength measure
                        checkboxInput("strengthtab",
                                      label = "Strength",
                                      value = FALSE)),
                 column(3,
                        # return standardized values
                        checkboxInput("standardizedcenttab",
                                      label = "Standardized",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Print betweenness measure
                        checkboxInput("betweennesstab",
                                      label = "Betweenness",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Print closeness measure
                        checkboxInput("closenesstab",
                                      label = "Closeness",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Print indegree measure
                        # ONLY WITH ADJACENCY MATRIX OR EDGELIST
                        checkboxInput("indegreetab",
                                      label = "In Strength",
                                      value = FALSE))),
               
               fluidRow(
                 column(4,
                        # Print outdegree measure
                        # ONLY WITH ADJACENCY MATRIX OR EDGELIST
                        checkboxInput("outdegreetab",
                                      label = "Out Strength",
                                      value = FALSE))),
               
               tags$hr(),
               
               # Download centrality table
               downloadButton('downloadcentralitytable', 'Download Centrality Table'),
               
               br(),
               br()),
      
      
      tabPanel("Network Comparison", 
               br(),
               br(),
               
               fluidRow(
                 column(6,     
                        
                        h2("Dataset 1"),
                        
                        # Upload dataset 1
                        
                        selectInput('typedata1', 
                                    label = "Specify your type of data here:",
                                    choices = list(".csv",
                                                   ".txt",
                                                   ".sav"), selected = ".txt"),
                        
                        fileInput('input1', 'Choose file',
                                  accept=c('text/csv', 
                                           'text/comma-separated-values,text/plain', 
                                           '.csv'))),
                 
                 column(6,
                        
                        h2("Dataset 2"),
                        
                        
                        selectInput('typedata2', 
                                    label = "Specify your type of data here:",
                                    choices = list(".csv",
                                                   ".txt",
                                                   ".sav"), selected = ".txt"),
                        
                        fileInput('input2', 'Choose file',
                                  accept=c('text/csv', 
                                           'text/comma-separated-values,text/plain', 
                                           '.csv'))),
                 
                 column(6,
                        # Are string to be coded as factor objects?
                        checkboxInput("stringfactors1", "Strings as factors", FALSE)),
                 column(6, 
                        # Are string to be coded as factor objects?
                        checkboxInput("stringfactors2", "Strings as factors", FALSE)),
                 
                 column(6,
                        # Specify coding for NAs
                        textInput("missing1",
                                  label = "Missing value coding:")),
                 
                 column(6,
                        # Specify coding for NAs
                        textInput("missing2",
                                  label = "Missing value coding:")),
                 
                 h2("Network Comparison Test Specifications"),
                 
                 br(),
                 br(),
                 
                 
                 column(6,
                        
                        # specify amount of iterations
                        numericInput("it",
                                     label = "Amount of iterations",
                                     value = 100)),
                 
                 column(6,
                        
                        # specify gamma
                        numericInput("gamma",
                                     label = "Gamma",
                                     value = 0)),
                 
                 # which rule must be used?
                 column(6, 
                        selectInput("andor",
                                    label = "Rule to define edges",
                                    choices = list("AND-rule",
                                                   "OR-rule"), selected = "AND-rule")),
                 column(6,
                        selectInput("test",
                                    label = "Test specification",
                                    choices = list("global strength",
                                                   "maximum difference edges"),
                                    selected = "global strength")),
                 
                 # weighted network TRUE/FALSE
                 column(6, 
                        checkboxInput('weightedNCT', 'Weighted', FALSE)),
                 
                 
                 # binary data TRUE/FALSE
                 column(6, 
                        checkboxInput('binary', 'Binary data', FALSE)),
                 
                 
                 
                 br(),
                 br(),
                 verbatimTextOutput("compnetwork")
                 
               )
      ), 
      
      tabPanel("Help",
               br(),
               br(),
               br(),
               
               downloadButton('downloadhelp', 'Download User Manual'),
               br(),
               br(),
               br(),
               
               includeHTML("Manual_HTML.html")
        )
      )
    )
  )
)
