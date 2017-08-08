#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_range.R
# TITLE:        Extract 1 variable from data table excluding data out of physical range of measurement
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that exclude data having value out of physical range.
#' 
#' @param DATA zoo data 
#' @param VARIABLE variable to apply filter min/max
#' 

fun_range=function(DATA,VARIABLE,RANGE){
  
  range_data=read.csv(RANGE,stringsAsFactors = F)
  
  
  if(any(colnames(DATA) == VARIABLE)){
    
    MIN=range_data$MIN[which(range_data$VARIABLE==VARIABLE)]
    MAX=range_data$MAX[which(range_data$VARIABLE==VARIABLE)]
    
    if(is.na(MIN) | is.na(MAX)){
      warning(paste(paste("Set up  the range of admitted values for '",VARIABLE ,"'.",sep = ""),"Miseed file Range_min_max.csv",sep = "\n"))
    }
    
    raw=DATA[,which(colnames(DATA)==VARIABLE)]
    new=raw
    new[which(new<MIN)]=NA
    new[which(new>MAX)]=NA
    
    return(new)
  } else {
    warning(paste("No column called '",VARIABLE,"'. Check input table!",sep=""))
    return(0)
  }
  
}