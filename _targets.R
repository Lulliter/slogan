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


# PIPELINE ----------------
## each target has a name and an R function to run
list(
   # RAW DATA INPUT ----------------
   tar_target(
      data_file,
      here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"),
      format = "file"),
   tar_target(
      data,
      read_excel(data_file, col_names = TRUE, skip = 2)),

   # ANALYSIS FILES ----------------
   ## Process and clean data ----
   tar_target(
      prep_report,
      {
         # Use `data` directly in the target to ensure dependency tracking
         quarto::quarto_render(
            here::here("analysis", "01a_WB_project_pdo_prep.qmd"),
            execute_params = list(data = data)  # Pass data as a parameter if used in the report
         )
      },
      format = "file"),

   ## ----- 🔴 OUTPUTs from  `prep_report` ----
   ### ___ Define target for projs_train.rds ----
   tar_target(
      projs_train,
      here::here("data", "derived_data", "projs_train.rds"),
      format = "file"
   ),

   ### ___ Define target for pdo_train_t.rds ----
   tar_target(
      pdo_train_t,
      here::here("data", "derived_data", "pdo_train_t.rds"),
      format = "file"
   ),


   ## Exploratory data analysis ----
   tar_target(
      eda_report,
      {
         # Just reference the file paths to signal dependency without loading them
         projs_train
         pdo_train_t

         # Render the EDA report
         quarto::quarto_render(here::here("analysis", "01b_WB_project_pdo_EDA.qmd"))
      },
      format = "file"
   ),
   ## ML Feature Classification ----
   tar_target(
      feat_class_report,
      quarto::quarto_render(here::here("analysis", "01c_WB_project_pdo_feat_class.qmd")),
      format = "file"
   ),

   # Combine ALL ANALYSIS reports  ----
   tar_target(
      analysis_reports,
      c(prep_report, eda_report, feat_class_report)),

   # POST page (resulting from above) ----
   tar_target(
      post_page,
      {# Reference analysis_reports to create dependency
         analysis_reports
         quarto::quarto_render(here::here("posts", "PDO_eda.qmd"))
      },
      format = "file"),


   # OTHER INDEPENDENT PAGES  -------
   ## Index page (root)----
   tar_target(
      index_page,
      quarto::quarto_render(here::here("index.qmd")),
      format = "file"),
   ## Hypotheses page ----
   tar_target(
      research_page,
      quarto::quarto_render(here::here("research","hypotheses.qmd")),
      format = "file"),

   # Combine ALL WEB PAGES (root-level and analysis) -------
   tar_target(
      all_pages,
      c(analysis_reports, index_page, research_page, post_page)),

   # Copy all rendered pages to docs/ directory -------
   tar_target(
      render_website,
      {
         # Ensure the docs/ directory exists
         dir.create(here::here("docs"), showWarnings = FALSE)

         # Copy each page to docs/
         walk(all_pages, ~ file.copy(.x, here::here("docs"), overwrite = TRUE))
      },
      #cue = tar_cue(mode = "always") # Always re-render the website when this target is called
      cue = tar_cue(depend = TRUE) ) # setting will trigger render_website only if one of its direct dependencies changes

)

