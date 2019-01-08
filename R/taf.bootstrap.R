#' Bootstrap TAF Analysis
#'
#' Set up data files and software required for the analysis. Model configuration
#' files are also set up, if found.
#'
#' @note
#' This function should be called from the top directory of a TAF analysis. It
#' looks for a directory called \file{bootstrap} and prepares data files and
#' software according to metadata specifications.
#'
#' The bootstrap procedure consists of the following steps:
#' \enumerate{
#' \item If a directory \verb{bootstrap/initial/config} contains model
#' configuration files, they are copied to \verb{bootstrap/config}.
#' \item If a \verb{bootstrap/DATA.bib} metadata file exists, it is processed
#' with \code{\link{process.bib}}.
#' \item If a \verb{bootstrap/SOFTWARE.bib} metadata file exists, it is
#' processed with \code{\link{process.bib}}.
#' }
#'
#' To override this default bootstrap procedure, the user can create a custom
#' \verb{bootstrap.R} script. If this script is found, the \code{taf.bootstrap}
#' function runs that script instead of the default bootstrap procedure.
#'
#' After the bootstrap procedure, data and software have been documented and
#' are ready to be used in the subsequent analysis. Specifically, the procedure
#' populates up to four new directories:
#' \itemize{
#' \item \verb{bootstrap/config} with model configuration files.
#' \item \verb{bootstrap/data} with data files.
#' \item \verb{bootstrap/library} with R packages compiled for the local
#' platform.
#' \item \verb{bootstrap/software} with software files, such as R packages in
#' \verb{tar.gz} source code format.
#' }
#'
#' @seealso
#' \code{\link{process.bib}} is a helper function used to process metadata.
#'
#' \code{\link{icesTAF-package}} gives an overview of the package.
#'
#' @examples
#' \dontrun{
#' taf.bootstrap()
#' }
#'
#' @export

taf.bootstrap <- function()
{
  if(file.exists("bootstrap.R"))
  {
    sourceTAF("bootstrap.R")
  }
  else
  {
    msg("Bootstrap procedure running...")
    if(!dir.exists("bootstrap"))
      stop("'bootstrap' directory not found")

    ## Create empty subdirectories
    taf.library(quiet=TRUE)
    setwd("bootstrap"); on.exit(setwd(".."))
    mkdir(c("config", "data", "library", "software"))

    ## 1  Process config
    if(dir.exists("initial/config"))
      cp("initial/config", ".")

    ## 2  Process data
    process.bib("DATA.bib")

    ## 3  Process software
    process.bib("SOFTWARE.bib")

    ## Remove empty folders
    rmdir(c("config", "data", "library", "software"))
    rmdir("library:", recursive=TRUE)  # this directory name can appear in Linux
    msg("Bootstrap procedure done")
    invisible(NULL)
  }
}