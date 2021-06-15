This folder contains scripts to create and populate a mysql database with the toml files created by the brigade-project-index crawler process https://github.com/codeforamerica/brigade-project-index.
- brigade-index-and-taxonomy.sql creates the database schema. Simply run it from any sql client. If it doesn't exist it creates the database first.
- The scripts (below) to populate the data use 4 environment variables:
 - DB_HOST
 - DB_USER
 - DB_PWD' // password
 - DB_DB // database

- org-toml-2-mysql.py downloads the https://github.com/codeforamerica/brigade-project-index/archive/index/v1.zip data produced by the crawler.
It extracts the organizations (brigades) data in /tmp folder and populate some database tables.

- proj-toml-2-mysql.py downloads the https://github.com/codeforamerica/brigade-project-index/archive/index/v1.zip data produced by the crawler.
It extracts the projects (again in /tmp folder, so it should be possible to skip this step if previously downloaded data) 
information and populate some database tables.

- ToDo/Improve
  - Find a way to update the database with continuosly with the most recent data produced by the crawler.
  Right now this could be done only deleting all data and run the org and proj loading scripts again.
  - When extracting the toml data files in /tmp, first we should delete the previous extract otherwise older files will be processed again.
  