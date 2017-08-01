\name{ESOLIP_QC}
\alias{ESOLIP_QC}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
ESOLIP_QC(PATH, FILE, ELEVATION, CLIMAREPORT, git_folder)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{PATH}{
%%     ~~Describe \code{PATH} here~~
}
  \item{FILE}{
%%     ~~Describe \code{FILE} here~~
}
  \item{ELEVATION}{
%%     ~~Describe \code{ELEVATION} here~~
}
  \item{CLIMAREPORT}{
%%     ~~Describe \code{CLIMAREPORT} here~~
}
  \item{git_folder}{
%%     ~~Describe \code{git_folder} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (PATH, FILE, ELEVATION, CLIMAREPORT, git_folder) 
{
    elevation = ELEVATION
    climareport = CLIMAREPORT
    source(paste(git_folder, "R/esqc_Read_data_metadata.R", sep = ""))
    zoo_data = fun_read_data(PATH, FILE)
    units = fun_read_units(PATH, FILE)
    original = zoo_data
    source(paste(git_folder, "R/esqc_Range.R", sep = ""))
    zoo_data[, which(colnames(zoo_data) == "Precip_T_Int15")] = fun_range(DATA = zoo_data, 
        VARIABLE = "Precip_T_Int15", git_folder)
    unfavorable = zoo_data[, which(colnames(zoo_data) == "RH")] < 
        50 & zoo_data[, which(colnames(zoo_data) == "SR_Sw")] > 
        400
    unfavorable[unfavorable == TRUE] = "Unlikely"
    unfavorable[unfavorable == FALSE] = "Possible"
    df_event = as.data.frame(unfavorable)
    colnames(df_event) = "Precip_?"
    source(paste(git_folder, "R/esqc_Wet_Bulb_Calculator.R", 
        sep = ""))
    vett_Twb = c()
    T_Air = as.numeric(zoo_data[, which(colnames(zoo_data) == 
        "T_Air")])
    RH = as.numeric(zoo_data[, which(colnames(zoo_data) == "RH")])
    for (i in 1:nrow(zoo_data)) {
        if (!is.na(T_Air[i]) & !is.na(RH[i])) {
            vett_Twb[i] = Tf_single(Ta = T_Air[i], RH = RH[i], 
                elevation = elevation)
        }
        else {
            vett_Twb[i] = NA
        }
    }
    Twb = zoo(vett_Twb, order.by = index(zoo_data))
    phase = Twb
    phase[Twb <= 0] = "Snow"
    phase[Twb >= 1] = "Rain"
    phase[Twb > 0 & Twb < 1] = "Mix"
    df_event = cbind(df_event, as.data.frame(phase))
    snow_melting = zoo_data[, which(colnames(zoo_data) == "Precip_T_Int15")] != 
        0 & unfavorable == "Unlikely"
    qual_index = snow_melting
    qual_index[snow_melting == T] = "Possible Snow Melting/Irrigation"
    no_prec = zoo_data[, which(colnames(zoo_data) == "Precip_T_Int15")] == 
        0 & unfavorable == "Unlikely"
    qual_index[no_prec == T] = "No precipitation"
    prec = zoo_data[, which(colnames(zoo_data) == "Precip_T_Int15")] != 
        0 & unfavorable == "Possible"
    qual_index[prec == T] = "Precipitation recorded"
    possible = zoo_data[, which(colnames(zoo_data) == "Precip_T_Int15")] == 
        0 & unfavorable == "Possible"
    qual_index[possible == T] = "Possible precipitation not recorded"
    qual_index[qual_index == F] = NA
    df_event = cbind(df_event, as.data.frame(qual_index))
    val_index = qual_index
    val_index[val_index == "Possible Snow Melting/Irrigation"] = 5
    val_index[val_index == "No precipitation"] = 0
    val_index[val_index == "Precipitation recorded"] = 1
    val_index[val_index == "Possible precipitation not recorded"] = 9
    df_event = cbind(df_event, as.data.frame(val_index))
    df = data.frame(zoo_data, Twb, df_event)
    clima = read.csv(climareport, stringsAsFactors = F)
    clima_date = rep(clima[, 1], each = 24)
    clima_clear = rep(clima[, 2], each = 24)
    clima_cloudy = rep(clima[, 3], each = 24)
    clima_variable = rep(clima[, 4], each = 24)
    clima_precipitation = rep(clima[, 5], each = 24)
    h_char = c("00", "01", "02", "03", "04", "05", "06", "07", 
        "08", "09", "10", "11", "12", "13", "14", "15", "16", 
        "17", "18", "19", "20", "21", "22", "23")
    c_hour = rep(h_char, times = length(clima_date)/24)
    year <- substring(clima_date, 1, 4)
    month <- substring(clima_date, 6, 7)
    day <- substring(clima_date, 9, 10)
    hour <- c_hour
    c_date_chr <- paste(year, "-", month, "-", day, " ", hour, 
        ":00:00", sep = "")
    c_datetime <- as.POSIXct(strptime(x = c_date_chr, format = "\%Y-\%m-\%d \%H:\%M:\%S"), 
        tz = "Etc/GMT-1")
    clima_new = zoo(data.frame(clima_clear, clima_cloudy, clima_variable, 
        clima_precipitation), order.by = c_datetime)
    colnames(clima_new) = c("clear", "cloudy", "variable", "precipitation")
    clima_index = clima_new[, which(colnames(clima_new) == "clear")] == 
        1 | clima_new[, which(colnames(clima_new) == "cloudy")] == 
        1
    clima_index[clima_index == TRUE] = "Certain no precipitation"
    clima_index[is.na(clima_index)] = "Possible_precipitation"
    index_1 = clima_index == "Certain no precipitation" & qual_index == 
        "Possible Snow Melting/Irrigation"
    index_2 = clima_index == "Certain no precipitation" & qual_index == 
        "No precipitation"
    index_3 = clima_index == "Certain no precipitation" & qual_index == 
        "Precipitation recorded"
    index_4 = clima_index == "Certain no precipitation" & qual_index == 
        "Possible precipitation not recorded"
    index_5 = clima_index == "Possible_precipitation" & qual_index == 
        "Possible Snow Melting/Irrigation"
    index_6 = clima_index == "Possible_precipitation" & qual_index == 
        "No precipitation"
    index_7 = clima_index == "Possible_precipitation" & qual_index == 
        "Precipitation recorded"
    index_8 = clima_index == "Possible_precipitation" & qual_index == 
        "Possible precipitation not recorded"
    index_tot = index_1
    index_tot[index_1 == T] = "SnowMelting/Irrigation"
    index_tot[index_2 == T] = "No precipitation"
    index_tot[index_3 == T] = "SnowMelting/Irrigation"
    index_tot[index_4 == T] = "No precipitation"
    index_tot[index_5 == T] = "Uncertain"
    index_tot[index_6 == T] = "No precipitation"
    index_tot[index_7 == T] = "Precipitation"
    index_tot[index_8 == T] = "Uncertain"
    index_tot[index_tot == F] = NA
    val_index = index_tot
    val_index[val_index == "SnowMelting/Irrigation"] = 5
    val_index[val_index == "No precipitation"] = 0
    val_index[val_index == "Precipitation"] = 1
    val_index[val_index == "Uncertain"] = 9
    df_event = cbind(df_event[, 1:3], as.data.frame(index_tot), 
        as.data.frame(val_index))
    s_ind_1 = phase == "Snow" & index_tot == "SnowMelting/Irrigation"
    s_ind_2 = phase == "Snow" & index_tot == "No precipitation"
    s_ind_3 = phase == "Snow" & index_tot == "Precipitation"
    s_ind_4 = phase == "Snow" & index_tot == "Uncertain"
    s_ind_5 = phase == "Rain" & index_tot == "SnowMelting/Irrigation"
    s_ind_6 = phase == "Rain" & index_tot == "No precipitation"
    s_ind_7 = phase == "Rain" & index_tot == "Precipitation"
    s_ind_8 = phase == "Rain" & index_tot == "Uncertain"
    s_ind_9 = phase == "Mix" & index_tot == "SnowMelting/Irrigation"
    s_ind_10 = phase == "Mix" & index_tot == "No precipitation"
    s_ind_11 = phase == "Mix" & index_tot == "Precipitation"
    s_ind_12 = phase == "Mix" & index_tot == "Uncertain"
    s_index = s_ind_1
    s_index[s_ind_1 == T] = "SnowMelting/Irrigation"
    s_index[s_ind_2 == T] = "No precipitation"
    s_index[s_ind_3 == T] = "Precipitation"
    s_index[s_ind_4 == T] = "Uncertain"
    s_index[s_ind_5 == T] = "SnowMelting/Irrigation"
    s_index[s_ind_6 == T] = "No precipitation"
    s_index[s_ind_7 == T] = "Precipitation"
    s_index[s_ind_8 == T] = "No precipitation"
    s_index[s_ind_9 == T] = "SnowMelting/Irrigation"
    s_index[s_ind_10 == T] = "No precipitation"
    s_index[s_ind_11 == T] = "Precipitation"
    s_index[s_ind_12 == T] = "Uncertain"
    s_index[s_index == F] = NA
    val_index = s_index
    val_index[val_index == "SnowMelting/Irrigation"] = 5
    val_index[val_index == "No precipitation"] = 0
    val_index[val_index == "Precipitation"] = 1
    val_index[val_index == "Uncertain"] = 9
    df_event = cbind(df_event[, -which(colnames(df_event) == 
        "val_index")], as.data.frame(s_index), as.data.frame(val_index))
    month = substring(index(zoo_data), 6, 7)
    result_index = s_index
    result_index[s_index == "SnowMelting/Irrigation" & month \%in\% 
        c("06", "07", "08") & zoo_data[, which(colnames(zoo_data) == 
        "Precip_T_Int15")] <= 0.2 & zoo_data[, which(colnames(zoo_data) == 
        "Precip_T_Int15")] > 0] = "Dew/Fog/Dirty"
    result_index[s_index == "SnowMelting/Irrigation" & month \%in\% 
        c("06", "07", "08") & zoo_data[, which(colnames(zoo_data) == 
        "Precip_T_Int15")] > 0.2] = "Precipitation"
    df_event = cbind(df_event[, -which(colnames(df_event) == 
        "val_index")], as.data.frame(result_index), as.data.frame(val_index))
    val_index = result_index
    val_index[val_index == "SnowMelting/Irrigation"] = 5
    val_index[val_index == "No precipitation"] = 0
    val_index[val_index == "Precipitation"] = 1
    val_index[val_index == "Uncertain"] = 9
    val_index[val_index == "Dew/Fog/Dirty"] = 2
    df_event = cbind(df_event[, -which(colnames(df_event) == 
        "val_index")], as.data.frame(val_index))
    new_data = data.frame(as.data.frame(zoo_data), df_event[, 
        6])
    colnames(new_data) = c(colnames(zoo_data), "Precip_T_Int15_Metadata")
    ext_units = cbind(units[-1, -1], NA)
    colnames(ext_units) = colnames(new_data)
    new_data = rbind(ext_units, new_data)
    new_event = cbind(index(zoo_data), df_event)
    colnames(new_event)[1] = "TIMESTAMP"
    return(list(new_data, new_event))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
