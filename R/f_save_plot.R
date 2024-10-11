library(magrittr)
library(ggplot2)
library(here)


# Function to save a plot as PDF and PNG
# --- creaded in `./analysis/01b_WB_project_pdo_EDA.qmd`
f_save_plot <- function(plot_name, plot_object) {
   # --- plot_object: ggplot object, previously created
   # --- plot_name: character, name of the plot to save
   # Print the plot, save as PDF and PNG
   plot_object %T>%
      print() %T>%
      ggsave(., filename = here("analysis", "output", "figures", paste0(plot_name, ".pdf")),
             # width = 4, height = 2.25, units = "in",
             device = cairo_pdf) %>%
      ggsave(., filename = here("analysis", "output", "figures", paste0(plot_name, ".png")),
             # width = 4, height = 2.25, units = "in",
             type = "cairo", dpi = 300)
}

# Example of using the function
# f_save_plot("proj_wrd_freq", proj_wrd_freq)
