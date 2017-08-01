#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_moving_average
# TITLE:        Fix value out of range min/max in HS 
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that apply a moving average filter
#' 
#' @param DATA zoo data 
#' @param PERIOD_LENGTH moving average window
#' 

fun_moving_average=function(DATA, PERIOD_LENGTH){
  
  data_raw_3=DATA
  data_filtered=filter(data_raw_3,rep(1/PERIOD_LENGTH,PERIOD_LENGTH))
  data_filtered=zoo(data_filtered, order.by = index(data_raw_3))
  
  return(data_filtered)
}



