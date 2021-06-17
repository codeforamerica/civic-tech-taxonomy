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


i=0

zipurl = "https://github.com/codeforamerica/brigade-project-index/archive/index/v1.zip"

#directory = 'brigade-project-index-index-v1/organizations'


ziprep = urlopen(zipurl)
zfile = ZipFile(BytesIO(ziprep.read()))
zfile.extractall('/tmp')

directory = "/tmp/brigade-project-index-index-v1/organizations"

connection = MySQLdb.connect(host=db_host, user=db_user, password=db_pwd, db=db_db)

logging.basicConfig(format='%(asctime)s - %(message)s', 
                    handlers=[
                      logging.FileHandler("db_loader.log"),
                      logging.StreamHandler()
                    ],					
                    level=logging.DEBUG)

logging.info("Connected to DB %s", db_db)

cursor = connection.cursor()

org_columns = ["name", "type", "website"]

for entry in os.scandir(directory):
  logging.info("Processing %s", entry)
  
  dict = toml.load(entry.path)

  i +=1

  org_values = [dict.get(org_columns[0],""), dict.get(org_columns[1],""), dict.get(org_columns[2],"")]

  sql = "INSERT INTO `organizations` (`name`,`type`,`website`) VALUES (%s, %s, %s)"

  cursor.execute(sql, (org_values[0],org_values[1], org_values[2]))
  org_id = cursor.lastrowid
  logging.info("Inserted Organization %s id %i", org_values[0], org_id)

  tags = dict['tags']
  tag_id=0
  for tag in tags:
    if(len(tag) > 1):
      # Check if tag already exist
      sql = "select id from tags where tag = %s"
      cursor.execute(sql, (tag,))
      tag_id = cursor.fetchone()
      if(tag_id == None):
        sql = "INSERT INTO `tags` (`tag`) VALUES (%s)"
        cursor.execute(sql, ([tag]))
        tag_id = cursor.lastrowid
      sql = "INSERT INTO `organizations_tags` (`organization_id`, `tag_id`) VALUES (%s,%s)"
      cursor.execute(sql, ([org_id], [tag_id]))

  location = dict.get('location', "")
  if(location == ""):
    continue

  logging.debug(location.get("city",""))
	
  location_columns = ['city','state','country','continent']
  location_values = [location.get(location_columns[0],""), location.get(location_columns[1],""), location.get(location_columns[2],""), location.get(location_columns[3],"")]

  #should first check if already exist
  sql = "select id from locations where city = %s and state= %s and country = %s and continent = %s"
  cursor.execute(sql, (location_values))
  location_id = cursor.fetchone()
  if(location_id == None):
    sql = "INSERT INTO `locations` (`city`,`state`,`country`,`continent`) VALUES (%s,%s,%s,%s )"
    logging.debug(sql)
    cursor.execute(sql, (location[location_columns[0]], location[location_columns[1]], location[location_columns[2]], location[location_columns[3]]))
    location_id = cursor.lastrowid
  
  logging.debug("location_id %s", location_id)

  sql = "INSERT INTO `organizations_locations` (`organization_id`,`location_id`) VALUES (%s,%s)"
  cursor.execute(sql, (org_id, location_id))

logging.info("Inserted %i Organizations", i)

connection.commit()

connection.close()
