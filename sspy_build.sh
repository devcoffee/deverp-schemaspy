#!/usr/bin/env bash
# 
# Script para geração automatizada do SchmaSpy à partir de um BD BrERP/iDempiere
# 
# Antes de executar, assegure-se de ter o java e o pacote graphviz instalados
# e configurados em seu ambiente
#
# 

DOTFILE="config.env"
DIR="./public"

REQUIRED_TOOLS=(
  "java"
  "dot"
)

SCHEMASPY_JAR="lib/schemaspy-app.jar"
# Run: java -jar lib/schemaspy-app.jar -dbhelp
# Even though we are connecting to Postgres version 13, the highest database type listed is pgsql11 ... 
DATABASE_TYPE="pgsql11"
JDBC_DRIVERS="lib/driver"

for tool in ${REQUIRED_TOOLS[@]}; do
  if ! command -v ${tool} >/dev/null; then
    echo "${tool} is required ..."
    exit 1
  fi
done

if [[ ! -f ${DOTFILE} ]]; then
  echo "File ${DOTFILE} is required ..."
  exit 1
fi

source ${DOTFILE}

# See https://schemaspy.readthedocs.io/en/latest/configuration/commandline.html
java -jar ${SCHEMASPY_JAR} -debug -imageformat svg -noimplied -degree 1 -t ${DATABASE_TYPE} -dp ${JDBC_DRIVERS} -host ${PGHOST} -port ${PGPORT} -db ${PGDATABASE} -s ${PGSCHEMA} -u ${PGUSER} -p ${PGPASSWORD} -o ${DIR}

cp -pr CNAME public/

echo "Completed ${0} in ${SECONDS}s"