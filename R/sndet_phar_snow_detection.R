#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   fun_phar_snow_detection.R
# TITLE:        Snow detection using soil temperature
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         18/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL

#' Snow presence derived from Phar sensor. Little radiation that hit soil and little fraction from incoming radiation suggest the presence of snow near the station
#' 
#' @param PAR_UP column of zoo data correspondig to PAR_Up (Photosintetically Active Radiation, at 2 meters) 
#' @param PAR_DOWN column of zoo data correspondig to PAR_Down (Photosintetically Active Radiation, at soil level ) 
#' @param RATIO_THRESHOLD Threshold of fraction of incoming PAR. Suggested value 0.1
#' @param PAR_SOIL_THRESHOLD Threshold of PAR at soil level 

fun_phar_snow_detection=function(PAR_UP,PAR_DOWN,RATIO_THRESHOLD = 0.1, PAR_SOIL_THRESHOLD = 75){
  
  # daily resampling --> daily time
  d_year <- substring(index(PAR_UP),1,4); d_month <- substring(index(PAR_UP),6,7); d_day <- substring(index(PAR_UP),9,10)
  d_hour <- substring(index(PAR_UP),12,13); d_min  <- substring(index(PAR_UP),15,16);
  d_date_chr <- paste(d_year, "-", d_month, "-", d_day, " ",  "00:00:00", sep="")
  d_time <- as.POSIXct( strptime(x = d_date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  par_NA=zoo(rep(NA,times=length(PAR_UP)),order.by = index(PAR_UP))
  
  
  # par up 
  parup_day_max=aggregate(PAR_UP,d_time,max,na.rm=F)
  parup_max=na.locf(merge(par_NA,parup_day_max))[,-1]
  if(substring(index(parup_max)[1],11,12)=="00"){
    parup_max=parup_max[-1,]
  }
  
  # par up 
  pardn_day_max=aggregate(PAR_DOWN,d_time,max,na.rm=F)
  pardn_max=na.locf(merge(par_NA,pardn_day_max))[,-1]
  if(substring(index(pardn_max)[1],11,12)=="00"){
    pardn_max=pardn_max[-1,]
  }
  
  
  # Snow detection using phar sensors: 0-> no snow, 1-> snow
  
  ratio=pardn_max/parup_max
  
  par_limits=rep(0,times=length(PAR_UP))
  par_limits[ratio<RATIO_THRESHOLD & pardn_max<PAR_SOIL_THRESHOLD]=1
  
  par_limits[is.na(pardn_max)| is.na(ratio)]=NA
  par_limits=zoo(par_limits,order.by = index(PAR_UP))
  
  return(par_limits)
}

