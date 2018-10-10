#!/bin/sh
env=${1}
user=${2}
pass=${3}

sqlplus -s /nolog << EOF
connect ${user}/${pass}@${env};

whenever sqlerror exit sql.sqlcode;
set echo off
set heading off

@create.sql

exit;
EOF

sqlldr userid=${user}/${pass}@${env} control=sqlldr.ctl log=sqlldr.log \
  bad=sqlldr.bad discard=sqlldr.dsc
