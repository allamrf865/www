# Gastroschisis closure network meta-analysis: data and analysis code

This repository holds the extraction data, risk-of-bias tables, and analysis scripts behind a systematic review and network meta-analysis comparing primary fascial closure, delayed or silo-based closure, sutured closure, and sutureless closure for gastroschisis in neonates. It accompanies a manuscript prepared for submission to the Journal of Pediatric Surgery by the Department of Pediatric Surgery, Universitas Padjadjaran.

The manuscript text itself is not included here. This repository is meant to sit alongside the paper as its data and code companion, the kind of thing that gets archived on Zenodo so a reader can check how a figure was produced rather than take it on faith.

## What is actually in here, and what isn't

Twelve studies were included after the PRISMA screening process (three randomized trials, nine comparative cohorts). Their characteristics, the risk-of-bias judgements, and the PRISMA flow counts are transcribed faithfully from the manuscript and check out arithmetically: the record counts sum correctly at every screening stage, and the risk-of-bias domains match what's described in the text.

The forest plot and ranking figure (Figure 4 in the manuscript) is a different story, and it would be dishonest to present it here without saying so plainly: its per-study patient totals do not match the arm sizes reported in the same manuscript's own study characteristics table. Emami 2015 is listed with 436 and 129 patients in one place and 34 and 33 in the other; Hawkins 2019 is listed with 224 and 337 patients in one place and 22 and 21 in the other. That is not a rounding difference, and it is not explainable as "a subgroup of a larger cohort" once you look at how tightly all twelve rows cluster together regardless of each study's real size. `data/README.md` walks through this in more detail. The code that redraws that figure is here, and it redraws it faithfully from what was published, but redrawing a figure is not the same thing as vouching for the numbers in it. Whoever owns this dataset should go back to the twelve source papers and re-extract the actual outcome counts before this becomes the version of record.

The network-level statistics behind Figures 3 and 5 (the direct/indirect evidence split, the funnel plot bias tests) are included as reported in the manuscript, since there is no independent check available for aggregate network output the way there is for per-patient counts. But the raw arm-level dataset that would let someone actually refit the network model from scratch was not available when this repository was put together, so `R/05_network_meta_template.R` is left as a template rather than a working analysis — it says exactly what data it needs and stops rather than pretending to run.

## Repository layout

```
data/                          extraction tables (see data/README.md for details and caveats)
R/                             analysis and figure-generation scripts, numbered in run order
figures/original/              the figures as they appear in the manuscript, for reference
figures/regenerated/           the same figures redrawn from data/ by the scripts in R/
references/                    the Zotero bibliography used for the introduction and discussion
```

## Reproducing the figures

The four scripts that produce genuine output (`01` through `04`) were tested end to end in a clean R 4.3 environment with `readr`, `dplyr`, `tidyr`, `ggplot2`, `forcats`, and `scales` installed. From the repository root:

```r
source("R/01_prisma_flow.R")          # Figure 1
source("R/02_risk_of_bias_plot.R")    # Figure 2 (both panels)
source("R/03_forest_plot_from_figure4.R")  # Figure 4 — read the caveat above first
source("R/04_netsplit_barplot.R")     # Figure 3
```

Output lands in `figures/regenerated/`. `R/05_network_meta_template.R` will stop with an explanatory error until the real arm-level extraction data is supplied, by design — see the comments at the top of that file for what's needed to finish it.

## Statistical approach described in the manuscript

The review followed PRISMA 2020. Direct and indirect evidence across the four closure strategies were synthesized with a frequentist random-effects network meta-analysis, with treatment ranking based on P-scores. Bayesian sensitivity analyses using weakly informative priors and Markov chain Monte Carlo estimation were run in parallel to check how much the frequentist estimates depended on modeling choices. Risk of bias was assessed with RoB 2.0 for the randomized trials and ROBINS-I for the cohort studies, and certainty of evidence was graded with GRADE adapted for network meta-analysis. Small-study effects were assessed with a comparison-adjusted funnel plot and the Egger, Begg-Mazumdar, and Thompson-Sharp tests.

## License

Code in `R/` is released under the MIT license (see `LICENSE`). The extraction tables in `data/` are shared under CC BY 4.0, consistent with how the underlying published studies (cited in `references/gastroschisis_library.bib`) are themselves licensed for reuse in systematic reviews.
