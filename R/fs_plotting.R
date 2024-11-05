# FUNCTION to save plot as object  ----------------------------------------
f_save_plot_obj <- function(plot_object, plot_obj_name) {
   # Save the plot object
   saveRDS(plot_object, here("analysis", "output", "figures", paste0(plot_obj_name, ".rds")))
}
# Example of using the function
# f_save_plot_obj("proj_wrd_freq", proj_wrd_freq)
# Dopo
# proj_wrd_freq <- readRDS(file = here ("analysis", "output", "figures", "plot_object.rds"))
# proj_wrd_freq



# f_save_plot <- function(plot_name, plot_object) {
#    # Define plot dimensions and resolution
#    width <- 8         # Width in inches
#    height <- 6        # Height in inches
#    dpi <- 320         # Resolution in DPI
#
#    # Save the plot as PDF
#    ggsave(plot_object,
#           filename = here("analysis", "output", "figures", paste0(plot_name, ".pdf")),
#           device = "pdf", #cairo_pdf,
#           width = width,
#           height = height,
#           units = "in")
#
#    # Save the plot as PNG
#    ggsave(plot_object,
#           filename = here("analysis", "output", "figures", paste0(plot_name, ".png")),
#           # type = "cairo",
#           device = "png",
#           dpi = dpi,      # Set DPI
#           width = width,
#           height = height,
#           units = "in")
# }

# Example of using the function
# f_save_plot("proj_wrd_freq", proj_wrd_freq)

#### --- [FUNC] Plot by sector for PDO and TAG by sector-----
 # Define the plotting function
f_plot_sector_trends <- function(data, sector_name, title = NULL, subtitle = NULL) {
   # Filter data for the specified sector
   sector_data <- data %>% filter(tok_sector_broad == sector_name)

   # Normalize n_pdo and n_tag to range [0, 1] for the selected sector
   sector_data <- sector_data %>%
      mutate(
         n_pdo_norm = (n_pdo - min(n_pdo)) / (max(n_pdo) - min(n_pdo)),
         n_tag_norm = (n_tag - min(n_tag)) / (max(n_tag) - min(n_tag))
      )

   # ---- Calculate Spearman correlation and KS test p-value for the selected sector
   sector_stats <- sector_data %>%
      summarize(
         spearman_cor = cor(n_pdo_norm, n_tag_norm, method = "spearman", use = "complete.obs"),
         ks_p_value = ks.test(n_pdo_norm, n_tag_norm)$p.value,
         similarity = ifelse(ks_p_value > 0.05, "Similar", "Dissimilar")
      )

   # --- Create custom legend title with statistical information
   # custom_legend_title <- paste0(
   #    "Frequency Metrics"#,
   #    #"KS test p-value: ", round(sector_stats$ks_p_value, 4)
   # )
   # Plot with both KS test annotations
   ggplot(sector_data, aes(x = FY_appr)) +
      # ---- (OR) Lighter line plot for normalized n_pdo
      # geom_line(aes(y = n_pdo_norm, color = "n_pdo"), size = 1, alpha = 0.3) +
      # # Points for normalized n_pdo
      # geom_point(aes(y = n_pdo_norm, color = "n_pdo"), size = 4, alpha = 0.5) +

      # ---- (OR) Bar plot for normalized n_pdo with fill in aes() to include in legend
      geom_bar(aes(y = n_pdo_norm, fill = "n_pdo"), stat = "identity", alpha = 0.5) +
      # -----Lighter line plot for normalized n_tag
      geom_line(aes(y = n_tag_norm, color = "n_tag"), size = 1, alpha = 0.3) +
      # -----Points for normalized n_tag
      geom_point(aes(y = n_tag_norm, color = "n_tag"), size = 4) +

      # --- Annotate KS test results directly on the plot
      annotate(
         "text", x = Inf, y = Inf, label = paste("KS test p-value:", round(sector_stats$ks_p_value, 4)),
         hjust = 1.1, vjust = 1.1, color = "black", size = 4
      ) +


      # ---- Set titles, labels, and theme
      labs(
         title = paste0(title, " - ", sector_name),
         subtitle = subtitle,
         x = "",
         y = "",
         fill =  "PDO term frequency",
         color = "Sector label frequency"
      ) +
      # Customize colors for lines and bar fill
      scale_color_manual(
         values = c("n_tag" = "#00689D")
      ) +
      scale_fill_manual(
         values = c("n_pdo" = "#8e550a")
      ) +
      scale_x_continuous(breaks = unique(sector_data$FY_appr)) +
      lulas_theme +
      theme(legend.position = "right",
            axis.text.x = element_text(angle = 45, hjust = 1) )
}
# Usage example for a specific sector
# f_plot_sector_trends(data = sector_broad_combo, sector_name = "WAT_SAN",
#                      title = "Comparing frequency of sector trends over time" ,
#                      subtitle = "\`n_pdo\` = frequency in PDOs text; \`n_tag\` = frequency sector label (normalized values) \nKolmogorov-Smirnov test for similarity between the two trends")


