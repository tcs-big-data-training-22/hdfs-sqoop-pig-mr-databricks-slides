## Loading Data
```
hdfs dfs -mkdir /data/xml/inputs/
hdfs dfs -put /root/streaming/samplexml01.xml /data/xml/inputs/
```

## Simple Option with XML
```
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -input /data/xml/inputs/ \
    -output /data/xml/outputs/01/ \
    -mapper /bin/cat \
    -reducer /usr/bin/wc
```

```
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -inputreader "StreamXmlRecordReader,begin=xmlroot,end=/xmlroot" \
    -input /data/xml/inputs/ \
    -output /data/xml/outputs/02/ \
    -mapper /bin/cat \
    -reducer /usr/bin/wc
```	

## Python and XML
```
chmod a+x ./mapper.py
chmod a+x ./reducer.py
```

```
cat samplexml01.xml | ./mapper.py | ./reducer.py
```

### Run Python scripts inside Hadoop cluster.
```
hadoop jar /usr/hdp/current/hadoop-mapreduce-client/hadoop-streaming.jar \
    -input /data/xml/inputs/ \
    -output /data/xml/outputs/04/ \
    -file mapper.py \
    -file reducer.py \
    -mapper ./mapper.py \
    -reducer ./reducer.py
```
