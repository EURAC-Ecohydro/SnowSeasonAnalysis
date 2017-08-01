\name{fun_read_metadata}
\alias{fun_read_metadata}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
fun_read_metadata(PATH, FILE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{PATH}{
%%     ~~Describe \code{PATH} here~~
}
  \item{FILE}{
%%     ~~Describe \code{FILE} here~~
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
function (PATH, FILE) 
{
    data = read.csv(paste(PATH, FILE, sep = ""), stringsAsFactors = F)
    units = data[c(1, 2), ]
    data = data[-c(1, 2), ]
    if (colnames(data)[ncol(data)] == "Precip_T_Int15_Metadata") {
        METADATA = T
    }
    else {
        METADATA = F
        warning("This file doesn't contain 'Precip_T_Int15_Metadata'. No 'Precip_T_Int15_Metadata' available!")
        warning("Function: read_metadata has not assigned any new variable! Be careful!")
    }
    if (METADATA == T) {
        year <- substring(data[, 1], 1, 4)
        month <- substring(data[, 1], 6, 7)
        day <- substring(data[, 1], 9, 10)
        hour <- substring(data[, 1], 12, 13)
        min <- substr(data[, 1], 15, 16)
        date_chr <- paste(year, "-", month, "-", day, " ", hour, 
            ":", min, ":00", sep = "")
        time <- as.POSIXct(strptime(x = date_chr, format = "\%Y-\%m-\%d \%H:\%M:\%S"), 
            tz = "Etc/GMT-1")
        zoo_metadata = zoo(data[, ncol(data)], order.by = time)
    }
    return(zoo_metadata)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
