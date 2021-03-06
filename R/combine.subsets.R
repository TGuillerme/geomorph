#' Combine separate landmark configurations 
#'
#' Combine separate landmark configurations (subsets) into one landmark set
#'
#' This function combines landmark configurations (either landmarks requiring GPA
#' or Procrustes coordinates following GPA) to create a different morphological data set.  
#' This might be of interest, for example, if one has landmarks digitized on separate images
#' collected from the same organisms.  (In the examples below, configurations for heads and tails
#' of larval salamanders were collected separately from images taken on the same individuals.)  An
#' attempt is made to scale configurations by their relative centroid sizes, following the procedure in
#' Davis et al. (2016); i.e., landmark coordinates are multiplied by CSi/(CSi + CSj + ...) before 
#' combining them, so that resulting combinations of landmarks are scaled to unit centroid size.  This is
#' only possible if GPA is performed on landmarks (gpa = TRUE) or centroid sizes are provided as an 
#' argument.  Objects of class \code{gpagen} can be used rather than original landmarks (recommended, 
#' especially if curves or surface sliding semilandmarks are used, as different arguments cannot be passed onto
#' onto separate GPAs via this function).
#' 
#' The procedure of Davis et al. (2016) is analogous to the "seperate subsets" method of Adams (1999)
#' for articulated structures.
#' 
#' @param ... Class gpagen objects, Procrustes coordinates from class gpagen objects, or original landmarks.  
#' As many data sets as desired can be supplied, separated by commas.  Additionally, arguments passed onto 
#' \code{\link{gpagen}} can be provided, but these arguments will be passed onto all GPAs performed.  Therefore,
#' it is recommended that GPA is performed first with \code{\link{gpagen}}, to maintain flexibility.  Naming
#' subsets is a good idea, as landmark names in the combined data set will take the subset name as a precursor.
#' @param gpa A logical argument to indicate if either (1) GPA should be performed (if original landmarks
#' are provided) or (2) \code{gpagen} objects are provided.  If TRUE, this function will check to see if 
#' the input is an object of class \code{gpagen}, and if not, perform GPA.  If FALSE, landmarks will be unchanged.
#' (One would choose gpa = FALSE if inputting aligned coordinates and centroid size, separately.  There might be
#' little reason to do this, unless one wishes to intentionally not scale configurations.)
#' @param CS.sets A list, array, or matrix of centroid sizes to use for scaling.  The default is NULL and should be
#' left so if gpa = TRUE.  If gpa = FALSE and CS.set is null, all centroid sizes become 1.0, meaning no scaling 
#' of configurations by relative size is performed.  If gpa = FALSE and CS.set is provided, scaling by relative 
#' size is performed according to the data input  (One could weight configurations via this method.).  If the 
#' CS.set input is a matrix, it is assumed that rows are specimens and columns correspond to the different landmark
#' sets.  Lists or arrays should be in the same order as the landmark sets.
#' @keywords utilities
#' @export
#' @references Davis, M.A., M.R. Douglas, M.L. Collyer, & M.E. Douglas, M. E. 2016.
#'  Deconstructing a species-complex: geometric morphometric and molecular analyses define species in the 
#'  Western Rattlesnake (Crotalus viridis). PloS one, 11(1), e0146166.
#' @references  Adams, D. C. 1999. Methods for shape analysis of landmark data from articulated structures. 
#'  Evolutionary Ecology Research. 1:959-970. 
#' @author Michael Collyer
#' @return An object of class \code{combined.set} is a list containing the following
#' \item{cords}{An [p x k x n] array of scaled, concatenated landmark coordinates.}
#' \item{CS}{A matrix of columns representing original centroid sizes of subsets,
#' either input or found via GPA.}
#' \item{GPA}{If gpa = TRUE, the gpagen results for each subset.}
#' \item{gpa.coords.by.set}{A list of the coordinates following GPA for each subset.}
#' \item{adj.coords.by.set}{A list of the coordinates of each subset, after rescaling.}
#' \item{points.by.set}{A vector of the number of landmarks in each subset.}
#' @examples
#' data(larvalMorph) 
#' head.gpa <- gpagen(larvalMorph$headcoords, curves = larvalMorph$head.sliders)
#' tail.gpa <- gpagen(larvalMorph$tailcoords, curves = larvalMorph$tail.sliders)
#' comb.lm <- combine.subsets(head = head.gpa, tail = tail.gpa, gpa = TRUE)
#' summary(comb.lm)
#' # Plot first specimen and color code landmarks 
#' # (configurations are actual relative size)
#' comb.lm$coords[,,1]
#' plot(comb.lm$coords[,,1], pch = 21, bg = c(rep(1,26), rep(2,64)), asp = 1)
#' 
#' # choose to override scaling by relative size 
#' comb.lm <- combine.subsets(head = head.gpa$coords, 
#' tail = tail.gpa$coords, gpa = FALSE, CS.sets = NULL)
#' summary(comb.lm)
#' plot(comb.lm$coords[,,1], pch = 21, bg = c(rep(1,26), rep(2,64)), asp = 1)


