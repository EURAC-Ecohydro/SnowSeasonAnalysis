#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_savitzky_golay
# TITLE:        Fix value out of range min/max in HS 
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
NULL

#' Function that apply a savitzky_golay. See https://cran.r-project.org/web/packages/signal/signal.pdf
#' 
#' @param DATA zoo data 
#' @param FILTER_ORDER filter order
#' @param FILTER_LENGTH filter length (must be odd)
#' 


fun_savitzky_golay=function(DATA, FILTER_ORDER,FILTER_LENGTH){
  
  p = FILTER_ORDER
  n = FILTER_LENGTH
  sg <- sgolay(p, n, m=0)
  data_filtered=filter(sg,DATA)
  data_filtered=zoo(data_filtered, order.by = index(DATA))
  
  return(data_filtered)
}



