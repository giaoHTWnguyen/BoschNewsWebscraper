import pyodbc

from  database import configs  

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

def getSqlValue(value, withDelimiter: bool):
    if value is None:
        return 'NULL'
    value = value.strip().replace("'", "''").replace('\n', "' + CHAR(10) + '").replace('\r', "' + CHAR(13) + '").replace('\t', "' + CHAR(9) + '") #prevent sql injection
    if withDelimiter:
        value = "'" + value + "'"
    return value

def getSqlCommand(sql: str, **kwargs):
    for a in kwargs:
        sql = sql.replace("%<{a}>%", getSqlValue(kwargs[a], a.startswith('_')))
    return sql

def queryData(connection, sql: str): #Python Cursor Class = https://www.mcobject.com/docs/Content/Programming/Python/Classes/Cursor/execute.htm
    with connection.cursor() as crs:
        crs.execute(sql)
        return crs.fetchall()
    
def queryValue(connection, sql: str):
    with connection.cursor() as crs:
        crs.execute(sql)
        return crs.fetchval()
    
def insertCommitData(connection, sql: str):
    with connection.cursor() as crs:
        crs.execute(sql)
        connection.commit()
      #  crs.execute(sql)
        return crs.fetchall()
###functions

##init

###store extracted articles in database

###update the status of a session in a database


###Close the connection