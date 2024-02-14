# BoschNewsWebscraper

##Prerequisites
To successfully run this program, you will need the following prerequisites:

##SQL Server:
Make sure you have a SQL Server installed. You can download the SQL Server from the official Microsoft website: https://www.microsoft.com/en-us/sql-server/sql-server-downloads

##SQL Server Management Studio (SSMS):
To manage the SQL Server and access the database, you will need the SQL Server Management Studio (SSMS). You can download SSMS from the following Microsoft website: https://learn.microsoft.com/en-us/sql/ssms/download-sql-server-management-studio-ssms?view=sql-server-ver16

Inside SSMS, create a new Database: WebScraper. Afterwards drag and drop the sql-script "Webscraper-full.sql" (inside the folder db-tools) into the database, so that it will create all the tables.

To run the program, you need to adjust the configs.py file of the program. Inside that file are the configuration, which you connect with the database. Most of the time you don't need to change anything, but the db_server should have the same name as your PC.

Eventually install the request package: pip install requests 

In the database inside the Views folder you can select the dbo.VwArticles to see the output of the Web Scraping extraction.
