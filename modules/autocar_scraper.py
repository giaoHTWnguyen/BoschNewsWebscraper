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

    def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text

        if element:
            text = element.text.strip()
            #newString_text = text.replace('\n', '')

            return text
        else:
            return None


    #iterate over articles, extract the title, url, text and pub-date 
    try:
        for article in articles:

            headline_element = article.find('h3')
            headlineText = get_stripped_text(headline_element)

            url = base_url + article.find('a')['href']

            subline_element = article.find('p', {"class": "standfirst"})
            sublineText = get_stripped_text(subline_element)

            publicDate_element = article.find('div', {"class": "pub-date"})
            publicDateText = get_stripped_text(publicDate_element)
       
            print(publicDateText)

            dataText = ""

            response_url = requests.get(url)
            html_soup_url = BeautifulSoup(response_url.text, 'html.parser')

            content = html_soup_url.find_all('div', {"class": 'field-item even'})

            data_list = []

            for div in content:
                paragraphs = div.find_all('p')
                data_list.extend(paragraphs)

            dataText = [p.get_text() for p in data_list]

            article_autocar = articleData(
                overline=None,
                headline=headlineText,
                subline = sublineText,
                author=None,
                content=dataText,
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