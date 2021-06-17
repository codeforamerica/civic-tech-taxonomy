import toml
import MySQLdb
import os

import logging
from io import BytesIO
from urllib.request import urlopen
from zipfile import ZipFile

from dotenv import load_dotenv

load_dotenv()  # take environment variables from .env.

# Read the database credentials from environmental variables
db_host = os.environ.get('DB_HOST')
db_user = os.environ.get('DB_USER')
db_pwd = os.environ.get('DB_PWD')
db_db = os.environ.get('DB_DB')


zipurl = "https://github.com/codeforamerica/civic-tech-taxonomy/archive/master.zip"

ziprep = urlopen(zipurl)
zfile = ZipFile(BytesIO(ziprep.read()))
zfile.extractall('/tmp')

logging.basicConfig(format='%(asctime)s - %(message)s', 
                    handlers=[
                      logging.FileHandler("db_loader.log"),
                      logging.StreamHandler()
                    ],					
                    level=logging.DEBUG)

connection = MySQLdb.connect(host=db_host,
                             user=db_user,
                             password=db_pwd,
                             db=db_db,
                             use_unicode=True,
                             charset='utf8')

logging.info("Connected to DB %s", db_db)
							 
cursor = connection.cursor()

sql_get_org = "select id from organizations where name = %s"

sql_save_tags = "INSERT INTO `taxonomy_tags` (`id`,`display_name`) VALUES (%s, %s)" 
sql_save_synonyms = "INSERT INTO `taxonomy_synonyms` (`tag_id`,`synonym`) VALUES (%s, %s)" 

i = 0
y = 0
directory = '/tmp/civic-tech-taxonomy-master/issues'

with os.scandir(directory) as files:
  for file in files:
    y += 1
    fname = file.name.encode("utf-8")
    logging.info("Processing file %s", fname)
    try:
      f = open(file.path, "r", encoding='utf-8')
      dict = toml.load(f)
      logging.debug(dict)
      id = dict.get("id")
      display_name = dict.get("display_name")
      synonyms = dict.get("synonyms")
	  
      cursor.execute(sql_save_tags, (id, display_name))
 
      if synonyms == None:
        continue
		
      for synonym in synonyms:
        cursor.execute(sql_save_synonyms, (id, synonym))

    except UnicodeEncodeError as ue_err:
      logging.exception("Error processing %s", fname)
      continue            		  
    except Exception as error:
      logging.exception("Error processing %s", fname)
      continue
	
    logging.debug("Inserted tags and synonyms from %s", fname);

logging.info("Processed %i toml files", y)

connection.commit()

connection.close()


