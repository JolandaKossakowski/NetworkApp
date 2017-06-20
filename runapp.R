if(!"shiny" %in% installed.packages()) 
{ 
  install.packages("shiny") 
}
library(shiny)

if(!"devtools" %in% installed.packages())
{
  install.packages("devtools")
}
library(devtools)

if(!"huge" %in% installed.packages())
{
  install.packages("huge")
}
library(huge)

if(!"qgraph" %in% installed.packages())
{
  install.packages("qgraph")
}
library(qgraph)

if(!"igraph" %in% installed.packages())
{
  install.packages("igraph")
}
library(igraph)

if(!"psych" %in% installed.packages())
{
  install.packages("psych")
}
library(psych)

if(!"ggplot2" %in% installed.packages())
{
  install.packages("ggplot2")
}
library(ggplot2)

if(!"graphicalVAR" %in% installed.packages())
{
  install.packages("graphicalVAR")
}
library(graphicalVAR)

source("https://bioconductor.org/biocLite.R")

if(!"graph" %in% installed.packages())
{
  biocLite("graph")
}
library(graph)

if(!"RBGL" %in% installed.packages())
{
  biocLite("RBGL")
}
library(RBGL)

if(!"pcalg" %in% installed.packages())
{
  install.packages("pcalg")
}
library(pcalg)

if(!"markdown" %in% installed.packages())
{
  install.packages("markdown")
}
library(markdown)

if(!"foreign" %in% installed.packages())
{
  install.packages("foreign")
}
library(foreign)

if(!"XLConnect" %in% installed.packages())
{
  install.packages("XLConnect")
}
library(XLConnect)

if(!"NetworkComparisonTest" %in% installed.packages())
{
  install_github('cvborkulo/NetworkComparisonTest') 
}
library(NetworkComparisonTest)

if(!"mlVAR" %in% installed.packages())
{
  install.packages("mlVAR")
}
library(mlVAR)

runGitHub("NetworkApp", "JolandaKossakowski") 
