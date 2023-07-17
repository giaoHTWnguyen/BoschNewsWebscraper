from bs4 import BeautifulSoup
import requests
import json
from collections import deque
import traceback
from database.articleData import articleData

def scrape_autocar(base_url, options):

    print("Methode scrape_autocar wird gestartet..")
    # Set up Base Url, send GET Request, create BeautifulSoup Object
    ### autocar ###
    #base_url = 'https://www.autocar.co.uk/'
    article_objects = []
    response = requests.get(base_url)
    html_soup = BeautifulSoup(response.text, 'html.parser')

    # Find all the div elements with class "details with-image"
    articles = html_soup.find_all('div', {"class": 'details with-image'})


    #iterate over articles, extract the title, url, text and pub-date 
    try:
        for article in articles:

            headlineText = article.find('h3')
            if headlineText:
                headlineText = headlineText.text.strip()

            url = base_url + article.find('a')['href']

            subtext = article.find('p', {"class": "standfirst"})
            if subtext:
                subtext = subtext.text.strip()

            publicdate = article.find('div', {"class": "pub-date"})
            if publicdate:
                publicdate = publicdate.text.strip()
       
            #Create dictionary with extracted data
            # article_data = {
            #     "Titel": title,
            #     "URL": url,
            #     "Text": text,
            #     "Datum": date
            # }
            
            article_autocar = articleData(
                overline=None,
                headline=headlineText,
                subline = subtext,
                author=None,
                data=None,
                publicdate=None,
                url=url)
            
            article_objects.append(article_autocar)
        # Print in nested directionary
    except Exception as e:
        traceback.print_exc(limit=1)
        print(f"An error occurred: {str(e)}")
        article = None

    # 'for article in article_dict: 
    #     print(json.dumps(article, sort_keys=True, indent=4))  #https://stackoverflow.com/questions/3229419/how-to-pretty-print-nested-dictionaries'

    print ("Methode scrape_autocar beendet...")

    return article_objects