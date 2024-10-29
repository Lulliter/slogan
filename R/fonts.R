# 0) --- Go to Google and "GEt Font" + "Download" + "Install" the font
# https://fonts.google.com/specimen/Roboto+Condensed
# --- Move it to  /Library/Fonts/*....ttf

# 1) --- Use loadfonts() with "pdf" on macOS
library(extrafont)
# ---- This will import all system fonts into R, takes a few minutes
# font_import()
# -- quali ho nel sistema
# fonts()
loadfonts(device = "pdf")

# 2) --- Use showtext for More Robust Font Handling
library(showtext)
# --- # Automatically enable text rendering for all plots
showtext_auto()

# 3) --- Add the font to the system
library(sysfonts)
font_add_google("Roboto Condensed", "roboto_condensed")

# 4) --- Set the font as the default for ggplot2
# Who else? https://datavizf24.classes.andrewheiss.com/example/05-example.html
library(ggplot2)
my_pretty_theme <- theme_minimal(base_family = "roboto_condensed", base_size = 12) +
   theme(panel.grid.minor = element_blank(),
         # Bold, bigger title
         plot.title = element_text(face = "bold", size = rel(1.7)),
         # Plain, slightly bigger subtitle that is grey
         plot.subtitle = element_text(face = "plain", size = rel(1.3), color = "grey70"),
         # Italic, smaller, grey caption that is left-aligned
         plot.caption = element_text(face = "italic", size = rel(0.7),
                                     color = "grey70", hjust = 0),
         # Bold legend titles
         legend.title = element_text(face = "bold"),
         # Bold, slightly larger facet titles that are left-aligned for the sake of repetition
         strip.text = element_text(face = "bold", size = rel(1.1), hjust = 0),
         # Bold axis titles
         axis.title = element_text(face = "bold"),
         # Add some space above the x-axis title and make it left-aligned
         axis.title.x = element_text(margin = margin(t = 10), hjust = 0),
         # Add some space to the right of the y-axis title and make it top-aligned
         axis.title.y = element_text(margin = margin(r = 10), hjust = 1),
         # Add a light grey background to the facet titles, with no borders
         strip.background = element_rect(fill = "grey90", color = NA),
         # Add a thin grey border around all the plots to tie in the facet titles
         panel.border = element_rect(color = "grey90", fill = NA))

# use
# ggplot + my_pretty_theme

