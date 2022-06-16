
#**************************************************************************
#                  Chapter 2 : Working with Text Corpus
#**************************************************************************

#install and load the tm library for text processing

#install.packages("tm")
library(tm)

#--------------------------------------------------------------------------
#                   2.2 : Creating a Corpus
#--------------------------------------------------------------------------

#Read a directory into a Source object
source_data <- DirSource("C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/data")

#Create a Volatile Corpus from the source object
course_corpus <- VCorpus(source_data)


#--------------------------------------------------------------------------
#                   2.3 : Exploring the Corpus
#--------------------------------------------------------------------------

#Inspect the corpus to learn about its data
inspect(course_corpus)

#Inspect the contents of a specific document in the corpus
inspect(course_corpus[[1]])

#Inspect meta data about a document
meta(course_corpus[[1]])

#Access a specific attribute about a document
course_corpus[[1]]$meta$id

#Set a value for an attribute
course_corpus[[1]]$meta$author <- "Kumaran Ponnambalam"
course_corpus[[1]]$meta$type <- "Courses"

#Display the attributes again
meta(course_corpus[[1]])

#--------------------------------------------------------------------------
#                   2.4 : Persisting the Corpus
#--------------------------------------------------------------------------


#Change ID for each document - without the .txt extension.
for(i_doc in 1:length(course_corpus) ) {
    course_corpus[[i_doc]]$meta$id = 
        sub('.txt','',course_corpus[[i_doc]]$meta$id)
}

#The destination directory should pre-exist.
writeCorpus(course_corpus, "C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/SavedCorpus" )

#--------------------------------------------------------------------------
