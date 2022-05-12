# TOY EXAMLPLE of Nested List  --------------------------------------------
n_l <- list(
  doc1 = list (header = list ("bla1a", "bla1b"),
               metadata = list(dc = list (date = "2021",
                                          title = "Title 1")
               )
  ),
  doc2 = list (header = list ("bla2a", "bla21b"),
               metadata = list(dc = list (date = "2022",
                                          title = "Title 2")
               )
  ),
  doc3 = list (header = list  ("bla3a", "bla3b"),
               metadata = list(dc = list (date = "2023",
                                          title = "Title 3")
               )
  )
)

# str(n_l)
