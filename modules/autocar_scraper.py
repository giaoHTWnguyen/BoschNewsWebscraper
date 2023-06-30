from bs4 import BeautifulSoup
import requests
import json
from collections import deque

# Set up Base Url, send GET Request, create BeautifulSoup Object
### autocar ###
base_url = 'https://www.autocar.co.uk/'
response = requests.get(base_url)
html_soup = BeautifulSoup(response.text, 'html.parser')
article_dict = deque()

# Find all the div elements with class "details with-image"
articles = html_soup.find_all('div', {"class": 'details with-image'})


#iterate over articles, extract the title, url, text and pub-date 
for article in articles:

    title = article.find('h3')
    if title:
        title = title.text.strip()

    url = base_url + article.find('a')['href']

    text = article.find('p', {"class": "standfirst"})
    if text:
        text = text.text.strip()

    date = article.find('div', {"class": "pub-date"})
    if date:
        date = date.text.strip()
    #Create dictionary with extracted data
    article_data = {
        "Titel": title,
        "URL": url,
        "Text": text,
        "Datum": date
    }
    
    article_dict.append(article_data)
# Print in nested directionary

for article in article_dict: 
    print(json.dumps(article, sort_keys=True, indent=4))  #https://stackoverflow.com/questions/3229419/how-to-pretty-print-nested-dictionaries