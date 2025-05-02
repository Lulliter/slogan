# SET UP ------------------------------------------------------------------

# Load the targets package
library(here)
# install.packages("igraph", type = "binary") https://r.igraph.org/articles/installation-troubleshooting.html
# install.packages("tarchetypes")
library(igraph)
library(targets)
library(tarchetypes)
library(tidyverse)
library(quarto)
library(readxl)
library(purrr)  # For walk function


tar_option_set(
   packages = c("readxl", "janitor", "dplyr", "purrr", "here", "quarto"),
   format = "rds"
)

tar_source(here::here("R", "f_recap_values.R"))
tar_source(here::here("R", "f_parse_date.R"))

# This hardcodes the absolute path in _targets.yaml, so to make this more
# portable, we rewrite it every time this pipeline is run (and we don't track
# _targets.yaml with git)
tar_config_set(
   store = here::here("_targets"),
   script = here::here("_targets.R"))


# PIPELINE ----------------
list(
   # RAW DATA INPUT ----------------
   # Load the raw data from older XLS file
   tar_target(
      all_proj,
      readxl::read_excel(
         here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"),
         col_names = FALSE,
         skip = 1
      )
   ),
   # Load World Bank Projects sheet (March 2025)
   tar_target(
      all_proj_25,
      readxl::read_excel(
         here::here("data", "raw_data", "project3", "all_projects_as_of31mar2025.xlsx"),
         sheet = "World Bank Projects",
         skip = 1
      ) %>%
         janitor::clean_names() %>%
         filter(project_id %in% all_proj$id)
   ),
   # Load Themes sheet
   tar_target(
      all_proj_themes_25_l,
      readxl::read_excel(
         here::here("data", "raw_data", "project3", "all_projects_as_of31mar2025.xlsx"),
         sheet = "Themes",
         skip = 1
      ) %>%
         janitor::clean_names() %>%
         filter(project_id %in% all_proj$id)
   ),
   # Load Sectors sheet
   tar_target(
      all_proj_sectors_25_l,
      readxl::read_excel(
         here::here("data", "raw_data", "project3", "all_projects_as_of31mar2025.xlsx"),
         sheet = "Sectors",
         skip = 1
      ) %>%
         janitor::clean_names() %>%
         filter(project_id %in% all_proj$id)
   ),
   # Load GEO Locations sheet
   tar_target(
      all_proj_geo_25,
      readxl::read_excel(
         here::here("data", "raw_data", "project3", "all_projects_as_of31mar2025.xlsx"),
         sheet = "GEO Locations",
         skip = 1
      ) %>%
         janitor::clean_names() %>%
         filter(project_id %in% all_proj$id)
   ),
   # Load Financiers sheet
   tar_target(
      all_proj_financiers_25_l,
      readxl::read_excel(
         here::here("data", "raw_data", "project3", "all_projects_as_of31mar2025.xlsx"),
         sheet = "Financers",
         skip = 1
      ) %>%
         janitor::clean_names() %>%
         filter(project %in% all_proj$id) %>%
         rename(project_id = project)
   ),
   # wrd data from OLD SLOGAN PROJECT
   tar_target(
      wdr,
      here::here("data", "derived_data", "wdr.rds"),
      format = "file"),




   # ANALYSIS FILES ----------------
   ## 1) Process and clean data ----
 tar_target(
      prep_report,
      {
         quarto::quarto_render(
            here::here("analysis", "01a_WB_project_pdo_prep.qmd"),
            execute_params = list(
               all_proj = all_proj,
               all_proj_25 = all_proj_25,
               all_proj_themes_25_l = all_proj_themes_25_l,
               all_proj_sectors_25_l = all_proj_sectors_25_l
            )
         )
      },
      format = "file"
   ),

   ## OUTPUTs from `prep_report` ----
   ### ___ projs_train.rds ----
   tar_target(
      projs_train,
      {
         # Ensure dependency on `prep_report`
         prep_report
         return(here::here("data", "derived_data", "projs_train.rds"))
      },
      format = "file"),
   ### ___ pdo_train_t.rds ----
   tar_target(
      pdo_train_t,
      {
         # Ensure dependency on `prep_report`
         prep_report
         return(here::here("data", "derived_data", "pdo_train_t.rds"))
      },
      format = "file"),
   ### ___ projs_val.rds [NOT really used yet!] ----
   tar_target(
      projs_val,
      {
         prep_report
         here::here("data", "derived_data", "projs_val.rds")
      },
      format = "file"
   ),

   ### ___ proj_test.rds [NOT really used yet!] ----
   tar_target(
      proj_test,
      {
         prep_report
         here::here("data", "derived_data", "proj_test.rds")
      },
      format = "file"
   ),
   ### ___ intermediate file  ----
   tar_target(
      tracking,
      {
         prep_report
         here::here("data", "derived_data", "tracking.rds")
      },
      format = "file"
   ),

   # [------------------]-------------

   ## 2) Exploratory data analysis ----
 tar_target(
    eda_report,
    {
       # Establish dependencies so changes in these files trigger re-rendering:
       projs_train
       pdo_train_t
       # Render the EDA report and pass file paths as parameters
       quarto::quarto_render(
          here::here("analysis", "01b_WB_project_pdo_EDA.qmd"),
          execute_params = list(
             projs_train = projs_train,
             pdo_train_t = pdo_train_t
          )
       )
    },
    format = "file"
 ),
   ## OUTPUTs from  `eda_report` ----
   ### ___ projs_train2.rds ----
 tar_target(
    projs_train2, # Ensure dependency on `eda_report`
    {eda_report
       here::here("data", "derived_data", "projs_train2.rds")
    },
    format = "file"),


 tar_target(
      custom_stop_words, # Ensure dependency on `eda_report`
      {eda_report
         here::here("data", "derived_data", "custom_stop_words.rds")
      },
      format = "file"),

   ### ___ custom_stop_words_df.rds ----
   tar_target(
      custom_stop_words_df, # Ensure dependency on `eda_report`
      {eda_report
         here::here("data", "derived_data", "custom_stop_words_df.rds")
      },
      format = "file"),

  # [------------------]-------------
   ## 3) ML Feature Classification ----
 tar_target(
    feat_class_report,
    {
       # Declare dependencies so that changes in these files trigger re-rendering:
       projs_train2
       wdr
       custom_stop_words_df
       # Render the feature classification report and pass parameters
       quarto::quarto_render(
          here::here("analysis", "02a_WB_project_pdo_feat_class_envcat.qmd"),
          execute_params = list(
             projs_train = projs_train,
             wdr = wdr,
             custom_stop_words_df = custom_stop_words_df
          )
       )
    },
    format = "file"
 ),
   ## OUTPUTs from  `feat_class_report` ----
   ### ___ custom_stop_words.rds ----
   tar_target(
      wdr2,
      {feat_class_report # Ensure dependency on `feat_class_report`
         feat_class_report
         here::here("data", "derived_data", "wdr2.rds")
      },
      format = "file"),


 # [------------------]-------------
 ## 3.b) ML Feature Classification (multiclass)----
 # .....


   # Combine ALL ANALYSIS reports  ----
   tar_target(
      analysis_reports,
      c(prep_report, eda_report, feat_class_report)),
 # [------------------]-------------
 # [------------------]-------------
# POST page (resulting from above) ----
   tar_target(
      post_page,
      {analysis_reports # Reference analysis_reports to create dependency
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

   # RENDER WEBSITE -------
   ## Copy all rendered pages to docs/ directory
   tar_target(
      render_website,
      {
         # Ensure the docs/ directory exists
         base::dir.create(here::here("docs"), showWarnings = FALSE)

         # Copy each page to docs/
         purrr::walk(all_pages, ~ file.copy(.x, here::here("docs"), overwrite = TRUE))
      },
      #cue = tar_cue(mode = "always") # Always re-render the website when this target is called
      cue = tar_cue(depend = TRUE) ) # setting will trigger render_website only if one of its direct dependencies changes

)

#targets::tar_visnetwork()
