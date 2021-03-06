% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/digitsurface.r
\name{digitsurface}
\alias{digitsurface}
\title{Digitize 3D fixed landmarks and surface semilandmarks}
\usage{
digitsurface(spec, fixed, ptsize = 1, center = TRUE)
}
\arguments{
\item{spec}{Name of surface file, as either an object of class shape3d/mesh3d, or matrix of three-dimensional vertex coordinates.}

\item{fixed}{numeric Either: a single value designating the number of fixed template landmarks to be selected by \code{\link{digit.fixed}}, OR a p-x-k matrix of 3D coordinates collected previously}

\item{ptsize}{numeric: Size to plot the mesh points (vertices), e.g. 0.1 for dense meshes, 3 for sparse meshes}

\item{center}{Logical Whether the object 'spec' should be centered prior to digitizing (default {center=TRUE})}
}
\value{
Function writes to the working directory an NTS file with the name of the specimen and .nts suffix containing the landmark coordinates.
}
\description{
An interactive function to digitize three-dimensional (3D) landmarks on a surface lacking known landmarks.
Input for the function is either a matrix of vertex coordinates defining a 3D surface object
or a mesh3d object as obtained from \code{\link{read.ply}}.
}
\details{
Function for digitizing fixed 3D landmarks and placing "surface sliders", semilandmarks that slide over a surface.
 Following selection of fixed points (see digitizing below), function finds surface semilandmarks following 
 algorithm outlined in Gunz et al. (2005) and Mitteroecker and Gunz (2009). digitsurface finds the same number of surface 
 semilandmarks as the template (created by \code{\link{buildtemplate}}) by downsampling scanned mesh, registering template with 
 current specimen via GPA. A nearest neighbor algorithm is used to match template surface landmarks to current specimen's. 
 To use function digitsurface, the template must be constructed first, and 'template.txt' be in the working directory. Because template 
 matching is based on the correspondence of fixed landmark points in the template and the specimen, a minimum of four fixed landmarks must be used.

Some of the "fixed" landmarks digitized with digitsurface can be later designated as "curve sliders" using function 
\code{\link{define.sliders}} if required (see details in \code{\link{digit.fixed}}).
 NOTE: Function centers the mesh before digitizing by default (center=TRUE). If one chooses not to center,
 specimen may be difficult to manipulate in rgl window.

\subsection{Digitizing}{
Digitizing is interactive between landmark selection using a mouse (see below for instructions), 
and the R console. Once a point is selected, the user is asked if the system should keep or discard the 
selection (y/n). If "y", the user is asked to continue to select the next landmark. If "n" the removes the last chosen
landmark, and the user is asked to select it again. This can be repeated until the user is comfortable with the landmark
chosen.

To digitize with a standard 3-button (PC):
\enumerate{
 \item the RIGHT mouse button (primary) to select points to be digitized,
 \item the LEFT mouse button (secondary) is used to rotate mesh, 
 \item the mouse SCROLLER (third/middle) is used to zoom in and out.
}
NOTE: Digitizing functions on MACINTOSH computers using a standard 3-button mice works as specified. Macs using platform 
specific single button mice, XQuartz must be configured: go to Preferences > Input > tick "Emulate three button mouse":
\enumerate{
 \item press button to rotate 3D mesh,
 \item press button while pressing COMMAND key to select vertex to be used as a landmark,
 \item press button while pressing OPTION key to adjust mesh perspective.
 \item the mouse SCROLLER or trackpad two finger scroll is used to zoom in an out.
 }

NOTE: there is no pan (translate) functionality in rgl library for all platforms at this time.
}

\subsection{AUTO mode}{ 
The function as described above (for interactive mode) calls \code{\link{digit.fixed}}, prompting the user to select fixed landmarks
in the rgl window. However if the user has digitized these fixed landmark elsewhere (e.g., in other software), then the input for
parameter 'fixed' can be a p-x-k matrix of 3D coordinates. In this case, the function the function will automatically use these
landmarks and fit the template of sliding semilandmarks.
}
}
\references{
Gunz P, Mitteroecker P, & Bookstein FJ (2005) Semilandmarks in Three Dimensions. Modern Morphometrics in Physical Anthropology, ed Slice DE (Springer-Verlag, New York), pp 73-98.

Mitteroecker P & Gunz P (2009) Advances in Geometric Morphometrics. Evolutionary Biology 36(2):235-247.
}
\seealso{
\code{\link{buildtemplate}}

\code{\link{read.ply}}

\code{\link{digit.fixed}}
}
\author{
Erik Otarola-Castillo & Emma Sherratt
}
\keyword{digitizing}
