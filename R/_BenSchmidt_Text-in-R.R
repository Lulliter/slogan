# STUDIO TEXT in R  -------------------------------------------------------
# http://benschmidt.org/HDA/texts-as-data.html#subword-tokenization-with-sentencepiece



# Pckgs -------------------------------------
if (!require ("pacman")) (install.packages("pacman"))
#p_install_gh("luisDVA/annotater")
#p_install_gh("HumanitiesDataAnalysis/hathidy")
# devtools::install_github("HumanitiesDataAnalysis/HumanitiesDataAnalysis")
p_load(annotater,
       tidyverse,
       # ggplot2, for data visualisation.
       # dplyr, for data manipulation.
       # tidyr, for data tidying.
       # readr, for data import.
       # purrr, for functional programming.
       # tibble, for tibbles, a modern re-imagining of data frames.
       # stringr, for strings.
       # forcats, for factors.
       here,
       skimr,
       httr,
       jsonlite,
       XML,
       xml2,
       oai, # R client to work with OAI-PMH
       citr
)

p_load(
  tidytext, # Text Mining using 'dplyr', 'ggplot2', and Other Tidy Tools
  sjmisc, # Data and Variable Transformation Functions
  ggraph, # An Implementation of Grammar of Graphics for Graphs and Networks
  widyr, # Widen, Process, then Re-Tidy Data
  SnowballC, # Snowball Stemmers Based on the C 'libstemmer' UTF-8 Library
  HumanitiesDataAnalysis, # Data and Code for Teaching Humanities Data Analysis
  sentencepiece # Text Tokenization using Byte Pair Encoding and Unigram Modelling
  )

# Reading Text of State of Union into r -----------------------------------------------------
HumanitiesDataAnalysis::extract_SOTUs() # creates "SOTUS" dir in ./
# read in A text as a series of lines
text  <- readr::read_lines("SOTUS/2019.txt") # Read/write lines to/from a file
text %>% head(3)
str(text) # A character vector with one element for each line.
# chr [1:128]

# Tokenization [= Breaking a piece of text into words] ---------------------------------------
# --- modo 1) --> returns: NOT df
text %>%
  str_split("[^A-Za-z]") %>%
  head(2)
str(text) # chr [1:128] each paragraph is nested


## Tokenization [tidytext] -------------------------------------------------
# --- modo 2) --> returns: df!
# turn SOTU text to tibble
SOTU  <- tibble(text = text)
SOTU %>% head
str(SOTU) # tibble [128 × 1]

# tokenize with {tidytext}
tidied <- SOTU %>%
  unnest_tokens(word, text)

## Wordcounts/plots --------------------------------------------------------

# Count words
wordcounts <- tidied %>%
  group_by(word) %>%
  summarize(n = n()) %>%
  arrange(-n)

wordcounts %>% head(5)
# plot
wordcounts <- wordcounts %>%
  mutate(rank = rank(-n)) %>%
  filter(n > 2, word != "")
ggplot(wordcounts) + aes(x = rank, y = n, label = word) + geom_text() # ugly!!!

# Putting logarithmic scales on both axes reveals something interesting about the way that data is structured; this turns into a straight line.
ggplot(wordcounts) +
  aes(x = rank, y = n, label = word) +
  geom_point(alpha = .3, color = "grey") +
  geom_text(check_overlap = TRUE) +
  scale_x_continuous(trans = "log") +
  scale_y_continuous(trans = "log") +
  labs(title = "Zipf's Law",
       subtitle="The log-frequency of a term is inversely correlated with the logarithm of its rank.")
# ...the logarithm of rank decreases linearly with the logarithm of count
# This is “Zipf’s law:” the phenomenon means that the most common word is twice as common as the second most common word, three times as common as the third most common word, four times as common as the fourth most common word, and so forth.


## Concordances !!!------------------------------------------------------------
# NB: dplyr includes lag and lead functions that let you combine the next element. You specify by how many positions you want a vector to “lag” or “lead” another one, and the two elements are offset against each other by one. like
tibble(number = c(1, 2, 3, 4, 5)) %>%
  mutate(lag = lag(number, 1)) %>%
  mutate(lead = lead(number, 2))

# align one series of text with the words that follow...
twoColumns <- tidied %>%
  mutate(word2 = lead(word, 1))
head(twoColumns)
# By grouping on both words, we can use that to count bigrams:
twoColumns %>%
  group_by(word, word2) %>%
  summarize(count = n()) %>%
  arrange(-count) %>%
  head(10)
## `summarise()` has grouped output by 'word'. You can override using the `.groups` argument.

# Doing this several times gives us snippets of the text we can read across as well as down.
multiColumn <- tidied %>%
  mutate(word2 = lead(word, 1),
         word3 = lead(word, 2),
         word4 = lead(word, 3),
         word5 = lead(word, 4))

