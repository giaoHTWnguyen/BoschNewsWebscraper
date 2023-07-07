#Entry point of program
###import modules and classes
from database import configs
from database import db
from database import articleData
import traceback

import sys
import os
sys.path.append(os.path.dirname(__file__)+"/modules")   # modules IN path includieren damit werden die ladbaren Modules gefunden

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
    #print(sites)
    
    # session = db.queryData(connection, generate_session_id())
    '''
    Insert a new row with executor value into [dbo].[Sessions] table, retriebe the identity value assigned to that row
    SET NOCOUNT ON: Remove "X rows affected" message
    SELECT @@Identity: retrieve last identity value generated for any table in current session
    #https://learn.microsoft.com/de-de/sql/relational-databases/system-stored-procedures/sp-executesql-transact-sql?view=sql-server-ver16
    '''
    session = db.queryValue(connection, "EXEC sp_executesql N'SET NOCOUNT ON; INSERT INTO [dbo].[Sessions]([Executor]) VALUES(''WebScraper Version 1.0''); SELECT @@IDENTITY'")
    
    print("Session-ID: " + str(session))

    #Switch out the module
    for site in sites[:1]:
        module = site.Module[:-3] # Namen endet mit .py
        methode = site.Method
        articles = []
        code ='import '+module+'; articles = '+ module + '.' + methode + '(site.URL)'
        print(code)
        exec(code)
        #Insert all articles into database
        for article in articles:
            print(article.headline)
except Exception as ex:

    traceback.print_exc(limit=1)
    print("Error: " + str(ex))

finally:

    connection.close()
    print("done.")


#Generate Session ID
