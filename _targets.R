# Load the targets package
library(here)
# install.packages("igraph", type = "binary") https://r.igraph.org/articles/installation-troubleshooting.html
# install.packages("tarchetypes")
library(igraph)
library(targets)
library(tarchetypes)
library(quarto)
library(readxl)
library(purrr)  # For walk function

# --- from 01a_WB_project_pdo_prep.qmd
#source(here("R","f_recap_values.R"))
# --- from 01b_WB_project_pdo_EDA.qmd
#source(here("R","fs_plotting.R"))

# This hardcodes the absolute path in _targets.yaml, so to make this more
# portable, we rewrite it every time this pipeline is run (and we don't track
# _targets.yaml with git)
tar_config_set(
   store = here::here("_targets"),
   script = here::here("_targets.R")
)


# Define your targets
list(
   # DATA INPUT ----------------
   tar_target(
      data.file,
      here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"),
      format = "file"
   ),
   tar_target(
      data,
      read_excel(data.file, col_names = TRUE, skip = 2)
   ),

   # Render specific analysis/*.qmd files ------------
   tar_target(
      prep_report,
      quarto::quarto_render(here::here("analysis", "01a_WB_project_pdo_prep.qmd")),
      format = "file"
   ),
   tar_target(
      eda_report,
      quarto::quarto_render(here::here("analysis", "01b_WB_project_pdo_EDA.qmd")),
      format = "file"
   ),
   tar_target(
      feat_class_report,
      quarto::quarto_render(here::here("analysis", "01c_WB_project_pdo_feat_class.qmd")),
      format = "file"
   ),
   # Combine analysis reports into a list using tar_combine
   tar_target(
      analysis_reports,
      c(prep_report, eda_report, feat_class_report),  # Combine manually
      format = "file"
   ),

   # Render root-level .qmd pages separately -------
   tar_target(
      index_page,
      quarto::quarto_render(here::here("index.qmd")),
      format = "file"
   ),
   tar_target(
      research_page,
      quarto::quarto_render(here::here("research","hypotheses.qmd")),
      format = "file"
   ),
   tar_target(
      post_page,
      quarto::quarto_render(here::here("posts", "PDO_eda.qmd")),
      format = "file"
   ),

   # Combine all pages (root-level and analysis) into a list -------
   tar_target(
      all_pages,
      c(prep_report, eda_report, feat_class_report, index_page, research_page, post_page),
      format = "file"
   ),

   # Copy all rendered pages to docs/ directory -------
   tar_target(
      render_website,
      {
         # Ensure the docs/ directory exists
         dir.create(here::here("docs"), showWarnings = FALSE)

         # Copy each page to docs/
         walk(all_pages, ~ file.copy(.x, here::here("docs"), overwrite = TRUE))
      },
      cue = tar_cue(mode = "always")
   )
)

