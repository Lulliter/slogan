
#**************************************************************************
#                  Chapter 5 : N-Grams
#**************************************************************************

#install and load the tm library for text processing

#install.packages("tm")
library(tm)

#--------------------------------------------------------------------------
#                   5.2. Using the RWeka NGramTokenizer
#--------------------------------------------------------------------------

#install.packages("RWeka")
library(RWeka)


demo_string <- "This is a demo for ngrams"

#Bigrams
print("Bigrams extraction : ")
NGramTokenizer( demo_string, Weka_control(min=2,max=2))

#Trigrams
print("Trigrams extraction : ")
NGramTokenizer( demo_string, Weka_control(min=3,max=3))

#--------------------------------------------------------------------------
#                   5.3. Creating N-gram Text Frequency Matrix
#--------------------------------------------------------------------------

#Load the corpus
course_desc <- VCorpus(DirSource("C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/data"))
inspect(course_desc[[1]])

#Function to generate Bigrams
BigramTokenizer <- function(x) {
  NGramTokenizer(x, Weka_control(min = 2, max = 2))
}

#Generate Document Term matrix from Bigrams
dtm_bigrams = DocumentTermMatrix(course_desc,
                        control = list(tokenize = BigramTokenizer))
#Inspect the Bigrams DTM created
inspect(dtm_bigrams)

#Most frequent terms in the corpus that occured atleast 3 times
findFreqTerms(dtm_bigrams,3)

#--------------------------------------------------------------------------
#                   5.4. Extracting N-gram pairs
#--------------------------------------------------------------------------

#Remove sparse bigrams
dense_bigrams <- removeSparseTerms(dtm_bigrams , 0.5)
inspect(dense_bigrams)

#Generate a frequency table
bigrams_frequency <- sort(colSums(as.matrix(dense_bigrams)),
                          decreasing=TRUE)
bigrams_frequency

#Convert to data frame
bigrams_df <- data.frame(first_word=character(), 
                               second_word=character(), 
                               count=integer())

#Iterate through the frequency table to extract data
for ( i in 1:length(bigrams_frequency)) {
  
    #Extract the bigram name
    bigram <- names(bigrams_frequency)[[i]]
    #Split bigram into words
    bigram_words<-unlist(strsplit(bigram," "))
    #Extract count
    count=bigrams_frequency[[i]]
    
    #Create a row for the dataframe
    bigram_row<-list(first_word = bigram_words[[1]],
                      second_word=bigram_words[[2]],
                      count=count)
    #Add the row to the dataframe
    bigrams_df<-rbind(bigrams_df, bigram_row, stringsAsFactors=FALSE)
}

print("Bigrams dataframe :")
bigrams_df


#--------------------------------------------------------------------------