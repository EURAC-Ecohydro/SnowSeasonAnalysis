Filtering\_snow\_height.R
================

Title: "Filtering\_snow\_height.R"
==================================

Introduction
------------

The script Filtering\_snow\_height.R in folder *inst* want to increase quality of data of snow height signal measured with a SR50AT sensor produced by Campbell Scientific ([Link](https://www.campbellsci.com/sr50at-l)). In our data there is some problems, for exmaple some data are out of a phisycal range. To identify these sampling problems we apply some thresholds on range and on increasing/decreasing rate filtering improbable values. After these process the main objective is filtering remaining noise. We apply 2 methods: a moving average filter with a window of 5 hours and a Savitzky-Golay smoothing filter.Documentation of Savitzky-Golay smoothing filter are available online (<https://cran.r-project.org/web/packages/signal/signal.pdf>)\[1\]. The main problem of moving average is the smoothing of true snowfall peaks, the Savitzky-Golay smoothing filter seems to exclude this, if we set a small a filter length. In our analysis we observe some strange phenomenous during snow melting. The snow height signal, expecially during warm and sunny days in spring, has a minimum in the middle of afternoon and increase during the night. Our first hypothesis was that the temperature correction applied, as suggest in User Manual, was not enough. The second hypotesys was that the snow react in a different way depending on his status. So the ultrasonic signal penetrates more in melted snow than in fresh or not melted snow. Open issues: how to filter this snow signal?

Description of script
---------------------

-   **Section 1:** in this section you have to select *git\_folder* and *file* of data. This files must contain the column: **Snow\_Height**

-   **Section 2:** here the script import data and extract snow column using the input section.

-   **Section 3:** more realistic data are created in this section using snow depth calibration point. In the file **Snow\_Depth\_Calibration\_file.csv** in folder *data/Snow\_Depth\_Calibration/* you can insert real snow surveys (snow height under ultrasoni sensor), or virtual snow survey (observing time series and set the value at the dates of end of snow season as 0 cm). With these informations we can calibrate snow height time series. The calibration function apply a linear transformation between 2 snow depth measurements, and a constant transformation from the last snow survey and the end of time series.

-   **Section 4:** in this section the algorithm substitute value out of range and value with high increasing/decreasing rate with NA. Data out of phisycal range are considered improbable, as data that change fastly.

-   **Section 5:** here the algorithm perform a filtering of snow height signal in two different ways. The first is a moving average filter, which has the problem of smoothing of true snowfall signal. The second is a Savitzky-Golay smoothing filter that seems to work better than moving average expecially setting small value for filter period. The smoothig process can create values with not realistic behaviour, so a rate thresholds as in section 3 is applied on filtered value, as suggested in Comai thesis \[2\]. At the end of **Section 5** you can select which is your favourite smoothing filter to save in **Section 6**

-   **Section 6:** in this section the algorithm save a dataframe cointaining some partial results of filtering snow signal as:
    -   *Snow\_file.Rdata* in folder *data/Output/Snow\_Filtering\_RData/* for visualization tool
    -   *Snow\_file.csv* in folder *data/Output/Snow\_Filtering/* for storage results. In this file you can find the original snow height time series, the snow height cleaned using a range threshold,the snow height cleaned using a rete threshold, the snow height calibrated, the snow height filtered with method selected, and the snow height smoothed and checked with rate threshold.

Note on file *Snow\_Depth\_Calibration\_FILE.csv*
-------------------------------------------------

This file contain all snow surveys and snow calibration point used to calibrate raw data of ultrasonic snow sensor.

1.  The first column, called **date**, is the date and time of measurement, and the second, called **snow\_height**, is the snow height at the station, as near as possible at the sensor.
2.  The **date** should be **hourly**, Date format is YYYY-MM-DD hh:mm (where mm is 00). Example:
    -   Correct: 2017-02-15 15:00
    -   Incorrect: 2017-02-15 15:30 (minutes not admitted)

3.  The **snow\_height** should be in **meters**. You should convert snow surveys from cm to m (divide per 100)
4.  Snow surveys should be orderd from the **oldest** to the **most recent**. Remember to reorder snow surveys every times you insert new one. If the snow surveys are not orederd the calibration don't work properly

How to use
----------

Open script *Filtering\_snow\_height.R* and:

1.  Set **git folder**, the path where the package is download or used.
2.  Run **Section 1** (up to **INPUT**) to explore data available in folder *data/Input data*
3.  Select the file (containing **Snow\_Height**) to process
4.  Run **Section 2** to read data
5.  Run **Section 3** to calibrate snow height time series
6.  Run **Section 4** to perform a quality check based on range and on rate of data
7.  Run **Section 5** (up to **INPUT**) to filter signal using moving average filter and Savitzky-Golay smoothing filters
8.  Select in **INPUT** the data filtered you want to keep
9.  Run the other part of **Section 5**
10. Run **Section 6** to save outputs

Reference
---------

\[1\] William H. Press, Saul A. Teukolsky, William T. Vetterling, Brian P. Flannery, Numerical Recipes in C: The Art of Scientific Computing , 2nd edition, Cambridge Univ. Press, N.Y., 1992.

\[2\] Comai T. ,Analisi spaziale e temporale delle precipitazioni nevose nelle alpi italiane, Rel. Rigon Riccardo, Università degli Studi di Trento, AA 2013/2014
