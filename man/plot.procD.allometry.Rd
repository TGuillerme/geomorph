% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geomorph.utils.r
\name{plot.procD.allometry}
\alias{plot.procD.allometry}
\title{Plot Function for geomorph}
\usage{
\method{plot}{procD.allometry}(x, method = c("CAC", "RegScore", "PredLine"),
  warpgrids = TRUE, label = NULL, gp.label = FALSE, pt.col = NULL,
  mesh = NULL, shapes = FALSE, ...)
}
\arguments{
\item{x}{plot object (from \code{\link{procD.allometry}})}

\item{method}{Method for estimating allometric shape components}

\item{warpgrids}{A logical value indicating whether deformation grids for small and large shapes 
should be displayed (note: if groups are provided no TPS grids are shown)}

\item{label}{An optional vector indicating labels for each specimen that are to be displayed}

\item{gp.label}{A logical value indicating labels for each group to be displayed (if group was originally included); "PredLine" only}

\item{pt.col}{An optional vector of colours to use for points (as in points(bg=))}

\item{mesh}{A mesh3d object to be warped to represent shape deformation of the minimum and maximum size 
if {warpgrids=TRUE} (see \code{\link{warpRefMesh}}).}

\item{shapes}{Logical argument whether to return the the shape coordinates shape coordinates of the small and large shapes}

\item{...}{other arguments passed to plot}
}
\value{
If shapes = TRUE, function returns a list containing the shape coordinates of the small and large shapes
}
\description{
The following are brief descriptions of the different plotting methods, with references.
\itemize{
\item {If "method=CAC" (the default) the function calculates the 
  common allometric component of the shape data, which is an estimate of the average allometric trend 
  within groups (Mitteroecker et al. 2004). The function also calculates the residual shape component (RSC) for 
  the data.}
  \item {If "method=RegScore" the function calculates shape scores 
  from the regression of shape on size, and plots these versus size (Drake and Klingenberg 2008). 
  For a single group, these shape scores are mathematically identical to the CAC (Adams et al. 2013).}
  \item {If "method=PredLine" the function calculates predicted values from a regression of shape on size, and 
  plots the first principal component of the predicted values versus size as a stylized graphic of the 
  allometric trend (Adams and Nistri 2010). }
  }
}
\references{
Adams, D.C., F.J. Rohlf, and D.E. Slice. 2013. A field comes of age: geometric morphometrics 
  in the 21st century. Hystrix. 24:7-14.

Adams, D. C., and A. Nistri. 2010. Ontogenetic convergence and evolution of foot morphology 
  in European cave salamanders (Family: Plethodontidae). BMC Evol. Biol. 10:1-10.

Drake, A. G., and C. P. Klingenberg. 2008. The pace of morphological change: Historical 
  transformation of skull shape in St Bernard dogs. Proc. R. Soc. B. 275:71-76.

Mitteroecker, P., P. Gunz, M. Bernhard, K. Schaefer, and F. L. Bookstein. 2004. 
  Comparison of cranial ontogenetic trajectories among great apes and humans. J. Hum. Evol. 46:679-698.
}
\author{
Michael Collyer
}
\keyword{utilities}
\keyword{visualization}
