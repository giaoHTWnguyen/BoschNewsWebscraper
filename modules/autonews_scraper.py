from bs4 import BeautifulSoup
import json
from collections import deque
import requests
import time

import traceback
from database.articleData import articleData


def scrape_autonews(base_url):
    print ("Methode scrape_autonews wird gestartet.." + base_url)
    article_objects=[]
    response = requests.get(base_url)
    html_soup = BeautifulSoup(response.text, "html.parser")
    #articles = html_soup.find_all('div', {"class": 'layout-content'})
    articles = html_soup.find_all('a', {"class": 'omnitrack'})

    def get_stripped_text(element):
        if element:
            text = element.text.strip()
            return text
        else:
            return None
        
    try:
        for article in articles:
            #time.sleep(10) #delay 10seconds
            url_element = article.find('a')
            url = base_url + url_element['href'] if url_element else None

            headline_element = article.find('h1')
            headline_text = get_stripped_text(headline_element)

            subline_element = article.find('a')
            subline_text = get_stripped_text(subline_element)

            

            article_autonews = articleData(
                    overline=None,
                    headline=headline_text,
                    subline=subline_text,
                    author=None,
                    data=None,
                    publicdate=None,
                    url=url)

            article_objects.append(article_autonews)

    except Exception as e:
        traceback.print_exc(limit=1)
        print(f"An error occurred: {str(e)}")
        article = None

    return article_objects