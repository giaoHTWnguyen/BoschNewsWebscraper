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

# Read all actives sites

#create a new session with session id

#Create a scraper object

#iterate over all active sites
    #scrape the sites and store all the articles
    #store the articles in the database

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
    sessionID = db.queryValue(connection, "EXEC sp_executesql N'SET NOCOUNT ON; INSERT INTO [dbo].[Sessions]([Executor]) VALUES(''WebScraper Version 1.0''); SELECT @@IDENTITY'")
    
    print("Session-ID: " + str(sessionID))
    #print(sites)
    #Switch out the module
    for site in sites:
        module = site.Module[:-3] # Namen endet mit .py, extract module name by removing last three characters (".py" extension) from module
        methode = site.Method
        
        articles = []
        code ='import '+module+'; articles = '+ module + '.' + methode + '(site.URL)' #contain import statement and dynamic method call
        exec(code) #execute function, import the module a
        #Insert all articles into database
        '''
        Insert all data from a select query into "article" table;
        values are provided as placeholders '<%placeholder%> and will be replaced with actual values later;
        second argument is set of named parameters, values are extracted from object properties and converted
        into strings using formatting 'format' expression
        '''
        for article in articles:
           
            sql = db.getSqlCommand("""
                INSERT INTO [dbo].[articles] (Site_Id, Session_Id, Overline, Headline, Subline, Author, Data, Publicdate, Url)
                SELECT <%siteId%>, <%session%>, NULLIF(<%_overline%>, ''), NULLIF(<%_headline%>, ''), NULLIF(<%_subline%>, ''), NULLIF(<%_author%>, ''), NULLIF(<%_data%>, ''), NULLIF(<%_publicdate%>, ''), NULLIF(<%_url%>, '');
                """,
                siteId = str(site.Id),
                session = str(sessionID),
                _overline = "{overline}".format(overline = article.overline),
                _headline = "{headline}".format(headline = article.headline),
                _subline = "{subline}".format(subline = article.subline),
                _author = "{author}".format(author = article.author), 
                _data = "{data}".format(data = article.data),
                _publicdate = "{publicdate}".format(publicdate = article.publicdate),
                _url = "{url}".format(url = article.url)
            )
            db.execCommand(connection, sql) #Run Queue with Cursor Commit
        print("Done with Articles")
except Exception as ex:

    traceback.print_exc(limit=1)
    print("Error: " + str(ex))

finally:

    connection.close()
    print("done.")
 

#Generate Session ID
