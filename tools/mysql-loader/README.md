This folder contains scripts to create and populate a mysql database with the toml files present in this repository.
- The scripts use 4 environment variables:
 - DB_HOST
 - DB_USER
 - DB_PWD' // password
 - DB_DB // database

This set of scripts share the database with similar scripts in the project-index repo (https://github.com/codeforamerica/brigade-project-index).

A github Action (.github/workflows) create a virtual environment and create the connection with the database (https://codeforamerica.github.io/nac-sandbox-cluster/civic-tech-taxonomy/mysql/). This action runs on commits to master branch.
Then it runs the following scripts:
- tools/mysql-loader/drop-schema.sql to drop the database tables and views
- tools/mysql-loader/create-schema.sql to create the database tables and views
- tools/mysql-loader/taxonomy-toml-2-mysql.py to populate the data from the repository (it downloads the repo content in /tmp in order to process it)

The portion of the database used by these scripts is

![image](https://user-images.githubusercontent.com/16311029/122997735-4b6f7a80-d37a-11eb-970b-053e3113b303.png)

- ToDo/Improve
  - Perhaps there is no need to download the toml data files in /tmp (otherwise, first we should delete the previous extract otherwise older files will be processed again).
  - To include other folders in the pushing to mysql (right now it only uses "issues" which may be renamed to "topics").
