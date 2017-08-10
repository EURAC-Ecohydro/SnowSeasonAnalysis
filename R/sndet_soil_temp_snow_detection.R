#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_soil_temp_snow_detection.R
# TITLE:        Snow detection using soil temperature
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         18/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

NULL

#' Snow presence derived from Soil Temperature sensor. Soil Temperature during snow presence has generally a little daily mean and small daily amplitude.
#' # MEAN_ST_THRESHOLD = 3.5               # Suggested value: 3.5 . Units: deg C (daily mean)
# AMPLITUDE_ST_THRESHOLD = 3            # Suggested value. 3.0 . Units: deg C (daily amplitude) 
#' 
#' @param SOIL_TEMPERATURE column of zoo data correspondig to PAR_Up (Photosintetically Active Radiation, at 2 meters) 
#' @param MEAN_ST_THRESHOLD Threshold of daily mean of soil temperature. Suggested value 3.5
#' @param MEAN_ST_THRESHOLD Threshold of daily amplitude of soil temperature. Suggested value 3

fun_soil_temp_snow_detection=function(SOIL_TEMPERATURE,MEAN_ST_THRESHOLD = 3.5,AMPLITUDE_ST_THRESHOLD = 3){
  
  # daily resampling --> daily time
  d_year <- substring(index(SOIL_TEMPERATURE),1,4); d_month <- substring(index(SOIL_TEMPERATURE),6,7); d_day <- substring(index(SOIL_TEMPERATURE),9,10)
  d_hour <- substring(index(SOIL_TEMPERATURE),12,13); d_min  <- substring(index(SOIL_TEMPERATURE),15,16);
  d_date_chr <- paste(d_year, "-", d_month, "-", d_day, " ",  "00:00:00", sep="")
  d_time <- as.POSIXct( strptime(x = d_date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  ST_NA=zoo(rep(NA,times=length(SOIL_TEMPERATURE)),order.by = index(SOIL_TEMPERATURE))

  # daily average
  ST_day_mean=aggregate(SOIL_TEMPERATURE,d_time,mean,na.rm=F)
  ST_mean=na.locf(merge(ST_NA,ST_day_mean))[,-1]
  if(substring(index(ST_mean)[1],11,12)=="00"){
    ST_mean=ST_mean[-1,]
  }
  
  # daily maximum 
  ST_day_max=aggregate(SOIL_TEMPERATURE,d_time,max,na.rm=F)
  ST_max=na.locf(merge(ST_NA,ST_day_max))[,-1]
  if(substring(index(ST_max)[1],11,12)=="00"){
    ST_max=ST_max[-1,]
  }
  
  # daily minimum
  ST_day_min=aggregate(SOIL_TEMPERATURE,d_time,min,na.rm=F)
  ST_min=na.locf(merge(ST_NA,ST_day_min))[,-1]
  if(substring(index(ST_min)[1],11,12)=="00"){
    ST_min=ST_min[-1,]
  }
  
  # daily amplitude (max-min)
  dST=ST_max-ST_min
  
  # Snow detection using soil temperature: 0-> no snow, 1-> snow
  tsoil_limits=rep(0,times=length(SOIL_TEMPERATURE))
  tsoil_limits[ST_mean<MEAN_ST_THRESHOLD & dST<AMPLITUDE_ST_THRESHOLD]=1
  tsoil_limits[is.na(ST_max)]=NA
  tsoil_limits=zoo(tsoil_limits,order.by = index(SOIL_TEMPERATURE))

  return(tsoil_limits)
}

