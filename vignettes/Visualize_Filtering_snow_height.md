Visualize\_Filtering\_snow\_height.R
================

Introduction
------------

The script Visualize\_Filtering\_snow\_height.R in folder *inst* plot using dygraph the time series of snow height (HS) and the elaborations of this data. Differente color are used for original data (**HS\_original**), snow height cleaned using a range threshold (**HS\_range\_QC**), snow height cleaned using a rete threshold (**HS\_rate\_QC**), snow height calibrated (**HS\_calibrated**), the snow height filtered with method selected in algorithm *Filtering\_snow\_height.R* (**HS\_calibr\_smoothed**), and the snow height smoothed and checked with rate threshold (**HS\_calibr\_smooothed\_rate\_QC**).

Description of algorithm
------------------------

-   **Section 1:** in this section the algorithm load data of station selected in section **INPUT**

-   **Section 2:** the script plot time series of snow height and some elaborations of data.

Plot description
----------------

On the plot we can see:

-   **Plot1:** Snow Height data and elaborations of algorithm *Filtering\_snow\_height.R*. See color on palette:
    -   *HS\_original* blue marine
    -   *HS\_range\_QC* orange
    -   *HS\_rate\_QC* violet
    -   *HS\_calibrated* pink
    -   *HS\_calibr\_smoothed* green
    -   *HS\_calibr\_smooothed\_rate\_QC* ocher
-   **Example** <!-- ![](https://github.com/EURAC-Ecohydro/SnowSeasonAnalysis/tree/master/figs/img_snow_filtering.PNG) --> ![](C:/Users/CBrida/Desktop/Git/Upload/SnowSeasonAnalysis/figs/img_snow_filtering.PNG)

How to use
----------

Open script *Visualize\_Snow\_detection\_TS\_PAR.R* and:

1.  Select **file**, the name of station to examine (**without .csv**)
2.  Set **git folder**, the path where the package is download or used.
3.  Run **Section 1** to import data
4.  Run **Section 2** to visualize results using dygraphs
