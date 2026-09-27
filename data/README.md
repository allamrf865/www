# Data folder

This folder holds the extraction tables behind the network meta-analysis, plus the numbers that were read directly off the manuscript's figures so those figures could be redrawn in code instead of kept as static images.

## Files

- `study_characteristics.csv` — the study-level extraction table (Table 1 in the manuscript): country, design, arm sizes, closure techniques compared, and how each study defined simple versus complex gastroschisis. Transcribed directly from the manuscript table, no changes.
- `prisma_flow_counts.csv` — the record counts behind the PRISMA flow diagram (Figure 1). These add up correctly at every stage (790 records → 681 after de-duplication → 477 assessed in full text → 12 included), so the flow diagram can be regenerated with confidence.
- `risk_of_bias_rob2.csv` — RoB 2.0 domain judgements for the three randomized trials (Pastor 2008, Bruzoni 2017, Poola 2018).
- `risk_of_bias_robins_i.csv` — ROBINS-I domain judgements for the nine non-randomized cohorts.
- `netsplit_direct_indirect.csv` — the direct/indirect evidence split and network connectivity metrics for each of the six pairwise contrasts, digitized from Figure 3.
- `forest_ranking_digitized.csv` — the per-study event counts, risk ratios, weights, and ranking metrics digitized from Figure 4.
- `small_study_effects_tests.csv` — the Egger, Begg-Mazumdar, and Thompson-Sharp p-values reported alongside the funnel plot (Figure 5).

## A caveat that matters more than the rest of this file

`forest_ranking_digitized.csv` does not agree with `study_characteristics.csv` for the same studies. Two examples:

- Emami 2015 is listed in Table 1 with arms of 436 and 129 patients. The same study appears in Figure 4 with totals of 34 and 33.
- Hawkins 2019 is listed in Table 1 with arms of 224 and 337 patients. In Figure 4 it appears as 22 and 21.

Across all twelve rows of Figure 4, the control-arm total is within one patient of the experimental-arm total, and the P-scores step down in an almost perfectly even sequence (0.90, 0.87, 0.84, 0.80...). Real cohorts drawn from twelve different centers over roughly fifteen years do not behave like that, and they certainly don't behave like that while also contradicting the same manuscript's own Table 1.

This dataset is included here because it is what the published figure shows, and the code in `R/03_forest_plot_from_figure4.R` will faithfully redraw that figure from it. But redrawing a figure is not the same as validating it: this file should not be treated as the verified per-study outcome data until someone goes back to the twelve source articles (listed in `study_characteristics.csv` and cited in `references/gastroschisis_library.bib`) and re-extracts the actual event counts for whichever outcome Figure 4 is meant to represent. The netsplit and funnel-plot numbers (Figure 3 and Figure 5) are network-level summary statistics rather than per-patient counts, so they don't have the same kind of internal check available, but they carry the same open question: nobody has shown they were computed from the study data as it stands in Table 1.

Nothing in `R/03_forest_plot_from_figure4.R` recomputes a network meta-analysis from raw arm-level data — that would require the true extraction spreadsheet, which was not part of what was supplied for this repository. What's here is a faithful, clearly labeled redrawing of the published figures, not an independent re-derivation of the underlying statistics.
