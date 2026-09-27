<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:2E7D32,100:1565C0&height=180&section=header&text=Gastroschisis%20Closure%20NMA&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Data%20%2B%20Code%20companion%20repository&descAlignY=58&descSize=18" width="100%"/>

<a href="https://github.com/allamrf865/www">
  <img src="https://readme-typing-svg.demolab.com/?font=Fira+Code&size=20&pause=1200&color=1565C0&center=true&vCenter=true&width=780&lines=Primary+vs+Delayed+vs+Sutureless+Closure+for+Gastroschisis;Systematic+Review+%2B+Network+Meta-analysis;Frequentist+NMA+with+Bayesian+Sensitivity+Checks;PRISMA+2020+%C2%B7+RoB+2.0+%C2%B7+ROBINS-I+%C2%B7+GRADE" alt="animated subtitle" />
</a>

<br/>

![R](https://img.shields.io/badge/R-4.3-276DC3?logo=r&logoColor=white)
![License: MIT](https://img.shields.io/badge/code%20license-MIT-blue.svg)
![Data License: CC BY 4.0](https://img.shields.io/badge/data%20license-CC%20BY%204.0-lightgrey.svg)
![PRISMA 2020](https://img.shields.io/badge/PRISMA-2020-2E7D32)
![Status](https://img.shields.io/badge/status-data%20verified%20partially-yellow)

</div>

---

This repository holds the extraction data, risk-of-bias tables, and analysis scripts behind a systematic review and network meta-analysis comparing primary fascial closure, delayed or silo-based closure, sutured closure, and sutureless closure for gastroschisis in neonates. It accompanies a manuscript prepared for submission to the Journal of Pediatric Surgery by the Department of Pediatric Surgery, Universitas Padjadjaran.

The manuscript text itself is not included here. This repository is meant to sit alongside the paper as its data and code companion, the kind of thing that gets archived on Zenodo so a reader can check how a figure was produced rather than take it on faith.

<details>
<summary><strong>Table of contents</strong></summary>

- [What is actually in here, and what isn't](#what-is-actually-in-here-and-what-isnt)
- [Repository layout](#repository-layout)
- [Reproducing the figures](#reproducing-the-figures)
- [Statistical approach described in the manuscript](#statistical-approach-described-in-the-manuscript)
- [License](#license)

</details>

## What is actually in here, and what isn't

Twelve studies were included after the PRISMA screening process (three randomized trials, nine comparative cohorts). Their characteristics, the risk-of-bias judgements, and the PRISMA flow counts are transcribed faithfully from the manuscript and check out arithmetically: the record counts sum correctly at every screening stage, and the risk-of-bias domains match what's described in the text.

> [!WARNING]
> The forest plot and ranking figure (Figure 4 in the manuscript) does not reconcile with the manuscript's own study characteristics table. Emami 2015 is listed with 436 and 129 patients in one place and 34 and 33 in the other; Hawkins 2019 is listed with 224 and 337 patients in one place and 22 and 21 in the other. That is not a rounding difference, and it is not explainable as a subgroup of a larger cohort once you look at how tightly all twelve rows cluster together regardless of each study's real size. `data/README.md` and `R/README.md` walk through this in more detail. The code that redraws that figure is here, and it redraws it faithfully from what was published, but redrawing a figure is not the same thing as vouching for the numbers in it. Whoever owns this dataset should go back to the twelve source papers and re-extract the actual outcome counts before this becomes the version of record.

The network-level statistics behind Figures 3 and 5 (the direct/indirect evidence split, the funnel plot bias tests) are included as reported in the manuscript, since there is no independent check available for aggregate network output the way there is for per-patient counts. But the raw arm-level dataset that would let someone actually refit the network model from scratch was not available when this repository was put together, so `R/05_network_meta_template.R` is left as a template rather than a working analysis — it says exactly what data it needs and stops rather than pretending to run.

## Repository layout

```
data/                          extraction tables (see data/README.md for details and caveats)
R/                             analysis and figure-generation scripts, numbered in run order
figures/original/              the figures as they appear in the manuscript, for reference
figures/regenerated/           the same figures redrawn from data/ by the scripts in R/
references/                    the Zotero bibliography used for the introduction and discussion
```

<details>
<summary><strong>Preview: original figures side by side with the regenerated ones</strong></summary>

| Figure | Original | Regenerated |
|---|---|---|
| 1. PRISMA flow | `figures/original/fig1_prisma.png` | `figures/regenerated/fig1_prisma_regenerated.png` |
| 2. Risk of bias | `figures/original/fig2_risk_of_bias.webp` | `figures/regenerated/fig2a_rob2_regenerated.png`, `fig2b_robins_i_regenerated.png` |
| 3. Direct/indirect evidence | `figures/original/fig3_netsplit.webp` | `figures/regenerated/fig3a_direct_indirect_share.png` and two companion plots |
| 4. Forest and ranking | `figures/original/fig4_forest_ranking.webp` | `figures/regenerated/fig4_forest_regenerated.png` — see the warning above |
| 5. Funnel plot | `figures/original/fig5_funnel.png` | not regenerated — needs the raw arm-level dataset, see `R/05_network_meta_template.R` |

</details>

## Reproducing the figures

The four scripts that produce genuine output (`01` through `04`) were tested end to end in a clean R 4.3 environment with `readr`, `dplyr`, `tidyr`, `ggplot2`, `forcats`, and `scales` installed. From the repository root:

```r
source("R/01_prisma_flow.R")               # Figure 1
source("R/02_risk_of_bias_plot.R")         # Figure 2, both panels
source("R/03_forest_plot_from_figure4.R")  # Figure 4 — read the warning above first
source("R/04_netsplit_barplot.R")          # Figure 3
```

Output lands in `figures/regenerated/`. `R/05_network_meta_template.R` will stop with an explanatory error until the real arm-level extraction data is supplied — see `R/README.md` for exactly what's needed to finish it.

## Statistical approach described in the manuscript

The review followed PRISMA 2020. Direct and indirect evidence across the four closure strategies were synthesized with a frequentist random-effects network meta-analysis, with treatment ranking based on P-scores. Bayesian sensitivity analyses using weakly informative priors and Markov chain Monte Carlo estimation were run in parallel to check how much the frequentist estimates depended on modeling choices. Risk of bias was assessed with RoB 2.0 for the randomized trials and ROBINS-I for the cohort studies, and certainty of evidence was graded with GRADE adapted for network meta-analysis. Small-study effects were assessed with a comparison-adjusted funnel plot and the Egger, Begg-Mazumdar, and Thompson-Sharp tests.

## License

Code in `R/` is released under the MIT license (see `LICENSE`). The extraction tables in `data/` are shared under CC BY 4.0, consistent with how the underlying published studies (cited in `references/gastroschisis_library.bib`) are themselves licensed for reuse in systematic reviews.

<div align="center">
<sub>Department of Pediatric Surgery, Universitas Padjadjaran</sub>
</div>
