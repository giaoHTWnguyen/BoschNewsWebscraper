class articleData:
    def __init__(self, overline, headline, subline, author, data, publicdate, url):
        self.overline = "" if overline is None else overline
        self.headline = "" if headline is None else headline
        self.subline = "" if subline is None else subline
        self.author =   "" if author is None else author
        self.data =  "" if data is None else data
        self.publicdate = "" if publicdate is None else publicdate
        self.url = "" if url is None else url