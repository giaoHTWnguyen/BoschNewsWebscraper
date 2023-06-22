from selenium import webdriver
import requests
import dataset
from json import loads
###Connect to SQLite-Database

db = dataset.connect('sqlite:///news.db')
#base_url = 'https://news.google.com/news/?ned=us&hl=en'
#base_url = 'https://news.google.com/home?hl=de&gl=DE&ceid=DE:de'
base_url = 'https://news.google.com/topics/CAAqIAgKIhpDQkFTRFFvSEwyMHZNR3MwYWhJQ1pHVW9BQVAB?hl=de&gl=DE&ceid=DE%3Ade'
script_url = 'http://www.webscrapingfordatascience.com/readability/Readability.js'

#Extract article content with this JavaSCript Command

get_article_cmd = requests.get(script_url).text
get_article_cmd += '''
var documentClone = document.cloneNode(true);
var loc = document.location; 
var uri = {
 spec: loc.href,
 host: loc.host,
 prePath: loc.protocol + "//" + loc.host,
 scheme: loc.protocol.substr(0, loc.protocol.indexOf(":")),
 pathBase: loc.protocol + "//" + loc.host +
 loc.pathname.substr(0, loc.pathname.lastIndexOf("/") + 1)
};
var article = new Readability(uri, documentClone).parse();
return JSON.stringify(article);
'''

'''
# ###Summary: Clone the webscrapingfordatascience webpage's document object
# retrieve inormation about the url
use Readability class to parse the cloned document and extract the main article content
return the extracted main article as a JSON representation
'''
#Set up Selenium webdriver
driver = webdriver.Chrome()
driver.implicitly_wait(10)
driver.get(base_url)

news_urls = []
for link in driver.find_elements("xpath", '//a[contains(@class, "WwrzSb")]'): #find all classes with xpath
 news_url = link.get_attribute('href')
 news_urls.append(news_url)

# Scrape each news article

count = 0
for news_url in news_urls:

   print('Now scraping:', news_url)
   driver.get(news_url)

   print('Injecting script')
   returned_result = driver.execute_script(get_article_cmd)

   # Convert JSON string to Python dictionary
   article = loads(returned_result)
   if not article:
      # Failed to extract article, just continue
      continue
   # Add in the url
   article['url'] = news_url
   # Remove 'uri' as this is a dictionary on its own
   del article['uri']
   # Add to the database
   db['articles'].upsert(article, ['url']) ##combination of update and insert, database ope
##ration to insert new record or update exiting record in database table
   print('Title was:', article['title'])
   
   #count = count + 1
   count += 1
   if count >= 5:
     break
   

driver.quit()