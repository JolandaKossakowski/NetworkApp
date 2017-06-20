## Network App ##


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
                                          ".txt",
                                          ".xls",
                                          ".xlsx",
                                          ".sav"), selected = ".txt"),   
               
               # Specify kind of data
               selectInput('sortdata', 
                           label = "Specify the kind of data that is uploaded:",
                           choices = list("Raw Data",
                                          "Adjacency Matrix",
                                          "Edgelist"), selected = "Raw Data"),  
               
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
                        checkboxInput("allcolumns", "All columns", FALSE))),
               
               # Are string to be coded as factor objects?
               checkboxInput("stringfactors", "Strings as factors", FALSE),
               
               # Specify coding for NAs
               textInput("missing",
                         label = "Missing value coding:"),
               
               # Choose network estimation method
               selectInput("method",
                           label = "Network Estimation Method:",
                           choices = c("FDRnetwork",
                                       "GLASSO",
                                       "Graphical VAR: PCC",
                                       "Graphical VAR: PDC",
                                       "IC-Algorithm: DAG",
                                       "IC-Algorithm: Skeleton",
                                       "Multilevel VAR: 2-level",
                                       "Multilevel VAR: 3-level",
                                       "Partial Correlation",
                                       "Pearson Correlation",
                                       "VAR-model"),
                           selected = "Partial Correlation"),
               
               tags$hr(),
               
               # Download example data
               downloadButton('downloadexample', 'Download Example Data'),
               
               h5("Authors"),
               p("Jolanda Kossakowski <mail@jolandakossakowski.eu> & Sacha Epskamp & Claudia van Borkulo"),
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
               
               ## Panel for basic estimation methods
               
               conditionalPanel(
                 condition = "input.method == 'Partial Correlation' || input.method == 'GLASSO' || input.method == 'Pearson Correlation' || input.method == 'Graphical VAR: PCC' || input.method == 'Graphical VAR: PDC'",
                 
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
               
               ## Panel for FDR network
               conditionalPanel(
                 condition = "input.method == 'FDRnetwork'",
                 
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
                   
                   column(4,
                          # Select what value to use for FDR-network
                          selectInput("FDRmethod",
                                      label = "Method for FDR Network:",
                                      choices = c("Local FDR",
                                                  "None",
                                                  "p-value",
                                                  "q-value"),
                                      selected = "None")),
                   
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
                                        label = "Plot Self-Loops",
                                        value = FALSE))),
                 
                 fluidRow(
                   column(4),
                   column(3,
                          
                          # Select size of nodes
                          sliderInput("nodesize",
                                      label = "Node Size:",
                                      min = 0,
                                      max = 25,
                                      value = 6.1))),
                 
                 fluidRow(
                   column(4),
                   
                   
                   column(3,
                          
                          # Set cut-off value for FDR network
                          sliderInput("cutoffFDR",
                                      label = "Cut-off value FDR network:",
                                      min = 0.0001,
                                      max = 1,
                                      value = 0.05)))),
               
               
               
               ## Panel for IC-algorithm networks
               conditionalPanel(
                 condition = "input.method == 'IC-Algorithm: DAG' || input.method == 'IC-Algorithm: Skeleton'",
                 
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
                   
                   column(4,
                          
                          # Method for IC-algorithm
                          selectInput("pcindep",
                                      label = "Method for Conditional Independence IC-Algorithm:",
                                      choices = c("Binary",
                                                  "Discrete",
                                                  "D-separation",
                                                  "Gaussian",
                                                  "None"),
                                      selected = "None")),
                   
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
                                        label = "Plot Self-Loops",
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
               
               ## Panel for VAR network
               
               conditionalPanel(
                 condition = "input.method == 'VAR-model'",
                 
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
                   
                   column(4,
                          
                          # Select distribution family VAR-network
                          selectInput("VARmethod",
                                      label = "Distribution family for VAR-model:",
                                      choices = c("Binary",
                                                  "Gaussian",
                                                  "None"),
                                      selected = "None")),
                   
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
                                        label = "Plot Self-Loops",
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
               
               # Panel for multilevel VAR network with 2 levels
               conditionalPanel(
                 condition = "input.method == 'Multilevel VAR: 2-level'",
                 
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
                          
                          # Plot graph details TRUE/FALSE
                          checkboxInput("details",
                                        label = "Graph Details",
                                        value = FALSE))),
                 
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
                          
                          # apply non-paranormal transformation TRUE/FALSE
                          checkboxInput("normal",
                                        label = "Non-Paranormal Transformation",
                                        value = FALSE))),
                 
                 fluidRow(
                   
                   column(4,
                          #idvar
                          selectInput("idvar",
                                      "Subject Identification Variable",
                                      "")),
                   
                   column(3,
                          
                          # Select maximum value edge weights
                          sliderInput("maximum",
                                      label = "Maximum Edge Weight:",
                                      min = 0,
                                      max = 1,
                                      value = 1)),
                   
                   column(3,
                          #stepwise
                          checkboxInput("stepwise", "Stepwise Estimation", TRUE))),
                 
                 fluidRow(
                   column(4,
                          #critFun
                          selectInput("critfun", 
                                      label = "Information Criterion",
                                      choices = list("AIC", 
                                                     "BIC"), selected = "AIC")),
                   
                   column(3,
                          
                          # Select cut-off value edge weights
                          sliderInput("cut",
                                      label = "Edge Cut-Off Value:",
                                      min = 0,
                                      max = 1,
                                      value = 0.1))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          # Select width edge
                          sliderInput("edgesize",
                                      label = "Edge Size:",
                                      min = 0,
                                      max = 25,
                                      value = 5))),
                 
                 fluidRow(
                   column(4),
                   column(3,
                          
                          # Select size of nodes
                          sliderInput("nodesize",
                                      label = "Node Size:",
                                      min = 0,
                                      max = 25,
                                      value = 6.1))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #vars
                          sliderInput("vars", 
                                      "Select Variable Columns",
                                      min = 1,
                                      max = 100,
                                      value = c(3, 10)))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #lags
                          sliderInput("lags", "Time Lag",
                                      min = 1,
                                      max = 10,
                                      value = c(1,1)))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #maxEffects
                          sliderInput("maxeffect",
                                      label = "Maximum Incoming edges per node",
                                      min = 1,
                                      max = 10,
                                      value = 6)))),
               
               # Panel for multilevel VAR network with 3 levels
               conditionalPanel(
                 condition = "input.method == 'Multilevel VAR: 3-level'",
                 
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
                          
                          # Plot graph details TRUE/FALSE
                          checkboxInput("details",
                                        label = "Graph Details",
                                        value = FALSE))),
                 
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
                          
                          # apply non-paranormal transformation TRUE/FALSE
                          checkboxInput("normal",
                                        label = "Non-Paranormal Transformation",
                                        value = FALSE))),
                 
                 fluidRow(
                   
                   column(4,
                          #idvar
                          selectInput("idvar",
                                      "Subject Identification Variable",
                                      "")),
                   
                   column(3,
                          
                          # Select maximum value edge weights
                          sliderInput("maximum",
                                      label = "Maximum Edge Weight:",
                                      min = 0,
                                      max = 1,
                                      value = 1)),
                   
                   column(3,
                          #stepwise
                          checkboxInput("stepwise", "Stepwise Estimation", TRUE))),
                 
                 fluidRow(
                   column(4,
                          #dayvar
                          selectInput("dayvar", 
                                      "Day Identification Variable", 
                                      "")),
                   
                   column(3,
                          
                          # Select cut-off value edge weights
                          sliderInput("cut",
                                      label = "Edge Cut-Off Value:",
                                      min = 0,
                                      max = 1,
                                      value = 0.1))),
                 
                 fluidRow(
                   column(4,
                          #critFun
                          selectInput("critfun", 
                                      label = "Information Criterion",
                                      choices = list("AIC", 
                                                     "BIC"), selected = "AIC")),
                   
                   column(3,
                          # Select width edge
                          sliderInput("edgesize",
                                      label = "Edge Size:",
                                      min = 0,
                                      max = 25,
                                      value = 5))),
                 
                 fluidRow(
                   column(4),
                   column(3,
                          
                          # Select size of nodes
                          sliderInput("nodesize",
                                      label = "Node Size:",
                                      min = 0,
                                      max = 25,
                                      value = 6.1))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #vars
                          sliderInput("vars", 
                                      "Select Variable Columns",
                                      min = 1,
                                      max = 100,
                                      value = c(3, 10)))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #lags
                          sliderInput("lags", "Time Lag",
                                      min = 1,
                                      max = 10,
                                      value = c(1,1)))),
                 
                 fluidRow(
                   column(4),
                   
                   column(3,
                          #maxEffects
                          sliderInput("maxeffect",
                                      label = "Maximum Incoming edges per node",
                                      min = 1,
                                      max = 10,
                                      value = 6)))),
               
               br(),
               br()),
      
      
      
      
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
      
      tabPanel("Clustering Plot", 
               br(),
               br(),
               plotOutput("clustplot"),
               
               tags$hr(),
               
               fluidRow(
                 column(4,
                        # Visualize WS measure
                        checkboxInput("ws",
                                      label = "WS", 
                                      value = TRUE)),
                 
                 # Turn clustering plot 90 degrees
                 column(4,
                        checkboxInput("horizontal",
                                      label = "Flip plot", 
                                      value = FALSE))),
               
               fluidRow(
                 column(4,
                        # Visualize zhang measure
                        checkboxInput("zhang",
                                      label = "Zhang",
                                      value = TRUE)),
                 column(3,
                        # return standardized values
                        checkboxInput("standardizedclustplot",
                                      label = "Standardized",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Visualize Onnela measure
                        checkboxInput("onnela",
                                      label = "Onnela",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Visualize Barrat measure
                        checkboxInput("barrat",
                                      label = "Barrat",
                                      value = TRUE))),
               
               tags$hr(), 
               
               # Download clustering plot
               downloadButton('downloadclusteringplot', 'Download Clustering Plot')),
      
      tabPanel("Clustering Table",
               br(),
               br(),
               tableOutput("clusttable"),
               
               fluidRow(
                 column(4,
                        # Print WS measure
                        checkboxInput("wstab",
                                      label = "WS", 
                                      value = TRUE)),
                 
                 column(3,
                        # return standardized values
                        checkboxInput("standardizedclusttab",
                                      label = "Standardized",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Print Zhang measure
                        checkboxInput("zhangtab",
                                      label = "Zhang",
                                      value = TRUE))),
               
               fluidRow(
                 column(4,
                        # Print Onnela measure
                        checkboxInput("onnelatab",
                                      label = "Onnela",
                                      value = TRUE))),
               fluidRow(
                 column(4,
                        # Print Barrat measure
                        checkboxInput("barrattab",
                                      label = "Barrat",
                                      value = TRUE))),
               
               tags$hr(),
               
               # Download clustering table
               downloadButton('downloadclusteringtable', 'Download Clustering Table'),
               
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
                                                   ".xls",
                                                   ".xlsx",
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
                                                   ".xls",
                                                   ".xlsx",
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
               
               includeHTML("Manual.html")
      )
    )
  )
)
)


