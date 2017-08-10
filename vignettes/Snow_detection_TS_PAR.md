Snow\_detection\_TS\_PAR.R
================

Title: "Snow\_detection\_TS\_PAR.R"
===================================

Introduction
------------

The script Snow\_detection\_TS\_PAR.R in folder *inst* analyzes Soil Temperature (TS) and Photosynthetically active radiation (PAR) to extract snow presence near the station. The algoritm improve results obtained only with one of these elements. The algorithm check if soil temperature (@ 0 cm) has high or low value and how it is the daily amplitude. At the same time it check the daily ratio between PAR @ 2 m and @ 0 cm (soil level) and the daily maximum at soil level. Combining these infomarmations we can determinate the presence/absence of snow without ultrasonic snow sensor.

Description of script
---------------------

-   **Section 1:** in this section you select input file to process. Input files are in folder *data/Input data*. After the selection the script import data as a zoo series

-   **Section 2:** here you set inputs used to run models used. You should assign to each variable the corresponding column names of zoo\_data:
    -   **soil\_temperature** (required)
    -   **phar\_up** (required)
    -   **phar\_down** (required)
    -   **snow\_height**(optional)

    You can also tune these moldel parameters:

    -   **daily\_mean\_soil\_tempeature\_threshold**: Default is 3.5 deg C. Threshold on daily mean soil temperature. Under this value the model *TS* suggest snow presence
    -   **daily\_amplitude\_soil\_tempeature\_threshold**: Default is 3 deg C. Threshold on daily amplitude of soil temperature. Under this value the model *TS* suggest snow presence
    -   **daily\_max\_ratio\_parup\_pardown**: Default is 0.1. Threshold on daily ratio between maximum PAR at soil level (**phar\_down**) and maximum PAR on weather station (**pahr\_up**) Under this value the model *PAR* suggest snow presence
    -   **daily\_max\_pardown**: Default is 75 w/m2. Threshold on daily maximum PAR at soil level (**phar\_down**). Under this value the model *PAR* suggest snow presence

    Running row by row this section the algorithm plots the data selected for an help and a fast visual inpsection.

-   **Section 3:** this section run different models and combining results. Two different models are combined in a third. Here we explain how single models is built and how they are combined.
    -   **TS**: *Snow presence Soil Temp*. This model analyse only soil temperaute at 0 cm and indicate snow presence (flag = 1) every **day** that have at the same time a small daily mean and a small daily amplitude

    -   **PAR**: *Snow presence PAR*. This model analyse only phar sensors (PHotosynthetically Active Radiation sensors) at soil level (phar\_down) and on weather station (phar\_up). It indicate snow presence (flag = 1) every **day** that have at the same time small radiation incoming that hit the soil passing through grass and a small ratio (that suggest that a lot of incoming radiation is blocking by snowpack)

    -   **TS+PAR**: *Snow presence PAR + Soil Temp*. This model combine the previous 2 in a smart way. We observe that the model **TS** are not able to find properly the early snowfall, probably due thermal inerthia of soil. Instead **PAR** perform better, it is observed an important decreasing on radiation at soil level is sufficient a few centimeter of snow. During spring, the two models perform at the opposite, the **PAR** is affected by high radiation that penetrate on melting snow. Instead the snow maintains the soil temperature constant until the complete snow melting (melting snow and water has a temperature near 0 deg C). To develop this model we take into account these facts and elaborate an algorithm that consider snow cover the events that staring with model *PAR* and ending with *ST*. For a stable results we assume that *PAR* have to detect snow for at least 2 days consecutively

-   **Section 4:** Save output as *.RData* for a visualizzation tool and as *.csv* to create a table

Datasets
--------

**INPUT:**

1.  **git\_folder**: source of package **SnowSeasonAnalysis**
2.  **file**: name of .csv file to process available in folder */data/Input data*
3.  **soil\_temperature**: Required. The column name of *file* corresponding with soil temperature. In the Example: "ST\_CS\_00"
4.  **phar\_up**: Required. The column name of *file* corresponding with phar up. In the Example: "PAR\_Up"
5.  **phar\_down**: Required. The column name of *file* corresponding with phar down. In the Example: "PAR\_Soil\_LS"
6.  **snow\_height**: Optional. The column name of *file* corresponding with snow height. In the Example: "Snow\_Height"
7.  **daily\_mean\_soil\_tempeature\_threshold**: Default is 3.5 deg C. Threshold of daily mean of soil temperature that suggest snow presence.
8.  **daily\_amplitude\_soil\_tempeature\_threshold**: Default 3 deg C. Threshold of daily amplitude of soil temperature that suggest snow presence
9.  **daily\_max\_ratio\_parup\_pardown**: Default 0.1 (10%). Threshold of ratio between daily maximum of PAR at soil level and at 2 meters that suggest snow presence.
10. **daily\_max\_pardown**: Default 75 W/m2). Threshold of daily maximum PAR at soil level that suggest snow presence.
11. **SUMMER\_MONTHS**: Vector of summer months used to exclude snow in modes **TS**. Example "05": May, "06":June etc...

**OUTPUT:**

1.  **Snow\_presence\_file.RData**: in folder *data/Output/Snow\_Detection\_RData/* an .RData file which contains three zoo time series of:
    -   *Snow presence PAR + Soil Temp*: Hourly snow presence time series, detect with model **TS+PAR**. Value: 0 means NO SNOW, 1 means SNOW
    -   *Snow presence PAR*: Hourly snow presence time series, detect with model **PAR**. Value: 0 means NO SNOW, 1 means SNOW
    -   *Snow presence Soil Temp*: Hourly snow presence time series, detect with model **TS**. Value: 0 means NO SNOW, 1 means SNOW

2.  **Snow\_presence\_file.csv**: in folder *data/Output/Snow\_Detection/* a.csv file file which contains three zoo time series of:
    -   *TIMESTAMP*: date and time of data
    -   *Snow presence PAR + Soil Temp*: Hourly snow presence time series, detect with model **TS+PAR**. Value: 0 means NO SNOW, 1 means SNOW
    -   *Snow presence PAR*: Hourly snow presence time series, detect with model **PAR**. Value: 0 means NO SNOW, 1 means SNOW
    -   *Snow presence Soil Temp*: Hourly snow presence time series, detect with model **TS**. Value: 0 means NO SNOW, 1 means SNOW

How to use
----------

Open script *Snow\_detection\_TS\_PAR.R* and:

1.  Set **git folder**, the path where the package is download or used.
2.  Run **Section 1** to explore data available in folder *data/Input data*
3.  Select **file**, the station you want process (**Section 1.i**)
4.  Run **Section 2** row by row to explore and select the best variables for TS and PAR
5.  Run **Section 3** to produce output. This section combine results of different models used
6.  Run **Section 4** to save outputs:
    -   *.RData* contains a list of models zoo series used by Visualize\_Snow\_detection\_TS\_PAR.R (a tool for a graphical analysis of snow detection)
    -   *.csv* is a dataframe built using different models time series

References:
-----------

Teubner, I.E., L. Haimberger, and M. Hantel, 2015: Estimating Snow Cover Duration from Ground Temperature. J. Appl. Meteor. Climatol., 54, 959-965, <https://doi.org/10.1175/JAMC-D-15-0006.1>
