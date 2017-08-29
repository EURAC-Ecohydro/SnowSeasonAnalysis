#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Visualize_Winter_precipitation_estimation_from_SWE.R
# TITLE:        Visualize results of winter precipitation reconstruction using snow height increment
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         19/07/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Load .RData saved from Filtering_snow_height.R
#------------------------------------------------------------------------------------------------------------------------------------------------------
library(zoo)
library(dygraphs)
rm(list = ls())

# ==== INPUT ====
file = "B3_2000m_TOTAL"   # without .csv
#git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"
git_folder=getwd() 

# ===============
# ~~~~~~~~ Section 1 ~~~~~~~~ 

load(paste(git_folder,"/data/Output/SWE_from_snow_height_RData/SWE_analysis_",file,".RData",sep = ""))
list2env(new_list, .GlobalEnv)

zoo_SWE_snowfall=merge.zoo(SWE_filtered, snow, precipitation, derivate_snow)

# ~~~~~~~~ Section 2 ~~~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Plot Snow_height original and elaborated
#------------------------------------------------------------------------------------------------------------------------------------------------------

dygraph(zoo_SWE_snowfall, main=paste("SWE Analysis",file)) %>% dyRangeSelector()%>%    
  dySeries("snow",axis = "y", color = "blue")%>%
  dySeries("derivate_snow",axis = "y", color =  "green")%>%
  dySeries("SWE_filtered",axis = "y2",color = "red")%>%
  dySeries("precipitation",axis = "y2", color = "orange")%>%
  dyEvent(index(SWE_filtered)[which(!is.na(SWE_filtered))], color = "#ADE5EA",strokePattern = "solid") %>%
  dyLimit(increment_threshold) %>%
  dyAxis("y", label = "Snow_Height [m]",axisLineColor = "blue",axisLabelColor = "blue") %>%
  dyAxis("y2", label = "Precipitation/SWE [mm]", axisLineColor = "red",axisLabelColor = "red")
  


