#Entry point of program
###import modules and classes
import constant
from database import configs
from database import db
from database import articleData
import traceback
import datetime


import sys
import os
sys.path.append(os.path.dirname(__file__)+"/modules")   # modules IN path includieren damit werden die ladbaren Modules gefunden

# Read all actives sites

#create a new session with session id

#Create a scraper object

#iterate over all active sites
    #scrape the sites and store all the articles
    #store the articles in the database

#from database.db import connect_db
module = ''
print (constant.APP_NAME + " version " + constant.VERSION)

try:

    print("Connect to the database " + configs.db_database + " on server " + configs.db_server)
    ###https://www.sqlnethub.com/blog/how-to-resolve-im002-microsoftodbc-driver-manager-data-source-name-not-found-and-no-default-driver-specified-0-sqldriverconnect/
    connection = db.connect_db()
    sites = db.queryData(connection, "SELECT Id, Name, URL, Module, Method, ISNULL(Configs, '') as Configs FROM dbo.Sites WHERE Active = 1")
    '''
    Insert a new row with executor value into [dbo].[Sessions] table, retrieve the identity value assigned to that row
    SET NOCOUNT ON: Remove "X rows affected" message
    SELECT @@Identity: retrieve last identity value generated for any table in current session
    #https://learn.microsoft.com/de-de/sql/relational-databases/system-stored-procedures/sp-executesql-transact-sql?view=sql-server-ver16
    '''
    sessionID = db.queryValue(connection, "EXEC dbo.CreateSession '" + constant.APP_NAME + " version " + constant.VERSION + "'")
    
    print("Session-ID: " + str(sessionID))
    #print(sites)
    #Switch out the module
    for site in sites:
        module = site.Module[:-3] # Namen endet mit .py, extract module name by removing last three characters (".py" extension) from module
        methode = site.Method
        
        articles = []
        code ='import '+module+'; articles = '+ module + '.' + methode + '(site.URL, site.Configs)' #contain import statement and dynamic method call
        exec(code) #execute function, import the module a
        #Insert all articles into database
        '''
        Insert all data from a select query into "article" table;
        values are provided as placeholders '<%placeholder%> and will be replaced with actual values later;
        second argument is set of named parameters, values are extracted from object properties and converted
        into strings using formatting 'format' expression
        '''
        for article in articles:
            #print(article)
            isValidated = db.validateData(connection, article)
            if not isValidated:
                continue
            asql = db.getSqlCommand("""
                EXEC dbo.CreateArticle <%siteId%>, <%session%>, <%_overline%>, <%_headline%>, <%_subline%>, <%_author%>, <%_publicdate%>, <%_url%>;
                """,
                siteId = str(site.Id),
                session = str(sessionID),
                _overline = "{overline}".format(overline = article.overline),
                _headline = "{headline}".format(headline = article.headline),
                _subline = "{subline}".format(subline = article.subline),
                _author = "{author}".format(author = article.author), 
                _publicdate = "{publicdate}".format(publicdate = article.publicdate),
                _url = "{url}".format(url = article.url)
            )
            #print(asql)
            articleId = db.queryValue(connection, asql) #Run Queue with Cursor Commit
            if (articleId == 0): # no new aricle inserted
                continue
            lineIndex = 0
            for contentLine in article.content:
                if (not(contentLine is None) and contentLine != ""):
                    psql = db.getSqlCommand("""
                        INSERT INTO dbo.ArticleContents (article_Id, lineIndex, contentLine)
                        VALUES(<%articleId%>, <%lineIndex%>, <%_contentLine%>)
                        """,
                        articleId = str(articleId),
                        lineIndex = str(lineIndex),
                        _contentLine = contentLine)
                    #print(psql)
                    db.execCommand(connection, psql)
                    lineIndex = lineIndex + 1
        print("Done with Articles")
except Exception as ex: 

    traceback.print_exc(limit=1)
    print("Error: " + str(ex))

finally:

    bsql = db.closeSession(connection, sessionID)
    connection.close()
    print("done.")