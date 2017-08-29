#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Winter_precipitation_estimation_from_SWE.R
# Description:  Winter precipitation reconstruction using snow height increment
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

source(paste(git_folder,"/R/SWE_estimation.R",sep = ""))


# ====== INPUTS 2-9 ====== 

# you type here the file you want to process among the avaliable ones
# and corresponding elevation and metadata

path <- paste(git_folder,"/data/Input_data/",sep = "")      # <-- path of original dataset 

path_filtered_snow <- paste(git_folder,"/data/Output/Snow_Filtering/",sep = "")      # <-- path of snow dataset elaborated from "Filtering_snow_height.R" algorithms

path_esolip_qc <- paste(git_folder,"/data/Output/Precipitation_metadata/ESOLIP_QC_Steps/",sep = "")      # <-- path of snow dataset elaborated from "Filtering_snow_height.R" algorithms

file  <- "B3_2000m_TOTAL.csv" # <-- with .csv    # <--  name of file of original dataset 

file_snow <- paste("Snow_",file,sep = "")        # <--  name of file of snow dataset 

file_esolip_qc <- paste("ESQC_Steps_",file,sep = "")        # <--  name of file of snow dataset 

precipitation = "Precip_T_Int15"    # <-- assign here the column name corresponding with precipitation parameter. Default (LTER stations) is "Precip_T_Int15" 

air_temperature <- "T_Air"          # <-- assign here the column name corresponding with air temperature parameter. Default (LTER stations) is "T_Air" 

wind_speed <- "Wind_Speed"          # <-- assign here the column name corresponding with wind speed parameter. Default (LTER stations) is "Wind_Speed" 

increment_threshold <- 0.002        # <-- assign here the threshold on derivative  . Default is 0.001 m (1 mm/h of snow correspond to 0.1 mm/h of water whith rho = 100 kg/m³)
# ===================

# ~~~~~~ Section 2 ~~~~~~ 

# ====== RUN ESOLIP ALGORITHM ======

t1=Sys.time()
SWE_snowfall = SWE_estimation(git_folder = git_folder,PATH = path,FILE = file,
                              PATH_SNOW = path_filtered_snow, FILE_SNOW = file_snow,
                              PATH_ESOLIP_QC = path_esolip_qc,FILE_ESOLIP_QC = file_esolip_qc,
                              PRECIPITATION = precipitation, AIR_TEMPERATURE = air_temperature,WIND_SPPED = wind_speed,
                              INCREMENT_THRESHOLD = increment_threshold) 

t2=Sys.time()

# ===================

# ~~~~~~ Section 3 ~~~~~~ 

# ====== SAVE RESULTS IN A .RData OR IN TWO .csv ======

list2env(SWE_snowfall, .GlobalEnv)
SWE_dataframe=data.frame(index(SWE), as.numeric(SWE_filtered))
colnames(SWE_dataframe)=c("TIMESTAMP","SWE")
rho_dataframe=data.frame(index(rho), as.numeric(rho))
colnames(rho_dataframe)=c("TIMESTAMP","rho")

new_list=c(SWE_snowfall,increment_threshold)
names(new_list)[length(new_list)]="increment_threshold"

save(new_list,file=paste(git_folder,"/data/Output/SWE_from_snow_height_RData/SWE_analysis_",substring(file,1,nchar(file)-4), ".RData",sep=""))
write.csv(SWE_dataframe,paste(git_folder,"/data/Output/SWE_from_snow_height/SWE_",file,sep = ""),quote = F,row.names = F,na = "NaN")
write.csv(rho_dataframe,paste(git_folder,"/data/Output/SWE_from_snow_height/rho_",file,sep = ""),quote = F,row.names = F,na = "NaN")

# ================================== 

