#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_snow_detection.R
# TITLE:        Snow detection using soil temperature and phar
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         18/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Function that merge snow presence from Soil Temp and snow presence from PAR to improve results
#'
#' @param DATA zoo data 
#' @param FILE variable to clean excluding outliers 
#' 


fun_snow_detection=function(SOIL_TEMP_SNOW, PHAR_SNOW){
  
  # daily resampling --> daily time
  d_year <- substring(index(PHAR_SNOW),1,4); d_month <- substring(index(PHAR_SNOW),6,7); d_day <- substring(index(PHAR_SNOW),9,10)
  d_hour <- substring(index(PHAR_SNOW),12,13); d_min  <- substring(index(PHAR_SNOW),15,16);
  d_date_chr <- paste(d_year, "-", d_month, "-", d_day, " ",  "00:00:00", sep="")
  d_time <- as.POSIXct( strptime(x = d_date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  prob=merge(PHAR_SNOW,SOIL_TEMP_SNOW)
  prob=cbind(prob,apply(prob,1,mean, na.rm=T))
  
  snow_cover=zoo(prob[,3],order.by = index(PHAR_SNOW))
  
  par_limits_day=aggregate(PHAR_SNOW,d_time,mean,na.rm=F)
  tsoil_limits_day=aggregate(SOIL_TEMP_SNOW,d_time,mean,na.rm=F)
  snow_cover_day=aggregate(snow_cover,d_time,mean,na.rm=F)
  SNOW=zoo(rep(0,times=length(snow_cover_day)),order.by = index(snow_cover_day))
  
  # This loop check if the previous value is a PAR event or PAR + T_Soil event. (Starting snow events)
  # If positive the snow presence could be considered true. 
  # The end of snow seasons is detected when there isn't PAR events and T_Soil is above a threshold (TS and dTS)
  
  for(i in 2:(length(snow_cover_day))){
    if(SNOW[i-1]==0){
      if(is.na(par_limits_day[i]) | is.na(tsoil_limits_day[i]) ){
        SNOW[i]=0
      }else{
        if(par_limits_day[i]==1){
          SNOW[i]=1
        } 
        if(par_limits_day[i]==1 & tsoil_limits_day[i]==1 ){
          SNOW[i]=1
        } 
      }
    }else{
      if(is.na(par_limits_day[i]) | is.na(tsoil_limits_day[i]) ){
        SNOW[i]=0
      }else{
        if(SNOW[i-1]==1){
          if(tsoil_limits_day[i]==1){
            SNOW[i]=1
          } 
          if(par_limits_day[i]==1 & tsoil_limits_day[i]==1 ){
            SNOW[i]=1
          } 
        }
      }
    }
  }
  
  # i=2
  # In this loop we fix the problem that Tsoil could detect snow 2 day after PAR.
  # Furthermore snow events in early fall  or in late spring don't affect T_soil, and usually survive 2 days
  
  for(i in 2:(length(snow_cover_day)-1)){
    if(as.numeric(SNOW[i-1,])==1 & as.numeric(SNOW[i,])==0 & as.numeric(SNOW[i+1,])==1){
      SNOW[i]=1
    } 
  }
  
  SNOW_NA=zoo(rep(NA,times=length(PHAR_SNOW)),order.by = index(PHAR_SNOW))
  SNOW_h=na.locf(merge(SNOW_NA,SNOW))[-1,-1]
  if(substring(index(SNOW),12,13)[1]=="00"){
    SNOW_h=SNOW_h[-1,]
  }
  
  return(SNOW_h)
}