multiColumn %>% count(word, word2, word3, word4, word5) %>%
  arrange(-n) %>%
  head(5)

# Using filter, we can see the context for just one particular word. This is a concordance, which lets you look at any word in context.
multiColumn %>% filter(word3 == "immigration")


# Function... ---------------------------------------------------

# create a function to read and organize lines of text from 1 file
readSOTU = function(filename) {
  # reads lines from a (txt/doc) file
  readr::read_lines(filename) %>%
    # makes it a tibble where each line is a row
    tibble(text = .) %>%
    filter(text != "") %>%
    ## Add a counter for the paragraph number
    mutate(paragraph = 1:n()) %>%
    unnest_tokens(word, text) %>%
    # clean up the file name to get only the year
    mutate(filename = filename %>%
             str_replace(".*/", "") %>%
             str_replace(".txt", "")
    )
}

# call function on 1 item ---------------------------------------------------
# call my f on 1 specific file
SOTU_1899 <- readSOTU("SOTUS/1899.txt")
# it returns:
str(SOTU_1899)
# tibble [22,906 × 3] (S3: tbl_df/tbl/data.frame)
# $ paragraph: int [1:22906] 1 2 2 2 2 2 2 2 3 3 ...
# $ word     : chr [1:22906] "none" "to" "the" "senate" ...
# $ filename : chr [1:22906] "1899" "1899" "1899" "1899" ...

SOTU_1899 %>%
  slice(1:50)

# Function iterated ---------------------------------------------------
# need to know all the names of the files!
all_files <-  list.files("SOTUS", full.names = T)
# ... or smaller
some_files <- all_files[c(1:50)]

## --- a) for loop WAY ---------------------------------------------------
SOTUs_some_loop <- tibble() # prep empty tibble
for (fname in some_files) {
  SOTUs_some_loop = rbind(SOTUs_some_loop, # Combine R Objects by Row
                     readSOTU(fname) # after calling func on each text file
                     )
}
str(SOTUs_some_loop)

## --- a) purrr WAY ---------------------------------------------------
# it takes as an argument a list and a function, and applies the function to each element of the list.
# map_dfr returns a dataframe
SOTUs_some <- some_files %>%
  map_dfr(readSOTU)
str(SOTUs_some)

skimr::n_unique(SOTUs_some$filename)
skimr::n_unique(SOTUs_some$word)

# plot
SOTUs_some %>%
  group_by(filename) %>%
  summarize(count = n()) %>% # N of "entries" == words
  ggplot() + geom_line() + aes(x = filename %>% as.numeric(), y = count) +
  labs(title = "Number of words per State of the Union")

# Metadata Joins ----------------------------------------------------------
presidents # presidents {datasets} approval of Presidents
skimr::skim(presidents)

SOTUs_some_join  <-  SOTUs_some %>%
  mutate(year = as.numeric(filename)) %>%
  # join by year
  inner_join(presidents)

# plot 2 see party
SOTUs_some_join %>%  ggplot() +
  geom_bar(aes(x = year, fill = party)) +
  labs("SOTU lengths by year and party")

# plot 2 see whether the speech was written or delivered aloud.
SOTUs_some_join %>%
  group_by(year, sotu_type) %>%
  summarize(`Word Count` = n()) %>%
  ggplot() +
  geom_point(aes(x = year, y = `Word Count`, color = sotu_type))

# Any unique words said by 1 author only? ---------------------------------------
SOTUs_some_join %>%
  mutate(year = as.numeric(filename)) %>%
  # count words by president
  group_by(word, president) %>%
  summarize(count = n()) %>%
  # then find those that had been said only once
  group_by(word) %>%
  filter(n() == 1) %>%
  arrange(-count) %>% head(10)

# { not clear} ---------------------------------------------------
# Subwords tokenization ---------------------------------------------------
# “Sentencepiece” is one of several strategies for so-called “subword encoding” that have become popular in neural-network based natural language processing pipelines. It works by looking at the statistical properties of a set of texts to find linguistically common breakpoints. You tell it how many individual tokens you want it to output, and it divides words up into portions. These portions may be as long as a full word or as short as a letter.

# Sentencepiece doesn’t know how it will split up words–instead, it looks at the words in your collection to determine a plan for splitting them up. This means you must train your model on
# a list of files before actually doing the tokenization.

# pass it a list of all the files it should read.
some_files <- list.files("SOTUS", full.names = TRUE) %>%
  .[51:100] %>% #smaller
  keep(~str_detect(.x, ".txt"))
skimr::skim(some_files)

