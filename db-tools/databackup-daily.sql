DECLARE @filename nvarchar(255) = N'C:\WebScraper\Backups\WebScraper_'+FORMAT(GETDATE(), 'yyyy-MM-dd') +'.bak'
print 'backup WebScraper database to '+@filename
BACKUP DATABASE [WebScraper] TO  DISK = @filename WITH FORMAT, INIT,  NAME = N'WebScraper-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO
