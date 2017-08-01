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

git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"

# ~~~~~~ Section 1 ~~~~~~ 
#------------------------------------------------------------------------------------------------------------------------------------------------------
# Show data available
#------------------------------------------------------------------------------------------------------------------------------------------------------

files_available=dir(paste(git_folder,"data/Input_data",sep = ""))
print(paste("Example data:",files_available))

# Readme!
# You can process: B1_1000_TOTAL_2009_2016.csv, B3_2000m_TOTAL.csv, M3_total_2009_2016_15min.csv (no snow_height),M0004.csv (no snow_height)
# Elevation:              980,                         1950,                 2330,                                     1990 

# Input example:
# PATH <- "C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/Input_data/"
# FILE="B3_2000m_TOTAL.csv"
# ELEVATION=1950     

source(paste(git_folder,"R/esqc_ESOLIP_quality_check.R",sep = ""))


# ====== INPUT ====== 

path <- paste(git_folder,"data/Input_data/",sep = "")

file  <- "B3_2000m_TOTAL.csv" # <-- with .csv 

elevation <- 1950

climareport <- paste(git_folder,"data/Climareport/Climareport.csv",sep = "")

# ===================

# ~~~~~~ Section 2 ~~~~~~ 

# ====== RUN ESOLIP ALGORITHM ======
# Readme!
# Option 1: save a .Rdata --> activate only "save(esolip_output, ..."
# Option 2: save 2 .csv   --> * activate "esolip_data <- ..." and "esolip_events <- ..."
#                             * activate the two "write.csv"

t1=Sys.time()
esolip_output <- ESOLIP_QC(PATH <- path, FILE <- file, ELEVATION <- elevation, CLIMAREPORT <- climareport,git_folder)
esolip_data=esolip_output[[1]]
esolip_events=esolip_output[[2]]
t2=Sys.time()

# ===================

# ~~~~~~ Section 3 ~~~~~~ 

# ====== SAVE RESULTS IN A .RData OR IN TWO .csv ======
# Readme!
# Option 1: save a .Rdata --> activate only "save(esolip_output, ..."
# Option 2: save 2 .csv   --> * activate "esolip_data <- ..." and "esolip_events <- ..."
#                             * activate the two "write.csv"

save(esolip_output,file=paste(git_folder,"data/Output/Precipitation_metadata_RData/ESQC_",substring(file,1,nchar(file)-4), ".RData",sep=""))
write.csv(esolip_data,paste(git_folder,"data/Output/Precipitation_metadata/Precip_T_Int_15_Metadata/Prec_Metadata_",file,sep = ""),quote = F,row.names = F,na = "NaN")
write.csv(esolip_events,paste(git_folder,"data/Output/Precipitation_metadata/ESOLIP_QC_Steps/ESQC_Steps_",file,sep = ""),quote = F,row.names = F,na = "NaN")

# ================================== 

