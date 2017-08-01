\name{SVPwater}
\alias{SVPwater}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
SVPwater(Ta)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Ta}{
%%     ~~Describe \code{Ta} here~~
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
function (Ta) 
{
    est = 1013
    Ts = 373.16
    a = -7.90298
    b = 5.02808
    c = -1.3816e-07
    d = 11.344
    f = 0.0081328
    h = -3.49149
    TsT = Ts/(Ta + 273.15)
    Z = a * (TsT - 1) + b * log10(TsT) + c * (10^(d * (1 - TsT)) - 
        1) + f * (10^(h * (TsT - 1)) - 1)
    SvPw = est * 10^Z
    return(SvPw)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
