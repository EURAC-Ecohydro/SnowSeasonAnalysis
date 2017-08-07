Filtering\_precipitation\_readings.R
================

Title: "Filtering\_precipitation\_readings.R"
=============================================

Introduction
------------

The script Filtering\_precipitation\_readings.R in folder *inst* classify every precipitation measurement of tipping rain gauge in different class using additional parameters measured on the station. The script would like improve precipitation data quality based on paper ESOLIP, Mair et al.\[1\].

Description of script
---------------------

-   **Section 1:** in this section you can select inputs, for example the name of the station to process, the elevation, and the file of Climareport. See the example: /data/Climareport/Climareport.csv. Climareport is a csv who we can find information about weather in Vinschgau valley, derived from textual [Climareport](http://weather.provinz.bz.it/publications.asp) published by Province of South Tyrol. The file *Climareport.csv* distinguishes 4 possible events during a day (put the flag 1 to the events):
    -   **Clear**: Sunny day with clear sky and without precipitation.
    -   **Cloudy**: Day with some clouds but without precipitation.
    -   **Variable**: Day with variable weather conditions. In Vinschgau precipitation is possible but not sure.
    -   **Precipitation**: Days with rain. Precipitation in Vinschgau is highly possible.
    -   other optional paramater are *Snow* (snow limit) and *Notes* for additional informations such extreme events etc...

    In this section the script require the information of variable names. Assign to **precipitation**, **air\_temperature** , **relative\_humidity** and **radiatio** string of names of corresponding variable measured in input file. This variables are required for an evaluation of precipitation

-   **Section 2:** here the script run the function ESOLIP\_QC (in the file *esqc\_ESOLIP\_quality\_check.R* in folder R) that classify the data measured by Tipping Rain Gauges using additional informations: wheather station parameters (e.g. as Air Temperature, Solar Radiation, ...), Climareport, and other experimental knowledge (e.g. improbable snow melting during summer, ...).

-   **Section 3:** in the previous section the algorithm generate an output that in this section are saved. There are two possibilities:
    -   *.RData:* required to examine result with shiny app in script Visualize\_Filtering\_precipitation\_readings.R
    -   *.csv:* to have the output in the same format as the input. Output is a single column called Precip\_T\_Int15\_Metadata. In this report you can find the description of metadata

Datasets
--------

**INPUT:**

1.  **git\_folder**: source of package **SnowSeasonAnalysis**
2.  **path**: path of Input data **(don't edit this path)**
3.  **file**: name of .csv file to process available in folder */data/Input data*
4.  **elevation**: elevation of station
5.  **climareport**: path of Climareport file **(don't edit this path)**
6.  **precipitation**: the column name of *file* corresponding with precipitation parameter. Default (LTER stations) is "Precip\_T\_Int15"
7.  **air\_temperature**: the column name of *file* corresponding with air\_temperature parameter. Default (LTER stations) is "T\_Air"
8.  **relative\_humidity**: the column name of *file* corresponding with relative\_humidity parameter. Default (LTER stations) is "RH"
9.  **radiation**: the column name of *file* corresponding with radiation parameter. Default (LTER stations) is "SR\_Sw"

**INPUT DATA FORMAT:**

The files in folder */data/Input\_data/* should be **hourly aggregated**or hourly sampled and have:

-   the datetime (in LTER called **TIMESTAMP**) at the **first** column and should have this format: **YYYY-MM-DD HH:MM**. Example: "2017-07-15 09:00"
-   a **precipitation** variable. Example: "Precip\_T\_Int15"
-   an **air temperature** variable. Example: "T\_Air"
-   a **relative humidity** variable. Example: "RH"
-   a **solar radiation** variable. Example: "SR\_Sw"

**OUTPUT:**

-   **ESQC\_file.RData**: in folder *data/Output/Precipitation\_metadata\_RData/* an .RData file which contains:
    -   **esolip\_data** -&gt; Time seried of Precip\_T\_Int15\_Metadata
    -   **esolip\_events** -&gt; Steps results. Every single step of ESOLIP\_QC function give in output some informations used for final result [More details about algorithm](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/vignettes/ESOLIP_QC.Rmd)
-   **Prec\_Metadata\_file.csv**: in folder *data/Output/Precipitation\_metadata/Prec\_Metadata/* a.csv file which contains a time series of ESOLIP metadata (See above *esolip\_data*)

-   **ESQC\_Steps\_file.csv**: in folder *data/Output/Precipitation\_metadata/ESOLIP\_QC\_Steps/* a.csv file which contains a time series of steps results of ESOLIP alghorithm (See above *esolip\_events*) [More details about algorithm](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/vignettes/ESOLIP_QC.Rmd)

Note: in the output names above the algorithm substitute automatically **"file"** with the name of station, setting in **file &lt;- "..."** (INPUT 3)

**Description of Precip\_T\_Int15\_Metadata:**

This new column is the result of ESOLIP\_QC function. It could contain 7 value :

-   *No precipitation:* no precipitation is recorded and no precipitation is possible
-   *Dew/Fog:* precipitation measured but probabily incorrect. Possible dew, fog condensed on tipping bucket
-   *Precipitation:* precipitation measured is plausible
-   *Uncertain:* precipitation is not measured but is to not exclude the possibility of precipitation
-   *SnowMelting:* precipitation is recorded but improbable. Possible snow melting (during winter)
-   *Irrigation/Dirt* :precipitation is measured but probabily incorrect. Possible Irrigation or dirt in the tipping bucket
-   *NaN:* evaluation impossible due missing data of additional parameters (T\_Air, RH, etc...)

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
