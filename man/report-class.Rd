% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/class-report.R
\docType{class}
\name{report-class}
\alias{report-class}
\alias{.report}
\alias{report}
\alias{show_layers,report-method}
\alias{show_layers}
\alias{yaml,ANY-method}
\alias{yaml}
\alias{yaml<-,ANY-method}
\alias{yaml<-}
\alias{new_report,missing-method}
\alias{new_report,character-method}
\alias{new_report}
\alias{call_command,report-method}
\alias{call_command}
\title{...}
\usage{
\S4method{show_layers}{report}(x)

\S4method{yaml}{ANY}(x)

\S4method{yaml}{ANY}(x) <- value

\S4method{new_report}{missing}(..., yaml)

\S4method{new_report}{character}(..., yaml)

\S4method{call_command}{report}(x)
}
\arguments{
\item{value}{The value for the slot.}

\item{...}{...}

\item{yaml}{...}
}
\description{
...

\code{show_layers}: show \code{layers} slots in a pretty
and readable style.

\code{yaml}, \code{yaml<-}: getter and setter
for the \code{yaml} slot of the object.

\code{new_report()}: get the default parameters for the method \code{new_report}.

\code{new_report(x, ...)}: use the default parameters whatever 'missing'
while performing the method \code{new_report}.

\code{new_report}: ...

\code{call_command}: Format 'report' object as character, which can be output
by \code{writeLines()} function as '.Rmd' file and than use \code{rmarkdown::render} as
pdf, html, or other format files.
}
\section{Slots}{

\describe{
\item{\code{yaml}}{...}
}}

\examples{
\dontrun{
new('report', ...)
}
\dontrun{
show_layers(...)
}
\dontrun{
new_report(...)
}
\dontrun{
call_command(...)
}
}
\seealso{
\code{\link[=writeLines]{writeLines()}}, \code{\link[rmarkdown:render]{rmarkdown::render()}}...

Other layerSets: 
\code{\link{ggset-class}},
\code{\link{layerSet-class}}

Other call_commands: 
\code{\link{code_block-class}},
\code{\link{ggset-class}},
\code{\link{section-class}}
}
\concept{call_commands}
\concept{layerSets}