- Open Hadoop CLI and run below commands
```
cd ~/Day-2/06-PIG
wget https://sadatashareagsparkml.blob.core.windows.net/hadoop-bangalore/ml-100k.zip
unzip -n ml-100k.zip
hadoop fs -put ml-100k
hadoop fs -ls
```

- Open PIG Grunt Console
```
pig
```

```
ratings = LOAD 'ml-100k/u.data' AS (userID:int, movieID:int, rating:int, ratingTime:int);
DUMP ratings;
```

```
metadata = LOAD 'ml-100k/u.item' USING PigStorage('|')AS (movieID:int, movieTitle:chararray, releaseDate:chararray, videoRelease:chararray, imdbLink:chararray);
DUMP metadata;
```

```
nameLookup = FOREACH metadata GENERATE movieID, movieTitle, ToUnixTime(ToDate(releaseDate, 'dd-MMM-yyyy')) AS releaseTime;
DUMP nameLookup;
```

```
ratingsByMovie = GROUP ratings BY movieID;
DUMP ratingsByMovie;
```

```
avgRatings = FOREACH ratingsByMovie GENERATE group AS movieID, AVG(ratings.rating) AS avgRating;
DUMP avgRatings;
```

```
DESCRIBE ratings;
DESCRIBE ratingsByMovie;
DESCRIBE avgRatings;
```

```
fiveStarMovies = FILTER avgRatings BY avgRating > 4.0;
DUMP fiveStarMovies;
```

- JOIN
```
DESCRIBE fiveStarMovies;
DESCRIBE nameLookup;
fiveStarsWithData = JOIN fiveStarMovies BY movieID, nameLookup BY movieID;
DESCRIBE fiveStarsWithData;
DUMP fiveStarsWithData
```

- ORDER BY
```
oldestFiveStarMovies = ORDER fiveStarsWithData BY
nameLookup::releaseTime;
DUMP oldestFiveStarMovies;
```

- Exit from PIG Grun console
```
\q
```

- Putting it all tigether
	- Now open Ambari and open PIG view
	- Copy the script and run it. Script code is available in pig.txt
