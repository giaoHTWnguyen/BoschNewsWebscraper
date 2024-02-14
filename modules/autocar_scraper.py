import datetime
from bs4 import BeautifulSoup
import requests
import json
from collections import deque
import traceback
from database.articleData import articleData
from datetime import datetime
import time

def scrape_autocar(base_url, options):

    print("Methode scrape_autocar wird gestartet..")
    

    def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text

        if element:
            text = element.text.strip()
            #newString_text = text.replace('\n', '')

            return text
        else:
            return None

    def convertToDatetime(publicDateText):
        dtelements = publicDateText.split(' ')
        months = ["---", "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        for (i, mname) in enumerate(months): #use enumerate function to retrieve index i and mname from months
            dtelements[1] = dtelements[1].replace(mname, str(i))

        publicDateText = datetime(int(dtelements[2]), int(dtelements[1]), int(dtelements[0]), 0, 0, 0)
        return publicDateText
    #iterate over articles, extract the title, url, text and pub-date

    session = requests.Session()
    try:

        #latest User Agent: https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome
        headers = {
            'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
        }

        response = session.get(base_url, headers=headers)

        time.sleep(1)

        # Set up Base Url, send GET Request, create BeautifulSoup Object
        ### autocar ###
        #base_url = 'https://www.autocar.co.uk/'
        article_objects = []
        html_soup = BeautifulSoup(response.text, 'html.parser')

        # Find all the div elements with class "details with-image"
        articles = html_soup.find_all('div', {"class": 'details with-image'})


        for article in articles:

            isPublicDateMissing = False

            headline_element = article.find('h3')
            headlineText = get_stripped_text(headline_element)
            print(headlineText)


            url = base_url + article.find('a')['href']

            subline_element = article.find('p', {"class": "standfirst"})
            sublineText = get_stripped_text(subline_element)
            

            publicDate_element = article.find('div', {"class": "pub-date"})
            publicDateText = get_stripped_text(publicDate_element)
       
            # print(headlineText)
            # print(publicDateText)

            if publicDateText:
                convertedDatetime = convertToDatetime(publicDateText=publicDateText)
                #print(convertedDatetime)
            else:
                isPublicDateMissing = True

            ###scrape publicdate via main page, if no publicdate is found and  headline is empty too, go into the page url and scrape it from class "personality-date"

            try:
                time.sleep(1)
                response_url = requests.get(url)
                html_soup_url = BeautifulSoup(response_url.text, 'html.parser')
            except Exception as ex:
                # FEHLERMELDUNG
                print(f"ERROR occurred: {str(ex)} on url={url}")
                continue
            if isPublicDateMissing:
                publicDate_element = html_soup_url.find('div', {"class": 'personality-date'})
                publicDateText = get_stripped_text(publicDate_element)
                if publicDateText:
                    convertedDatetime = convertToDatetime(publicDateText=publicDateText)
                    #print(convertedDatetime)
                else:
                    publicDateText = None
                    #print("Empty Time")

            author_class = html_soup_url.find('div', {"class": 'personality-author'})
            if author_class is None:
                author_element = None
            else:
                author_element = author_class.find('span', itemprop ='name')
            author_text = get_stripped_text(author_element)

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
                author=author_text,
                content=dataText,
                publicdate=convertedDatetime,
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
