#Entry point of program
###import modules and classes
from database import configs
from database import db
from database import articleData
import uuid
#import pandas as pd

#functions

###Create a new session with a session ID
def generate_session_id():
    sql_1 =  "INSERT INTO [dbo].[Sessions]([Executor]) VALUES('WebScraper'); SELECT @@IDENTITY;"
    return sql_1

##get all actives sites from the database
def get_active_sites():
    pass

###close the session and update the status in the database
def close_session():
    pass

###https://docs.python.org/3/library/uuid.html - create uuid4() to create a new session

sessionID = generate_session_id()
print("Session ID:", sessionID)



# Read all actives sites

#create a new session with session id

#Create a scraper object

#iterate over all active sites
    #scrape the sites and store all the articles
    #store the articles in the database

# Close the session

#from database.db import connect_db

module = ''



try:

    ###https://www.sqlnethub.com/blog/how-to-resolve-im002-microsoftodbc-driver-manager-data-source-name-not-found-and-no-default-driver-specified-0-sqldriverconnect/
    connection = db.connect_db()
    print("Connect to the database")
    sites = db.queryData(connection, "SELECT Id, Name, URL, Module, Method, Configs FROM dbo.Sites WHERE Active = 1")
    print(sites)
    
    # session = db.queryData(connection, generate_session_id())
    session = db.queryData(connection, "SELECT @@IDENTITY from dbo.Sessions;")
    print("Session-ID: " + session)
    
except Exception as ex:
    print("Error: " + str(ex))

finally:

    connection.close()
    print("done.")


#Generate Session ID
