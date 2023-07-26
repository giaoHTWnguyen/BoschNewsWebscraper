USE [WebScraper]
GO

/****** Object:  StoredProcedure [dbo].[CloseSession]    Script Date: 26.07.2023 12:41:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Giao Nguyen
-- Create date: 17.07.2023
-- Description:	Take sessionID and Update the endtime
-- =============================================

CREATE OR ALTER PROCEDURE [dbo].[CloseSession]
	@sessionID INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @EndTime DateTime = GETDATE();
	UPDATE [dbo].[Sessions]
	SET EndTime = @EndTime
	WHERE [dbo].[Sessions].Id = @sessionID;
END