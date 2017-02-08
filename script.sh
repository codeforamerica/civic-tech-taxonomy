#!/bin/sh
gem install yaml-lint
yaml-lint topics.yml #Recomended: Put all the yml files in a folder such as yml so you can do yaml-lint yml so you do not have to go through all the trouble of adding each file one by one.
sort_yaml < topics.yml > topics.sorted.yml && mv topics.sorted.yml topics.yml
