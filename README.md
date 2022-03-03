Prereqs:

- TPC-DS dsdgen - you can build from source from https://github.com/gregrahn/tpcds-kit. 
- Spark 3.2

To create Iceberg tables on top of a TPC-DS dataset:

- Generate base TPC-DS data files using dsdgen - see run-dsdgen.sh for example command line.  You can download source for dsdgen that can compile on MacOS at https://github.com/gregrahn/tpcds-kit.
- Run gen-create-tables-script.sh to generate a SQL script that can be run via Spark SQL to create Iceberg tables from the generated text data files.

For example, if I want to create my Iceberg tables under ~/warehouse/tpcds, and I will register that location as a catalog in Spark as 'tpcds':

./gen-create-tables-script.sh tpcds <path-to-tpcds-data-files> > tpcds.sql

You can then run the script in Spark using something like:

$HOME/spark/spark-3.2.0-bin-hadoop3.2/bin/spark-sql --packages org.apache.iceberg:iceberg-spark-runtime-3.2_2.12:0.13.0 \
    --conf spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions \
    --conf spark.sql.catalog.spark_catalog=org.apache.iceberg.spark.SparkSessionCatalog \
    --conf spark.sql.catalog.spark_catalog.type=hive \
    --conf spark.sql.catalog.tpcds=org.apache.iceberg.spark.SparkCatalog \
    --conf spark.sql.catalog.tpcds.type=hadoop \
    --conf spark.sql.catalog.tpcds.warehouse=$HOME/warehouse/tpcds \
    --conf spark.sql.iceberg.handle-timestamp-without-timezone=true \
    --conf spark.executor.memory=4g \
    --conf spark.driver.memory=4g \
    -f tpcds.sql

