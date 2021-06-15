import toml
import MySQLdb
import os
import logging

# Read the database credentials from environmental variables
db_host = os.environ.get('DB_HOST')
db_user = os.environ.get('DB_USER')
db_pwd = os.environ.get('DB_PWD')
db_db = os.environ.get('DB_DB')

connection = MySQLdb.connect(host=db_host, user=db_user, password=db_pwd, db=db_db)

logging.basicConfig(format='%(asctime)s - %(message)s', filename="cfa_index_sql.log", level=logging.DEBUG)

logging.info("Connected to DB %s", db_db)

cursor= connection.cursor()

cursor.execute("TRUNCATE TABLE organizations_locations")
cursor.execute("TRUNCATE TABLE organizations_tags")
cursor.execute("TRUNCATE TABLE projects_topics")

cursor.execute("TRUNCATE TABLE locations")
cursor.execute("TRUNCATE TABLE organizations")
cursor.execute("TRUNCATE TABLE projects")
cursor.execute("TRUNCATE TABLE tags")
cursor.execute("TRUNCATE TABLE topics")

connection.close()
