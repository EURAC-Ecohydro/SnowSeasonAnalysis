#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Filtering_precipitation_readings.R
# Description:  Apply some threshold to determine if precipitation is possible or not
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         20/12/2016
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------
require(zoo)
require(chron)
require(dygraphs)

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Define your Git folder:   
#------------------------------------------------------------------------------------------------------------------------------------------------------

# ====== INPUT 1 ====== 

setwd("~/Git/EURAC-Ecohydro/SnowSeasonAnalysis")
git_folder=getwd() 
#git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"

# ===================

# ~~~~~~ Section 1 ~~~~~~ 
#------------------------------------------------------------------------------------------------------------------------------------------------------
# Show data available
#------------------------------------------------------------------------------------------------------------------------------------------------------

files_available=dir(paste(git_folder,"/data/Input_data",sep = ""))
print(paste("Avaliable input data:",files_available))

metadata_available=dir(paste(git_folder,"/data/Climareport",sep = ""))
print(paste("Avaliable meta data:",metadata_available))

# Readme!
# You can process: B1_1000_TOTAL_2009_2016.csv, B3_2000m_TOTAL.csv, M3_total_2009_2016_15min.csv (no snow_height),M0004.csv (no snow_height)
# Elevation:              980,                         1950,                 2330,                                     1990 

# Input example:
# PATH <- "C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/Input_data/"
# FILE="B3_2000m_TOTAL.csv"
# ELEVATION=1950     

source(paste(git_folder,"/R/esqc_ESOLIP_quality_check.R",sep = ""))


# ====== INPUTS 2-9 ====== 

# you type here the file you want to process among the avaliable ones
# and corresponding elevation and metadata

path <- paste(git_folder,"/data/Input_data/",sep = "")

file  <- "B3_2000m_TOTAL.csv" # <-- with .csv 

elevation <- 1950

climareport <- paste(git_folder,"/data/Climareport/Climareport.csv",sep = "")

precipitation <- "Precip_T_Int15"   # <-- assign here the column name corresponding with precipitation parameter. Default (LTER stations) is "Precip_T_Int15" 

air_temperature <- "T_Air"          # <-- assign here the column name corresponding with air_temperature parameter. Default (LTER stations) is "T_Air" 

relative_humidity <- "RH"           # <-- assign here the column name corresponding with relative_humidity parameter. Default (LTER stations) is "RH" 

radiation <- "SR_Sw"                # <-- assign here the column name corresponding with radiation parameter. Default (LTER stations) is "SR_Sw" 

# ===================

# ~~~~~~ Section 2 ~~~~~~ 

# ====== RUN ESOLIP ALGORITHM ======

t1=Sys.time()
esolip_output <- ESOLIP_QC(PATH = path, FILE = file, ELEVATION = elevation, CLIMAREPORT = climareport,git_folder,
                           PRECIPITATION = precipitation, AIR_TEMPERATURE = air_temperature,
                           RELATIVE_HUMIDITY = relative_humidity, RADIATION = radiation)
esolip_data=esolip_output[[1]]
esolip_events=esolip_output[[2]]
t2=Sys.time()

# ===================

# ~~~~~~ Section 3 ~~~~~~ 

# ====== SAVE RESULTS IN A .RData OR IN TWO .csv ======
# Readme!
# save a .Rdata --> activate only "save(esolip_output, ..."
# save 2 .csv   --> * activate "esolip_data <- ..." and "esolip_events <- ..."
#                             * activate the two "write.csv"

save(esolip_output,file=paste(git_folder,"/data/Output/Precipitation_metadata_RData/ESQC_",substring(file,1,nchar(file)-4), ".RData",sep=""))
write.csv(esolip_data,paste(git_folder,"/data/Output/Precipitation_metadata/Prec_Metadata/Prec_Metadata_",file,sep = ""),quote = F,row.names = F,na = "NaN")
write.csv(esolip_events,paste(git_folder,"/data/Output/Precipitation_metadata/ESOLIP_QC_Steps/ESQC_Steps_",file,sep = ""),quote = F,row.names = F,na = "NaN")

# ================================== 