# --- FUNCTION to plot iteratively each sector (like f_plot_sector) ------
f_plot_tag_sector <- function( name_sec){
   # Ensure name_sec is treated as a character
   data_sec <- sector_list[[as.character(name_sec)]]
   #  data_sec <- sector_list[["ENERGY"]]

   data_sec <- data_sec %>%
      group_by(FY_appr)  %>%
      count() %>%
      ungroup() #%>%
   # #mutate(FY_appr = as.Date(FY_appr, format = "%Y-%m-%d"))

   # plot
   ggplot(data = data_sec, aes(x = FY_appr, y = n)) +
      geom_line(color = sector_colors[name_sec], linetype = "dotted", alpha = 0.5, size = 1) +
      geom_point(color = sector_colors[name_sec], size = 3) +
      scale_x_continuous(breaks = seq(2001, 2023, by = 1)) +
      scale_y_continuous(breaks = seq(0, max(data_sec$n), by = 5)) +
      labs(title = name_sec, x = "Year", y = "Number of projects") +
      # custom
      lulas_theme +
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(
         title = paste("\"",name_sec,"\" in tag by fiscal years of approval"),  # Use facet-specific title
         subtitle = "[Using variable \"sector1\"]",
         x = "",
         y = ""  # Remove y-axis label
      )

}

# --- Plot one sector
# name_sec EDUCATION    ENERGY    HEALTH       ICT     MINING_OIL_GAS TRANSPORT    WAT_SAN
# data_sec EX sector_list[["WAT_SAN"]]
# f_plot_tag_sector( name_sec = "WAT_SAN")


# --- FUNCTION to plot iteratively each sector (like f_plot_sector) ----
f_plot_comm_sector <- function( name_sec){
   # --- Get split data postion
   data_sec <- commit_by_sector_list[[as.character(name_sec)]]
   #  data_sec <- commit_by_sector_list[["ENERGY"]]

   # --- Plot
   ggplot(data = data_sec, aes(x = FY_appr)) +
      # --- geom_bar for rel_freq_n_pdo
      geom_bar(aes(y = rel_freq_n_pdo, fill ="PDO term"), stat = "identity", alpha = 0.5) +
      # --- geom_line and geom_point for rel_freq_commitment
      geom_line(aes(y = rel_freq_commitment, color = "$$ committed"), linetype = "dotted", alpha = 0.5, size = 1) +
      geom_point(aes(y = rel_freq_commitment, color = "$$ committed"), size = 3) +
      # --- scale
      scale_x_continuous(breaks = seq(2001, 2023, by = 1)) +
      scale_y_continuous(breaks = seq(0, 75, by = 5)) +
      # Customize colors and set common legend title
      scale_color_manual(
         values = c("$$ committed" = "#00689D") ,
         guide = guide_legend(title = "Relative frequencies")
      ) +
      scale_fill_manual(
         values = c("PDO term" = "#8e550a"),
         guide = guide_legend(title = "")
      ) +
      # custom
      lulas_theme +
      theme(legend.position = "right",
            axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(
         title = paste("PDO term frequency for \"",name_sec,"\" v. $$ committed by FY"),  # Use facet-specific title
         subtitle = "[Distributions of relative frequencies]",
         x = "",
         y = ""
      )

}

# --- Plot one sector
# name_sec EDUCATION    ENERGY    HEALTH       ICT     MINING_OIL_GAS TRANSPORT    WAT_SAN
# data_sec EX sector_list[["WAT_SAN"]]
# f_plot_comm_sector( name_sec = "WAT_SAN")
