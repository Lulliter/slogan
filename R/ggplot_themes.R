
# --- THEME ----
# Pckgs -------------------------------------
if (!require ("pacman")) (install.packages("pacman"))

#p_install_gh("luisDVA/annotater")
#p_install_gh("HumanitiesDataAnalysis/hathidy")
# devtools::install_github("HumanitiesDataAnalysis/HumanitiesDataAnalysis")
pacman::p_load(here,
               magrittr,
               ggplot2,
               sysfonts, showtext
               )

#ggplot2::theme_set(theme_minimal())


# Add custom fonts & make custom theme for ggplot2 -----
#sysfonts::font_add_google(name = "Roboto Condensed", family =  "Condensed")
sysfonts::font_add(family = "Roboto Condensed", regular =  "~/Applications/Roboto_Condensed/RobotoCondensed-Regular.ttf")


# from AH course here: https://datavizs21.classes.andrewheiss.com/example/05-example/
my_theme <-
  theme_minimal( base_family = "Roboto Condensed"#, base_size = 12
                 ) +

  theme(
    panel.grid.minor = element_blank(),
    # Bold, bigger title
    plot.title = element_text(face = "bold"),#, size = rel(1.7)),#
    # Plain, slightly bigger subtitle that is grey
    plot.subtitle = element_text(face = "plain", color = "grey70"),#, size = rel(1.3) ),
    # Italic, smaller, grey caption that is left-aligned
    plot.caption = element_text(face = "italic", color = "grey70", hjust = 0 #, size = rel(0.7),
    ),
    # Bold legend titles
    legend.title = element_text(face = "bold"),
    # Bold, slightly larger facet titles that are left-aligned for the sake of repetition
    strip.text = element_text(face = "bold", hjust = 0 #, size = rel(1.1)
    ),
    # Bold axis titles
    axis.title = element_text(face = "bold"),
    # Add some space above the x-axis title and make it left-aligned
    axis.title.x = element_text(margin = margin(t = 10), hjust = 0),
    # Add some space to the right of the y-axis title and make it top-aligned
    axis.title.y = element_text(margin = margin(r = 10), hjust = 1),
    # Add a light grey background to the facet titles, with no borders
    strip.background = element_rect(fill = "grey90", color = NA),
    # Add a thin grey border around all the plots to tie in the facet titles
    panel.border = element_rect(color = "grey90", fill = NA)
    )

# color paletts -----
mycolors_gradient <- c("#ccf6fa", "#80e8f3", "#33d9eb", "#00d0e6", "#0092a1")
mycolors_contrast <- c("#E7B800", "#a19100", "#0084e6","#005ca1", "#e60066" )

# put the elements in a list ----
my_theme_contr <- list(my_theme, scale_color_manual(values = mycolors_contrast), scale_fill_manual(values = mycolors_contrast))

my_theme_grad <- list(my_theme, scale_color_manual(values = mycolors_gradient), scale_fill_manual(values = mycolors_gradient))

