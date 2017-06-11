Explanatory Data Analysis and Prediction of movie scores on *Rotten Tomatoes*
=============================================================================

Setup
-----

### Load packages

    library(ggplot2)
    library(dplyr)

    ## Warning: package 'dplyr' was built under R version 3.3.3

    library(statsr)

### Load data

    load("movies.Rdata")

------------------------------------------------------------------------

Data
----

The Internet Movie Database (abbreviated IMDb) is an online database of
information related to films, television programs and video games,
including cast, production crew, fictional characters, biographies, plot
summaries, trivia and reviews.

Rotten Tomatoes is an American review aggregator website for film and
television. The data set used is comprised of 651 randomly sampled
movies produced and released before 2016.

Since random sample has been usedm, it can be said that the data is
generalized.

And since its an observational study, we can't comment anything about
any causalty.

------------------------------------------------------------------------

Research question
-----------------

Q. What is the distribution of audience ratings on both IMDB and Rotten
Tomatoes for the different genres of motion pictures from 1970 to 2014.

This distribution would help us to properly understand the polarity of
audiences on these two review aggregators and if there are any biases of
judgement towards any genre in particular.

------------------------------------------------------------------------

Exploratory data analysis
-------------------------

### For audiences on IMDB,

    imdb_dist <- movies %>% group_by(genre) %>% summarise(med = median(imdb_rating))
    imdb_dist[order(imdb_dist$med),]

    ## # A tibble: 11 × 2
    ##                        genre   med
    ##                       <fctr> <dbl>
    ## 1                     Comedy  5.70
    ## 2                     Horror  5.90
    ## 3  Science Fiction & Fantasy  5.90
    ## 4         Action & Adventure  6.00
    ## 5                  Animation  6.40
    ## 6  Art House & International  6.50
    ## 7         Mystery & Suspense  6.50
    ## 8                      Drama  6.80
    ## 9                      Other  6.80
    ## 10 Musical & Performing Arts  7.55
    ## 11               Documentary  7.60

*The medians of the respective ratings provided has been used in this
exploration as in cases when our distributions might not be normal, the
median is the most robust centre we can rely upon.*

It can be seen from the summary table that the audiences are more biased
towards those motion pictures within the sole genres of "Documentaries"
and "Musical and performing arts" as compared to the other genres.

In contrast, it can also be seen that those motion pictures solely
within genres like "Horror" and "Comedy" are seldomly highly rated, a
fact that we young people as movie fanatics are already aqquainted to.

    ggplot(movies, aes(y = imdb_rating , x = genre)) + geom_boxplot(fill = "#e6f3ff") + coord_flip() + labs(title="Distribution of audience ratings on IMDB", y = "IMDB Rating(out of 10)", x = "Genre") + theme_minimal()


