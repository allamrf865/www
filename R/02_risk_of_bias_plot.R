library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)

judgement_colors <- c(
  "Low" = "#4CAF50",
  "Some concerns" = "#FFC107",
  "Moderate" = "#FFC107",
  "Serious" = "#D32F2F",
  "Critical" = "#7B1FA2"
)

plot_traffic_light <- function(df, domain_cols, domain_labels, title) {
  long <- df %>%
    select(study_label, all_of(domain_cols)) %>%
    pivot_longer(-study_label, names_to = "domain", values_to = "judgement") %>%
    mutate(
      domain = factor(domain, levels = domain_cols, labels = domain_labels),
      study_label = fct_rev(fct_inorder(study_label))
    )

  overall <- df %>%
    transmute(study_label = study_label, domain = "Overall", judgement = overall) %>%
    mutate(study_label = factor(study_label, levels = levels(long$study_label)))

  combined <- bind_rows(long, overall) %>%
    mutate(domain = factor(domain, levels = c(domain_labels, "Overall")))

  ggplot(combined, aes(x = domain, y = study_label, fill = judgement)) +
    geom_tile(color = "white", linewidth = 1) +
    geom_point(aes(color = judgement), size = 6, shape = 21, fill = "white", stroke = 1.2) +
    scale_fill_manual(values = judgement_colors, name = "Judgement") +
    scale_color_manual(values = judgement_colors, guide = "none") +
    labs(title = title, x = NULL, y = NULL) +
    theme_minimal(base_size = 11) +
    theme(
      panel.grid = element_blank(),
      axis.text.x = element_text(angle = 0, face = "bold"),
      plot.title = element_text(face = "bold")
    )
}

rob2 <- read_csv("data/risk_of_bias_rob2.csv", show_col_types = FALSE)
robins <- read_csv("data/risk_of_bias_robins_i.csv", show_col_types = FALSE)

p_rob2 <- plot_traffic_light(
  rob2,
  domain_cols = c("D1_randomisation", "D2_deviations", "D3_missing_data",
                   "D4_outcome_measurement", "D5_selective_reporting"),
  domain_labels = c("D1", "D2", "D3", "D4", "D5"),
  title = "Risk of Bias RoB 2.0 (Randomized Trials)"
)

p_robins <- plot_traffic_light(
  robins,
  domain_cols = c("D1_confounding", "D2_selection", "D3_intervention_classification",
                   "D4_deviations", "D5_missing_data", "D6_outcome_measurement",
                   "D7_selective_reporting"),
  domain_labels = c("D1", "D2", "D3", "D4", "D5", "D6", "D7"),
  title = "Risk of Bias ROBINS-I (Nonrandomized Studies)"
)

dir.create("figures/regenerated", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/regenerated/fig2a_rob2_regenerated.png", p_rob2, width = 8, height = 3.2, dpi = 300)
ggsave("figures/regenerated/fig2b_robins_i_regenerated.png", p_robins, width = 8, height = 5.5, dpi = 300)
