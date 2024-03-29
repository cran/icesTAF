#' Import a boot data script from ICES datasets repo
#'
#' Download an \file{R} file from the ICES datasets repo to fetch
#' data including adding metadata via roxygen2 fields to the top of the file.
#'
#' @param name the name of the dataset.
#' @param install.deps install packages used in the script if not already
#'        installed.
#' @param commit should the boot script be added and committed to the analysis.
#'
#' @examples
#' \dontrun{
#'
#' # Create boot folder
#' mkdir(taf.boot.path())
#'
#' # Create boot script, boot/mydata.R
#' add.data.script(name = "vms")
#'
#' # Create metadata, boot/DATA.bib
#' taf.roxygenise(files = "vms.R")
#'
#' # Run boot script, creating boot/data/vms/...
#' taf.boot()
#' }
#'
#' @importFrom TAF taf.boot.path
#'
#' @export


add.data.script <- function(name, install.deps = TRUE, commit = FALSE) {
  message(
    "browse TAF dataset scripts at:\n",
    "    https://github.com/ices-taf/datasets"
  )

  script <-
    readLines(
      sprintf("https://raw.githubusercontent.com/ices-taf/datasets/main/%s.R", name)
    )

  cat(
    script,
    sep = "\n",
    file = taf.boot.path(sprintf("%s.R", name))
  )

  if (install.deps) {
    install.deps()
  }

  if (commit) {
    loadpkg("git2r")
    git2r::add(".", taf.boot.path(sprintf("%s.R", name)))
    git2r::commit(".", sprintf("added TAF dataset %s.R", name))
  }

  message(
    "to add dataset to analysis run:\n\n",
    "# register script in DATA.bib\n",
    "taf.roxygenise()\n",
    "# fetch data\n",
    "taf.boot()\n"
  )
}
