# Importing with Sqoop

> **NOTE**: Use the command  hadoop fs -rm -r /etl/input/* to clear the HDFS data, for a clean run on the hands-on excercises.

> **NOTE**: Import excercise seed data and users by login to mysql with
> '$ mysql -u root -p' password is hadoop, after login execute mysql> source /path/to/file/mysql.credentials.sql and mysql> source /path/to/file/mysql.tables.sql

## Simple import
Sqoop provides import tools to import from hadoop DB to HDFS, Sqoop by default uses JDBC for connecting to the target DB, hence any DB with a JDBC driver can be used with sqoop.
cd ~/Day-2/03-Sqoop
ls

sqoop import \
   --connect jdbc:mysql://localhost/sqoop \
   --username sqoop \
  --password sqoop \
  --table cities

#Sqoop offers two parameters for specifying custom output directories: --target-dir and --warehouse-dir. Use the --target-dir parameter to specify the directory on HDFS where Sqoop should import your data

sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password sqoop \
  --table cities \
  --target-dir /etl/input/cities

sqoop import \
    --connect jdbc:mysql://localhost/sqoop \
    --username sqoop \
    --password sqoop \
    --table cities \
    --warehouse-dir /etl/input/

#Use the command-line parameter --where to specify a SQL condition that the imported data should meet.

sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password sqoop \
  --table cities \
  --where "country = 'USA'"

> **NOTE**: By default, Sqoop will create a directory with the same name as the imported table inside your home directory on HDFS and import
> all data there. For example, when the user u1 imports the table
> cities, it will be stored in /user/u1/cities. This directory can
> be changed to any arbitrary directory on your HDFS using the
> --target-dir parameter. The only requirement is that this directory must not exist prior to running the Sqoop command.

##Protecting the password

#The mysql password as plain text is not recommended approach, there are a couple of alternatives, reading the password from the stdin

hadoop fs -rm -r /user/$USER/cities
sqoop import \
      --connect jdbc:mysql://localhost/sqoop \
      --username sqoop \
      --table cities \
      -P

#but this cannot be used as a part of automation scripts as it requires user intervention to provide the password, other alternative is to use the `--password-file` option

#First create a password file, that is read-only for the user who is creating the file in HDFS


```
echo -n "sqoop" > sqoop.password
hadoop fs -put sqoop.password /user/$USER/
hadoop fs -chmod 400 /user/$USER/sqoop.password
rm sqoop.password
```

#and using the password file in sqoop commands

hadoop fs -rm -r /user/$USER/cities
sqoop import \
    --connect jdbc:mysql://localhost/sqoop \
    --username sqoop \
    --password-file /user/$USER/sqoop.password \
    --table cities


##Compress

#Compressed files occupy less storage space, but with a caveat, compressed files except LZO, bz2 cannot be split and hence disallow parallel processing on the HDFS data.
hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*

 #With default gz compression
 sqoop import --connect jdbc:mysql://localhost/sqoop --username sqoop --target-dir /etl/input/cities --table cities --compress --password-file /user/$USER/sqoop.password

 hadoop fs -rm -r /user/$USER/cities
 hadoop fs -rm -r /etl/input/*
 #With bz2 compression using a different codec
 sqoop import --connect jdbc:mysql://localhost/sqoop --username sqoop --target-dir /etl/input/cities --table cities --compress --password-file /user/$USER/sqoop.password --compression-codec org.apache.hadoop.io.compress.BZip2Codec

##Using --direct to speed up transfer

sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --table cities \
  --direct

#--direct uses native utilities, if provided my the DB vendor to perform the transfer, ex. mysqldump

##Type mapping

#Sqoop lets you map type between the DB and HDFS, this ensures any type incompatibility that may arise are handled at the data ingestion itself

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*

sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --table cities \
  --map-column-java id=Long,country=String,city=String \
  --target-dir /etl/input/cities \
  --compress

##Controlling Parallelism

#Sqoop lets you control parallelism by increasing the number of mappers that will read from DB, that is concurrent tasks that will be executed against the DB, it may not always have desired effect, as it can increase the load and may adversely affect the performance, however if sqoop can find that there are no enough data to run given parallel task, it will fall back to the default number

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*

sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --table cities \
  --target-dir /etl/input/cities \
  --num-mappers 10

##Importing null

#by default sqoop imports null as string 'null', but that may differ between environments and your target format and storage, to handle sqoop provides --null-string and --null-non-string options, by default HDFS represents nulls as \N so the null has to be mapped to \N when importing to HDFS

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --table cities \
  --target-dir /etl/input/cities \
  --null-string '\\N' \
  --null-non-string '\\N'


##Import all tables

#Sqoop allows import of entire database with a single command

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop import-all-tables \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --exclude-tables visits \
  --warehouse-dir /etl/input \
  --num-mappers 10 \
  --null-string '\\N' \
  --null-non-string '\\N'


> **NOTE**:
 > 1. use --exclude-tables to exclude a selected tables, specify
    comma-separated list of table names
> 2. --target-dir which is used to specify data dir for a single table can no longer be used, use --warehouse-dir instead to specify target dir for all the tables

##Incremental Import

It is always necessary and pertinent that, there should always be a way to incrementally import changes rather that importing the whole database everytime we import data into HDFS, importing only the deltas will save a load on both DB and HDFS

sqoop provides `--incremental` option for this purpose, and it comes with two modes
1. append
2. lastmodified

**append**

append is for immutable tables, that just adds new record and does not modifies the existing records, ex: audit tables, log tables etc.

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --table visits \
  --warehouse-dir /etl/input \
  --password-file /user/$USER/sqoop.password \
  --incremental append \
  --check-column id \
  --last-value 1

#the above command will import all the rows after the specified `--last-value` of 1 from the `--check-column` id

**lastmodified**

Is used for mutable tables, it imports all rows whose timestamp column specified with `--check-column`, date or time values if greater than the value specified with the `--last-value` option
The command runs two jobs, one to import all the matching rows into a temp location and second to merge the values imported with the current values

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --table visits \
  --warehouse-dir /etl/input2 \
  --password-file /user/$USER/sqoop.password \
  --incremental lastmodified \
  --check-column last_update_date \
  --last-value "2013-05-22 01:01:01" \
  --merge-key id

`--merge-key` specify the key to used for merging the modifications

##Sqoop Jobs

Sqoop jobs lets you automate the incremental imports by allowing sqoop to preserve the state of the job and reexecute from the last saved state, thus in this case saving the `--last-value` across executions, thus reducing the manual overhead.

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop job \
  --create visits \
  -- \
 import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --table visits \
  --warehouse-dir /etl/input \
  --password-file /user/$USER/sqoop.password \
  --incremental append \
  --check-column id \
  --last-value 0 \
  --merge-key id


#List the jobs that are stored in the sqoop metastore

sqoop job --list


#Describe a sqoop job
sqoop job --show visits

#execute a job
sqoop job --exec visits

##Import with Free form queries

It is possible to import with free form queries, specially useful if you have a normalized set of tables and you want to import materialized (denormalized) view of the table into Hadoop, you replace the `--table` with `--query`.

> **Note**: try avoiding complex queries however as they unnecessary overhead to your ETL, materialize the query into a temp table and import from the temp table.

hadoop fs -rm -r /user/$USER/cities
hadoop fs -rm -r /etl/input/*
sqoop import \
  --connect jdbc:mysql://localhost/sqoop \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --query 'SELECT normcities.id, countries.country, normcities.city FROM normcities JOIN countries USING(country_id) WHERE $CONDITIONS' \
  --split-by id \
  --target-dir /etl/input/cities \
  --mapreduce-job-name import-normalized-cities \
  --boundary-query "select min(id), max(id) from normcities"

To achieve parallelism sqoop by default runs `min()`, `max()` on the primary-key to slice the data and run concurrent mappers, with free-form queries, the min max has to be run by materializing the query, which has significant cost, to avoid, you can specify query to identify the boundary values with `--boundary-query`, and you are free to select from anywhere and any table, the first column is used as a min and the second max.

> **NOTE**: `--split-by` is used specify the column to be used for slicing the data for parallel tasks

The `$CONDITIONS` given with the where clause in `--query` will be used by the mapper tasks to specify the slicing conditions for concurrent mappers.

> **NOTE**: To avoid ambiguity in column names across tables while using free-form queries, assign alias to the column names

#Exporting with Sqoop
Sqoop also let's you export data from HDFS onto your DB. To do so the table must already exist in your DB and it need not be empty, but the data you are offloading shouldn't violate any constraint

sqoop export \
  -Dsqoop.export.records.per.statement=10 \
  -Dsqoop.export.statements.per.transaction=10 \
  --connect jdbc:mysql://localhost/sqoop_export \
  --username sqoop \
  --password-file /user/$USER/sqoop.password \
  --table cities \
  --export-dir /etl/input/cities \
  --staging-table staging_cities \
  --batch \
  --clear-staging-table

sqoop uses `export` tool to export the data, you specify the `--table` to export and the HDFS directory from which it is supposed to export using `--export-dir` , by default the export happens row-by-row which has a lot of overhead interms of connections and transactions, to workaround that use `--batch` which batches multiple rows into a single statement, you could also control the number of rows sent per query using `-Dsqoop.export.records.per.statement=10` and number of rows to be inserted before the transaction is committed using `-Dsqoop.export.statements.per.transaction=10`, these 3 parameters lets you optimize the inserts based on the underlying DB.

`--staging-table` lets you specify a staging table, which should be as same as the target table interms of columns and column definitions, the records are inserted into staging table first, once all the mapreduce jobs are successfully completed, the rows are then transferred to the target table. `--clear-staging-table` ensures the staging table is truncated (if supported by the DB) before the export.

##Updates

If the data in the HDFS is mutable, sqoop provides mechanism to update the existing data

sqoop export \
	-Dsqoop.export.records.per.statement=10 \
	-Dsqoop.export.statements.per.transaction=10 \
	--connect jdbc:mysql://localhost/sqoop_export \
	--username sqoop \
	--password-file /user/$USER/sqoop.password \
	--table cities \
	--export-dir /etl/input/cities \
	--update-key id \
	--update-mode allowinsert \
	--batch

`--update-key` can be used to specify a comma separated list of columns to be used as the look-up key for the row selection. Ex. if a table has columns c1, c2, c3, c4 and `--update-key c3,c4` is given the resulting `UPDATE` would be

  UPDATE table SET c1 = ?, c2 = ? WHERE c3 = ? and c4 = ?

The lookup values, obviously need not be altered.

If there is a case where there are new columns are added to the source HDFS file, it will not be exported as a part of the UPDATE(of-course!!!), to handle this use `--update-mode allowinsert` , to use this feature however it must be supported by the target DB, right now Oracle and Mysql (without `--direct` mode). The update cannot be used arbitrary updates, however, only solution is to truncate the target table and do a full export.

**Exporting only a subset of columns**

If there is a mismatch between the HDFS data and the target table we can use `--columns` to specify the comma separated list of columns to export, given the target DB supports specifying list of columns during INSERT.

sqoop export \
	-Dsqoop.export.records.per.statement=10 \
	-Dsqoop.export.statements.per.transaction=10 \
	--connect jdbc:mysql://localhost/sqoop_export \
	--username sqoop \
	--password-file /user/$USER/sqoop.password \
	--table cities \
	--export-dir /etl/input/cities \
	--columns id,country,city \
	--update-key id \
	--update-mode allowinsert \
--input-null-string '\\N' \
  --input-null-non-string '\\N' \
	--batch

additionally the target table must either allow or have a default value configured.
