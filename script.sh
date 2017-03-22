#!/bin/sh
set -e errexit
set -o pipefail
FILES=*.yml
oldvalue=`cat $files`
gem install yaml-lint
gem install i18n_yaml_sorter
for f in $FILES
do
  yaml-lint $f
  sort_yaml < $f > $f.tmp && mv $f.tmp $f
  newvalue=`cat $files`
  if [ $newvalue == $oldvalue ]
  then 
    echo "Done"
  else
    exit 1
  fi
done
