# Packages ----------------------------------------------------------------

library(shiny)
library(ggplot2)
library(huge)
library(qgraph)
library(psych)
library(pcalg)
library(igraph)
library(graphicalVAR)
library(markdown)
library(mlVAR)
library(foreign)
library(XLConnect)
library(dplyr)
library(NetworkComparisonTest)
library(glmnet)

# example dataset for demo versions
data(bfi)
big5 <- bfi[,1:25]

shinyServer(
  function(input, output, session) {
    
    # Upload data -------------------------------------------------------------
    
    # Define global data with estimation 
    data <- reactive({
      
      inFile <- input$input
      
      if(input$demo == TRUE)
      {
        file <- big5
      } else 
      {
        if (is.null(inFile))
        {
          return(NULL)
        }
        
        # Code missing values
        na <- NULL
        if (input$missing == "NA")
        {
          na <- "NA"
        }
        else if (input$missing == FALSE)
        {
          na <- FALSE
        }
        else 
        {
          na <- as.numeric(input$missing)
        }
        
        if(input$allcolumns == TRUE)
        {
          if(input$typedata == ".txt")
          {
            file <- read.table(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors, header = TRUE)
          } else if(input$typedata == ".csv")
          {
            file <- read.csv(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors, sep = ";")
          }  else if(input$typedata == ".sav")
          {
            file <- read.spss(inFile$datapath, to.data.frame = TRUE)
          }
        } else
        {
          if(input$typedata == ".txt")
          {
            file <- read.table(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors, header = TRUE)
          }  else if(input$typedata == ".csv")
          {
            file <- read.csv(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors)[,input$columnrangefrom:input$columnrangeto]
          } else if(input$typedata == ".sav")
          {
            file <- read.spss(inFile$datapath, to.data.frame = TRUE)[,input$columnrangefrom:input$columnrangeto]
          }
        }
      }
    }) # exit data uploading
    
    # Use chosen layout
    lay <- reactive({
      switch(input$layout,
             "Circle" = "circle",
             "Spring" = "spring",
             "Grouped Circle" = "groups")
    })
    
    # Print graph details
    det <- reactive({
      if(input$details == TRUE)
      {
        TRUE
      } else
      {
        FALSE
      }
    })
    
    weight <- reactive ({
      if(input$weighted == TRUE)
      {
        TRUE
      } else
      {
        FALSE
      }
    })
    
    # Use directed edges TRUE/FALSE
    direct <- reactive({
      if(input$direction == TRUE)
      {
        TRUE
      } else
      {
        FALSE
      }
    })    
    
    # Add a title
    tit <- reactive({
      input$title     
    })
    
    # Specify threshold value
    thres <- reactive({
      input$threshold
    })
    
    # Specify minimum edge weight
    min <- reactive({
      input$minimum 
    })
    
    # Specify maximum edge weight
    max <- reactive({
      input$maximum 
    })
    
    # Specify cut-off value
    ct <- reactive({
      input$cut})
    
    # Specify edge size
    es <- reactive({
      input$edgesize  
    })
    
    # Specify node size
    ns <- reactive({
      input$nodesize
    })  
    
    plotdiag <- reactive({
      input$diagonal
    })
    
    # Apply non-paranormal transformation TRUE/FALSE in different networks
    norm <- reactive({
      if(input$normal == TRUE)
      {
        cor_auto(huge.npn(data()))
      } else if(input$sortdata == "Correlation Matrix")
      {
        data()
      } else  
      {
        cor_auto(data())
      }
      
    })
    
    #  Estimation method network
    est <- reactive({
      if(!input$method == "FDRnetwork")
      {
        switch(input$method,
               "GLASSO" = "glasso",
               "Pearson Correlation" = "cor",
               "Partial Correlation" = "pcor") 
      }         
    })
    
    # Indicate nodeshape
    shapenode <- reactive({
      switch(input$nodeshape,
             "Circle" = "circle",
             "Diamond" = "diamond",
             "Heart" = "heart",
             "Square" = "square",
             "Triangle" = "triangle")
    })
    
    # Print node labels
    lab <- reactive({
      if(input$node_labels == TRUE)
      {
        abbreviate(colnames(data()), input$abbreviate)
      } else
      {
        FALSE
      }     
    })
    
    # Visualize network
    output$network <- renderPlot({       
      
      if(is.null(data()))
      {
        return(NULL)
      } else if(input$sortdata == "Raw Data" | input$sortdata == "Correlation Matrix")
      {
        qgraph(norm(),
               layout = lay(), 
               labels = lab(),
               title = tit(),
               minimum = min(),
               maximum = max(),
               cut = ct(),
               details = det(),
               esize = es(),
               vsize = ns(),
               weighted = weight(),
               directed = direct(),
               sampleSize = input$samplesize,
               graph = est(),
               threshold = thres(),
               shape = shapenode(),
               diag = plotdiag())
      } else if(input$sortdata == "Adjacency Matrix")
      {
        
        # Visualize adjacency matrix
        qgraph(data(),
               layout = lay(), 
               labels = lab(),
               title = tit(),
               minimum = min(),
               maximum = max(),
               cut = ct(),
               details = det(),
               esize = es(),
               vsize = ns(),
               weighted = weight(),
               directed = direct(),
               threshold = thres(),
               shape = shapenode(),
               diag = plotdiag())
      } else if(input$sortdata == "Edgelist")
      {
        # Visualize edgelist
        qgraph(data(),
               layout = lay(), 
               labels = lab(),
               title = tit(),
               minimum = min(),
               maximum = max(),
               cut = ct(),
               details = det(),
               esize = es(),
               vsize = ns(),
               weighted = weight(),
               directed = direct(),
               threshold = thres(),
               shape = shapenode(),
               diag = plotdiag())
      }
      
      
    }, height = 600) # exit network rendering

    # Calculate small-world index
    
    SWI <- reactive({
      
      if(input$sortdata == "Raw Data")
      {
        as.numeric(smallworldness(qgraph(norm(),
                                         graph = est(),
                                         sampleSize = input$samplesize,
                                         weighted = weight(),
                                         directed = direct(),
                                         threshold = thres(),
                                         minimum = min(),
                                         maximum = max(),
                                         cut = ct(),
                                         diag = plotdiag()))[1])
      } else if(input$sortdata == "Adjacency Matrix")
      {
        as.numeric(smallworldness(qgraph(data(),
                                         weighted = weight(),
                                         directed = direct(),
                                         threshold = thres(),
                                         minimum = min(),
                                         maximum = max(),
                                         cut = ct(),
                                         diag = plotdiag()))[1])
      } else if(input$sortdata == "Edgelist")
      {
        as.numeric(smallworldness(qgraph(data(),
                                         weighted = weight(),
                                         directed = direct(),
                                         threshold = thres(),
                                         minimum = min(),
                                         maximum = max(),
                                         cut = ct(),
                                         diag = plotdiag()))[1])
      } 
    }) # exit SWI
    
    # display SWI
    
    output$swi <- renderPrint({
      SWI()
    })
    
    output$downloadnetwork <- downloadHandler(
      filename = function()
      {
        paste("network", class = ".pdf", sep = "") 
      },
      content = function(file) 
      {
        pdf(file)
        if(input$sortdata == "Raw Data")
        {
          qgraph(norm(),
                 layout = lay(), 
                 labels = lab(),
                 title = tit(),
                 minimum = min(),
                 maximum = max(),
                 cut = ct(),
                 details = det(),
                 esize = es(),
                 vsize = ns(),
                 weighted = weight(),
                 directed = direct(),
                 sampleSize = input$samplesize,
                 graph = est(),
                 threshold = thres(),
                 shape = shapenode(),
                 diag = plotdiag())
        } else if(input$sortdata == "Adjacency Matrix")
        {
          qgraph(data(),
                 layout = lay(), 
                 labels = lab(),
                 title = tit(),
                 minimum = min(),
                 maximum = max(),
                 cut = ct(),
                 details = det(),
                 esize = es(),
                 vsize = ns(),
                 weighted = weight(),
                 directed = direct(),
                 threshold = thres(),
                 shape = shapenode(),
                 diag = plotdiag())
        } else if(input$sortdata == "Edgelist")
        {
          qgraph(data(),
                 layout = lay(), 
                 labels = lab(),
                 title = tit(),
                 minimum = min(),
                 maximum = max(),
                 cut = ct(),
                 details = det(),
                 esize = es(),
                 vsize = ns(),
                 weighted = weight(),
                 directed = direct(),
                 threshold = thres(),
                 shape = shapenode(),
                 diag = plotdiag())
        }
        dev.off()
      }) # exit download plot
    
    # Download example dataset
    exampledata <- reactive({
      bfi[,1:25]
    })
    
    output$downloadexample <- downloadHandler(
      filename = function()
      {
        paste("bfi", class = ".csv", sep = "") 
      },
      content = function(file) 
      {
        write.csv(exampledata(), file)
      }) #exit download example dataset
    
    
    # Set centrality measures for plot
    stren <- reactive({
      if(input$sortdata == "Raw Data")
      {
        if(input$strength == TRUE)
        {
          "Strength"
        }
      } 
    })
    
    between <- reactive({
      if(input$betweenness == TRUE)
      {
        "Betweenness"
      }
    })
    
    close <- reactive({
      if(input$closeness == TRUE)
      {
        "Closeness"
      }
    })
    
    indeg <- reactive({
      if(input$sortdata == "Adjacency Matrix" | input$sortdata == "Edgelist")
      {
        if(input$indegree == TRUE)
        {
          "InStrength"
        }
      }
    })
    
    outdeg <- reactive({
      if(input$sortdata == "Adjacency Matrix" | input$sortdata == "Edgelist")
      {
        if(input$outdegree == TRUE)
        {
          "OutStrength"
        }
      }
    })
           
    #######################
    ### CENTRALITY PLOT ###
    #######################
    
    output$centplot <- renderPlot({
      
      # Plot centrality results
      if(input$sortdata == "Raw Data")
      {
        cent <- centralityPlot(qgraph(norm(),
                                      sampleSize = input$samplesize,
                                      graph = est(),
                                      weighted = weight(),
                                      directed = direct(),
                                      labels = lab(),
                                      DoNotPlot = TRUE), include = c(stren(), between(), close()), standardized = input$standardizedcentplot)
      } else if(input$sortdata == "Adjacency Matrix")
      {
        cent <- centralityPlot(qgraph(data(),
                                      weighted = weight(),
                                      directed = direct(),
                                      labels = lab(),
                                      DoNotPlot = TRUE), include = c(between(), close(), indeg(), outdeg()), standardized = input$standardizedcentplot)
      } else if(input$sortdata == "Edgelist")
      {
        cent <- centralityPlot(qgraph(data(),
                                      weighted = weight(),
                                      directed = direct(),
                                      DoNotPlot = TRUE), include = c(between(), close(), indeg(), outdeg()), standardized = input$standardizedcentplot)
      }
      
      # Flip plot if chosen
      if(input$horizontal == TRUE)
      {
        print(cent + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1)) + coord_flip())
      } else
      {
        print(cent + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1)))
      }
      
    }) # exit centrality plot

    
    # Download centrality plot
    output$downloadcentralityplot <- downloadHandler(
      
      filename = function()
      {
        paste("centrality_plot", class = ".pdf", sep = "") 
      },
      content = function(file) 
      {
        if(input$horizontal == TRUE)
        {
          pdf(file)
          if(input$sortdata == "Raw Data")
          {
            g <- centralityPlot(qgraph(norm(),
                                       sampleSize = input$samplesize,
                                       graph = est(),
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1)) + coord_flip()
          } else if(input$sortdata == "Adjacency Matrix")
          {
            g <- centralityPlot(qgraph(data(), 
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1)) + coord_flip()
          } else if(input$sortdata == "Edgelist")
          {
            g <- centralityPlot(qgraph(data(), 
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1)) + coord_flip()
          }
          print(g)
          dev.off()
        } else
        {
          pdf(file)
          if(input$sortdata == "Raw Data")
          {
            g <- centralityPlot(qgraph(norm(),
                                       sampleSize = input$samplesize,
                                       graph = est(),
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1))
          } else if(input$sortdata == "Adjacency Matrix")
          {
            g <- centralityPlot(qgraph(data(),
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1))
          } else if(input$sortdata == "Edgelist")
          {
            g <- centralityPlot(qgraph(data(),
                                       weighted = weight(),
                                       directed = direct(),
                                       labels = lab(),
                                       DoNotPlot = TRUE), print = FALSE, include = c(stren(), between(), close(), indeg()), standardized = input$standardizedcentplot) + theme(axis.text.x = element_text(size = 5, angle = 45, hjust = 1, vjust = 1))
          }
          print(g)
          dev.off()
        }
      }) # exit download centrality plot
    
    ########################
    ### CENTRALITY TABLE ###
    ########################
    
    strentab <- reactive({
      if(input$strengthtab == TRUE)
      {
        "Strength"
      }
    })
    
    betweentab <- reactive({
      if(input$betweennesstab == TRUE)
      {
        "Betweenness"
      }
    })
    
    closetab <- reactive({
      if(input$closenesstab == TRUE)
      {
        "Closeness"
      }
    })
    
    # Create centrality table
    centtable <- reactive({  
      ncol <- rep(FALSE, times = 10)
      
      ncol[2] = TRUE
      if(input$direction == FALSE)
      {
        if(input$strengthtab == TRUE)
        {
          ncol[8] = TRUE
        }
      }
      if(input$betweennesstab == TRUE)
      {
        ncol[4] = TRUE
      }
      if(input$closenesstab == TRUE)
      {
        ncol[6] = TRUE
      }
      if(input$direction == TRUE)
      {
        if(input$indegreetab == TRUE)
        {
          ncol[8] = TRUE
        }      
      }
      if(input$direction == TRUE)
      {
        if(input$outdegreetab == TRUE)
        {
          ncol[10] = TRUE
        }
      }
    
    # Print centrality table
    centtab <- reactive({
      if(input$sortdata == "Raw Data")
      {
        centralityTable(qgraph(norm(),
                               sampleSize = input$samplesize,
                               graph = est(),
                               weighted = weight(),
                               directed = direct(),
                               labels = lab(),
                               DoNotPlot = TRUE), standardized = input$standardizedcenttab)
      } else if(input$sortdata == "Adjacency Matrix")
      {
        centralityTable(qgraph(data(),
                               weighted = weight(),
                               directed = direct(),
                               labels = lab(),
                               DoNotPlot = TRUE), standardized = input$standardizedcenttab)
      } else if(input$sortdata == "Edgelist")
      {
        centralityTable(qgraph(data(),
                               weighted = weight(),
                               directed = direct(),
                               labels = lab(),
                               DoNotPlot = TRUE), standardized = input$standardizedcenttab)
      } 
    })
    
    reshape(centtab(), timevar = "measure",
            idvar = c("graph", "node"),
            direction = "wide")[, ncol]
    
    }) #exit centrality table (global variable)
    
    # Print centrality table
    output$centtable <- renderTable({
      print(centtable())
    }) #exit centrality table 
    
    # Download centrality table
    output$downloadcentralitytable <- downloadHandler(            
      filename = function()
      {
        paste("centrality_table", class = ".csv", sep = "") 
      },            
      content = function(file) 
      {
        write.csv(centtable(), file, row.names = FALSE)
      }) #exit download centrality table
    
    
    ##########################
    ### Network Comparison ###
    ##########################
    
    # Dataset 1
    data1 <- reactive({
      
      inFile <- input$input1
      
      if (is.null(inFile))
      {
        return(NULL)
      }
      
      # Code missing values
      na <- NULL
      if (input$missing1 == "NA")
      {
        na <- "NA"
      }
      else if (input$missing1 == FALSE)
      {
        na <- FALSE
      }
      else 
      {
        na <- as.numeric(input$missing1)
      }
      
      if(input$typedata1 == ".txt")
      {
        file <- read.table(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors, header = TRUE)
      } else if(input$typedata1 == ".csv")
      {
        file <- read.csv(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors)
      } else if(input$typedata1 == ".sav")
      {
        file <- read.spss(inFile$datapath, to.data.frame = TRUE)
      }
      
      file <- file[rowSums(is.na(file)) == 0,]
      
    })
    
    
    # Dataset 2
    data2 <- reactive({
      
      inFile <- input$input2
      
      if (is.null(inFile))
      {
        return(NULL)
      }
      
      # Code missing values
      na <- NULL
      if (input$missing2 == "NA")
      {
        na <- "NA"
      }
      else if (input$missing2 == FALSE)
      {
        na <- FALSE
      }
      else 
      {
        na <- as.numeric(input$missing2)
      }
      
      if(input$typedata2 == ".txt")
      {
        file <- read.table(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors, header = TRUE)
      } else if(input$typedata2 == ".csv")
      {
        file <- read.csv(inFile$datapath, na.strings = na, stringsAsFactors = input$stringfactors)
      } else if(input$typedata2 == ".sav")
      {
        file <- read.spss(inFile$datapath, to.data.frame = TRUE)
      }
      
      file <- file[rowSums(is.na(file)) == 0,]
      
    })
    
    itt <- reactive({
      input$it
    })
    
    gamm <- reactive({
      input$gamma
    })
    
    weightNCT <- reactive({
      input$weightedNCT
    })
    
    #### Network Comparison Test
    
    AndOr <- reactive({
      switch(input$andor,
             "AND-rule"  = TRUE,
             "OR-rule"  = FALSE)
    })
    
    output$compnetwork <- renderPrint({
      print("p-value")
      
      if(input$binary == TRUE)
      {
        if(input$test == "global strength")
        {
          NCT(data1(), data2(), gamma = gamm(), it = itt(), weighted = weightNCT(), binary.data = TRUE, progressbar = FALSE, AND = AndOr())$glstrinv.pval
        } else
        {
          NCT(data1(), data2(), gamma = gamm(), it = itt(), weighted = weightNCT(), binary.data = TRUE, progressbar = FALSE, AND = AndOr())$nwinv.pval
        }
        
      } else
      {
        if(input$test == "global strength")
        {
          NCT(data1(), data2(), gamma = gamm(), it = itt(), weighted = weightNCT(), binary.data = FALSE, progressbar = FALSE, AND = AndOr())$glstrinv.pval
        } else
        {
          NCT(data1(), data2(), gamma = gamm(), it = itt(), weighted = weightNCT(), binary.data = FALSE, progressbar = FALSE, AND = AndOr())$nwinv.pval
        }
      }
    })
    
    
    # output$downloadhelp <- downloadHandler(            
    #   filename = function()
    #   {
    #     paste("Helpfile", class = ".pdf", sep = "") 
    #   },            
    #   content = function(file) {
    #     file.copy('Manual.pdf', file)
    #   }) #exit download manual
    # 
    
  } # exit shiny server
)