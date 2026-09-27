# Template for the actual network meta-analysis (frequentist, netmeta) and
# for the comparison-adjusted funnel plot (Figure 5).
#
# This script is intentionally not run against fabricated numbers. Figure 5
# needs per-study, per-comparison standardized mean differences and standard
# errors — the raw scatter behind the funnel plot — and that raw table was
# not part of what was supplied for this repository (only the three test
# p-values printed in the corner of the figure were available; those are
# stored in data/small_study_effects_tests.csv). Filling in the arm-level
# counts below with anything other than the real extraction data would mean
# manufacturing a funnel plot that only looks like the published one.
#
# To finish this once the real extraction spreadsheet is available:
#   1. Replace `arm_level_data` below with a data frame read from that
#      spreadsheet: one row per study arm, with columns
#      study, treatment, n, event (or mean/sd for continuous outcomes).
#   2. Run netmeta::pairwise() to build the contrast-level dataset.
#   3. Fit the network model with netmeta::netmeta().
#   4. netmeta::netsplit(model) reproduces Figure 3 from real data instead
#      of the digitized version in 04_netsplit_barplot.R.
#   5. netmeta::funnel(model, order = c("PC","DC","SC","SL")) reproduces
#      Figure 5 directly, and reports the same Egger/Begg/Thompson tests
#      that are hand-entered in data/small_study_effects_tests.csv.

library(readr)
library(dplyr)
library(netmeta)

# arm_level_data <- read_csv("data/arm_level_outcomes.csv", show_col_types = FALSE)
#
# pw <- pairwise(
#   treat = treatment,
#   event = event,
#   n = n,
#   studlab = study,
#   data = arm_level_data,
#   sm = "RR"
# )
#
# net <- netmeta(pw, random = TRUE, reference.group = "DC")
# netrank(net)
# netsplit(net)
# funnel(net, order = c("PC", "DC", "SC", "SL"))

stop(
  paste(
    "This script is a template. Supply the arm-level extraction data",
    "(one row per study arm) before running the analysis — see the",
    "comments above for the expected columns.",
    sep = "\n"
  )
)
