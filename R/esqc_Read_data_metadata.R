#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Read_data_metadata.R
# TITLE:        Read and adjust data
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         11/04/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that import and prepare data in the proper format for ESOLIP_QC
#' 
#' @param PATH path of input folder
#' @param FILE file in input folder to process (hourly aggregated)
#' 

fun_read_data=function(PATH,FILE){
  
  # read data
  data=read.csv(paste(PATH,FILE,sep = ""),stringsAsFactors = F)
  
  # split data and units
  units=data[c(1,2),]
  data=data[-c(1,2),]
  
  # Check if in data table there is Precip_T_Int15_Metadata 
  
  if(colnames(data)[ncol(data)]=="Precip_T_Int15_Metadata"){
    METADATA=T
    warning(paste("OK! This file contains 'Precip_T_Int15_Metadata'.","  You can read it with 'fun_read_metadata' function.",sep = "\n"))
  }else{
    METADATA=F
  }
  
  if(METADATA==T){
    for(j in 2:(ncol(data)-1)){
      data[,j]=as.numeric(data[,j])
    }
    
    # define a POSIXct time 
    year <- substring(data[,1],1,4); month <- substring(data[,1],6,7); day <- substring(data[,1],9,10)
    hour <- substring(data[,1],12,13); min  <- substr(data[,1],15,16);
    date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", min, ":00", sep="")
    time <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
    
    # create a zoo variable
    zoo_data=zoo(data[,-c(1,ncol(data))], order.by = time)
    
  }else{
    
    # convert data as numeric, except TIMESTAMP (1st column) and Precip_T_Int15_Metadata (last column)
    for(j in 2:ncol(data)){
      data[,j]=as.numeric(data[,j])
    }
    
    # define a POSIXct time 
    year <- substring(data[,1],1,4); month <- substring(data[,1],6,7); day <- substring(data[,1],9,10)
    hour <- substring(data[,1],12,13); min  <- substr(data[,1],15,16);
    date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", min, ":00", sep="")
    time <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
    
    # create a zoo variable
    zoo_data=zoo(data[,-1], order.by = time)
  }
  
  return(zoo_data)
}

#' Function that read Precip_T_Int15_Metadata
#' 
#' @param PATH path of input folder
#' @param FILE file in input folder to process (hourly aggregated)
#' 
fun_read_metadata=function(PATH,FILE){
  
  # read data
  data=read.csv(paste(PATH,FILE,sep = ""),stringsAsFactors = F)
  
  # split data and units
  units=data[c(1,2),]
  data=data[-c(1,2),]
  
  # Check if in data table there is Precip_T_Int15_Metadata 
  if(colnames(data)[ncol(data)]=="Precip_T_Int15_Metadata"){
    METADATA=T
  }else{
    METADATA=F
    warning("This file doesn't contain 'Precip_T_Int15_Metadata'. No 'Precip_T_Int15_Metadata' available!")
    warning("Function: read_metadata has not assigned any new variable! Be careful!")
  }
  
  if(METADATA==T){
  # convert data as numeric, except TIMESTAMP (1st column) and Precip_T_Int15_Metadata (last column)
  # for(j in 2:(ncol(data)-1)){
  #   data[,j]=as.numeric(data[,j])
  # }
  
  # define a POSIXct time 
  year <- substring(data[,1],1,4); month <- substring(data[,1],6,7); day <- substring(data[,1],9,10)
  hour <- substring(data[,1],12,13); min  <- substr(data[,1],15,16);
  date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", min, ":00", sep="")
  time <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  # create a zoo variable
  zoo_metadata=zoo(data[,ncol(data)], order.by = time)
  }
  
  return(zoo_metadata)
}

#' Function that import and extract units and type of sampling from input data
#' 
#' @param PATH path of input folder
#' @param FILE file in input folder to process (hourly aggregated)
#' 
fun_read_units=function(PATH,FILE){
  data=read.csv(paste(PATH,FILE,sep = ""),stringsAsFactors = F)
  
  # split data and units
  units=data[c(1,2),]
  
  df=rbind(colnames(units), units)
  
  return(df)
}