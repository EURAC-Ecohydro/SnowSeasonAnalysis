Visualize\_Snow\_detection\_TS\_PAR.R
================

Title: "Visualize\_Snow\_detection\_TS\_PAR.R"
==============================================

Introduction
------------

The script Visualize\_Snow\_detection\_TS\_PAR.R in folder *inst* plot using dygraph the time series of snow height (HS) (if available) grey line with the classification of snow presence by models. Green represents snow presence period obtained by Soil Temperature (TS) and Photosynthetically active radiation (PAR), blue only PAR, red only TS

Description of algorithm
------------------------

-   **Section 1:** in this section the algorithm load data of station selected in section **INPUT**

-   **Section 2:** here the script calibrate snow height signal (if available) using an external file **Snow\_Depth\_Calibration\_file.csv** in *data/Snow\_Depth\_Calibration/* filled with real snow surveys (field campaign) or virtual snow depth calibration (visual inspection of snow height signal are set as 0 cm at the end of winter season)

-   **Section 3:** hte script plot time series of snow height (calibrated or not) and results of different snow detection models using dygraphs. We apply some checks to plot HS with or without calibration (select in **INPUT**) and to avoid problems if the snow height sensor is not installed on the station selected.

Plot description
----------------

On the plot we can see:

-   **Plot1:** Snow detection results of algorithm *Snow\_detection\_TS\_PAR.R*. Different values for different models are only for visualization. The output are 0 -&gt; no snow , 1 -&gt; snow for each models. ([more details](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/vignettes/Snow_detection_TS_PAR.Rmd)):
    -   *HS:* grey
    -   *Snow detection using TS+PAR:* green
    -   *Snow detection using TS:* red
    -   *Snow detection using PAR:* blue
-   **Example** ![](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/blob/master/figs/img_Snow_detection.PNG)

How to use
----------

Open script *Visualize\_Snow\_detection\_TS\_PAR.R* and:

1.  Select **file**, the name of station to examine (**without .csv**)
2.  Set **git folder**, the path where the package is download or used.
3.  Set **calib\_snow** = T if you want to show snow height in dygraphs plot calibrated with snow depth calibration, or F if you don't need calibration
4.  Run **Section 1** to import data
5.  Run **Section 2** to calibrate snow height
6.  Run **Section 2** to visualize results using dygraphs
