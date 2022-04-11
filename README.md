
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Follow the buzzword

[Luisa M. Mimmi](https://luisamimmi.com/) • Independent Consultant

------------------------------------------------------------------------

<!-- [![OSF DOI](https://img.shields.io/badge/OSF-10.17605%2FOSF.IO%2FMTR6X-blue)](https://dx.doi.org/10.17605/OSF.IO/MTR6X) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5715402.svg)](https://doi.org/10.5281/zenodo.5715402) -->

> Luisa M. Mimmi. 2022. [“Follow the
> buzzword,”](https://doi.org/10.1177/0899764020971045) *Journal of
> Human Rights* (forthcoming).

**All this project’s materials are free and open:**

-   [Download the data](#data)
-   [See the analysis notebook
    website](https://lulliter.github.io/slogan/)

![Open data](img/data_large_color.png)  
![Open](img/materials_large_color.png)

## How to build/deploy the site

This project is an `Rmarkdown` websites hosted on `Github Pages` and
accessible here <https://lulliter.github.io/slogan/>. The folder
containing the html files of the website is `./docs/` (this was also
specified in the `_site.yml`)

    #> .
    #> ├── 00_home-lexicon.Rmd
    #> ├── 00_lexicon-gender.Rmd
    #> ├── 00_lexicon-green.Rmd
    #> ├── 01_data-overview.Rmd
    #> ├── 02_descriptive-analysis.Rmd
    #> ├── 03_model-details.Rmd
    #> ├── 03_modeling-choices.Rmd
    #> ├── 04_predictions.Rmd
    #> ├── Makefile
    #> ├── R
    #> │   ├── funs_data-cleaning.R
    #> │   ├── funs_knitting.R
    #> │   ├── funs_notebook.R
    #> │   ├── models_analysis.R
    #> │   ├── models_details.R
    #> │   ├── models_lhr.R
    #> │   ├── models_pts.R
    #> │   └── psyteachr_setup.R
    #> ├── README.Rmd
    #> ├── README.html
    #> ├── README.md
    #> ├── _build_deploy.sh
    #> ├── _site.yml
    #> ├── _slogan.bib
    #> ├── buzzwords.bib
    #> ├── data
    #> │   ├── DO-NOT-EDIT-ANY-FILES-IN-HERE-BY-HAND
    #> │   ├── derived_data
    #> │   └── raw_data
    #> ├── docs
    #> │   ├── 00_home-lexicon.html
    #> │   ├── 00_lexicon-gender.html
    #> │   ├── 00_lexicon-green.html
    #> │   ├── 01_data-overview.html
    #> │   ├── 02_descriptive-analysis.html
    #> │   ├── 03_model-details.html
    #> │   ├── 03_modeling-choices.html
    #> │   ├── 04_predictions.html
    #> │   ├── R
    #> │   ├── README.html
    #> │   ├── data
    #> │   ├── html
    #> │   ├── img
    #> │   ├── index.html
    #> │   └── site_libs
    #> ├── html
    #> │   ├── fixes.css
    #> │   └── footer.html
    #> ├── img
    #> │   ├── data_large_color.png
    #> │   └── materials_large_color.png
    #> ├── index.Rmd
    #> └── slogan.Rproj

Upon making changes in the local folder, I have 2 ways in which I can
commit and push changes to GitHub (as well as update public version of
website on GitHub Pages)

1.  Pseudo manual **shell** commands in `_build_deploy.sh` file

-   Here I can also decide whether to use `git add -u` (only stuff
    already tracked) or `git add --A` (also new stuff)

2.  Using automated **make** instructions in `Makefile`  

-   Here I have set it up exclusively with `git add -u`

------------------------------------------------------------------------

## Acknowledgements

**RMarkdown Website Instructions**
[here](https://psyteachr.github.io/hack-your-data/rmarkdown_2.html)
<https://gist.github.com/cobyism/4730490>

**Gh pages from subtree 1**
[here](https://gist.github.com/cobyism/4730490) **and 2**
[here](https://sangsoonam.github.io/2019/02/08/using-git-worktree-to-deploy-github-pages.html)

## Abstract

bla bla bla

------------------------------------------------------------------------

<!-- This repository contains the data and code for our paper. Our pre-print is online here: -->
<!-- > Luisa M. Mimmi. 2022. "Follow the buzzword"". Accessed April 11, 2022. Online at <https://dx.doi.org/10.17605/OSF.IO/MTR6X> -->

## Data

<div style="color:#FF4136">

cccccc

</div>

## Licenses

**Text and figures:** All prose and images are licensed under Creative
Commons ([CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/))

**Code:** All code is licensed under the [MIT License](LICENSE.md).

## Contributions
