required_packages <- c(
  "readr",
  "dplyr",
  "tidyr",
  "ggplot2",
  "forcats",
  "scales",
  "netmeta",
  "meta"
)

missing_packages <- setdiff(required_packages, rownames(installed.packages()))

if (length(missing_packages) > 0) {
  install.packages(missing_packages, repos = "https://cloud.r-project.org")
}

invisible(lapply(required_packages, library, character.only = TRUE))
