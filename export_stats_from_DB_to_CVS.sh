#!/bin/bash
# params to introduce along with the script
# field 1: DB name
# field 2: search beginning date
# field 3: search end date
# field 4: machine name / IP @
# field 5: user name
# field 6: password
# field 7: port
# field 8: mysql directory ended by '/'
# field 9: socket

# for help purpose
if [ $1 == "--help" ];
  then echo -e "usage : $0 [DB_name] [Start date YYMMDD] [End date YYMMDD ] [Host] [user] [password] [Port] [MySQL directory] [Socket]";
else
  date=$2;
  endDate=$(date -d $3 +"%y%m%d");
  date2=$(date -d $date +"%y%m%d");
  while [ $endDate -ge $date2 ]; do
    echo "$date;"|tr '\n' ' '
    date=$(date +%Y-%m-%d -d "$date +1 day");
    $8/mysql --host=$4 --user=$5 --password=$6  --port=$7 --socket=$9 $1 -N -B -e "select distinct(login_name) as '' from bugs_activity,profiles where bug_when like \"$date%\" and userid=who" |tr '\n' ' ';
    echo -e ";"|tr '\n' ' '
    $8 --host=$4 --user=$5 --password=$6  --port=$7 --socket=$9 $1 -N -B -e "select count(distinct(who)) as '' from bugs_activity where bug_when like \"$date%\"" |tr '\n' ' ';
    echo -e "\n";
    endDate=$(date -d $3 +"%y%m%d");
    date2=$(date -d $date +"%y%m%d");
  done;
fi;
