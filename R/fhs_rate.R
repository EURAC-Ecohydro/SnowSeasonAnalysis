#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_rate.R
# TITLE:        Fix value out of range min/max in HS 
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
NULL

#' Function that exclude data having a rate too high (increase/decrease too fast)
#' 
#' @param DATA zoo data 
#' @param VARIABLE variable to apply filter of increasing/decresaing rate
#' 


fun_rate=function(DATA,VARIABLE,RATE){
  
  rate_data=read.csv(RATE,stringsAsFactors = F)
  
  MAX_DECREASE=rate_data$MAX_DECREASE[which(rate_data$VARIABLE==VARIABLE)]
  MAX_INCREASE=rate_data$MAX_INCREASE[which(rate_data$VARIABLE==VARIABLE)]
  
  if(is.na(MAX_DECREASE) | is.na(MAX_INCREASE)){
    warning(paste(paste("Set up admitted rates (increase/decrease) for '",VARIABLE ,"'.",sep = ""),"Missed file Rate_min_max.csv",sep = "\n"))
  }
  
  data_raw=DATA
  derivative=zoo(c(0,diff(data_raw)),order.by=index(data_raw))
  i_out_pos=which(derivative>MAX_INCREASE)
  i_out_neg=which(derivative<MAX_DECREASE)
  data_no_outliers=data_raw
  data_no_outliers[i_out_pos]=NA
  data_no_outliers[i_out_neg]=NA
  
  return(data_no_outliers)
  
}


