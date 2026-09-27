# Scripts

Run in order from the repository root. Each one reads a CSV from `data/` and writes to `figures/regenerated/`.

| Script | Produces | Status |
|---|---|---|
| `00_setup.R` | installs the packages the other scripts need | run once per machine |
| `01_prisma_flow.R` | Figure 1, the PRISMA flow diagram | verified against `data/prisma_flow_counts.csv`, which sums correctly at every stage |
| `02_risk_of_bias_plot.R` | Figure 2, both the RoB 2.0 and ROBINS-I traffic-light panels | direct transcription of the manuscript's judgements |
| `03_forest_plot_from_figure4.R` | Figure 4, the forest and ranking plot | redraws the published figure faithfully; read the note below first |
| `04_netsplit_barplot.R` | Figure 3, the direct/indirect evidence panels | digitized from the published figure, not recomputed from a model |
| `05_network_meta_template.R` | nothing yet, on purpose | a template that stops until real arm-level data is supplied |

## Why Figure 4's script comes with a warning

`data/forest_ranking_digitized.csv` gives each of the twelve studies a patient total in the 20-to-40 range. `data/study_characteristics.csv`, from the same manuscript, gives some of those same studies wildly different totals: Emami 2015 is 436 versus 129 patients in one table and 34 versus 33 in the other, Hawkins 2019 is 224 versus 337 in one table and 22 versus 21 in the other. Twelve independent cohorts spanning multiple countries and roughly fifteen years should not cluster this tightly, and they certainly shouldn't contradict their own study characteristics table while doing it. `03_forest_plot_from_figure4.R` will draw the figure exactly as published, but that is a redraw, not a validation.

## Finishing the network meta-analysis

`05_network_meta_template.R` stops on purpose because Figure 5, the comparison-adjusted funnel plot, needs the real per-study, per-comparison arm-level data (treatment, n, events, or mean/sd), and that table was not supplied when this repository was built. Once it is available, the pipeline is:

```r
arm_level_data <- read_csv("data/arm_level_outcomes.csv", show_col_types = FALSE)

pw <- pairwise(
  treat = treatment,
  event = event,
  n = n,
  studlab = study,
  data = arm_level_data,
  sm = "RR"
)

net <- netmeta(pw, random = TRUE, reference.group = "DC")
netrank(net)
netsplit(net)
funnel(net, order = c("PC", "DC", "SC", "SL"))
```

That last call reproduces Figure 5 directly from the fitted model, along with the Egger, Begg-Mazumdar, and Thompson-Sharp tests currently hand-entered in `data/small_study_effects_tests.csv`.
