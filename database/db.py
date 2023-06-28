import pyodbc
import configs  

def connect_db():
    connection_string = 'Driver={{SQL Server Native Client 11.0}};Server={configs.db_server};Database={configs.db_database};'

    if not configs.db_username:
        connection_string += 'Trusted_Connection=Yes;'
    else:
        connection_string += 'uid={configs.db_username};pwd={configs.db_password};'
    connection_string += configs.db_extras
    connection = pyodbc.connect(connection_string)
    return connection

def selectdata(sql):
    return ''

###functions

##init

###store extracted articles in database

###update the status of a session in a database


###Close the connection