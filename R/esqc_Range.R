#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Range.R
# TITLE:        Extract one variable from data table excluding data out of physical range of measurement
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that replace value out of range min/max with NaN
#' 
#' @param DATA zoo time series
#' @param VARIABLE variable in zoo time series to filter
#' @param git_folder local folder where package is cloned. 
#'

fun_range=function(DATA,VARIABLE,git_folder){
  
  range_data=read.csv(paste(git_folder,"data/Support files/Range_min_max.csv",sep = ""),stringsAsFactors = F)
  
  
  if(any(colnames(DATA) == VARIABLE)){
    
    MIN=range_data$MIN[which(range_data$VARIABLE==VARIABLE)]
    MAX=range_data$MAX[which(range_data$VARIABLE==VARIABLE)]
    
    if(is.na(MIN) | is.na(MAX)){
      warning(paste(paste("Set up  the range of admitted values for '",VARIABLE ,"'.",sep = ""),"See: ",paste(git_folder,"data/Support files/Range_min_max.csv",sep = ""),sep = "\n"))
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