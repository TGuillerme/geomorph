% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/compare.multi.evol.rates.r
\name{compare.multi.evol.rates}
\alias{compare.multi.evol.rates}
\title{Comparing net rates of shape evolution among traits on phylogenies}
\usage{
compare.multi.evol.rates(A, gp, phy, Subset = TRUE, iter = 999,
  print.progress = TRUE)
}
\arguments{
\item{A}{A matrix (n x [p x k]) or 3D array (p x k x n) containing GPA-aligned coordinates for a set of specimens}

\item{gp}{A factor array designating group membership}

\item{phy}{A phylogenetic tree of {class phylo} - see \code{\link[ape]{read.tree}} in library ape}

\item{Subset}{A logical value indicating whether or not the traits are subsets from a single 
landmark configuration (default is TRUE)}

\item{iter}{Number of iterations for significance testing}

\item{print.progress}{A logical value to indicate whether a progress bar should be printed to the screen.
This is helpful for long-running analyses.}
}
\value{
An object of class "evolrate" returns a list of the following: 
  \item{rates.all}{The phylogenetic evolutionary rates for each trait.}
  \item{rate.ratio}{The ratio of maximum to minimum evolutionary rates.}
  \item{pvalue}{The significance level of the observed rate ratio.}
  \item{pvalue.gps}{Matrix of pairwise significance levels comparing each pair of rates.}
  \item{call}{The matched call.}
}
\description{
Function calculates net rates of shape evolution for two or more multi-dimensional traits on a 
phylogeny from a set of Procrustes-aligned specimens
}
\details{
The function compares net rates of morphological evolution for two or more multi-dimensional traits
on a phylogeny, under a Brownian motion model of evolution following the procedure of Denton and 
Adams (2015). It is assumed that the landmarks for all traits have previously been aligned using
Generalized Procrustes Analysis (GPA) [e.g., with \code{\link{gpagen}}]. The approach calculates
multivariate net evolutionary rates found from the outer-product matrix of between species differences 
in morphospace after phylogenetic transformation (sensu Adams 2014). From the data the net rate of shape evolution for 
each multi-dimensional trait is calculated, and a ratio of rates is obtained. If three or more 
traits are used, the ratio of the maximum to minimum rate is used as a test statistic (see 
Denton and Adams 2015). Significance testing is accomplished by phylogenetic simulation in 
which tips data are obtained under Brownian motion using a an evolutionary rate matrix 
for all traits, which contains a common rate for all trait dimensions (Denton and Adams 2015).
If three or more traits are used, pairwise p-values are 
also returned.

The shape data may be input as either a 3D array (p x k x n) containing GPA-aligned coordinates 
for a set of species, or as a matrix (n x [p x k]) whose rows correspond to each species. In 
both cases, species names must be provided as rownames (for a matrix) or as the names of the 
third dimension of the array. Landmark  groups for each trait are then specified by a factor
array designating which landmark belongs to which trait. Additionally, if the method is to be 
used with other data (i.e., a set of length measurements), the input A should be a matrix 
of n rows of species and p columns of variables. In this case, the grouping factor should 
have each variable assigned to a trait group.

Comparisons of net evolutionary rates between traits may be accomplished in one of two ways. First, 
if the traits are are part of a single shape that was subjected to a single Procrustes 
superimposition (i.e., they are subsets of landmarks in the configuration), then the procedure
is performed without alteration as described above. However, if the shapes are derived from 
different structures (shapes) that were superimposed separately, then the estimates of the rates must 
take the difference in the number of trait dimensions into account (see discussion in Denton and
Adams 2015). This option is identified by selecting Subset = FALSE.

The generic functions, \code{\link{print}}, \code{\link{summary}}, and \code{\link{plot}} all work with 
 \code{\link{compare.multi.evol.rates}}.
 The generic function, \code{\link{plot}}, produces a histogram of random rate-ratios associated with
 the resampling procedure.
}
\examples{

data(plethspecies) 
Y.gpa<-gpagen(plethspecies$land)    #GPA-alignment    
land.gp<-c("A","A","A","A","A","B","B","B","B","B","B")  #mandible and cranium subsets

EMR<-compare.multi.evol.rates(A=Y.gpa$coords,gp=land.gp, 
    Subset=TRUE, phy= plethspecies$phy,iter=999)
summary(EMR)
plot(EMR)
}
\references{
Adams, D.C. 2014. Quantifying and comparing phylogenetic evolutionary rates for 
 shape and other high-dimensional phenotypic data. Syst. Biol. 63:166-177.

Denton, J.S.S., and D.C. Adams. 2015. A new phylogenetic test for comparing 
multiple high-dimensional evolutionary rates suggests interplay of evolutionary rates and 
modularity in lanternfishes (Myctophiformes; Myctophidae). Evolution. 69:2425-2440.
}
\author{
Dean Adams
}
\keyword{analysis}