combine.subsets <- function(..., gpa = TRUE, CS.sets = NULL){
  sets <- list(...)
  if(!is.null(CS.sets)) {
    if(!is.list(CS.sets)) {
      ck <- dim(CS.sets)
      if(length(ck) == 3) {
        g <- ck[[3]]
        CS.sets <- lapply(1:g, function(j) as.matrix(CS.sets[,,j]))
      } 
      if(length(ck) == 2) {
          cat("\nAssuming CS values are columns of the matrix input\n")
          g <- ck[[1]]
          CS.sets <- lapply(1:g, function(j) as.matrix(CS.sets[,j]))
      }
      if(length(ck) != 2 && length(ck) != 3) {
        stop("CS.set is not an appropriate argument for this analysis.")
      }
    }
  }
  curves <- ifelse(is.null(sets$curves), NA, sets$curves)
  surfaces <- ifelse(is.null(sets$surfaces), NA, sets$surfaces)
  PrinAxes <- ifelse(is.null(sets$PrinAxes), NA, sets$PrinAxes)
  max.iter <- ifelse(is.null(sets$max.iter), NA, sets$max.iter)
  ProcD <- ifelse(is.null(sets$ProcD), NA, sets$ProcD)
  Proj <- ifelse(is.null(sets$Proj), NA, sets$Proj)
  print.progress <- ifelse(is.null(sets$print.progress), NA, sets$print.progress)
  if(is.na(curves)) curves <- NULL
  if(is.na(surfaces)) surfaces <- NULL
  if(is.na(PrinAxes)) PrinAxes <- TRUE
  if(is.na(max.iter)) max.iter <- NULL
  if(is.na(ProcD)) ProcD <- TRUE
  if(is.na(Proj)) Proj <- TRUE
  if(is.na(print.progress)) print.progress <- TRUE
  match.set <- match(names(sets), c("curves", "surfaces", "PrinAxes", 
                                 "max.iter", "ProcD", "Proj", "print.progress"))
  if(length(na.omit(match.set)) == 0) sets <- sets else{
    keep <- ifelse(is.na(match.set), TRUE, FALSE)
    sets <- sets[keep]
  }
  g <- length(sets)
  if(g < 2) stop(paste("At least two subsets are required. 
                 You have", g, "subset(s)."))
	if(gpa) {
		all.coords <- all.CS <- GPA <- as.list(array(0,g))
		dim.n.check <-  dim.k.check <- array(0,g)
		for(i in 1:g){
			x = sets[[i]]
			if(class(x) == "gpagen") y <- x else {
			  if(length(dim(x)) != 3) stop("\nCoordinates must be a  [p x k x n] array.\n  
			                               Use arrayspecs first")
			  y <- gpagen(x, curves = curves, surfaces = surfaces, PrinAxes = PrinAxes,
			                   max.iter = max.iter, ProcD = ProcD, Proj = Proj, 
			                   print.progress = print.progress)
			}
			GPA[[i]] <- y
			all.coords[[i]] = y$coords
			all.CS[[i]] = y$Csize
			dim.n.check[i] = length(y$Csize)
			dim.k.check[i] = dim(y$coords)[2]
		}
		if(length(unique(dim.n.check)) > 1) stop("Sets have different numbers of specimens")
		if(length(unique(dim.k.check)) > 1) stop("Sets have different numbers of landmarks")
	}
	if(!gpa){
	  GPA <- NULL
		if(is.null(CS.sets)) cat("\nNo CS sets input.  Final configurations will not be scaled\n")
		if(!is.null(CS.sets) && length(CS.sets) != length(sets)) cat("\nThere is a mismatch between number of coordinate sets and CS sets\n")
		all.coords = all.CS = as.list(array(0,g))
		dim.n.check = dim.k.check = array(0,g)
		for(i in 1:g){
			x = sets[[i]]
			if(length(dim(x)) != 3) stop("Coordinates must be a [p x k x n] array.\n  Use arrayspecs first")
			all.coords[[i]] = x
			if(is.null(CS.sets)) cs = rep(1,dim(x)[3]) else cs = CS.sets[[i]]
			all.CS[[i]] = cs
			dim.n.check[i] = length(cs)
			dim.k.check = dim(x)[2]
		}
		if(length(unique(dim.n.check)) > 1) stop("Sets have different numbers of specimens")
		if(length(unique(dim.k.check)) > 1) stop("Sets have different numbers of landmarks")
	}
	n <- dim.n.check[1]
	p <- array(0,g)
	for(i in 1:g) p[i] <- dim(all.coords[[i]][,,1])[1]
	k <- dim(all.coords[[1]][,,1])[2]
	CS.tot <- as.matrix(simplify2array(all.CS))
	CS.part <- CS.tot/rowSums(CS.tot)
	coords.part <- lapply(1:g, function(j){
	  all.coords[[j]]*CS.part[,j]
	})
	new.coords <- array(0, c(sum(p),k,n))
	if(g > 1) {
	  for(i in 1:n){
	    x <- coords.part[[1]][,,i]
	    for(ii in 2:g){
	      x <- rbind(x,coords.part[[ii]][,,i])
	    }
	    new.coords[,,i] <- x
	  }  
	} else new.coords <- all.coords[[1]]

	pnames <- unlist(lapply(1:g, function(j){
	  s <- names(sets)[[j]]
	  paste(s, 1:p[j], sep=".")
	}))
	
	if(k == 2) knames <- c("X", "Y")
	if(k == 3) knames <- c("X", "Y", "Z")
	dimnames(new.coords)[[1]] <- pnames
	dimnames(new.coords)[[2]] <- knames
	if(!is.null(names(all.coords[[1]]))) 
	  dimnames(new.coords[[3]]) <- names(all.coords[[1]])
	colnames(CS.tot) <-  colnames(CS.part) <- names(sets)
	names(all.coords) <- names(all.CS) <- names(coords.part) <- names(p) <- names(sets)
	out <- list(coords = new.coords, CS = CS.tot, rel.CS = CS.part,
	     GPA = GPA, 
	     gpa.coords.by.set = all.coords,
	     adj.coords.by.set = coords.part,
	     points.by.set = p)
	class(out) <- "combined.set"
	out
}