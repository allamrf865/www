library(readr)
library(dplyr)
library(netmeta)

stop(
  paste(
    "This script is a template. Supply the arm-level extraction data",
    "(one row per study arm) before running the analysis.",
    "See R/README.md for the expected columns and the full pairwise/netmeta/netsplit/funnel pipeline.",
    sep = "\n"
  )
)
