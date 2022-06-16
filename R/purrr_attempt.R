# Here is my tibble
# Imagine I would like to apply a `n_distinct` function with pmap on it every rows

df <-  tibble(id = c("01", "02", "03","04","05","06"),
              A = c("Jan", "Mar", "Jan","Jan","Jan","Mar"),
              B = c("Feb", "Mar", "Jan","Jan","Mar","Mar"),
              C = c("Feb", "Mar", "Feb","Jan","Feb","Feb")
)
df
# It is perfectly achievable with `rowwise` and `mutate` and results in my desired output

df %>%
  rowwise() %>%
  mutate(overal = n_distinct(c_across(A:C)))

# But with `pmap` it won't.
df %>%
  select(-id) %>%
  mutate(overal = pmap_dbl(list(A, B, C), n_distinct))


df %>%
  select(-id) %>%
  mutate(overal = pmap_dbl(list(A, B, C), ~ n_distinct(c(...))))
