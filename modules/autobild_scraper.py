from bs4 import BeautifulSoup
import requests
import traceback
from database.articleData import articleData
import time

def scrape_autobild(base_url, options):
    print ("Methode scrape_autobild gestartet: url=" + base_url)
    article_objects = []
    myServerAddress ='.'
    mydatabase = 'WebScraper'
    connection_string = 'Driver=SQL Server;Server={myServerAddress};Database={myDataBase};Trusted_Connection=True;'
  

    # Iterate over articles, extract the title, URL, text, and author

    def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text
        if element:
            text = element.text.strip()
            return text
        else:
            return None
        
    session = requests.Session()
    try:

         #latest User Agent: https://www.whatismybrowser.com/guides/the-latest-user-agent/chrome
        headers = {
            'User-Agent' : 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/115.0.0.0 Safari/537.36'
        }

        #base_url = 'https://www.wiwo.de/unternehmen/auto/'
        response = session.get(base_url, headers=headers)
        time.sleep(1)

        # Create BeautifulSoup object from the loaded page HTML
        html_soup = BeautifulSoup(response.text, 'html.parser')

        articles = html_soup.find_all('section', {"class": 'teaserBlock'})

        for article in articles:

            url_element = article.select_one('section.teaserBlock a')['href']
            url = url_element if url_element else None

            overline_text_element = article.find('p', {"class" : 'teaserBlock__headline'})
            overlineText = get_stripped_text(overline_text_element)

            headline_text_element = article.find('p', {"class" : 'teaserBlock__title'})
            headlineText = get_stripped_text(headline_text_element)
            print(headlineText)
            #scrape the links
            html_soup_url = None
            try:
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
            
            timeTag = html_soup_url.find('time')
            if timeTag is None:
                publicdate_element = None
            else:
                publicdate_element = timeTag['datetime']
            
            author_tag = html_soup_url.find('div', {"class": 'authorList__name'})
            if author_tag is None:
                author_element = None
            else:
                author_element = author_tag.find('a')
                if author_element is None:
                    author_element = author_tag.find('span')
            author_text = get_stripped_text(author_element)

            ###Scrape Content
            content = html_soup_url.find_all('div', {"class": 'paragraph'})
            data_list = []
            for div in content:
                data_list.extend(div)
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

    print ("Methode scrape_wiwo beendet..")

    return article_objects
