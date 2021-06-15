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

cursor.execute("DROP TABLE organizations_locations")
cursor.execute("DROP TABLE organizations_tags")
cursor.execute("DROP TABLE projects_topics")

cursor.execute("DROP TABLE locations")
cursor.execute("DROP TABLE organizations")
cursor.execute("DROP TABLE projects")
cursor.execute("DROP TABLE tags")
cursor.execute("DROP TABLE topics")

cursor.execute("DROP TABLE periods")
cursor.execute("DROP TABLE states_regions")

connection.close()
