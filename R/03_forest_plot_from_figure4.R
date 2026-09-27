library(readr)
library(dplyr)
library(ggplot2)
library(forcats)

d <- read_csv("data/forest_ranking_digitized.csv", show_col_types = FALSE) %>%
  mutate(study_label = fct_rev(fct_inorder(study_label)))

p <- ggplot(d, aes(x = rr, y = study_label)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "grey40") +
  geom_errorbarh(aes(xmin = ci_lower, xmax = ci_upper), height = 0.2) +
  geom_point(aes(size = weight_pct), shape = 15, color = "#2E7D32") +
  scale_x_log10(breaks = c(0.1, 0.2, 0.5, 1, 2, 5, 10)) +
  scale_size_continuous(range = c(2, 6), guide = "none") +
  labs(
    x = "Risk ratio (log scale)",
    y = NULL,
    title = "Digitized reproduction of Figure 4",
    subtitle = "See data/README.md for the Table 1 inconsistency before using this figure"
  ) +
  theme_minimal(base_size = 11)

dir.create("figures/regenerated", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/regenerated/fig4_forest_regenerated.png", p, width = 8, height = 6, dpi = 300)

write_csv(
  d %>% select(study_label, rr, ci_lower, ci_upper, weight_pct, p_score, rank, sucra, sensitivity_flag),
  "figures/regenerated/fig4_ranking_table.csv"
)
