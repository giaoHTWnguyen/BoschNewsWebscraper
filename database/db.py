import pyodbc

from  database import articleData, configs  
#https://learn.microsoft.com/en-us/ef/core/miscellaneous/connection-strings
def connect_db():
    connection_string = f'Driver={configs.db_driver};Server={configs.db_server};Database={configs.db_database};'
    if not configs.db_username:
        connection_string += 'Trusted_Connection=Yes;'
    else:
        connection_string += f'uid={configs.db_username};pwd={configs.db_password};'
    connection_string += configs.db_extras
    #print (connection_string)
    connection = pyodbc.connect(connection_string)
    return connection

#https://pynative.com/python-mysql-execute-parameterized-query-using-prepared-statement/

#Sanitize and prevent sql injection
def getSqlValue(value, withDelimiter: bool):
    if value is None:
        return 'NULL'
    value = value.strip().replace("'", "''") #trail whitespace        
    if withDelimiter: #add prefix 'N' and suffix ' to sanatize
        value = "N'" + value + "'"
    return value

#replace placeholders with provided values
def getSqlCommand(sql: str, **kwargs): #kwargs: ductuibary containung values to replace the placeholders in SQL command
    '''
    replace '<%{a}%>' in sql with value by calling 'getSqlValue()' function 
    with value from 'kwargs' and boolean to indictate wheter the ykey starts with an underscroe
    '''
    for a in kwargs:
        #print (a+": "+kwargs[a])
        sql = sql.replace("<%" + a +"%>", getSqlValue(kwargs[a], a.startswith('_'))) 
    #print(sql)
    return sql
#https://learn.microsoft.com/en-us/dotnet/api/system.data.oledb.oledbtransaction.commit?view=dotnet-plat-ext-7.0
def execCommand(connection, sql: str): 
    with connection.cursor() as crs:
        crs.execute(sql)
        crs.commit() 
    
def queryData(connection, sql: str): 
    with connection.cursor() as crs:
        crs.execute(sql)
        return crs.fetchall()

#Python Cursor Class = https://www.mcobject.com/docs/Content/Programming/Python/Classes/Cursor/execute.htm

def queryValue(connection, sql: str):
    with connection.cursor() as crs: #use 'with' statement (context manager) to ensure database is closed after query is executed
        #get cursor object from 'connection' using cursor()-method
        crs.execute(sql)#execute SQL query on database
        return crs.fetchval() #return fetched value

def validateData(connection, article: articleData):
    # tidy data by removing leading trailing whitespaces
    article.overline = article.overline.strip()
    article.headline = article.headline.strip()
    article.subline = article.subline.strip()
    article.url = article.url.strip()

    # check data exists based on its hash value
    # Hash value is calculated using the GetHashValue function defined in database
    sql = getSqlCommand("SELECT Id FROM dbo.Articles WHERE HashValue = dbo.GetHashValue(<%_overline%>, <%_headline%>, <%_subline%>, <%_url%>);", 
                        #Provide Placeholders using article properties for Hash Value
                        _overline = article.overline,
                        _headline = article.headline,
                        _subline = article.subline,
                        _url = article.url)
    #Exectue query and retrieve the existing article ID (if found)
    existingId = queryValue(connection, sql)
    #If the existingId is None, means article data is not present in the database,
    #data is considered vakudated (not a duplicate)
    return existingId is None

def closeSession(connection, sessionID):
    with connection.cursor() as crs:
        crs.execute("EXEC [dbo].[CloseSession] @sessionID=?", sessionID)
        #return crs.fetchval()

def formatDateTime(dateobj):
    if dateobj is None: return None
    if isinstance(dateobj, str): return dateobj
    return dateobj.strftime('%Y-%m-%d %H:%M:%S')