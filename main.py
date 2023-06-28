#Entry point of program
###import modules and classes

#functions

###Create a new session with a session ID
def generate_session_id():
    pass


##get all actives sites from the database
def get_active_sites():
    pass

###close the session and update the status in the database
def close_session():
    pass


# Read all actives sites

#create a new session with session id

#Create a scraper object

#iterate over all active sites
    #scrape the sites and store all the articles
    #store the articles in the database

# Close the session

from database.db import connect_db

try:
    connection = connect_db

    print("Cpmmected tp the database")

except Exception as ex:
    print("Error: " + str(ex))

finally:

    connection.close()


#Generate Session ID
