from bs4 import BeautifulSoup
import json
from collections import deque
import requests
import pyodbc
import csv

#Create a class Wiwoscraper and inizialize it



#Connect to SQL Server database




myServerAddress ='.'
database = 'WebScraper'
connection_string = 'Driver=SQL Server;Server={myServerAddress};Database={myDataBase};Trusted_Connection=True;'





base_url = 'https://www.wiwo.de/unternehmen/auto/'


response = requests.get(base_url)


# Create BeautifulSoup object from the loaded page HTML
html_soup = BeautifulSoup(response.text, 'html.parser')

# csv_file = open('news_web_scraper.csv', 'w', newline='', encoding='utf-8')

# csv_writer = csv.writer(csv_file)
# csv_writer.writerow(['overline', 'headline', 'author', 'url'])

article_dict = deque()

# Find all the div elements with class "u-flex__item u-lastchild"
articles = html_soup.find_all('div', {"class": 'u-flex__item u-lastchild'})

# Iterate over articles, extract the title, URL, text, and author

def get_stripped_text(element): #https://beautiful-soup-4.readthedocs.io/en/latest/index.html?highlight=strip#get-text

    if element:
        text = element.text.strip()
        #newString_text = text.replace('\n', '')
        
        #Remove unicode escape sequences

        #NORMALIZE
        #https://docs.python.org/3/library/unicodedata.html
        #https://www.youtube.com/watch?v=KP1YizbZdeU
        #https://www.w3schools.com/python/ref_string_encode.asp
        #https://www.tutorialspoint.com/python/string_decode.htm

        #use unicode normalization form to standarize representations of characters
        #two main forms are NFC and NFD
        #NFC combines characters represented as a combination
        #NFD decomposes characters into basic components
        #NFKD additional form to handle compatibility equivalence --> apply decomposition

        #.ENCODE
        #convert unicode string to ASCII characters
        #use ignore parameter ignore any non-ASCII characters and exclude them
        #decode('utf-8') encode using UTF-8 encoding

        #decoded_text = unicodedata.normalize('NFKD', newString_text).encode('ascii', 'ignore').decode('utf-8') #unicodedata.normalize(form, unistr)

        return text
    else:
        return None


try:
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
        author = get_stripped_text(author_element)


        # Create dictionary with extracted data
        article_data = {
            #"Title": title,
            "URL": url,
            "Overline": overlineText,
            "Headline": headlineText,
            "Author": author
        }

        article_dict.append(article_data)
        #Write data to CSV file
        # csv_writer.writerow([overlineText, headlineText, author, url])
except Exception as e:
    print(f"An error occurred: {str(e)}")
    article = None


# finally:
#     # Close the CSV file
#     csv_file.close()


# Print the extracted data in a nested dictionary format
for article in article_dict:
    print(json.dumps(article, sort_keys=True, indent=4))

