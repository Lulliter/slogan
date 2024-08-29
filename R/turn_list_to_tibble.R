library(here)
library(tibble)
library(tidyverse)


# FUNCTION: to turn a list item into df column   --------------------------
turn_list_to_tibble <- function(list, where, item_name ) {
  # 1) Prepare empty ouppt
  item_l <- list(mode = "character", length = length(list))
  item_v <- vector(mode = "character", length = length(list))
  # 2)  loop to get the items as list, then vector
  for(i in seq_along(list)) {
    # extract ALL items LIST LIST
    if (where == "meta") {
      item_l[[i]] <- list[[i]][["metadata"]][["dc"]][[item_name]]
    } else if ( where == "header"){
      item_l[[i]] <- list[[i]][["header"]][["identifier"]]
    }
    # transform list in vector
    item_v[[i]] <- unlist(item_l[[i]])
  }
  # 3) give desired name to column name to
  column_name <- paste0("doc_mt_", item_name)
  # 4) transform vector in tibble
  item_t <- as_tibble_col(item_v, column_name =column_name)

}

 # # ------------- USE FUNCTION  (called INSIDE THE `assign`) ----------
 # source(here::here("R", "toy_nested_list.R"))
 #
 # ## input
 # list <- n_l
 # item_name <- "date"
 # where <- "meta"
 # df_name <- paste("col",   item_name, sep = "_")
 # ## function call (that changes the name of output on the fly )
 # # tunr_list_to_tibble(list, where, item_name )
 # assign(df_name, value = tunr_list_to_tibble(list, where, item_name ))
 #






















