USE WebScraper
GO

CREATE OR ALTER VIEW dbo.VwArticles --create view if doesen't exist
AS
WITH cnt AS (--calculate number of items and concatenate the items for each article 
	SELECT [article_Id]
		,COUNT(*) as ItemsCount
		,STRING_AGG([ContentLine]
			,CHAR(13)+CHAR(10)			-- separator between items
		) WITHIN GROUP ( ORDER BY LineIndex ASC) AS Items
	FROM [dbo].[ArticleContents]
	GROUP BY [article_Id]
)
SELECT a.[Id]
      ,a.[Site_Id]
	  , t.Name as SiteName
	  , t.URL as SiteUrl
      ,a.[Session_Id]
	  ,s.Executor
	  ,s.StartTime as SessionStart
	  ,s.EndTime as SessionEnd
      ,a.[Overline]
      ,a.[Headline]
      ,a.[Subline]
      ,a.[Author]
      ,a.[PublicDate]
      ,a.[Url]
	  ,cnt.Items
	  ,cnt.ItemsCount
FROM [dbo].[Articles] a
INNER JOIN [dbo].[Sessions] s on s.Id = a.Session_Id
INNER JOIN [dbo].[Sites] t on t.Id = a.Site_Id
LEFT JOIN cnt on cnt.article_Id=a.Id
