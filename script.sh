#!/bin/sh
FILES=*.yml
gem install yaml-lint
gem install i18n_yaml_sorter
for f in $FILES
do
  echo "Processing $f"
  yaml-lint $f
  sort_yaml < $f > $f.tmp && mv $f.tmp $f
  echo "Done $f"
done
