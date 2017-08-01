SnowSeasonAnalysis
================

Introduction
------------

The R package SnowSeasonAnalysis is a group of tools for the analysis of data during winter. In particular there are some scripts for quality check of precipitation data during winter, or there are some scripts for the analysis of snow presence using different methods, and combining results to improve the models. The third script is a procedure for analisys and filtering of snow height signal.

The goal of the project is to perform in R an algorithm to evaluate the precipitation recorded of a tipping bucket, based on paper ESOLIP, Mair E et al. \[1\]. Using other parameters measured on the station we classify 6 different events and give the opporunity of an user of data to decide if the precipitation recorded is realistic or not.

Another work done during the project was the implementation of an algorithm for snow cover duration. Classical method use daily amplitude and daily maximum of soil temperature for detection snow cover. But early snow fall wasn't detected because the soil freezing slowly, and expecially in early autumn, when temperatures are mild, and snow falls are weak, the soil doesn't react fastly. Using PAR we examine the part of radiation that hit soil and compare with a free sensor (2 m). In this way we improve the classical snow detection algorithm and can obtain some validation points for hydrological models or satellites products

The third part of this package is a snow filtering tool. This tool want to increase quality of snow height data excluding bad value (out of phisycal range and rate) and smoothing noise deriving by sampling condition. There is an open issue deriving to the behaviour of snow height signal during snow melting days. In warm and sunny days during spring the signal varies by a few centimeters during the day. We are not able to distinguish the cause of this strange behaviour. An hypotesis could be the insufficient signal correction with temperature, other analysis suggests that ultrasonic signal seems to penetrate on the "wet" snow more than in dry snow. A complete explanation need more investigation, and an appropriate filtering technique is not so easy to find.

In the package there are some scripts (folder **inst**):

-   **Filtering\_precipitation\_readings.R** that run and save the ESOLIP quality check algorithm. [More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Filtering_precipitation_readings.Rmd)
-   **Visualize\_Filtering\_precipitation\_readings.R** that load results of Filtering\_precipitation\_readings.R and plot some graphs using *Shiny*.[More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Visualize_ESOLIP.Rmd)
-   **Snow\_detection\_TS\_PAR.R** that analyzes Soil Temperature (TS) and Photosynthetically active radiation (PAR) to detect the presence of snow at the station with a daily resolution.[More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Snow_detection_TS_PAR.Rmd)
-   **Visualize\_Snow\_detection\_TS\_PAR.R** that load results of Snow\_detection\_TS\_PAR.R and plot some dynamic graphs. [More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Visualize_ESOLIP.Rmd)
-   **Filtering\_snow\_height.R** that filter snow height signal using some thresholds and some filtering techniques.[More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Filtering_snow_height.Rmd)
-   **Visualize\_Filtering\_snow\_height.R** that load results of Filtering\_snow\_height.R and plot a dynamic graphs. [More details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Visualize_Filtering_snow_height.Rmd)

Required data
-------------

Put in folder *data* the following data:

1.  In the folder *Climareport* add/update *Climareport.csv*
2.  In the folder *Input data* add/update *Station\_xxx\_yyy.csv*. Is has to be **hourly aggregated** and must have the following parameters:
    -   **Precip\_T\_Int15** (required)
    -   **T\_Air** (required)
    -   **RH** (required)
    -   **SR\_Sw** (required)
    -   **Snow\_Height** (optional)

3.  In the folder *Support files* update (not necessary) **Range\_min\_max** to modify thresholds to detect ouliers using physical range of values
4.  In the folder *Support files* update (not necessary) **Rate\_min\_max** to modify thresholds to detect ouliers using possible rate of increasing/decreasing
5.  In the folder *Snow\_Depth\_Calibration* add files **Snow\_Depth\_Calibration\_file.csv** with snow sureveys and virtual snow calibration point (see snow height time series and insert the date of end of winter season. Set the value of snow height at this date as 0 cm)
