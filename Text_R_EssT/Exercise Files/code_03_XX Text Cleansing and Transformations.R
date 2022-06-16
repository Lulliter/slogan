
#**************************************************************************
#                  Chapter 3 : Text Cleansing and Transformations
#**************************************************************************

#install and load the tm library for text processing

#install.packages("tm")
library(tm)

#--------------------------------------------------------------------------
#                   3.1 : Setting up for processing
#--------------------------------------------------------------------------


#Load text files into the VCorpus
course_corpus <- VCorpus(DirSource("C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/data"))

#Function that prints data about the corpus
#-----input : processing_step <- Description of the step
#-----input : corpus : The corpus to analyze.
analyze_corpus <- function(processing_step, corpus) {
  
  print("***************************************************")
  print(processing_step)
  print("---------------------------------------------------")
  
  #Count number of words and characters in the corpus and print.
  for(i_doc in 1:length(corpus) ) {
    print(paste(corpus[[i_doc]]$meta$id,
                " words =", 
                lengths(gregexpr("\\W+", corpus[[i_doc]])) + 1,
                " chars =",
                nchar(corpus[[i_doc]]$content)
    ))
  }
  
  #Print the first document in the corpus
  print("---------------------------------------------------")
  print(corpus[[1]]$content)
  
}

#Print the raw Corpus first
analyze_corpus("Raw input data", course_corpus)

#--------------------------------------------------------------------------
#                   3.2 : Cleansing Text
#--------------------------------------------------------------------------

#Convert to lower case
course_corpus2 <- tm_map(course_corpus, content_transformer(tolower))
analyze_corpus("Converted to lower case",course_corpus2)

#Remove punctuations
course_corpus3 <- tm_map(course_corpus2, removePunctuation)
analyze_corpus("Removed punctuations",course_corpus3)

#--------------------------------------------------------------------------
#                   3.3 : Stopword removal
#--------------------------------------------------------------------------

#Remove stopwords
course_corpus4 <- tm_map(course_corpus3, removeWords, stopwords())
analyze_corpus("Removed Stopwords",course_corpus4)

#--------------------------------------------------------------------------
#                   3.4 : Stemming
#--------------------------------------------------------------------------

#install.packages("SnowballC")
library("SnowballC")

course_corpus5 <- tm_map(course_corpus4, stemDocument)
analyze_corpus("Stemmed documents",course_corpus5)

#--------------------------------------------------------------------------
#                   3.5 : Managing Metadata 
#--------------------------------------------------------------------------

#Change ID for each document - without the .txt extension.
for(i_doc in 1:length(course_corpus5) ) {
  
    #Remove the .txt extension in the ID
    course_corpus5[[i_doc]]$meta$id <-
        sub('.txt','',course_corpus5[[i_doc]]$meta$id)
    
    #Add no. of words
    course_corpus5[[i_doc]]$meta$words <-
          lengths(gregexpr("\\W+", course_corpus5[[i_doc]])) + 1
    
    #add a new attribute for status.
    course_corpus5[[i_doc]]$meta$status <-'Cleaned'
}

#Print modified meta data
course_corpus5[[1]]$meta

#Convert to dataframe
df_metadata <- 
  data.frame(status=sapply(course_corpus5, meta, "status"),
             words=sapply(course_corpus5, meta, "words"),
             stringsAsFactors=FALSE)

#Print the data frame
df_metadata

#Save corpus for future use in next chapters. 
#Note: This wont save meta data. If required,  
#the metadata's dataframe should be persisted seperately 

writeCorpus(course_corpus5, "C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/CleanCorpus" )

#--------------------------------------------------------------------------

