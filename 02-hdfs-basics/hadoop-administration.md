# Hadoop Configuration Files
1) hadoop-env.sh->>It specifies the environment variables that affect the JDK used by Hadoop Daemon (bin/hadoop). We know that Hadoop framework is wriiten in Java and uses JRE so one of the environment variable in Hadoop Daemons is $Java_Home in Hadoop-env.sh.

2) core-site.xml->>It is one of the important configuration files which is required for runtime environment settings of a Hadoop cluster.It informs Hadoop daemons where the NAMENODE runs in the cluster. It also informs the Name Node as to which IP and ports it should bind.

3) hdfs-site.xml->>It is one of the important configuration files which is required for runtime environment settings of a Hadoop. It contains the configuration settings for NAMENODE, DATANODE, SECONDARYNODE. It is used to specify default block replication. The actual number of replications can also be specified when the file is created,

4) mapred-site.xml->>It is one of the important configuration files which is required for runtime environment settings of a Hadoop. It contains the configuration settings for MapReduce . In this file, we specify a framework name for MapReduce, by setting the MapReduce.framework.name.

5) Slave->>It is used to determine the slave Nodes in Hadoop cluster.
The Slave file at Master Node contains a list of hosts, one per line.
The Slave file at Slave server contains IP address of Slave nodes.

## Common admin tasks
- Monitor health of cluster
- Add new data nodes as needed
- Optionally turn on security
- Optionally turn on encryption
- Recommended, but optional, to turn on high availability
- Optional to turn on MapReduce Job History Tracking Server
- Fix corrupt data blocks when necessary
- Tune performance


## Hadoop web interface URLs
- The most common URLs you use with Hadoop are:
  - NameNode	http://localhost:50070
  - Yarn Resource Manager	http://localhost:8088
  - MapReduce JobHistory Server	http://localhost:19888

## You run administrative commands using the CLI:
```
hdfs haadmin
```


## MapReduce job history server
cd /etc/hadoop/2.6.5.0-292/0
cat mapred-site.xml
curl http://localhost:19888/ws/v1/history/info

## Common CLI Commands
```
hdfs namenode -backup
```

```
hdfs namenode -format
```

- List processes.
```
jps
```

- Corrupt data blocks. Find missing blocks.
```
hdfs fsck /
```
