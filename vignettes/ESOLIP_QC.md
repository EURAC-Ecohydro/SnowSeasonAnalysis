ESOLIP\_QC.R
================

Title: "ESOLIP\_QC.R"
=====================

Introduction
------------

This function is the core to generate metadata to evaluate precipitation. In particular the algorithm has different steps that check some additional information excluding period which precipitation is improbable or identify possible events of snow melting, irrigation, dew, fog or dirt in the tipping rain gauges. It is based on paper ESOLIP, Mair et al. \[1\]

Algorithm description:
----------------------

-   **STEP 1:** Evaluate the atmospheric conditions. As suggested in ESOLIP \[1\], precipitation is highly unlikely if there are two condition: strong solar radiation incoming (**SR\_Sw**) and low values of Relative Humidity (**RH**). We classify every sampling (1h) in two class:
    -   *Possible* : **RH** &gt; 50% or **SR\_Sw** &lt; 400 W/m² (high RH, low SR\_Sw)
    -   *Unlikely* : **RH** &lt; 50% and **SR\_Sw** &gt; 400 W/m² (low RH, high SR\_Sw)
-   **STEP 2:** Calculate the phase of eventually precipitation using Wet Bulb Temperature (**Twb**):
    -   *Snow* : **Twb** &lt; 0 C
    -   *Mix* : 0 C &lt; **Twb** &lt; 1 C
    -   *Rain* : **Twb** &gt; 1C
-   **STEP 3:** Compare STEP 1 with precipitation readings (**Precipt\_T\_Int15**). We want to classy precipitation using information about atmospheric conditions. We distinguish the case of precipitation recorded (Precip\_T\_Int15 &gt; 0) and any precipitation measured (Precip\_T\_Int15 = 0). Combining these informations with STEP 1 we obtain four class:
    -   *Precipitation recorded* : high **RH**, low **SR\_Sw** and **Precip\_T\_Int15** &gt; 0 suggest that the rain measured is effectively true
    -   *Possible precipitation not recorded* : high **RH**, low **SR\_Sw** suggest that the atmospheric conditions are positive for precipitation but the rain gauges doesn't record any value (**Precip\_T\_Int15** = 0). Uncertain evaluation
    -   *Possible Snow Melting/Irrigation* : low **RH**, high **SR\_Sw** and **Precip\_T\_Int15** &gt; 0. The atmospheric conditions are bad for precipitation but rain gauges measure something. Classic condition of snow melting after a snow event or during irrigation.
    -   *No precipitation* : low **RH**, high **SR\_Sw** and **Precip\_T\_Int15** = 0. Clear sky day and any values from rain gauges suggest a true precipitation readings
-   **STEP 4:** Compare STEP 3 with Climareport.csv. Climareport (in folder data/Climareport/Climareport.csv) is a table manual filled usign [Province Climareport](http://weather.provinz.bz.it/publications.asp) which contain information about the meteorological events. Days *without precipitation* are classified **Clear** (clear sky day) or **Cloudy** ( some clouds but without precipitation), days *with precipitation* **Variable** (Clouds and instable) and **Precipitation** (rain during the day). Combining these information we obtatin 8 combination that we aggregate in 4 classes:
    -   *No precipitation* : climareport suggests no precipitation and STEP 3 confirms this fact
    -   *Precipitation* : climareport allows precipitation and STEP3 confirms this fact
    -   *SnowMelting/Irrigation* : climareport suggests no precipitation but STEP 3 suggest precipitation or snow melting
    -   *Uncertain* : climareport don't exclude the possiblity of precipitation and STEP 3 admits that could be a possible precipitation not recorded
-   **STEP 5:** Compare STEP 4 with STEP 2. Tipping rain gauges have the most of issues during the winter, expecially if they aren't heated. An example is the accumulation of snow on the top of bucket and a fusion later than the snow event. To prevent we use the phase information and decide if it is rain or snow. Combining these information can reduce the number of uncertain data. The classes are the same as in STEP 4:
    -   *No precipitation*
    -   *Precipitation*
    -   *SnowMelting/Irrigation*
    -   *Uncertain*
-   **STEP 6:** During summer months is higly unlikely that we have Snow melting. We distinguish 2 case, one if 0 mm/h &lt; **Precip\_T\_Int15** &lt; 0.2 mm/h, little precipitation that could be fog or dew which condenses on tipping bucket walls. The second case is for **Precip\_T\_Int15** &gt; 0.2 mm/h that suggests Irrigation events or Dirt. The final classes are:
    -   *No precipitation*
    -   *Precipitation*
    -   *Uncertain*
    -   *SnowMelting*
    -   *Dew/Fog*
    -   *Irrigation/Dirt*
    -   (*NaN* if in one step evaluation couldn't be possible due missing data)

Model Flowchart
---------------

![](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/figs/img_ESOLIP_flowchart.PNG) ![](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/figs/img_ESOLIP_flowchart_2.PNG) ![](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/figs/img_ESOLIP_flowchart_3.PNG)

References:
-----------

\[1\] Mair, E., Bertoldi, G., Leitinger, G., Della Chiesa, S., Niedrist, G., and Tappeiner, U.: ESOLIP - estimate of solid and liquid precipitation at sub-daily time resolution by combining snow height and rain gauge measurements, Hydrol. Earth Syst. Sci. Discuss., 10, 8683-8714, <doi:10.5194/hessd-10-8683-2013>, 2013.
