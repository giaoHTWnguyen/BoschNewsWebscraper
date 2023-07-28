from bs4 import BeautifulSoup
from collections import deque
import requests
import traceback
from database.articleData import articleData
import time
#import articleData

#Create a class Wiwoscraper and inizialize it



#Connect to SQL Server database


def scrape_wiwo(base_url, options):
    print ("Methode scrape_wiwo gestartet: url=" + base_url)
    article_objects = []
    myServerAddress ='.'
    mydatabase = 'WebScraper'
    connection_string = 'Driver=SQL Server;Server={myServerAddress};Database={myDataBase};Trusted_Connection=True;'
    #base_url = 'https://www.wiwo.de/unternehmen/auto/'

    def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text

        if element:
            text = element.text.strip()
            #newString_text = text.replace('\n', '')

            return text
        else:
            return None
    session = requests.Session()
    try:

        #latest User Agent: https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome
        headers = {
            'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
        }

        response = session.get(base_url, headers=headers)

        time.sleep(1)

        # Create BeautifulSoup object from the loaded page HTML
        html_soup = BeautifulSoup(response.text, 'html.parser')

        # Find all the div elements with class "u-flex__item u-lastchild"
        articles = html_soup.find_all('div', {"class": 'u-flex__item u-lastchild'})

        # Iterate over articles, extract the title, URL, text, and author

    

    
        for article in articles:

            # title_element = article.find('h3', {"class" : 'c-headline'})
            # title = get_stripped_text(title_element)

            url_element = article.find('a', {"class" : 'c-teaser__link'})
            url = base_url + url_element['href'] if url_element else None

            overline_text_element = article.find('span', {"class" : 'c-overline'})
            overlineText = get_stripped_text(overline_text_element)

            headline_text_element = article.find('span', {"class" : 'js-headline'})
            headlineText = get_stripped_text(headline_text_element)


            author_element = article.find('div', {"class" : 'c-teaser__authors'})
            # if author_element is "" : article.find('div', {"class" : ''})
            author_text = get_stripped_text(author_element)


            #scrape content
            html_soup_url = None
            try:
                #add Delay before each request to scrape individual articles
                time.sleep(1)
                response_url = requests.get(url)
                html_soup_url = BeautifulSoup(response_url.text, 'html.parser')
            except Exception as ex:
                # FEHLERMELDUNG
                print(f"ERROR occurred: {str(ex)} on url={url}")
                continue
            if html_soup_url is None:
                print(f"skip NOTHING on url={url}")
                continue
            #publicdate_text = get_stripped_text(publicdate_element)
            timeTag = html_soup_url.find('time')
            if timeTag is None:
                publicdate_element = None
            else:
                publicdate_element = timeTag['datetime']
                publicdate_element = publicdate_element[0:10] + ' ' + publicdate_element[11:19]
            if publicdate_element is None:
                continue

            content = html_soup_url.find_all('div', {"class": 'u-richtext'})
            ### if content empty use other class!!

            ###Scrape Content
            data_list = []
            for div in content:
                paragraphs = div.find_all('p')
                data_list.extend(paragraphs)
            dataText = [p.get_text() for p in data_list]

            article_wiwo = articleData(
                overline=overlineText,
                headline=headlineText,
                subline=None,
                author=author_text,
                content=dataText,
                publicdate=publicdate_element,
                url=url)

            article_objects.append(article_wiwo)

           
    except Exception as e:
        traceback.print_exc(limit=1)
        print(f"An error occurred: {str(e)}")
        article = None

    # Print the extracted data in a nested dictionary format
    # for article in article_dict:
    #     print(json.dumps(article, sort_keys=True, indent=4))
    print ("Methode scrape_wiwo beendet..")

    return article_objects
