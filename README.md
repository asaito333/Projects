# Analytics Projects
Project work completed in the graduate courses

<h3>(1) <a href= "https://github.com/tnmasui/Projects/tree/master/InsideAirbnb" >Regression Model on Inside Airbnb data with Spark MLlib</a></h3>

In this project, I analyzed <a href="http://insideairbnb.com/get-the-data.html">"Inside Airbnb" data</a> to identify what factor affects property's rating to provide useful direction for users to choose better property or for property owners to increase rating score. To achieve that, I incorpolated this huge data into HDFS, <a href= "https://github.com/tnmasui/Projects/blob/master/InsideAirbnb/Preprocess_Hive.hql">manipulated data with Hive</a>, and <a href= "https://github.com/tnmasui/Projects/blob/master/InsideAirbnb/Regression_MLlib_Scala.txt">developed regression model by MLlib Scala in Spark</a>. The following chart shows what factors are the most significant for ratings. 

<img src="https://github.com/tnmasui/Projects/blob/master/InsideAirbnb/IMG_Airbnb.jpg" height="350" width="600">

<h3>(2) <a href= "https://github.com/tnmasui/Projects/tree/master/TripAdviser" >Topicmodeling on User Review Data of TripAdviser with R</a></h3>

In this project, I analyzed <a href="http://kavita-ganesan.com/entity-ranking-data">TripAdviser's user review and rating data</a> and identified how users rate and comment on hotels for the purpose of user's better hotel choice. For that purpose, I performed <a href= "https://github.com/tnmasui/Projects/blob/master/TripAdviser/TopicModeling.Rmd">topic modeling on user comments by hotel location</a> and found out which factors users appreciate. The following imange shows part of the result.

<img src="https://github.com/tnmasui/Projects/blob/master/TripAdviser/IMG_TripAdviser.jpg" height="350" width="600">

<h3>(3) <a href= "https://github.com/tnmasui/Projects/tree/master/IMDb" >Analyzing Movie Series Performance with IMDb Data by Python</a></h3>

In this project, we created dataset with <a href="http://www.imdb.com/interfaces">IMDb plain text data files</a> by using <a href="http://imdbpy.sourceforge.net/">API (IMDbPY)</a>. Then, I <a href= "https://github.com/tnmasui/Projects/blob/master/IMDb/Series_Analysis.ipynb">analyzed how user ratings on movies differ across series numbers</a>. The original data has multiple tables which includes such as title, movie type, rating, and box-office, so I joined those tables in this code. In addition, although the data have movies across countries, I only focus on US movie in this analysis. The following imange shows the result.

<img src="https://github.com/tnmasui/Projects/blob/master/IMDb/IMG_IMdB.jpg" height="350" width="600">
