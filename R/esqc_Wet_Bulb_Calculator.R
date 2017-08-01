#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Wet_Bulb_Calculator.R
# TITLE:        Create some functions to calculate Wet Bulb Temperature from T_Air and RH
# Autor:        Christian Brida
#               Institute for Alpine Environment
#               
#               Matlab functions developed by Elisabeth Mair
#               "H:\Projekte\Klimawandel\Modelling\GeoMatlab\GeoMatlab_MaE\Utilities\wet bulb temperature"
#
# Data:         11/01/2017
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

NULL
 
#' Saturation Vapor Pressure for ice from T_Air 
#' 
#' @param Ta air temperature C
#' 

SVPice=function(Ta){
  
  # Compute Saturation Vapor Pressure for ice (solid phase)
  
  # 6.10780*Exp(17.08085*TT/(234.175+TT)) Magnus formula
  # i = -9.09718 constant
  # j = -3.56654 constant
  # k = 0.876793 constante
  # e0 = 6.1071 Air pressure, Units hPa
  # T0 = 273.16 0 C-Temperatur, Units K
  # Ta = Air Temperature, Units C
  # e =???
  
  e0 = 6.1071
  T0 = 273.16
  
  i = -9.09718
  j = -3.56654
  k = 0.876793; 
  
  T0T = T0/(Ta+273.15)
  X = i*(T0T-1) + j*log10(T0T) + k*(1-1./T0T)
  SvPi = e0*10^X
  
  return(SvPi)
}

#' Calculates Saturation Vapor Pressure for water from T_Air
#' 
#' @param Ta air temperature C
#' 
SVPwater=function(Ta){
  
  # Compute Saturation Vapor Pressure for water (solid phase)
  # 6.10780*Exp(17.08085*TT/(234.175+TT)) Magnus formula
  # a = -7.90298 constant
  # b = 5.02808 constant
  # c = -1.381*10^-7 constant
  # d = 11.344 constant
  # f = 8.1328*10^-3 constnt
  # h = -3.49149 constante
  # est = 1013 Air pressure, Units: hPa
  # Ts = 373.16 Boiling Temperatur, Units: K
  # Ta = Air Temperatur in C
  # e =???
  
  est = 1013
  Ts = 373.16
  
  a = -7.90298
  b = 5.02808
  c = -1.3816e-07
  d = 11.344
  f = 8.1328e-03
  h = -3.49149
  
  TsT = Ts/(Ta + 273.15)
  Z = a*(TsT-1) + b*log10(TsT) + c*(10^(d*(1-TsT))-1) + f*(10^(h*(TsT-1))-1)
  SvPw = est*10.^Z 
  
  return(SvPw)
}

#' Calculates Delta of Vapor pressure from Ta, Tf, lambda
#' 
#' @param Ta air temperature C
#' @param Tf Possible range of wet bulb temperature
#' @param lambda  
#' 

Dampfdrucksprung=function(Ta,Tf,lambda){
  
  # berechnet den Dampfdruck nach der Sprung schen Formel
  # lambda betragt fur niedrige Hohen vereinfacht 0.67,

  
  if (Ta>0){
    Dampfdsprung=SVPwater(Tf)-lambda*(Ta-Tf)
  }
  else{
    Dampfdsprung=SVPice(Tf)-lambda*(Ta-Tf)
  }
  return(Dampfdsprung)
}

#' Calculates Vapor pressure from T_air and Relative Humidity
#' 
#' @param Ta air temperature C
#' @param RH relative humidity percentage  
#' 

dampfdruck2=function(Ta,RH){
  
  # berechnet den aktuellen Dampfdruck aus dem Sattigungsdampfdruck und der
  # Luftfeuchtigkeit
  # Sattigungsdampfdruck uber SvPi oder SvPw - je nach Temperatur!
  
  if (Ta > 0){
    Dampfd2=RH*SVPwater(Ta)
  }
  else{
    Dampfd2=RH*SVPice(Ta)
  }
  return(Dampfd2)
}


#' Calculates Wet Bulb Temperature from T_air and Relative Humidity and elevation
#' 
#' @param Ta air temperature C
#' @param RH relative humidity percentage  
#' @param elevation elevation of weather station
#' 

Tf_single=function(Ta,RH,elevation){

# calculates the wet bulb temperature (single value)
# from Ta (air temperature in C) RH (relative humidity) and lambda
# for every single station of the Matschertalproject
# for elevations below 500m, lambda is 0.67, 
# otherwise there is an Excelfile with corresponding values!
#   
# already calculated LAMBDA-values are here already integrated!
  
  
# calculation of lambda based on elevation 
  
# first calculation of air pressure

press = (1-((0.0065*elevation)/(273.15+15)))^5.255*1013;


# calculation of the lambda

T=seq(from=-30, to=30,by=1)   # range of temperature to calculate lambda

lambda_array = 0.0016286*(press/(2.501-0.002361*T))     # Option 1: mean of range of temperature
lambda = mean(lambda_array) # Why?

# lambda_array = 0.0016286*(press/(2.501-0.002361*Ta))    # Option 2: Air temperature
# lambda = lambda_array


# calculation of the wet bulb tempearture

Tf=seq(from=-20, to=30, by=0.01)        # Possible range of wet bulb temperature, resolution 0.01

VP1=dampfdruck2(Ta,(RH/100))             # calculates the vapor pressure from Ta and RH
VP2=Dampfdrucksprung(Ta,Tf,lambda)       # calculates the vapor pressure of the range of Tf for the given Ta

# plot(abs(VP2-VP1))
index=which(abs(VP2-VP1)==min(abs(VP2-VP1)))
Tfsingle=Tf[index]

return(Tfsingle)

}




