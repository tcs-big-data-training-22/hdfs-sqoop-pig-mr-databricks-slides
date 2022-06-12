### Data
We will also use data got from GroupLens.

* [Movielens](http://grouplens.org/datasets/movielens/ "Movielens")


* Fake Friends data

> data/fakefriends.csv

* Weather data from the year 1800

> data/1800.csv

* Book data

> data/book.txt

* Order Amount by Customer data

> data/customer-orders.csv

* Marvel input data

> data/Marvel-Graph.txt
> data/Marvel-Names.txt

### Run
* Rating Counter with ml-100k data

- Move to the correct directory
```console
pwd
ls
cd ~/Day-2/05-MapReduce
```

```console
python app/RatingCounter.py data/ml-100k/u.data
```

* Average Friends by Age with Fake Friends data
```console
python app/FriendsByAge.py data/fakefriends.csv
python app/FriendsByAge.py data/fakefriends.csv > dist/friendsbyage.txt
```

* Finding Temperature Extremes

Get minimum temperature by location
```console
python app/MinTemperatures.py data/1800.csv > dist/mintemps.txt
```

Get maximum temperature by location
```console
python app/MaxTemperatures.py data/1800.csv > dist/maxtemps.txt
```

* Word Frequency

However, it still make some errors
```console
python app/WordFrequency.py data/Book.txt > dist/wordcount.txt
```

Using chaining step method, results are sorted by the values(frequencies)
```console
python app/WordFrequencySorted.py data/Book.txt > dist/wordcountsorted.txt
```

* Most Popular Movie
```console
python app/MostPopularMovie.py data/ml-100k/u.data > dist/mostpopularmovie.txt
```
