from bs4 import BeautifulSoup
from collections import deque
import requests
import traceback
from database.articleData import articleData
#import articleData

#Create a class Wiwoscraper and inizialize it



#Connect to SQL Server database


def scrape_autobild(base_url, options):
    print ("Methode scrape_wiwo gestartet: url=" + base_url)
    article_objects = []
    myServerAddress ='.'
    mydatabase = 'WebScraper'
    connection_string = 'Driver=SQL Server;Server={myServerAddress};Database={myDataBase};Trusted_Connection=True;'
    #base_url = 'https://www.wiwo.de/unternehmen/auto/'
    response = requests.get(base_url)
    # Create BeautifulSoup object from the loaded page HTML
    html_soup = BeautifulSoup(response.text, 'html.parser')

    article_dict = deque()

    # Find all the div elements with class "u-flex__item u-lastchild"
    articles = html_soup.find_all('section', {"class": 'teaserBlock'})

    # Iterate over articles, extract the title, URL, text, and author

    def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text

        if element:
            text = element.text.strip()
            #newString_text = text.replace('\n', '')

            return text
        else:
            return None

    try:
        for article in articles:

            # title_element = article.find('h3', {"class" : 'c-headline'})
            # title = get_stripped_text(title_element)

            url_element = article.select_one('section.teaserBlock a')['href']
            url = url_element if url_element else None

            overline_text_element = article.find('p', {"class" : 'teaserBlock__headline'})
            overlineText = get_stripped_text(overline_text_element)

            headline_text_element = article.find('p', {"class" : 'teaserBlock__title'})
            headlineText = get_stripped_text(headline_text_element)


            #author_element = article.find('div', {"class" : 'c-teaser__authors'})
            # if author_element is "" : article.find('div', {"class" : ''})
            #author_text = get_stripped_text(author_element)


            publicdate_element = article.find()
            publicdate_text = get_stripped_text(publicdate_element)

             
            #scrape content
            dataText = ""

            response_url = requests.get(url)
            html_soup_url = BeautifulSoup(response_url.text, 'html.parser')
            
            content = html_soup_url.find_all('div', {"class": 'paragraph'})
            ### if content empty use other class!!

            ###Scrape Content
            data_list = []

            for div in content:
                data_list.extend(div)

            dataText = [p.get_text() for p in data_list]
            
            article_wiwo = articleData(
                overline=overlineText,
                headline=headlineText,
                subline=None,
                author=None,
                content=dataText,
                publicdate=None,
                url=url)

            article_objects.append(article_wiwo)

           
    except Exception as e:
        traceback.print_exc(limit=1)
        print(f"An error occurred: {str(e)}")
        article = None

    print ("Methode scrape_wiwo beendet..")

    return article_objects
