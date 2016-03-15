library(tm)
library(SnowballC)
library(topicmodels)
library(dplyr)
library(wordcloud)
library(RColorBrewer)

setwd("~/U_of_Minnesota/22_Exploratory Analytics/Group8_FinalProject/")

############# Topic Modeling #############

topicmodeling <- function(city) {
  dirname <- file.path("~/U_of_Minnesota/22_Exploratory Analytics/Group8_FinalProject/OpinRankDatasetWithJudgments/hotels/data/",city)
  docs <- Corpus(DirSource(dirname, encoding = "UTF-8"))
  #meta(docs[[1]])
  
  # The following steps pre-process the raw text documents.
  # Remove punctuations and numbers because they are generally uninformative.
  docs <- tm_map(docs, removePunctuation)
  docs <- tm_map(docs, removeNumbers)
  # Convert all words to lowercase.
  docs <- tm_map(docs, content_transformer(tolower))
  # Remove stopwords such as "a", "the", etc.
  docs <- tm_map(docs, removeWords, stopwords("english"))
  # Use the SnowballC package to do stemming.
  docs <- tm_map(docs, stemDocument)
  # Remove excess white spaces between words.
  docs <- tm_map(docs, stripWhitespace)
  # Inspect the first document to see what it looks like.
  #docs[[1]]$content
  
  # Convert all documents to a term frequency matrix.
  tfm <- DocumentTermMatrix(docs)
  # We can check the dimension of this matrix by calling dim()
  #print(dim(tfm))
  
  # Use topicmodels package to conduct LDA analysis.
  results <- LDA(tfm, k = 10, method = "Gibbs")
  return(results)
}

############# CSV Output #############

csv_files <- function(out_terms, out_topic_dist) {
  
  # Obtain the top five words for each topic.
  write.csv(terms(results, 10),file=out_terms)
  
  # Get the posterior probability for each document over each topic
  posterior <- posterior(results)[[2]]
  
  #Average topic distribution
  city_mean <- colMeans(posterior)

  # Obtain distribution of topics of certain city
  write.csv(city_mean,file=out_topic_dist)
}


############# Graphics Output #############

graphics <- function(out_cloud, out_dist) {
  
  terms_freq <- as.data.frame(t(posterior(results)$terms))
  terms_freq$name <- rownames(terms_freq)
  
  png(out_cloud, width=12,height=8, units='in', res=1000)
  par(mfrow=c(2,5))
  pal2 <- brewer.pal(8,"Dark2")
  for (i in c(1:10)) {
    terms_freq_a <- arrange(terms_freq[,c(i,11)],desc(terms_freq[,i]))
    terms_freq_a <- terms_freq_a[1:50,]
    wordcloud(terms_freq_a$name,terms_freq_a[,1],c(2,.5),colors=pal2, res=300)
  }
  dev.off()
  
  topic_dist <- data.frame(x=colMeans(posterior(results)[[2]]), y=c("Topic1","Topic2","Topic3","Topic4","Topic5","Topic6","Topic7","Topic8","Topic9","Topic10"))
  topic_dist <- arrange(topic_dist,desc(x))
  png(out_dist, width=12,height=8, units='in', res=1000)
  par(mfrow=c(1,1))
  barplot(topic_dist$x,names.arg =topic_dist$y,col="indianred2")
  dev.off()
  return()
}


############# Main Program #############

### Chicago
results <- topicmodeling("chicago")
csv_files(out_terms="Terms_Chicago.csv", out_topic_dist="Topic_dist_Chicago.csv")
graphics(out_cloud="wordcloud_Chicago.png",out_dist="topic_dist_Chicago.png")

### Beijing
results <- topicmodeling("beijing")
csv_files(out_terms="Terms_Beijing.csv", out_topic_dist="Topic_dist_Beijing.csv")
graphics(out_cloud="wordcloud_Beijing.png",out_dist="topic_dist_Beijing.png")

### Dubai
results <- topicmodeling("dubai")
csv_files(out_terms="Terms_Dubai.csv", out_topic_dist="Topic_dist_Dubai.csv")
graphics(out_cloud="wordcloud_Dubai.png",out_dist="topic_dist_Dubai.png")

### New-Delhi
results <- topicmodeling("new-delhi")
csv_files(out_terms="Terms_New-Delhi.csv", out_topic_dist="Topic_dist_New-Delhi.csv")
graphics(out_cloud="wordcloud_New-Delhi.png",out_dist="topic_dist_New-Delhi.png")

### Las-Vegas
results <- topicmodeling("las-vegas")
csv_files(out_terms="Terms_Las-Vegas.csv", out_topic_dist="Topic_dist_Las-Vegas.csv")
graphics(out_cloud="wordcloud_Las-Vegas.png",out_dist="topic_dist_Las-Vegas.png")

### new-york-city
results <- topicmodeling("new-york-city")
csv_files(out_terms="Terms_new-york-city.csv", out_topic_dist="Topic_dist_new-york-city.csv")
graphics(out_cloud="wordcloud_new-york-city.png",out_dist="topic_dist_new-york-city.png")

### montreal
results <- topicmodeling("montreal")
csv_files(out_terms="Terms_montreal.csv", out_topic_dist="Topic_dist_montreal.csv")
graphics(out_cloud="wordcloud_montreal.png",out_dist="topic_dist_montreal.png")

### shanghai
results <- topicmodeling("shanghai")
csv_files(out_terms="Terms_shanghai.csv", out_topic_dist="Topic_dist_shanghai.csv")
graphics(out_cloud="wordcloud_shanghai.png",out_dist="topic_dist_shanghai.png")

### san-francisco
results <- topicmodeling("san-francisco")
csv_files(out_terms="Terms_san-francisco.csv", out_topic_dist="Topic_dist_san-francisco.csv")
graphics(out_cloud="wordcloud_san-francisco.png",out_dist="topic_dist_san-francisco.png")

### London
# results <- topicmodeling("london")
# csv_files(out_terms="Terms_London.csv", out_topic_dist="Topic_dist_London.csv")
# graphics(out_cloud="wordcloud_london.png",out_dist="topic_dist_london.png")