![](https://github.com/SauravDeb/Explanatory-Data-Analysis-and-Prediction-on-IMDB-dataset/blob/master/Distributtion%20of%20audience%20ratings%20on%20IMDB.png)
The box corresponding to the "Documentaries" genre can be seen as having
the highest median of audience ratings and "Horror" the lowest.

### For audiences on Rotten Tomatoes,

    imdb_dist <- movies %>% group_by(genre) %>% summarise(med = median(audience_score))
    imdb_dist[order(imdb_dist$med),]

    ## # A tibble: 11 × 2
    ##                        genre   med
    ##                       <fctr> <dbl>
    ## 1                     Horror  43.0
    ## 2  Science Fiction & Fantasy  47.0
    ## 3                     Comedy  50.0
    ## 4         Action & Adventure  52.0
    ## 5         Mystery & Suspense  54.0
    ## 6                  Animation  65.0
    ## 7  Art House & International  65.5
    ## 8                      Drama  70.0
    ## 9                      Other  73.5
    ## 10 Musical & Performing Arts  80.5
    ## 11               Documentary  86.0

*The medians of the respective ratings provided has been used in this
exploration as in cases when our distributions might not be normal, the
median is the most robust centre we can rely upon.*

It can be seen from the summary table that the audiences are more biased
towards those motion pictures within the sole genres of "Documentaries"
and "Musical and performing arts" as compared to the other genres.

In contrast, it can also be seen that those motion pictures solely
within genres like "Horror" and "Sci-fy and Fantasy" are seldomly highly
rated.

    ggplot(movies, aes(y = audience_score , x = genre)) + geom_boxplot(fill = "#e6f3ff") + coord_flip() + labs(title="Distribution of audience score on Rotten Tomatoes", y = "Audience Score(in %)", x = "Genre") + theme_minimal()


![](https://github.com/SauravDeb/Explanatory-Data-Analysis-and-Prediction-on-IMDB-dataset/blob/master/Distribution%20od%20audience%20score%20on%20Rotten%20Tomatoes.png)
The box corresponding to the "Documentaries" genre can be seen as having
the highest median of audience ratings and "Horror" the lowest.

> We can hence infer the fact that those movies solely carrying the
> banners of "Documentaries" and "Horror" are the most high-scoring and
> low-scoring respectively according to the audiences of both IMDB and
> Rotten Tomatoes.

------------------------------------------------------------------------

Part 4: Modeling
----------------

I aim at creating a reliable linear regression model that can predict
audience scores of movies on Rotten Tomatoes based on certain parameters
that are explained below.

*The full Model*

The full model attempts at predicting the audience scores based on
variables present in our dataset as listed: genre, runtime,
critics\_score, best\_pic\_win, best\_actor\_win, best\_dir\_win and
best\_actress\_win.

*Exclusion of certain parameters*

The quality of a model is described by its Multiple R-squared but more
there is a more powerful measure of the Adjusted R-squared which
describes a penalty on each insignificant parameter used.

Certain parameters such as the best\_pic\_win, best\_actor\_win,
best\_dir\_win and best\_actress\_win have been excluded as these
affected the model quaility and proved to be insignificant towards the
ease of predictibility of the audience scores and a corresponding
parsimonious model.

### Model Selection

Backward elimination using the p-value method has been used since we're
way too short of any insight to start with a forward selection process
and under such circumstances, elimination has proved to be better
approach towards creating a statistically significant prediction model.

**Step 1**

    model <- lm(audience_score ~ genre + runtime + critics_score + best_pic_win + best_actor_win + best_dir_win + best_actress_win, data = movies)

*Multiple R-squared: 0.534, Adjusted R-squared: 0.5223*

**Step 1**

    model <- lm(audience_score ~ genre + runtime + critics_score + best_pic_win + best_actor_win +  best_actress_win, data = movies)

*Multiple R-squared: 0.534, Adjusted R-squared: 0.523*

**Step 3**

    model <- lm(audience_score ~ genre + runtime + critics_score, data = movies)

*Multiple R-squared: 0.5323, Adjusted R-squared: 0.5235*

Hence we finally arrive at the maximum Adjusted R-squared of 0.5235 and
a parsimonious model for the prediction of audience scores.

### Model diagnostics

    summary(model)

    ## 
    ## Call:
    ## lm(formula = audience_score ~ genre + runtime + critics_score, 
    ##     data = movies)
    ## 
    ## Residuals:
    ##     Min      1Q  Median      3Q     Max 
    ## -36.151  -9.586   0.525   9.568  41.424 
    ## 
    ## Coefficients:
    ##                                Estimate Std. Error t value Pr(>|t|)    
    ## (Intercept)                    27.37145    3.59290   7.618 9.35e-14 ***
    ## genreAnimation                  5.94345    4.99993   1.189 0.234998    
    ## genreArt House & International  5.74324    4.12223   1.393 0.164035    
    ## genreComedy                    -0.53569    2.29935  -0.233 0.815856    
    ## genreDocumentary                9.45211    2.81096   3.363 0.000818 ***
    ## genreDrama                      1.68250    1.96516   0.856 0.392229    
    ## genreHorror                    -8.22215    3.40868  -2.412 0.016142 *  
    ## genreMusical & Performing Arts  9.77902    4.45744   2.194 0.028606 *  
    ## genreMystery & Suspense        -4.38861    2.53277  -1.733 0.083628 .  
    ## genreOther                      1.79864    3.93336   0.457 0.647627    
    ## genreScience Fiction & Fantasy -6.54296    4.97258  -1.316 0.188711    
    ## runtime                         0.07482    0.03040   2.462 0.014097 *  
    ## critics_score                   0.45007    0.02175  20.697  < 2e-16 ***
    ## ---
    ## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
    ## 
    ## Residual standard error: 13.97 on 637 degrees of freedom
    ##   (1 observation deleted due to missingness)
    ## Multiple R-squared:  0.5323, Adjusted R-squared:  0.5235 
    ## F-statistic: 60.42 on 12 and 637 DF,  p-value: < 2.2e-16

    ggplot(movies, aes(y=audience_score, x=runtime)) + geom_jitter() + labs(title = "Plot of audience scores Vs Runtime", x = "Movie Runtime", y = "Audience Scores(in %)") + theme_minimal()

    ## Warning: Removed 1 rows containing missing values (geom_point).


![](https://github.com/SauravDeb/Explanatory-Data-Analysis-and-Prediction-on-IMDB-dataset/blob/master/PlotAudi.png)

    ggplot(model, aes(y=.resid,x= .fitted)) + geom_jitter() + geom_hline( yintercept = 0, linetype = "dashed") + labs(title = "Resdiduals plot", x = "Fitted Values", y = "Residuals") + theme_minimal()


![](https://github.com/SauravDeb/Explanatory-Data-Analysis-and-Prediction-on-IMDB-dataset/blob/master/ResPlot.png)

    ggplot(model, aes(.resid)) + geom_histogram(binwidth = 10, fill = "#e6f3ff", color = "black") + theme_minimal() + labs(title = "Distribution of Residuals", x = "Residuals", y = "Count")


![](https://github.com/SauravDeb/Explanatory-Data-Analysis-and-Prediction-on-IMDB-dataset/blob/master/DistRes.png)

**Interpretation of Coefficients**

The intercept of this regression line is meaningless whatsover since the
runtime of any movie can't be 0 minutes.

The 0.07482 coefficient of runtime points out to the fact that for each
additional minute the movie goes on, the audience scores increases by
this value.

The 0.45007 coefficient of critics score points out to the fact that for
each additional 10% increase in the critics score increases the audience
scores by 4.5%.

The coefficients corresponding to the the genre categories are
self-explanatory now these have already been discussed in the EDA
Section.

------------------------------------------------------------------------

Part 5: Prediction
------------------

We wanted to predict the audience score for a new movie that has not
been used to fit the model. For the recent release of the DC-franchise
movie __Wonder Woman(2017)__ we extracted the runtime, critics score
and audience score from IMDB and Rotten tomatoes,the genre was set to
__Action & Adventure__.

The real and the predicted audience score were 92% each, and a
confidence interval between 51.52 and 107.11 was calculated. It means
that if samples were taken repeatedly and intervals were to be
calculated, 95% of the them would contain the true audience score
percentage(i.e 92% in this case).

    new_movie<-data.frame(genre="Action & Adventure",runtime=141,critics_score=92)
    predict(model, new_movie, interval = "predict")

    ##        fit      lwr      upr
    ## 1 79.32759 51.54167 107.1135

------------------------------------------------------------------------

Part 6: Conclusion
------------------

Determining the popularity of a movie is not simple task. The intrinsic
characteristics of a movie seem to have some degree of correlation with
the popularity of a movie. However, external attributes, like critics
score , also seem to be correlated with its popularity. Then, the movie
genre, runtime etc can also be used to predict the popularity of a movie
as extrinsic parameters. One important shortcoming of the current
approach is the fact that we only used a subset of the features for the
initial model, a better model could be trained using the whole set of
features or a combination of some features. Another possible path for
future research is to use external features independent of IMDB and
Rotten tomatoes.

**END**
