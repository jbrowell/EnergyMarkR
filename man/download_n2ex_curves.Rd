% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/download_n2ex_curves.R
\name{download_n2ex_curves}
\alias{download_n2ex_curves}
\title{Download n2ex Curve Data}
\usage{
download_n2ex_curves(
  path = paste0(get_credentials()$data_path, "n2ex_auction_cross/"),
  h = new_handle(httpauth = 1, userpwd = get_credentials()$n2ex),
  years = 10:(year(Sys.Date()) - 2000)
)
}
\arguments{
\item{path}{Path to folder for n2ex curve data}

\item{years}{Which years (last two digits, only data from 2000s available) should be downloaded?}

\item{userpwd}{Credentials for the n2ex FTP}
}
\description{
Download or update n2ex buy and sell curves data from the n2ex FTP.
}
\details{
Files are downloaded if a local copy does not exisit. The file corresponding to the last
year in \code{years} is updated.
}
\author{
Jethro Browell, \email{jethro.browell@strath.ac.uk}
}
