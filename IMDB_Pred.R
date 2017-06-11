library(ggplot2)
library(dplyr)
library(statsr)

load("movies.Rdata")

imdb_dist <- movies %>% group_by(genre) %>% summarise(med = median(imdb_rating))
imdb_dist[order(imdb_dist$med),]
ggplot(movies, aes(y = imdb_rating , x = genre)) + geom_boxplot(fill = "#e6f3ff") + coord_flip() + labs(title="Distribution of audience ratings on IMDB", y = "IMDB Rating(out of 10)", x = "Genre") + theme_minimal()

imdb_dist <- movies %>% group_by(genre) %>% summarise(med = median(audience_score))
imdb_dist[order(imdb_dist$med),]
ggplot(movies, aes(y = audience_score , x = genre)) + geom_boxplot(fill = "#e6f3ff") + coord_flip() + labs(title="Distribution of audience score on Rotten Tomatoes", y = "Audience Score(in %)", x = "Genre") + theme_minimal()

model <- lm(audience_score ~ genre + runtime + critics_score, data = movies)

summary(model)

#Diagnostics
ggplot(movies, aes(y=audience_score, x=runtime)) + geom_jitter() + labs(title = "Plot of audience scores Vs Runtime", x = "Movie Runtime", y = "Audience Scores(in %)") + theme_minimal()
ggplot(model, aes(y=.resid,x= .fitted)) + geom_jitter() + geom_hline( yintercept = 0, linetype = "dashed") + labs(title = "Resdiduals plot", x = "Fitted Values", y = "Residuals") + theme_minimal()
ggplot(model, aes(.resid)) + geom_histogram(binwidth = 10, fill = "#e6f3ff", color = "black") + theme_minimal() + labs(title = "Distribution of Residuals", x = "Residuals", y = "Count")