# ------ Function to count total_rows | n_distinct | n_missing in a subset of columns -----
f_recap_values <- function(data, columns) {
   # Step 1: Select the subset of columns
   df_subset <- data %>% select(all_of(columns))
   # Step 2: Get the number of rows in the dataset
   total_rows <- nrow(df_subset)
   # Step 3: Use skimr to skim the data
   skimmed <- skim(df_subset)

   # Step 4: Calculate the number of distinct values for each column
      # N_distinct works on individual cols (no df) so I need to calc for each column
      # separately using across() and store it in a long format dataframe (distinct_counts).
   distinct_counts <- df_subset %>%
      # returns in 1 row the number of distinct values for each column ---
      summarise(across(everything(), n_distinct)) %>%
      # reshape the data in long format | 1 col
      pivot_longer(everything(), names_to = "skim_variable", values_to = "n_distinct")

   # Step 5: Extract the relevant columns for column names, missing values, and distinct counts
   missing_table <- skimmed %>%
      select(skim_variable, n_missing) %>%
      # Add the total number of rows
      mutate(total_rows = total_rows) %>%
      # Join with distinct counts
      left_join(distinct_counts, by = "skim_variable") %>%
      relocate(n_distinct, n_missing, .after = total_rows) %>%
      mutate(missing_perc = round((n_missing/total_rows)*100, 1),
             missing_perc = glue::glue("{missing_perc}%")) %>%
      arrange(desc(n_distinct))

   # Return the table
   return(missing_table)
}

# ------ Example use  -----
#f_recap_values(df, c("col1","col2"))
