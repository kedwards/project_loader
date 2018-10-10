#!/bin/sh
options=':the:u:p:'
user=wdcnv

function help () {
  cat <<-END

Project OneTimer Load Script
----------------------------
Usage: $0 -e ENV -p PASSWORD [-t][-u wdcnv]
------
   -e | Workday enviornment to run against.
   -u | Workday user (default: wdcnv).
   -p | Workday password.
   -t | Test connection to the Workday DB (requires -e and -p, optionally -u).
   -h | Display this help.

END
}

function test () {
  echo "exit" | sqlplus -L ${user}/${pass}@${env} | grep Connected > /dev/null
  if [ $? -eq 0 ]
  then
    echo "Connection to ${env} is OK"
  else
    echo "Connection to ${env} is NOT OK"
  fi
}

while getopts $options option
do
  case $option in
    e  ) env=$OPTARG;;
    p  ) pass=$OPTARG;;
    u  ) user=$OPTARG;;
    t  ) test=TRUE;;
    h  ) help
         exit 0;;
    \? ) echo "Invalid Option: -$OPTARG" 1>&2
         help
         exit 1;;
    *  ) help
         exit 1;;
  esac
done

shift $(($OPTIND - 1))

if [[ -z ${env} ]] || [[ -z ${pass} ]]; then
  help
  exit 1
fi

if [[ ${test} ]]
then
  test
  exit 0
fi

for d in ./projects/*/;
do (
  cd "$d"
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
);
done

sqlplus.exe ${user}/${pass}@${env} @projects/export.sql
