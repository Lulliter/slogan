# Load the targets package
library(targets)
library(quarto)
library(readxl)
library(here)

# Define your targets
list(
  tar_target(
    raw_data,
    read_excel(here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"), col_names = FALSE, skip = 1)
  ),
  tar_target(
    column_names,
    read_excel(here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"), col_names = FALSE, skip = 1, n_max = 2)
  ),
  tar_target(
    full_data,
    read_excel(here::here("data", "raw_data", "project2", "all_projects_as_of29ago2024.xls"))
  ),
  # QMD notebookes _01a_... 
  tar_target(
    prep_report,
    quarto::quarto_render("analysis/01a_WB_project_pdo_prep.qmd")
  ),
  # QMD notebookes 01b_... 
  tar_target(
    eda_report,
    quarto::quarto_render("analysis/01b_WB_project_pdo_EDA.qmd")#,
    #output_dir = "docs"
  ) , 
# QMD notebookes _01c_... 
  tar_target(
    feat_class_report,
    quarto::quarto_render("analysis/01c_WB_project_pdo_feat_class.qmd")
  )

)