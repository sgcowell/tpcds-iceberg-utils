#!/bin/zsh
# usage: gen-create-tables-script.sh <schema> <csv-input-files-dir>

scriptdir=${0:A:h}
schema=$1
inputdir=$2

identifier_type=long
date_type=date
time_type=timestamp
decimal5_type=float
decimal7_type=float
decimal15_type=double

tblproperties="'format-version'='2', 'write.delete.mode'='merge-on-read'"

for table_info_file in $scriptdir/tables/*.schema
do 
    table_name=`basename $table_info_file .schema`

    partition_spec_file=$scriptdir/tables/$table_name.partition_spec
    if [ -e $partition_spec_file ]
    then
        partition_spec=`cat  $scriptdir/tables/$table_name.partition_spec`
    else
        partition_spec=UNPARTITIONED
    fi
    sqlfile=$sqldir/$table_name'.sql'

    awk -F '|' -v schema=$schema -v table_name=$table_name -v partition_spec=$partition_spec -v tblproperties=$tblproperties -v identifier_type=$identifier_type -v date_type=$date_type -v time_type=$time_type -v decimal5_type=$decimal5_type -v decimal7_type=$decimal7_type -v decimal15_type=$decimal15_type -v source_csv_path=$inputdir/$table_name'.dat' -f $scriptdir/create-table.awk $table_info_file
done