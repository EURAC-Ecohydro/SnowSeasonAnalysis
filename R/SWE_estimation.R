
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


SWE_estimation=function(PATH, FILE, PATH_SNOW, FILE_SNOW,  git_folder, 
                        PRECIPITATION = "Precip_T_Int15", AIR_TEMPERATURE = "T_Air", WIND_SPPED = "Wind_Speed"){
  
  PATH = path
  FILE = file
  
  PATH_SNOW = path_filtered_snow
  FILE_SNOW = file_snow
  
  # PATH_PHASE = path_phase
  # FILE_PHASE = file_phase
  
  source(paste(git_folder,"/R/esqc_Read_data_metadata.R",sep=""))
  
  zoo_data=fun_read_data(PATH,FILE)
  precip_original=zoo_data[,which(colnames(zoo_data)==PRECIPITATION)]
  air_temperature_original=zoo_data[,which(colnames(zoo_data)==AIR_TEMPERATURE)]
  wind_original=zoo_data[,which(colnames(zoo_data)==WIND_SPPED)]
  
  T_Kelvin=air_temperature_original+273.15
  
  rho = rep(NA, times=length(air_temperature_original))
  rho = zoo(rho,order.by = index(air_temperature_original))
  
  g1= which(T_Kelvin>275.65)
  rho[g1]=NA
  
  g2 = which(T_Kelvin>260.15 & T_Kelvin <=275.65)
  rho[g2]=500*(1-0.951*exp(-1.4*(278.15-T_Kelvin[g2])^(-1.15))-0.008*wind_original[g2]^1.7)
  
  g3 = which(T_Kelvin <= 260.15)
  rho[g3] = 500*(1-0904*exp(-0.008*wind_original[g3]^1.7))
  
  rho2=rho
  rho2[which(rho<(-100))]=NA
  
  zoo_snow=fun_read_output_data(PATH_SNOW,FILE_SNOW)
  snow=zoo_snow[,which(colnames(zoo_snow)=="HS_calibr_smooothed_rate_QC")]  
  

  
  num_snow = as.numeric(snow)
  deriv=diff(num_snow)
  accum=deriv
  w=which(deriv<0.0025)
  accum[w] = NA
  accum=c(NA,accum)
  
  num_rho=as.numeric(rho2)
  rho_accum=rho2
  rho_accum[w]=NA
  
  SWE=accum*rho_accum
  
  derivat_snow=zoo(c(NA,deriv),order.by = index(precip_original))
  output=list(SWE,snow,derivat_snow,precip_original)
  names(output)=c("SWE","snow","derivate_snow","precipitation")
  
  return(output)

}

