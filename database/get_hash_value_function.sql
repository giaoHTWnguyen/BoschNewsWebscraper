SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Giao Nguyen
-- Create date: 24.07.2023
-- Description:	get hash values as string
-- =============================================
CREATE OR ALTER FUNCTION dbo.GetHashValue
(
	@Overline nvarchar(max),
	@Headline nvarchar(max),
	@Subline nvarchar(max),
	@Url nvarchar(max)
)
RETURNS VARCHAR(32)
AS
BEGIN
	DECLARE @Separator varchar(20) = '--||//.|.\\||--';

	RETURN CONVERT([varchar](32),hashbytes('MD5',
		isnull(@Overline, '') + @Separator +
		isnull(@Headline, '') + @Separator +
		isnull(@Subline, '')  + @Separator +
		isnull(@Url, '')), 2)
END
GO

