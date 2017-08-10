#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Snow_detection_TS_PAR.R
# TITLE:        Detect snow presence combining Soil Temperature and PAR sensors
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         12/04/2017
# Version:      1.0
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
Sys.setenv(TZ='Etc/GMT-1')
require(zoo)
require(chron)
require(dygraphs)

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Define your Git folder:
#------------------------------------------------------------------------------------------------------------------------------------------------------

# ==== INPUT 1 ====

#git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"
git_folder=getwd() 

# =================

# ~~~~~~ Section 1 ~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Import data (zoo object)
#------------------------------------------------------------------------------------------------------------------------------------------------------

# Import functions to read data
source(paste(git_folder,"/R/sndet_read_data_metadata.R",sep = ""))

# Define path and file to import
path=paste(git_folder,"/data/Input_data/",sep="")
print(paste("File available:",dir(path,pattern = ".csv")))  # Show file available in folder 

# ==== INPUT 2 ====

file = "B3_2000m_TOTAL.csv"

# =================

zoo_data=fun_read_data(PATH = path,FILE = file)

# ~~~~~~ Section 2 ~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Check colnames(zoo_data) and assign the properly variable
#------------------------------------------------------------------------------------------------------------------------------------------------------

print(paste("Variable available:",colnames(zoo_data)))

# check in colnames(zoo_data) if there are:
# 1. Soil temperature (obligatory)
# 2. phar_up (obligatory) 
# 3. phar_down (obligatory)
# 4. snow_height (optional)

# ==== INPUT 3-11 ====

soil_temperature="ST_CS_00"                          # <- obligatory
plot(zoo_data[,which(colnames(zoo_data)==soil_temperature)])

phar_up="PAR_Up"                                     # <- obligatory
plot(zoo_data[,which(colnames(zoo_data)==phar_up)])

phar_down="PAR_Soil_LS"                              # <- obligatory
plot(zoo_data[,which(colnames(zoo_data)==phar_down)])

snow_height="Snow_Height"                            # <- optional
plot(zoo_data[,which(colnames(zoo_data)==snow_height)])

daily_mean_soil_tempeature_threshold = 3.5         # <- Default 3.5 deg C. Threshold of daily mean of soil temperature that suggest snow presence. 
daily_amplitude_soil_tempeature_threshold = 3      # <- Default 3 deg C. Threshold of daily amplitude of soil temperature that suggest snow presence  

daily_max_ratio_parup_pardown = 0.1                # <-  Default 0.1 (10%). Threshold of ratio between daily maximum of PAR at soil level and at 2 meters that suggest snow presence. 
daily_max_pardown = 75                             # <-  Default 75 W/m2). Threshold of daily maximum PAR at soil level that suggest snow presence. 

SUMMER_MONTHS=c("05","06","07","08","09")          # <- select summer months based on position of station (elevation) ["01"-> Jan, ... , "12"-> Dec]

# ====================


# ~~~~~~ Section 3 ~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Exctract soil temperature, par up and par down from zoo_data
#------------------------------------------------------------------------------------------------------------------------------------------------------

ST=zoo_data[,which(colnames(zoo_data)==soil_temperature)]            # Soil temperature @ 0 cm (superficial)
PAR_DOWN=zoo_data[,which(colnames(zoo_data)==phar_down)]             # Par_soil
PAR_UP=zoo_data[,which(colnames(zoo_data)==phar_up)]                 # Par_up

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Snow detection using Soil temperature
#------------------------------------------------------------------------------------------------------------------------------------------------------
source(paste(git_folder,"/R/sndet_soil_temp_snow_detection.R",sep = ""))

# SOIL_TEMPERATURE = ST
# MEAN_ST_THRESHOLD = 3.5               # Suggested value: 3.5 . Units: deg C (daily mean)
# AMPLITUDE_ST_THRESHOLD = 3            # Suggested value. 3.0 . Units: deg C (daily amplitude)

snow_by_soil_temp=fun_soil_temp_snow_detection(SOIL_TEMPERATURE = ST,
                                               MEAN_ST_THRESHOLD = daily_mean_soil_tempeature_threshold,
                                               AMPLITUDE_ST_THRESHOLD = daily_amplitude_soil_tempeature_threshold)

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Snow detection using Phar sensors (Up an soil)
#------------------------------------------------------------------------------------------------------------------------------------------------------
source(paste(git_folder,"/R/sndet_phar_snow_detection.R",sep = ""))

# PAR_UP = PAR_UP
# PAR_DOWN = PAR_DOWN
# RATIO_THRESHOLD = 0.1                   #  Suggested value: 0.1 . Units: abs
# PAR_SOIL_THRESHOLD = 75                 #  Suggested value:  75 . Units: umol/(m²s)

snow_by_phar=fun_phar_snow_detection(PAR_UP = PAR_UP,PAR_DOWN = PAR_DOWN,RATIO_THRESHOLD = daily_max_ratio_parup_pardown ,PAR_SOIL_THRESHOLD = daily_max_pardown)

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Snow detection (Phar + Soil Temperarature)
#------------------------------------------------------------------------------------------------------------------------------------------------------
source(paste(git_folder,"/R/sndet_snow_detection.R",sep = ""))

snow_detect=fun_snow_detection(SOIL_TEMP_SNOW = snow_by_soil_temp, PHAR_SNOW = snow_by_phar)

# Exclude snow cover during summer 
# SUMMER_MONTHS=c("05","06","07","08","09")               # <- select summer length based on position of station (elevation) 

snow_detect[substring(index(snow_detect),6,7) %in% SUMMER_MONTHS]=0

# ~~~~~~ Section 4 ~~~~~~ 

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Save output
#------------------------------------------------------------------------------------------------------------------------------------------------------

output_for_Visualize_Snow_detection_TS_PAR=list(snow_height,file,zoo_data,
                                                snow_detect,snow_by_soil_temp,snow_by_phar )
names(output_for_Visualize_Snow_detection_TS_PAR)=c("Snow presence PAR + Soil Temp", "Snow presence PAR","Snow presence Soil Temp")

save(output_for_Visualize_Snow_detection_TS_PAR,file = paste(git_folder,"/data/Output/Snow_Detection_RData/",substring(file,1,nchar(file)-4),".RData",sep = ""))

detection=merge(snow_detect, snow_by_phar,snow_by_soil_temp)
detection=as.data.frame(detection)
export=cbind(index(snow_detect),detection)
colnames(export)=c("TIMESTAMP","Snow presence PAR + Soil Temp", "Snow presence PAR","Snow presence Soil Temp")

write.csv(export, paste(git_folder,"/data/Output/Snow_Detection/Snow_presence_",file,sep=""),quote = F,row.names = F)
