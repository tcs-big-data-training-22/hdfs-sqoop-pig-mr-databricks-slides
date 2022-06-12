Reference:
https://phoenixnap.com/kb/install-hadoop-ubuntu

sudo apt update
sudo apt install openjdk-8-jdk -y
java -version; javac -version

Install OpenSSH on Ubunt
```
sudo apt install openssh-server openssh-client -y
```

Create Hadoop User
sudo adduser hdoop

Switch to the newly created user and enter the corresponding password:
su - hdoop

Enable Passwordless SSH for Hadoop User
ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 0600 ~/.ssh/authorized_keys
ssh localhost

Download and Install Hadoop on Ubuntu
- Visit: https://hadoop.apache.org/releases.html
- Chose the URL of Hadoop tar file to download
wget https://downloads.apache.org/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
tar xzf hadoop-3.2.1.tar.gz


## Single Node Hadoop Deployment
- A Hadoop environment is configured by editing a set of configuration files:
bashrc
hadoop-env.sh
core-site.xml
hdfs-site.xml
mapred-site-xml
yarn-site.xml


Configure Hadoop Environment Variables (bashrc)
sudo nano .bashrc

Define the Hadoop environment variables by adding the following content to the end of the .bashrc file:

#Hadoop Related Options
export HADOOP_HOME=/home/hdoop/hadoop-3.2.1
export HADOOP_INSTALL=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_HDFS_HOME=$HADOOP_HOME
export YARN_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
export HADOOP_OPTS"-Djava.library.path=$HADOOP_HOME/lib/nativ"


source ~/.bashrc

- Locate java path
which javac

Use the provided path to find the OpenJDK directory with the following command:
readlink -f /usr/bin/javac

The section of the path just before the /bin/javac directory needs to be assigned to the $JAVA_HOME variable.

Edit hadoop-env.sh File
sudo nano $HADOOP_HOME/etc/hadoop/hadoop-env.sh

- Uncomment the $JAVA_HOME variable (i.e., remove the # sign) and add the full path to the OpenJDK installation on your system
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

Edit core-site.xml File
- The core-site.xml file defines HDFS and Hadoop core properties.

sudo nano $HADOOP_HOME/etc/hadoop/core-site.xml

- Create directory
mkdir /home/hdoop/tmpdata

- Add the following configuration to override the default values for the temporary directory and add your HDFS URL to replace the default local file system setting:

<configuration>
<property>
  <name>hadoop.tmp.dir</name>
  <value>/home/hdoop/tmpdata</value>
</property>
<property>
  <name>fs.default.name</name>
  <value>hdfs://127.0.0.1:9000</value>
</property>
</configuration>


Edit hdfs-site.xml File
- The properties in the hdfs-site.xml file govern the location for storing node metadata, fsimage file, and edit log file.
- Configure the file by defining the NameNode and DataNode storage directories.
- Additionally, the default dfs.replication value of 3 needs to be changed to 1 to match the single node setup.

sudo nano $HADOOP_HOME/etc/hadoop/hdfs-site.xmlCopied!

- Add the following configuration to the file and, if needed, adjust the NameNode and DataNode directories to your custom locations:

<configuration>
<property>
  <name>dfs.data.dir</name>
  <value>/home/hdoop/dfsdata/namenode</value>
</property>
<property>
  <name>dfs.data.dir</name>
  <value>/home/hdoop/dfsdata/datanode</value>
</property>
<property>
  <name>dfs.replication</name>
  <value>1</value>
</property>
</configuration>

- If necessary, create the specific directories you defined for the dfs.data.dir value.

- Edit mapred-site.xml File
sudo nano $HADOOP_HOME/etc/hadoop/mapred-site.xml

- Add the following configuration to change the default MapReduce framework name value to yarn:

<configuration>
<property>
  <name>mapreduce.framework.name</name>
  <value>yarn</value>
</property>
</configuration>

- Edit yarn-site.xml File
The yarn-site.xml file is used to define settings relevant to YARN. It contains configurations for the Node Manager, Resource Manager, Containers, and Application Master.

Open the yarn-site.xml file in a text editor:

sudo nano $HADOOP_HOME/etc/hadoop/yarn-site.xml

Append the following configuration to the file:

<configuration>
<property>
  <name>yarn.nodemanager.aux-services</name>
  <value>mapreduce_shuffle</value>
</property>
<property>
  <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
  <value>org.apache.hadoop.mapred.ShuffleHandler</value>
</property>
<property>
  <name>yarn.resourcemanager.hostname</name>
  <value>127.0.0.1</value>
</property>
<property>
  <name>yarn.acl.enable</name>
  <value>0</value>
</property>
<property>
  <name>yarn.nodemanager.env-whitelist</name>   
  <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PERPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_MAPRED_HOME</value>
</property>
</configuration>

Format HDFS NameNode
It is important to format the NameNode before starting Hadoop services for the first time:

hdfs namenode -format

Start Hadoop Cluster
Navigate to the hadoop-3.2.1/sbin directory and execute the following commands to start the NameNode and DataNode:

./start-dfs.sh

Once the namenode, datanodes, and secondary namenode are up and running, start the YARN resource and nodemanagers by typing:

./start-yarn.sh

Type this simple command to check if all the daemons are active and running as Java processes:

jps

Access Hadoop UI from Browser
Use your preferred browser and navigate to your localhost URL or IP. The default port number 9870 gives you access to the Hadoop NameNode UI:

http://localhost:9870


The default port 9864 is used to access individual DataNodes directly from your browser:

http://localhost:9864


The YARN Resource Manager is accessible on port 8088:

http://localhost:8088
