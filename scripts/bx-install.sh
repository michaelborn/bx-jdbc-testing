#!/usr/bin/env sh
#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
##############################################################################
##
##  boxlang jar downloader and module installer script for UN*X
##
##############################################################################
BOXLANG_HOME=$HOME/.boxlang

rm -rf $BOXLANG_HOME/lib/temp $BOXLANG_HOME/modules
mkdir -p $BOXLANG_HOME $BOXLANG_HOME/lib $BOXLANG_HOME/lib/temp $BOXLANG_HOME/modules

curl -o $BOXLANG_HOME/lib/boxlang-1.0.0-all.jar https://ortus-temp.s3.amazonaws.com/jericho/libs/boxlang-1.0.0-all.jar
curl -o $BOXLANG_HOME/lib/boxlang-1.0.0-web.jar https://ortus-temp.s3.amazonaws.com/jericho/libs/boxlang-1.0.0-web.jar

module_esapi_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-esapi/bx-esapi-1.0.0.zip
module_esapi_zip=bx-esapi-1.0.0.zip
module_esapi_foldername=bx-esapi
mkdir $BOXLANG_HOME/modules/$module_esapi_foldername
curl $module_esapi_runtime -o $BOXLANG_HOME/lib/temp/$module_esapi_zip 
unzip $BOXLANG_HOME/lib/temp/$module_esapi_zip -d $BOXLANG_HOME/modules/$module_esapi_foldername

module_postgresql_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-postgresql/bx-postgresql-1.0.0.zip
module_postgresql_zip=bx-postgresql-1.0.0.zip
module_postgresql_foldername=bx-postgresql
mkdir $BOXLANG_HOME/modules/$module_postgresql_foldername
curl $module_postgresql_runtime -o $BOXLANG_HOME/lib/temp/$module_postgresql_zip 
unzip $BOXLANG_HOME/lib/temp/$module_postgresql_zip -d $BOXLANG_HOME/modules/$module_postgresql_foldername

module_derby_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-derby/bx-derby-1.0.0.zip
module_derby_zip=bx-derby-1.0.0.zip
module_derby_foldername=bx-derby
mkdir $BOXLANG_HOME/modules/$module_derby_foldername
curl $module_derby_runtime -o $BOXLANG_HOME/lib/temp/$module_derby_zip 
unzip $BOXLANG_HOME/lib/temp/$module_derby_zip -d $BOXLANG_HOME/modules/$module_derby_foldername

module_mysql_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-mysql/bx-mysql-1.0.0.zip
module_mysql_zip=bx-mysql-1.0.0.zip
module_mysql_foldername=bx-mysql
mkdir $BOXLANG_HOME/modules/$module_mysql_foldername
curl $module_mysql_runtime -o $BOXLANG_HOME/lib/temp/$module_mysql_zip 
unzip $BOXLANG_HOME/lib/temp/$module_mysql_zip -d $BOXLANG_HOME/modules/$module_mysql_foldername

module_mariadb_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-mariadb/bx-mariadb-1.0.0.zip
module_mariadb_zip=bx-mariadb-1.0.0.zip
module_mariadb_foldername=bx-mariadb
mkdir $BOXLANG_HOME/modules/$module_mariadb_foldername
curl $module_mariadb_runtime -o $BOXLANG_HOME/lib/temp/$module_mariadb_zip 
unzip $BOXLANG_HOME/lib/temp/$module_mariadb_zip -d $BOXLANG_HOME/modules/$module_mariadb_foldername

module_mssql_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-mssql/bx-mssql-1.0.0.zip
module_mssql_zip=bx-mssql-1.0.0.zip
module_mssql_foldername=bx-mssql
mkdir $BOXLANG_HOME/modules/$module_mssql_foldername
curl $module_mssql_runtime -o $BOXLANG_HOME/lib/temp/$module_mssql_zip 
unzip $BOXLANG_HOME/lib/temp/$module_mssql_zip -d $BOXLANG_HOME/modules/$module_mssql_foldername

module_oracle_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-oracle/bx-oracle-1.0.0.zip
module_oracle_zip=bx-oracle-1.0.0.zip
module_oracle_foldername=bx-oracle
mkdir $BOXLANG_HOME/modules/$module_oracle_foldername
curl $module_oracle_runtime -o $BOXLANG_HOME/lib/temp/$module_oracle_zip 
unzip $BOXLANG_HOME/lib/temp/$module_oracle_zip -d $BOXLANG_HOME/modules/$module_oracle_foldername

module_hypersql_runtime=https://ortus-temp.s3.amazonaws.com/boxlang-modules/bx-hypersql/bx-hypersql-1.0.0.zip
module_hypersql_zip=bx-hypersql-1.0.0.zip
module_hypersql_foldername=bx-hypersql
mkdir $BOXLANG_HOME/modules/$module_hypersql_foldername
curl $module_hypersql_runtime -o $BOXLANG_HOME/lib/temp/$module_hypersql_zip 
unzip $BOXLANG_HOME/lib/temp/$module_hypersql_zip -d $BOXLANG_HOME/modules/$module_hypersql_foldername