cd ~/hdfs-sqoop-pig-mr-databricks-slides
wget https://sadatashareagsparkml.blob.core.windows.net/hadoop-bangalore/code-data.zip
unzip -n code-data.zip

# If not done already, login to ambari UI with admin ID and create a new user with name - u?

## SSH to Hadoop Cluster
ssh $USER@localhost -p 2222


hadoop fs -rm -r input-data

// make a 'input-data' directory

hadoop fs -mkdir /user/$USER
hadoop fs -ls /user
hadoop fs -ls /user/$USER
hadoop fs -mkdir input-data
hadoop fs -ls /user/$USER


// Clone Git Repo
cd ~
git clone https://github.com/tcs-big-data-training-22/hdfs-sqoop-pig-mr-databricks-slides
cd ~/hdfs-sqoop-pig-mr-databricks-slides
ls
wget https://sadatashareagsparkml.blob.core.windows.net/hadoop-bangalore/code-data.zip
unzip -n code-data.zip
cd data
ls
pwd

// load 'shakespeare' dataset into hdfs:
cd ~/hdfs-sqoop-pig-mr-databricks-slides/data
hadoop fs -put shakespeare input-data/

// you may experience an error because the data is already in there (if so, then just leave it)
// load 'page_view' dataset into hdfs
hadoop fs -put page_view input-data/

// make a directory in hdfs
hadoop fs -mkdir delete-me-later-dir

// do a list on our home directory:
hadoop fs -ls # relative path (to /user/[username])
hadoop fs -ls /user/$USER
hadoop fs -ls input-data

// says it moved to trash... that's nice!
hadoop fs -rm -r delete-me-later-dir

// cat some data out
hadoop fs -cat input-data/shakespeare/poems

// we can pipe this output in linux just as we're used to piping any STDOUT data
hadoop fs -cat input-data/shakespeare/poems | less


// get something back out of hdfs
hadoop fs -get input-data/shakespeare/poems
