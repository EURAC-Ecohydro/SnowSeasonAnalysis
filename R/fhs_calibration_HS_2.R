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

fun_calibration_HS_2=function(DATA,FILE_NAME,PATH_SURVEYS){
  
  surveys=read.csv(paste(PATH_SURVEYS,FILE_NAME,sep=""),stringsAsFactors = F)
  year <- substring(surveys[,1],1,4); month <- substring(surveys[,1],6,7); day <- substring(surveys[,1],9,10)
  hour <- substring(surveys[,1],12,13); min  <- substr(surveys[,1],15,16);
  date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", "00:00", sep="")
  time_survey <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')
  
  # if (!all(min == "00")){
  #   stop(paste("Incorrect date format in: Snow_depth_calibration",FILE_NAME," Admitted YYYY-MM-DD HH:00! (hourly approssimation)",sep = ""))
  # }
  zoo_survey=zoo(surveys$snow_height, order.by = time_survey)
  
  HS=DATA
  ptot=HS
  
  zoo_survey_mod=c(ptot[1],zoo_survey)
  
  differ=zoo_survey_mod-ptot[which(index(ptot) %in% index(zoo_survey_mod))]
  
  ind=which(index(ptot) %in% index(zoo_survey_mod))
  d=diff(as.numeric(differ))
  m=d/diff(ind)
  q=as.numeric(differ)[-1]-m*ind[-1]
  
  cal=c()
  for(i in 1:(length(zoo_survey_mod)-1)){
    s=seq(ind[i]+1,ind[i+1],by=1)
    y=m[i]*s+q[i]
    cal=c(cal,y)
  }
  
  s_last=seq(ind[length(zoo_survey_mod)],length(ptot),by=1)
  y_last=rep(differ[length(zoo_survey_mod)],times = length(s_last))
  cal=c(cal,y_last)

  # q[length(zoo_survey_mod)-1] + m[length(zoo_survey_mod)-1]*s_last # to add at y_last if you want extend last linear calibration factor. (Not recommended)
    
    
  HS_calibrated=ptot+cal
  return(HS_calibrated)
  
}
