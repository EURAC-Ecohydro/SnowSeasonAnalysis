#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_dygraphs_snow_detection.R
# TITLE:        Read and adjust data
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         18/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
NULL

#' Function that plot snow presence using three models: only PAR, only Soil Temperature, combination of PAR and Soil Temperature and Snow Height
#' 
#' @param FILE name of file to plot for title
#' @param SNOW_HEIGHT column of zoo data correspondig to Snow_Height (calibrated or not)
#' @param ST_MODEL snow presence using only some checks on Soil Temperature 
#' @param PAR_MODEL snow presence using only some checks on Photosintetically Active Radiation
#' @param MODEL snow presence using the combination of Soil Temperature and PAR

fun_plot_models_HS=function(FILE, SNOW_HEIGHT,ST_MODEL, PAR_MODEL, MODEL){
  
  HS=SNOW_HEIGHT
  ST=ST_MODEL*0.33
  PAR=PAR_MODEL*0.66
  ST_PAR=MODEL
  
  m=merge(HS,ST_PAR,ST,PAR)
  colnames(m)=c("HS","TS+PAR", "TS", "PAR")
  
  graph= dygraph(m,main = paste(FILE,"Snow detection models", sep=" - ")) %>% dyRangeSelector()%>%
    dySeries("HS",axis = "y2", color = "grey",strokeWidth = 1)%>%
    dySeries("TS",axis = "y",color = "red",fillGraph = T,stepPlot = T) %>%
    dySeries("PAR",axis = "y",color = "blue",fillGraph = T,stepPlot = T) %>%
    dySeries("TS+PAR",axis = "y",color = "green",fillGraph = T,stepPlot = T,strokeWidth = 1.5) %>%
    dyAxis("y",valueRange = c(0,1.1),label = "Snow presence") %>%
    dyAxis("y2",valueRange = c(0,1.1),label = "Snow Height [m]") %>%
    dyLegend(show = c("auto"),showZeroValues = T)
  
  return(graph)
  
}

NULL

#' Function that plot snow presence using three models: only PAR, only Soil Temperature, combination of PAR and Soil Temperature without Snow Height
#' 
#' @param FILE name of file to plot for title
#' @param ST_MODEL snow presence using only some checks on Soil Temperature 
#' @param PAR_MODEL snow presence using only some checks on Photosintetically Active Radiation
#' @param MODEL snow presence using the combination of Soil Temperature and PAR
#' 


fun_plot_models=function(FILE,ST_MODEL, PAR_MODEL, MODEL){
  
  ST=ST_MODEL*0.33
  PAR=PAR_MODEL*0.66
  ST_PAR=MODEL
  
  m=merge(ST_PAR,ST,PAR)
  colnames(m)=c("TS+PAR", "TS", "PAR")
  
  graph=dygraph(m,main = paste(FILE,"Snow detection models", sep=" - ")) %>% dyRangeSelector()%>%
    dySeries("ST",axis = "y",color = "red",fillGraph = T,stepPlot = T) %>%
    dySeries("PAR",axis = "y",color = "blue",fillGraph = T,stepPlot = T) %>%
    dySeries("ST+PAR",axis = "y",color = "green",fillGraph = T,stepPlot = T,strokeWidth = 1.5) %>%
    dyAxis("y",valueRange = c(0,1.1),label = "Snow presence") %>%
    dyAxis("y2",valueRange = c(0,1.1),label = "Snow Height [m]") %>%
    dyLegend(show = c("auto"),showZeroValues = T)
  
  return(graph)
  
}

