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


zipurl = "https://github.com/codeforamerica/brigade-project-index/archive/index/v1.zip"

# download again? or only if it doesn't exist or it's old?

ziprep = urlopen(zipurl)
zfile = ZipFile(BytesIO(ziprep.read()))
zfile.extractall('/tmp') #extract in local dir instead?

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

project_columns = ['name','description','code_url','last_update', 'organization_id']
sql_save_proj = "INSERT INTO `projects` (`name`,`description`,`code_url`,`last_pushed_within`,`organization_id`) VALUES (%s, %s, %s, %s, %s)" 

i = 0
y = 0
directory = '/tmp/brigade-project-index-index-v1/projects'

with os.scandir(directory) as directories:
  for dir in directories:
    y += 1
    logging.info("Processing Organization %s", dir.name.encode("utf-8"))
    cursor.execute(sql_get_org, ([dir.name]))
    row = cursor.fetchone()
    if(row == None):
      logging.debug("Empty directory %s", dir.name)
      continue;
	  
    org_id = row[0]
    logging.debug("Organization ID %i", org_id)
    if(dir.is_dir()):
      i = 0
      with os.scandir(dir) as files:
        for file in files:
          logging.info("Processing %s", file.name.encode("utf-8"))
			
          try: 

            f = open(file.path, "r", encoding='utf-8')
            dict = toml.load(f)

            cursor.execute(sql_save_proj, (dict.get(project_columns[0]), dict.get(project_columns[1]), dict.get(project_columns[2]), dict.get('last_pushed_within'), org_id))
            project_id = cursor.lastrowid
          except UnicodeEncodeError as ue_err:
            logging.exception("Error in directory %s", dir.name)
            continue            		  
          except Exception as error:
            logging.exception("Error in directory %s", dir.name)
            continue
			
          logging.debug("Inserted project %s with id %i", dict.get(project_columns[0]), project_id)

          i += 1

          topics = dict.get('topics')
          if(topics != None):
            for topic in topics:
              # first check if already exist
              sql = "select id from topics where topic = %s"
              cursor.execute(sql, ([topic]))
              topic_id = cursor.fetchone()
              if(topic_id == None):
                sql = "INSERT INTO `topics` (`topic`) VALUES (%s)" 
                cursor.execute(sql, ([topic]))
                topic_id = cursor.lastrowid
              sql = "INSERT INTO `projects_topics` (`project_id`,`topic_id`) VALUES (%s, %s)" 
              cursor.execute(sql, (project_id, topic_id))
		  
      logging.info("Processed %i Projects for Organization %s", i, dir.name)

logging.info("Processed %i Organizations", y)
logging.info("Processed %i Projects", y*i)

connection.commit()

connection.close()


