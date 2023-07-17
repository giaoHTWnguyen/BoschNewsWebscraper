class articleData:
    def __init__(self, overline, headline, subline, author, content, publicdate, url):
        self.overline = "" if overline is None else overline
        self.headline = "" if headline is None else headline
        self.subline = "" if subline is None else subline
        self.author =   "" if author is None else author
        self.content =  "" if content is None else content
        self.publicdate = "" if publicdate is None else publicdate
        self.url = "" if url is None else url