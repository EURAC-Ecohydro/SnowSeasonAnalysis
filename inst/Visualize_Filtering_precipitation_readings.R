#-------------------------------------------------------------------------------------------------------------------------------------------------------
# File Title:   Visualize_ESOLIP.R
# Description:  IMPORT RData AND VISUALIZE MODEL OUTPUT USING SHINY
# Autor:        Christian Brida
#               Institute for Alpine Environment
# Data:         20/12/2016
# Version:      1.0
#------------------------------------------------------------------------------------------------------------------------------------------------------

# ~~~~~~ Section 1 ~~~~~~ 

# ====== Input ======

# Select which .RData you want to explore

FILE_NAME="B3_2000m_TOTAL"    # <-- without .csv

# You can process: B1_1000_TOTAL_2009_2016, B3_2000m_TOTAL, M3_total_2009_2016_15min (no snow_height),M0004 (no snow_height)

git_folder="C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/"

# ====================

# ====== Load .RData ======

load(paste(git_folder,"data/Output/Precipitation_metadata_RData/ESQC_",FILE_NAME,".RData",sep = ""))
esolip_data=esolip_output[[1]]
esolip_events=esolip_output[[2]]

# =========================

# ~~~~~~ Section 2 ~~~~~~ 

# ====== Run this SHINY APP ======

# Run this SHINY APP to plot 2 time series together: precipitation (with QC) and Snow_Height 
require(shiny)
require(datasets)
require(zoo)
require(chron)
require(dygraphs)

ui=shinyUI(fluidPage(
  titlePanel(""),
  # titlePanel("Comparison of Precipitation Quality Index with Snow Height"),
  
  fluidRow(
    dygraphOutput("dygraph1")
  ),
  fluidRow(
    dygraphOutput("dygraph2")
  ),
  fluidRow(
    h3(strong(" Legend:"))
  ),
  fluidRow(
    h5(strong(" Plot 1:")," the red line is the time series of hourly cumulated precipitation of a tipping bucket installed on the LTER station (Precip_T_Int15).")
  ),
  fluidRow(
    h5("The background has different colours based on classification of precipitation reading: ")
  ),
  fluidRow(
    h5(" Grey -> No precipitation; Blue -> True precipitation; Yellow -> Uncertain data;")
  ),
  fluidRow(
    h5("Green -> Snow melting; Magenta -> Dew or Fog; Lightbue -> Irrigation or Dirt ")
  ),
  fluidRow(
    h5(strong(" Plot 2:")," the grey line is the time series Snow Height, if the sensor is installed on LTER station")
  )
)
)

esqc_data=esolip_data
events=esolip_events
input_data=read.csv(paste(git_folder,"data/Input_data/",FILE_NAME,".csv",sep = ""),stringsAsFactors = F)
units=input_data[c(1,2),]
rownames(input_data)=input_data[,1]
data=cbind(input_data[-c(1,2),-1],esqc_data[,-1])

for(j in 1:(ncol(data)-1)){
  data[,j]=as.numeric(data[,j])
}
time=rownames(data)

year <- substring(time,1,4); month <- substring(time,6,7); day <- substring(time,9,10)
hour <- substring(time,12,13); min  <- substr(time,15,16);
date_chr <- paste(year, "-", month, "-", day, " ", hour, ":", min, ":00", sep="")
time_new <- as.POSIXct( strptime(x = date_chr, format = "%Y-%m-%d %H:%M:%S"), tz = 'Etc/GMT-1')

zoo_data=zoo(data[,-1], order.by = time_new)

zoo_events=zoo(events, order.by = time_new)

server=shinyServer(function(input, output) {
  Precipitation=zoo_data[,which(colnames(zoo_data)=="Precip_T_Int15")]
  val_index=zoo_events[,8]
  
  
  zero=val_index[val_index==0]
  zero[zero==0]=1
  prec=val_index[val_index==1]
  smelt=val_index[val_index==5]
  smelt[smelt==5]=1
  unc=val_index[val_index==9]
  unc[unc==9]=1
  dew=val_index[val_index==2]
  irr=val_index[val_index==4]
  irr[irr==4]=1
  
  if(length(dew)!=0){       # if doesn't work the script insert here some checks on irr, in some cases there are any values corresponting to irr
    dew[dew==2]=1
    m=merge(Precipitation,zero,prec,smelt,unc,dew,irr)
    time(m)=as.POSIXct(time(m))
    
    output$dygraph1 <- renderDygraph({
      dygraph(m,group = "subplot1",ylab = "Precipitation [mm/h]",main=FILE_NAME) %>% dyRangeSelector()%>%
        dySeries("Precipitation",axis = "y", color = "red" ,stepPlot = T)%>%
        dySeries("zero",axis = "y2",color = "eeeeee", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("prec",axis = "y2",color = "blue", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("smelt",axis = "y2",color = "green", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("unc",axis = "y2",color = "yellow", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("dew",axis = "y2",color = "magenta", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("irr",axis = "y2",color = "#3297ac", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dyAxis("y2",valueRange = c(0,1.1))%>%
        dyLegend(show="never")
    })
  } else {
    p=merge(Precipitation,zero,prec,smelt,unc)
    time(p)=as.POSIXct(time(p))
    
    output$dygraph1 <- renderDygraph({
      dygraph(p,group = "subplot1",ylab = "Precipitation [mm/h]",main=file) %>% dyRangeSelector()%>%
        dySeries("Precipitation",axis = "y", color = "red" ,stepPlot = T)%>%
        dySeries("zero",axis = "y2",color = "eeeeee", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("prec",axis = "y2",color = "blue", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("smelt",axis = "y2",color = "green", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("unc",axis = "y2",color = "yellow", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dySeries("irr",axis = "y2",color = "#3297ac", fillGraph = T, stepPlot = T,strokeWidth = 2)%>%
        dyAxis("y2",valueRange = c(0,1.1))%>%
        dyLegend(show="never")
      
    })
    
  }
  
  if(any(colnames(zoo_data)=="Snow_Height")){
    HS=zoo_data[,which(colnames(zoo_data)=="Snow_Height")]
    HS1=HS
    HS2=HS
    n=merge(HS1,HS2)
    time(n)=as.POSIXct(time(n))
    
    output$dygraph2 <- renderDygraph({
      dygraph(n,group = "subplot1",ylab="Snow Height [m]") %>% dyRangeSelector()%>%
        dySeries("HS1",axis = "y", color = "grey" )%>%
        dySeries("HS2",axis = "y2",color = "grey")%>%
        dyAxis("y",valueRange = c(0,1.5))%>%
        dyAxis("y2",valueRange = c(0,1.5))%>%
        dyLegend(show="never")
    })
  } else{ 
    HS_new=zoo(rep(x = 0,nrow(zoo_data)),order.by = time)
    HS1=HS_new
    HS2=HS_new
    q=merge(HS1,HS2)
    time(q)=as.POSIXct(time(q))
    output$dygraph2 <- renderDygraph({
      dygraph(q,group = "subplot1",ylab="Snow Height [m]",main="Ultrasonic sensor not installed: No Snow Height data available") %>% dyRangeSelector()%>%
        dySeries("HS1",axis = "y", color = "grey" )%>%
        dySeries("HS2",axis = "y2",color = "grey")%>%
        dyAxis("y",valueRange = c(0,1.5))%>%
        dyAxis("y2",valueRange = c(0,1.5))%>%
        dyLegend(show="never")
    })
    
  }
})


shinyApp(ui = ui, server = server)

# ================================================================== 
