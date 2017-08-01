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
# Load .RData saved from Filtering_snow_height.R
#------------------------------------------------------------------------------------------------------------------------------------------------------
library(zoo)
library(dygraphs)

# ==== INPUT ====

file = "B3_2000m_TOTAL"   # without .csv
git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"

# ===============
# ~~~~~~~~ Section 1 ~~~~~~~~ 

load(paste(git_folder,"data/Output/Snow_Filtering_RData/Snow_",file,".RData",sep = ""))

HS_original = rdata_output[[1]]
HS_range_QC = rdata_output[[2]]
HS_rate_QC = rdata_output[[3]]
HS_calibrated = rdata_output[[4]]
HS_calibr_smoothed = rdata_output[[5]]
HS_calibr_smooothed_rate_QC =  rdata_output[[6]]

zoo_HS=merge.zoo(HS_original,
                 HS_range_QC,
                 HS_rate_QC ,
                 HS_calibrated ,
                 HS_calibr_smoothed,
                 HS_calibr_smooothed_rate_QC)

# ~~~~~~~~ Section 2 ~~~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Plot Snow_height original and elaborated
#------------------------------------------------------------------------------------------------------------------------------------------------------

dygraph(zoo_HS, main=paste("HS elaboration on",file))%>%dyRangeSelector() %>%
  dyAxis("y", label = "Snow_Height [m]") %>%
  dyOptions(colors = RColorBrewer::brewer.pal(6, "Dark2"))

