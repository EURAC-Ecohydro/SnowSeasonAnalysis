\name{fun_range}
\alias{fun_range}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
fun_range(DATA, VARIABLE, git_folder)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{DATA}{
%%     ~~Describe \code{DATA} here~~
}
  \item{VARIABLE}{
%%     ~~Describe \code{VARIABLE} here~~
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
function (DATA, VARIABLE, git_folder) 
{
    range_data = read.csv(paste(git_folder, "data/Support files/Range_min_max.csv", 
        sep = ""), stringsAsFactors = F)
    if (any(colnames(DATA) == VARIABLE)) {
        MIN = range_data$MIN[which(range_data$VARIABLE == VARIABLE)]
        MAX = range_data$MAX[which(range_data$VARIABLE == VARIABLE)]
        if (is.na(MIN) | is.na(MAX)) {
            warning(paste(paste("Set up  the range of admitted values for '", 
                VARIABLE, "'.", sep = ""), "See: ", paste(git_folder, 
                "data/Support files/Range_min_max.csv", sep = ""), 
                sep = "\n"))
        }
        raw = DATA[, which(colnames(DATA) == VARIABLE)]
        new = raw
        new[which(new < MIN)] = NA
        new[which(new > MAX)] = NA
        return(new)
    }
    else {
        warning(paste("No column called '", VARIABLE, "'. Check input table!", 
            sep = ""))
        return(0)
    }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
