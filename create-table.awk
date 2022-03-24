BEGIN { 
    qualified_table_name = schema "." table_name
    csv_table_name = table_name "_source_csv"
    drop_table_sql = "DROP TABLE IF EXISTS " qualified_table_name ";\n"
    drop_source_csv_table_sql = "DROP TABLE IF EXISTS " csv_table_name ";\n"
    create_table_sql = "CREATE TABLE " qualified_table_name " ("
    create_source_csv_table_sql = "CREATE TABLE " csv_table_name " ("

    insert_sql = "INSERT INTO " qualified_table_name " SELECT "
}

{ 
    if ($2 == "identifier") {
        col_type = identifier_type
    } else if ($2 == "date") {
        col_type = date_type
    } else if ($2 == "time") {
        col_type = time_type
    } else if ($2 == "decimal(5,2)") {
        col_type = decimal5_type
    } else if ($2 == "decimal(7,2)") {
        col_type = decimal7_type
    } else if ($2 == "decimal(15,2)") {
        col_type = decimal15_type
    } else {
        col_type = $2
    }

    create_table_sql = create_table_sql sep "\n    " $1 " " col_type
    create_source_csv_table_sql = create_source_csv_table_sql sep "\n    " $1 " " col_type

    insert_expr = $1
#    requires_cast = col_type !~ /^(char|varchar)/
 
#    if (requires_cast) {
#        insert_expr = "CAST(" $1 " AS " col_type ")"
#    }

    insert_sql = insert_sql sep "\n    " insert_expr
}
{ sep = "," }

END {
    if (partition_spec != "UNPARTITIONED") {
        partitioned_by = " PARTITIONED BY (" partition_spec ")"
        distributed_by = " DISTRIBUTE BY " partition_spec
    }
    create_table_sql = create_table_sql "\n) USING iceberg" partitioned_by " TBLPROPERTIES (" tblproperties ");\n" 
    create_source_csv_table_sql = create_source_csv_table_sql "\n) USING csv\nOPTIONS ( header false, delimiter '|' )\nLOCATION '" source_csv_path "';\n"
    insert_sql = insert_sql "\nFROM " csv_table_name distributed_by ";\n"
    
    print "-- " table_name "\n"
    print drop_table_sql
    print drop_source_csv_table_sql
    print create_table_sql
    print create_source_csv_table_sql
    print insert_sql
    print drop_source_csv_table_sql
}