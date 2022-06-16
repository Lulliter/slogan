#**************************************************************************
#                  Chapter 4 : TF-IDF
#**************************************************************************

#install and load the tm library for text processing

#install.packages("tm")
library(tm)

#--------------------------------------------------------------------------
#                  4.2: Generating a Term frequency Matrix
#--------------------------------------------------------------------------

#Load the cleaned corpus saved in Chapter 3
course_desc <- VCorpus(DirSource("C:/Users/Kumaran Ponnambalam/Desktop/Exercise Files/CleanCorpus"))
inspect(course_desc[[1]])

#Generate the Document Term matrix
course_dtm <- DocumentTermMatrix(course_desc)

#Inspect to TF-IDF
inspect(course_dtm)

#List of docs in the matrix
Docs(course_dtm)
#No. of docs in the matrix
nDocs(course_dtm)
#List of terms in the matrix
Terms(course_dtm)
#No. of terms in the matrix
nTerms(course_dtm)

#Convert to a matrix
course_dtm_matrix = as.matrix(course_dtm)

#Inspect a specific term
course_dtm_matrix[, 'kafka']


#--------------------------------------------------------------------------
#                  4.3: Improving Term Frequency Matrix
#--------------------------------------------------------------------------

#Find terms that have occured atleast 5 times
findFreqTerms(course_dtm,5)

#Remove sparse terms - Terms not there in 50% of the documents
#Given that we have only 2 documents, this will give terms that
#are there in both the documents
dense_course_dtm <- removeSparseTerms(course_dtm, 0.5)

inspect(dense_course_dtm)

#--------------------------------------------------------------------------
#                  4.4: Plotting Frequency data
#--------------------------------------------------------------------------

#Generate a frequency table
course_dtm_frequency <- sort(colSums(as.matrix(dense_course_dtm)), 
                          decreasing=TRUE)
#Print the table (vector)
course_dtm_frequency

#Convert frequency table to a data frame
course_dtm_df <- data.frame(word=names(course_dtm_frequency), 
                            freq=course_dtm_frequency)
#print the data frame
course_dtm_df

#install.packages("ggplot2")
library(ggplot2)

#Create a frequency plot
frequency_plot <- ggplot(subset(course_dtm_df, freq>1), 
                    aes(x = reorder(word, -freq), y = freq)) +
                geom_bar(stat = "identity", fill = "#FF6666") + 
                theme(axis.text.x=element_text(angle=45, hjust=1))

#display the frequency plot
frequency_plot

#--------------------------------------------------------------------------
#                  4.5. Generating TF-IDF
#--------------------------------------------------------------------------

#Generate the TF-IDF 
course_tfidf <- DocumentTermMatrix(course_desc, 
                      control= list(weighting = weightTfIdf))

#Inspect to TF-IDF
inspect(course_tfidf)

#-------------------------------------------------------------------------


