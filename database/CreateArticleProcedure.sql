USE [WebScraper]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Giao Nguyen
-- Create date: 17.07.2023
-- Description:	insert new article and returns its id
-- =============================================
CREATE OR ALTER PROCEDURE dbo.CreateSession 
	@executor nvarchar(240)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Sessions] (Executor)
    VALUES(@executor);
	SELECT SCOPE_IDENTITY() -- return the inserted id
END
GO

-- =============================================
-- Author:		Giao Nguyen
-- Create date: 17.07.2023
-- Description:	insert new article and returns its id
-- =============================================
CREATE OR ALTER PROCEDURE dbo.CreateArticle 
	-- Add the parameters for the stored procedure here
	@siteId int, 
	@sessionId int,
	@overline nvarchar(max),
	@headline nvarchar(max),
	@subline nvarchar(max),
	@author nvarchar(240),
	@publicDate nvarchar(50),
	@url nvarchar(max)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Articles] 
		(Site_Id, Session_Id, Overline, Headline, Subline, Author, Publicdate, Url)
        SELECT @siteId, @sessionId, NULLIF(@overline, ''), NULLIF(@headline, ''), NULLIF(@subline, ''), NULLIF(@author, ''), NULLIF(@publicdate, ''), NULLIF(@url, '');
	SELECT SCOPE_IDENTITY() -- return the inserted id
END
GO
