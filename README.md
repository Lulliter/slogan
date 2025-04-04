

<!-- README.md is generated from README.qmd. Please edit that file -->

# CORE files

``` bash
tree analysis -C -L 2 # then https://carbon.now.sh/
 
 #or 
#tree -n  --noreport analysis  -L 2 | silicon --language bash -o images/tree.png
```

<img src="images/tree.png" style="width:50.0%" alt="tree" />

# TO DO

- Access all tidy tuesday port for week 12 2025
  [bluesky](https://bsky.app/search?q=week+12+%23tidytuesday)
- Read:
  - [R pckg to use LLm to summarize from
    PDF](https://posit.co/blog/mall-ai-powered-text-analysis/)
  - [Tidy tuesday on TExt
    analytics](https://github.com/rfordatascience/tidytuesday/blob/main/data/2025/2025-03-25/readme.md)
    - [spiega](https://gregoryvdvinne.github.io/Text-Mining-Amazon-Budgets.html)
- creare branch con e senza la parte dei dati ?
- fare una pagina con `targets::tar_visnetwork()` e la tabella
  `data/pprovenance.md`

### In `analysis/01a_WB_project_pdo_prep.qmd`

- I added fresh (2025) info on sector theme etc (attached to 2024 proj
  list).. see what can be done with it
- revise the OLD plot -\> NEW plot thing

### In `analysis/01b_WB_project_pdo_EDA.qmd`

- revise the OLD plot -\> NEW plot thing

### In `analysis/01c_WB_project_pdo_prep.qmd`

- tutto da rivedere ….
- Study the theory of Lasso Regr and Classification with ML on Gabor’s
  book
  - BOOK chp 14[Prediction with
    LASSO](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture22-lasso)
  - [lelc 25 class
    ML](https://github.com/gabors-data-analysis/da-coding-rstats/tree/main/lecture25-classification-wML)
- re-write the attempted models in more condensed form
- tell in plain English the choices available for improving ML pred
  perormance (even if not run)
  - defining data / sample for analysis (preprocessing)
  - defining/label engineering of y
  - feature engineering of x (dealing with missing data %, what x and in
    what functional form)
  - model selection
  - model hyperparameters tuning

<!-- 
# + mandare a 
#    + tipo di Data ninja
#    + tipo Vincenzo
#    + gianni  
#    + michele MD a DC 
-->

# Abstract

## Exploring World Bank Project Development Objectives (PDO) text data

This ongoing project serves as a proof-of-concept for applying text
analytics to World Bank Projects & Operations data. Focusing on ~4,000
projects, I analyze the short texts that define *Project Development
Objectives (PDOs)*—concise summaries of each project’s goals. This
exploration has uncovered intriguing insights, including:

- Trends in sector-specific language and thematic shifts over time,  
- Unexpected patterns, such as recurring topics, phrases and conceptual
  relationships,  
- Enhanced text classification and metadata tagging through machine
  learning,  
- Novel text-based questions that could inform further research.

The analysis is conducted in R, integrating text mining, natural
language processing, and machine learning techniques.

(This is an ongoing project, so comments, questions, and suggestions are
welcome. The R source code is open, albeit not very polished).
