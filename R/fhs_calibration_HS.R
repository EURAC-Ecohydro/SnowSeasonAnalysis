#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   calibration_HS.R
# TITLE:        calibrate HS using end of season data
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         12/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Calibrate Snow Height signal using virtual surveys (HS = 0 cm at end of winter season)
#' 
#' @param DATA zoo data 
#' @param FILE_NAME file in input folder to process (hourly aggregated)
#' @param PATH_SURVEYS Path of virtual snow surveys

fun_calibration_HS=function(DATA,FILE_NAME,PATH_SURVEYS){
  
  surveys=read.csv(paste(PATH_SURVEYS,FILE_NAME,sep=""),stringsAsFactors = F)
  year <- substring(surveys[,1],1,4); month <- substring(surveys[,1],6,7); day <- substring(surveys[,1],9,10)
  hour <- substring(surveys[,1],12,13); min  <- substr(surveys[,1],15,16);
  date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", min, ":00", sep="")
  time_survey <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  zoo_survey=zoo(rep(0, times=length(time_survey)), order.by = time_survey)
  
  HS=DATA
  ptot=HS
  
  for(i in length(time_survey):1){
    delta=as.numeric(ptot[which(index(DATA)==time_survey[i])]-zoo_survey[i])
    p1=as.numeric(ptot[1:(which(index(DATA)==time_survey[i])-1)])
    p2=as.numeric(ptot[(which(index(DATA)==time_survey[i])):length(HS)])
    pdelta=p1-delta
    ptot=c(pdelta, p2)
  }
  delta=as.numeric(ptot[which(index(DATA)==time_survey[7])]-zoo_survey[7])
  p1=as.numeric(ptot[1:(which(index(DATA)==time_survey[7])-1)])
  p2=as.numeric(ptot[(which(index(DATA)==time_survey[7])):length(HS)])
  pdelta=p2-delta
  ptot=c(p1,pdelta)
  HS_calibrated=zoo(ptot, order.by = index(DATA))
  
  return(HS_calibrated)
}
