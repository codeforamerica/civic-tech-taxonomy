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

cursor.execute("DROP TABLE taxonomy_tags")
cursor.execute("DROP TABLE taxonomy_synonyms")

connection.commit()

connection.close()
