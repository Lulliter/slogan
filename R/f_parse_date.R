library(dplyr)
library(skimr)
library(tidyr)

# ------ Mess of data format weird in different ways in 2 cols:
# 1947-12-31 12:00:00 # closingdate
# 8/3/1948 12:00:00 AM # closingdate
# 1955-03-15T00:00:00Z # boardapprovaldate

# ------ List of possible inconsistent date formats
common_date_formats <- c(
   "ymd HMS", "ymd HM", "ymd",           # ISO: 2023-03-15 12:30:00
   "ymd_HMS", "ymd_HM", "ymd T",         # ISO with underscore/T separator
   "mdy HMS", "mdy HM",                  # U.S. style with AM/PM
   "mdy HMSp",                           # "MM/DD/YYYY HH:MM AM/PM"
   "dmy HMS", "dmy HM",                  # European style
   "Ymd HMS", "BdY IMS p",               # Weird but possible
   "Y-m-d", "m/d/Y", "d/m/Y"             # Fallback basics
)



# ------ Function to parse messy, inconsistent date formats for list of date col -----
f_parse_date <- function(data, date_columns) {
   data %>%
      mutate(across(
         .cols = all_of(date_columns),
         .fns = ~ if_else(
            .x == "" | is.na(.x),
            as.POSIXct(NA),
            parse_date_time(.x, orders = common_date_formats)
         )
      ))
}

# ------ Example use  -----
# date_columns_exe <- c("closingdate", "boardapprovaldate")
# f_parse_date(data = all_proj_t, date_columns = date_columns_exe)
