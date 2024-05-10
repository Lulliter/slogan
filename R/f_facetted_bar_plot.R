facet_bar <- function(df, y, x, by, nrow = 2, ncol = 2, scales = "free") {
  mapping <- aes(y = reorder_within({{ y }}, {{ x }}, {{ by }}),
                 x = {{ x }},
                 fill = {{ by }})

  facet <- facet_wrap(vars({{ by }}),
                      nrow = nrow,
                      ncol = ncol,
                      scales = scales)

  ggplot(df, mapping = mapping) +
    geom_col(show.legend = FALSE) +
    scale_y_reordered() +
    facet +
    ylab("")
}
