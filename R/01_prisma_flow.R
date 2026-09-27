# Redraws the PRISMA 2020 flow diagram (Figure 1) from data/prisma_flow_counts.csv.
# The counts in that file add up correctly at every stage, so this is a direct,
# verifiable reproduction rather than a guess at layout.

library(readr)
library(dplyr)
library(ggplot2)

counts <- read_csv("data/prisma_flow_counts.csv", show_col_types = FALSE)

get_n <- function(label) counts$n[counts$label == label]

box <- function(xmin, xmax, ymin, ymax, text, fill = "white") {
  list(
    rect = data.frame(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill),
    label = data.frame(x = (xmin + xmax) / 2, y = (ymin + ymax) / 2, text = text)
  )
}

identification_text <- paste0(
  "Records identified through\ndatabase searching (n = ", get_n("Records identified through database searching (total)"), ")\n",
  "- PubMed: ", get_n("PubMed"), "\n",
  "- Scopus: ", get_n("Scopus"), "\n",
  "- Cochrane: ", get_n("Cochrane Library")
)

dedup_text <- paste0("Records after duplicates removed (n = ", get_n("Records after duplicates removed"), ")")
screened_text <- paste0(
  "Records screened (n = ", get_n("Records after duplicates removed"), ")\n",
  "Records excluded (n = ", get_n("Records excluded (not relevant)") + get_n("Records excluded (insufficient data)"), ")"
)
eligibility_text <- paste0(
  "Full-text articles assessed for eligibility\n(n = ", get_n("Full-text articles assessed for eligibility"), ")\n",
  "Full-text articles excluded, with reasons\n(n = ",
  get_n("Excluded - not meeting inclusion criteria") +
    get_n("Excluded - data overlap with other studies") +
    get_n("Excluded - poor study design"), ")"
)
included_text <- paste0(
  "Studies included in qualitative and\nquantitative synthesis (n = ",
  get_n("Studies included in qualitative and quantitative synthesis"), ")"
)

screen_excl_text <- paste0(
  "Not relevant: ", get_n("Records excluded (not relevant)"), "\n",
  "Insufficient data: ", get_n("Records excluded (insufficient data)")
)

eligibility_excl_text <- paste0(
  "- Not meeting inclusion criteria: ", get_n("Excluded - not meeting inclusion criteria"), "\n",
  "- Data overlap with other studies: ", get_n("Excluded - data overlap with other studies"), "\n",
  "- Poor study design: ", get_n("Excluded - poor study design")
)

boxes <- list(
  box(0, 10, 24, 30, identification_text),
  box(0, 10, 19, 22, dedup_text),
  box(0, 10, 14, 17, screened_text),
  box(0, 10, 9, 12, eligibility_text),
  box(0, 10, 3, 6, included_text),
  box(12, 20, 27, 30, screen_excl_text),
  box(12, 20, 8, 18, eligibility_excl_text)
)

rects <- do.call(rbind, lapply(boxes, function(b) b$rect))
labels <- do.call(rbind, lapply(boxes, function(b) b$label))

arrows <- data.frame(
  x = c(5, 5, 5, 5, 10, 10),
  xend = c(5, 5, 5, 5, 12, 12),
  y = c(24, 19, 14, 9, 28.5, 13),
  yend = c(22, 17, 12, 6, 28.5, 13)
)

p <- ggplot() +
  geom_rect(data = rects, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            fill = "white", color = "black") +
  geom_text(data = labels, aes(x = x, y = y, label = text), size = 3.1, lineheight = 0.95) +
  geom_segment(data = arrows, aes(x = x, xend = xend, y = y, yend = yend),
               arrow = arrow(length = unit(0.15, "cm")), linewidth = 0.4) +
  coord_cartesian(xlim = c(-4, 21), ylim = c(1, 31)) +
  annotate("text", x = -3, y = 27, label = "Identification", angle = 90, size = 3.5) +
  annotate("text", x = -3, y = 15.5, label = "Screening", angle = 90, size = 3.5) +
  annotate("text", x = -3, y = 10.5, label = "Eligibility", angle = 90, size = 3.5) +
  annotate("text", x = -3, y = 4.5, label = "Included", angle = 90, size = 3.5) +
  theme_void()

dir.create("figures/regenerated", showWarnings = FALSE, recursive = TRUE)
ggsave("figures/regenerated/fig1_prisma_regenerated.png", p, width = 9, height = 10, dpi = 300)
