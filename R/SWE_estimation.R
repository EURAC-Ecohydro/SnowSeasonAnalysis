
NULL

#' Snow presence derived from Phar sensor. Little radiation that hit soil and little fraction from incoming radiation suggest the presence of snow near the station
#' 
#' @param PATH path of input data 
#' @param FILE name of file of input data (write under " " and ending with .csv)
#' @param PATH_SNOW path of snow dataset created usign snow filtering algorithm 
#' @param FILE_SNOW name of snow file created usign snow filtering algorithm  (write under " " and ending with .csv)
#' @param git_folder local folder where "package" is cloned
#' @param PRECIPITATION names of column in input data corresponding with precipitation parameter
#' @param AIR_TEMPERATURE names of column in input data corresponding with air temperature parameter
#' @param WIND_SPPED names of column in input data corresponding with wind speed parameter

# # Input
# git_folder="C:/Users/CBrida/Desktop/Git/EURAC-Ecohydro/SnowSeasonAnalysis/"
# 
# PATH <- paste(git_folder,"/data/Input_data/",sep = "")      # <-- path of original dataset 
# FILE  <- "B3_2000m_TOTAL.csv" # <-- with .csv    # <--  name of file of original dataset 
# 
# PATH_SNOW <- paste(git_folder,"/data/Output/Snow_Filtering/",sep = "")      # <-- path of snow dataset elaborated from "Filtering_snow_height.R" algorithms
# FILE_SNOW <- paste("Snow_",FILE,sep = "")        # <--  name of file of snow dataset 
# 
# PATH_ESOLIP_QC <- paste(git_folder,"/data/Output/Precipitation_metadata/ESOLIP_QC_Steps/",sep = "")      # <-- path of snow dataset elaborated from "Filtering_snow_height.R" algorithms
# FILE_ESOLIP_QC <- paste("ESQC_Steps_",FILE,sep = "")        # <--  name of file of snow dataset 
# 
# PRECIPITATION <- "Precip_T_Int15"    # <-- assign here the column name corresponding with precipitation parameter. Default (LTER stations) is "Precip_T_Int15" 
# AIR_TEMPERATURE <- "T_Air"          # <-- assign here the column name corresponding with air temperature parameter. Default (LTER stations) is "T_Air" 
# WIND_SPPED <- "Wind_Speed"          # <-- assign here the column name corresponding with wind speed parameter. Default (LTER stations) is "Wind_Speed" 
# 


SWE_estimation=function(git_folder,PATH, FILE,
                        PATH_SNOW, FILE_SNOW,
                        PATH_ESOLIP_QC, FILE_ESOLIP_QC,   
                        PRECIPITATION = "Precip_T_Int15", AIR_TEMPERATURE = "T_Air", WIND_SPPED = "Wind_Speed",
                        INCREMENT_THRESHOLD = 0.001 ){
  
  # INCREMENT_THRESHOLD = 0.001  # <-- threshold on snow height increment (increment less then 0.002 mm/h of snow) 
  
  source(paste(git_folder,"/R/esqc_Read_data_metadata.R",sep=""))
  
  zoo_data=fun_read_data(PATH,FILE)
  precip_original=zoo_data[,which(colnames(zoo_data)==PRECIPITATION)]
  air_temperature_original=zoo_data[,which(colnames(zoo_data)==AIR_TEMPERATURE)]
  wind_original=zoo_data[,which(colnames(zoo_data)==WIND_SPPED)]
  
  T_Kelvin=air_temperature_original+273.15
  
  T_Kelvin2=T_Kelvin
  T_Kelvin2[which(is.na(T_Kelvin))] = 273.15

  wind=wind_original
  wind[is.na(wind_original)] = 1
  
  rho = rep(NA, times=length(air_temperature_original))
  rho = zoo(rho,order.by = index(air_temperature_original))
  
  g0 = which(T_Kelvin2 > 283.15)
  rho[g0]=NA 
  
  g1= which(T_Kelvin2>275.65 & T_Kelvin2 <=283.15)
  rho[g1]=200
  
  g2 = which(T_Kelvin2>260.15 & T_Kelvin2 <=275.65)
  rho[g2]=500*(1-0.951*exp(-1.4*(278.15-T_Kelvin2[g2])^(-1.15))-0.008*wind[g2]^1.7)
  
  g3 = which(T_Kelvin2 <= 260.15)
  rho[g3] = 500*(1-0904*exp(-0.008*wind[g3]^1.7))
  
  rho2=rho
  rho2[which(rho<(0))]=NA
  
  zoo_snow=fun_read_output_data(PATH_SNOW,FILE_SNOW)
  snow=zoo_snow[,which(colnames(zoo_snow)=="HS_calibr_smooothed_rate_QC")]  
  
  
  num_snow = as.numeric(snow)
  deriv=diff(num_snow)
  accum=deriv
  w=which(deriv<INCREMENT_THRESHOLD)
  accum[w] = NA
  accum=c(NA,accum)
  
  num_rho=as.numeric(rho2)
  rho_accum=rho2
  rho_accum[w]=NA
  
  SWE=accum*rho_accum
  

  esolip_metadata=fun_read_output_metadata(PATH_ESOLIP_QC,FILE_ESOLIP_QC)
  phase=esolip_metadata[,which(colnames(esolip_metadata)=="STEP2")]
  classification=esolip_metadata[,which(colnames(esolip_metadata)=="STEP6")]
  
  SWE_out=SWE
  SWE_out[which(phase=="Rain")]=NA

  derivat_snow=zoo(c(NA,deriv),order.by = index(precip_original))
  output=list(SWE, SWE_out,snow,derivat_snow,precip_original,rho2)
  names(output)=c("SWE","SWE_filtered","snow","derivate_snow","precipitation", "rho")
  
  return(output)
  
}