# The model will be saved in the current directory if you want to reuse it later.
model <- sentencepiece(x = some_files, vocab_size = 4000 - 1, model_dir = "." )

# With the model saved, you can now tokenize a list of strings with the
# ‘sentencepiece_encode’ function. To use the model, it needs to be passed as
# the first argument to the function; but we can still use the same functions
# to put the words in a dataframe and unnest them.

words <- sentencepiece_encode(model, read_lines(some_files[25]))
table <- data_frame(words) %>% unnest(words)

table %>% count(words) %>% arrange(-n)
table %>% filter(lag(words, 1) == "▁in") %>% count(words) %>% arrange(-n)

# Probabilities and Markov chains -----------------------------------------
bigrams = SOTUs_some %>%
  mutate(word1 = word, word2 = lead(word, 1), word3 = lead(word, 2))
head(bigrams)

transitions <- bigrams %>%
  group_by(word1) %>%
  # First, we store the count for each word.
  mutate(word1Count = n()) %>%
  group_by(word1, word2) %>%
  # Then we group1 by the second word to see what share of
  # the first word is followed by the second.
  summarize(chance = n() / word1Count[1])
## `summarise()` has grouped output by 'word1'. You can override using the `.groups` argument.

# This gives a set of probabilities. What words follow “United?”
transitions %>%
  filter(word1 == "united") %>%
  arrange(-chance) %>%
  head(5)

# We can use the weight argument to sample_n. If you run this several times, you’ll see that you get different results.
transitions %>%
  filter(word1 == "my") %>%
  sample_n(1, weight = chance)

# So now, consider how we combine this with joins. We can create a new column from a seed word, join it in against the transitions frame, and then use the function `str_c`
# –which pastes strings together– to create a new column holding our new text.
chain <- data_frame(text = "my")
chain <- chain %>%
  mutate(word1 = text) %>%
  inner_join(transitions) %>%
  sample_n(1, weight = chance) %>%
  mutate(text = str_c(text, word2, sep = " "))

# This gives us a column that’s called “text”; and we can select it, and tokenize it again.
# Why is that useful? Because now we can combine this join and the wordcounts to keep doing the same process! We tokenize our text; take the very last token; and do the merge.
# Try running this piece of code several different times.

chain <- chain %>%
  select(text) %>%
  unnest_tokens(word1, text, drop = FALSE) %>%
  tail(1) %>% inner_join(transitions) %>%
  sample_n(1, weight = chance) %>%
  mutate(text = str_c(text, word2, sep=" ")) %>%
  select(text)


## doing this in a function ----------------------------------------------

# In the tidyverse, the simplest functions start with a dot.
add_a_word <- . %>%
  select(text) %>%
  unnest_tokens(word1, text, drop = FALSE) %>%
  tail(1) %>%
  inner_join(transitions, by = "word1") %>%
  sample_n(1, weight = chance) %>%
  mutate(text = str_c(text, word2, sep=" ")) %>%
  select(text)

# .... modo A) repeating function
tibble(text = "america") %>%
  add_a_word %>% add_a_word %>% add_a_word %>%
  add_a_word %>% add_a_word %>% add_a_word %>%
  add_a_word %>% add_a_word %>% add_a_word %>%
  add_a_word %>% add_a_word %>% add_a_word %>%
  add_a_word %>% add_a_word %>% add_a_word %>% pull(text)

# .... modo B) looping function
seed = tibble(text = "America")
for (i in 1:15) {
  seed = add_a_word(seed)
}
seed %>% pull(text)

# .... modo c) “recursion.” function
# Here the function calls itself if it has more than one word left to add.
# This would be something a programming class would dig into;

# just know that functions might call themselves!
add_n_words <- function(seed_frame, n_words) {
    with_one_addition = add_a_word(seed_frame)
    if (n_words==1) {
      return(with_one_addition)
    } else {
      return(add_n_words(with_one_addition, n_words - 1))
    }
  }

add_n_words(tibble(text = "chile"), 10)

length_2_transitions  <-  SOTUs_some %>%
  mutate(word1 = word, word2 = lead(word, 1), word3 = lead(word, 2)) %>%
  group_by(word1, word2, word3) %>%
  summarize(chance = n()) %>%
  ungroup

length_2_transitions %>% sample_n(10)

# function
add_a_bigram <- . %>%
  unnest_tokens(word, text, drop=FALSE) %>%
  tail(2) %>% mutate(wordpos = str_c("word", 1:n())) %>%
  pivot_wider(values_from=word,names_from = wordpos) %>%
  inner_join(length_2_transitions) %>%
  sample_n(1, weight = chance) %>%
  mutate(text = str_c(text, word3, sep=" ")) %>%
  select(text)
# call it
start = tibble(text = "united states")
start <- start %>% add_a_bigram
start
