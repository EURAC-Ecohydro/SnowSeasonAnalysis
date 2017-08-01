Filtering\_precipitation\_readings.R
================

Introduction
------------

The script Filtering\_precipitation\_readings.R in folder *inst* classify every precipitation measurement of tipping rain gauge in different class using additional parameters measured on the station. The script would like improve precipitation data quality based on paper ESOLIP, Mair et al.\[1\].

Description of script
---------------------

-   **Section 1:** in this section you can select inputs, for example the name of the station to process, the elevation, and the file of Climareport. See the example: data/Climareport/Climareport.csv. Climareport is a csv who we can find information about weather in Vinschgau valley, derived from textual [Climareport](http://weather.provinz.bz.it/publications.asp) published by Province of South Tyrol

-   **Section 2:** here the script run the function ESOLIP\_QC (in folder R) that classify the data measured by Tipping Rain Gauges using additional informations: wheather station parameters (e.g. as Air Temperature, Solar Radiation, ...), Climareport, and other experimental knowledge (e.g. improbable snow melting during summer, ...).

-   **Section 3:** in the previous section the algorithm generate an output that in this section are saved. There are two possibilities:
    -   *.RData:* required to examine result with shiny app in script Visualize\_Filtering\_precipitation\_readings.R
    -   *.csv:* to have the output in the same format as the input. Output is a single column called Precip\_T\_Int15\_Metadata. In this report you can find the description of metadata

Datasets
--------

**INPUT:**

-   name of .csv file to process available in folder *data/Input data*.
-   elevation of station
-   «path of clone of ESOLIP\_quality\_check **(not necessary if ESOLIP\_quality\_check is a package)**» (example:C:/Users/CBrida/Desktop/Git/Upload/ESOLIP\_quality\_check/)
-   «path of Input data **(don't edit this path)**»
-   «path of Climareport.csv **(don't edit this path)**»

**OUTPUT:**

-   *.RData*: .RData file which contains:
    -   **esolip\_data** -&gt; Time seried of Precip\_T\_Int15\_Metadata
    -   **esolip\_events** -&gt; Steps results. Every single step of ESOLIP\_QC function give in output some informations used for final result [More details about algorithm](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/?????????.Rmd)
-   *.csv*: 2 .csv files:
    -   **name of input file** that contains **esolip\_data** -&gt; input data + column Precip\_T\_Int15\_Metadata
    -   \*\*name of input file \_events\*\* that contains **esolip\_events** -&gt; step results. Every single step of ESOLIP\_QC function give in output some informations used for final result

**Description of Precip\_T\_Int15\_Metadata:**

This new column is the result of ESOLIP\_QC function. It could contain 7 value :

-   *No precipitation:* any precipitation are measured and any precipitation are possible
-   *Dew/Fog:* precipitation measured but probabily incorrect. Possible dew, fog condensed on tipping bucket
-   *Precipitation:* precipitation measured are plausible
-   *Uncertain:* precipitation not measured but to not exclude the possibility of losing of data
-   *SnowMelting:* precipitation recorded but improbable. Possible snow melting (during winter)
-   *Irrigation/Dirt* :precipitation measured but probabily incorrect. Possible Irrigation or dirt in the tipping bucket
-   *NaN: * evaluation impossible due missing data of additional parameters (T\_Air, RH, etc...)

How to use
----------

Open script *Filtering\_precipitation\_readings.R* and:

1.  Set **git folder**, the path where the package is download or used.
2.  Run **Section 1** to explore data available in folder *data/Input data*
3.  Select **file**, the station you want process.
4.  Select **elevation**, the elevation of the station
5.  Select **climareport**, the path and the file of Climareport (Suggest: update existing Climareport.csv in folder *data/Climareport*)
6.  Run **Section 2** to produce output
7.  Run **Section 3** to save output (Decide which type of output you want)

References:
-----------

\[1\] Mair, E., Bertoldi, G., Leitinger, G., Della Chiesa, S., Niedrist, G., and Tappeiner, U.: ESOLIP - estimate of solid and liquid precipitation at sub-daily time resolution by combining snow height and rain gauge measurements, Hydrol. Earth Syst. Sci. Discuss., 10, 8683-8714, <doi:10.5194/hessd-10-8683-2013>, 2013.
