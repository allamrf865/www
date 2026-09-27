library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(forcats)

d <- read_csv("data/netsplit_direct_indirect.csv", show_col_types = FALSE)

bars <- d %>%
  select(comparison, direct_pct, indirect_pct) %>%
  pivot_longer(-comparison, names_to = "evidence", values_to = "pct") %>%
  mutate(
    evidence = recode(evidence, direct_pct = "direct", indirect_pct = "indirect"),
    comparison = fct_inorder(comparison)
  )

p_bar <- ggplot(bars, aes(x = pct, y = comparison, fill = evidence)) +
  geom_col(width = 0.7) +
  geom_text(aes(label = paste0(pct, "%")), position = position_stack(vjust = 0.5), size = 3) +
  scale_fill_manual(values = c(direct = "#F5A623", indirect = "#A9C9E8")) +
  labs(x = "Percentage", y = NULL, fill = "Evidence",
       title = "Direct evidence proportion for each network estimate") +
  theme_minimal(base_size = 11)

p_parallelism <- ggplot(d, aes(x = minimal_parallelism, y = fct_inorder(comparison))) +
  geom_point() +
  geom_vline(xintercept = 2, color = "steelblue") +
  labs(x = "Minimal parallelism", y = NULL) +
  theme_minimal(base_size = 11)

p_path_length <- ggplot(d, aes(x = mean_path_length, y = fct_inorder(comparison))) +
  geom_point() +
  geom_vline(xintercept = 2, color = "steelblue") +
  labs(x = "Mean path length", y = NULL) +
  theme_minimal(base_size = 11)

dir.create("figures/regenerated", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/regenerated/fig3a_direct_indirect_share.png", p_bar, width = 8, height = 4, dpi = 300)
ggsave("figures/regenerated/fig3b_minimal_parallelism.png", p_parallelism, width = 5, height = 4, dpi = 300)
ggsave("figures/regenerated/fig3c_mean_path_length.png", p_path_length, width = 5, height = 4, dpi = 300)
