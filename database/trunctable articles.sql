delete from WebScraper.dbo.ArticleContents;
delete from WebScraper.dbo.Articles;
--delete from WebScraper.dbo.Sessions;

DBCC CHECKIDENT ('WebScraper.dbo.ArticleContents', RESEED, 0);
DBCC CHECKIDENT ('WebScraper.dbo.Articles', RESEED, 0);
--DBCC CHECKIDENT ('WebScraper.dbo.Sessions', RESEED, 0);