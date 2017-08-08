#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Visualize_Snow_detection_TS_PAR.R
# TITLE:        Visualize results of detecting snow presence using Soil Temperature and PAR sensors
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         19/07/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Load .RData saved from Snow_detection_TS_PAR.R
#------------------------------------------------------------------------------------------------------------------------------------------------------

# ==== INPUT ====


#git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"
git_folder=getwd() 
file = "B3_2000m_TOTAL"   # without .csv
calib_snow = T    #<- T to calbrate snow heigh using snow surveys, F if use raw data
load(paste(git_folder,"/data/Output/Snow_Detection_RData/",file,".RData",sep = ""))

# ===============
# ~~~~~~~~ Section 1 ~~~~~~~~ 


snow_height = output_for_Visualize_Snow_detection_TS_PAR[[1]]
file = output_for_Visualize_Snow_detection_TS_PAR[[2]]
zoo_data  = output_for_Visualize_Snow_detection_TS_PAR[[3]]
snow_detect = output_for_Visualize_Snow_detection_TS_PAR[[4]]
snow_by_soil_temp = output_for_Visualize_Snow_detection_TS_PAR[[5]]
snow_by_phar = output_for_Visualize_Snow_detection_TS_PAR[[6]]

# ~~~~~~~~ Section 2 ~~~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# calibration with "virtual" snow surveys
#------------------------------------------------------------------------------------------------------------------------------------------------------

# We suggest to use this calibration after a filtering procedure
# Time series should be filled before, or "virtual" snow survey should be done in when there is a value!

# Import functions to calibrate HS
source(paste(git_folder,"/R/sndet_calibration_HS.R",sep = ""))
source(paste(git_folder,"/R/sndet_range.R",sep = ""))

folder_surveys=paste(git_folder,"/data/Snow_Depth_Calibration/Snow_Depth_Calibration_",sep = "")

# check if snow height data are available
if(any(colnames(zoo_data)==snow_height)){
  zoo_data[,which(colnames(zoo_data)==snow_height)]=fun_range(DATA = zoo_data,VARIABLE = snow_height)
  
  # Calibration of HS using end of snow season surveys "Virtual snow surveys" (Hypothesis, no snow --> HS=0)
  HS=zoo_data[,which(colnames(zoo_data)==snow_height)]
  
  HS_calibr=fun_calibration_HS(DATA = HS,FILE_NAME = file,PATH_SURVEYS = folder_surveys)
  HS_flag=1
} else{
  
  warning(paste(paste("Remember: snow_height data not available for station", substring(file,1,nchar(file)-4)),
                "If it is FALSE, assign the proper variable in section above", sep="\n"))
  
  HS_flag=0
}

# ~~~~~~~~ Section 3 ~~~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Plot Snow detection models (Phar + Soil Temperarature) using dygraphs
#------------------------------------------------------------------------------------------------------------------------------------------------------
source(paste(git_folder,"/R/sndet_dygraphs_snow_detection.R",sep = ""))
# source("H:/Projekte/Criomon/06_Workspace/BrC/Cryomon/03_R_Script/05_snow_filter/function/fun_dygraphs_snow_detection.R")
if(calib_snow == T){
  SNOW = HS_calibr
}else{
  SNOW = HS
}

if(HS_flag==1){
  models_graph=fun_plot_models_HS(FILE = file,SNOW_HEIGHT = SNOW,ST_MODEL = snow_by_soil_temp,PAR_MODEL = snow_by_phar,MODEL = snow_detect)
  models_graph
}else{
  models_graph=fun_plot_models(FILE = file,ST_MODEL = snow_by_soil_temp,PAR_MODEL = snow_by_phar,MODEL = snow_detect)
  models_graph
}
