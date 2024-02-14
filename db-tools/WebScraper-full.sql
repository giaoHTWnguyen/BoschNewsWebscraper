USE [master]
GO
/****** Object:  Database [WebScraper]    Script Date: 08.08.2023 11:15:35 ******/
/*
CREATE DATABASE [WebScraper]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'WebScraper', FILENAME = N'C:\SQLData\MSSQL16.MSSQLSERVER\MSSQL\DATA\WebScraper.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'WebScraper_log', FILENAME = N'C:\SQLData\MSSQL16.MSSQLSERVER\MSSQL\DATA\WebScraper_log.ldf' , SIZE = 270336KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
*/
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [WebScraper].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [WebScraper] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [WebScraper] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [WebScraper] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [WebScraper] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [WebScraper] SET ARITHABORT OFF 
GO
ALTER DATABASE [WebScraper] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [WebScraper] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [WebScraper] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [WebScraper] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [WebScraper] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [WebScraper] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [WebScraper] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [WebScraper] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [WebScraper] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [WebScraper] SET  DISABLE_BROKER 
GO
ALTER DATABASE [WebScraper] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [WebScraper] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [WebScraper] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [WebScraper] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [WebScraper] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [WebScraper] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [WebScraper] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [WebScraper] SET RECOVERY FULL 
GO
ALTER DATABASE [WebScraper] SET  MULTI_USER 
GO
ALTER DATABASE [WebScraper] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [WebScraper] SET DB_CHAINING OFF 
GO
ALTER DATABASE [WebScraper] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [WebScraper] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'WebScraper', N'ON'
GO
USE [WebScraper]
GO
/****** Object:  UserDefinedFunction [dbo].[GetHashValue]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Giao Nguyen
-- Create date: 24.07.2023
-- Description:	get hash vakues as string
-- =============================================
CREATE   FUNCTION [dbo].[GetHashValue]
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
/****** Object:  Table [dbo].[ArticleContents]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ArticleContents](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[article_Id] [bigint] NOT NULL,
	[LineIndex] [int] NOT NULL,
	[ContentLine] [nvarchar](max) NULL,
 CONSTRAINT [PK_ArticleContents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articles]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Site_Id] [int] NOT NULL,
	[Session_Id] [int] NOT NULL,
	[Overline] [nvarchar](max) NULL,
	[Headline] [nvarchar](max) NULL,
	[Subline] [nvarchar](max) NULL,
	[Author] [nvarchar](240) NULL,
	[PublicDate] [nvarchar](50) NULL,
	[Url] [nvarchar](max) NOT NULL,
	[HashValue]  AS ([dbo].[GetHashValue]([Overline],[Headline],[Subline],[Url])),
 CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sessions]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sessions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NULL,
	[Executor] [nvarchar](240) NULL,
 CONSTRAINT [PK_Sessions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sites]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sites](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](240) NOT NULL,
	[Active] [bit] NOT NULL,
	[URL] [nvarchar](240) NOT NULL,
	[Module] [nvarchar](40) NULL,
	[Method] [nvarchar](80) NULL,
	[Configs] [nvarchar](max) NULL,
 CONSTRAINT [PK_Sites] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[VwArticles]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[VwArticles] --create view if doesen't exist
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
GO
SET IDENTITY_INSERT [dbo].[ArticleContents] ON 
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1, 1, 0, N'Land Rover''s long-mooted and highly anticipated ‘baby Defender’ programme, which will take the 4x4 brand boldly into a new segment, will arrive as the Halewood firm''s mysterious fourth model line.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2, 1, 1, N'The rugged, compact 4x4 is rumoured to have been on the cards for several years but has never officially appeared on JLR’s product roadmap presentations.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (3, 1, 2, N'However, it is now finally expected inbound as a sibling model to the next-generation Range Rover Evoque, Velar and Land Rover Discovery Sport, and it will share with them the company’s new EMA electric vehicle platform.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (4, 1, 3, N'The move to expand the Defender family into the compact 4x4 segment was confirmed at JLR’s recent investor conference by CEO Adrian Mardell, who said the “Range Rover, Defender and Discovery brands will come off that platform”.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (5, 1, 4, N'The revelation shed further light on the mysterious fourth model line due to be built alongside the three electric SUVs, which are new-generation variants of current models, at the firm’s Halewood factory.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (6, 1, 5, N'Mardell gave no further details, but the confirmation that the smaller Defender will use the electric-only EMA architecture reveals much about the new model. It could adopt the Defender Sport moniker, in keeping with the more road-focused versions of the Discovery and Range Rover, and arrive in dealerships as soon as 2027.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (7, 1, 6, N'Most importantly, it will be much more compact in all dimensions compared with its full-size namesake, today’s combustion engine-powered ‘L663’ Defender.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (8, 1, 7, N'That car uses a variation of the D7 platform that also underpins the Discovery, but the promised electric variant, which is due in around 2026, will use the MLA structure from combustionengined and future electric variants of the Range Rover.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (9, 1, 8, N'The EMA-based smaller car, in turn, will be a similar size to its platform-mates. It is likely to measure around 4.6m long and 2m wide and stand at less than 1.8m tall, therefore making it similar in size to – albeit no doubt a good deal more expensive than – the upcoming Dacia Bigster and Skoda Kodiaq.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (10, 1, 9, N'Good call and long overdue, they could have done this very easily using the current Evoque and Disco Sport base too.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (11, 1, 10, N'Surely though if they want to further differentiate the 3 brands they should call it Defender 70 rather than adopting the Discovery and RR naming convention?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (12, 1, 11, N'Seems a good idea.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (13, 1, 12, N'The present Defender is too vast even for a rural dweller like me.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (14, 1, 13, N'They have enough trouble keeping up with demand as it is such is the Defender''s popularity.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (15, 1, 14, N'Anyhow nice move and I reckon there''ll be people willing to add their name to a waiting list today.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (16, 2, 0, N'Advanced driver assistance systems (ADAS) are an acquired taste, with many finding features such as lane keeping assistance (LKA) an irritation they could do without. But car makers are continuing down the road to autonomy.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (17, 2, 1, N'Mercedes buyers in Europe can now order an automated overtaking feature on the new E-Class. It’s already available on the C-Class, E-Class and S-Class and EQ series in North America, but Mercedes says it has been adapting the function to suit European traffic conditions.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (18, 2, 2, N'Mercedes’ Automatic Lane Change (ALC) system is part of ‘Active Distance Assist Distronic with Active Steering Assist’. If the car is going at between 47.3mph and 87mph (80-140kph) and it detects a slower vehicle ahead, it can initiate a lane change automatically if it detects lane markings and ‘structurally separated directional lanes’ (ie dual carriageways). That can be a full overtake if the lane markings are good and there’s enough clearance.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (19, 2, 3, N'The car must be fitted with MBUX Navigation to use the feature and the road on which it’s performing the automatic lane change must have a speed limit. The driver doesn’t have to do anything else to initiate the manoeuvre, but their hands must remain on the wheel. The system can also assist with navigating road exits and merging from one highway to the next.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (20, 2, 4, N'ALC is classified as SAE level two in autonomous driving-speak, which is the last of the levels (above level zero and one) where the driver is considered to be in control even if the car is steering and feet are off the pedals. Familiar examples are adaptive cruise control and autonomous emergency braking.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (21, 2, 5, N'The jump to level three, which is defined as the driver not in direct control but the car driving itself in certain conditions (if not all), is a big one, so over the past few years automotive engineers have coined the phrase ‘level two-plus’, which is what Mercedes deems ALC to be.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (22, 2, 6, N'Executing a lane change on a multi-lane road is a big step up from LKA’s mix of lane centring and cruise control that combine a degree of automated steering, braking and acceleration. But at the same time it’s not going so far as to take complete hands-free control.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (23, 2, 7, N'It’s not a new feature to the industry, though. As well as Mercedes already having the feature in other markets, Tesla has an assisted lane change function available, while JLR developed a prototype ‘driver-assisted overtake’ manoeuvre back in 2016.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (24, 2, 8, N'Those not completely (or even a little) sold on autonomous driving may take heart from knowing that progress towards the roads being full of robotic cars through the evolution of ADAS is even slower than first thought.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (25, 2, 9, N'That Mercedes had to adapt its technology to suit European rather than American roads gives an indication of just how complex the development of autonomous vehicles really is, without attaching so many conditions that it hardly becomes worth it.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (26, 2, 10, N'Along with the hydogen car the automonous car has become another tale of false dawns that next to no one, apart from the press, think will happen or even desire.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (27, 3, 0, N'Why we’re running it:  To see if Lexus’s famed attention to detail makes up for the modest range')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (28, 3, 1, N'Welcoming the Lexus RZ to the fleet - 26 July 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (29, 3, 2, N'Spending £70,000-plus on a car is quite a privilege at the best of times, but throw in the current cost of living crisis and impending recession and it becomes an even more extravagant proposition.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (30, 3, 3, N'So, with opinions like that, seeing the keys to such a vehicle land on my desk at Autocar Towers was a bit of a surprise – but maybe that was the point. The very plush Lexus RZ will be in my keep for the next few months, possibly in the hope that I’ll become an advocate for high-end cruising, or at least understand its place.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (31, 3, 4, N'What’s more, the brand’s new flagship is an EV, and Lexus’s first bespoke one at that (after the also-a-hybrid UX) – albeit a reskinned Toyota bZ4X. Sorry, being cynical.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (32, 3, 5, N'But it’s hard not to be in the world of lavish EVs. Just look at the spec sheets that accompany some cheaper models such as the Skoda Enyaq iV, which in £45,000, bigger-battery form delivers more than 300 miles of real-world range.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (33, 3, 6, N'It makes you wonder why Lexus (and Toyota) didn’t want to offer more than the RX’s on-paper range of 251 miles (we’ll come to that later) and whether a car like this, at this price point has a place in the world – especially when battery technology has yet to catch up with combustion power in terms of how far it can take you between stops.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (34, 3, 7, N'Anyway, we’re going to start with a clean slate.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (35, 3, 8, N'First, let’s have a look at what we have here: a 309bhp, four-wheel-drive, two-tonne family SUV that has been created to offer “confidence, control and comfort”, according to Lexus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (36, 3, 9, N'Although this is my first report, I’m already more than 700 miles into our relationship, which has included airport trips and motorway runs. B-road blasts have figured too, and they’ve been surprisingly quite fun in this EV, despite its weight.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (37, 3, 10, N'I’m happy to report Lexus has hit the mark: this is a comfy car. And plush – especially in the Takumi trim of our model. As a result, every journey has been one of comfort – from being lightly manoeuvred into my driving position at the press of the start button to the in-seat fans keeping me sweat-free on scorching days.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (38, 4, 0, N'The next-generation Volkswagen California camper, based on the Multivan, will be offered with a plug-in hybrid powertrain when it goes on sale next year, the brand’s commercial vehicles arm has confirmed.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (39, 4, 1, N'It has released a pair of design sketches ahead of the California’s reveal at the Düsseldorf Caravan Salon trade fair (25 August), confirming it will feature a pop-out roof and gazebo.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (40, 4, 2, N'VW also hinted that the new California will feature two sliding doors, stating “no one has ever claimed that a California should have only one sliding door”. This would resolve a key grievance for California buyers in right-hand drive markets: the outgoing T6.1 model only opens on the right-hand side, which can complicate kerb-side drop-offs.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (41, 4, 3, N'A removable tablet features inside the California Concept, giving passenger access to climate and lighting controls, as well as ‘camping mode’. In T6.1, this setting deactivates the exterior lights so you don’t disturb fellow campers when unlocking the van late at night.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (42, 4, 4, N'The interior of the new California is otherwise expected to mirror the T6.1, including a kitchen area with stovetops and a cool box, a dining table and sink, and plenty more besides.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (43, 4, 5, N'Given it is based on the Multivan, the new California is anticipated to use the same plug-in hybrid powertrain. This pairs a 148bhp 1.4-litre petrol engine with a 114bhp electric motor, for a combined 215bhp. In the Multivan, this powertrain is officially rated to return 156.9mpg, but we averaged around 55mpg with a fully-charged battery in our full road test. This figure is likely to fall slightly in the California, given its tent and interior tweaks are likely to add significantly to its weight.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (44, 4, 6, N'Production of the next-generation California will begin at VW’s Hanover (Germany) plant next year, the firm confirmed in a statement. When it arrives, prices are expected to start at a significant premium compared with the T6.1, which starts at £61,322. For reference, the Mercedes-Benz V-Class Marco Polo starts at £83,490, while the Ford Transit Nugget is priced from £76,027.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (45, 4, 7, N'In the new car brands in 2023, you can refer to smash karts. There are also many beautiful car models and designs that you can see.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (46, 5, 0, N'With London’s Ultra Low Emission Zone (ULEZ) set to expand, choosing a used car has become even more complicated.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (47, 5, 1, N'Having a car that complies with Euro 4 or Euro 6 emissions standards has become a must in the UK capital.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (48, 5, 2, N'You can check if your car – or any car you''re considering buying – is compliant through the Transport for London (TfL) website.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (49, 5, 3, N'If your car doesn''t comply and you drive into the ULEZ, you will need to pay a £12.50 daily fee. If you fail to do this, you will be hit with a £120 fine.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (50, 5, 4, N'Read more: Clean Air Zones: all you need to know')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (51, 5, 5, N'Thankfully, the used-car market is abundant with petrols that comply with Euro 4 (usually produced from January 2006) and diesels that comply with Euro 6 (usually produced from September 2015).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (52, 5, 6, N'So, which ULEZ-friendly used cars should we be looking to buy? Read our list below for some top picks.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (53, 5, 7, N'Is there a cheekier-looking £2000 ULEZ-exempt car? We don’t think so. Euro 4 models are more common at this price than the Clio, which is surprising given it failed to replicate the sales success of its bigger sibling when new. Still, the 58bhp or 74bhp versions of the 1.2-litre engine are fizzy and frugal and perfectly suited to city driving, and the chassis delivers agile handling. With some clever packaging - the rear seats slide and can be removed - it''s far more practical than its tiny dimensions suggest.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (54, 5, 8, N'It was a rare sight 15 years ago and you’ll do well to find one these days, but the world’s shortest four-seater is worth sleuthing out. For one thing, it has an almost Mini-esque classless image (it’s not for nothing that Aston Martin based its Cygnet on it). For another, its styling is dating better than most other sub-£2000 cars here. It’s best suited to use around town, but is still fairly capable on the motorway. Just remember that the asymmetrical seating layout means it’s more of a 3+1 than a real four-seater, and at 32 litres, the boot is comically small.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (55, 5, 9, N'With a folding hard-top, the Golf-based Volkswagen Eos makes for a city-secure drop-top and, in the right spec, still cuts a dash today. That’s more the case with later facelifted models, though, and for our £2000 grant, we’re left with the bug-eyed original. We found a 70,000-mile model with a 1.6-litre engine, and even a couple of models with the Golf GTI’s 2.0 TFSI for some added poke. Tidy handling and a helpful 2+2 seating layout means that, so long as you avoid the problematic DSG auto, the Eos should make a great ULEZ-friendly cruiser.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (56, 5, 10, N'Crazy, I know, but my ML500 is ULEZ compliant.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (57, 5, 11, N'Not that I care to drive into London avoiding all the cameras/box junctions/20 mph limits/expensive parking.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (58, 5, 12, N'It''s not crazy about your ML500.  This is about stopping awful, heavy particulates from getting stuck in peoples lungs and older diesels were hundeds of time worse than petrol for this.  This is not about fuel economy')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (59, 6, 0, N'I still claim my Renault Scenic was the best long-term test car I was ever given custody of.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (60, 6, 1, N'It was 1997, when its features – including sliding and removable seats, a deep, aircraft-style windscreen, a two-position parcel shelf and sundry storage bins – were all novel.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (61, 6, 2, N'Soon, Scenics were popping up all over my neighbourhood, many bought by young families keen to inject some Gallic flair into their humdrum motoring lives.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (62, 6, 3, N'Forward to 2016, when the model’s fourth-generation successor was launched and those early adopters had drifted away, tempted by crossovers and SUVs. Recognising this, Renault served up a Scenic intended to appeal to the eye as much as the brain – a handsome thing with a high waistline, deeply scalloped sides with sill finishers, a curving roof, distinctive light signatures and huge, arch-filling 20in wheels.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (63, 6, 4, N'Inside, sliding rear seats that could be folded remotely, a sliding centre console with USB ports and 13 litres of storage capacity and numerous other storage solutions kept the faith. The large touchscreen crowning the dashboard delighted and challenged driver and passenger in equal measure.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (64, 6, 5, N'Hot on the heels of the Scenic came the Grand Scenic, a stretched seven-seat version that looked even better. However, like its shorter sibling, the floor is quite high, meaning rear-seat passengers sit with knees raised.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (65, 6, 6, N'Trim levels across both span Expression+ (dual-zone climate control, a digital radio) to Signature Nav (panoramic roof, leather and LED headlights). Scenic or Grand Scenic, we would pick middle-of-the-road Dynamique Nav.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (66, 6, 7, N'A choice of 1.2-litre petrol and 1.5 or 1.6-litre diesel engines plus a 1.5-litre diesel hybrid badged ''Hybrid Assist'' sent both Scenics down the road. In 2017, the 1.2 petrol was replaced by a more potent and responsive 1.3.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (67, 7, 0, N'Audi Sport is to resurrect the RS6 saloon as an electric-powered rival to the likes of the recently unveiled BMW i5 M60 saloon and the Mercedes-AMG EQE 53 saloon.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (68, 7, 1, N'Scheduled for UK introduction in 2025, the new four-door performance model is planned to be sold under the RS6 E-tron name as a sibling to the RS6 Avant E-tron, according to sources at the firm''s engineering headquarters in Neckarsulm, Germany.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (69, 7, 2, N'The impending return of the RS6 saloon to the Audi line-up has been revealed 13 years after the combustion-engined model ceased production in 2010, making way for the more sportingly styled RS7 saloon at the time.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (70, 7, 3, N'The RS6 E-tron saloon and RS6 E-tron Avant build on the upcoming A6 E-tron saloon and Avant models already confirmed for launch in 2024. Central to their performance is a newly developed electric drivetrain, elements of which have been engineered in partnership with Porsche, which will use the dual-motor system in an upgraded version of the Taycan, also due to be unveiled in 2025.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (71, 7, 4, N'The two new electric Audi Sport models are claimed to have more performance than the existing combustion-engined RS6 Avant and RS7 saloon, with up to 600bhp and over 738lb ft of torque.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (72, 7, 5, N'In combination with a two-speed gearbox on each motor and a fully variable electric Quattro four-wheel drive system, the two new performance EVs are shaping up to be the fastest-accelerating saloon and estate combinations yet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (73, 7, 6, N'Like their lesser A6 E-tron saloon and Avant siblings, the new RS6 E-tron saloon and Avant are based on the Premium Platform Electric (PPE) structure developed in an engineering partnership between Audi and Porsche. It supports an 800V electric architecture as well as a silicon-carbide inverter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (74, 7, 7, N'Other upcoming new models based on the PPE platform include the Audi Q6 E-tron SUV and Q6 E-tron Sportback as well as the Porsche Macan Electric.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (75, 7, 8, N'The A6 E-tron concept revealed in 2021 provides clues to the dimensions of the upcoming RS6 E-tron saloon. With a length of 4960mm, width of 1960mm and height of 1440mm, it is 9mm longer, 74mm wider and 18mm taller than today''s fifth-generation A6 saloon.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (76, 7, 9, N'The RS6 is synonymous with being an Avant, I can''t see anyone buying the saloon. A waste of time, especially since there''ll be an M5 Touring.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (77, 7, 10, N'Yeah I sort of agree, drive what you like not what other thing is their idea of the best, and the Avant was is better liked than the saloon.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (78, 7, 11, N'The RS6 is synonymous with being an Avant, I can''t see anyone buying the saloon. A waste of time, especially since there''ll be an M5 Touring.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (79, 7, 12, N'Doesn''t look the money either, from the rear view it looks like a mid spec car, not enough bling, no in your face Venturi under the bumpers,maybe it''s the boring Matt grey colour?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (80, 7, 13, N'Still the Car to have?, technology has kind of made good old fashioned 4WD at the retirement home door, BMW have the M5 hybrid with 830bhp and their 4 wheel steer and anyway a car is only as good as the driver.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (81, 7, 14, N'But the latest RS6 is a fantastic car, with fantastic looks. It''s now a car that makes no excuses.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (82, 7, 15, N'Erm , BMW''s new M5 Hybrid has 830bhp apparently, if this is true, doesn''t that trump Audi''s iconic RS6?, don''t think 4WD is all that these Days anyway what with technology having more to do with the underpinnings of Cars like these.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (83, 7, 16, N'Erm , BMW''s new M5 Hybrid has 830bhp apparently, if this is true, doesn''t that trump Audi''s iconic RS6?, don''t think 4WD is all that these Days anyway what with technology having more to do with the underpinnings of Cars like these.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (84, 7, 17, N'Hp correction,BMW will have 653bhp and 800+lb/ft.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (85, 8, 0, N'The Fisker Pear electric hatchback will arrive in the UK in 2025 at less than £28,000.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (86, 8, 1, N'Revealed at the Fisker Product Vision event in California last night, the Pear (for Personal Electric Automotive Revolution) has been built to anchor the American start-up’s line-up and designed to minimise production costs.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (87, 8, 2, N'"We wanted to design a car for today''s and future lifestyles," said boss Henrik Fisker at the event, adding that it has been designed to appeal to younger drivers.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (88, 8, 3, N'The EV will have room for either five or six people (it can be optioned with two three-seat benches) and offers two battery sizes: one giving 100-150 miles of range, aimed at city buyers, and another giving 300-plus miles.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (89, 8, 4, N'The smaller pack is expected to be the most popular. “In two years, you will see people realising they don''t need that [much] range, specifically if they have a second car. But it doesn''t work today. There are a few cars out there that have a 100- to 150-mile range and aren''t selling,” Henrik Fisker said previously.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (90, 8, 5, N'It will sit on a dedicated steel chassis, named SLV-1, that has been designed to have 35% fewer parts than a conventional platform in a process that Fisker dubbed “steel-plus-plus”. This will also give the Pear “sporty handling” characteristics.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (91, 8, 6, N'The “category-breaking lifestyle vehicle” is “Fisker’s vision of a sustainable EV as a connected mobility device”, said the brand.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (92, 8, 7, N'Key to this is the Fisker Blade central computing platform, which uses fewer, more centralised ECUs.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (93, 8, 8, N'Chief technology officer Burkhard Huhnke said in February that this approach reduces the material cost of the vehicle and “increases the performance drastically”. Chief financial officer Geeta Gupta-Fisker added the Pear will be “driven by software, not hardware”.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (94, 8, 9, N'Elsewhere, it comes with some unique features, such as a ''Houdini Trunk'': a boot that folds away into the rear bumper (see below). Along with a deep front storage compartment, this “simplifies cargo loading in city parking”.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (95, 8, 10, N'US buyers alos enjoy healthy incentives we in the UK can only dream about.  Ironic given the gvt is determined to phase out ICE cars failey soon.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (96, 8, 11, N'I read in an American journal recently that combined with the reductions in the price of a Tesla 3 (seemingly not reflected in the UK) and the EV incentives offered on some states the cost of a Tesla 3 was a few thousand $ of that of a Corolla.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (97, 8, 12, N'We seem to pay roughly 50% more than whatever price you see for the product in the US which would put the Pear at an unappetising £37k')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (98, 8, 13, N'I like it, and hope the whole enterprise doesn''t go pear-shaped.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (99, 8, 14, N'£28k my foot. Wait until it''s actually on sale, and you''ll see then, but I reckon £32k+ starting price. This is all dependent on Fisker delivering anything, because I''ve seen lots of ads, but not a single car.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (100, 8, 15, N'It seems like to offset the core cost of the battery, interior''s are being stripped bare to try and meet the target price, so for those looking for a ''cheap'' EV (!), expect about as basic cockpit as you could imagine.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (101, 8, 16, N'You will own nothing and be happy!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (102, 9, 0, N'You might not think London’s Ultra Low Emissions Zone (ULEZ) is something you should care about if you live outside the capital, but it can be great news if you like a motoring bargain.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (103, 9, 1, N'You see, the ULEZ is set to be expanded to encompass all of Greater London on 29 August – a significant increase in its reach that means thousands more motorists will be charged to drive non-compliant cars. As a result, such cars have flooded the used market, sending prices into freefall.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (104, 9, 2, N'If you wanted a comfy diesel for the motorway slog to work, a little supermini to nip to the shops or even to speculate on a future classic, now is the time to buy.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (105, 9, 3, N'There’s no need to feel guilty about using such cars outside built-up areas. The open air of the countryside dilutes the toxic NOx emissions to the point that they don''t pose a public health risk.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (106, 9, 4, N'Moreover, many of the diesels which run afoul of the NOx standards for the ULEZ actually emit less CO2 than their petrol counterparts. As CO2 contributes to climate change, rather than respiratory illnesses, a good diesel is often the better choice of the two fuels for limiting the damage you cause to the environment.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (107, 9, 5, N'This is our guide to the best bargains to come out of the ULEZ expansion, hand-picked from within a 25-mile radius of central London.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (108, 9, 6, N'The sixth-generation Passat is a supple, refined and spacious saloon that remains a classy pick almost 20 years later. We found a 2006 car with the 2.0-litre turbodiesel – good for more than 50mpg on the motorway – and 72,000 miles on the clock listed for sale at £1689.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (109, 9, 7, N'A Yank tank with a difference: about 20% of the 300C was derived from the 1996-2002 Mercedes-Benz E-Class, which made it a solid long-distance cruiser. An example with the Mercedes-sourced 3.0-litre diesel V6, showing fewer than 100,000 miles on the dash, is yours for £2595.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (110, 9, 8, N'Just £3200 gets you into what was once one of the world’s finest grand tourers. We’ve found one with the same V6 as in the 300C, a full service history and just two former keepers. Having racked up just 58,800 miles in 17 years, there’s plenty of life left in it.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (111, 9, 9, N'Need a cheap second car for quick trips to the shops or to teach a young’un how to drive? It doesn’t get much better than the Mk1 Yaris. We found a 1999 petrol model with 65,000 miles on the clock for just £995.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (112, 9, 10, N'CO2 does NOT contribute to Climate Change')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (113, 9, 11, N'It is the food of plant life on earth!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (114, 11, 0, N'Mercedes’ ‘W194’ endurance racer left an indelible mark on motorsport in 1952, winning Le Mans, the Nürburgring Eifelrennen and Mexico’s Carrera Panamericana, and it finished second on the Mille Miglia.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (115, 11, 1, N'It was retired after only a season, but such was the interest it caused that Mercedes’ US importer Max Hoffman (who would later prove key in the genesis of so many Porsches) suggested Mercedes should make a production version. So it did: in 1954, there followed the ‘W198’ 300 SL ‘Gullwing’.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (116, 11, 2, N'Six further generations of what would become known as the Mercedes SL followed, the longest-lived remaining in production for a remarkable 18 years. But over the decades, the SL has been defined very differently, swinging all the way from motorsport exile to thick-pile-carpeted, gently wafting, drop-top luxury icon.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (117, 11, 3, N'Mercedes says it’s going back to its roots. The new R232-generation car has officially become a Mercedes-AMG SL. Designed and developed exclusively by Mercedes’ own factory tuning department, the car comes in AMG-badged forms only and features several technical departures aimed at not only cutting weight and enhancing performance, handling and driver feedback but also boosting the daily usability for which the SL has become so well known.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (118, 11, 4, N'So has the whispering, demure, magic carpet-like Mercedes SL been fully retired and a sportier inheritor of the legend installed in its place? We turned to a full-fat Mercedes-AMG SL 63 4Matic+ to find out what the newcomer is made of.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (119, 11, 5, N'For many generations, the SL has been hitched developmentally to its contemporary S-Class limousine. The new ‘R232’ is a watershed moment in the history of this car, however, because it has been designed and developed from a clean sheet by Mercedes-AMG. And it is twinned not with a limousine but instead with Affalterbach’s next-generation AMG GT super-sports car, which is due later this year.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (120, 11, 6, N'The SL switches to the same kind of spaceframe construction that AMG has favoured for its sports cars for some time. It is aluminium-intensive but also contains magnesium, steel and carbonfibre composites, and it is significantly more torsionally, longitudinally and transversely rigid than the chassis of the ‘R231’ before it.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (121, 11, 7, N'Multi-link suspension features front and rear but, for the first time in decades, it sits below steel coil springs rather than either air or hydropneumatic suspension. All SLs get adaptive dampers and four-wheel steering as standard; upper-tier SL 63s add electromechanical active anti-roll control as part of Mercedes-AMG’s Active Ride Control suspension, plus a torque-vectoring active rear differential.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (122, 11, 8, N'Four-wheel drive is another technical departure. No previous SL has had it, but now all but the entry-level, four-cylinder, 375bhp SL 43 do. Above that are 469bhp and 577bhp turbo V8-powered versions, badged SL 55 and SL 63 respectively, with an even more potent SL 63 S E Performance due later on.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (123, 11, 9, N'And if all of that new chassis and powertrain technology sounds heavy? Well, this SL is the first since the 1990s to junk Mercedes’ old folding steel ‘vario-roof’ for a cloth alternative, itself saving 21kg and lowering the car’s centre of gravity.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (124, 11, 10, N'Our test car still weighed a pretty hefty 1939kg on the scales. That is 61kg lighter than the R230-generation SL 63 we tested in 2008 but more than 120kg heavier than the ‘R231’ SL 500 tested in 2012, both of which had a folding metal roof.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (125, 11, 11, N'The new SL’s cloth hood may be the first difference you notice, but this is the first SL in several generations to offer ‘+2’ second-row seating – although you certainly wouldn’t call it a proper four-seater.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (126, 11, 12, N'Mercedes advises that those back seats are “for passengers up to 1.5 metres tall”. They have very upright backrests and aren’t easy to access or exit, even for passengers who meet that height restriction. But while the ‘+2’ seating erodes the cabin’s sense of exclusivity, they do add some practicality – even when only carrying shopping bags.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (127, 11, 13, N'You dip low to berth the driver’s seat but will find it comfortable and widely adjustable. There is electric adjustment in just about every direction, but while much of that is automated, it’s not always done so intelligently. Open the door to get out and the seat will motor back and recline automatically to ease your egress, for example. But it will do so even when the sensors for the rear seatbelts tell the car that the chair behind is occupied – and where there was likely to have been scant leg room to begin with. The head restraints, too, have a habit of lowering themselves automatically as the hood folds up and back – but they don’t then return to their previous positions.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (128, 11, 14, N'The hood itself is an impressive piece of design, folding and stowing quickly and quietly into a surprisingly tight space that leaves a reasonable amount of luggage room. Some testers bemoaned the route by which it is controlled, however – not by a knurled physical switch but by a dedicated screen on the car’s portrait-oriented central infotainment display. Lowering the roof in a car such as this ought to be a bit of theatre to look forward to, but here it’s a disappointingly fiddly process via a surface that, when the roof has been down, can become a bit too warm to hold a fingertip against comfortably for the required 15 seconds.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (129, 11, 15, N'The SL’s tilting infotainment display is the central focus of a reductionist cabin design of a theme that Mercedes has dubbed ‘hyperanalogue’: the combination, supposedly, of a simplified classic-looking fascia geometry with the latest digital infotainment technology. But the sense of built-in quality around that screen, and of any really lavish sense of inherent expensiveness and heft to the cabin overall, is a little underwhelming.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (130, 11, 16, N'It’s all pleasant enough, but there is rather too much plastic masquerading as aluminium in evidence here, along with fewer physical controls with which to engender any substantial expensive tactile feel in the first place, to put this car on a level with the most luxurious-feeling convertibles.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (131, 11, 17, N'The SL’s major development here is an 11.9in portrait-style MBUX infotainment screen that can be adjusted between 12 and 32deg of inclination from the vertical. This means you can make it less likely to reflect light in your eyes, and at the same time it brings the top edge closer, within easier reach. It’s a feature from which more Mercedes models would benefit, because having the screen slightly closer does make it easier to prod at and swipe (although the controls mounted on the steering wheel still give you an option not to, if you prefer).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (132, 11, 18, N'Our test car had a useful head-up display, too (only bottom-rung SL 43 models miss out on it as standard), along with Mercedes’ usual choice of instrumentation display modes. It’s a more complicated array of information than many cars provide, and it does take some time to get used to the infotainment system. But overall it’s navigable enough, with practice and familiarity. The navigation system displays mapping clearly and plots routes effectively. Or, if you prefer, the car’s wireless smartphone mirroring software works reliably, too.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (133, 11, 19, N'The SL 63’s 577bhp power and 590lb ft torque peaks are emphatic statements of intent. You have to go all the way to a Porsche 911 Turbo S Cabriolet, an Aston Martin V12 Vantage, a 12-cylinder Bentley Continental GTC or a Ferrari Roma Spider to get a significantly more powerful car – and few of those are quicker-accelerating on paper.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (134, 11, 20, N'Few would be in practice, either. Aided by its effective launch control and four-wheel drive systems, and on a warm day, our test car needed just 3.5sec to hit 60mph from rest, and only 7.8sec to crack 100mph. Aston Martin’s Vantage F1 Edition was slower when we tested a coupé in 2021; Bentley’s 650bhp Continental GT Speed only a tenth or two quicker, again tested as a coupé. And what of the last SL 63 on which we did an instrumented road test, two model generations ago in 2008? It needed a yawning 2.6sec longer to get into three figures.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (135, 11, 21, N'In terms of outright accelerative performance, AMG’s blank-sheet reimagining has produced some serious results. And subjectively, 577bhp feels like plenty because, even at their wildest, SLs have always been as much grand tourers as committed sports cars. Their appeal has always been bound up in the woofling, ostentatious hot-rod charm of their V8 engines, which can be enjoyed at any speed.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (136, 11, 22, N'There’s plenty of punch here, and it’s typically smoothly provided – but there’s V8 drama, too. Lock in a higher intermediate gear from low revs and you will feel one of the first manifestations of that drama: with the tacho passing 2500rpm under maximum load, the V8’s turbos wake up to serve a hefty dose of torque to all four wheels.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (137, 11, 23, N'Ride out the full-throttle surge and the engine will pull harder and harder until beginning to tail off beyond 6000rpm. The high-range theatrics of other performance engines are omitted, then, but even so, there’s a lot of both performance and vocal presence to enjoy, the latter emanating from those quad tailpipes like some baritone battle cry if you select the noisiest, sportiest driving modes.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (138, 11, 24, N'The SL’s nine-speed automatic gearbox is impressive, too. It’s fast on the paddles in its manual mode and sufficiently slick and smooth in D that you certainly wouldn’t guess that AMG had replaced the torque converter with an automated wet clutch. Automatic downshifts under deceleration on the road can come a little suddenly in S+ and Race modes, though, and nine speeds are a little too many to keep track of during interested driving – which is why most testers preferred the manual setting.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (139, 11, 25, N'The SL 63 shows plenty of sporting purpose on track. In addition to its big accessible performance, it has considerable grip along with level and secure body control, and it is happy to be hustled along quickly.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (140, 11, 26, N'The car’s active damping, torque-vectoring, steering and active anti-roll control systems work well to make the SL seem lighter and more agile than it might. But their combined result feels too remote to make the driver feel truly involved.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (141, 11, 27, N'The SL 63 gets you through corners on line and under control without really letting you know how it’s doing so or inviting you to feel like a central part of the action. You’re never made aware of the lateral load building in its suspension and tyres as it corners or passing from one axle to the other as it changes direction.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (142, 11, 28, N'Ultimately, that AMG omitted its usual Drift mode from the car’s switchable drive settings tells you quite a lot about the firm’s expectations of the SL customer’s appetite for fun.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (143, 11, 29, N'It might have been suffocating for a sports car, but 1.9 tonnes of kerb weight isn’t too much of a disadvantage compared with some of this car’s luxury convertible rivals. For a modern sporting GT, it’s a manageable burden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (144, 11, 30, N'The truth is, steel coil suspension, together with the new tuning priorities that Mercedes-AMG has adopted here, do deliver some significant dynamic gains. To start with, the over-assisted, gloopy-feeling steering of the old SL has gone. For better or worse, there’s also a much more connected feel about the new car’s ride than there was in its predecessors, along with more consistent body control.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (145, 11, 31, N'At one level, the SL has certainly been made a more dynamically competitive driver’s car than its various forebears. But it’s one that feels less inclined to plough its own furrow, or play the rocket-propelled armchair, quite as idiosyncratically as the hot SLs of the past couple of decades. It has been made a firmer, noisier and more insistent-riding car, too, and potentially a less distinctively appealing one to those who liked the ‘fast yet filtered’ positioning of its antecedents.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (146, 11, 32, N'Oa smooth enough surface, things start quite well. Although a little lacking in natural handling fluency, the SL is certainly a shade more agile and precise than you expect it to be as you commit to a corner. It controls its mass well both vertically and laterally and is ever stable and assured at big speeds.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (147, 11, 33, N'Not by chance has Mercedes targeted the Porsche 911 Turbo Cabriolet with the price positioning of the SL 63 – and that actually makes its £170,000 base price decent relative value.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (148, 11, 34, N'Above it sits a Turbo S Convertible and a Ferrari Roma Spider, before you get into Bentley Continental GTC territory or start sizing up bigger drop-top Astons. Considering its performance, the SL 63 offers quite a lot for the money, although it’s arguably slightly less desirable than some of those rivals.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (149, 11, 35, N'If you feel an SL belongs at a more affordable price point – and you want better than a 20mpg average from your luxury Merc drop-top – an SL 43 costs from £108,165, and an SL 55 from £147,715. There’s also the E Performance plug-in hybrid waiting in the wings.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (150, 11, 36, N'Mercedes has taken some recent bold decisions to redefine many well-regarded models as it moves inexorably forward without too much regard for what has made it successful in the past. And its new SL feels like a car that has had change forced upon it.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (151, 11, 37, N'New chassis and drivetrain technology undoubtedly makes the SL 63 more effective as a sports car, and if Stuttgart’s aim was to shake off the SL’s fuddy-duddy image and attract younger buyers, that chassis makeover, combined with the comprehensive infotainment technology and the V8’s dramatic performance, might hit the target.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (152, 11, 38, N'But a returning owner of many SLs would certainly notice key deficiencies here in terms of refinement and ride comfort. On neither is the SL 63 truly poor, but it is only averagely filtered and cosseting for a luxury GT.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (153, 11, 39, N'Mercedes’ gamble is that the car’s keener handling will win it two new fans for every established one that the comfort trade-off may cost. It might be a risk worth taking, but the SL still has work to do to prove it’s really a better car because of it.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (154, 11, 40, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (155, 12, 0, N'You would have thought that of all the things in the world the new Ford Mustang didn''t need, it was a new name tag.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (156, 12, 1, N'After Boss, Mach 1, Bullitt, Shelby GT350 and Shelby GT500, surely there were enough. Apparently not. Welcome, then, the new Ford Mustang Dark Horse. I know...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (157, 12, 2, N'And if that’s not confusing enough, there are the differences between the Mustangs with Performance Packs, those with Handling Packs and the variants sold in the US and those heading in our direction.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (158, 12, 3, N'I will try my best to clear the fog for you. Right now, the Dark Horse is the only tuned version of the new seventh-generation Mustang there is. Shelbys will definitely come, as will many, some or more of the others, but that’s all for the future. And when I say seventh-generation Mustang, read heavily facelifted sixth-generation Mustang, whose standout feature, common to all ''Stangs, is a much improved though still hardly plush interior with a two large digital screens where once there were real instruments.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (159, 12, 4, N'The Dark Horse will cost around £61,000, adding about £10,000 to the price of the standard V8 Mustang GT when both go on sale in the UK early next year.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (160, 12, 5, N'There''s no four-cylinder turbo Ecoboost version of either car. I’m over it, too.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (161, 13, 0, N'As the struggles of so many car makers to ignite the sales growth of their electric car lines continue to show, there’s still plenty of need for reassurance among those looking to buy their first EV.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (162, 13, 1, N'While people who’ve already made the leap may argue it differently, many still see electric cars, which cost more than their ICE equivalents, as having potentially problematic usability for those who can’t depend on easy home charging.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (163, 13, 2, N'The Fisker Ocean, the emergent American-based EV specialist’s first production car, engages with those perceptions head on. Designed in California but built by Magna Steyr in Austria (on the same line that, until recently, cranked out the BMW 530e), this is an unexpectedly compact, European-flavoured SUV that leads with its smooth-surfaced, sophisticated design. In the metal, it looks a little like a slightly squatter, stretched Range Rover Evoque - but it certainly escapes the awkward proportions of so many of its electric rivals, and is distinctive enough to stand out in its own right. It''s a good-looking car, this - just as you''d expect given the reputation of the eminent car designer whose name adorns its model badge.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (164, 13, 3, N'But while the Ocean’s wide-stanced, sharp-featured styling is typically seen on cars with ‘premium-brand’ associations, Fisker actively avoids such a classification. It sees customers moving away from the automotive nameplates associated with consumerist ‘aspiration’ over the past half-century and towards new ones that better embody their personal values. Then again, if it only asks those who come and knock on its door in the first place, so it probably would.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (165, 14, 0, N'The leaders of the West Midlands Gigafactory (WMG) project have called for further government investment in UK battery manufacturing, following Tata’s announcement that it will spend £4 billion to open a factory in Somerset as soon as 2026.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (166, 14, 1, N'The start-up said in a statement that the government’s commitment to UK automotive (through the Tata plant) made it “clear the UK government recognises the urgency of supporting the UK’s mobility and energy storage sectors”.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (167, 14, 2, N'The BBC reported in May that incentives offered to Tata during negotiations – including monetary grants and energy subsidies – were worth close to £800 million.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (168, 14, 3, N'“We''re now extremely hopeful that this example will be continued,” said WMG.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (169, 15, 0, N'Jaguar today has “no equity whatsoever”, JLR chief creative officer Gerry McGovern told investors at a conference in June.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (170, 15, 1, N'So how will JLR build up a brand and capture buyers in the £100,000-plus luxury space it wants to occupy if it has no meaningful brand power in the market?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (171, 15, 2, N'We already know Jaguar will relaunch as an electric brand in 2025 with a “four-door GT” car with a range of around 435 miles.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (172, 17, 0, N'With London’s Ultra Low Emission Zone (ULEZ) set to expand, choosing a used car has become even more complicated.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (173, 17, 1, N'Having a car that complies with Euro 4 or Euro 6 emissions standards has become a must in the UK capital.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (174, 17, 2, N'You can check if your car – or any car you''re considering buying – is compliant through the Transport for London (TfL) website.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (175, 17, 3, N'If your car doesn''t comply and you drive into the ULEZ, you will need to pay a £12.50 daily fee. If you fail to do this, you will be hit with a £120 fine.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (176, 17, 4, N'Read more: Clean Air Zones: all you need to know')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (177, 17, 5, N'Thankfully, the used-car market is abundant with petrols that comply with Euro 4 (usually produced from January 2006) and diesels that comply with Euro 6 (usually produced from September 2015).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (178, 17, 6, N'So, which ULEZ-friendly used cars should we be looking to buy? Read our list below for some top picks.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (179, 17, 7, N'Is there a cheekier-looking £2000 ULEZ-exempt car? We don’t think so. Euro 4 models are more common at this price than the Clio, which is surprising given it failed to replicate the sales success of its bigger sibling when new. Still, the 58bhp or 74bhp versions of the 1.2-litre engine are fizzy and frugal and perfectly suited to city driving, and the chassis delivers agile handling. With some clever packaging - the rear seats slide and can be removed - it''s far more practical than its tiny dimensions suggest.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (180, 17, 8, N'It was a rare sight 15 years ago and you’ll do well to find one these days, but the world’s shortest four-seater is worth sleuthing out. For one thing, it has an almost Mini-esque classless image (it’s not for nothing that Aston Martin based its Cygnet on it). For another, its styling is dating better than most other sub-£2000 cars here. It’s best suited to use around town, but is still fairly capable on the motorway. Just remember that the asymmetrical seating layout means it’s more of a 3+1 than a real four-seater, and at 32 litres, the boot is comically small.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (181, 17, 9, N'With a folding hard-top, the Golf-based Volkswagen Eos makes for a city-secure drop-top and, in the right spec, still cuts a dash today. That’s more the case with later facelifted models, though, and for our £2000 grant, we’re left with the bug-eyed original. We found a 70,000-mile model with a 1.6-litre engine, and even a couple of models with the Golf GTI’s 2.0 TFSI for some added poke. Tidy handling and a helpful 2+2 seating layout means that, so long as you avoid the problematic DSG auto, the Eos should make a great ULEZ-friendly cruiser.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (182, 17, 10, N'Crazy, I know, but my ML500 is ULEZ compliant.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (183, 17, 11, N'Not that I care to drive into London avoiding all the cameras/box junctions/20 mph limits/expensive parking.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (184, 17, 12, N'It''s not crazy about your ML500.  This is about stopping awful, heavy particulates from getting stuck in peoples lungs and older diesels were hundeds of time worse than petrol for this.  This is not about fuel economy')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (185, 18, 0, N'Ten years since it was launched, the Alfa Romeo 4C still turns heads, still quickens pulses, still provokes debate. In the intervening years, the Alpine A110 has arrived and proved that it’s possible to have as much fun but be comfortable, too.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (186, 18, 1, N'Yet it doesn’t pluck the heartstrings in the same way, at least if your ticker is stamped ‘Alfa Romeo’. Production of the 4C ran from 2013 to 2020, and today there are only about 475 examples in the UK. For some years, few used ones came to market, but just recently more have begun to emerge. As this was written, around 20 were being offered at prices starting from £44,000. That compares with £35,000 two years ago.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (187, 18, 2, N'Proving that Alfisti prefer to drive their cars than salt them away, many have done reasonable mileages, a few around 30,000.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (188, 18, 3, N'The 4C comes in two flavours: original coupé and Spider, the latter launched in 2015 with a sticker price of £59,500 over the coupé’s £52,000.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (189, 18, 4, N'They are constructed around a strong yet light carbonfibre tub with aluminium subframes front and rear. The body panels are made of a composite material that flexes on impact and doesn’t dent, although it will tear if struck hard enough.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (190, 18, 5, N'The steering is unassisted and the suspension by a double-wishbone arrangement at the front and MacPherson struts behind. The engine is a mid-mounted 1.75-litre turbo petrol four-pot. It produces 237bhp and drives the rear wheels through, when it behaves, a lightning-quick, six-speed dual-clutch automatic transmission.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (191, 18, 6, N'With the coupé weighing only 925kg and the Spider 1080kg, 0-62mph takes 4.5sec, but its in-gear acceleration impresses more.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (192, 18, 7, N'At launch, the 4C attracted mixed press. Everyone loved its looks and rawness, but a few testers, including Autocar’s, criticised its unruly handling and steering on all but the smoothest of surfaces. Alfa took note and recalled early cars for tweaks to their geometry.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (193, 18, 8, N'Lovely!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (194, 19, 0, N'AUTO BILD deckte auf: VWs Biturbo-Diesel im T5 hat einen schweren Konstruktionsfehler. Nun tauchen auch beim T6 Motorschäden auf. Das müssen Bulli-Besitzer wissen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (195, 19, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (196, 19, 2, N'VW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (197, 19, 3, N'T6 von Andreas Wien ist ein echter Schluckspecht. Sein Bulli, Baujahr 2016, säuft aber keinen Sprit, sondern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (198, 19, 4, N'Motoröl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (199, 19, 5, N': fünf Liter auf 4000 Kilometern, bei einem Kilometerstand von 122.000. Der VW-Besitzer aus Geesthacht (Schleswig-Holstein) führt auf Anraten seiner Werkstatt Buch über den Schmiermittelverlust – und macht sich Sorgen um seinen einstigen Traumwagen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (200, 19, 6, N'Zu Recht. Denn die Fälle von Motorschäden beim T6 mit dem Biturbo-Diesel (204 PS, Motorcode CXEB) häufen sich. Laut VW wurden weltweit 84.359 T6 der Modelljahre 2016 bis 2019 mit dem Top-Aggregat ausgeliefert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (201, 19, 7, N'Viele Kunden klagen über Leistungseinbußen, Kühlwasserverlust und hohen Ölverbrauch – alles Vorboten für den endgültigen Ausfall des Triebwerks. Dagegen hilft kein Öl-Tagebuch, sondern nur der Tausch des Motors und weiterer bereits beschädigter Bauteile. Und ein hartnäckiges Auftreten gegenüber dem Hersteller.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (202, 19, 8, N'ZoomMutmaßliche Ursache für den Ölverbrauch: Verkokungen der Feder im Ölabstreifring machen ihn unbeweglich, er liegt nicht mehr an der Zylinderwand an, Öl dringt in den Brennraum ein. Bild: privat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (203, 19, 9, N'Mutmaßliche Ursache für den Ölverbrauch: Verkokungen der Feder im Ölabstreifring machen ihn unbeweglich, er liegt nicht mehr an der Zylinderwand an, Öl dringt in den Brennraum ein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (204, 19, 10, N'Volkswagen ist das Problem bekannt. Auf Nachfrage spricht VW von einer Schadensrate "im niedrigen einstelligen Prozentbereich". Zu den technischen Gründen heißt es lediglich, es könne unter bestimmten Einsatzbedingungen zu einem "innermotorisch bedingten erhöhten Verschleiß" kommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (205, 19, 11, N'So gibt es eine Reparaturroutine, bei der Rumpfmotor,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (206, 19, 12, N'Partikelfilter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (207, 19, 13, N', Kat und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (208, 19, 14, N'Lambdasonde')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (209, 19, 15, N'getauscht werden. Allein die Kosten für das Material belaufen sich auf etwa 12.800 Euro, die dank einer "umfangreichen Kulanzregelung" – abhängig von Fahrzeugalter und Laufleistung – nicht allein vom Kunden getragen würden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (210, 19, 16, N'Ein solches Angebot ist ebenso wenig an Andreas Wien herangetragen worden wie an Christian Bender aus Blieskastel-Aßweiler (Saarland). Im Dezember 2022 fiel der Turbo seines T6 von 2018 aus, der Ölverbrauch lag da bei zwei Litern auf 1000 Kilometern – bei einem Kilometerstand von knapp 130.000. Von VW hat Bender seit März 2023 nichts gehört, eine Kostenbeteiligung ist nicht in Sicht. Inzwischen hat der VW-Fahrer einen Anwalt eingeschaltet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (211, 19, 17, N'ZoomVerkokte Kolben und Kolbenringe: Folgen einer mangelhaften Ölrückführung und minderer Materialqualität, vermutet Instandsetzer Richard Wild. Bild: privat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (212, 19, 18, N'Verkokte Kolben und Kolbenringe: Folgen einer mangelhaften Ölrückführung und minderer Materialqualität, vermutet Instandsetzer Richard Wild.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (213, 19, 19, N'Das hat auch Jürgen Eichhorn aus Nürnberg getan. Seit Ende März 2023 steht sein T6 (Baujahr 2017, 80.000 km) in der Werkstatt. Ein erster Reparaturversuch schlug fehl. Bei einer endoskopischen Untersuchung fanden sich dann Metallteile im Kraftstoff – der Motor von innen zerstört.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (214, 19, 20, N'Am Telefon prognostizierte ihm VW Kosten in Höhe von mindestens 20.000 Euro. Das Auto und bereits getauschte Teile sind jetzt Beweismittel; gerade beauftragte das Gericht ein unabhängiges Gutachten. Für Eichhorn steht fest: "Es ist weniger die Frage, ob Probleme auftreten, sondern eher, wann."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (215, 19, 21, N'Das legen auch Erkenntnisse der Internetseite "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (216, 19, 22, N'motorschadenvergleich.de')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (217, 19, 23, N'" nahe. Dort zählt man über die vergangenen zwölf Monate 65 Anfragen zu einem überarbeiteten CXEB-Motor. "Eine solche Häufung ist sehr ungewöhnlich. Der Motor scheint besonders anfällig für Schäden zu sein", sagt Josua Schulte, einer der Macher des Portals.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (218, 19, 24, N'Die technischen Ursachen lassen sich bislang nicht so klar eingrenzen wie im Falle des Vorgängers')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (219, 19, 25, N'VW T5, bei dem mangelhafte AGR-Kühler das Problem sind')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (220, 19, 26, N'. Schulte vermutet eine konstruktive Schwäche des Ventils der Abgasrückführung (AGR) in Verbindung mit dem Software-Update im Zuge des Dieselskandals. Dies könnte die thermische Belastung im Motor erhöht haben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (221, 19, 27, N'AUTO BILD Gebrauchtwagenmarkt99.780 €VW T6 Multivan 2.0TDI DSG 4M Highline +INDIVIDUAL+ T6.14.800 km150 KW (204 PS)06/2023Zum AngebotDiesel, 7 l/100km (komb.), CO2 Ausstoß 184 g/km*79.450 €VW T6 Multivan T6.1 Multivan 2.0 TDI Comfortline 4MOTION Stdhzg.-5.500 km150 KW (204 PS)05/2023Zum AngebotDiesel, 7,2 l/100km (komb.), CO2 Ausstoß 190 g/km*69.985 €VW T6 Multivan T6.1 California Ocean "Edition" 2.0TDI DSG41.443 km110 KW (150 PS)04/2023Zum Angebot69.900 €VW T6 Multivan T6.1 Trend DSG 4motion Standhz. Navi AHK ACC SHZ7.400 km110 KW (150 PS)03/2023Zum AngebotDiesel, 8,2 l/100km (komb.), CO2 Ausstoß 215 g/km*77.645 €VW T6 Multivan T6.1 Multivan Comfortline 4Motion TDI DSG|AHK|2.550 km150 KW (204 PS)02/2023Zum AngebotDiesel, 8,5 l/100km (komb.), CO2 Ausstoß 223 g/km*77.445 €VW T6 Multivan T6.1 Multivan Comfortline 4Motion TDI DSG|AHK|2.550 km150 KW (204 PS)02/2023Zum AngebotDiesel, 8,5 l/100km (komb.), CO2 Ausstoß 223 g/km*95.990 €VW T6 Multivan T6.1 Multivan Generation Six 4MOTION EDITION15.000 km150 KW (204 PS)12/2022Zum AngebotDiesel, 7 l/100km (komb.), CO2 Ausstoß 185 g/km*67.945 €VW T6 Multivan T6.1 Multivan Comfortline TDI 4MO DSG|AHK|TÜRLI|13.670 km150 KW (204 PS)12/2022Zum AngebotDiesel, 8,6 l/100km (komb.), CO2 Ausstoß 225 g/km*71.900 €VW T6 Multivan T6.1 Multivan Comfortline 4M 2.0 TDI DSG~LED~ACC5.100 km150 KW (204 PS)12/2022Zum AngebotDiesel, 7 l/100km (komb.), CO2 Ausstoß 185 g/km*71.900 €VW T6 Multivan T6.1 Multivan Comfortline 4M 2.0 TDI DSG~LED~ACC6.100 km150 KW (204 PS)12/2022Zum AngebotDiesel, 7 l/100km (komb.), CO2 Ausstoß 185 g/km*Alle VW T6 Multivan gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (222, 19, 28, N'Beim Instandsetzer Wild Motoren in Unterpleichfeld (Bayern) melden sich etwa 15 bis 20 T6-Besitzer im Monat. Chef Richard Wild glaubt, dass Ausführung und Materialqualität von Kolbenringen und Kolben den Anforderungen auf Dauer nicht gewachsen und somit Ursache für den Ölverbrauch sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (223, 19, 29, N'Inzwischen haben sich auch Rechtsanwälte auf Motorschäden beim T6 spezialisiert. Wie Pascal Fuest aus Meerbusch, der vor allem von thermischen Problemen und defekten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (224, 19, 30, N'AGR-Ventilen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (225, 19, 31, N'spricht. Rechtsanwalt Frederick Gisevius aus Stuttgart vertritt nach eigenen Angaben bereits 20 Geschädigte, ihn erreichen derzeit etwa fünf neue Anfragen pro Woche.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (226, 19, 32, N'Gisevius geht von "mehreren konstruktiven Schwachstellen im Verbund mit den Update-Folgen" aus. Zudem stellt er einen "nicht unerheblichen Widerstand von VW" fest. Der Autohersteller habe von sich aus kein Interesse, "eine wirtschaftlich vernünftige Lösung für alle betroffenen T6-Fahrer anzubieten". Aus einem technischen Problem macht VW für seine enttäuschten Kunden nun auch noch ein juristisches.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (227, 20, 0, N'Der GLC ist der Verkaufsschlager von Mercedes, jetzt legt AMG mit dem GLC 43 und GLC 63 S nach – mit Hybrid-Antrieb und bis zu 680 PS. Die Infos und erste Preise!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (228, 20, 1, N'AMG liefert zwei Performance-Versionen vom Mittelklasse-SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (229, 20, 2, N'GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (230, 20, 3, N':')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (231, 20, 4, N'GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (232, 20, 5, N'43 und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (233, 20, 6, N'GLC 63 S E Performance')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (234, 20, 7, N'. Zweimal vier Zylinder, beide Motoren elektrifiziert und mit mächtig Leistung gehen die beiden Sport-SUV an den Start – als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (235, 20, 8, N'GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (236, 20, 9, N'63 sogar mit Plug-in-Hybrid. Der AMG GLC 43 ist ab sofort bestellbar, zu Preisen ab 86.870 Euro, der GLC 63 S folgt später.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (237, 20, 10, N'Die beliebtesten SUV bei Carwow
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Preis
Zum Angebot












                                                                                    Kia EV6                                                                            




                                                                                    UVP ab 46.990 EUR/Ersparnis bei Carwow bis zu 12.077,00 EUR
                                                                            






















                                                                                    VW T-Roc                                                                            




                                                                                    UVP ab 25.860 EUR/Ersparnis bei Carwow bis zu 8809,00 EUR
                                                                            






















                                                                                    Dacia Spring                                                                            




                                                                                    UVP ab 22.750 EUR/Ersparnis bei Carwow bis zu 7178,00 EUR
                                                                            






















                                                                                    Kia Sportage                                                                            




                                                                                    UVP ab 34.250 EUR/Ersparnis bei Carwow bis zu 7791,00 EUR
                                                                            






















                                                                                    Hyundai Ioniq 6                                                                            




                                                                                    UVP ab 43.900 EUR/Ersparnis bei Carwow bis zu 7995,00 EUR
                                                                            






















                                                                                    Skoda Kamiq                                                                            




                                                                                    UVP ab 24.370 EUR/Ersparnis bei Carwow bis zu 8071,00 EUR
                                                                            






















                                                                                    Telsa Model Y                                                                            




                                                                                    UVP ab 44.890 EUR/Ersparnis bei Carwow bis zu 7177,00 EUR
                                                                            






















                                                                                    Cupra Formentor                                                                            




                                                                                    UVP ab 35.530 EUR/Ersparnis bei Carwow bis zu 11.517,00 EUR
                                                                            






















                                                                                    Ford Kuga                                                                            




                                                                                    UVP ab 36.250 EUR/Ersparnis bei Carwow bis zu 13.264,00 EUR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (238, 20, 11, N'Doch bereits die Einstiegs-Motorisierung ist keinesfalls schwach auf der Brust. Vier Zylinder, aber aus den zwei Litern Hubraum schöpft das Aggregat stolze 421 PS (310 kW), zudem unterstütz im unteren Drehzahlbereich ein zusätzlicher Boost mit 14 PS (10 kW) über einen Riemen-Startergenerator beim Anfahren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (239, 20, 12, N'Und hybridisiert geht''s auch bei der größten Ausbaustufe zu, der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (240, 20, 13, N'AMG GLC 63 S')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (241, 20, 14, N'übernimmt den Antriebsstrang des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (242, 20, 15, N'AMG C 63')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (243, 20, 16, N'mit Plug-in-Hybrid-Technologie. Ja, einigen wird der Vierliter-V8-Biturbo der vorangegangenen Generation fehlen, aber mit einer Systemleistung von 680 PS (500 kW) sowie einem Systemdrehmoment von bis zu 1020 Nm dürfte auch der Neue ordentlich nach vorne marschieren. Übrigens: Mit einer Verbrenner-Leistung von 476')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (244, 20, 17, N'PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (245, 20, 18, N'(350 kW) ist der Motor des GLC 63 S der stärkste Serien-Vierzylinder.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (246, 20, 19, N'ZoomDie fette Abgasanlage verrät den AMG, unter der Haube gibt''s bis zu 680 PS und ein maximales Drehmoment von 1020 Nm. Bild: Daimler AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (247, 20, 20, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (248, 20, 21, N'Die fette Abgasanlage verrät den AMG, unter der Haube gibt''s bis zu 680 PS und ein maximales Drehmoment von 1020 Nm.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (249, 20, 22, N'Für noch mehr Agilität und Fahrspaß sollen dazu eine serienmäßige Hinterachslenkung mit 2,5 Grad Lenkwinkel und ein vollvariabler Allradantrieb sorgen. Geschaltet wird bei beiden Modellen serienmäßig über ein Neungang-Doppelkupplungsgetriebe mit nasser Anfahrkupplung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (250, 20, 23, N'Mehr Leistung bedeutet in der Regel auch mehr Beschleunigung – und ja, beim Standardsprint legen die AMG-Versionen noch mal etwas zu. Statt bisher in 4,9 Sekunden sprintet der neue AMG GLC 43 in 4,8 Sekunden auf Tempo 100, etwas größer ist der Unterschied beim GLC 63 S, der holt noch mal 0,3 Sekunden raus und knackt das Landstraßen-Tempo jetzt nach 3,5 Sekunden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (251, 20, 24, N'Bei der Höchstgeschwindigkeit ändert sich jedoch wenig, beim')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (252, 20, 25, N'GLC 43')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (253, 20, 26, N'bleibt''s bei abgeregelten 250 km/h, der stärkere 63er verliert sogar etwas Top-Speed. Statt der ursprünglichen 280 km/h ist jetzt bei Tempo 275 Schluss – das ist aber immer noch alles andere als langsam. Dank einer 6,1-kWh-Batterie kann er auch rein elektrisch fahren, jedoch nur zwölf Kilometer, bis sich der Benziner wieder zu Wort meldet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (254, 20, 27, N'ZoomSportliches Interieur mit AMG-Sitzen, wahlweise mit Mikrofaser bezogen. Das Lenkrad ist abgeflacht und mit AMG-Knöpfen bestückt. Bild: Daimler AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (255, 20, 28, N'Sportliches Interieur mit AMG-Sitzen, wahlweise mit Mikrofaser bezogen. Das Lenkrad ist abgeflacht und mit AMG-Knöpfen bestückt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (256, 20, 29, N'Okay, leistungsseitig zeigt sich das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (257, 20, 30, N'SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (258, 20, 31, N'trotz des Vierzylinders als AMG – und wie sieht''s optisch aus? Auch hier hat man sich in Affalterbach an den typischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (259, 20, 32, N'AMG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (260, 20, 33, N'-Zutaten bedient. Bedeutet auch beim neuen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (261, 20, 34, N'AMG-GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (262, 20, 35, N'wieder den Panamericana-Grill mit vertikalen Lamellen und die bekannte Vierrohr-Abgasanlage.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (263, 20, 36, N'ZoomDie richtigen Walzen für das SUV: Je nach Wunsch lassen sich bis zu 21 Zoll an den GLC schrauben. Bild: Daimler AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (264, 20, 37, N'Die richtigen Walzen für das SUV: Je nach Wunsch lassen sich bis zu 21 Zoll an den GLC schrauben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (265, 20, 38, N'Dazu neue Schürzen mit größeren Lufteinlässen, eine große Verbund-Bremse mit bis zu 390 Millimeter-Scheiben, ein fetter Heckdiffusor, Carbon-Teile, AMG-Embleme und bis zu 21 Zoll große AMG-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (266, 20, 39, N'Felgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (267, 20, 40, N', et voilà. Eine Sportabgasanlage soll zudem für einen kraftvollen, sportlichen Klang sorgen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (268, 20, 41, N'Innen wie außen sind es vor allem die Details, die den AMG von der Basis-Variante unterscheiden. Angefangen mit den AMG-Sitzen, die entweder mit einer Kombination aus einer Ledernachbildung und Mikrofaserstoff oder in Nappaleder mit geprägten AMG-Wappen angeboten werden. Alternativ lassen sich auch Performance-Sitze ordern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (269, 20, 42, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (270, 20, 43, N'Als Handschmeichler dient ein neues, unten abgeflachtes Lenkrad, ebenfalls in einer Leder-Mikrofaser-Kombination gehalten und mit mit AMG-spezifischen Knöpfen und Drehreglern bestückt. Dahinter das Infotainment-System, das mit speziell für die Sport-Ableger vorbehaltenen Anzeigen und Funktionen kommt, zu denen auch eigenständige Darstellungen im Kombiinstrument, dem Zentral- und Head-up-Display gehören. Zum Marktstart wird es – wie bei einigen anderen AMG-Versionen auch – eine First Edition mit erweiterten Ausstattungs- und Designumfängen geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (271, 20, 44, N'Zum Marktstart hat sich AMG noch nicht geäußert, eine Markteinführung Ende 2023 ist aber denkbar – der GLC 43 ist zumindest bereits bestellbar. Preislich wird das Sport-SUV deutlich über dem Vorgänger starten, der bisher als AMG GLC 43 bei 69.966 Euro und als größerer GLC 63 S bei 97.520 Euro startete.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (272, 20, 45, N'Zum Bestellstart des GLC 43 wird der kleinere Einstiegs-AMG des GLC bei 86.870 Euro starten, ist also gut 16.900 Euro teurer als bisher. Die Preise für den großen AMG GLC 63 S sind noch nicht bekannt, analog zum Einstiegspreis des GLC 43 dürfte der dann aber bei gut 115.000 Euro beginnen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (273, 21, 0, N'Die Campingplätze am italienischen Lago di Garda locken mit Frischekicks, in der Schweiz ist Camping beliebter als vor Coronazeiten und in Meck-Pomm gibt es ein neues Glamping-Angebot.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (274, 21, 1, N'Die Plätze und Feriendörfer von Lago di Garda Camping bieten Urlaubern in dieser Saison einige Neuerungen am größten See Italiens: So hat das Camping Village & Glamping Riva Blu in Padenghe sul Garda seinen Wasserpark um einen beheizten Poolbereich mit Entspannungsecke und Whirlpool erweitert. Für die Kleinsten gibt es eine Lagune mit Rutschen und Wasserspielen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (275, 21, 2, N'Das Le Palme Camping in Lazise bietet jetzt die Möglichkeit, Privattoiletten für die Dauer des Aufenthalts zu mieten. Neu außerdem: ein Restaurant mit Panoramablick sowie ein Minimarkt mit frischen und lokalen Produkten. Das Lido Family Camping and Village denkt in der neuen Saison an Eltern und hat neben einer Mini-Disco einen Indoor-Kinderbereich des Mini-Clubs eingerichtet, wo sich Animateure um die jungen Gäste kümmern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (276, 21, 3, N'ZoomDas Le Palme Camping liegt an der Olivenriviera nahe den Freizeitparks Gardaland und Movieland.  Bild: Pincamp')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (277, 21, 4, N'Das Le Palme Camping liegt an der Olivenriviera nahe den Freizeitparks Gardaland und Movieland.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (278, 21, 5, N'Ein weiterer recht neuer Komfortplatz bei Lazise – das IdeaLazise Camping & Village mit XL-Wasserpark und üppigem Freizeitprogramm – wirbt mit Angeboten für den Herbst, darunter 15 Prozent Rabatt bei einem Mindestaufenthalt von 14 Nächten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (279, 21, 6, N'Im Ort Heiden läuft ein Pilotversuch mit neun zentral gelegenen Stellplätzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (280, 21, 7, N'Der Trend ist auch 2023 stabil: Bereits 2022 lag die Zahl der Buchungen auf den Campingplätzen des Touring Club Schweiz (TCS) um 43 Prozent höher als vor der Corona-Pandemie (2019). Auch die Zahl der TCS-Mitgliedschaften stieg um elf Prozent auf ein Rekordhoch. Gleichzeitig wuchs die Familie der Campingplätze. Neu 2023: Camping La Tène Neuenburgersee mit Zugang zum Sandstrand.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (281, 21, 8, N'Einen anderen Weg in puncto Cam-ping geht die Stadt Heiden im Kanton Appenzell zwischen Bodensee und Alpstein: Als eine der ersten Schweizer Gemeinden bietet sie neun Wohnmobilstellplätze in zentraler Lage.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (282, 21, 9, N'Camper')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (283, 21, 10, N'dürfen maximal drei Nächte bleiben (Kosten: ab 12 Franken plus Kurtaxe pro Nacht). Öffentliche Toiletten sind vorhanden. Weitere Infos:')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (284, 21, 11, N'www.kurvereinheiden.ch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (285, 21, 12, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (286, 21, 13, N'Die Prima Relax-Oase mit Wellness, Natur-und Kultur-ausflügen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (287, 21, 14, N'Die neue Luxus-Camping- und Ferienhausanlage "Prima Resort Boddenblick" am Rande des Barther Boddens will ab Spätsommer die ersten Buchungen entgegennehmen. Top: die Lage inmitten der Küstenlandschaft an der Ostsee. Das Resort bietet neben Zelt- und Reisemobilstellplätzen auch Tinyhäuser und Schlaffässer.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (288, 21, 15, N'"Wie auf einem Kreuzfahrtschiff, nur auf dem Land", verspricht Prima Resorts. Für dieses Feeling sorgen: Restaurant, Sauna, Poolbar, Wellnessanwendungen und vieles mehr. Reserviert und bezahlt wird per Prima-Resort-App. Mehr unter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (289, 21, 16, N'www.prima-resorts.com')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (290, 21, 17, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (291, 23, 0, N'Die nächste 5er-Generation G60, der kommende X3, der neue X2 und der elektrische i7: AUTO BILD zeigt alle kommenden BMW-Modelle bis 2025!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (292, 23, 1, N'BMW will sich mehr auf Elektromobilität konzentrieren: Bis 2030 soll mindestens die Hälfte der weltweit verkauften BMW-Modelle aus Elektroautos bestehen. Dazu sind eine neue, auf E-Autos ausgelegte Architektur sowie neu entwickelte Antriebe und Batterien geplant.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (293, 23, 2, N'Zudem fokussiert sich')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (294, 23, 3, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (295, 23, 4, N'auf das Thema Nachhaltigkeit, die Bayern wollen "das grünste Auto" bauen. Komplett')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (296, 23, 5, N'vom Verbrenner')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (297, 23, 6, N'verabschieden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (298, 23, 7, N'will man sich aber noch nicht, stattdessen setzt BMW auf eine Doppelstrategie. Wahrscheinlich auch deshalb, weil sich noch nicht abschätzen lässt, welches Antriebskonzept die Kunden in den kommenden Jahren nachfragen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (299, 23, 8, N'Die Generation G60/G61 wird im Oktober 2023 vorgestellt. Natürlich gibt es den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (300, 23, 9, N'5er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (301, 23, 10, N'wieder in zwei Karosserieformen: als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (302, 23, 11, N'Limousine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (303, 23, 12, N'und als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (304, 23, 13, N'Kombi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (305, 23, 14, N', der bei BMW Touring genannt wird. Und schon auf den ersten Blick wird klar: Der Neue ist klein geschrumpfter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (306, 23, 15, N'7er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (307, 23, 16, N'. Die bekannte Doppelnieren-Front fällt deutlich dezenter aus als bei der Luxuslimousine und auch die Scheinwerfer sind nicht zwei, sondern einteilig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (308, 23, 17, N'Bei den Motoren setzt BMW auf eine flächendeckende Elektrifizierung, alle Verbrenner erhalten ein 48 Volt-Bordnetz und Mildhybrid, dazu kommen Plug-in-Hybride und die erste Elektro-Version i5 mit 340 bis 601')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (309, 23, 18, N'PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (310, 23, 19, N'und bis zu 582 WLTP-Kilometern Reichweite. Auch vom Kombi soll es eine elektrische Variante geben. Das wäre dann der erste Elektro-Kombi von BMW.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (311, 23, 20, N'Im Herbst kommt der neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (312, 23, 21, N'5er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (313, 23, 22, N'zu den Händlern, die Touring-Variante sowie die Plug-in-Hybride und weitere Motoren mit Sechszylinder folgen sukzessive ab Anfang 2024. Basispreis für die Oberklasse-Limousine ist ab 57.550 Euro, für den i5 werden mindestens 70.200 Euro fällig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (314, 23, 23, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (315, 23, 24, N'XM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (316, 23, 25, N'ist nicht nur das erste M-Modell mit Plug-in-Hybridantrieb, sondern auch das stärkste Serienfahrzeug mit Straßenzulassung von BMWs Performance-Marke. Beim Design setzen die Münchner auf einige Elemente des legendären M1: Beispielsweise kommt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (317, 23, 26, N'XM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (318, 23, 27, N'mit einem goldenen Akzentband an der Seite – angelehnt an die schwarze Seitenleiste des M1.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (319, 23, 28, N'BildergalerieKameraNeue BMW (2023 bis 2025)15 BilderPfeil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (320, 23, 29, N'Unterm Blech arbeitet ein neu entwickelter 4,4-Liter-V8-Biturbo, der zusammen mit einem E-Motor auf eine Systemleistung von 480 kW (653 PS) und ein maximales Drehmoment von 800 Nm kommt. Doch damit nicht genug: Mit einer limitierten "Label Red"-Edition bringt BMW noch ein Sondermodell mit noch mehr Leistung, dann reißen 550 kW (748 PS) und 1000 Nm an den Rädern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (321, 23, 30, N'Seit 2018 ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (322, 23, 31, N'X2')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (323, 23, 32, N'als schickerer Bruder des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (324, 23, 33, N'BMW X1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (325, 23, 34, N'unterwegs. Doch statt wie bisher als Lifestyle-SUV vorzufahren, wird der kommende X2 – wahrscheinlich ab Ende 2023 – als richtiges SUV-Coupé an den Start gehen. Vorn steckt viel vom X1 drin, hinten schließt er mit klassischem Fließheck, Spoiler und auffälligen Rückleuchten ab.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (326, 23, 35, N'Ob BMW den 136 PS starken Basis-Benziner aus dem X1 auch im sportlicher angehauchten X2 anbietet, bleibt fraglich. Denkbar ist, dass der Einstieg erst bei 170 PS im X2 sDrive20i möglich sein wird – mit Frontantrieb und Mildhybrid-Unterstützung. Die Allradversion xDrive23i mit 218 PS gilt als gesetzt, und neben Plug-in-Hybriden dürfte es auch einen elektrischen iX2 geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (327, 23, 36, N'AUTO BILD zeigt alle kommenden BMW-Modelle bis 2025! Los geht''s mit dem BMW M2; Marktstart: April 2023; Preis: ab 72.800 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (328, 23, 37, N'Der neue M2 setzt auf alte Tugenden. Bedeutet: Sechs Zylinder und 460 PS unter der Haube, und auch eine Handschaltung ist im Angebot. Optisch präsentiert er sich kantig und bullig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (329, 23, 38, N'BMW XM; Preis: ab 170.000 Euro; Marktstart: Frühjahr 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (330, 23, 39, N'Das zweite eigenständige M-Modell nach dem M1 wird ein großes SUV mit riesiger Doppel-Niere. Als Antrieb dient ein elektrifizierter V8, der Plug-in-Hybrid bringt es auf eine Systemleistung von 653 PS und bis zu 800 Nm Drehmoment.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (331, 23, 40, N'BMW i7 M70; Preis: ca. 150.000 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (332, 23, 41, N'Die Variante "M70" ist das Topmodell des i7. Verantwortlich für den Vortrieb sind hier ein 258 PS starker E-Motor an der Vorderachse sowie ein 489 PS starker E-Motor hinten. Zusammen kommt der Allradantrieb dann auf 485 kW (660 PS).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (333, 23, 42, N'BMW X5/X6 Facelift; Preis: ab 73.200 Euro (X5) bzw. ab 82.700 Euro (X6); Marktstart: 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (334, 23, 43, N'. Für einen noch präsenteren Auftritt sorgen künftig serienmäßige Designelemente des Modells xLine, neue Nieren und um 35 Millimeter flachere Scheinwerfer zieren die Front. Noch ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (335, 23, 44, N'... dynamischer wird''s mit dem M-Sportpaket, das für den X6 sogar Teil der Serienausstattung wird – beim X5 wird es optional angeboten. Motorenseitig hält BMW an seinen bisherigen Antrieben fest, verpasst einigen aber noch einen Leistungs-Bonus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (336, 23, 45, N'BMW X5 M/X6 M Competition Facelift; Marktstart: 2023; Preis: ab ca. 160.000 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (337, 23, 46, N'Wie auch seine zahmen Geschwister bekommen auch die brutalen M-Brüder des X5 und X6 ein Facelift – erstmals mit 48 Volt-Bordnetz und immer als stärkere Competition-Version mit 625 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (338, 23, 47, N'BMW M3 CS; Preis: ab 146.000 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (339, 23, 48, N'BMW bringt den M3 als limitierten CS. Das Sondermodell hat 550 PS und beschleunigt dank Allrad schneller auf 100 km/h als der M4 CSL.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (340, 23, 49, N'BMW 5er und i5 G60; Preis: ab 57.550 Euro (5er), ab 70.200 Euro (i5); Marktstart: Herbst 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (341, 23, 50, N'Der neue 5er wird kein geschrumpfter 7er, die Nieren bleiben human und auch die Scheinwerfer bleiben einteilig. Bei den Abmessungen legt der neue dafür etwas zu, wird insgesamt ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (342, 23, 51, N'... zehn Zentimeter länger, drei Zentimeter höher und breiter. Motorenseitig setzen die Bayern auch durchgängige Elektrifizierung, erstmals gibt''s den Oberklasse-BMW auch als vollelektrischen i5 – mit bis zu 601 PS und 582 Kilometern Reichweite.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (343, 23, 52, N'BMW X2/iX2; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (344, 23, 53, N'Wie ein möglicher X2-Nachfolger motorisiert sein könnte, ist zurzeit noch reine Spekulation – allerdings wäre ein zweigleisiger Ansatz wie beim aktuellen X3 und iX3 denkbar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (345, 23, 54, N'BMW XM Label Red; Preis: 203.000 Euro Marktstart: Herbst 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (346, 23, 55, N'Satte 748 PS, maximales Drehmoment von 1000 Nm – und das in einem SUV! Mit dem XM Label Red bringt BMW das stärkste Serienmodell der Marke – und die Produktion soll bereits im August 2023 starten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (347, 23, 56, N'BMW M5 Touring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (348, 23, 57, N'; Marktstart: 2024. Nach 17 Jahren soll es einen neuen M5 Touring geben – erst den dritten jemals. Über 700 PS sind auf jeden Fall denkbar und eine elektrische Variante wird es auch geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (349, 23, 58, N'BMW X3; Preis: 60.000 Euro; Marktstart: 2025.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (350, 23, 59, N'Die Münchner setzen auf Antriebsvielfalt, wollen nicht nur Batterieautos produzieren. So nutzt der kommende iX3 die neue E-Technik, mit der sechsten Generation der eDrive-Antriebe und schneller 800-Volt-Technik (erlaubt bis zu 350 kW Ladeleistung), werden Benziner und Diesel der bisherigen CLAR-Plattform treu bleiben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (351, 23, 60, N'BMW 4er Facelift; Marktstart: 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (352, 23, 61, N'Ähnlich wie beim 3er werden die Leuchten leicht modifiziert, die LED-Scheinwerfer erhalten eine neue Leuchtengrafik. Zudem scheint BMWdie Stoßfänger leicht zu überarbeiten, die seitlichen Lufteinlässe dürften neu gestaltet werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (353, 23, 62, N'BMW i3; Marktstart 2025.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (354, 23, 63, N'BMW belebt die "Neue Klasse" wieder – mit einer neuen Plattform, die ausschließlich auf Elektroantriebe setzt. 2025 dürfte die Neue Klasse dann mit dem künftigen i3 an den Start gehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (355, 24, 0, N'Die Mittelklasse-Limousine Renault Talisman wird seit 2022 nicht mehr gebaut. Gute Gebrauchtwagen-Angebote gibt es aber einige. Alle Infos!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (356, 24, 1, N'Die Karriere des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (357, 24, 2, N'Renault Talisman')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (358, 24, 3, N'war vergleichsweise kurz. Gebaut wurde die Mittelklasse-Limousine nämlich nur von 2015 bis 2022. Möchte man also den Franzosen sein Eigen nennen, ist man inzwischen also auf den Gebrauchtwagen-Markt angewiesen. Angebote gibt es einige. Ein Händler aus Bochum hat einen im April 2021 erstmals zugelassenen Talisman im Portfolio.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (359, 24, 4, N'Der Diesel in der Renault-Ausstattung "Intens" ist bislang 22.500 Kilometer gelaufen und ist mit einem Automatik-Getriebe ausgestattet. Einen Vorbesitzer gibt es, das Auto ist ein Nichtraucherfahrzeug und ist scheckheftgepflegt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (360, 24, 5, N'AUTO BILD Gebrauchtwagenmarkt38.980 €Renault Talisman Grandtour Initiale Paris dCi190 EDC9.000 km140 KW (190 PS)12/2022Zum AngebotDiesel, 5,2 l/100km (komb.), CO2 Ausstoß 161 g/km*39.180 €Renault Talisman Grandtour Initiale Paris dCi190 EDC9.000 km140 KW (190 PS)12/2022Zum AngebotDiesel, 5,2 l/100km (komb.), CO2 Ausstoß 161 g/km*44.900 €Renault Talisman Grandtour BLUE dCi 190 EDC INITIALE PARIS3.000 km138 KW (188 PS)12/2022Zum AngebotCO2 Ausstoß 161 g/km*44.990 €Renault Talisman Grandtour Initiale Paris NAVI LED SHZ15.000 km140 KW (190 PS)11/2022Zum AngebotDiesel, 4,9 l/100km (komb.), CO2 Ausstoß 130 g/km*40.880 €Renault Talisman INITIALE PARIS BLUE dCi 190 EDC SHZ ACC HuD13.000 km139 KW (189 PS)11/2022Zum AngebotDiesel, 4,9 l/100km (komb.), CO2 Ausstoß 115 g/km*42.990 €Renault Talisman Grandtour BLUE dCi 190 EDC INTENS8.100 km138 KW (188 PS)10/2022Zum AngebotDiesel, 4,8 l/100km (komb.), CO2 Ausstoß 161 g/km*42.850 €Renault Talisman Grandtour BLUE dCi 190 EDC INITIALE PARIS10.000 km138 KW (188 PS)09/2022Zum AngebotCO2 Ausstoß 161 g/km*39.990 €Renault Talisman Grandtour IntensdCi190 EDC MATRIX 4Controll WINTER11.000 km138 KW (188 PS)08/2022Zum AngebotDiesel, 4,8 l/100km (komb.), CO2 Ausstoß 126 g/km*48.915 €Renault Talisman Grandtour Initiale Paris Blue dCi 19011.500 km139 KW (189 PS)08/2022Zum AngebotDiesel, 5,2 l/100km (komb.), CO2 Ausstoß 157 g/km*39.222 €Renault Talisman Grandtour INITIALE PARIS TCe 160 EDC11.700 km116 KW (158 PS)08/2022Zum AngebotBenzin, 5,7 l/100km (komb.), CO2 Ausstoß 130 g/km*Alle Renault Talisman gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (361, 24, 6, N'Das Diesel-Aggregat hat zwei Liter Hubraum und leistet 118 kW (160 PS), bei einem maximalen Drehmoment von 360 Newtonmetern. Der Verbrauch wird mit rund fünf Litern kombiniert angegeben, innerorts sind es 5,9 Litern, außerorts 4,4 Liter. Der Preis liegt bei 28.300 Euro. Die nächste Hauptuntersuchung ist im April 2024 fällig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (362, 24, 7, N'ZoomDer Diesel in der Renault-Ausstattung "Intens" ist bislang 22.500 Kilometer gelaufen. Bild: Autohandel J.Ackermann')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (363, 24, 8, N'Der Diesel in der Renault-Ausstattung "Intens" ist bislang 22.500 Kilometer gelaufen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (364, 24, 9, N'Die Sonderausstattung bietet ein digitales Cockpit, ein Facelift, Navigation, ein Cruising-Paket, ein Fahrassistenz-System (Spurhalteassistent Aktiv), eine Metallic-Lackierung in "Grau Cassiopee" und ein Safety Plus-Paket. Die Innenausstattung ist in Schwarz gehalten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (365, 24, 10, N'Gebrauchtwagenmarkt
            







                        Aktuelles Angebot: Renault Talisman
                    

                        Renault Talisman im AUTO BILD-Gebrauchtwagenmarkt.
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (366, 24, 11, N'Extras werden auch geboten: Neben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (367, 24, 12, N'Allwetterreifen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (368, 24, 13, N'auch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (369, 24, 14, N'Alufelgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (370, 24, 15, N', Ambientebeleuchtung, eine Scheinwerferreinigung, Sprachsteuerung, Touchscreen und ein Winterpaket.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (371, 24, 16, N'Der Talisman war für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (372, 24, 17, N'Renault')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (373, 24, 18, N'kein wirklicher Glücksbringer, um das sich stark aufdrängende Wortspiel zu bemühen. Denn der Plan der Franzosen, in der gehobenen Mittelklasse ein echter Herausforderer für den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (374, 24, 19, N'VW Passat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (375, 24, 20, N'oder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (376, 24, 21, N'Opel Insignia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (377, 24, 22, N'zu werden, ging nicht ganz auf.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (378, 24, 23, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (379, 24, 24, N'Trotzdem: Der Talisman kann generell mit seinem Platzangebot punkten, dazu auch mit der gemütlichen Einrichtung. Er ist vor allem für Fans eleganter und mitunter komfortabler ausgestatteter Limousinen ein echter Geheimtipp.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (380, 25, 0, N'Die M GmbH ist bei BMW für die richtig schnellen Autos zuständig. AUTO BILD nennt 9 Fakten über die Sportabteilung der Münchner, die nicht jeder kennt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (381, 25, 1, N'Kenner der Sport-Spezialisten wissen, wie viel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (382, 25, 2, N'M')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (383, 25, 3, N'in jedem Sportfahrzeug aus dem Hause')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (384, 25, 4, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (385, 25, 5, N'steckt, die meisten Autos sind bekannt. AUTO BILD nennt hier 9 Fakten über die M GmbH, die nicht jeder kennt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (386, 25, 6, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (387, 25, 7, N'i4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (388, 25, 8, N'M50 war 2022 das meistverkaufte Modell der M GmbH. Gleichzeitig handelt es sich bei der 544 PS starken Limousine um das erste vollelektrische M-Modell überhaupt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (389, 25, 9, N'ZoomBMW i4 M50: Die 544 PS und 795 ermöglichen eine Beschleunigung von 0 auf 100 in 3,9 Sekunden. 225 km/h sind möglich. Bild: Olaf itrich/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (390, 25, 10, N'BMW i4 M50: Die 544 PS und 795 ermöglichen eine Beschleunigung von 0 auf 100 in 3,9 Sekunden. 225 km/h sind möglich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (391, 25, 11, N'Das erste Straßenfahrzeug, für das die M GmbH verantwortlich war, war der ab 1978 gebaute BMW M1. Die Entwicklung fand allerdings maßgeblich bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (392, 25, 12, N'Lamborghini')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (393, 25, 13, N'statt, der Designauftrag ging an Giorgetto Giugiaro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (394, 25, 14, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (395, 25, 15, N'Den 3,5-Liter-Reihensechszylinder-Motor wollte BMW zuliefern. Allerdings geriet Lamborghini Mitte der 70er-Jahre in finanzielle Schwierigkeiten, sodass der M1 schließlich von der Firma Baur, die nahe Stuttgart sitzt, gebaut wurde.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (396, 25, 16, N'ZoomDer BMW M1 wurde maßgeblich in Italien entworfen und designt. Bild: AUTO BILD/Martin Meiners')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (397, 25, 17, N'Der BMW M1 wurde maßgeblich in Italien entworfen und designt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (398, 25, 18, N'Wer einen "echten" M kauft, also kein M Performance-Modell wie den M240i, hat als Fahrzeughersteller nicht BMW, sondern tatsächlich die M GmbH als Hersteller im Fahrzeugschein stehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (399, 25, 19, N'ZoomBMW M ist offizieller Fahrzeughersteller – wenn es sich um einen "echten" M handelt. Bild: Conny Poltersdorf/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (400, 25, 20, N'BMW M ist offizieller Fahrzeughersteller – wenn es sich um einen "echten" M handelt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (401, 25, 21, N'BMW bietet bereits seit einigen Jahren unter dem Namen "Performance Parts" Teile an, mit denen Fahrer sich ihre Fahrzeuge aufrüsten können. Dazu zählen etwa bei BMW M3 und M4 Front- und Seitenschwelleraufsätze, Heckdiffusor und Heckspoiler, Schmiederäder oder auch eine Titan-Abgasanlage.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (402, 25, 22, N'ZoomZU den erhältlichen Performance Parts beim M3 gehören zahlreiche Carbonanbauteile wie Seitenschweller, Heckdiffusor und Heckspoiler. Die Titanabgasanlage spart acht Kilo Gewicht ein. Bild: BMW M GmbH')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (403, 25, 23, N'ZU den erhältlichen Performance Parts beim M3 gehören zahlreiche Carbonanbauteile wie Seitenschweller, Heckdiffusor und Heckspoiler. Die Titanabgasanlage spart acht Kilo Gewicht ein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (404, 25, 24, N'Wer seinen BMW mit Individuallack ausstatten möchte, gerät ebenfalls in den Zuständigkeitsbereich der M GmbH. Auch innen kann veredelt werden, etwa mit Gravuren oder Stickereien. Dazu beschäftigt die BMW M GmbH extra Kundenberater.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (405, 25, 25, N'Im Jahr des 50. Geburtstags der M GmbH führte BMW für alle Modelle mit M im Namen – also auch für Modelle mit M-Sport-Paket – ein besonderes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (406, 25, 26, N'Logo')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (407, 25, 27, N'(kam 1972 im Gründungsjahr bereits für Rennfahrzeuge zum Einsatz) für vorne, hinten und die Felgenkappen ein. Allerdings blieb es optional – daran lassen sich also nicht Zwangsläufe in 2022 gebaute Modelle erkennen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (408, 25, 28, N'Was banal klingt, ist durchaus bemerkenswert: Während rund ein Drittel aller BMW-Modelle in China neu ausgeliefert werden, zählte das Land 2022 für die BMW M GmbH nicht einmal zu den Top-3-Absatzländern. Dort stehen als Erstes die USA, dann Deutschland und auf Platz 3 Großbritannien hoch im Kurs.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (409, 25, 29, N'BMW M2, M3 und M4 sind noch mit 6-Gang-Handschaltung zu haben – bei allen anderen M-Modellen werden selbstständig die Gänge gewechselt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (410, 25, 30, N'Gebrauchtwagensuche: BMW M3100.490 €BMW M3 Competition M Drivers P. HK HiFi DAB Shz PDC18.000 km375 KW (510 PS)06/2023Zum AngebotBenzin, 10,4 l/100km (komb.), CO2 Ausstoß 234 g/km*121.999 €BMW M3 Competition Touring M xDrive Laser ACC4.100 km375 KW (510 PS)05/2023Zum Angebot109.950 €BMW M3 Competition Touring M xDrive Laserl, M-Drivers P.8.000 km375 KW (510 PS)05/2023Zum AngebotCO2 Ausstoß 232 g/km*169.000 €BMW M3 MANHART MH3 650 xdrive3.981 km375 KW (510 PS)04/2023Zum Angebot133.950 €BMW M3 Touring xDrive Competition - VOLLAUSSTATTUNG-3.997 km375 KW (510 PS)04/2023Zum Angebot89.495 €BMW M3 Competition 360° Kamera Alarmanlage 19"/20"6.289 km375 KW (510 PS)04/2023Zum AngebotBenzin, 9,8 l/100km (komb.), CO2 Ausstoß 223 g/km*96.789 €BMW M3 xDrive Comp. Schiebedach H&K Curved Kamera6.300 km375 KW (510 PS)04/2023Zum AngebotBenzin, 9,8 l/100km (komb.), CO2 Ausstoß 229 g/km*136.500 €BMW M3 Competion  xDrive Touring *M Race Track Pack*4.083 km375 KW (510 PS)04/2023Zum AngebotBenzin, 10,3 l/100km (komb.)*113.050 €BMW M3 Competion xDrive Facelift5.000 km375 KW (510 PS)04/2023Zum Angebot108.800 €BMW M3 Lim. xDrive Competition *FACE*CARBON*DRIVERSP7.500 km375 KW (510 PS)03/2023Zum AngebotAlle BMW M3 gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (411, 25, 31, N'Ungewöhnlich: Beim Motorstart ist natürlich erst einmal Fahrstufe P eingelegt. Wer in "Drive" schalten möchte, muss den Hebel nach rechts drücken. Wer den Rückwärtsgang benötigt, muss den Hebel zunächst nach links, dann nach oben führen, was wiederum ein wenig an alte, manuelle Schaltungen erinnert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (412, 25, 32, N'Ebenfalls anlässlich des 50. Geburtstages der M GmbH wurde 2022 der BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (413, 25, 33, N'XM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (414, 25, 34, N'vorgestellt – ein elektrisches Performance-SUV, das mit 5,11 Meter eigentlich die Standard-Maße für europäische Straßen sprengt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (415, 25, 35, N'ZoomDer BMW XM kostet mindestens 178.000 Euro. Bild: BMW AG/Enes Kucevic Photography')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (416, 25, 36, N'Der BMW XM kostet mindestens 178.000 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (417, 25, 37, N'Den Radstand von 3,1 Metern teilt er sich mit dem BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (418, 25, 38, N'X7')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (419, 25, 39, N'. Der Standard-XM verfügt mit einen Plug-in-Hybridantrieb und über eine Systemleistung von 653 PS, die im Frühjahr vorgestellte "Label Red"-Edition leistet bis zu 748 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (420, 26, 0, N'Was nach Daniel Düsentrieb klingt, ist tatsächlich real: Besitzer und Fahrer Sammy Tosuner hat einen Lkw mit Jet-Triebwerk ausgerüstet. Das sagt er zu seinem Umbau.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (421, 26, 1, N'Es gibt ungewöhnliche Ideen – und dann gibt es Sammy Tosuner. Was der fast 70-Jährige mit einem ehemaligen Renntruck angestellt hat, gibt es wohl nur ganz selten auf der Welt. Und das aus gutem Grund.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (422, 26, 2, N'Zoom64.000 PS wären mit drei Nachbrennern und Strahlverdichter möglich – aktuell beträgt die Leistung "nur" ungefähr 45.000 PS. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (423, 26, 3, N'64.000 PS wären mit drei Nachbrennern und Strahlverdichter möglich – aktuell beträgt die Leistung "nur" ungefähr 45.000 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (424, 26, 4, N'Der Aufwand, der in den Umbau des NOSTROMO Jet-Trucks einfloss, ist enorm. Das Rolls-Royce-Avon-Triebwerk griffen Tosuner und sein Team von der Royal Airforce ab, bezahlten dafür rund 300.000 Euro. Die BAC-Lightning Kampfjets, aus deren Antrieb das Triebwerk stammt, verfügten gleich über zwei davon mit jeweils drei Nachbrennern, konnten so mit mehr als Mach 2,3 (über 2600 km/h) fliegen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (425, 26, 5, N'ZoomDie Fahrgastzelle besteht aus Aluminium und Kohlefaser, bietet eine Sicherheitsfahrgastzelle und ein fest installiertes Feuerlöschsystem. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (426, 26, 6, N'Die Fahrgastzelle besteht aus Aluminium und Kohlefaser, bietet eine Sicherheitsfahrgastzelle und ein fest installiertes Feuerlöschsystem.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (427, 26, 7, N'Im Jet-Truck arbeitet ein einzelner Nachbrenner, der bis zu 64.000 PS leisten soll. Die Höchstgeschwindigkeit beträgt ungefähr 500 km/h. Auf der Viertelmeile stehen beim Zieleinlauf ca. 450 km/h an. Das Fahrwerk ist ungefedert, wodurch der Truck bei der kleinsten Unebenheit sofort kurz abhebt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (428, 26, 8, N'ZoomDas Gewicht des Jet-Trucks mit vollem Truck beträgt ca. 3750 Kilogramm. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (429, 26, 9, N'Das Gewicht des Jet-Trucks mit vollem Truck beträgt ca. 3750 Kilogramm.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (430, 26, 10, N'Der 600-Liter-Tank Jet A1-Benzin, kann auch mit Diesel befüllt werden. Dieser Vorrat reicht allerdings lediglich für drei Minuten Einsatzzeit. Problematisch: Erreicht das Jet-Triebwerk 80 Prozent seiner Maximalleistung, nützt auch die Bremse nichts mehr, die im Nostromo-Truck per Fußpedal bedient wird. Daher denkt Sammy sofort nach dem Start ans Bremsen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (431, 26, 11, N'ZoomIn Röhren dieser Art finden die Bremsfallschirme Platz. Weil der Stoff schnell feucht wird, sind sie auf den PS Days nicht verbaut. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (432, 26, 12, N'In Röhren dieser Art finden die Bremsfallschirme Platz. Weil der Stoff schnell feucht wird, sind sie auf den PS Days nicht verbaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (433, 26, 13, N'Eine derartiger Beschleunigung macht eine leistungsfähige Bremsanlage unverzichtbar. Dafür sorgt zum einen eine Vier-Scheiben-Druckluft-Rennbremsanlage. Für das Abbremsen aus hohen Geschwindigkeiten kommen Bremsfallschirme zum Einsatz.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (434, 26, 14, N'ZoomDer Tank fasst bis zu 600 Liter Jet-Benzin oder Diesel. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (435, 26, 15, N'Der Tank fasst bis zu 600 Liter Jet-Benzin oder Diesel.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (436, 26, 16, N'Sollte Tosuner eines Tages seiner Leidenschaft nicht mehr nachkommen können, hat er bereits für eine Nachfolgerin gesorgt: Seine 10-jährige Tochter fährt bereits Junior-Dragster auf der Achtel-Meile. Ihr Gefährt leistet ungefähr 90 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (437, 26, 17, N'Lust auf noch mehr Tuning bekommen? Dann schaut doch mal')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (438, 26, 18, N'bei den Finalisten der HotWheels Legend Tour Germany')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (439, 26, 19, N'vorbei!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (440, 27, 0, N'Hier ist nicht mehr viel original! Nur der Charme des kantigen Opel Vectras ist geblieben und viel Arbeit, Leidenschaft und Leistung kamen dazu.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (441, 27, 1, N'Böse Zungen würden behaupten, dass der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (442, 27, 2, N'Opel Vectra')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (443, 27, 3, N'A ein typisches Opa-Mobil sei, andere sehen in dem Blitz viel Potenzial – zum Glück. Denn ansonsten wäre einem dieser saubere Vectra auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (444, 27, 4, N'PS Days 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (445, 27, 5, N'nicht unter die Augen gekommen. Und vom Rentnerfahrzeug ist der graue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (446, 27, 6, N'Opel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (447, 27, 7, N'sehr weit entfernt! AUTO BILD hat sich den Viertelmeile-Vectra mal genauer angesehen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (448, 27, 8, N'ZoomDer Vectra ist komplett lackiert: Unterboden, Innenraum. Kein Fleck wurde unberührt gelassen. Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (449, 27, 9, N'Der Vectra ist komplett lackiert: Unterboden, Innenraum. Kein Fleck wurde unberührt gelassen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (450, 27, 10, N'Wirft man dem Opel Vectra A im Vorbeigehen nur einen kurzen Blick zu, dann fallen einem die glänzenden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (451, 27, 11, N'Felgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (452, 27, 12, N'und die böse Frontschürze auf, aber man ahnt noch lange nicht, was im Innenraum auf einen wartet. Oder besser gesagt: Was nicht mehr auf einen wartet. Denn bis auf das Wichtigste (Schalensitze, Lenkrad, Armatur und Schaltknauf), ist nichts übrig geblieben. Der Vectra wurde vom Besitzer, der den Opel im Jahr 2000 als ersten Erwerb mit Euro gekauft hat, bis auf die Rohkarosse auseinandergebaut – und Vieles wurde schließlich einfach weggelassen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (453, 27, 13, N'ZoomNur noch das Wichtigste vorhanden: Was nicht wirklich zum Fahren gebraucht wird, ist rausgeflogen. Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (454, 27, 14, N'Nur noch das Wichtigste vorhanden: Was nicht wirklich zum Fahren gebraucht wird, ist rausgeflogen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (455, 27, 15, N'Das stimmt natürlich nur so halb. Doch das Ziel war die Gewichtsreduktion und das hat offenbar geklappt. So, wie der Vectra auf der Messe steht, wiegt er noch knapp 1000 kg. Und das hatte auch einen triftigen Grund. Denn eigentlich war der Opel als Viertelmeileauto gedacht, leider kam es nur zu wenigen Fahrten in Brilon, denn das F28-Getriebe hat dem Vorhaben nicht standgehalten. Doch die Optik durfte bleiben und so führt der Opel ein entspanntes Leben auf Messen, Treffen und kleinen Ausfahrten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (456, 27, 16, N'ZoomSatt steht er da! Und für den Besitzer ist klar, dass so ein Wagen nicht auf Luft gehört. Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (457, 27, 17, N'Satt steht er da! Und für den Besitzer ist klar, dass so ein Wagen nicht auf Luft gehört.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (458, 27, 18, N'In seinem "früheren Leben" war der Turbo-Vectra mal ein bordeauxroter Zwei-Liter-16V-Opel – bis ihm sein jetziger Besitzer nicht nur eine neue Lackierung, sondern auch einen Turbo-Umbau gegönnt hat. Das heißt: Der Lightweight-Opel fährt heute mit 204 PS. Schön zu sehen, dass auch solche "Underdogs" immer mehr Anklang in der Tuning-Szene finden und der Vectra konnte auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (459, 27, 19, N'PS Days 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (460, 27, 20, N'sicher vielen Besuchern ein Lächeln auf die Lippen zaubern – mir auf jeden Fall.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (461, 27, 21, N'ZoomDank des Turboumbaus fährt der Viertelmeilen-Vectra heute mit 204 PS. Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (462, 27, 22, N'Dank des Turboumbaus fährt der Viertelmeilen-Vectra heute mit 204 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (463, 27, 23, N'Lust auf noch mehr Tuning bekommen? Dann schaut doch mal bei den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (464, 27, 24, N'Finalisten der HotWheels Legend Tour Germany')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (465, 27, 25, N'vorbei!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (466, 28, 0, N'Der VW Typ 181 ist ein echter Klassiker. Auf den PS Days in Hannover steht ein besonders sommerliches Exemplar. Der "California Dream" ist in Weiß und Türkis gehalten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (467, 28, 1, N'Bei Tuning denken man wahrscheinlich eher nicht an Militärfahrzeuge, aber hier auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (468, 28, 2, N'PS Days in Hannover')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (469, 28, 3, N'steht er, der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (470, 28, 4, N'VW Typ 181')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (471, 28, 5, N'. 1968 zunächst für die Bundeswehr entwickelt, erfreut er sich auch bei Privatleuten großer Beliebtheit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (472, 28, 6, N'ZoomDie Auspuffanlage wurde nachgerüstet und passt sich an den Look des "California Dreams" ein.  Bild: J. Bitter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (473, 28, 7, N'Die Auspuffanlage wurde nachgerüstet und passt sich an den Look des "California Dreams" ein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (474, 28, 8, N'Bis 1983 wurden 90.000 Exemplare produziert. Ein ganz besonders Exemplar steht in Halle 26 auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (475, 28, 9, N'PS Days')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (476, 28, 10, N'. Es hört auf den Namen "California Dream".')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (477, 28, 11, N'ZoomDer Innenraum ist auch in Türkis und Weiß gehalten – mit passenden grauen Sitzen. Bild: J. Bitter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (478, 28, 12, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (479, 28, 13, N'Der Innenraum ist auch in Türkis und Weiß gehalten – mit passenden grauen Sitzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (480, 28, 14, N'Im sommerlichen Türkis ist der VW Typ 181 ein echter Hingucker im Elite Circle. Der ganze Wagen versprüht paradiesische Vibes. Außen in Weiß und Türkis gehalten, runden die grauen Sitze das Bild geschmackvoll ab. Man fühlt sich direkt ins namensgebende Kalifornien versetzt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (481, 29, 0, N'Eigentlich ist der kleine Suzuki ein typischer Zweitwagen – davon kann hier aber kaum die Rede sein. Besitzer Kolja stellt auf den PS Days seinen getunten Swift Sport mit fast 200.000 Kilometern aus!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (482, 29, 1, N'Der aktuelle')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (483, 29, 2, N'Suzuki Swift')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (484, 29, 3, N'ist ohnehin ein Auto mit Klassiker-Potenzial: Mit einer Länge von 3,89 Metern irgendwo zwischen Kleinst- und Kleinwagen angesiedelt, setzt der Japaner auf bunte, auffällige Farben und nicht mehr Gewicht als nötig. Auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (485, 29, 4, N'PS Days')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (486, 29, 5, N'hat Besitzer Kolja seinen blauen Swift Sport ausgestellt. Das Besondere: die Laufleistung von heute 197.000 Kilometern bei einem Fahrzeugalter von gerade einmal fünf Jahren!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (487, 29, 6, N'ZoomDer Swift steht auf 18-Zoll-Felgen der Marke Tec mit 215er-Toyo-Bereifung. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (488, 29, 7, N'Der Swift steht auf 18-Zoll-Felgen der Marke Tec mit 215er-Toyo-Bereifung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (489, 29, 8, N'Kolja erzählt, bei  ungefähr 176.000 Kilometern habe ihn ein Riss im Motorblock zum Austausch desselben gezwungen. Das Auto werde von ihm aber auch überall genutzt – auf der Autobahn mit reichlich Vollgasanteil und auf der Rennstrecke. Zylinderkopf und Turbolader wurde im gleichen Zuge erneuert. Bis auf eine feste Bremse vorn rechts habe er ansonsten nichts zu beklagen gehabt. Seit Dezember 2019, als er den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (490, 29, 9, N'Suzuki')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (491, 29, 10, N'mit 8000 Kilometern kaufte, hat er über 180.000 Kilometer abgespult!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (492, 29, 11, N'ZoomDer zweite Motor tut nun seit gut 20.000 Kilometern seinen Dienst. Kolja fordert seinen Kleinen ordentlich, auch auf der Rennstrecke. Bild: Jonas Uhlig')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (493, 29, 12, N'Der zweite Motor tut nun seit gut 20.000 Kilometern seinen Dienst. Kolja fordert seinen Kleinen ordentlich, auch auf der Rennstrecke.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (494, 29, 13, N'Anbauteile von Maxton Design lassen den Kleinen stämmiger wirken, auch die H&R-Federn helfen dabei. Die Front zeigt sich für die hohe Laufleistung in gutem Zustand. Im Innenraum gab es ebenfalls einige Modifikationen: Der Dachhimmel wurde geschwärzt, dazu gesellen sich Verkleidungen von Türtafel und Armaturenbrett in Alcantara-Optik. Einzigartig auch der Schaltknauf, der mit dem Kopf einer alten Flasche für Handseife verschönert wurde.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (495, 29, 14, N'ZoomVon innen präsentiert sich der Suzuki noch frisch, mit gefärbtem Dachhimmel und einzigartigem Schaltknauf. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (496, 29, 15, N'Von innen präsentiert sich der Suzuki noch frisch, mit gefärbtem Dachhimmel und einzigartigem Schaltknauf.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (497, 29, 16, N'Die 18-Zoll-Felgen stammen von Hersteller Tec ("Speedwheel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (498, 29, 17, N'GT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (499, 29, 18, N'"), darauf sitzt eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (500, 29, 19, N'Bereifung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (501, 29, 20, N'im Format 215/35 R18. Der Nordschleifen-Sticker weist darauf hin: Kolja fährt den Swift Sport auch auf dem Ring. Die serienmäßigen 140 PS aus dem 1,4.Liter-Boosterjet-Motor mehren sich durch eine offene Ansaugung und eine Abgasanlage von Hersteller Inoxcar zu ungefähr 150 bis 160 PS, ein Forged-Ladeluftkühler hält die Temperaturen auf erträglichem Niveau. Genug Leistung also, um mit 950 Kilo Leergewicht auch mit größeren und stärkeren Autos mitzuhalten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (502, 29, 21, N'ZoomDie Schnecke Gary kennt man aus der Zeichentrickserie "Spongebob" – sie soll auf den Garrett-Turbolader anspielen. Bild: Christian Goes/AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (503, 29, 22, N'Die Schnecke Gary kennt man aus der Zeichentrickserie "Spongebob" – sie soll auf den Garrett-Turbolader anspielen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (504, 29, 23, N'Lust auf noch mehr Tuning bekommen? Dann schaut doch mal bei den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (505, 29, 24, N'Finalisten der HotWheels Legend Tour Germany')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (506, 29, 25, N'vorbei!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (507, 30, 0, N'Wem ein normaler BMW Z4 zu wenig ist, für den bietet AC Schnitzer eine Lösung mit mehr Optik, mehr Leistung und mehr Fahrspaß. Erste Fahrt!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (508, 30, 1, N'Tuning muss nicht immer ins Extreme gehen, manchmal sind es die dezenteren Autos, die den größeren Spaß machen. Das hat sich sicherlich auch AC Schnitzer gedacht, als sie sich dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (509, 30, 2, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (510, 30, 3, N'Z4 M40i Roadster angenommen haben, um dem Gefühl der Freiheit noch etwas mehr Optik und Leistung zu verpassen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (511, 30, 4, N'Doch bevor es losgeht, müssen wir uns einmal den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (512, 30, 5, N'BMW Z4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (513, 30, 6, N'genauer anschauen und über die Modifikationen sprechen. Wie es bereits das Blechkleid verrät, war AC Schnitzer bei der optischen Verfeinerung eher zurückhaltend.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (514, 30, 7, N'So hat der bayerische Sportler vorne eine neue Spoilerlippe bekommen, passend dazu gibt''s Seitenschweller – hier optional in Schwarz lackiert. Auch die vierflutige Abgasanlage ist hinzugekommen: ein neuer Endschalldämpfer mit einer Vierrohr-Optik, umrandet sind die Endrohre in Carbon. Sieht nicht nur schick aus, klingt auch schön, soweit es Kat und OPF zulassen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (515, 30, 8, N'Der Sportler steht auf stattlichen 21-Zoll-Felgen. Eine Tieferlegung wird ermöglicht dank eines Sport-Gewindefahrwerkes, damit kommt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (516, 30, 9, N'Z4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (517, 30, 10, N'dem Boden bis zu 25 Millimeter näher. Zusammen mit den AC Schnitzer-Schriftzügen und schwarzen Heckspoiler-Aufsätzen wirkt der Z4 noch ein bisschen sportlicher.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (518, 30, 11, N'ZoomDie Vierrohr-Abgasanlage macht einen kernigen Sound, die Spoiler-Lippen oben sorgen für mehr Aerodynamik. Bild: AUTO BILD / Christian Goes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (519, 30, 12, N'Die Vierrohr-Abgasanlage macht einen kernigen Sound, die Spoiler-Lippen oben sorgen für mehr Aerodynamik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (520, 30, 13, N'Aber nicht nur außen wurde Hand angelegt, auch im Innenraum lassen kleinere, dezente Details erahnen, dass man es nicht einfach mit irgendeinem "Standard"-Z4 zu tun hat. Das für den Fahrer wohl wichtigste Detail ist das neue Lenkrad, bezogen mit einer Mischung aus Leder und Alcantara und 12-Uhr-Markierung mit AC Schnitzer-Schriftzug. Dahinter befinden sich – wie es sich für einen Sportwagen gehört – die Schaltwippen, gefertigt aus Metall und nicht aus Plastik. Weitere Modifikationen umfassen einen neuen iDrive-Controller und eine neue Pedalerie.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (521, 30, 14, N'Bereits in der Basis ist der Z4 M40i mit seinen 340 PS ja nicht gerade untermotorisiert, doch dank einer Software-Optimierung leistet der Bayer jetzt 400 PS, maximal 600 Nm Drehmoment werden an die Räder weitergegeben. Also Faltdach auf, Motor starten und erst mal reinhören. Durch den Drehzahlbegrenzer im Leerlauf kommt zunächst nicht viel Sound an den Ohren an, erst in Fahrt steigt die Lautstärke beim Z4.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (522, 30, 15, N'ZoomDas Fahrwerk ist sehr straff, die Lenkung überzeugt mit sehr direktem Feedback. Bild: AUTO BILD / Christian Goes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (523, 30, 16, N'Das Fahrwerk ist sehr straff, die Lenkung überzeugt mit sehr direktem Feedback.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (524, 30, 17, N'Die 400 PS sorgen für schnellen Vortrieb. Serie sind 4,5 Sekunden auf Tempo 100, eine genaue Zahl nennen die Aachener nicht, nach rund vier Sekunden dürfte der Standard-Sprint aber absolviert sein. Der Roadster zieht mächtig an, könnte subjektiv locker 270 km/h rennen, leider ist das Pressefahrzeug bei 250 Sachen abgeregelt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (525, 30, 18, N'Aber es geht ja nicht nur um Geschwindigkeit, mindestens genauso wichtig ist das Handling. Und da kann der Z4 durchaus punkten. Ja, um die Mittellage herum merkt man, dass man gewaltige 21 Zöller bewegt, die im ersten Moment zum Einlenken gezwungen werden müssen, dann aber geht der Sportler straff und direkt um die Ecke.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (526, 30, 19, N'Dem Hinterradantrieb sei Dank gibt''s auch keine störenden Antriebseinflüsse in der Lenkung. Auch die Bremsen packen ordentlich zu, und in Kombination mit dem Gewindefahrwerk wirkt er richtig quirlig, lässt sich schön in die Kurven schmeißen, beschleunigt dann wieder sauber und kraftvoll raus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (527, 30, 20, N'ZoomDie 400 PS sorgen für einen amtlichen Antritt, Schluss ist leider schon bei abgeregelten 250 km/h. Bild: AUTO BILD / Christian Goes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (528, 30, 21, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (529, 30, 22, N'Die 400 PS sorgen für einen amtlichen Antritt, Schluss ist leider schon bei abgeregelten 250 km/h.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (530, 30, 23, N'Etwas Nachsehen hat bei dem Set-up aber leider der Komfort, die bequemen Sitze bieten zwar ordentlichen Seitenhalt, die straffe Fahrwerksabstimmung in Kombination mit den großen Rädern sorgen aber dafür, dass auch kleinere Unebenheiten recht direkt an die Insassen weitergegeben werden. Wirklich unbequem wird''s aber erst auf wirklich maroden Straßen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (531, 30, 24, N'Wenn man den Wagen zum entspannten Cruisen einlädt, dann liefert er Komfort. Obwohl sich das Fahrwerk nicht mehr aktiv einstellen lässt, wie beim Basis-Fahrzeug.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (532, 30, 25, N'Nun zum Preis. Laut AC Schnitzer lag das Basisfahrzeug bei 66.900 Euro (der aktuelle Startpreis liegt bei 69.300 Euro), dazu kommen 9970 Euro an Sonderausstattung, die ab Werk verbaut sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (533, 30, 26, N'Nun zu den Tuning-Kosten: Für die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (534, 30, 27, N'Felgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (535, 30, 28, N'werden 5735 Euro fällig, die Leistungssteigerung schlägt mit 4572 Euro zu Buche. Wer sich für das Sport-Lenkrad entscheidet, zahlt noch mal 1083 Euro. In Summe beläuft sich das Tuning auf 24.750 Euro, der Gesamtpreis liegt somit bei mehr als 100.00 Euro. Viel Geld, aber auch viel Fahrspaß!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (536, 31, 0, N'Hier ist auf den ersten Blick alles original, aber auch wirklich nur auf den ersten Blick. Geschadet hat das unauffällige Tuning dem NSX definitiv nicht!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (537, 31, 1, N'Am ersten Tag der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (538, 31, 2, N'PS-Days 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (539, 31, 3, N'sagte der Moderator auf der L8-Night-Showstrecke: "Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (540, 31, 4, N'NSX')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (541, 31, 5, N'ist sicher eines der schönsten Autos überhaupt". Und damit ist quasi alles gesagt. Denn wo man auch hinsah, alle blickten gebannt und fasziniert auf die japanische Schönheit. 31 Jahre alt und kein bisschen an Sportlichkeit und Begeisterung verloren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (542, 31, 6, N'Zoom280 PS starker Mittelmotor und Heckantrieb: Der NSX schiebt ordentlich nach vorne. Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (543, 31, 7, N'280 PS starker Mittelmotor und Heckantrieb: Der NSX schiebt ordentlich nach vorne.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (544, 31, 8, N'Technisch ist dieser NSX NA1 unverbastelt und das bedeutet: 3,2-Liter-V6-Mittelmotor mit 280 PS und 284 Nm maximalem Drehmoment. Was nicht mehr so original ist, ist die Karosserie. Denn – auch wenn man es nicht sofort sieht – besteht ein Großteil der Karosserie aus Carbon. Die Leistung des Japaners wirkt also nochmal ganz anders, was auf der Showstrecke auch jeder bestaunen konnte.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (545, 31, 9, N'ZoomGibt es ein schöneres Heck? Viele JDM-Fans würden behaupten: nein! Bild: K. Biehl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (546, 31, 10, N'Gibt es ein schöneres Heck? Viele JDM-Fans würden behaupten: nein!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (547, 31, 11, N'Lust auf noch mehr Tuning bekommen? Dann schaut doch mal bei den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (548, 31, 12, N'Finalisten der HotWheels Legend Tour Germany')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (549, 31, 13, N'vorbei!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (550, 32, 0, N'Auf der Tuningmesse PS Days gibt es einen Extrabereich für Tunerinnen. Das hat leider einen traurigen Hintergrund.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (551, 32, 1, N'Es müsste selbstverständlich sein. Ist es aber nicht! Frauen werden in der Tuningszene noch immer von vielen belächelt. Dabei wächst die Anzahl von Tunerinnen, die ihr Fahrzeug in mühevoller und kostspieliger Arbeit selbst veredeln. Vorbei die Zeiten, wo Frauen nur als Beiwerk in knappen Outfits an den getunten Autos posten. Frauen als Hostessen auf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (552, 32, 2, N'Automessen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (553, 32, 3, N', ich habe das viele Jahre als Autojournalist erlebt. Zum Glück ist das vorbei.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (554, 32, 4, N'ZoomDer EVO II-Umbau von Lisa Yasmin wird auf Youtube dokumentiert.  Bild: AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (555, 32, 5, N'Mit 30 Fahrzeugen von Tunerinnen in der "Ladies Lounge" der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (556, 32, 6, N'PS Days')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (557, 32, 7, N'demonstriert die Messe Hannover eindrucksvoll, was Frauen in der Community drauf haben. Mit dabei sind unter anderem Content Creator Lisa Yasmin und Unternehmerin Mareike')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (558, 32, 8, N'Fox')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (559, 32, 9, N'. Alle Frauen zeigen ihre eigenen Projekte. Und die kommen richtig gut an! Am ersten Messetag war der Pavillon 33 mit den Ladies der mit am stärksten besuchte Bereich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (560, 32, 10, N'Der EVO II-Umbau von Lisa Yasmin wird auf Youtube dokumentiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (561, 32, 11, N'Im Grunde ist so ein Extrabereich für Frauen überflüssig. Gleichberechtigt könnten die Projekte der Frauen gemeinsam mit allen anderen Fahrzeugen ausgestellt werden. Wie aber einige abwertende Kommentare auf der Messe und auf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (562, 32, 12, N'Social Media')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (563, 32, 13, N'zeigen, ist so ein Ausrufezeichen in Form einer "Ladies Lounge" offenbar immer noch notwendig, um ein klares Zeichen zu setzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (564, 33, 0, N'Es muss nicht immer tief, laut und schnell sein. Dieses komplett restauriete Exemplar des 1994er Mini Cooper zeigt sich im Top-Zustand!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (565, 33, 1, N'Klein aber fein: Das trifft ist den klassischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (566, 33, 2, N'Mini')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (567, 33, 3, N'mehr als zutreffend. Und auch wenn die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (568, 33, 4, N'PS Days in Hannover')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (569, 33, 5, N'eine Tuning-Messe sind, muss das nicht bedeuten, dass die ausgestellten Modelle allesamt Maximalumbauten sind. Dieser 1994er-Mini Cooper gehört zu den eher dezenten Umbauten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (570, 33, 6, N'Mit den Kotflügelverbreiterungen hat der Mini bereits ab Werk einen echt stämmigen Auftritt. Schließlich reden wir von einem knapp 3,4 Meter langen Kleinwagen. Gefüllt werden die Radhäuser von fast schon süßen 13 Zoll-Felgen mit einer Felgenbreite, Serie sind sechs Zoll. Etwas tiefer kommt der Mini dank eines höhenverstellbaren Fahrwerks.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (571, 33, 7, N'ZoomStämmiger Auftritt trotz kleiner Abmessugen, unter der Verbreiterung sind 7 x 13 Zoll-Felgen verbaut. Bild: AUTO BILD / Sebastian Friemel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (572, 33, 8, N'Stämmiger Auftritt trotz kleiner Abmessugen, unter der Verbreiterung sind 7 x 13 Zoll-Felgen verbaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (573, 33, 9, N'Weiter geht''s im Innenraum des Mini. Für einen Klassiker gewohnt minimalistisch: die Kombination aus der schwarzen Lackierung und dem roten Teppich innen steht dem kleinen Briten richtig gut. Platz genommen wird auf Sparco-Sportsitzen mit Porsche-Sitzmuster. Einzig das recht moderne Radio scheint etwas aus der Zeit gefallen zu sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (574, 33, 10, N'ZoomRoter Teppich im Innenraum, einzig das recht moderne Radio wirkt etwas deplaziert. Bild: AUTO BILD / Sebastian Friemel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (575, 33, 11, N'Roter Teppich im Innenraum, einzig das recht moderne Radio wirkt etwas deplaziert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (576, 33, 12, N'Apropos Radio, denn für ordentlichen Sound ist bei dem Kleinwagen gesorgt. Jeweils ein Lautsprecher pro Seite wanderte in die Türtafeln, genauso gut sichtbar sind die Hochtöner, die im Aramturenbrett anstelle der Lüftungsdüsen verbaut sind. An ausreichend Belüftung mangelt''s aber nicht, schließlich lassen sich die Scheiben öffnen, und wenn''s nicht reicht, dann gibt''s ein zusätzliches Schiebedach.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (577, 33, 13, N'ZoomMotorenseitig ist er noch Serie: Vier Zylinder mit rund 60 PS verrichten im Mini ihre Arbeit. Bild: AUTO BILD / Sebastian Friemel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (578, 33, 14, N'Motorenseitig ist er noch Serie: Vier Zylinder mit rund 60 PS verrichten im Mini ihre Arbeit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (579, 33, 15, N'Viel Leistung braucht man bei dem kleinen Briten aber nicht zu erwarten, der Vierzylinder mit seinen rund 60 PS reicht für ein so kleines Fahrzeug zwar locker aus, auf der Showstrecke wird der aber kein Rennen für sich entscheiden. Doch darum geht''s auch gar nicht, schließlich wurde der Mini ursprünglich als Daily, und mittlerweile als Sommerauto genutzt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (580, 33, 16, N'Und wenn ihr jetzt noch mehr Lust auf Tuning bekommen habt, dann schaut doch mal')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (581, 33, 17, N'bei den Finalisten der HotWheels Legend Tour Germany')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (582, 33, 18, N'vorbei!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (583, 34, 0, N'Regenrennen auf dem Nürburgring und eine faustdicke Überraschung mit zwei Youngstern an der Spitze. Thomas Preining baut Gesamtführung weiter aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (584, 34, 1, N'Sensationsergebnis beim Sonntagsrennen der DTM auf dem Nürburgring: Maximilian Paul (23) gewinnt als Ersatzmann im Grasser-Lamborghini an seinem erst zweiten DTM-Wochenende vor Laurin Heinrich (22) im Team75-Porsche. Zwei Youngster mischen die DTM auf!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (585, 34, 2, N'"Wir bauchen junge Leute und starken Nachwuchs in der DTM, von daher ist das ''ne richtig gute Nummer", kommentiert Ex-Champion und TV-Experte Timo Scheider bei ProSieben und prognostiziert Überraschungssieger Paul eine große Zukunft: "Wenn du hier ankommst und einspringst (für Mick Wisshofer; d. Red.), an deinem erst zweiten DTM-Wochenende, und bei diesen Bedingungen dann so eine Leistung zeigst, muss man sich den Namen auf jeden Fall merken."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (586, 34, 3, N'ZoomUngläubige Blicke auf dem Podest: Paul siegt vor Heinrich. Bild: DTM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (587, 34, 4, N'Ungläubige Blicke auf dem Podest: Paul siegt vor Heinrich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (588, 34, 5, N'Paul selbst kann seinen Sensationstriumph kaum glauben: "Einfach nur krass, einfach nur geil! Natürlich ist der Sieg immer das Ziel, aber das hätte ich davor tatsächlich nicht geglaubt", strahlt der Dresdener. "Ich bin dankbar für die Chance und so happy für das Team. Unser')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (589, 34, 6, N'Lamborghini')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (590, 34, 7, N'ist so ein großartiges Auto: Ich hatte einen echt super Start, war in einer guten Position und danach einfach in meiner Zone", sagt Paul, der lediglich vom 13. Startplatz aus losgefahren war.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (591, 34, 8, N'Bereits der Start am Nürburgring hat es am Sonntag jedoch in sich, denn pünktlich zur Rennfreigabe bringt das unvorhersehbare Eifelwetter Regen. Einige Top-Piloten, wie Titelverteidiger Sheldon van der Linde und Mehrfachmeister René Rast (beide')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (592, 34, 9, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (593, 34, 10, N'), gehen trotzdem volles Risiko, starten auf Slicks und verzocken sich damit böse. Pole-Mann Ricardo Feller (Abt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (594, 34, 11, N'Audi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (595, 34, 12, N') behält zwar nach dem Start zunächst die Nase vorne, bei zunehmendem Regen muss er sich aber bald der zu diesem Zeitpunkt überlegenen Pace von Winward-Mercedes-Pilot Lucas Auer beugen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (596, 34, 13, N'Später im Rennen geht es dem Österreicher jedoch selbst genauso: Nach den Pflichtboxenstopps ist Auer im Schlussstint chancenlos gegen den Speed und vor allem die Traktion von Pauls Lamborghini und muss erst den Grasser-Piloten, wenig später auch den zweiten starken Youngster Laurin Heinrich ziehen lassen. Am Ende gerät Auer sogar noch unter Druck von Markenkollege Maro Engel - den zweiten Podestplatz des Wochenendes (nach Rang zwei am Vortag) rettet für den Österreicher dann aber das Safety-Car, hinter dem das Feld nach einem Crash von Arjun Maini (HRT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (597, 34, 14, N'Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (598, 34, 15, N') ins Ziel geführt wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (599, 34, 16, N'ZoomRicardo Feller konnte seine Pole nicht in den Sieg ummünzen. Bild: DTM/ADAC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (600, 34, 17, N'Ricardo Feller konnte seine Pole nicht in den Sieg ummünzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (601, 34, 18, N'David Schumacher schafft es vom starken dritten Startplatz aus immerhin in die Top-10. Einen Tag zum Vergessen erlebt hingegen Samstagssieger Mirko Bortolotti, der wegen technischer Probleme an seinem SSR-Lamborghini erst gar nicht mitfahren kann. In der Gesamtwertung baut Thomas Preining (Manthey')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (602, 34, 19, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (603, 34, 20, N') seinen Vorsprung dadurch auf 28 Punkte aus, der Österreicher holt nach schwachem Qualifying als Fünfter am Ende noch gute Punkte.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (604, 34, 21, N'1. Maximilian Paul (Grasser Lamborghini) 35 Runden (1:04:21.613 Std.)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (605, 34, 22, N'2. Laurin Heinrich (Küs Porsche) +0.600 Sek.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (606, 34, 23, N'3. Lucas Auer (Winward Mercedes) +1.320')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (607, 34, 24, N'4. Maro Engel (Landgraf Mercedes) +1.954')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (608, 34, 25, N'5. Thomas Preining (Manthey Porsche +3.248')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (609, 34, 26, N'6. Ricardo Feller (Abt Audi) +4.419')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (610, 34, 27, N'7. Luca Engstler (Engstler Audi) +4.680')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (611, 34, 28, N'8. Thierry Vermeulen (Emil Frey')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (612, 34, 29, N'Ferrari')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (613, 34, 30, N') +7.159')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (614, 34, 31, N'9. David Schumacher (Winward Mercedes) + 7.617')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (615, 34, 32, N'10. Franck Perera (')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (616, 34, 33, N'SSR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (617, 34, 34, N'Lamborghini) + 8.008')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (618, 34, 35, N'1. Thomas Preining (Manthey Porsche) 117 Punkte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (619, 34, 36, N'2. Sheldon van der Linde (Schubert BMW) 89')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (620, 34, 37, N'3. Mirko Bortolotti (SSR Lamborghini) 88')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (621, 34, 38, N'4. Ricardo Feller (Abt Audi) 88')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (622, 34, 39, N'5. Maro Engel (Landgraf Mercedes) 78')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (623, 35, 0, N'Der neue DTM-Veranstalter ADAC schafft früh Planungssicherheit für die Saison 2024: Lausitzring rückt im Kalender vor, weiteres Auslandsevent möglich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (624, 35, 1, N'Pünktlich zur Halbzeit der aktuellen DTM-Saison am Nürburgring hat die DTM am Wochenende ihren neuen Rennkalender für das kommende Jahr 2024 veröffentlicht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (625, 35, 2, N'Dabei setzt die Serie nach der großen Neuaufstellung unter Schirmherrschaft des ADAC offenbar auf Kontinuität, denn an den acht Strecken des Kalenders ändert sich für nächste Saison nichts - Unterschiede gibt es aber, was die Reihenfolge der Läufe betrifft und auch die Länge der Saison, die 2024 entzerrt wird und fast einen Monat länger dauert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (626, 35, 3, N'Nach dem späten DTM-Auftakt dieses Jahr Ende Mai in Oschersleben, legt die Tourenwagen-Serie dort 2024 schon vom 26.-28. April los. Während 2023 danach bereits das erste von zwei Auslandsrennen in Zandvoort anstand, geht es kommendes Jahr erst einmal an den Lausitzring (24.-26. Mai), ehe Anfang Juni (7.-9. Juni) erneut das Gastspiel auf dem beliebten Kurs in den holländischen Dünen ansteht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (627, 35, 4, N'ZoomAuch 2024 dürfen sich die Fans wieder auf die DTM freuen Bild: ADAC/DTM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (628, 35, 5, N'Auch 2024 dürfen sich die Fans wieder auf die DTM freuen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (629, 35, 6, N'Das Saisonhighlight auf dem beliebten Stadtkurs in Nürnberg steht einen Monat später an, vom 5.-7. Juli rast die DTM über den Norisring. Rund zwei Wochen später als dieses Jahr, also erst Mitte August, geht es dann in die Eifel zum fünften Saisonlauf auf dem Nürburgring (16.-18. August).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (630, 35, 7, N'Den Schlussspurt im Titelkampf bilden die drei Rennen am')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (631, 35, 8, N'Sachsenring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (632, 35, 9, N'(6.-8. September), am Red-Bull-Ring im österreichischen Spielberg (27.-29. September) und das große Finale, das traditionell auf dem Hockenheimring steigt - erneut am vorletzten Wochenende im Oktober (18.-20. Oktober).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (633, 35, 10, N'Noch offen ist laut ADAC derzeit, ob der Kalender 2024 darüber hinaus noch mit einem weiteren Event im europäischen Ausland ergänzt wird. Ansonsten müssen sich die Fans aber kaum auf Änderungen einstellen: TV-Partner ProSieben überträgt die Serie auch nächstes Jahr live, in Österreich sind die DTM-Rennen weiterhin bei ServusTV zu sehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (634, 35, 11, N'26.-28. April 2024: Motorsport')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (635, 35, 12, N'Arena')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (636, 35, 13, N'Oschersleben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (637, 35, 14, N'24.-26. Mai 2024: Lausitzring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (638, 35, 15, N'07.-09. Juni 2024: Zandvoort Circuit (Niederlande)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (639, 35, 16, N'05.-07. Juli 2024: Norisring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (640, 35, 17, N'16.-18.  August 2024: Nürburgring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (641, 35, 18, N'06.-08. September 2024: Sachsenring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (642, 35, 19, N'27.-29. September 2024: Red-Bull-Ring (Österreich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (643, 35, 20, N'18.-20. Oktober 2024: Hockenheimring')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (644, 36, 0, N'Franck Perera macht sich beim DTM-Lauf auf dem Nürburgring mit einer Blockade unbeliebt - selbst bei Nutznießer Lucas Auer, der jetzt Wettschulden hat.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (645, 36, 1, N'Es war die Szene des Rennens beim siebten Saisonlauf der DTM auf dem Nürburgring! In der Hauptrolle: Alle drei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (646, 36, 2, N'Lamborghini')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (647, 36, 3, N'vom Team')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (648, 36, 4, N'SSR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (649, 36, 5, N'Performance. Zunächst legt Alessio Deledda seinen Lambo auf regennasser Strecke in der Bande von Kurve eins ab. Die Rennleitung reagiert darauf mit dem Safety-Car, das aber kostet den anderen SSR-Lamborghini von Mirko Bortolotti an der Spitze seinen bereits herausgefahrenen Vorsprung von sieben Sekunden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (650, 36, 6, N'Die Rettung: Ausgerechnet das dritte Auto des SSR-Teams von Franck Perera. Dieser ist bereits überrundet und liegt vor dem Restart als Puffer genau zwischen dem Führenden Bortolotti und den Verfolgern Thomas Preining und Ricardo Feller.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (651, 36, 7, N'So kommt es zum kuriosen Teamwork: Als das Safety-Car reinkommt, gibt Bortolotti vorne Gas, während Perera schon in der Zielkurve die Verfolger aufhält. Deren Handicap: Sie dürfen erst ab der Ziellinie überholen, was Preining und Feller auch umgehend tun - durch die Perera-Falle sind sie ohne Schwung aber chancenlos gegen den Winward-Mercedes von Lucas Auer, der von hinten herangestürmt kommt und sich vom vierten auf den zweiten Platz schiebt, während Bortolotti vorne längst über alle Berge ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (652, 36, 8, N'ZoomPreining und Feller dürfen Perera (l.) nicht vor der Ziellinie überholen, von hinten kommt Auer (r.) angeflogen. Bild: ran/ProSieben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (653, 36, 9, N'Preining und Feller dürfen Perera (l.) nicht vor der Ziellinie überholen, von hinten kommt Auer (r.) angeflogen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (654, 36, 10, N'TV-Experte Timo Scheider findet das nicht besonders fair: "Eigentlich lagen schon vor der letzten Kurve vier, fünf Wagenlagen zwischen den Teamkollegen (Bortolotti und Perera; d. Red.), für mein Empfinden war das definitiv zu viel", sagt der zweifache DTM-Champion und glaubt: "Pereras Bummelfahrt vor der Linie hatte schon einen großen Effekt, Preining und Feller werden sicher einen Hals haben. Das wird noch für Diskussionen sorgen."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (655, 36, 11, N'Allein: Im Ziel fallen die Reaktionen relativ gemäßigt aus. Preining nimmt''s sportlich und äußert sogar fast schon Bewunderung für den Taschenspielertrick der Konkurrenz: "Da haben die SSR-Jungs super zusammengearbeitet und mich blockiert. Aber auch das ist Motorsport", sagt der Österreicher, der die Meisterschaft nach dem Rennen weiterhin anführt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (656, 36, 12, N'Neue Freunde hat sich Perera, mit 39 Jahren aktuell der älteste Starter im DTM-Feld, am Samstag aber trotzdem keine gemacht: Schon am Start kachelt er dem Viertplatzierten Kelvin van der Linde (Abt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (657, 36, 13, N'Audi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (658, 36, 14, N') ins Heck und dreht den Südafrikaner um. Für Perera setzt es deshalb eine Strafe, die ihn aus der Führungsrunde wirft.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (659, 36, 15, N'ZoomPereras erster Streich: Am Start kachelt er Van der Linde rein. Bild: ran/ProSieben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (660, 36, 16, N'Pereras erster Streich: Am Start kachelt er Van der Linde rein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (661, 36, 17, N'Und selbst Auer, der große Nutznießer von Pereras kurioser Blockade-Aktion beim Restart, dürfte nur so mittelgut auf den Franzosen zu sprechen sein, erweist dieser ihm damit doch einen Bärendienst - zumindest, was das nächste Frühstück betrifft: Für den unwahrscheinlichen Fall, dass er von Startplatz acht aufs Podium stürmt, hatte Auer vor dem Rennen gewettet, dass er am Sonntag Pancakes mit Fleischsalat frühstückt, wie Experte Scheider noch während der Livesendung ausplaudert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (662, 36, 18, N'Nach dem Rennen will Auer davon natürlich nichts mehr wissen: "Ach, das wird mir jetzt unterstellt und in den Mund gelegt, aber das habe ich nie gesagt. Sowas wette ich doch nicht", lacht der Österreicher, nur um wenig später einzuräumen: "Na gut, wenn''s mir was bringt, dann zieh ich das jetzt eben durch." Prost Mahlzeit!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (663, 37, 0, N'Jetzt ist der Knoten geplatzt: Mirko Bortolotti gewinnt am Nürburgring sein erstes DTM-Rennen, Regen und Safety-Car sorgen für Spannung in der Eifel.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (664, 37, 1, N'Das lange Warten hat sich ausgezahlt: Mirko Bortolotti gehört seit seinem DTM-Debüt vor anderthalb Jahren zu den Spitzenpiloten der Serie, für einen Sieg hat es bisher aber nicht gereicht - am Samstag ist es endlich soweit, ausgerechnet auf dem Nürburgring!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (665, 37, 2, N'"Letztes Jahr war hier einer der schlimmsten Tage", erinnert sich Bortolotti an seinen Crash vor zwölf Monaten, der ihn 2022 die Meisterschaftschancen kostete, "heute ist dafür einer der besten: Die Revanche ist gelungen."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (666, 37, 3, N'Und wie: Nach Bestzeiten in Training und Qualifying, lässt der Lamborghini-Pilot vom Team')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (667, 37, 4, N'SSR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (668, 37, 5, N'Performance vom Start weg nichts anbrennen, sorgt für den siebten Sieger im siebten DTM-Rennen der Saison. "Das war längst überfällig, vom reinen Speed her hätte er schon mehrere Rennen gewinnen müssen. Jetzt ist er endlich da angekommen, absolut verdient", adelt Ex-DTM-Champion und TV-Experte Timo Scheider den "Mann des Wochenendes".')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (669, 37, 6, N'ZoomDarf strahlen: Mirko Bortolotti ist endlich DTM-Sieger Bild: DTM/ADAC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (670, 37, 7, N'Darf strahlen: Mirko Bortolotti ist endlich DTM-Sieger')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (671, 37, 8, N'Vor allem der Schlussspurt wird für Bortolotti dabei zur Nervenprobe, denn nach einer späten Safety-Car-Phase, die seinen Vorsprung von bereits sieben Sekunden zunichte macht, gerät der Lambo-Fahrer unter Druck von Mercedes-Winward-Pilot Lukas Auer, der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (672, 37, 9, N'bei einem kontroversen Restart')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (673, 37, 10, N'an DTM-Spitzenreiter Thomas Preining (Manthey')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (674, 37, 11, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (675, 37, 12, N') und Ricardo Feller (ABT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (676, 37, 13, N'Audi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (677, 37, 14, N') vorbeigeht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (678, 37, 15, N'"Lukas war richtig schnell zum Schluss, ich musste also schon das ganze Rennen durchpushen, um mir endlich den ersten Sieg zu holen. Am Ende war ich einfach nur froh, dass das Rennen endlich vorbei ist", strahlt Bortolotti, der durch den Erfolg vor Auer und Preining quasi für ein österreichisches Dreifach-Podium sorgt: Zwar startet der 33-Jährige unter italienischer Flagge, als Sohn eines bekannten Eissalonbesitzers in Wien ist Bortolotti aber in der österreichischen Hauptstadt aufgewachsen und lebt dort heute noch.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (679, 37, 16, N'Die nötige Prise Spannung liefert am Samstag in der Eifel einmal mehr das Wetter: Bei für August ohnehin extrem niedrigen Asphalttemperaturen von nur 17 Grad, sorgt ab Rennmitte ein Schauer für Chaos. Heftig ist dabei vor allem der Crash von Christian Engelhardt, der auf der nassen Fahrbahn hin zu Kurve eins sein Auto verliert und Porsche-Kollege Ayhancan Güven voll abräumt - beide Fahrer überstehen den harten Einschlag zum Glück unverletzt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (680, 37, 17, N'ZoomHeftiger Porsche-Crash: Engelhardt torpediert Güven Bild: ran/ProSieben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (681, 37, 18, N'Heftiger Porsche-Crash: Engelhardt torpediert Güven')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (682, 37, 19, N'Weil sich wenig später im Regen vor Kurve eins auch noch SSR-Lamborghini-Fahrer Alessio Deledda ins Kiesbett einbuddelt, schickt die Rennleitung das Safety-Car auf die Strecke und schiebt das Feld so noch einmal eng zusammen. Eis-Mann Bortolotti bleibt an der Spitze aber ganz cool und lässt sich davon nicht mehr beeindrucken: Mit seinem DTM-Premierensieg rückt er mit 88 Punkten hinter Leader Preining (106 Punkte) auf Rang zwei in der Meisterschaft vor.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (683, 37, 20, N'1. Mirko Bortolotti (SSR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (684, 37, 21, N'Lamborghini')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (685, 37, 22, N') 39 Runden (1:02:51.994 Std.)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (686, 37, 23, N'2. Lucas Auer (Winward')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (687, 37, 24, N'Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (688, 37, 25, N') +1.199 Sek.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (689, 37, 26, N'3. Thomas Preining (Manthey Porsche) +2.572')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (690, 37, 27, N'4. Ricardo Feller (Abt Audi) +3.117')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (691, 37, 28, N'5. Dennis Olsen (Manthey Porsche) +4.327')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (692, 37, 29, N'6. Marco Wittmann (Project 1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (693, 37, 30, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (694, 37, 31, N') +7.205')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (695, 37, 32, N'7. Sheldon van der Linde (Schubert BMW) +10.163')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (696, 37, 33, N'8. Kelvin van der Linde (Abt Audi) +13.297')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (697, 37, 34, N'9. Patric Niederhauser (Tresor Orange1 Audi) +14.649')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (698, 37, 35, N'10. Thierry Vermeulen (Emil Frey')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (699, 37, 36, N'Ferrari')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (700, 37, 37, N') +15.395')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (701, 37, 38, N'1. Thomas Preining (Manthey Porsche) 106 Punkte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (702, 37, 39, N'2. Mirko Bortolotti (SSR Lamborghini) 88')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (703, 37, 40, N'3. Sheldon van der Linde (Schubert BMW) 87')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (704, 37, 41, N'4. Ricardo Feller (Abt Audi) 75')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (705, 37, 42, N'5. Maro Engel (Landgraf Mercedes) 65')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (706, 38, 0, N'Max Verstappen eilt von Sieg zu Sieg und pulverisiert Rekorde: Schafft Red Bull mit seiner Dominanz etwas noch nie Dagewesenes?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (707, 38, 1, N'Mit unglaublichen 125 Punkten Vorsprung geht Max Verstappen in die Sommerpause der Formel 1, der dritte WM-Titel in Folge ist dem Niederländer realistisch kaum noch zu nehmen. Für Spannung an der Spitze sorgt ohne ernstzunehmende Gegner eigentlich nur die Frage, welches Ausmaß die beispiellose Rekordjagd des Red-Bull-Stars und seines Teams noch annehmen kann?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (708, 38, 2, N'Red Bull Racing gewann bisher alle zwölf Saisonrennen, Verstappen zehn davon, die letzten acht am Stück: Ausgerechnet bei seinem Heimspiel nach der Sommerpause in Zandvoort kann der Lokalmatador damit den Allzeitrekord von neun Siegen in Serie von Alberto Ascari (1952/1953) und Sebastian Vettel (2013) einstellen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (709, 38, 3, N'Red-Bull-Teamchef Christian Horner strahlt angesichts solcher Zahlen: "Was wir derzeit sehen, das gibt es ganz selten in der Formel 1 - dass ein Fahrer derart überlegen ist. Ich schätze mich sehr glücklich, dass ich so etwas als Teamchef erleben darf", sagt der Brite, der anders als Fans und Konkurrenten auf Spannung wie beim epischen Titelkampf zwischen Verstappen und Lewis Hamilton 2021 gut verzichten kann: "Davon erhole ich mich heute noch", lacht Horner.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (710, 38, 4, N'ZoomTeamchef Christian Horner kann Red Bulls Lauf kaum fassen Bild: Red Bull')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (711, 38, 5, N'Teamchef Christian Horner kann Red Bulls Lauf kaum fassen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (712, 38, 6, N'Selbst Teamkollege')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (713, 38, 7, N'Sergio')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (714, 38, 8, N'Perez zieht mittlerweile nur noch den Hut, wenn er sieht wie Verstappen, so wie zuletzt beim Belgien GP, mit gleichem Material an ihm vorbei und auf und davon stürmt: "Man kann Max da nichts absprechen, er zeigt eine gigantische Saison und ist sehr talentiert. Gemeinsam mit seinem Team holen sie einfach Wochenende für Wochenende das Maximum raus, das ist schon wirklich eindrucksvoll", staunt der Mexikaner.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (715, 38, 9, N'Doch woher kommt der unbändige Siegeshunger beim F1-Dominator? Einer, der es wissen muss, ist Papa Jos Verstappen, zwischen 1994 und 2003 selbst in der Formel 1. Der 51-Jährige glaubt: "Max will zeigen, wer der Beste ist. Das hat er hier (in Spa; d. Red.) auch wieder. Er ist voll drauf, aber das ist auch schwierig: Immer da zu sein, in jedem Training, Qualifying und Rennen - aber das ist es, was er im Moment macht."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (716, 38, 10, N'Dabei weiß der ehemalige Formel-1-Pilot selbstverständlich auch, dass ein derartiger Mega-Lauf nicht ohne starkes Team geht: "Man braucht natürlich ein gutes Fahrzeug und das hat er: Max mit Red Bull zusammen, das funktioniert einfach. Es ist unglaublich, wie ein Traum, nur noch besser", freut sich Papa Jos bei ServusTV.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (717, 38, 11, N'ZoomVerstappen feierte in Spa den zehnten Sieg im zwölften Rennen Bild: Red Bull')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (718, 38, 12, N'Verstappen feierte in Spa den zehnten Sieg im zwölften Rennen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (719, 38, 13, N'Sohnemann Max widerspricht seinem Vater bei der Erklärung für seine Nimmersatt-Attitüde keineswegs, gibt das Lob in gewisser Weise aber zurück: "Ich will immer mehr und versuche mir in jeder einzelnen Situation anzuschauen, was man hätte besser machen können. So wurde ich aber auch erzogen, immer mehr zu wollen und mir Details anzuschauen, selbst wenn Leute sagen, dass alles toll oder großartig ist - es gibt immer Dinge, die man noch besser machen kann", erklärt der Weltmeister.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (720, 38, 14, N'Dass es mit seinen einsamen Spazierfahrten an der Spitze indes ewig so weitergeht, davon geht Verstappen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (721, 38, 15, N'Junior')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (722, 38, 16, N'nicht aus: "Ich war ja auch mal auf der anderen Seite, wenn man Siege jagt, es aber nie reicht, weil man nicht das Paket dafür zur Verfügung hat", erinnert er sich an Jahre der Hamilton-Dominanz: "Entsprechend genieße ich das natürlich im Moment, aber ich weiß gleichzeitig auch, dass es an einem gewissen Punkt aufhören wird. Deswegen müssen wir es jetzt auskosten, weiter lernen und versuchen, uns zu verbessern."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (723, 38, 17, N'Auch wenn Letzteres im Angesicht von Red Bulls Hammer-Zahlen 2023 schwer möglich scheint: "Bisher als Team alle Rennen gewonnen zu haben, das ist schon unglaublich", grinst Verstappen. Für seinen Rennstall geht es jetzt doch tatsächlich um den Traum von einer perfekten Saison - das ist in 73 Jahren F1-Historie bis dato noch keinem Team gelungen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (724, 38, 18, N'ZoomAuch Teamkollege Perez kann mittlerweile nur noch gratulieren Bild: Red Bull')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (725, 38, 19, N'Auch Teamkollege Perez kann mittlerweile nur noch gratulieren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (726, 38, 20, N'Ganz nah dran war 1988')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (727, 38, 21, N'McLaren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (728, 38, 22, N'mit dem legendären MP4/4, der bis heute nicht nur als eines der schönsten, sondern vor allem auch als das erfolgreichste Formel-1-Auto aller Zeiten gilt: Ayrton')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (729, 38, 23, N'Senna')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (730, 38, 24, N'und Alain Prost gewannen damit 15 von 16 Rennen - und es wären wohl alle geworden, wäre Senna beim Italien GP in')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (731, 38, 25, N'Monza')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (732, 38, 26, N'nicht zwei Runden vor Schluss in Führung liegend mit dem überrundeten Williams-Ersatzfahrer Jean-Louis Schlesser kollidiert, wodurch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (733, 38, 27, N'Ferrari')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (734, 38, 28, N'einen viel umjubelten Heimsieg abstaubte.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (735, 38, 29, N'Dass beim Streben nach Perfektion bis zur letzten Zielflagge immer noch etwas schiefgehen kann, weiß auch Red Bulls erfahrener Motorsportberater Dr. Helmut Marko: "Wir wollen das jetzt natürlich fortführen", sagt er mit Blick auf die ungeschlagene Serie seines Teams und ein mögliches Formel-1-Novum, wohlwissend: "Es ist zwar unwahrscheinlich und unrealistisch, aber langsam glauben wir schon, dass es vielleicht doch gehen könnte." Kein Wunder, bei dieser erdrückenden Verstappen-Dominanz.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (736, 39, 0, N'Er ist der deutsche Star der DTM – René Rast. Hier spricht er über Nachhaltigkeit und Förderung im Rennsport.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (737, 39, 1, N'Herr Rast, von Audi sind Sie 2023 zu BMW gewechselt. Haben Sie sich an Ihre neuen Farben schon gewöhnt?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (738, 39, 2, N'René Rast (36): Ja, mittlerweile fühlt sich mein BMW-Overall nicht mehr fremd an, aber ich muss mich immer noch ein bisschen zwingen, meinen Fahrstil anzupassen. Den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (739, 39, 3, N'Audi R8')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (740, 39, 4, N'und den  BMW M4 kannst du nicht vergleichen. Der Audi hat einen Mittelmotor, der BMW einen Frontmotor. Mit dem Audi musst du eigentlich immer versuchen, die Geschwindigkeit in der Kurve hoch zu halten, während der BMW einen anderen Fahrstil erfordert: später bremsen, langsamer um die Ecke und zügig wieder raus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (741, 39, 5, N'Sie sind zuletzt am Norisring zweimal Zweiter geworden. Wie zufrieden sind Sie bisher mit Ihrer Saison?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (742, 39, 6, N'Zufrieden. Mein Teamkollege Sheldon [van der Linde, Schubert-BMW; d. Red.] ist die Messlatte, hat letztes Jahr die Meisterschaft gewonnen und ist auch dieses Jahr mittendrin im Titelkampf. Dass ich mit ihm mithalten kann und teilweise sogar vor ihm war, damit kann ich sehr zufrieden sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (743, 39, 7, N'ZoomDreifach-Champion René Rast liegt in der DTM auf Rang sieben, hat 34 Punkte Rückstand auf Porsche-Pilot Thomas Preining. Bild: Gruppe C Photography / ADAC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (744, 39, 8, N'Dreifach-Champion René Rast liegt in der DTM auf Rang sieben, hat 34 Punkte Rückstand auf Porsche-Pilot Thomas Preining.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (745, 39, 9, N'Sie sind nicht nur Sheldon van der Lindes Teamkollege, sondern mittlerweile gemeinsam mit Ihrem Manager Dennis Rostek auch sein Berater. Wie wichtig ist es Ihnen, Ihre Erfahrung an junge Rennfahrer weiterzugeben?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (746, 39, 10, N'Sehr wichtig, denn Motorsport wird immer schwieriger. Es gibt kaum noch Nachwuchsklassen – und wenn doch, sind sie sehr teuer. Deswegen ist es im deutschen Motorsport derzeit extrem schwierig, weil einfach das Geld fehlt. Wenn wir weiter Fahrer in der Formel 1 haben wollen – oder auch in anderen relevanten Rennserien –,  müssen wir da definitiv ansetzen. Irgendwer muss die Ausbildung und Förderung zahlen. Und wenn ich den Jungs mit Expertise zur Seite stehen kann, hilft auch das.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (747, 39, 11, N'Der ADAC setzt da mit seiner Stiftung Sport an, hat zur Saison 2023 auch die DTM übernommen und bekennt sich damit zum deutschen Rennsport. Wie finden Sie die neue DTM?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (748, 39, 12, N'Der Name DTM steht immer noch für Premium-Hersteller und Premium-Fahrer sowie erstklassigen Rennsport im Allgemeinen. Ich glaube, es ist unheimlich wichtig, dass man das bewahrt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (749, 39, 13, N'ZoomRasts BMW M4 des Schubert-Teams wird von einem 3-Liter-Reihensechszylinder-Twin-Turbo mit bis zu 590 PS angetrieben. Bild: Gruppe C Photography / ADAC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (750, 39, 14, N'Rasts BMW M4 des Schubert-Teams wird von einem 3-Liter-Reihensechszylinder-Twin-Turbo mit bis zu 590 PS angetrieben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (751, 39, 15, N'Und wie wichtig ist Nachhaltigkeit im Motorsport?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (752, 39, 16, N'Wir müssen alle unseren Beitrag dazu leisten, weniger CO2 auszustoßen. Wenn der Motorsport das fördern und ein Bewusstsein für nachhaltige Mobilität schaffen kann, ist schon viel gewonnen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (753, 39, 17, N'Die DTM fährt mit 50 Prozent Bioanteilen im Kraftstoff, in der Formel E, quasi Ihrem Zweitjob, fahren Sie mit Batteriestrom. Inwiefern kann der Motorsport auch Technologievorreiter sein?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (754, 39, 18, N'Motorsport war immer Vorreiter. Da müssen wir wieder ansetzen. Wir dürfen die Fans aber auch nicht zu sehr vergraulen, weil sie immer noch den Motorsport haben wollen, den sie kennen und lieben. Sie gucken Rennen nicht, um die Welt zu verbessern, sondern weil sie Entertainment haben wollen. Das darf man einfach nicht vergessen. Das Gleiche gilt für die Hersteller: Sie machen das nicht nur, um grün zu werden, sondern um einen Marketing-Effekt zu bekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (755, 39, 19, N'Der Mindener ist der Allrounder des deutschen Rennsports. Er war Meister im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (756, 39, 20, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (757, 39, 21, N'Carrera Cup, Porsche Supercup und im ADAC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (758, 39, 22, N'GT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (759, 39, 23, N'Masters. Mit Audi dreimal Champion in der DTM. Jetzt für BMW in der DTM und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (760, 39, 24, N'McLaren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (761, 39, 25, N'in der Formel E')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (762, 39, 26, N'unterwegs.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (763, 39, 27, N'Die DTM am Nürburgring gibt’s am 5./6. August jeweils ab 12.55 Uhr live auf ProSieben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (764, 40, 0, N'Wenn die 630 PS und 850 Nm des RS 6 performance nicht reichen: Audi plant eine Hardcore-Version seines Powerkombis. Der RS 6 GT soll 2024 kommen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (765, 40, 1, N'Seit 2020 ist die vierte Generation des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (766, 40, 2, N'Audi RS 6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (767, 40, 3, N'am Start: Die brutale Optik des Powerkombis verspricht nicht zu viel, denn unter der Haube steckt der Vierliter-V8-Biturbo, der im RS 6 satte 600 PS und 800 Nm Drehmoment an alle vier Räder liefert. Das Ergebnis sind beeindruckende Fahrleistungen: Topspeed bis zu 305 km/h (mit Dynamikpaket plus) und von 0 auf 100 km/h in 3,6 Sekunden. Doch da geht noch mehr!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (768, 40, 4, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (769, 40, 5, N'Im November 2022 präsentierte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (770, 40, 6, N'Audi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (771, 40, 7, N'die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (772, 40, 8, N'"performance"-Versionen von RS 6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (773, 40, 9, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (774, 40, 10, N'RS 7')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (775, 40, 11, N'. Dank neuer Turbolader mit um drei Millimeter vergrößerten Verdichterrädern (jetzt im 90-Grad-Innen-V der Zylinderbänke platziert) und angepasstem Ladedruck wurde die Leistung des V8-Biturbos auf 630 PS und 850 Nm gesteigert. Dazu gibt es neue 22-Zoll-Schmiederäder und ein kleineres, mechanisches Mittendifferenzial.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (776, 40, 12, N'Für all diejenigen, denen selbst das noch nicht reicht, arbeitet Audi an einer neuen Hardcore-Version des RS 6. Bereits vor einigen Monaten hatte der Geschäftsführer von Audi Sport, Sebastian Grams, durchblicken lassen, dass beim RS 6 performance noch nicht Schluss ist. Man könne den Kombi noch extremer, noch schärfer machen, hieß es.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (777, 40, 13, N'ZoomDie 22-Zoll-Schmiedefelgen des Audi RS 6 performance wiegen in Summe 20 Kilo weniger als die Standardräder.  Bild: AUDI AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (778, 40, 14, N'Die 22-Zoll-Schmiedefelgen des Audi RS 6 performance wiegen in Summe 20 Kilo weniger als die Standardräder.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (779, 40, 15, N'Das Ergebnis dürfte der RS 6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (780, 40, 16, N'GT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (781, 40, 17, N'sein, der aller Voraussicht nach 2024 auf den Markt kommen wird. Aktuell sind Erlkönige bereits auf der Nordschleife des Nürburgrings unterwegs. Einige Veränderungen sind trotz starker Tarnung bereits zu erkennen – die AUTO BILD-Illustration (ganz oben) zeigt, wie der Hardcore-RS-6 als Serienmodell aussehen könnte!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (782, 40, 18, N'Besonders auffällig ist das Heck des RS 6 GT. Neben einer neuen Schürze mit größerem Diffusor sticht vor allem der XXL-Dachspoiler ins Auge. Was sich technisch ändern wird, ist zum jetzigen Zeitpunkt noch nicht bekannt. AUTO BILD geht aber davon aus, dass der GT im Vergleich zum performance nicht nur optisch, sondern auch leistungstechnisch noch mal eine ordentliche Schippe drauflegen wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (783, 40, 19, N'AUTO BILD Gebrauchtwagenmarkt148.980 €Audi RS6 RS 6 Avant tiptronic HUD RSDyn Keramik HDMatrix AH9.999 km441 KW (600 PS)07/2023Zum AngebotBenzin, 11,6 l/100km (komb.), CO2 Ausstoß 265 g/km*169.980 €Audi RS6 4.0 TFSI quattro EU6d Avant LEDER LED NAVI3.000 km441 KW (600 PS)07/2023Zum AngebotBenzin, 11,6 l/100km (komb.), CO2 Ausstoß 289 g/km*143.157 €Audi RS6 Avant 4.0 TFSI quattro, 5 J. Garantie ab EZ3.500 km441 KW (600 PS)06/2023Zum AngebotBenzin, 11,5 l/100km (komb.), CO2 Ausstoß 263 g/km*154.990 €Audi RS6 Avant tiptronic Pano Matrix Laser HUD Nav5.999 km441 KW (600 PS)06/2023Zum AngebotBenzin, 12,1 l/100km (komb.), CO2 Ausstoß 276 g/km*180.900 €Audi RS6 Avant Keramik Dynamik Stadt Tour Abgas MTRX3.000 km441 KW (600 PS)06/2023Zum AngebotBenzin, 12,6 l/100km (komb.), CO2 Ausstoß 286 g/km*155.980 €Audi RS6 Avant Keramik/305kmh /ASG 36/100.000 / Navi10.000 km441 KW (600 PS)06/2023Zum AngebotCO2 Ausstoß 263 g/km*164.580 €Audi RS6 Dynamik-Paket Carbon Keramik Matrix HUD7.982 km441 KW (600 PS)05/2023Zum AngebotElektro/Benzin, 11,5 l/100km (komb.), CO2 Ausstoß 263 g/km*140.658 €Audi RS6 Avant 4.0 TFSI quattro, 5 J. Garantie ab EZ3.000 km441 KW (600 PS)05/2023Zum AngebotBenzin, 11,5 l/100km (komb.), CO2 Ausstoß 263 g/km*147.917 €Audi RS6 Avant 4.0 TFSI quattro,Keramik,5 J. Garantie3.291 km441 KW (600 PS)05/2023Zum Angebot155.000 €Audi RS6 Avant 4.0 TFSI, 5J. Garantie ab EZ, 305km/h5.200 km441 KW (600 PS)04/2023Zum AngebotAlle Audi RS6 gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (784, 40, 20, N'Dass der RS 6 GT so extrem wird wie das spektakuläre')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (785, 40, 21, N'RS 6 GTO concept')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (786, 40, 22, N', das 2020 anlässlich des 40. Jubiläums von')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (787, 40, 23, N'Audi quattro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (788, 40, 24, N'als Einzelstück gezeigt wurde, ist zwar unwahrscheinlich; immerhin könnte sich der GT daran orientieren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (789, 40, 25, N'Und wer weiß, vielleicht geht Audi beim RS 6 GT ja wirklich "all-in" – denn bei diesem Sondermodell dürfte es sich um ein letztes Hurra für den RS 6 mit Verbrenner handeln, bevor der elektrische Nachfolger präsentiert wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (790, 41, 0, N'Mehr Leistung für den Ford Mustang: Tuner Hennessey hat dem Muscle Car einen Kompressor und über 800 PS spendiert. Die Infos!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (791, 41, 1, N'Wem die Leistung eines gewöhnlichen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (792, 41, 2, N'Ford')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (793, 41, 3, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (794, 41, 4, N'Mustang')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (795, 41, 5, N'noch nicht genug ist, der wird bei Hennessey sicherlich fündig. Bekannt für leistungsstarke Kompressor-Umbauten, hat sich der US-amerikanische Tuner auch die neueste Generation des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (796, 41, 6, N'Pony')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (797, 41, 7, N'Cars vorgenommen. Das Ergebnis ist eine PS-Maschine, die mit den serienmäßigen 507 Sauger-PS nicht mehr viel zu tun hat.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (798, 41, 8, N'Basis für die Leistungskur ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (799, 41, 9, N'Mustang')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (800, 41, 10, N'der siebten Generation, genauer gesagt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (801, 41, 11, N'Mustang Dark Horse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (802, 41, 12, N', der aus einem Fünfliter-V8 serienmäßig glatte 500 hp (507 PS) herausholt. Doch dem Durst nach Leistung reichte der frei atmende Motor nicht aus – ein Kompressor sorgt jetzt für eine Zwangsbeatmung des Muscle Cars.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (803, 41, 13, N'Die zusätzliche Luft bringt ordentlich Leistung mit: 862')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (804, 41, 14, N'PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (805, 41, 15, N'(850 hp) schöpft der Mustang aus fünf Liter Hubraum, maximal 881 Nm Drehmoment liegen an den Hinterrädern an. Geschaltet wird entweder über ein manuelles Sechsgang-Getriebe oder wahlweise eine Zehnstufen-Automatik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (806, 41, 16, N'AUTO BILD Gebrauchtwagenmarkt62.980 €Ford Mustang Fastback 5.0 Ti-VCT V8 MACH1 (neu)2.500 km338 KW (460 PS)07/2023Zum AngebotBenzin, 12,4 l/100km (komb.), CO2 Ausstoß 284 g/km*66.600 €Ford Mustang Fastback 5.0 Ti-VCT V8 Aut. MACH1 (neu)2.500 km338 KW (460 PS)07/2023Zum AngebotBenzin, 11,7 l/100km (komb.), CO2 Ausstoß 270 g/km*59.980 €Ford Mustang GT Convertible4.900 km330 KW (449 PS)07/2023Zum AngebotBenzin, 11,6 l/100km (komb.), CO2 Ausstoß 265 g/km*64.907 €Ford Mustang S550 Convertible5.000 km338 KW (460 PS)06/2023Zum AngebotBenzin, 11,6 l/100km (komb.), CO2 Ausstoß 264 g/km*74.900 €Ford Mustang Mach 1 Fastback 5.0l Ti-VCT V8 6-Gang4.500 km338 KW (460 PS)06/2023Zum AngebotBenzin, 12,4 l/100km (komb.), CO2 Ausstoß 284 g/km*60.990 €Ford Mustang GT California Style Convertible Sonderm.3.000 km331 KW (450 PS)06/2023Zum AngebotBenzin, 12 l/100km (komb.), CO2 Ausstoß 273 g/km*66.740 €Ford Mustang GT Cabrio V8 California Special -8%*2.500 km330 KW (449 PS)06/2023Zum AngebotBenzin, 12 l/100km (komb.), CO2 Ausstoß 273 g/km*64.990 €Ford Mustang Convertible 5.0 Ti-VCT V8 Aut. GT5.000 km330 KW (449 PS)06/2023Zum AngebotBenzin, 11,6 l/100km (komb.), CO2 Ausstoß 265 g/km*55.900 €Ford Mustang GT 5.0 V8 Klimasitze Navi B&O Soundsystem4.900 km331 KW (450 PS)05/2023Zum AngebotBenzin, 11,8 l/100km (komb.), CO2 Ausstoß 268 g/km*62.900 €Ford Mustang GT Convertible *CALIFORNIA* DAB LED RFK5.000 km331 KW (450 PS)05/2023Zum AngebotBenzin, 12 l/100km (komb.), CO2 Ausstoß 273 g/km*Alle Ford Mustang gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (807, 41, 17, N'Zu den weiteren Modifikationen von Hennessey gehören stärkere Einspritzdüsen, ein High-Flow-Luftansaugsystem, eine neue High-Flow-Kraftstoffpumpe und ein Software-Update für das Motormanagement-System.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (808, 41, 18, N'Zusätzlich zur Leistungssteigerung ist das "H850"-Paket von Hennessey mit einigen optischen Verbesserungen verbunden: Die Amerikaner spendieren dem Sportwagen Seitenschweller, Frontsplitter und Heckspoiler – allesamt aus Kohlefaser gefertigt. Schmiederäder sind ebenfalls Teil des Pakets, zusammen mit Karosseriegrafiken, speziellen Plaketten und bestickten Kopfstützen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (809, 41, 19, N'ZoomOptionale Heritage-Aufkleber und Carbon-Bodykit bringen noch mehr Sportlichkeit zum Ausdruck. Bild: Hennessey')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (810, 41, 20, N'Optionale Heritage-Aufkleber und Carbon-Bodykit bringen noch mehr Sportlichkeit zum Ausdruck.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (811, 41, 21, N'Hinter den 19-Zoll-Aluminiumfelgen arbeitet die serienmäßige Mehrkolben-Bremsanlage, die aus dem Hause Brembo stammt. Beim Fahrwerk will Hennessey dagegen Hand anlegen – allerdings verraten die Texaner hier noch keine Details.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (812, 41, 22, N'Auch zum Preis des Upgrades hat Hennessey noch nichts verraten, es ist aber von einem deutlichen Zuschlag für die Performance-Variante auszugehen. Ab dem vierten Quartal 2023 soll der "H850" in Produktion gehen, Anfang 2024 dürften die ersten Exemplare an Kunden ausgeliefert werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (813, 42, 0, N'Bei eBay wird derzeit ein roter Mazda MX-5 der Generation NC angeboten. Der Roadster hat 126 PS und wird als reines Schönwetter-Auto beschrieben. Beulen, Kratzer und erst recht Rost soll der Japaner nicht haben!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (814, 42, 1, N'Ein leichter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (815, 42, 2, N'Zweisitzer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (816, 42, 3, N'mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (817, 42, 4, N'Hinterradantrieb')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (818, 42, 5, N'und drehfreudigem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (819, 42, 6, N'Saugmotor')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (820, 42, 7, N'ist was? Ein Garant für Fahrfreude? Ein Ass beim Slalomrennen auf dem Flugplatz oder einfach nur das schönste Spielzeug der Welt? Besitzer eines')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (821, 42, 8, N'Mazda MX-5')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (822, 42, 9, N'würden auf diese Fragen wahrscheinlich mit einem Schulterzucken und einem lakonischen "sowohl als auch" antworten. Denn der "Mixxer" kann viel – und er ist zuverlässig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (823, 42, 10, N'Genau so ein Spaßgerät wird aktuell bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (824, 42, 11, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (825, 42, 12, N'zum Verkauf angeboten. Es handelt sich um einen roten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (826, 42, 13, N'Mazda MX-5')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (827, 42, 14, N'NC aus dem Jahr 2006, der 8500 Euro kosten soll.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (828, 42, 15, N'Der Verkäufer hat die Beschreibung zum Auto kurz gehalten. Dennoch machen die Informationen zum Wagen Lust auf mehr. Da steht als Erstes, dass der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (829, 42, 16, N'Mazda')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (830, 42, 17, N'grundsätzlich in einem guten Zustand sein soll. Es gebe weder Beulen oder Kratzer noch Risse oder Löcher.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (831, 42, 18, N'ZoomDer Mazda MX-5 wurde den Angaben im Inserat zufolge nur im Sommer bei Sonnenschein gefahren. Bild: AUTO BILD Montage

eBay/jupie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (832, 42, 19, N'Der Mazda MX-5 wurde den Angaben im Inserat zufolge nur im Sommer bei Sonnenschein gefahren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (833, 42, 20, N'Das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (834, 42, 21, N'Faltdach')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (835, 42, 22, N'soll einwandfrei sein, im Angebot inbegriffen ist ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (836, 42, 23, N'Hardtop')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (837, 42, 24, N', dessen Zustand der Verkäufer ebenfalls als "sehr gut" beschreibt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (838, 42, 25, N'ZoomIm Cockpit ist alles zu finden, was man zum Spaßhaben beim Fahren braucht. Für Großgewachsene kann es eng werden. Bild: AUTO BILD Montage

eBay/jupie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (839, 42, 26, N'Im Cockpit ist alles zu finden, was man zum Spaßhaben beim Fahren braucht. Für Großgewachsene kann es eng werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (840, 42, 27, N'Der MX-5 ist')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (841, 42, 28, N'unfallfrei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (842, 42, 29, N', hat erst 94.000 Kilometer auf der Uhr und soll keinerlei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (843, 42, 30, N'Rostprobleme')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (844, 42, 31, N'haben. Er wurde den Angaben zufolge nur für Spaßfahrten im Sommer genutzt, wenn es nicht regnete. Elektrische Fensterheber und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (845, 42, 32, N'Ledersitze')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (846, 42, 33, N'sind an Bord.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (847, 42, 34, N'Der nächste Termin beim')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (848, 42, 35, N'TÜV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (849, 42, 36, N'steht im September 2024 an.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (850, 42, 37, N'ZoomDas Faltdach des angebotenen Mazda MX-5 soll sich in einem einwandfreien Zustand befinden.  Bild: AUTO BILD Montage

eBay/jupie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (851, 42, 38, N'Das Faltdach des angebotenen Mazda MX-5 soll sich in einem einwandfreien Zustand befinden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (852, 42, 39, N'Völlig problemfrei ist so ein MX-5 leider nicht. Der Japaner mag am allerliebsten schönes Wetter und kann auf ständigen Regen und fehlendes Waschen mit hässlichen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (853, 42, 40, N'Rostansätzen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (854, 42, 41, N'reagieren. Ständige Feuchtigkeit kann auch das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (855, 42, 42, N'Stoffdach')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (856, 42, 43, N'nicht so gut ab. Wer nicht vernünftig und vor allem regelmäßig durchlüftet, riskiert, dass ekliger')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (857, 42, 44, N'Schimmel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (858, 42, 45, N'in die Stoffkapuze einzieht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (859, 42, 46, N'Die Körpergröße spielt beim MX-5-Fahren eine Rolle. Unbedingt eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (860, 42, 47, N'Probefahrt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (861, 42, 48, N'machen, falls bisher noch keine Erfahrung vorhanden ist! Wenn man eine bestimmte Zahl an Zentimetern überragt, wird es unter Umständen eng im Cockpit, oder man sitzt ganz schön im Fahrtwind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (862, 42, 49, N'In den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (863, 42, 50, N'Kofferraum')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (864, 42, 51, N'passen 150 Liter Gepäck. Das ist überschaubar, wenn man mit dem Japaner auf die große Reise gehen will.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (865, 42, 52, N'Der 126-PS-Motor ist die kleinere von zwei möglichen Varianten. Die Maschine treibt den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (866, 42, 53, N'Mazda')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (867, 42, 54, N'flott vorwärts, verlangt aber auch nach ordentlichen Drehzahlen. So weit, so erwartbar, doch Letztere wirken sich normalerweise auf den Verbrauch aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (868, 42, 55, N'Die gute Nachricht für alle Kurvenkünstler lautet wie folgt: Man kann den MX-5 nicht nur mithilfe von Spezialisten zu einem noch schärferen Verhalten am Kurvenscheitelpunkt verhelfen. Man kann auch die Leistung steigern, und zwar ordentlich. Das Video oben erläutert, warum das Konzept Mazda MX-5 so genial ist – und zwar bis heute!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (869, 43, 0, N'Fahrwerk und Aerodynamik: Das Manthey Kit macht den Porsche 718 Cayman GT4 RS noch schneller, ist aber alles andere als ein Schnäppchen. Erster Check!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (870, 43, 1, N'Auf der Suche nach einem Tracktool, das auch problemlos im Alltag bewegt werden kann? Dann ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (871, 43, 2, N'Porsche 718 Cayman GT4 RS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (872, 43, 3, N'genau das richtige Auto! Mit einer Rundenzeit von 7:09,300 Minuten auf der Nordschleife des Nürburgrings (kürzere Variante der Nordschleife: 7:04,511 Minuten) ist er keine zehn Sekunden langsamer als der große Bruder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (873, 43, 4, N'911 (992) GT3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (874, 43, 5, N', der die Runde in 6:59,927 Minuten absolviert, kostet mit einem Basispreis von 155.575 Euro aber knapp 40.000 Euro weniger. Diese Preisdifferenz könnte zum Beispiel in das neue Manthey Kit investiert werden!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (875, 43, 6, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (876, 43, 7, N'Zugegeben, 42.504 Euro plus Einbau für das Manthey Kit sind alles andere als ein Schnäppchen. Wer es auf dem Trackday aber richtig ernst meint, sollte über die Anschaffung nachdenken, denn Manthey schärft an den entscheidenden Stellen nach.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (877, 43, 8, N'Genau wie bei 991 GT2 RS und 992 GT3 beschränkt sich das Kit auch beim GT4 RS auf Fahrwerk und Aerodynamik. Der 500 PS starke 4,0-Liter-Sechszylinder-Boxer bleibt unangetastet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (878, 43, 9, N'ZoomDie Carbon-Aerodiscs sind nicht nur effektiv, sie sehen auch noch richtig gut aus.  Bild: Christian Goes / AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (879, 43, 10, N'Die Carbon-Aerodiscs sind nicht nur effektiv, sie sehen auch noch richtig gut aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (880, 43, 11, N'Auf dem Goodwood Festival of Speed hatte ich die Möglichkeit, mir den GT4 RS mit Manthey Kit (so lautet die offizielle Porsche-Bezeichnung) genau anzuschauen. An der Front fallen als Erstes die zwei zusätzlichen Flaps pro Seite auf. Dahinter befinden sich neu gestaltete Aircurtains mit Radhaus-Gurney. Nicht zu erkennen, aber zu ertasten: Der Unterboden besteht im vorderen Bereich aus Carbon und besitzt neue Windkanäle.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (881, 43, 12, N'Weiter geht es mit den Carbon-Louvres (drei statt zwei pro Seite), die auf dem Testwagen in der PTS-Sonderfarbe "Pastellorange" besonders herausstechen und wunderbar mit der Carbon-Fronthaube des Weissach-Pakets harmonieren. Kleiner Wermutstropfen: Die Carbon-Louvres kosten extra und sind in den 42.504 Euro nicht enthalten. Gleiches gilt auch für die grünen Rennbremsbeläge eine Etage darunter. Die Stahlflex-Bremsleitungen gibt es ohne Aufpreis.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (882, 43, 13, N'ZoomAus zwei mach drei: Die Carbon-Louvres sehen aus wie ein Serienteil und passen perfekt zur Weissach-Haube, kosten aber extra.  Bild: Christian Goes / AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (883, 43, 14, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (884, 43, 15, N'Aus zwei mach drei: Die Carbon-Louvres sehen aus wie ein Serienteil und passen perfekt zur Weissach-Haube, kosten aber extra.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (885, 43, 16, N'Für Laien nicht zu erkennen: Manthey installiert zusätzliche Gitter in den Lufteinlässen hinter den vorderen Türen. Darin soll sich Pick-up von der Rennstrecke (Gummiabrieb etc.) sammeln und sich so leichter entfernen lassen – Manthey hat eben an alles gedacht!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (886, 43, 17, N'ZoomDer riesige Heckflügel ist 85 Millimeter breiter und lässt sich vierfach einstellen.  Bild: Christian Goes / AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (887, 43, 18, N'Der riesige Heckflügel ist 85 Millimeter breiter und lässt sich vierfach einstellen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (888, 43, 19, N'Ein optisches Highlight ist der neue Carbon-Heckflügel. Dieser ist 85 Millimeter breiter, hat eine veränderte Form und ist in vier Stufen einstellbar. Direkt zu erkennen ist er an den größeren Endplatten mit Manthey- statt GT4-RS-Schriftzügen. Wie bei allen Bestandteilen des Kits sieht der Flügel aber nicht nur gut aus, er bewirkt auch etwas: Bei 200 km/h verspricht Manthey fast doppelt so viel Abtrieb (169 statt 89 Kilo), allerdings nur in der nicht straßenzugelassenen Performance-Stellung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (889, 43, 20, N'Das wiederum hatte aber ein anderes Problem zur Folge, denn das gesamte Aerodynamik-Paket generiert so viel Abtrieb, dass die Puffer der Heckklappe eine kleine Delle ins Chassis gedrückt haben. Auch hier besserte Manthey nach und verbaute an den entsprechenden beiden Stellen kleine Carbon-Platten, die nur bei geöffneter Heckklappe zu sehen sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (890, 43, 21, N'Bereits inklusive sind die spektakulären Aero-Discs für die Hinterräder (lieferbar für die Schmiede- und die Magnesiumfelgen), die schon von GT2 RS und GT3 bekannt sind – und die auch mit Schriftzügen in Wagenfarbe geliefert werden können.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (891, 43, 22, N'Doch auch hier ist noch nicht Schluss, denn im ab Dezember 2023 erhältlichen Manthey Kit ist außerdem ein voll einstellbares Gewindefahrwerk mit vierfach einstellbaren Federbeinen und um 20 Prozent erhöhten Federraten an der Vorderachse enthalten. Druck- und Zugstufe lassen sich ohne Werkzeug einstellen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (892, 43, 23, N'ZoomDer zusätzliche Sichtcarbon-Gurney für den Ducktail kostet übrigens auch extra.  Bild: Christian Goes / AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (893, 43, 24, N'Der zusätzliche Sichtcarbon-Gurney für den Ducktail kostet übrigens auch extra.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (894, 43, 25, N'Optisch machen alle Teile des Kits einen extrem hochwertigen Eindruck und könnten auch glatt als Teile durchgehen, die direkt aus Weissach stammen. Das hat auch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (895, 43, 26, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (896, 43, 27, N'erkannt und bietet die Manthey Kits mittlerweile offiziell über das Porsche-Tequipment-Programm an, was den Vorteil hat, dass die Garantie erhalten bleibt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (897, 43, 28, N'AUTO BILD Gebrauchtwagenmarkt235.900 €Porsche Cayman 718 GT4 RS BOSE LED Rückfahrkamera3.200 km368 KW (500 PS)07/2023Zum Angebot84.900 €Porsche Cayman T 718 BOSE LED Rückfahrkamera6.000 km220 KW (299 PS)05/2023Zum Angebot122.990 €Porsche Cayman 718 GTS 4.0 *Vollschalensitze*Mwst*1.Hand ********3.990 km294 KW (400 PS)03/2023Zum AngebotBenzin, 10,8 l/100km (komb.), CO2 Ausstoß 246 g/km*105.999 €Porsche Cayman GTS 4.0 DSG - 1.Hd/orig. 3.333 KM - neuw.3.333 km294 KW (400 PS)11/2022Zum AngebotCO2 Ausstoß 246 g/km*104.490 €Porsche Cayman (718) GTS 4.0 | sofort Verfügbar |5.400 km294 KW (400 PS)10/2022Zum AngebotBenzin, 10,1 l/100km (komb.), CO2 Ausstoß 230 g/km*236.718 €Porsche Cayman GT4RS Weissach Clubsport Lift LED 918-Sit3.867 km368 KW (500 PS)06/2022Zum AngebotBenzin, 12,3 l/100km (komb.), CO2 Ausstoß 281 g/km*236.718 €Porsche Cayman GT4RS Weissach Clubsport Lift LED 918-Sit3.867 km368 KW (500 PS)06/2022Zum AngebotBenzin, 12,3 l/100km (komb.), CO2 Ausstoß 281 g/km*216.900 €Porsche Cayman 718 GT4 RS BOSE Weissach-Paket LED4.900 km368 KW (500 PS)06/2022Zum Angebot127.900 €Porsche Cayman 718 Cayman GT4*918 Spyder Sitze*Clubsport Paket!3.900 km309 KW (420 PS)06/2022Zum AngebotBenzin, 10,9 l/100km (komb.), CO2 Ausstoß 249 g/km*239.718 €Porsche Cayman 718 Cayman GT4 RS Weissach-Paket / Liftsystem3.200 km368 KW (500 PS)06/2022Zum AngebotBenzin, 12,3 l/100km (komb.), CO2 Ausstoß 281 g/km*Alle Porsche Cayman gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (898, 43, 29, N'Und was kommt unterm Strich dabei rum? 6,179 Sekunden, um genau zu sein! Mit dem Manthey Kit hat Jörg Bergmeister die Nordschleife in 7:03,121 Sekunden umrundet. Damit kommt der GT4 RS dem 992 GT3 schon ganz schön nah. Aber: Auch für den GT3 hat Manthey ein Performance-Kit parat!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (899, 44, 0, N'Erstmals verpasst BMW seinem kleinsten SUV eine Sport-Nachschärfung und adelt den X1 zum M35i. AUTO BILD SPORTSCARS hat sich den Alpen-Alleskönner beim DTM-Rennen am Norisring genauer angeschaut!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (900, 44, 1, N'Einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (901, 44, 2, N'BMW X2')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (902, 44, 3, N'M35i gibt es schon länger, für den allgemeintauglicheren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (903, 44, 4, N'X1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (904, 44, 5, N'hat man sich bis zum Modellwechsel Zeit gelassen. Nun, rund ein Jahr nach dem Start des Neuen, schiebt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (905, 44, 6, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (906, 44, 7, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (907, 44, 8, N'M')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (908, 44, 9, N'also die Sportversion nach.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (909, 44, 10, N'Am Triebwerk selbst wurde im Vergleich zum stärksten X2 nichts geändert, nur schärfere Abgasrichtlinien klauen dem X1 sechs PS auf seinen coupéhaften Bruder. Mit glatten 300 PS ist er zwar nicht untermotorisiert, die US-Version – hier pfeift man auf einen Ottopartikelfilter – leistet jedoch 317 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (910, 44, 11, N'Die beliebtesten SUV bei Carwow
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Preis
Zum Angebot












                                                                                    Kia EV6                                                                            




                                                                                    UVP ab 46.990 EUR/Ersparnis bei Carwow bis zu 12.077,00 EUR
                                                                            






















                                                                                    VW T-Roc                                                                            




                                                                                    UVP ab 25.860 EUR/Ersparnis bei Carwow bis zu 8809,00 EUR
                                                                            






















                                                                                    Dacia Spring                                                                            




                                                                                    UVP ab 22.750 EUR/Ersparnis bei Carwow bis zu 7178,00 EUR
                                                                            






















                                                                                    Kia Sportage                                                                            




                                                                                    UVP ab 34.250 EUR/Ersparnis bei Carwow bis zu 7791,00 EUR
                                                                            






















                                                                                    Hyundai Ioniq 6                                                                            




                                                                                    UVP ab 43.900 EUR/Ersparnis bei Carwow bis zu 7995,00 EUR
                                                                            






















                                                                                    Skoda Kamiq                                                                            




                                                                                    UVP ab 24.370 EUR/Ersparnis bei Carwow bis zu 8071,00 EUR
                                                                            






















                                                                                    Telsa Model Y                                                                            




                                                                                    UVP ab 44.890 EUR/Ersparnis bei Carwow bis zu 7177,00 EUR
                                                                            






















                                                                                    Cupra Formentor                                                                            




                                                                                    UVP ab 35.530 EUR/Ersparnis bei Carwow bis zu 11.517,00 EUR
                                                                            






















                                                                                    Ford Kuga                                                                            




                                                                                    UVP ab 36.250 EUR/Ersparnis bei Carwow bis zu 13.264,00 EUR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (911, 44, 12, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (912, 44, 13, N'Der Zweiliter-Vierzylinder mit Singleturbo-Aufladung (B48) drückt 400 Newtonmeter an das xDrive-Hang-on-Allradsystem. Letzteres kann im Extremfall bis zu 50 Prozent der Antriebsleistung an die Hinterräder weitergeben, arbeitet also plattformbedingt im Normalbetrieb als reiner Fronttriebler. Dennoch verspricht BMW, dass sich der M35i im Schnee hervorragend im Allraddrift ums Eck werfen lässt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (913, 44, 14, N'Zoom4,50 Meter lang, 1,62 Meter hoch – der X1, nicht der Redakteur. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (914, 44, 15, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (915, 44, 16, N'4,50 Meter lang, 1,62 Meter hoch – der X1, nicht der Redakteur.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (916, 44, 17, N'Auf nicht abgesperrter Strecke beschränken wir uns derweil auf die längsdynamischen Fahrwerte: In 5,4 Sekunden rennt das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (917, 44, 18, N'SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (918, 44, 19, N'auf Tempo 100, bei 250 km/h regelt BMW wie üblich ab. Damit das alles auch so fährt, wie es aussieht, verbaut die M GmbH ein adaptives Sportfahrwerk, das den M35i 15 Millimeter näher an den Asphalt bringt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (919, 44, 20, N'An der Vorderachse sortiert ein mechanisches Sperrdifferenzial den Radschlupf, die M-Compound-Bremsanlage mit gelochten Scheiben vorn und ausdauernderen Belägen ist optional – genau wie die schicken 20-Zoll-Felgen an unserem Testwagen. Serienmäßig hängen 19-Zöller an den Radnaben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (920, 44, 21, N'ZoomOptionale 20-Zoll-Felgen vor High-Performance-Bremsanlage. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (921, 44, 22, N'Optionale 20-Zoll-Felgen vor High-Performance-Bremsanlage.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (922, 44, 23, N'Im Interieur fallen sofort die zweifarbigen Sportsitze mit integrierter Kopfstütze auf, doch auch die gibt es nur, wenn das entsprechende Kästchen im Konfigurator angeklickt wird. Der Bezug ist übrigens aus "veganem Leder" gefertigt – früher sagte man Kunstleder.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (923, 44, 24, N'ZoomViel Platzangebot vorn und optionale Halbschalensitze. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (924, 44, 25, N'Viel Platzangebot vorn und optionale Halbschalensitze.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (925, 44, 26, N'Beeindruckend: Das Material fasst sich nicht wie Kunstleder an. Haptik und Sitzgefühl sind von echtem Leder kaum zu unterscheiden. Und weil man auf Kunstleder immer so fürchterlich schwitzt, ist der Sitz belüftet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (926, 44, 27, N'Das Sportlenkrad ist dagegen mit Echtleder ummantelt, gefällt mit schicken Aussparungen in der 6-Uhr-Speiche und einer Mittenmarkierung für den Motorsport-Fan. Die Schaltpaddel sind angenehm groß geraten, und auf der Minus-Seite versteckt sich sogar ein Special-Feature, das aufgedruckte "Boost" verrät es schon: Wer hier länger als eine Sekunde zieht, stellt sämtliche Systeme auf das schärfstmögliche Setting, wodurch sich der X1 M35i vorspannt, etwa für Überholmanöver – quasi ein Push-to-pass-Button wie im Rennsport.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (927, 44, 28, N'ZoomIm Innenraum gibt es ein neues Betriebssystem fürs Infotainment. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (928, 44, 29, N'Im Innenraum gibt es ein neues Betriebssystem fürs Infotainment.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (929, 44, 30, N'Infotainmentseitig hat BMW sein Breitbild-Cockpit mit einer neuen Generation des BMW-eigenen Betriebssystems ausgerüstet. Die nun neunte Version schaltet schneller zwischen den Bildschirmen hin und her, und auch an der Komplexität hat BMW gearbeitet: Dadurch, dass einige Menüebenen weggelassen wurden, soll der Fahrer weniger vom Fahren abgelenkt werden. Am besten ginge das mit einem iDrive-Controller, doch den haben die Münchner beim X1 bekanntlich wegrationalisiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (930, 44, 31, N'Am Heck gefällt der M35i mit einem großen Dachkantenspoiler inklusive zweier Längsstreben. Solche finden sich auch zwischen der kernig klingenden Vierrohranlage als angedeuteten Diffusor wieder.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (931, 44, 32, N'Kommen wir zum Schluss noch zu den praktischen Talenten: Das Raumangebot vorn ist auch für Großgewachsene mehr als ausreichend und weit von der ersten Generation entfernt – obwohl der Neue keine zehn Zentimeter gewachsen ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (932, 44, 33, N'AUTO BILD Gebrauchtwagenmarkt22.222 €BMW X1 sDrive18i Advantage19.200 km103 KW (140 PS)02/2019Zum AngebotBenzin, 7,2 l/100km (komb.), CO2 Ausstoß 165 g/km*23.890 €BMW X1 sDrive18i Advantage 19" Alu/Navi/PDC/Shz/Klimaauto17.687 km103 KW (140 PS)06/2019Zum AngebotBenzin, 5,8 l/100km (komb.), CO2 Ausstoß 132 g/km*24.400 €BMW X1 X1 sDrive18d xLine19.878 km110 KW (150 PS)01/2020Zum AngebotDiesel, 4,6 l/100km (komb.)*24.649 €BMW X1 sDrive18i Advantage TEMPO/H-Klappe/DAB7.469 km103 KW (140 PS)10/2020Zum AngebotBenzin, 5,5 l/100km (komb.), CO2 Ausstoß 125 g/km*24.790 €BMW X1 sDrive18i *BUSINESS-PAKET.NAVI.PDC*15.100 km103 KW (140 PS)06/2020Zum Angebot24.880 €BMW X1 sDrive18i Advantage NAVI Parkassistent17.490 km103 KW (140 PS)05/2020Zum Angebot24.890 €BMW X1 sDrive 18i Advantage SHZ NAVI AHK LED PANO17.295 km103 KW (140 PS)08/2019Zum Angebot24.900 €BMW X1 18d sDRIVE ADVANTAGE/19 ZOLL BICOLOR/1.HAND11.919 km110 KW (150 PS)05/2018Zum Angebot24.980 €BMW X1 sDrive 18i Advantage *LM+PDC+ISOFIX+GARANTIE* ####14.000 km103 KW (140 PS)07/2020Zum AngebotBenzin, 5,8 l/100km (komb.), CO2 Ausstoß 132 g/km*25.970 €BMW X1 sDrive18i Aut. Advantage Navi.LED.PDCvo+hinte19.465 km103 KW (140 PS)04/2019Zum AngebotBenzin, 5,8 l/100km (komb.), CO2 Ausstoß 133 g/km*Alle BMW X1 gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (933, 44, 34, N'Hinten finden auch durchschnittlich große Erwachsene Platz; im Kofferraum dürfen 540 Liter Gepäck mitfahren, bei geklappten Sitzen und bis unters Dach sogar 1600. Mit seinen 1665 Kilogramm DIN-Leergewicht gibt BMW einen WLTP-Verbrauch zwischen 8,0 und 8,5 Litern an – je nach Ausstattung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (934, 44, 35, N'ZoomEin großer Dachkantenspoiler mit zwei Finnen sorgt für einen sportlichen Look. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (935, 44, 36, N'Ein großer Dachkantenspoiler mit zwei Finnen sorgt für einen sportlichen Look.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (936, 44, 37, N'Preislich startet der X1 M35i bei 62.000 Euro und damit exakt auf dem einstigen Level des 100 PS stärkeren, aber einen Tick weniger vielseitigen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (937, 44, 38, N'Audi RS 3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (938, 44, 39, N'Sportback. Der vor uns stehende Testwagen liegt mit allen Extras übrigens bei 78.770 Euro. Die ersten Autos kommen im November 2023 zu den Kunden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (939, 44, 40, N'Volle Familientauglichkeit, ausreichendes Kraxel-Talent und dazu noch sportliche Fahrleistungen, die sich im Alltag nicht verstecken müssen. Der neue X1 M35i erfüllt gleich drei Wünsche auf einmal!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (940, 45, 0, N'Sportcoupé, Boxer-Sauger, Hinterradantrieb: Dieser Mix ist rar, doch der Subaru BRZ hat ihn. Nun kommt Motor-Nachschlag – was ihn noch kerniger macht!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (941, 45, 1, N'Er knurrt mit zarter Wut im Ton, wenn der Motor Zug an die Kette legt und in Richtung höhere Drehzahlen marschiert. Es knistert gelegentlich am Türrahmen, wenn sich der Wagen mit Schmackes in die Kurve dehnt. Manchmal rumpelt es auch bebend, wenn die entlastete Hinterachse über einen Buckel wälzt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (942, 45, 2, N'Es geht also eher derb als feingeistig zu. Schlimm? Ganz im Gegenteil! Denn nie klingen die "Arbeitsgeräusche" des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (943, 45, 3, N'Subaru BRZ')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (944, 45, 4, N'angestrengt, überlastet oder gar kaputt. Das ist eher eine erfrischend ehrliche Klangkulisse, das Auto legt sich halt ins Zeug und meldet selbstbewusst zurück.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (945, 45, 5, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (946, 45, 6, N'Akustisch, aber auch über Vibrationen, über kleine Stöße, ganz einfach über Leben in der Bude. Charakter hieß so etwas früher, heute meint man Authentizität – und im Groben ist an dieser Stelle alles zum neuen BRZ gesagt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (947, 45, 7, N'Im Feinen hat das Sportcoupé aber ebenfalls eine Menge beizutragen. Den Motor zum Beispiel. Als Vierzylinder-Boxer ist er ein echter Exot, als Saugmotor sogar vom Aussterben bedroht, und vom Hubraum aus betrachtet ein besonders eigenständiger Bursche. Dabei geht der neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (948, 45, 8, N'2.4er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (949, 45, 9, N'drehwillig und linear ans Werk, der Nachschlag an Hubraum tut ihm mächtig gut – nun wuchten 250 Newtonmeter Drehmoment im Kurbeltrieb herum, das macht den Wagen viel elastischer.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (950, 45, 10, N'ZoomSteht ihm prächtig: der neue 2.4er mag Drehzahlen und tourenfaul schnüren. Bild: AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (951, 45, 11, N'Steht ihm prächtig: der neue 2.4er mag Drehzahlen und tourenfaul schnüren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (952, 45, 12, N'Gleichzeitig büßt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (953, 45, 13, N'2.4er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (954, 45, 14, N'nichts von seinen ursprünglichen Zügen ein. Er dreht auch in Folge von 20 Prozent mehr Hubraum noch mit großem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (955, 45, 15, N'Elan')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (956, 45, 16, N'dem roten Bereich entgegen, läuft dabei mit dieser rauchigen Unförmigkeit aller Subaru-Boxer und tourt dennoch einzigartig geschmeidig durch das Drehzahlband. Kurz: Sein Herz schlägt für Benziner-Genießer.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (957, 45, 17, N'Seine Papierwerte komplettieren den wohligen subjektiven Eindruck: die maximale Leistung von 234 PS liegt bei 7000 Touren an, das höchste Drehmoment schüttelt der Benziner bei 3700 U/min raus. Das Ganze addiert sich zu einer effektiven Mischung. Wer es mit Kupplungsschlupf und reichlich Anfahrdrehzahl darauf anlegt, könnte zum Beispiel in 6,5 Sekunden auf Tempo 100 sprinten. Überholspurts von 80 auf 120 Km/h hakt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (958, 45, 18, N'Subaru')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (959, 45, 19, N'in 6,6 Sekunden ab – am Ende jedenfalls wirkt der BRZ für ein Auto ohne Turbo-Nachhilfe unerwartet hubraumstark.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (960, 45, 20, N'ZoomDas BRZ-Modelljahr 2023 dürfte ein seltener Anblick werden: Nur 300 Autos gibt Subaru in den Verkauf. Bild: AUTO BILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (961, 45, 21, N'Das BRZ-Modelljahr 2023 dürfte ein seltener Anblick werden: Nur 300 Autos gibt Subaru in den Verkauf.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (962, 45, 22, N'Außer im letzten Gang. Hier hat Subaru dem Getriebe eine arg lange Übersetzung eingerechnet, so stürzt der Tempozuwachs auf der Autobahn in eine fade Angelegenheit ab. Auch möchte das Getriebe mit Bedacht berührt, gerührt und nicht gerissen werden – die Anschläge des Sechsganghebels sind zwar kantig-endgültig ausgelegt, schnelle Gangwechsel fühlen sich jedoch sehr widerspenstig an.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (963, 45, 23, N'Mehr wollen und können wir nicht am Antrieb herummäkeln. Denn der BRZ entschädigt über sein launiges Fahrgefühl. Hinterradantrieb mit gesperrter Wirkung – mehr muss man nicht sagen. Heißt: Das Auto lenkt sich fein (wenn auch aus der Mitte heraus unter Hektik und leider mit viel zu wenig Spannkraft zurück zu null), astet sich verbissen gegen Schlupf stemmend aus Kurven heraus, lässt sich am Limit zu queren Handlungen verleiten, fühlt sich angenehm dirigierbar an.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (964, 45, 24, N'Subaru BRZ im AUTO BILD-Gebrauchtwagenmarkt28.900 €Subaru BRZ 2.0i Sport +, Garantie bis 08.202551.203 km147 KW (200 PS)08/2020Zum AngebotCO2 Ausstoß 196 g/km*29.490 €Subaru BRZ 2.0R AT Sport +50.532 km147 KW (200 PS)12/2019Zum AngebotBenzin, 8 l/100km (komb.), CO2 Ausstoß 183 g/km*29.490 €Subaru BRZ 2.0i Automatik Sport+50.500 km147 KW (200 PS)12/2019Zum AngebotBenzin, 8 l/100km (komb.), CO2 Ausstoß 183 g/km*28.900 €Subaru BRZ Sport+ (Z10)20.300 km147 KW (200 PS)07/2019Zum AngebotBenzin, 8,6 l/100km (komb.), CO2 Ausstoß 196 g/km*26.000 €Subaru BRZ BRZ 2.0i Sport43.000 km147 KW (200 PS)03/2019Zum AngebotBenzin, 8,6 l/100km (komb.)*27.750 €Subaru BRZ BRZ 2.0i Sport+39.500 km147 KW (200 PS)03/2019Zum AngebotBenzin, 8,6 l/100km (komb.), CO2 Ausstoß 197 g/km*27.490 €Subaru BRZ 2.0R AT Sport Automatik / LED / Keyless32.500 km147 KW (200 PS)04/2018Zum Angebot17.700 €Subaru BRZ 2.0i*KAMERA*SPORT-AGA*TEMPOMAT*6-GANG*XENON80.000 km147 KW (200 PS)01/2016Zum AngebotBenzin, 7,8 l/100km (komb.), CO2 Ausstoß 180 g/km*18.900 €Subaru BRZ149.900 km147 KW (200 PS)12/2012Zum AngebotBenzin, 7,8 l/100km (komb.)*39.999 €Subaru BRZ HK-Power Stage 2130.000 km235 KW (320 PS)10/2012Zum AngebotBenzin, 7,8 l/100km (komb.)*Alle Subaru BRZ gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (965, 45, 25, N'Schade: trotz erlebbar tiefem Schwerpunkt dürfte der BRZ gerne mit weniger Eigenleben (sprich Karosseriebewegung) und griffiger (sprich mit klebrigeren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (966, 45, 26, N'Reifen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (967, 45, 27, N') in die Kurve stechen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (968, 45, 28, N'Am Ende steht aber das runde, handliche Gesamtgefühl des nur 1279 Kilogramm schweren Autos. Fazit an dieser Stelle also: Der BRZ macht es kraftvoll, spielerisch, leichtfüßig. Fahrerauto nennt man so was auch. Dazu passen die stramm von Seitenwangen dominierten Vordersitze und das angenehm einfach sortierte Zentralinstrument mit großem Drehzahlmesser im Analog-Stil.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (969, 45, 29, N'ZoomNun auch digital: Cockpit mit neuer Instrumenteneinheit. Bild: AUTOBILD')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (970, 45, 30, N'Nun auch digital: Cockpit mit neuer Instrumenteneinheit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (971, 45, 31, N'Etwas verspielter geht es auf Wunsch ebenfalls: Mit per Taste aktiviertem Sportmodus verwandelt sich die Darstellung in eine vom Motorsport inspirierte Grafik für die Fahrinformationen. Abgesehen von ESP, Brems- und Spurhalteassistenz steckt keine weitere elektronische Fahrunterstützung im BRZ. Weitere Elektronik ist auch gar nicht vorgesehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (972, 45, 32, N'Die Preisliste (bei 38.990 Euro geht''s los) gibt dann auch insgesamt kaum mehr her, weist außer Außenfarben und Styling nur eine Sportabgasanlage bzw. ein zweites BRZ-Modell mit Automatikgetriebe aus. Macht nichts, der BRZ hat die schönsten Extras schließlich schon ab Werk: Herz und Seele.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (973, 45, 33, N'Der Hubraum-Zuschlag steht dem leichten Coupé bestens – so boxt sich der Subaru BRZ einen weiteren Schritt in Richtung Fahrmaschine. Und: ein günstiges Auto in Relation zu so viel Erlebnis am Steuer.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (974, 46, 0, N'Der Gemera ist der erste Koenigsegg mit vier Sitzplätzen. Jetzt gibt es den Hyper-GT auch mit V8-Twinturbo und unglaublichen 2300 PS. Alle Infos!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (975, 46, 1, N'Premiere für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (976, 46, 2, N'Koenigsegg')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (977, 46, 3, N'! Mit dem Gemera präsentierte die schwedische Marke 2020 das erste Modell mit Platz für vier Leute und Gepäck. Drei Jahre später ist die Serienversion fertig – und bei der hat sich noch mal einiges verändert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (978, 46, 4, N'Außerdem bietet Koenigsegg den Gemera jetzt auch mit dem V8-Twinturbo aus dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (979, 46, 5, N'Jesko')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (980, 46, 6, N'an. Die Leistungsdaten? Einfach nur irre!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (981, 46, 7, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (982, 46, 8, N'➤ Platz für vier Personen plus Gepäck')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (983, 46, 9, N'➤ zwei unterschiedliche Motorisierungen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (984, 46, 10, N'➤ Elektromotor plus Dreizylinder-Benziner (1400 PS und 1850 Nm)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (985, 46, 11, N'➤ Elektromotor plus V8-Twinturbo (2300 PS und 2750 Nm)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (986, 46, 12, N'➤ bis zu 1000 Kilometer Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (987, 46, 13, N'➤ 50 Kilometer rein elektrische Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (988, 46, 14, N'➤ vier beheizte und belüftete Einzelsitze')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (989, 46, 15, N'➤ acht (!) Becherhalter, zwei pro Person')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (990, 46, 16, N'➤ nur 300')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (991, 46, 17, N'Koenigsegg Gemera')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (992, 46, 18, N'werden gebaut')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (993, 46, 19, N'➤ Produktionsstart Ende 2024')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (994, 46, 20, N'➤ erste Kundenfahrzeuge ab 2025')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (995, 46, 21, N'Mit dem Gemera erfüllt sich Firmengründer Christian von Koenigsegg einen Traum. Seit 2003 arbeitet er an der Idee, die Fahrleistungen eines Hypersportwagens mit dem Praxisnutzen und den Annehmlichkeiten eines Viersitzers zu kombinieren. 20 Jahre später präsentiert Koenigsegg das Ergebnis: den Gemera!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (996, 46, 22, N'Im Rahmen der Eröffnung des neuen "Gripen Atelier" (Teil der Koenigsegg-Fabrik im schwedischen Ängelholm) hat Christian von Koenigsegg die Serienversion des Gemera enthüllt, bei der sich im Vergleich zur Studie noch mal einiges verändert hat. Zwar bleibt der Mega-GT ein Hybrid, die Zusammensetzung der Motoren ist allerdings neu.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (997, 46, 23, N'ZoomDie riesigen Türen haben keine B-Säule und sollen einen bequemen Ein- und Ausstieg ermöglichen.  Bild: Koenigsegg Automotive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (998, 46, 24, N'Die riesigen Türen haben keine B-Säule und sollen einen bequemen Ein- und Ausstieg ermöglichen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (999, 46, 25, N'Anstelle der drei Elektromotoren tritt jetzt ein neu entwickelter Elektromotor mit dem Spitznamen "Dark Matter". Dieser wiederum wird mit dem LSTT-Getriebe (Light Speed Tourbillon Transmission) kombiniert. Dieses Neungang-Getriebe wurde erst nach der Präsentation des Gemera mit dem Jesko eingeführt und jetzt an den viersitzigen Gemera adaptiert. Der neue Elektromotor ist mit dem LSTT-Getriebe kombiniert, was eine besonders leichte und kleine Einheit ergibt. Bedeutet: Das ursprünglich angedachte Eingang-Getriebe (Koenigsegg Direct Drive) fliegt raus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1000, 46, 26, N'Was bleibt, ist der TNG-Dreizylinder. TFG steht für "Tiny Friendly Giant" und bezeichnet den von Koenigsegg entwickelten Dreizylinder-Benziner. Aus zwei Liter Hubraum schöpft der TFG glatte 600 PS und 600 Nm maximales Drehmoment. Die enorme Leistung wird mithilfe zweier Turbolader erreicht. Die Maximaldrehzahl des Dreizylinders mit Trockensumpfschmierung liegt bei 8500 U/min. Trotz der aufwendigen Technik soll der im Gemera als Mittelmotor verbaute Dreizylinder gerade mal extrem leichte 70 Kilo wiegen und in einen gewöhnlichen Handgepäck-Koffer passen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1001, 46, 27, N'ZoomAuf dieser Explosionszeichnung ist gut zu erkennen, dass hinter den Sitzen nicht viel Platz für den großen V8 ist.  Bild: Koenigsegg Automotive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1002, 46, 28, N'Auf dieser Explosionszeichnung ist gut zu erkennen, dass hinter den Sitzen nicht viel Platz für den großen V8 ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1003, 46, 29, N'Die Systemleistung geben die Schweden mit 1400 PS und 1850 Nm an, was deutlich unter den im Jahr 2020 versprochenen 1700 PS und 3500 Nm liegt. Aber Koenigsegg wäre nicht Koenigsegg, wenn sie nicht noch ein Ass im Ärmel hätten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1004, 46, 30, N'Und dieses Ass trägt den Namen HV8 (Hot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1005, 46, 31, N'V8')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1006, 46, 32, N'). Wo aufgrund der Kombination aus Mittelmotor-Layout und vier Einzelsitzen bisher schlicht und ergreifend kein Platz für einen V8 war, konnte durch das kompakt bauende LSTT-Getriebe und den Elektromotor jetzt ausreichend Platz gewonnen werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1007, 46, 33, N'Der HV8 getaufte V8-Twinturbo ist praktisch der Motor aus dem Jesko, dessen Abgasführung jedoch nach oben verlegt wurde. Die Leistungswerte? Schwindelerregend! Allein der V8 leistet 1500 PS und ist damit so stark wie der W16 des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1008, 46, 34, N'Bugatti Chiron')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1009, 46, 35, N'. Kombiniert mit dem Elektromotor geben die Schweden eine Systemleistung (mit E85-Sprit) von unglaublichen 2300 PS und 2750 Nm an – Weltrekord für ein Serienauto!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1010, 46, 36, N'ZoomDer Koenigsegg Gemera soll ein Hyper-GT sein. In der V8-Konfiguration leistet er unglaubliche 2300 PS. Bild: Koenigsegg Automotive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1011, 46, 37, N'Der Koenigsegg Gemera soll ein Hyper-GT sein. In der V8-Konfiguration leistet er unglaubliche 2300 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1012, 46, 38, N'Fahrleistungen verrät Koenigsegg zu diesem Zeitpunkt noch nicht. Doch schon für die Version mit Dreizylinder gab Koenigsegg 2020 einen Beschleunigungswert von 1,9 Sekunden auf 100 km/h und einen 400 km/h Topspeed an.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1013, 46, 39, N'Der Aufpreis für das HV8-Upgrade soll übrigens bei knapp 400.000 US-Dollar liegen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1014, 46, 40, N'Auf den ersten Blick sieht der Mega-GT aus wie ein Sportwagen. Erst wenn die riesigen "Katsad" genannten Türen öffnen, wird klar, dass der Gemera ein Gran Turismo mit Platz für vier Personen ist. Das Design ist spektakulär und erinnert gleichzeitig an den ersten Koenigsegg überhaupt, den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1015, 46, 41, N'CC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1016, 46, 42, N'Prototyp von 1996.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1017, 46, 43, N'Am Heck fallen vor allem die Auspuffrohre auf, die links und rechts neben der Glas-Motorabdeckung enden – ähnlich wie beim')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1018, 46, 44, N'Porsche 918 Spyder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1019, 46, 45, N'oder dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1020, 46, 46, N'McLaren 600LT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1021, 46, 47, N'. Die Titan-Auspuffanlage stammt von Akrapovic.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1022, 46, 48, N'Bei der Serienversion hat Koenigsegg einzelne Details entschärft. So mussten die Kameras beispielsweise konventionellen Außenspiegeln weichen, weil die futuristische Lösung nicht weltweit homologiert werden kann. Außerdem wird zukünftig ein optionales "Ghost"-Paket mit größerem Splitter, Heckflügel und mehr erhältlich sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1023, 46, 49, N'ZoomVier Einzelsitze im Gemera: Koenigsegg verspricht gute Platzverhältnisse – vorne wie hinten. Bild: Koenigsegg Automotive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1024, 46, 50, N'Vier Einzelsitze im Gemera: Koenigsegg verspricht gute Platzverhältnisse – vorne wie hinten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1025, 46, 51, N'Das Cockpit des Gemera ist typisch Koenigsegg. Auch beim ersten Viersitzer haben die Schweden an der abgerundeten Windschutzscheibe inklusive mittig aufgestelltem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1026, 46, 52, N'Scheibenwischer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1027, 46, 53, N'festgehalten. Auch das von den CC- und Agera-Modellen bekannte Glasdach wurde für den Mega-GT übernommen. Die vorderen Sitze sind aus Carbon gefertigt und wiegen gerade mal 17 Kilo pro Stück. Durch die integrierten Gurte sollen die Mitfahrer auf den hinteren Plätzen bequem ein- und aussteigen können. Zudem verspricht Koenigsegg, dass die Rücksitze genauso komfortabel sind wie die Vordersitze – alle vier sind belüftet und beheizt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1028, 46, 54, N'Als echter GT bietet der Gemera viele Annehmlichkeiten. Darunter: Dreizonen-Klimaautomatik, zwei große Touchscreens (jeweils einen für vorne und hinten), acht (!) Becherhalter, WLAN-Hotspot und Apple CarPlay. Das Lenkrad mit dem oben aufgesetzten Bildschirm inklusive Gyro-Sensor ist aus dem Jesko bekannt. Zu allem Überfluss bietet der Gemera auch noch Platz fürs Gepäck. Insgesamt stehen 200 Liter Stauraum zur Verfügung – fast doppelt so viel wie beim')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1029, 46, 55, N'Porsche 911 Turbo')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1030, 46, 56, N'. Ein echter Alleskönner, der Gemera!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1031, 47, 0, N'Der Basis-Neupreis des Porsche Macan GTS liegt bei knapp 100.000 Euro. Im Privatleasing ist das 440 PS starke SUV aber auch kein Schnäppchen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1032, 47, 1, N'Einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1033, 47, 2, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1034, 47, 3, N'besitzen – das ist für viele Autofans ein Traum! Auf dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1035, 47, 4, N'Gebrauchtwagenmarkt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1036, 47, 5, N'gibt es die günstigsten Exemplare schon für weniger als 10.000 Euro; soll es aber ein Neuwagen sein, dann wird es deutlich teurer! Mit einem Basispreis von 63.945 Euro ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1037, 47, 6, N'718 Cayman')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1038, 47, 7, N'aktuell der günstigste Porsche im Konfigurator. Einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1039, 47, 8, N'Basis-Macan')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1040, 47, 9, N'mit 265 PS starkem Vierzylinder gibt es ab 69.895 Euro. Soll es das Macan-Topmodell GTS sein, werden mindestens 96.075 Euro fällig. Und auch im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1041, 47, 10, N'Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1042, 47, 11, N'wird der Macan nicht zum Schnäppchen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1043, 47, 12, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) gibt es aktuell einen 440 PS starken')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1044, 47, 13, N'Porsche Macan')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1045, 47, 14, N'GTS im Leasing – es handelt sich um einen sofort verfügbaren Neuwagen. Das 272 km/h schnelle')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1046, 47, 15, N'SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1047, 47, 16, N'in der Außenfarbe "Kreide" ist sehr gut ausgestattet und hat einen Listenpreis von 124.888 Euro. Das Angebot richtet sich gleichermaßen an Privat- und Gewerbekunden, doch die monatliche Rate hat es in sich: 1599 Euro brutto (1343,70 Euro netto) soll der Macan kosten. Immerhin ist keine Anzahlung nötig.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1048, 47, 17, N'(')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1049, 47, 18, N'Unterhaltskosten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1050, 47, 19, N'berechnen? Zum Kfz-Versicherungsvergleich!)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1051, 47, 20, N'Die Vertragslaufzeit ist auf 48 Monate bei 10.000 Freikilometern pro Jahr festgelegt. Im Angebot lassen sich beide Parameter nicht anpassen, doch vielleicht sind andere Laufzeiten und Kilometerpakete per Nachfrage beim Leasingpartner möglich. Wenn nicht, sollten sich Kunden strikt an die 40.000 Kilometer Gesamtfahrleistung halten, denn jeder Mehrkilometer wird mit heftigen 49 Cent brutto berechnet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1052, 47, 21, N'Und das ist noch nicht alles, denn auch die Überführungskosten fallen extrem hoch aus. 2380 Euro brutto berechnet der Händler hierfür, sodass sich die Gesamtleasingkosten in vier Jahren auf 79.132 Euro (1599 Euro mal 48 plus 2380 Euro) belaufen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1053, 47, 22, N'Bedenkt man, dass der Porsche Macan auch als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1054, 47, 23, N'Gebrauchtwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1055, 47, 24, N'ziemlich wertstabil ist, ist das ein zu hoher Preis – zumindest für Privatkunden. Wenn es unbedingt ein Porsche sein soll, empfiehlt sich hier eher der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1056, 47, 25, N'Gebrauchtwagenkauf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1057, 47, 26, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1058, 47, 27, N'Positiv anzumerken ist, dass dieser Macan GTS sehr gut ausgestattet und als Tageszulassung mit nur zehn Kilometern auf dem Tacho sofort verfügbar ist, doch das sind die meisten Gebrauchtwagen auch.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1059, 47, 28, N'Bei hoher Nachfrage kann das Angebot laut sparneuwagen.de nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1060, 47, 29, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1061, 48, 0, N'Le Mans wird 100, Ferrari ist nach 50 Jahren zurück. AUTO BILD SPORTSCARS schnappt sich einen 296 GTS – und schaut sich das vor Ort an!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1062, 48, 1, N'Die 24 Stunden von Le Mans – wer Motorsport lebt, kommt spätestens jetzt ins Schwärmen. 1923 fand im Département Sarthe das erste Rennen zweimal rund um die Uhr statt, seitdem gab es 89 weitere Auflagen, die Legenden und Tragödien en masse hervorbrachten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1063, 48, 2, N'Man denke nur an die 1966er-Auflage, als der eigentlich siegreiche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1064, 48, 3, N'Ford')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1065, 48, 4, N'GT40 im Nachhinein nur als Zweiter gewertet wurde. Oder den Brun-Porsche, dem 1990  nur 15 Minuten vor dem Ziel auf der Hunaudières-Geraden der Motor um die Ohren flog. 2016 strandete der in Führung liegende')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1066, 48, 5, N'Toyota')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1067, 48, 6, N'in der letzten Runde auf der Start-Ziel-Geraden – direkt vor den Augen seiner Boxencrew.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1068, 48, 7, N'Und das diesjährige 91. Rennen versprach schon vor dem Start, ein echter Klassiker zu werden. In der Top-Kategorie waren mit Vorjahressieger Toyota,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1069, 48, 8, N'Porsche')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1070, 48, 9, N',')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1071, 48, 10, N'Cadillac')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1072, 48, 11, N',')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1073, 48, 12, N'Peugeot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1074, 48, 13, N'und natürlich')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1075, 48, 14, N'Ferrari')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1076, 48, 15, N'gleich fünf Werksteams gemeldet. So voller Prominenz war es an der Spitze des Feldes seit der 1999er-Ausgabe nicht mehr, die von vielen als das beste Le-Mans-Rennen aller Zeiten angesehen wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1077, 48, 16, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1078, 48, 17, N'Ferrari bekommt dabei besondere Aufmerksamkeit, denn das Comeback mit dem 499P markiert den ersten Werkseinsatz aus Maranello in der Top-Kategorie seit exakt 50 Jahren. Zwar fuhren von 1995 bis 99 einige 333SP an der Sarthe, die offenen Prototypen wurden jedoch privat und teils gegen den Willen des Werks eingesetzt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1079, 48, 18, N'Bei so viel Historie konnten wir nicht nein sagen, als uns Ferrari fragte, ob wir mit einem Straßenmodell die lange Reise nach Frankreich auf uns nehmen wollten. 1200 Kilometer in einem Ferrari? Da haben wir schon von schlimmeren Foltermethoden gehört.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1080, 48, 19, N'ZoomEin bisschen Blödsinn fährt immer mit: Stimmungsmeldung aus dem Cockpit. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1081, 48, 20, N'Ein bisschen Blödsinn fährt immer mit: Stimmungsmeldung aus dem Cockpit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1082, 48, 21, N'Also satteln wir am Mittwochmorgen vor dem Rennen unseren blauen 296 GTS und geben ihm zunächst auf deutscher Autobahn die Sporen. Hier kann der 2,9-Liter-V6 noch mal zeigen, was in ihm steckt, bevor wir bei Mülhausen auf die französische Seite wechseln und der Spaß vom dortigen Tempolimit als Geisel genommen wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1083, 48, 22, N'Bei maximal 130 km/h ist ab sofort der Cruising-Modus die einzig verbleibende Fortbewegungsart, aber zum Glück können wir bei unserem GTS das Dach nach hinten klappen. So röstet uns die knallige Frühsommer-Sonne die Stirn, während sich der 663 PS starke Biturbo hinter uns ein bisschen zu langweilen scheint. Im Race-Modus verwöhnt er uns zumindest mit seiner famosen Akustik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1084, 48, 23, N'ZoomEin Brett im Kornfeld: Der 296 ist fahrdynamisch eine echte Wucht. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1085, 48, 24, N'Ein Brett im Kornfeld: Der 296 ist fahrdynamisch eine echte Wucht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1086, 48, 25, N'Nach dem ersten Tankstopp in Besançon heißt unser Tagesziel Clermont-Ferrand. Hier erklärt uns Michelin am nächsten Tag, wie sie die High-End-Pneus für die Sportwagen aus Maranello zusammenmixen und backen. Je nach Performance-Ausprägung, Gewicht, bzw. Gewichtsverteilung und selbst der Motoreinbaulage des jeweiligen Modells, wird die Zusammensetzung des schwarzen Goldes angepasst und umfangreichst unter sämtlichen Bedingungen getestet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1087, 48, 26, N'ZoomAuf den französischen Landsträßchen wird das Autofahren zum puren Genuss. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1088, 48, 27, N'Auf den französischen Landsträßchen wird das Autofahren zum puren Genuss.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1089, 48, 28, N'Nachmittags macht sich die Kolonne auf den Weg; die letzten 400 Kilometer nach Le Mans stehen an. Doch wir haben keine Lust auf das ständige Autobahn-Gezuckel, schnappen uns Fotograf Lennen sowie einen SF90 Spider, dessen Piloten ebenfalls ausbruchswillig sind, und erkunden die kleinen Örtchen und verwinkelten Landstraßen rund um die Loire.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1090, 48, 29, N'ZoomItalienischer Supersportler vor US-Altblech in der französischen Provinz – gelebte Völkerverständigung. Bild: Alexander Bernt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1091, 48, 30, N'Italienischer Supersportler vor US-Altblech in der französischen Provinz – gelebte Völkerverständigung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1092, 48, 31, N'Schon im dritten Dörfchen haben wir Erfolg, finden eine echte Perle in Form eines US-Schraubers, der gerade einen Chevy-Big-Block lauffähig auf einem Gestell montiert hat und parallel an einem 66er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1093, 48, 32, N'Mustang')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1094, 48, 33, N'arbeitet. Draußen im Hof stehen noch drei weitere Ponys, ein völlig vergammelter El Camino, ein Datsun 240Z, ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1095, 48, 34, N'Jensen Interceptor')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1096, 48, 35, N'und ein Trabant Kombi – unter anderem.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1097, 48, 36, N'Ein komplett wirrer Laden, der innen eine Mischung aus Teilelager und Memorabilia-Museum ist und deren Besitzer – wie in Frankreich üblich – natürlich kaum ein Wort Englisch spricht. Meine drei Jahre Schulfranzösisch sind auch schon wieder ein Weilchen her, aber mit Händen und Füßen bekommt man sich schon verständigt. Im Zweifel spricht man schon eine gemeinsame Sprache: nämlich Auto. Als Kontrast passt unser brandneuer und 830 PS starker Ferrari hier perfekt dazu.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1098, 48, 37, N'ZoomFast geschafft: In der Dämmerung nähern wir uns dem Ziel Le Mans. Bild: Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1099, 48, 38, N'Fast geschafft: In der Dämmerung nähern wir uns dem Ziel Le Mans.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1100, 48, 39, N'Es wird schon dämmerig, als wir 15 Kilometer vor Le Mans das erste Hinweisschild auf unser Ziel erspähen. Natürlich ist auch hier noch ein Fotostopp Pflicht, bevor wir bei Dunkelheit im französischen Motorsport-Mekka einrollen – und prompt im Stau stehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1101, 48, 40, N'Im nicht enden wollenden Gezuckel wechseln wir in den Hybridmodus, dann schaltet der 296 GTS den Verbrenner ab und steht sich lautlos seine Michelins in den Bauch. Wir halten den enttäuschten Blicken der vorbeiwandernden Le-Mans-Fans aber nur kurz stand. "Wie, hier steht ein Ferrari und der macht keinen Lärm? Dreh mal hoch die Kiste." Hast ja recht, lieber Racing-Fan, wir sitzen ja nicht in einem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1102, 48, 41, N'Prius')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1103, 48, 42, N'. Ein Ferrari, den man nicht hören kann, das ist schon ein bisschen peinlich. Also: Ein kurzer Druck am digitalen Volant, der V6 springt vehement grollend an, die Passanten jubeln. So muss das sein, hier in Le Mans.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1104, 48, 43, N'Die Faszination Le Mans ist ungebrochen – das beweisen 325.000 Zuschauer, ein neuer Rekord. Dabei gilt: Je faszinierender das ­Gefährt, mit dem man anreist, ­desto mehr wird die Reise selbst zum Erlebnis. Im Ferrari? Unschlagbar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1105, 49, 0, N'Bei eBay steht derzeit diese weiße Simson S51 Comfort zum Verkauf. Die kultige Maschine ist umfassend neu gemacht worden. Sie wurde zu DDR-Zeiten so zugelassen und hat bereits eine Vape-Zündung an Bord.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1106, 49, 1, N'Nachhaltigkeit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1107, 49, 2, N'ist in aller Munde. Doch die Idee der langfristigen Einsetzbarkeit eines Produkts ist nicht neu. Gestalter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1108, 49, 3, N'Karl Clauss Dietel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1109, 49, 4, N'war schon Ende der 1970er-Jahre so clever, die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1110, 49, 5, N'Simson S51')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1111, 49, 6, N'so zu konzipieren, dass man alle Baugruppen einfach und unabhängig voneinander tauschen konnte. Obendrauf kommt der Reiz daran, dass viele Simson-Produkte bis heute 60 km/h schnell sein dürfen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1112, 49, 7, N'Wer Nachhaltigkeit zu schätzen weiß, und gerne stilvoll unterwegs ist, der sollte aktuell unbedingt mal bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1113, 49, 8, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1114, 49, 9, N'reinschauen. Da wird nämlich diese Simson S51 Comfort angeboten. Die inserierte Maschine ist mit 4300 Euro zwar relativ teuer – aber sie wurde neu aufgebaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1115, 49, 10, N'ZoomDie Simson S51 Comfort sieht so aus, als wäre sie gerade vom Band gerollt. Nach dem Neuaufbau fuhr sie kaum. Bild: AUTO BILD Montage

eBay/hemb_47')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1116, 49, 11, N'Die Simson S51 Comfort sieht so aus, als wäre sie gerade vom Band gerollt. Nach dem Neuaufbau fuhr sie kaum.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1117, 49, 12, N'Als erstes fallen an der Anzeige die Bilder auf. Sie zeigen eine bildschöne')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1118, 49, 13, N'Maschine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1119, 49, 14, N', die gerade erst vom Band gelaufen sein könnte. Der weiße')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1120, 49, 15, N'Lack')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1121, 49, 16, N'glänzt mit den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1122, 49, 17, N'Chromteilen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1123, 49, 18, N'um die Wette. Gebrauchsspuren oder Schäden sind weit und breit keine zu entdecken.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1124, 49, 19, N'Das dürfte kein Wunder sein, denn der Beschreibung nach wurde die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1125, 49, 20, N'Simson')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1126, 49, 21, N'komplett neu aufgebaut. Alle Teile sind neu, die Blechteile wurden lackiert und die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1127, 49, 22, N'Rahmenteile')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1128, 49, 23, N'pulverbeschichtet. Der Neuaufbau soll zu fast 100 Prozent original sein. Mit Ausnahme des Scheinwerfers. Das ist ein LED-Licht von einem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1129, 49, 24, N'Jeep Wrangler')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1130, 49, 25, N'. Doch den originalen Simson-Scheinwerfer gibt es zum Bike dazu.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1131, 49, 26, N'ZoomDer Verkäufer scheint sich bis ins Detail mit der Maschine Mühe gegeben zu haben. Bild: AUTO BILD Montage

eBay/hemb_47')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1132, 49, 27, N'Der Verkäufer scheint sich bis ins Detail mit der Maschine Mühe gegeben zu haben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1133, 49, 28, N'Beinahe noch wichtiger: Die S51 Comfort wurde den Angaben zufolge zu DDR-Zeiten so verkauft, nichts ist umgebaut. KBA-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1134, 49, 29, N'Papiere')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1135, 49, 30, N'liegen vor.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1136, 49, 31, N'ZoomDie Blechteile wurden neu lackiert, der Rahmen beschichtet. Bild: AUTO BILD Montage

eBay/hemb_47')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1137, 49, 32, N'Die Blechteile wurden neu lackiert, der Rahmen beschichtet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1138, 49, 33, N'Wer das Hobby DDR-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1139, 49, 34, N'Zweirad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1140, 49, 35, N'für sich entdecken will, der muss sich keine Sorgen machen: Die Fahrzeugindustrie der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1141, 49, 36, N'DDR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1142, 49, 37, N'und den Hersteller Simson gibt es zwar nicht mehr, doch die Enthusiasten-Szene ist groß.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1143, 49, 38, N'Spezialwerkstätten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1144, 49, 39, N'gibt es überall, Clubs und Freizeitschrauber sowieso.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1145, 49, 40, N'Klar,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1146, 49, 41, N'Schrauber')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1147, 49, 42, N', die schon mal einen Motor überholt haben, sind im Vorteil. Wer sich im Detail mit der Materie auseinandersetzt, erst recht. Doch auch Einsteiger finden ihren Weg in die Welt der Suhler Kult-Zweiräder, im Zweifelsfall eben mit Unterstützung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1148, 49, 43, N'Es gibt nur einen Wermutstropfen: Die Zeiten, in denen man eine Simson gegen ein paar Kästen Bier eintauschen konnte, sind lange vorbei. Heutzutage muss man für ein gutes Exemplar mehrere Tausend Euro anlegen. Und am besten einen abschließbaren Stellplatz haben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1149, 49, 44, N'ZoomFür die Simson-Modelle herrscht kein Mangel an Teilen. Nur die Qualität sollte man unbedingt prüfen. Bild: Andreas Vetter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1150, 49, 45, N'Für die Simson-Modelle herrscht kein Mangel an Teilen. Nur die Qualität sollte man unbedingt prüfen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1151, 49, 46, N'Bleibt die Frage nach')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1152, 49, 47, N'Ersatzteilen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1153, 49, 48, N'. Das Internet ist voll von Seiten, die Teile für die verschiedenen Simson-Modelle anbieten, teilweise sogar original aus der DDR. Mancher Händler macht es dem Kunden besonders einfach und vertreibt seine Produkte sogar via')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1154, 49, 49, N'Amazon')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1155, 49, 50, N'oder eBay.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1156, 49, 51, N'Soll heißen: Es gibt keinen Mangel an Teilen! Da können Simson-Neulinge ganz beruhigt sein. Die meisten Sachen sind auch noch echt bezahlbar. Doch die Qualität sollte geprüft werden. Wie bei vielen anderen historischen Fahrzeugen auch sind nachgefertigte Teile nicht immer garantiert von der besten Machart.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1157, 49, 52, N'Als klassische Schwachstelle gilt die serienmäßige Unterbrecher-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1158, 49, 53, N'Zündung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1159, 49, 54, N'. Sie wird von vielen Simson-Fahrern gegen die oben bereits erwähnte Vape-Zündung getauscht. An einer "Simme" gibt es immer mal wieder nach nachzustellen, zum Beispiel die Gänge oder die Bremsen. Man soll anhand eines Produktes aus dem Hause Simson aber sogar schrauben lernen können.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1160, 50, 0, N'Bei eBay steht gerade diese BMW R80 Scrambler zum Verkauf. Die coole Maschine wurde professionell umgebaut, alles ist den Angaben zufolge eingetragen. TÜV hat das Bike noch bis April 2024!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1161, 50, 1, N'Die bis 1984 gebauten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1162, 50, 2, N'Boxer-BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1163, 50, 3, N'stehen bis heute bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1164, 50, 4, N'Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1165, 50, 5, N'-Liebhabern hoch im Kurs. Warum? Weil die großen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1166, 50, 6, N'Zweiventiler')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1167, 50, 7, N'der Baureihe 247 das gesamte Repertoire des angenehmen Motorrad Fahrens beherrschen, inklusive langer Reisen, dynamischer Kurven und kurzer Ausflüge zur Eisdiele. Richtig cool wird so eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1168, 50, 8, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1169, 50, 9, N', wenn sie jemand stilvoll zum')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1170, 50, 10, N'Cafe Racer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1171, 50, 11, N'oder zum Scrambler umbaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1172, 50, 12, N'Und genau so eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1173, 50, 13, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1174, 50, 14, N'R 80 Scrambler wird derzeit bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1175, 50, 15, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1176, 50, 16, N'zum Verkauf angeboten. Die inserierte Maschine besticht gleich auf den ersten Blick mit ihrem wunderschönen Äußeren. Darüber hinaus macht die BMW einen sehr gepflegten Eindruck. (Notiz am Rande: Die heißeste BMW-Neuheit des Jahres 2023 gibt es oben im Video!)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1177, 50, 17, N'ZoomGrobstollige Reifen sind vorhanden und das Schutzblech vorne fehlt. Die BMW ist also auf jeden Fall ein Scrambler. Bild: AUTO BILD Montage

eBay/helgeh8657')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1178, 50, 18, N'Grobstollige Reifen sind vorhanden und das Schutzblech vorne fehlt. Die BMW ist also auf jeden Fall ein Scrambler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1179, 50, 19, N'Die Anzeige besticht mit den Bildern von der angebotenen Maschine. Die zeigen einen wirklich schönen, schwarzen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1180, 50, 20, N'Scrambler')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1181, 50, 21, N'mit genau den richtigen Details. Dazu gehören unter anderem das fehlende Schutzblech vorne, die mit Hitzeschutzband umwickelten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1182, 50, 22, N'Krümmer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1183, 50, 23, N'und natürlich die grobstolligen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1184, 50, 24, N'Reifen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1185, 50, 25, N'auf beiden Rädern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1186, 50, 26, N'ZoomDer Umbau wird als professionell beschrieben. Der große Zweiventil-Boxer von BMW kann auf jeden Fall jede Menge. Bild: AUTO BILD Montage

eBay/helgeh8657')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1187, 50, 27, N'Der Umbau wird als professionell beschrieben. Der große Zweiventil-Boxer von BMW kann auf jeden Fall jede Menge.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1188, 50, 28, N'Die Beschreibung zum Fahrzeug ist denkbar kurz gehalten. Sie erwähnt aber unter anderem, dass die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1189, 50, 29, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1190, 50, 30, N'in ihrem ganzen Leben erst 68.000 Kilometer gelaufen ist. Bei passender Pflege geht das als Kleinigkeit durch. Der Scrambler-Umbau ist professionell vorgenommen worden und sämtliche Änderungen an der Maschine sind bereits')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1191, 50, 31, N'eingetragen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1192, 50, 32, N'. Der Motor ist trocken und läuft ruhig, das Getriebe schaltet sauber.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1193, 50, 33, N'Auf das Preisschild hat der Verkäufer 7950 Euro geschrieben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1194, 50, 34, N'ZoomDie Maschine sieht auf den ersten Blick sehr gut aus. Das sollte natürlich ein Termin vor Ort bestätigen. Bild: AUTO BILD Montage

eBay/helgeh8657')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1195, 50, 35, N'Die Maschine sieht auf den ersten Blick sehr gut aus. Das sollte natürlich ein Termin vor Ort bestätigen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1196, 50, 36, N'Vor allem kommt es darauf an, bei der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1197, 50, 37, N'Besichtigung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1198, 50, 38, N'eines gebrauchten BMW-Bikes den Pflegezustand zu überprüfen. Der Vorbesitzer sollte möglichst umfassend darüber Auskunft geben können, wo die Maschine unterwegs war und wie sie behandelt wurde.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1199, 50, 39, N'Kenner wissen, dass BMW Motorrad technische Probleme schon immer gerne still und leise im Rahmen fälliger')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1200, 50, 40, N'Werkstattaufenthalte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1201, 50, 41, N'aus dem Weg geräumt hat. Das ist ein weiterer Grund, warum ein Motorrad mit belegbarer Historie zu bevorzugen ist. Abgesehen davon, dass man manche Fehler nur mithilfe von BMW-Spezialwerkzeugen erkennt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1202, 50, 42, N'Eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1203, 50, 43, N'Probefahrt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1204, 50, 44, N'ist zwingend nötig. Dabei stellt sich heraus, ob sich das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1205, 50, 45, N'Getriebe')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1206, 50, 46, N'sauber schalten lässt. Der Hinterradantrieb sollte dicht sein – austretende Flüssigkeit ist ebenso kritisch wie eindringende Feuchtigkeit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1207, 50, 47, N'Das Gleiche gilt für die Gummiteile. Darüber hinaus kommt es auf den Zustand der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1208, 50, 48, N'Felgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1209, 50, 49, N', Bremsscheiben und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1210, 50, 50, N'Federn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1211, 50, 51, N'bzw. auf deren Verschleiß an. Sämtliche elektronische Komponenten an Bord sollten störungsfrei funktionieren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1212, 51, 0, N'Bei eBay wird derzeit diese BMW R 1200 C angeboten. Die Maschine wird offen beschrieben, wirkt gepflegt und kostet nur kleines Geld. Ist der BMW-Chopper, mit dem Pierce Brosnan einst über die Kinoleinwand jagte, gut?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1213, 51, 1, N'Bevor sich')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1214, 51, 2, N'BMW Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1215, 51, 3, N'die endlos coole')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1216, 51, 4, N'BMW R 18')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1217, 51, 5, N'getraut hat, gab es schon mal einen Chopper bzw.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1218, 51, 6, N'Cruiser')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1219, 51, 7, N'von den Bayern. Das Motorrad hieß')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1220, 51, 8, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1221, 51, 9, N'R 1200 C und lief von 1997 bis 2004 vom Band. Berühmt wurde die C, als Pierce Brosnan 1997 auf ihr zusammen mit Oscar-Preisträgerin Michelle Yeoh im James-Bond-Streifen "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1222, 51, 10, N'Der Morgen stirbt nie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1223, 51, 11, N'" durch Saigon jagte.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1224, 51, 12, N'Aktuell wird so eine BMW R 1200 C bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1225, 51, 13, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1226, 51, 14, N'zum Kauf angeboten. Die Maschine macht auf den ersten Blick einen schönen, gut gepflegten Eindruck und weiß sowohl mit einer offenen Beschreibung durch den Verkäufer als auch mit ihrem kleinen Preis zu überzeugen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1227, 51, 15, N'Den Angaben zufolge befindet sich die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1228, 51, 16, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1229, 51, 17, N'in einem für ihr Alter guten Zustand. Gefahren worden ist die Maschine offenbar ordentlich, auf dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1230, 51, 18, N'Tacho')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1231, 51, 19, N'stehen 96.285 Kilometer. Doch das muss bei der richtigen Pflege kein Ausschlussgrund sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1232, 51, 20, N'Am 4. April 1997 erfolgte die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1233, 51, 21, N'Erstzulassung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1234, 51, 22, N'. Der aktuelle Besitzer hat die BMW 2008 gekauft; erhebt gleich zum Eingang der Beschreibung ihre')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1235, 51, 23, N'Zuverlässigkeit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1236, 51, 24, N'hervor. Es sind Gebrauchsspuren vorhanden, aber keine Kratzer. Zur letzten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1237, 51, 25, N'HU')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1238, 51, 26, N'im Juni 2022 gab es unter anderem neues Motoröl, neue Bremsflüssigkeit und frisches Kardanöl. Im Mai 2023 folgte noch eine neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1239, 51, 27, N'Batterie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1240, 51, 28, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1241, 51, 29, N'ZoomDie Maschine wurde offensichtlich mit einigem an Zubehör ausgestattet. Das ist Geschmackssache. Bild: eBay/monza42')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1242, 51, 30, N'Die Maschine wurde offensichtlich mit einigem an Zubehör ausgestattet. Das ist Geschmackssache.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1243, 51, 31, N'Es scheint einiges an Zubehör an Bord der BMW zu sein. Der Verkäufer hat die Liste gesplittet in einen Teil namens "Sonderausstattung" und in einen zweiten Teil, in dem nachgerüstete Features stehen. Die Sonderausstattung beinhaltet neben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1244, 51, 32, N'ABS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1245, 51, 33, N'und einem großen Windschild vom Hersteller eine mehrstufige')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1246, 51, 34, N'Griffheizung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1247, 51, 35, N'und reichlich Chromteile.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1248, 51, 36, N'ZoomDie BMW R 1200 C dürfte vor allem für Langstrecken-Motorradfahrer interessant sein. Bild: eBay/monza42')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1249, 51, 37, N'Die BMW R 1200 C dürfte vor allem für Langstrecken-Motorradfahrer interessant sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1250, 51, 38, N'Zu einem späteren Zeitpunkt bekam die BMW Helferlein wie einen Handballentempomat und eine große Steckdose mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1251, 51, 39, N'USB-Stecker')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1252, 51, 40, N'nachgerüstet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1253, 51, 41, N'Der Verkäufer erzählt die erfreulicherweise offen und ehrlich. Zu eben dieser Geschichte gehört auch, dass die Maschine schon mal einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1254, 51, 42, N'Unfall')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1255, 51, 43, N'hatte. Der wurde von der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1256, 51, 44, N'Versicherung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1257, 51, 45, N'reguliert, die Schäden seien bei BMW in einer Vertragswerkstatt behoben worden. Doch das ruft natürlich nach einer ganz genauen Prüfung der Umstände und des Ergebnisses der Reparatur. Schön: Die Rechnungen liegen vor!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1258, 51, 46, N'Auf dem Preisschild stehen 4860 Euro. Das ist überschaubar. Doch die Maschine sollte den guten ersten Eindruck beim')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1259, 51, 47, N'Termin vor Ort')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1260, 51, 48, N'halten, damit sich die Investition lohnt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1261, 51, 49, N'Wer sich für die Maschine begeistern kann, sollte unbedingt einen Besichtigungstermin ausmachen und eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1262, 51, 50, N'Probefahrt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1263, 51, 51, N'unternehmen. Das ist nicht nur grundsätzlich sinnvoll, es drängt sich besonders bei der BMW R 1200 C auf. Die Maschine bekam zu ihrer Zeit hier und dort nämlich Kritik dafür, dass die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1264, 51, 52, N'Aufhängung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1265, 51, 53, N'relativ hart sein soll und die Lenkung angeblich einigermaßen langsam reagiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1266, 51, 54, N'Motor')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1267, 51, 55, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1268, 51, 56, N'Getriebe')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1269, 51, 57, N'gelten als wahnsinnig zuverlässig und halten Laufleistungen jenseits der 50.000 Kilometer ohne zusätzlichen Aufwand aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1270, 51, 58, N'Kommt es zu Konstantfahrruckeln, hilft ein Codierstecker von BMW, der die Leerlaufdrehzahl anhebt. Bei der Probefahrt unbedingt auf das Schaltverhalten achten. Wenn es beim Einlegen der ersten Gangs kracht, ist das normal. Wenn die höheren Gänge sich nicht einlegen lassen wollen, ist Vorsicht geboten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1271, 51, 59, N'Achtung, eine besondere Eigenheit der R 1200 C: Man sollte sensibel mit dem Seitenständerausleger umgehen! Der ist in der Nähe der Fußraste platziert und kann bei leichtem Kontakt mit dem Fuß die Zündung unterbrechen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1272, 52, 0, N'Suzuki bringt anlässlich des 25. Geburtstags der Hayabusa dieses einzigartige Sondermodell mit Namen 25th Anniversary Edition. 50 Exemplare kommen bei uns auf den Markt, um die Geschichte des mächtigen Wanderfalken zu ehren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1273, 52, 1, N'Suzuki')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1274, 52, 2, N'hat mit der Über-Sportlerin')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1275, 52, 3, N'Hayabusa')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1276, 52, 4, N'(dt. Wanderfalke) einst die Motorradwelt aufgescheucht. Kein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1277, 52, 5, N'Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1278, 52, 6, N'war bis zum Stapellauf der legendären Maschine so kraftvoll aufgetreten. Kaum ein anderes brachte krasse Fahrleistungen und Komfort so zusammen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1279, 52, 7, N'Und das tut sie bis heute! Die ''Busa getaufte Maschine wird nun 25 Jahre alt. Grund genug für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1280, 52, 8, N'Suzuki')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1281, 52, 9, N', das vergangene Vierteljahrhundert mit diesem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1282, 52, 10, N'Sondermodell')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1283, 52, 11, N'mit speziellen optischen Features zu ehren, von dem bei uns in Deutschland nur 50 Exemplare auf den Markt kommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1284, 52, 12, N'Batterie-Ladegeräte für Motorräder
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Zum Angebot












                                                                                    CTEK  CT5 Powersport                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    GYS Gysflash                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Bosch  C3                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Dino 12V/5A Kraftpaket 12V/5A                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Optimate  4                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    APA  Mikroprozessor 6V/12V 5A                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    AEG  LD 5.0                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    hi-Q TOOLS  Ladegerät 900                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    SHIDO  DC3                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    EUFAB  EAL 6V/12V                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Einhell  CC-BC 6 M                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1285, 52, 13, N'ZoomDie Geburtstags-Hayabusa lockt mit einigen interessanten optischen Highlights wie u.a. ihrer Farbe.  Bild: SUZUKI Deutschland GmbH')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1286, 52, 14, N'Die Geburtstags-Hayabusa lockt mit einigen interessanten optischen Highlights wie u.a. ihrer Farbe.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1287, 52, 15, N'Das 2024er Sondermodell basiert laut Suzuki auf der Technik der aktuellen Generation der Maschine. Das bedeutet, dass ihr')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1288, 52, 16, N'Reihenvierzylinder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1289, 52, 17, N'1340 Kubikzentimeter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1290, 52, 18, N'Hubraum')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1291, 52, 19, N'hat. Er soll ebenso mit seiner Leistung wie mit seiner feinen Charakteristik überzeugen. Die Maschine hat 190 PS und entwickelt 150 Nm maximales Drehmoment. Alle erhältlichen Helferlein stehen dem Fahrer zur Seite.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1292, 52, 20, N'"25th Anniversary Edition" steht sowohl auf dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1293, 52, 21, N'Tank')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1294, 52, 22, N'als auch perlgestrahlt auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1295, 52, 23, N'Endschalldämpfern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1296, 52, 24, N'. Auf dem Kettenschutz ist das Hayabusa-Kanji-Logo zu sehen. Die Innenringe der Bremsscheiben und der Kettenspanner haben goldene Eloxaloberflächen. Dazu kommt eine serienmäßig in der Fahrzeugfarbe lackierte Abdeckung für den Soziussitz. Zwei Farben werden zu Auswahl stehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1297, 52, 25, N'50 Exemplare der Sonder-Hayabusa kommen in Deutschland auf den Markt. Die Preise beginnen bei 19.000 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1298, 52, 26, N'ZoomWie schnell ist der Wanderfalke wirklich? AUTO BILD-Redakteur Jan Horn hat es 2021 getestet. Bild: Christoph Börries')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1299, 52, 27, N'Wie schnell ist der Wanderfalke wirklich? AUTO BILD-Redakteur Jan Horn hat es 2021 getestet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1300, 52, 28, N'Dass die Japanerin nix für Anfänger ist, weiß die AUTOBILD-Redaktion spätestens seit 2021. Da wollten wir wissen, wie schnell die Rakete wirklich ist. Anhaltspunkte: Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1301, 52, 29, N'Tacho')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1302, 52, 30, N'reicht bis 290 km/h und 135 km/h sind schon allein im ersten Gang möglich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1303, 52, 31, N'Jan Horn wagte den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1304, 52, 32, N'Test')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1305, 52, 33, N'und fuhr die damals aktuelle Maschine frühmorgens auf einer leeren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1306, 52, 34, N'Autobahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1307, 52, 35, N'aus. 301 km/h dokumentierte die Satellitenaufzeichnung am Ende des Höllenritts. Doch der erfahrene Testprofi war nicht in erster Linie deswegen beeindruckt. Die Lässigkeit der Japanerin beim Abrufen ihrer Leistung und ihre geradezu sanfte, reisetaugliche Seite hob er in seinem Fazit beinahe überdeutlich hervor.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1308, 52, 36, N'ZoomEin krasses Aggregat mit vielen Möglichkeiten: Diesen Swift macht ein Hayabusa-Motor zum wilden Biest. Bild: Christoph Boerries')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1309, 52, 37, N'Ein krasses Aggregat mit vielen Möglichkeiten: Diesen Swift macht ein Hayabusa-Motor zum wilden Biest.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1310, 52, 38, N'Jan Horn war es auch, der 2014 ein ganz wildes Gerät testete. Damals hatte Rallye-Profi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1311, 52, 39, N'Niki Schelle')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1312, 52, 40, N'(ja, der aus der Fernsehsendung "Grip") den Motor einer damaligen Suzuki Hayabusa in einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1313, 52, 41, N'Suzuki Swift Sport')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1314, 52, 42, N'eingepflanzt. Und als ob das noch nicht genug war, gab es sozusagen obendrauf noch einen fetten Turbolader und der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1315, 52, 43, N'Swift')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1316, 52, 44, N'musste seinen Vorderradantrieb abgeben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1317, 52, 45, N'PlayVideo: Suzuki Swift Sport HayabusaExtrem heißer Umbau')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1318, 52, 46, N'Das Ergebnis war ein einzigartiges')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1319, 52, 47, N'Experimentalfahrzeug')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1320, 52, 48, N', ein aberwitzig laut heulendes Schreckgespenst für die Rennstrecke. Und das sind nur zwei Highlights aus einem Vierteljahrhundert Geschichte der heißesten Suzuki von allen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1321, 53, 0, N'Bei eBay wird derzeit diese 90 PS starke Suzuki GS 1000 aus dem Jahr 1980 verkauft. Das Besondere: Die Maschine wurde im Stil des Arbeitsgeräts von Rennfahrer Wes Cooley gestaltet. Und Cooley fuhr für Yoshimura!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1322, 53, 1, N'Der Name Hideo "Pops" Yoshimura hat in der japanischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1323, 53, 2, N'Zweirad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1324, 53, 3, N'-Szene einen ähnlichen Klang wie der Name')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1325, 53, 4, N'Akira Nakai')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1326, 53, 5, N'unter Porsche-Fans. Yoshimura war Motorradtuner, Motorradbauer und Betreiber eines Rennstalls, um nur die wichtigsten Stationen seiner Karriere zu nennen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1327, 53, 6, N'Warum die einleitenden Worte? Weil bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1328, 53, 7, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1329, 53, 8, N'gerade diese')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1330, 53, 9, N'Suzuki')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1331, 53, 10, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1332, 53, 11, N'GS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1333, 53, 12, N'1000 aus dem Jahr 1980 zum Kauf angeboten wird. Und die Maschine sieht in ihrem klassischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1334, 53, 13, N'Cafe-Racer-Stil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1335, 53, 14, N'nicht nur irre cool aus. Der Besitzer hat offensichtlich eine Replik der Rennmaschine von Wes Cooley gebaut, inklusive der Startnummer 34. Wes Cooley war ein amerikanischer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1336, 53, 15, N'Superbike')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1337, 53, 16, N'-Rennfahrer, der für Yoshimura an den Start ging.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1338, 53, 17, N'ZoomDie angebotene Suzuki ist mit ihrem klassischen Cafe-Racer-Stil als allererstes mal ein Hingucker. Bild: AUTO BILD Montage

eBay/24111959')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1339, 53, 18, N'Die angebotene Suzuki ist mit ihrem klassischen Cafe-Racer-Stil als allererstes mal ein Hingucker.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1340, 53, 19, N'Die Beschreibung in der Anzeige berichtet, dass der Besitzer die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1341, 53, 20, N'Suzuki')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1342, 53, 21, N'wegen einem Umzug und dem damit offenbar einhergehenden Wechsel in eine kleinere')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1343, 53, 22, N'Garage')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1344, 53, 23, N'abgibt. Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1345, 53, 24, N'Kfz-Brief')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1346, 53, 25, N'der Maschine ist vorhanden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1347, 53, 26, N'Die Japanerin wurde umfassend umgebaut und in den vergangenen Jahren offenbar gelegentlich bei historischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1348, 53, 27, N'Rennsportveranstaltungen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1349, 53, 28, N'eingesetzt. Zum Umbau gehören unter anderem eine Racing-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1350, 53, 29, N'Kette')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1351, 53, 30, N', geänderte Kolben, stärkere Kupplungsfedern, eine scharfe Nockenwelle, offene Filter, eine neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1352, 53, 31, N'Batterie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1353, 53, 32, N'und eben ein Yoshimura-Auspuff.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1354, 53, 33, N'ZoomAuf dem Preisschild stehen 5900 Euro. Das ist überschaubar. Bild: AUTO BILD Montage

eBay/24111959')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1355, 53, 34, N'Auf dem Preisschild stehen 5900 Euro. Das ist überschaubar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1356, 53, 35, N'Der Rückbau für die Straße ist den Angaben zufolge problemlos möglich. Der Besitzer ist bereit, eine Jama-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1357, 53, 36, N'Auspuffanlage')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1358, 53, 37, N'mit eNummer für 700 Euro zum Fahrzeug dazu zu geben. Originale Teile wie Räder und die Schwinge würde der Besitzer ebenfalls dazu geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1359, 53, 38, N'Zum technischen Zustand schreibt der Verkäufer nur, dass die Suzuki top laufen soll. Preis: 5900 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1360, 53, 39, N'ZoomDie Straßenzulassung soll problemlos möglich sein. Ein Halter fürs Kennzeichen gibt es schon mal. Bild: AUTO BILD Montage

eBay/24111959')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1361, 53, 40, N'Die Straßenzulassung soll problemlos möglich sein. Ein Halter fürs Kennzeichen gibt es schon mal.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1362, 53, 41, N'Als die GS 1000 Ende der 70er Jahre auf den Markt kam, brauchte Suzuki dringend Erfolge. Die Konkurrenz von')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1363, 53, 42, N'Honda')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1364, 53, 43, N', Kawasaki und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1365, 53, 44, N'Yamaha')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1366, 53, 45, N'war groß und strotzte nur so vor Leistung. Die Suzuki GS 400 und die GS 750 verkauften sich gut, aber es fehlte ein Knüller.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1367, 53, 46, N'Also brachten die Japaner die GS 1000. Sie basierte auf der GS 750. Vergrößerte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1368, 53, 47, N'Brennräume')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1369, 53, 48, N'steigerten die Leistung auf 90 PS. Das versprach überaus sportliche Fahrleistungen. Das Fahrzeuggewicht stieg nicht, es lag weiterhin bei überschaubaren 233 Kilogramm.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1370, 53, 49, N'Damit die GS 1000 jenseits der 200 km/h nicht aus der Ruhe geriet, gab es ein verbessertes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1371, 53, 50, N'Fahrwerk')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1372, 53, 51, N'. Modern: Der Start erfolgte elektrisch.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1373, 53, 52, N'Die exzellente Abstimmung sorgte für einen für die Epoche erwähnenswerten Geradeauslauf und eine sehr erfreuliche Kurvenstabilität.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1374, 53, 53, N'Die eigentliche Stärke der GS 1000 lag (und liegt) Kennern zufolge aber in ihrer mustergültigen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1375, 53, 54, N'Zuverlässigkeit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1376, 53, 55, N'. Die Japanerin kann 100.000 Kilometer Laufleistung und mehr wegstecken, als wäre es das normalste von der Welt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1377, 54, 0, N'BMW Motorrad will mit dem CE 02 die Fahrzeugklasse des eParkourers erfunden haben – ein cooles Gefährt zwischen E-Roller und E-Motorrad. AUTO BILD fühlt sich an die legendäre Honda Dax erinnert!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1378, 54, 1, N'Wenn Hersteller mit einem neuen Produkt an den Markt gehen, dann sind sie gerne extra begeistert und füllen die Presseinformationen mit extra schönen Worten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1379, 54, 2, N'BMW Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1380, 54, 3, N'ist da nicht anders. Die Bayern wollen mit dem nagelneuen CE 02 nichts Geringeres als die Fahrzeugklasse des eParkourers erfunden haben – ein cooles Zweirad in der Mitte zwischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1381, 54, 4, N'E-Roller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1382, 54, 5, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1383, 54, 6, N'E-Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1384, 54, 7, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1385, 54, 8, N'AUTO BILD hat sich angesichts des zufälligen Aufeinandertreffens mit dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1386, 54, 9, N'Prototyp des CE 02')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1387, 54, 10, N'auf den Hamburger Motorrad Tagen 2023 gewünscht, dass')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1388, 54, 11, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1389, 54, 12, N'diese abgefahrene Kiste bitte bauen möge. Und nun ist es so weit: Erstkontakt mit dem Serienfahrzeug kurz vor der Premiere anlässlich der BMW Motorrad Days 2023 in Berlin!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1390, 54, 13, N'Nützliches für Motorradfahrer
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Zum Angebot












                                                                                    Neverland Motorrad-Abdeckung                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    O''Neal Motorradhelm                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Proanti Motorradhandschuhe                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Heyberry Motorradjacke                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    ShinySkulls Premium Motorrad- und Autoshampoo                                                                            






Zum Angebot bei Amazon











Zum Angebot bei Ebay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1391, 54, 14, N'BMW Motorrad darf sich gerne über die Wortschöpfung eParkourer freuen. AUTO BILD würde das neue Fahrzeug eher so zusammenfassen:')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1392, 54, 15, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1393, 54, 16, N'hat eine elektrische')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1394, 54, 17, N'Honda Dax')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1395, 54, 18, N'vor der elektrischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1396, 54, 19, N'Honda')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1397, 54, 20, N'Dax gebaut. Klar, der CE 02 ist größer als die legendäre Kult-Honda. Aber der erste Eindruck von der Handlichkeit und der Bedienbarkeit passt. Allein das könnte schon der Schlüssel für jede Menge Fahrspaß sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1398, 54, 21, N'ZoomBMW spricht von einer ganz neuen Fahrzeugklasse. AUTO BILD fühlt sich an die Honda Dax erinnert. Bild: BMW Motorrad/Markus Jahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1399, 54, 22, N'BMW spricht von einer ganz neuen Fahrzeugklasse. AUTO BILD fühlt sich an die Honda Dax erinnert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1400, 54, 23, N'Christian Ott ist der zuständige Produktmanager für den BMW CE 02. Ihm zufolge wollte BMW ein leichtes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1401, 54, 24, N'E-Zweirad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1402, 54, 25, N'auf die Räder stellen, das sich so intuitiv bedienen lässt, dass auch völlige Neueinsteiger ohne Probleme damit klarkommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1403, 54, 26, N'ZoomDie Sitzhöhe von 750 Millimetern ist echt überschaubar. Bild: BMW Motorrad/Markus Jahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1404, 54, 27, N'Die Sitzhöhe von 750 Millimetern ist echt überschaubar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1405, 54, 28, N'Das könnte gelungen sein, ersichtlich allein an der überschaubaren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1406, 54, 29, N'Sitzhöhe')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1407, 54, 30, N'von 750 Millimetern. Mit ihr sollten auch nicht so Großgewachsene keine Probleme haben. Es wird mehrere Versionen vom CE 02 geben. Die Grundausstattung und die umfangreichere Version namens "Highline" lassen sich äußerlich auf den ersten Blick auseinanderhalten. Der normale CE 02 kommt in Schwarz und Grau, "Highline" setzt farbige Akzente.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1408, 54, 31, N'ZoomSuper: Beide Versionen des CE 02 mit vier und elf kW Leistung sind für Autofahrer interessant. Bild: BMW Motorrad/Markus Jahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1409, 54, 32, N'Super: Beide Versionen des CE 02 mit vier und elf kW Leistung sind für Autofahrer interessant.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1410, 54, 33, N'Das Spannendste für Autofahrer am CE 02 dürfte aber etwas völlig anderes sein: BMW wird seinen eParkourer einmal mit vier kW (fünf PS) und einmal mit elf kW (15 PS) anbieten. Die schwächere Version fährt maximal 45 km/h schnell, ist für die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1411, 54, 34, N'Führerscheinklasse AM')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1412, 54, 35, N'geeignet und darf daher von Inhabern eines')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1413, 54, 36, N'Pkw-Führerscheins')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1414, 54, 37, N'ab 18 Jahren einfach so gefahren werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1415, 54, 38, N'Die 15 PS starke Version entspricht – zugespitzt ausgedrückt – einer 125er und ist A1-geeignet. Sie darf von Autofahrern bewegt werden, sobald sie etwa die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1416, 54, 39, N'B196-Erweiterung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1417, 54, 40, N'in der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1418, 54, 41, N'Fahrschule')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1419, 54, 42, N'erworben haben. Dieser BMW CE 02 fährt laut BMW bis zu 95 km/h schnell und soll mit voll geladenen Akkus 90 Kilometer weit kommen. Eine luftgekühlte, fremderregte Synchronmaschine sorgt für den passenden Vortrieb.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1420, 54, 43, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1421, 54, 44, N'Hinweis Nummer zwei auf die völlige Problemfreiheit des CE 02: Die top ausgestattete Variante mit elf kW wiegt 132 Kilogramm. Das ist für ein E-Zweirad auf dem aktuellen Stand der Technik echt gut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1422, 54, 45, N'ZoomDie Person hinter dem Lenker kann je nach Tagesform die vorderen oder die hinteren Fußrasten nutzen. Bild: BMW Motorrad/Markus Jahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1423, 54, 46, N'Die Person hinter dem Lenker kann je nach Tagesform die vorderen oder die hinteren Fußrasten nutzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1424, 54, 47, N'Ein 0,9-kW-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1425, 54, 48, N'Ladegerät')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1426, 54, 49, N'ist Serie. Mit ihm soll der CE 02 problemlos an der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1427, 54, 50, N'Haushaltssteckdose')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1428, 54, 51, N'aufgeladen werden können. Für die stärkere Variante wird es wahlweise ein Schnellladegerät mit 1,5 kW Leistung geben. Die 11-kW-Version braucht 312 Minuten mit 0,9 kW und 210 Minuten mit 1,5 kW, um die Akkus zu 100 Prozent aufzuladen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1429, 54, 52, N'Zwei Fahrmodi sind ab Werk immer an Bord. "Flow" soll der perfekte Begleiter für entspannten Stadtverkehr sein und "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1430, 54, 53, N'Surf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1431, 54, 54, N'" das dynamische Gegenstück für ambitioniertere Fahrten, zum Beispiel über Land. Als Sonderausstattung oder Inhalt des Ausstattungspakets "Highline" kann der potenzielle Kunde außerdem noch den Fahrmodus "Flash" bekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1432, 54, 55, N'Vorne hat der CE 02 eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1433, 54, 56, N'Teleskopgabel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1434, 54, 57, N', hinten eine Einarmschwinge mit direkt angelenktem, einstellbarem Federbein hinten. Vorne und hinten gibt es Scheibenbremsen, dazu ABS für die vordere Bremse. Dazu sind eine Stabilitätskontrolle und natürlich Rekuperation an Bord. Sehr lässig: Die Person hinter dem Lenker kann je nach Laune die vorderen oder die hinteren Fußrasten nutzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1435, 54, 58, N'ZoomDie stylishe, kleine "Windschutzscheibe" am Lenker gehört zum erhältlichen Zubehör. Bild: BMW Motorrad/Markus Jahn')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1436, 54, 59, N'Die stylishe, kleine "Windschutzscheibe" am Lenker gehört zum erhältlichen Zubehör.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1437, 54, 60, N'Das TFT-Display am Lenker ist hervorragend ablesbar. BMW hat es mit Absicht optisch so reduziert wie möglich aufgestellt. Mithilfe einer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1438, 54, 61, N'USB-C-Ladebuchse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1439, 54, 62, N'kann man an Bord des CE 02 sein Smartphone laden. In der Version "Highline" dient das Smartphone zudem als zusätzliches Display.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1440, 54, 63, N'BMW-typisch gibt es natürlich auch für den CE 02 Zubehör. Die Liste beginnt bei Taschen für die Gepäckaufbewahrung und endet bei Cockpitverkleidungen. Außerdem ist eine Diebstahlwarnanlage dabei.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1441, 54, 64, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1442, 54, 65, N'Die Preise lauten wie folgt: 7500 Euro für den BMW CE 02 mit vier kW und 8500 Euro für den mit elf kW. Die Highline-Ausstattung gibt es für beide Versionen. Beim kleinen CE 02 kostet Highline 680 Euro Aufpreis, beim großen CE 02 sind es 880 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1443, 55, 0, N'Bei eBay wird derzeit diese Yamaha TT 500 aus dem Jahr 1980 angeboten. Die Schwester der legendären Yamaha XT 500 sieht gut aus – und kostet nicht allzu viel. Ein lohnender Kauf? Inserats-Check!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1444, 55, 1, N'Achtung,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1445, 55, 2, N'Enduro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1446, 55, 3, N'-Kult! Wer die Geländemaschinen aus den Filmen von Bud Spencer und Terence Hill liebt, der sollte jetzt weiterlesen. Kinder der 70er- und 80er-Jahre mit einem Faible für Enduros und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1447, 55, 4, N'Motocross-Maschinen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1448, 55, 5, N'sind ebenfalls angesprochen. Warum?')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1449, 55, 6, N'Weil bei eBay diese')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1450, 55, 7, N'Yamaha')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1451, 55, 8, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1452, 55, 9, N'TT')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1453, 55, 10, N'500 aus dem Jahr 1980 zum Kauf angeboten wird. Die Japanerin ist eine Schwester der ebenso legendären wie inzwischen teuren Yamaha XT 500. Dieses Exemplar macht auf den ersten Blick einen guten Eindruck, und es soll nicht besonders viel kosten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1454, 55, 11, N'Doch der Reihe nach: Die Yamaha TT 500 ist die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1455, 55, 12, N'Geländesportversion')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1456, 55, 13, N'der XT 500. Diese hier befindet sich den Angaben zufolge in einem sehr guten, sofort fahrbereiten Zustand. Die TT 500 wurde von 1976 bis 1981 gebaut. Jedes Jahr hat Yamaha das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1457, 55, 14, N'Motorrad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1458, 55, 15, N'weiterentwickelt. Deshalb wurden die unterschiedlichen Baujahre in verschiedenen Farben lackiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1459, 55, 16, N'ZoomDie Yamaha TT 500 ist die Schwester der legendären Yamaha XT 500. 80er-Jahre-Filme lassen grüßen. Bild: AUTO BILD Montage

eBay.de/tourte_de')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1460, 55, 17, N'Die Yamaha TT 500 ist die Schwester der legendären Yamaha XT 500. 80er-Jahre-Filme lassen grüßen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1461, 55, 18, N'Alle belasteten Teile wie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1462, 55, 19, N'Gabel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1463, 55, 20, N', Federn und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1464, 55, 21, N'Schwinge')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1465, 55, 22, N'wurden ab Werk verstärkt ausgeliefert. Trotzdem wiegt die TT 500 nur 118 Kilogramm. Der 500 Kubikzentimeter große Einzylinder leistet 36 PS. Die Kombination aus beidem mache viel Spaß, schreibt der Verkäufer.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1466, 55, 23, N'ZoomDer Verkäufer schreibt, eine Vollabnahme und damit Zulassung der kultigen Enduro sei kein Problem.  Bild: AUTO BILD Montage

eBay.de/tourte_de')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1467, 55, 24, N'Der Verkäufer schreibt, eine Vollabnahme und damit Zulassung der kultigen Enduro sei kein Problem.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1468, 55, 25, N'Der Anbieter hat laut Beschreibung solche Motorräder gesammelt und besitzt noch weitere Exemplare. Alle seien original und hätten sogenannte "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1469, 55, 26, N'Matching Numbers')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1470, 55, 27, N'". Das angebotene Fahrzeug werde – wie vermutlich die anderen auch – trocken in einer Halle aufbewahrt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1471, 55, 28, N'Eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1472, 55, 29, N'Vollabnahme')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1473, 55, 30, N'und damit eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1474, 55, 31, N'Zulassung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1475, 55, 32, N'für den deutschen Straßenverkehr sollen problemlos möglich sein. Der Verkäufer beziffert die Kosten mit 100 Euro für die Abnahme und 50 bis 100 Euro für die Versicherung. Auf dem Preisschild stehen 5000 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1476, 55, 33, N'ZoomWer gar keine Erfahrung mit dem "Antreten" eines älteren Motorrads hat, sollte das vor dem Kauf ausprobieren. Bild: AUTO BILD Montage

eBay.de/tourte_de')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1477, 55, 34, N'Wer gar keine Erfahrung mit dem "Antreten" eines älteren Motorrads hat, sollte das vor dem Kauf ausprobieren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1478, 55, 35, N'Kenner lecken sich angesichts der Angaben über die Yamaha jetzt vielleicht schon die Finger. Nicht so erfahrenen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1479, 55, 36, N'Bikern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1480, 55, 37, N'sei ans Herz gelegt, sich vor dem Kauf über ein paar Dinge klar zu werden – Motorrad-Oldtimer fahren nämlich nicht unbedingt so wie aktuelle Maschinen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1481, 55, 38, N'Bei dieser Yamaha beginnen die Unterschiede schon beim "Antreten". Klar kann man den Fußhebel benutzen, um die Maschine täglich zum Leben zu erwecken. Man kann über Erfolg und Misserfolg sogar lustige Instagram-Videos drehen. Aber man muss üben, bis man den Dreh richtig raushat. Soll heißen: Wer den E-Starter rechts am Lenker gewöhnt ist, probiert das Ganze am besten erst mal aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1482, 55, 39, N'Die Prüfstandards für den Kauf von')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1483, 55, 40, N'Gebrauchtwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1484, 55, 41, N'kann man auch auf Motorrad-Oldtimer anwenden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1485, 55, 42, N'Hier gibt es die wichtigsten Tipps für die Besichtigung eines gebrauchten Motorrads')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1486, 55, 43, N'. Obendrauf kommen der Eindruck, den man vom Verkäufer bekommt, und die Vorgeschichte.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1487, 55, 44, N'Diese Historie darf man bei einem geländegängigen Fahrzeug gerne besonders genau prüfen. Denn Fahrten abseits des Asphalts belasten das Material.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1488, 56, 0, N'Bei eBay wird derzeit diese gut aussehende BMW F 800 GS angeboten. Der Verkäufer hat die 85 PS starke Maschine umfassend personalisiert. So steht sie den Angaben zufolge gut da. Und sie ist echt bezahlbar!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1489, 56, 1, N'Schon immer von einer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1490, 56, 2, N'BMW GS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1491, 56, 3, N'geträumt, aber bisher einfach nicht die Kohle gehabt, eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1492, 56, 4, N'R 1250 GS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1493, 56, 5, N'für mehr als 15.000 Euro Neupreis zu kaufen? Dann bitte jetzt hier weiterlesen! Denn bei eBay wird derzeit eine interessante')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1494, 56, 6, N'GS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1495, 56, 7, N'angeboten. Und zwar für einigermaßen kleines Geld.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1496, 56, 8, N'Es handelt sich um eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1497, 56, 9, N'BMW F 800 GS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1498, 56, 10, N', die vom Verkäufer offenbar nach seinem persönlichen Geschmack gestaltet wurde und jetzt wegen Zeitmangels wieder weg soll. Die Maschine macht einen guten ersten Eindruck, und auf dem Preisschild stehen 5100 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1499, 56, 11, N'Die technischen Einzelheiten sind knapp gehalten, 798 Kubikzentimeter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1500, 56, 12, N'Hubraum')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1501, 56, 13, N'und 63 kW Leistung werden aufgeführt, also 85 PS. Dazu kommt die Laufleistung: Die ist mit 97.815 Kilometern insgesamt nicht gerade klein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1502, 56, 14, N'ZoomDer Verkäufer hat seinen Angaben zufolge ein paar Sachen an der GS verändert, etwa den Kennzeichenhalter. Bild: AUTO BILD Montage

eBay.de/enrablub')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1503, 56, 15, N'Der Verkäufer hat seinen Angaben zufolge ein paar Sachen an der GS verändert, etwa den Kennzeichenhalter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1504, 56, 16, N'Der Verkäufer gibt an, er habe die Maschine eher zufällig erworben und inseriere sie nun wieder, weil er wegen familiärer Verpflichtungen nicht oft genug zum')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1505, 56, 17, N'Motorradfahren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1506, 56, 18, N'käme. Der zufällige Kauf erfolgte 2022. Da hatte der Vorbesitzer gerade einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1507, 56, 19, N'Service')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1508, 56, 20, N'machen lassen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1509, 56, 21, N'ZoomDas Windschild wurde besprüht. Wie gut diese Transformation gelungen ist, sollte der Interessent prüfen. Bild: AUTO BILD Montage

eBay.de/enrablub')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1510, 56, 22, N'Das Windschild wurde besprüht. Wie gut diese Transformation gelungen ist, sollte der Interessent prüfen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1511, 56, 23, N'Der Verkäufer hat an der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1512, 56, 24, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1513, 56, 25, N'ein paar Sachen verändert. Auf der Liste stehen unter anderem ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1514, 56, 26, N'AC-Schnitzer-Auspuff')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1515, 56, 27, N'für einen kernigeren Klang, schmale Handguards, kleine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1516, 56, 28, N'Spiegel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1517, 56, 29, N'im Carbon-Look, LED-Scheinwerfer und ein gekürzter Halter fürs Kennzeichen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1518, 56, 30, N'Sämtliche Karosserieteile wurden foliert und mit einem vom Verkäufer selbst entworfenen Design überklebt. Die Originalfarbe ist Orange.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1519, 56, 31, N'Das Zubehör an Bord der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1520, 56, 32, N'BMW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1521, 56, 33, N'umfasst unter anderem originale BMW-Alukoffer für links und rechts, ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1522, 56, 34, N'Garmin-Navi mit Ladestation')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1523, 56, 35, N', eine SP-Connect-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1524, 56, 36, N'Handyhalterung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1525, 56, 37, N'mit Dämpfungsring, eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1526, 56, 38, N'Ersatzfelge')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1527, 56, 39, N'fürs Vorderrad und mehrere Ersatzschläuche.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1528, 56, 40, N'ZoomUnter der weißen Folie mit dem selbst entworfenen Design des Verkäufers steckt die originale Farbe Orange. Bild: AUTO BILD Montage

eBay.de/enrablub')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1529, 56, 41, N'Unter der weißen Folie mit dem selbst entworfenen Design des Verkäufers steckt die originale Farbe Orange.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1530, 56, 42, N'Die BMW F 800 GS ist die kleine Schwester der legendären')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1531, 56, 43, N'Mutter aller Reiseenduros')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1532, 56, 44, N'BMW R 1250 GS. Sie wurde von 2008 bis 2018 im Motorradwerk Berlin-Spandau gebaut und setzt technisch auf der F-Reihe von BMW auf.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1533, 56, 45, N'Deshalb gibt es einige grundsätzliche technische Unterschiede zur großen GS: Es beginnt mit dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1534, 56, 46, N'Motor')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1535, 56, 47, N', einem Zweizylinder-Rotax-Reihenmotor anstelle des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1536, 56, 48, N'Boxers')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1537, 56, 49, N'. Das Aggregat ist ein mittragendes Element des Rahmens und hat zwei obenliegende')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1538, 56, 50, N'Nockenwellen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1539, 56, 51, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1540, 56, 52, N'Das Hinterrad wird anstelle via Kardan mithilfe einer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1541, 56, 53, N'Kette')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1542, 56, 54, N'angetrieben. Auch darin unterscheidet sich die kleine GS von der großen. Doch die Reaktion der Öffentlichkeit auf die F 800 GS war positiv. Nur die Sitzhöhe und das Gewicht bei vollem Tank wurden kritisiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1543, 56, 55, N'Über technische Schwachstellen wird kaum berichtet, auch nicht auf bzw. nach langen Reisen. Vielfahrer sind sich aber einig, dass die serienmäßige')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1544, 56, 56, N'Sitzbank')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1545, 56, 57, N'hätte bequemer ausfallen können. Auch wünschen sich manche eine Anzeige der Restreichweite.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1546, 56, 58, N'Notiz am Rande: Im Video oben gibt es anhand der großen Schwester BMW R 1250 GS einen Eindruck davon, wie viel Gelände die hochgelobten und seit Jahrzehnten viel gekauften Reiseenduros von BMW wirklich können.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1547, 57, 0, N'Bei eBay wird gerade eine schöne Simson S51 angeboten. Kenner sehen möglicherweise gleich, dass die Maschine zur Enduro umgebaut wurde. Das ist aber nicht alles: Es floss eine ganze Menge Geld in die Instandhaltung!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1548, 57, 1, N'Wer Nachhaltigkeit zu schätzen weiß und gerne stilvoll unterwegs ist, der sollte aktuell unbedingt mal bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1549, 57, 2, N'eBay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1550, 57, 3, N'reinschauen. Da wird nämlich diese Simson S51 zum Kauf angeboten. Die inserierte Maschine ist mit 2799 Euro nicht allzu teuer – und sie wurde zur Enduro umgebaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1551, 57, 4, N'Nachhaltigkeit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1552, 57, 5, N'ist ja gerade in aller Munde, doch die Idee der langfristigen Verwendbarkeit eines Produkts ist nicht neu. Gestalter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1553, 57, 6, N'Karl Clauss Dietel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1554, 57, 7, N'war schon Ende der 70er so clever, die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1555, 57, 8, N'Simson S51')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1556, 57, 9, N'so zu konzipieren, dass man alle Baugruppen einfach und unabhängig voneinander tauschen konnte. Ganz zu schweigen vom Reiz daran, dass viele Simson-Produkte bis heute 60 km/h schnell sein dürfen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1557, 57, 10, N'ZoomDie Simson macht auf den ersten Blick einen guten Eindruck. Sie hat in jüngerer Zeit viel Pflege bekommen. Bild: AUTO BILD Montage

eBay.de/reini-1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1558, 57, 11, N'Die Simson macht auf den ersten Blick einen guten Eindruck. Sie hat in jüngerer Zeit viel Pflege bekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1559, 57, 12, N'Warum diese einleitenden Worte? Weil bei eBay gerade diese')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1560, 57, 13, N'Simson S51')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1561, 57, 14, N'in Grün angeboten wird. Es handelt sich den Angaben zufolge um einen Enduro-Umbau. Das bedeutet, dass die Maschine vermutlich keine rare,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1562, 57, 15, N'originale Enduro-Version der S51')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1563, 57, 16, N'ist. Doch das sollte höchstens Simson-Museen und ähnliche Sammlungen vom Kauf abhalten. Spaß haben kann man mit der Simson nämlich auch so.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1564, 57, 17, N'ZoomEs handelt sich bei dieser S51 um einen Enduro-Umbau. Das ändert nichts daran, dass die Maschine Spaß macht. Bild: AUTO BILD Montage

eBay.de/reini-1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1565, 57, 18, N'Es handelt sich bei dieser S51 um einen Enduro-Umbau. Das ändert nichts daran, dass die Maschine Spaß macht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1566, 57, 19, N'Das eigentliche Highlight an der Maschine versteckt sich in den Hinweisen des Verkäufers. Dort wird aufgeführt, wie viel Arbeit und Geld in den vergangenen Jahren in die Maschine geflossen sind. Unter anderem gab es zum Beispiel eine komplett erneuerte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1567, 57, 20, N'Elektronik')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1568, 57, 21, N'und einen neuen Antriebsstrang. Materialkosten über vier Jahre: 1200 Euro. Trotzdem muss der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1569, 57, 22, N'Termin vor Ort')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1570, 57, 23, N'zeigen, wie gut die S51 ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1571, 57, 24, N'Wer das Hobby DDR-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1572, 57, 25, N'Zweirad')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1573, 57, 26, N'für sich entdecken will, der muss sich keine Sorgen machen: Die Fahrzeugindustrie der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1574, 57, 27, N'DDR')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1575, 57, 28, N'und den Hersteller Simson gibt es zwar nicht mehr, doch die Enthusiasten-Szene ist groß.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1576, 57, 29, N'Spezialwerkstätten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1577, 57, 30, N'gibt es überall, Clubs und Freizeitschrauber sowieso. Das Internet ist voll von Seiten, die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1578, 57, 31, N'Ersatzteile')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1579, 57, 32, N'für die verschiedenen Simson-Modelle anbieten, teilweise sogar original aus der DDR.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1580, 57, 33, N'ZoomWer sich eine S51 genau ansieht, der erkennt die konzeptionelle Weitsicht von Gestalter Karl Clauss Dietel. Bild: picture alliance')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1581, 57, 34, N'Wer sich eine S51 genau ansieht, der erkennt die konzeptionelle Weitsicht von Gestalter Karl Clauss Dietel.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1582, 57, 35, N'Klar,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1583, 57, 36, N'Schrauber')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1584, 57, 37, N', die schon mal einen Motor überholt haben, sind im Vorteil. Wer sich im Detail mit der Materie auseinandersetzt, erst recht. Doch auch Einsteiger finden ihren Weg in die Welt der Suhler Kult-Zweiräder, im Zweifelsfall eben mit Unterstützung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1585, 57, 38, N'Es gibt nur einen Wermutstropfen: Die Zeiten, in denen man eine Simson gegen ein paar Kästen Bier eintauschen konnte, sind lange vorbei. Heutzutage muss man für ein gutes Exemplar mehrere Tausend Euro anlegen. Und am besten einen abschließbaren Stellplatz haben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1586, 58, 0, N'Irmscher hebt den brandneuen Opel Astra Sports Tourer optisch aufs nächste Tuning-Level. AUTO BILD verrät, was der Sport-Look kostet!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1587, 58, 1, N'Kaum ist der neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1588, 58, 2, N'Opel Astra')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1589, 58, 3, N'Sports Tourer bei den Händlern angekommen, knöpft sich Tuning-Urgestein Irmscher den Kombi vor! Leistungstechnisch gibt es keine Veränderungen, dafür wertet Irmscher – in Zusammenarbeit mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1590, 58, 4, N'Opel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1591, 58, 5, N'– die Optik des Astra Sports Tourer auf.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1592, 58, 6, N'AUTO-ABO
            







                        Der Opel Crossland X und weitere Modelle flexibel im Abo
                    

                        Profitieren Sie von kurzen Lieferzeiten, der Möglichkeit zu pausieren und zahlreichen Modellen im Sixt+ Auto-Abo.
                    




zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1593, 58, 7, N'Die Karosserieanbauteile lassen sich einzeln bestellen: Neben der bereits bekannten Frontspoilerlippe (419 Euro) und den Seitenschwellern (599 Euro), werden in Kürze die Kombi-spezifische Heckschürzenverbreiterung (319 Euro) und der neue Dachkantenspoiler (338 Euro) bestellbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1594, 58, 8, N'Alternativ bietet Irmscher ab Werk auch Komplettpakete für den Astra-Kombi an. Es gibt drei Stufen: Den Einstieg macht das Paket "is1" für 1500 Euro. Darin enthalten ist ein reduziertes Karosseriekit.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1595, 58, 9, N'ZoomDer Astra Sports Tourer wirkt durch die Irmscher-Anbauteile deutlich stämmiger.  Bild: Facebook/Irmscher')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1596, 58, 10, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1597, 58, 11, N'Der Astra Sports Tourer wirkt durch die Irmscher-Anbauteile deutlich stämmiger.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1598, 58, 12, N'Für 3500 Euro verbaut Irmscher das komplette Karosseriepaket "is2". Die Endstufe bildet das Tuningpaket "is3", das neben allen Karosserieteilen auch einen Fahrwerk-Umbau und 19-Zoll-Räder beinhaltet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1599, 59, 0, N'Bei der Nutzung von Elektroautos und Plug-in-Hybriden als Firmenwagen locken steuerliche Vorteile. Für viele Dienstwagen gilt die 0,25-Prozent- oder Viertel-Regelung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1600, 59, 1, N'Wer seinen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1601, 59, 2, N'Firmenwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1602, 59, 3, N'auch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1603, 59, 4, N'privat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1604, 59, 5, N'fährt, muss in der Steuererklärung einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1605, 59, 6, N'geldwerten Vorteil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1606, 59, 7, N'angeben und die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1607, 59, 8, N'Nutzung versteuern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1608, 59, 9, N'. Fahrer von Elektroautos und Plug-in-Hybriden sind da im Vorteil. Anfang 2019 wurde dieser Betrag bereits für Elektro-Firmenwagen verringert und inzwischen sogar erneut auf die sogenannte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1609, 59, 10, N'Viertel-Regelung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1610, 59, 11, N'halbiert. Neben der erhöhten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1611, 59, 12, N'Elektro-Kaufprämie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1612, 59, 13, N'sowie der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1613, 59, 14, N'Bezuschussung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1614, 59, 15, N'von heimischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1615, 59, 16, N'Wallboxen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1616, 59, 17, N'sind dies weitere Maßnahmen der Regierung, um die Nachfrage nach E-Autos anzukurbeln.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1617, 59, 18, N'Anstatt von einem Prozent des Brutto-Listenpreises wie bei Autos mit Benzin- oder Dieselmotor, müssen Arbeitnehmer seit 2020')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1618, 59, 19, N'für bis zu 60.000 Euro teure Firmenwagen nur noch 0,25 Prozent steuerlich geltend')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1619, 59, 20, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1620, 59, 21, N'machen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1621, 59, 22, N'. Auch die Zuschläge (z.B. für den Arbeitsweg) wurden halbiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1622, 59, 23, N'Plug-in-Hybrid-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1623, 59, 24, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1624, 59, 25, N'Brennstoffzellen-Fahrzeuge')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1625, 59, 26, N'sowie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1626, 59, 27, N'teurere Dienst-Stromer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1627, 59, 28, N'fallen unter die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1628, 59, 29, N'0,5-Prozent-Regelung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1629, 59, 30, N'. Die steuerliche Begünstigung gilt für E-Autos, die ab dem 1. Januar 2019 erstmals als Firmenwagen genutzt wurden, sie läuft noch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1630, 59, 31, N'bis zum 31. Dezember 2030')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1631, 59, 32, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1632, 59, 33, N'So funktioniert ein Elektroauto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1633, 59, 34, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1634, 59, 35, N'Die reduzierte Besteuerung funktioniert wie die zuvor für alle privat genutzten Firmenwagen übliche 1-Prozent-Regelung. Für die Berechnung wird der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1635, 59, 36, N'Brutto-Listenpreis des Neufahrzeugs herangezogen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1636, 59, 37, N'– auch wenn das Auto zu einem günstigeren Preis oder als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1637, 59, 38, N'Gebrauchtwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1638, 59, 39, N'erworben wurde. Wer sich beispielsweise für einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1639, 59, 40, N'BMW i3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1640, 59, 41, N'(120Ah, 170')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1641, 59, 42, N'PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1642, 59, 43, N', ca. 300 km')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1643, 59, 44, N'Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1644, 59, 45, N') als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1645, 59, 46, N'Dienstwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1646, 59, 47, N'entscheidet, müsste für die Berechnung die UVP von 39.000 Euro zugrunde legen. Ein Viertelprozent davon müssten monatlich als geldwerter Vorteil für die private Nutzung angegeben werden. 97,50 Euro würden also auf das zu versteuernde Einkommen aufgeschlagen. Bei einem durchschnittlichen Steuersatz von 40 Prozent kostet der BMW i3 als Firmenwagen dann 468 Euro Steuern pro Jahr.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1647, 59, 48, N'Wird der elektrische Firmenwagen an mehr als 47 Tagen im Jahr auch für den Arbeitsweg genutzt, muss dieser zusätzlich versteuert werden – auch hier gibt es vom Gesetzgeber eine Begünstigung für Elektroautos und Hybrid-Autos.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1648, 59, 49, N'Anstelle der üblichen 0,03 Prozent werden bei E-Fahrzeugen nur noch 0,0075 Prozent des Listenpreises pro Kilometer der einfachen Fahrtstrecke fällig')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1649, 59, 50, N'. Das macht beim BMW i3 also 2,92 Euro pro Kilometer. Bei einem 20 Kilometer langen Weg zur Arbeit müssten also zusätzlich 58,40 Euro monatlich versteuert werden – macht im zuvor genannten Beispiel insgesamt 700,80 Euro Steuern im Jahr. Die Alternative zur 0,25-Prozent-Regelung ist wie auch bei der 1-Prozent-Regelung das Fahrtenbuch (weitere Infos zur')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1650, 59, 51, N'1-Prozent-Regelung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1651, 59, 52, N').')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1652, 59, 53, N'So schleppt man ein E-Auto ab')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1653, 59, 54, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1654, 59, 55, N'Hybridautos, die nach der 0,5-Prozent-Regelung versteuert werden, müssen einige Voraussetzungen erfüllen. Eine davon ist die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1655, 59, 56, N'externe Aufladung (Plug-in-Hybrid)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1656, 59, 57, N'. Mildhybride fallen also aus der Regelung raus. Außerdem müssen Nutzer der 0,5-Prozent-Regelung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1657, 59, 58, N'mindestens eines')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1658, 59, 59, N'der zwei folgenden Kriterien erfüllen: Ihr Plug-in-Firmenwagen darf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1659, 59, 60, N'nicht mehr als 50 Gramm CO2 pro Kilometer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1660, 59, 61, N'ausstoßen,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1661, 59, 62, N'oder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1662, 59, 63, N'die rein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1663, 59, 64, N'elektrische Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1664, 59, 65, N'muss bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1665, 59, 66, N'mindestens 40 Kilometern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1666, 59, 67, N'liegen (ab 2022: 60 Kilometer; ab 2025: 80 Kilometer). Sind die Bedingungen nicht erfüllt, fällt der Dienstwagen unter die ansonsten übliche 1-Prozent-Regelung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1667, 59, 68, N'BildergalerieKameraFirmenwagen-Award 2020: Das sind die Sieger!20 BilderPfeil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1668, 59, 69, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1669, 59, 70, N'In dieser Bildergalerie zeigen wir alle Gewinner des Firmenwagen-Awards 2020, unterteilt in Kategorien. In jeder Kategorie gibt es zwei Gewinner: einen deutschen Sieger und einen Import-Sieger.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1670, 59, 71, N'Viel Spaß beim Durchklicken!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1671, 59, 72, N'Deutscher Sieger Kleinwagen: Audi A1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1672, 59, 73, N'Premium kommt an bei unseren Lesern. Kantiger und aggressiver als sein Vorgänger, fährt sich der A1 in die Herzen der Leser. Für den kleinsten Audi schon der zweite Sieg 2020. Auch bei den "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1673, 59, 74, N'Besten Marken aller Klassen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1674, 59, 75, N'" gewann der Audi bei den Kleinen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1675, 59, 76, N'Import-Sieger Kleinwagen: Skoda Fabia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1676, 59, 77, N'Anfang des kommenden Jahres will Skoda die vierte Fabia-Generation präsentieren. Quasi als Abschiedsgeschenk kürten unsere Leser den kleinen Tschechen zum Kleinwagen-Sieger bei den Importen. Für den Fabia bereits der dritte Erfolg in Serie.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1677, 59, 78, N'Deutscher Sieger Kompaktklasse: Mercedes A-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1678, 59, 79, N'Mit der 2018 eingeführten A-Klasse hat Mercedes neue Standards gesetzt. Der stylische Kompakte mit Hightech-Features aus der Oberklasse liegt in der Leser-Gunst vorne. Kein Wunder, kommt das aktuelle Modell doch weit dynamischer daher als der staksige Urahn.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1679, 59, 80, N'Import-Sieger Kompaktklasse: Skoda Octavia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1680, 59, 81, N'Auch in dieser Klasse stellt VW-Tochter Skoda den Gewinner bei den Importeuren. Die vierte Octavia-Generation kommt ob seiner flachen Dachlinie fast coupéartig daher. In Sachen Motor haben Fahrer aktuell die Wahl zwischen allen verfügbaren Antriebsarten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1681, 59, 82, N'Deutscher Sieger Mittelklasse: BMW 3er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1682, 59, 83, N'Seit Jahren ist der 3er das BMW-Topmodell im Dienstwagen-Zulassungsranking. Das deckt sich mit dem Votum unserer Leser: Klassensieg in der Mittelklasse. Die neueste Generation bietet dynamisches Design bei optimierter Funktionalität. Das wird honoriert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1683, 59, 84, N'Import-Sieger Mittelklasse: Skoda Superb')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1684, 59, 85, N'Seit 2015 ist der Superb das Skoda-Flaggschiff und macht dem Passat den Platz streitig. Eigenständiges, aggressives Design kennzeichen das 2019er-Facelift. Zudem punktet der aktuelle Superb mit moderner Technik, reichlich Komfort und einem großen Platzangebot.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1685, 59, 86, N'Deutscher Sieger Obere Mittelklasse: Audi A6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1686, 59, 87, N'Eine frische Optik und viel Hightech aus der Luxuslimousine A8 – so schickt Audi die fünfte Generation des A6 ins Rennen um die Krone in dieser Klasse. Und das erfolgreich, meinen jedenfalls unsere Leser.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1687, 59, 88, N'Import-Sieger Obere Mittelklasse: Volvo V90/S90')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1688, 59, 89, N'Stilsicher bis in die letzte Fuge – so punktet der Schwede offenbar auch bei den Lesern. Die meisten Stimmen unter den Import-Autos der oberen Mittelklasse entfielen auf den Volvo. Auch innen top. Das Platzangebot ist fast schon unverschämt gut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1689, 59, 90, N'Deutscher Sieger Luxusklasse: Mercedes S-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1690, 59, 91, N'Seit der Einführung 1972 ist die S-Klasse so was wie der Inbegriff einer Luxuslimousine. Mercedes nennt sie gar "das beste Auto der Welt". Es mag luxuriösere Autos geben, aber die S-Klasse steht wie kaum ein anderes Modell für Wohlfühlcharakter und modernste Technik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1691, 59, 92, N'Import-Sieger Luxusklasse: Tesla Model S')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1692, 59, 93, N'Hat die E-Mobilität in Deutschland doch eine Chance, die Massen zu begeistern? Offenbar ja, denn der Import-Sieger in der Luxusklasse heißt Tesla. Für den Amerikaner gilt: Spitzentechnik zum Spitzenpreis. Das Model S bietet immerhin 650 km Reichweite.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1693, 59, 94, N'Deutscher Sieger SUV: Mercedes GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1694, 59, 95, N'2015 erschien der GLC als Nachfolger des kantigen GLK. Das Mittelklasse-SUV strahlt Präsenz aus, ohne sich aufzudrängen. Komfort und Technik sind auf C-Klassen-Niveau. Kein Wunder, dass der große Schwabe in der Lesergunst ganz vorne landet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1695, 59, 96, N'Import-Sieger SUV: Skoda Kodiaq')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1696, 59, 97, N'Schiere Größe, durchdachte Funktionalität, moderne VW-Technik zu einem Skoda-typischen Preisleistungsverhältnis. Damit sorgt der Kodiaq im umkämpften SUV-Markt für Furore. Und punktet bei unseren Lesern: klarer Sieg im Import-Ranking dieser Klasse.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1697, 59, 98, N'Deutscher Sieger Elektroautos: Audi e-tron')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1698, 59, 99, N'Der e-tron ist das erste vollelektrische Modell der Marke. Mit 4,90 m Länge und 1,94 m Breite macht der Audi mächtig Eindruck. Eine Reichweite von bis zu 440 Kilometern soll der sportliche SUV in der Basis schaffen. Unsere Leser machen ihn zum Gewinner unter den E-Autos.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1699, 59, 100, N'Import-Sieger Elektroautos: Tesla Model 3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1700, 59, 101, N'Als erstes massentaugliches Elektroauto ist das Model 3 so etwas wie der Pionier moderner E-Mobilität. Und mit bis zu 580 km auch in Sachen Reichweite top! Das honorieren die Leser mit den meisten Stimmen bei den importierten E-Autos.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1701, 59, 102, N'Deutscher Sieger Plug-in-Hybride: Audi A6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1702, 59, 103, N'Mit gewohnt feiner Verarbeitung fährt der Audi A6 in der Mischmotorversion auf Platz eins der Lesergunst. Daran ändert auch der Einstiegspreis jenseits der 50.000 Euro nichts. Beim Hybriden verkleinert die über der Hinterachse platzierte Batterie das Ladevolumen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1703, 59, 104, N'Import-Sieger Plug-in-Hybride: Skoda Superb iV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1704, 59, 105, N'Auch mit Akku bleibt sich der Superb treu, ist Raumwunder und Alltagsheld in einem. Das Marken-Flaggschiff ist als erster Skoda seit Anfang des Jahres als Plug-in erhältlich und hat sich als Importsieger der Klasse direkt in die Leser-Herzen gefahren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1705, 59, 106, N'Deutscher Sieger Transporter: Volkswagen T6.1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1706, 59, 107, N'Mit dem Facelift bekam der Klassendauersieger einen breiteren Kühlergrill, flachere Scheinwerfer mit aktueller VW-Leuchtsignatur, das neue Infotainmentsystem MIB3 und einen überarbeiteten TDI-Motor. An der Beliebtheit des Bulli hat das offenbar gar nichts geändert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1707, 59, 108, N'Import-Sieger Transporter: Toyota Proace')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1708, 59, 109, N'Am Gesicht des Proace erkennt man eindeutig den Toyota, dabei teilt sich der Kastenwagen die Plattform mit Citroën Berlingo und Opel Combo. Egal ob Langversion oder Doppelkabine, der Proace ist ein echtes Lastentier und holt sich den Sieg in der Import-Kategorie.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1709, 59, 110, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1710, 59, 111, N'Sieger Leasing: Sixt Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1711, 59, 112, N'Seit 50 Jahren zählt die Sixt Leasing SE zu den führenden Leasinganbietern in Deutschland. Optimale Mobilität zu geringen Kosten hat sich der Konzern auf die Fahnen geschrieben. Das kommt offenbar auch bei den Lesern an: Platz eins im Leasing-Vergleich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1712, 59, 113, N'Die besten Firmenwagen 2020: Hier geht''s zum Artikel!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1713, 59, 114, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1714, 60, 0, N'AUTO BILD sucht wieder die besten Firmenwagen des Jahres und fragt die Leser nach ihren Favoriten. Stimmen Sie jetzt ab, und gewinnen Sie einen Satz Bridgestone-Winterreifen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1715, 60, 1, N'Firmenwagen halten Deutschland am Laufen – vom nützlichen Alltagshelfer bis zum Statussymbol. Und sie zählen noch immer zu den begehrten Nebenleistungen, die sich Angestellte vom Arbeitgeber wünschen. Von Januar bis Juli 2021 wurden rund 1,6 Millionen Autos in Deutschland neu zugelassen, 66,9 Prozent davon wurden auf gewerbliche Halter angemeldet – das entspricht mehr als einer Million Dienstwagen. Neben zahlreichen Kleinwagen, die auf Liefer- und Pflegedienste zugelassen sind, dominieren den Markt Modelle aus der Kompakt- und Mittelklasse, also klassische Vertreterautos. Interessant: Umweltfreundliche Fahrzeuge wie Elektroautos und Plug-in-Hybride nehmen immer mehr Fahrt in den Firmenwagenflotten auf. Gründe dafür sind der großzügige Umweltbonus und Steuervorteile.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1716, 60, 2, N'AUTO BILD vergibt 2021 bereits zum vierten Mal den Firmenwagen-Award. Und Sie, liebe Leser, wählen wieder die Sieger! Die zur Wahl stehenden Fahrzeuge bilden den deutschen Firmenwagenmarkt ab und zeigen die Vielfalt an Modellen. In sieben Klassen sind jeweils die fünf am häufigsten zugelassenen Modelle deutscher Autobauer und die fünf Zulassungskönige der Importeure nominiert (KBA-Statistik 1–7/2021, gewerbliche Halter). Außerdem stehen diesmal fünf Auto-Abo-Start-ups zur Wahl. Das neuartige Geschäftsmodell ist zu einer echten Leasing-Alternative geworden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1717, 60, 3, N'Abonnement, klar, wer denkt da nicht zuerst an Zeitungen oder Magazine? Doch zunehmend werden auch TV- und Musikangebote zu einer festen Monatsrate im Abo bezogen. Und Autos. Immer mehr Arbeitgeber schätzen es, ihren Mitarbeitern einen Firmenwagen im Abo anzubieten, statt auf das übliche Leasing zu setzen. Die Vorteile liegen auf der Hand. Abo-Autos werden zu einer monatlichen Flatrate abgerechnet. Wer ein Abo-Auto fährt, muss sich weder um Versicherungen und Steuern noch um Inspektionskosten kümmern. Die Laufzeiten sind in der Regel kürzer als bei Leasingverträgen. Dienstwagenberechtigte haben so die Möglichkeit, Modelle schneller zu wechseln. Ganz wichtig: Das Restwertrisiko entfällt. Drohen am Ende des Leasingvertrags oft hohe Abzüge bei der vereinbarten Rücknahmesumme, weil bei der Begutachtung Beulen und Schrammen festgestellt werden, gehen Abo-Autos meist ohne Zusatzzahlungen zurück an den Anbieter. Nur die Mehrkilometer sollten Nutzer von Abo-Autos im Auge behalten. Wird nämlich die vereinbarte Laufleistung überschritten, werden zusätzlich gefahrene Kilometer von der Abo-Firma gesondert in Rechnung gestellt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1718, 60, 4, N'ZoomStimmen Sie für Ihre Favoriten ab, und gewinnen Sie einen von fünf Reifensätzen von Bridgestone.  Bild: HerstellerDas Beste: Auch Sie können gewinnen! Unter allen Teilnehmern verlosen wir fünf Winterreifen-Sätze von Bridgestone. Sicher unterwegs in der kalten Jahreszeit, das verspricht der Winterreifen Blizzak LM005 von Bridgestone. Ob auf trockener oder verschneiter Fahrbahn – der in Tests vielfach ausgezeichnete Reifen überzeugt mit seiner Performance, dazu mit Bestnoten auf nasser Strecke. Für Grip sorgt die von Bridgestone hergestellte NanoPro-Tech-Mischung. Der hohe Silica-Anteil und das Profildesign garantieren gleichmäßige Leistung und Tophaftung. Sie möchten sich für den Winter rüsten? Dann stimmen Sie für Ihre Favoriten ab! Mit etwas Glück gewinnen Sie einen von fünf Reifensätzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1719, 60, 5, N'Stimmen Sie für Ihre Favoriten ab, und gewinnen Sie einen von fünf Reifensätzen von Bridgestone.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1720, 60, 6, N'In jeder Kategorie kann nur für ein Fahrzeug gestimmt werden. Mitmachen lohnt sich: Als Preis können Sie einen von fünf Sätzen Winterreifen von Bridgestone gewinnen! Teilnahmeschluss ist der 19. September 2021, 24 Uhr.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1721, 60, 7, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1722, 60, 8, N'Es gelten die Teilnahmebedingungen für Gewinnspiele auf autobild.de. Der Rechtsweg und die Barauszahlung sind ausgeschlossen. Mitarbeiter der Axel Springer SE, ihrer Tochtergesellschaften und der beteiligten Unternehmen dürfen nicht teilnehmen. Teilnahme ab 18 Jahren und mit Wohnsitz in Deutschland möglich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1723, 60, 9, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1724, 61, 0, N'Den Audi A3 Sportback gibt es als Plug-in-Hybrid momentan für 89 Euro pro Monat. Das Angebot gilt allerdings nur für Gewerbekunden!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1725, 61, 1, N'Seit 2020 ist die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1726, 61, 2, N'aktuelle Generation des Audi A3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1727, 61, 3, N'auf dem Markt. Die Ingolstädter bieten ihren Kompakten als Sportback oder Limousine an und haben ein richtig gutes Auto auf die Räder gestellt. Im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1728, 61, 4, N'AUTO BILD-Vergleichstest')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1729, 61, 5, N'musste sich der A3 im Kompaktsegment nur gegen den Konzernbruder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1730, 61, 6, N'VW Golf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1731, 61, 7, N'geschlagen geben, was letztendlich auf den höheren Preis zurückzuführen ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1732, 61, 8, N'BMW 1er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1733, 61, 9, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1734, 61, 10, N'Mercedes A-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1735, 61, 11, N'ließ der A3 hinter sich. Für den A3 spricht außerdem das große Motoren-Portfolio, das sogar')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1736, 61, 12, N'zwei Plug-in-Hybridvarianten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1737, 61, 13, N'beinhaltet. Zur Wahl stehen der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1738, 61, 14, N'Audi A3 40 TFSI e mit 204 PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1739, 61, 15, N'Systemleistung und der größere')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1740, 61, 16, N'45 TFSI e mit 245 PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1741, 61, 17, N'. Die Preise für den kleineren Plug-in-Hybrid starten bei 38.440 Euro. Doch im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1742, 61, 18, N'Leasing gibt es den stylishen A3 richtig günstig!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1743, 61, 19, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) bekommen Gewerbekunden den oben erwähnten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1744, 61, 20, N'Audi A3 Sportback 40 TFSI e')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1745, 61, 21, N'im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1746, 61, 22, N'Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1747, 61, 23, N'für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1748, 61, 24, N'sehr günstige 89 Euro netto pro Monat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1749, 61, 25, N'. Zwar wird eine einmalige')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1750, 61, 26, N'Sonderzahlung in Höhe von 4500 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1751, 61, 27, N'fällig, die durch den Leasingnehmer als Vorleistung erbracht werden muss – doch bei korrekter und fristgerechter Beantragung der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1752, 61, 28, N'Umweltprämie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1753, 61, 29, N'beim Bundesamt für Wirtschaft und Ausfuhrkontrolle (BAFA) wird diese Summe voll erstattet. Voraussetzung für die Auszahlung des Förderbetrags ist eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1754, 61, 30, N'Mindestvertragslaufzeit von 24 Monaten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1755, 61, 31, N', die im Fall des Audi A3 Sportback erfüllt wird. Die Freikilometer sind mit 10.000 km jährlich angegeben. Wer mehr fahren möchte, der sollte sich vor Vertragsabschluss mit dem Leasinggeber in Verbindung setzen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1756, 61, 32, N'(Unterhaltskosten berechnen? Zum Kfz-Versicherungsvergleich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1757, 61, 33, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1758, 61, 34, N'Neben der monatlichen Rate von 89 Euro netto kommen einmalig noch die Abholkosten obendrauf. Hierbei haben die Kunden die Wahl zwischen einer Werksabholung für 659 Euro brutto (554 Euro netto) oder der Übernahme beim Händler für 899 Euro brutto (755 Euro netto). Im günstigsten Fall liegen die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1759, 61, 35, N'Gesamtleasingkosten für zwei Jahre somit bei 2690 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1760, 61, 36, N'(89 Euro x 24 plus 554 Euro). Dafür bekommen die Kunden den A3 Plug-in-Hybrid, der laut')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1761, 61, 37, N'Audi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1762, 61, 38, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1763, 61, 39, N'bis zu 78 Kilometer rein elektrisch fahren soll.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1764, 61, 40, N'Das sind rund 20 Kilometer mehr, als der 2011 vorgestellte Vorgänger schaffte. Beim neuen A3 kombinieren die Ingolstädter einen 150 PS starken 1,4-Liter-Benziner mit einem Elektromotor. Die Systemleistung des A3 40 TFSI e liegt bei 204 PS und 330 Nm Drehmoment. Das reicht für 227 km/h Topspeed, wobei rein elektrisch maximal 140 km/h möglich sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1765, 61, 41, N'Da es sich beim angebotenen Audi A3 Sportback in der Farbe "Brillantschwarz" um ein frei konfigurierbares Bestellfahrzeug handelt, ist die Ausstattung gegen Aufpreis anpassbar. Zur Serienausstattung gehören unter anderem: Lederlenkrad, Klimaanlage, MMI Radio plus, Bluetooth-Schnittstelle und das Isofix-System für die Befestigung von')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1766, 61, 42, N'Kindersitzen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1767, 61, 43, N'. Die Lieferzeit ist mit etwa vier Monaten angegeben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1768, 61, 44, N'Aufgrund einer hohen Nachfrage kann das Angebot laut sparneuwagen.de kurzfristig nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1769, 61, 45, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1770, 61, 46, N'Weitere Themen: E-Bike-Fahrradträger im Vergleich')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1771, 62, 0, N'Die Umweltprämie macht''s möglich: Der Renault Zoe kostet im Leasing nur 37,90 Euro netto pro Monat. Günstiger lässt sich ein Elektroauto kaum fahren!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1772, 62, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1773, 62, 2, N'Renault Zoe war 2020 das meistverkaufte Elektroauto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1774, 62, 3, N'in Deutschland. Das hat mehrere Gründe: Neben zuverlässiger Technik und überschaubaren Lieferzeiten punktet der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1775, 62, 4, N'Zoe')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1776, 62, 5, N'vor allem mit vergleichsweise günstigen Preisen. Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1777, 62, 6, N'Basisversion Zoe Life R110')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1778, 62, 7, N'Z.E. 40 gibt es')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1779, 62, 8, N'ab 29.990 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1780, 62, 9, N'– und das vor')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1781, 62, 10, N'Abzug irgendwelcher Prämien')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1782, 62, 11, N'. Doch im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1783, 62, 12, N'Leasing gibt es das kleine Elektroauto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1784, 62, 13, N'jetzt richtig günstig!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1785, 62, 14, N'Mitte 2019 hat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1786, 62, 15, N'Renault')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1787, 62, 16, N'den neuen Zoe präsentiert, wobei man eher von einem gründlichen Facelift sprechen kann. Optisch hat sich wenig getan, doch im Innenraum haben die Franzosen dem Zoe ein neues Cockpit und mehr Features spendiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1788, 62, 17, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) haben')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1789, 62, 18, N'Gewerbekunden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1790, 62, 19, N'die Möglichkeit, einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1791, 62, 20, N'Renault Zoe Experience R110 Z.E. 50 zum absoluten Schnäppchenpreis')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1792, 62, 21, N'zu')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1793, 62, 22, N'leasen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1794, 62, 23, N'. Mit einer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1795, 62, 24, N'monatlichen Rate von nur 37,90 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1796, 62, 25, N'kostet das Elektroauto nicht viel mehr als die meisten Handyverträge. Natürlich ist das nur die halbe Wahrheit, denn der Leasingnehmer muss mit einer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1797, 62, 26, N'Sonderzahlung in Höhe von 6100 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1798, 62, 27, N'in Vorleistung gehen. Diese wird bei korrekter und fristgerechter Beantragung der Umweltprämie beim Bundesamt für Wirtschaft und Ausfuhrkontrolle jedoch voll erstattet. Voraussetzung hierfür ist eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1799, 62, 28, N'Mindestvertragslaufzeit von 24 Monaten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1800, 62, 29, N', die beim Zoe-Angebot erfüllt wird. Auf Wunsch kann der Renault auch für 36 Monate geleast werden, dann verdoppelt sich die monatliche Rate allerdings fast auf 72,50 Euro netto.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1801, 62, 30, N'(Unterhaltskosten berechnen? Zum Kfz-Versicherungsvergleich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1802, 62, 31, N'Obendrauf kommen einmalig die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1803, 62, 32, N'Bereitstellungskosten von 799 Euro brutto (671 Euro netto)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1804, 62, 33, N', die deutschlandweite Lieferung des kleinen Elektroautos ist bereits mit drin. Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1805, 62, 34, N'Freikilometer sind mit 10.000 km pro Jahr')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1806, 62, 35, N'angegeben, was für die Innenstadt durchaus reichen sollte. Wer mehr fährt, der kann die Kilometer in 5000er-Schritten auf bis zu 25.000 km jährlich anheben, landet dann aber auch bei einer monatlichen Rate von 120,12 Euro netto. Beim angebotenen Zoe handelt es sich um die gehobene Ausstattungslinie Experience. Der Elektromotor leistet 80 kW (109 PS), was laut Renault für eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1807, 62, 36, N'Reichweite von 395 Kilometern')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1808, 62, 37, N'reichen soll. Im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1809, 62, 38, N'AUTO BILD-Einzeltest konnte der stärkere Zoe R135')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1810, 62, 39, N', für den ebenfalls eine Reichweite von 395 Kilometern angegeben wird, bei niedrigen Außentemperaturen immerhin alltagstaugliche 240 Kilometer erreichen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1811, 62, 40, N'Zusätzlich zur Serienausstattung verfügt der vorkonfigurierte Zoe über das "Visio-Paket" inklusive Einparkhilfe vorne und hinten, Rückfahrkamera und LED-Nebelscheinwerfern sowie das Winterpaket mit beheizbarem Lederlenkrad und Sitzheizung. So ausgestattet liegt der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1812, 62, 41, N'Bruttolistenpreis des Zoe mit Batteriekauf bei 35.690 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1813, 62, 42, N', ohne Abzug der Prämien. Wie günstig das Leasingangebot ist, zeigt der Vergleich: Auf zwei Jahre gerechnet liegen die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1814, 62, 43, N'reinen Leasingkosten bei 1581 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1815, 62, 44, N'(37,90 Euro x 24 plus 671 Euro). Viel günstiger geht es nicht. Der Liefertermin wird mit Juni 2021 angegeben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1816, 62, 45, N'Aufgrund einer hohen Nachfrage kann das Angebot laut sparneuwagen.de kurzfristig nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1817, 62, 46, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1818, 63, 0, N'Im Leasing bekommen Gewerbekunden den VW Multivan ohne Anzahlung für 259 Euro netto pro Monat. Die Überführungskosten sind allerdings hoch!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1819, 63, 1, N'Ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1820, 63, 2, N'SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1821, 63, 3, N'oder ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1822, 63, 4, N'Kombi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1823, 63, 5, N'bieten einfach nicht genug Platz? Dann ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1824, 63, 6, N'VW Multivan')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1825, 63, 7, N'das richtige Auto! Die Generation T6.1 bieten die Wolfsburger inzwischen in')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1826, 63, 8, N'fünf Ausstattungsvarianten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1827, 63, 9, N'an, vom preiswerten T6.1 "Family" bis hin zum top ausgestatteten T6.1 "Highline".')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1828, 63, 10, N'Während das Topmodell über 67.000 Euro kostet, gibt es die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1829, 63, 11, N'Basisversion "Family"')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1830, 63, 12, N'als 2.0 TDI mit 150 PS und Sechsgang-Handschaltung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1831, 63, 13, N'ab 41.531 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1832, 63, 14, N'. Doch im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1833, 63, 15, N'Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1834, 63, 16, N'wird der Multivan um einiges günstiger!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1835, 63, 17, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) können')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1836, 63, 18, N'Gewerbekunden den VW Multivan T6.1 "Family"')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1837, 63, 19, N'mit drei Meter Radstand für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1838, 63, 20, N'259 Euro netto pro Monat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1839, 63, 21, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1840, 63, 22, N'ohne Anzahlung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1841, 63, 23, N'leasen. Das entspricht einem Leasingfaktor von guten 0,74. Obendrauf kommen die einmaligen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1842, 63, 24, N'Bereitstellungs- und Zulassungskosten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1843, 63, 25, N', die bei diesem Angebot mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1844, 63, 26, N'1334 Euro brutto (1121 Euro netto)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1845, 63, 27, N'allerdings mehr als happig ausfallen. Normal liegen diese eher bei 600 bis 900 Euro brutto. Die Laufzeit ist mit 48 Monaten angegeben, sodass sich auf vier Jahre')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1846, 63, 28, N'Gesamtleasingkosten in Höhe von 13.553 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1847, 63, 29, N'(259 Euro x 48 plus 1121 Euro) ergeben. Noch nicht enthalten sind hier Folgekosten wie Versicherung,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1848, 63, 30, N'Kfz-Steuer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1849, 63, 31, N'und Wartung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1850, 63, 32, N'(Unterhaltskosten berechnen? Zum Kfz-Versicherungsvergleich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1851, 63, 33, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1852, 63, 34, N'Das Angebot beinhaltet')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1853, 63, 35, N'10.000 Freikilometer pro Jahr')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1854, 63, 36, N'. Wer mehr fahren möchte, der sollte vor Vertragsabschluss ein größeres Kilometerpaket gegen Aufpreis anfragen. In der Basisausstattung "Family" wird der Multivan von einem Zweiliter-Diesel mit 150 PS angetrieben, der seine Kraft über eine Sechsgang-Handschaltung abgibt. Die Serienausstattung umfasst unter anderem: 70-Liter-Tank, Schiebetür auf der Beifahrerseite, 16-Zoll-Stahlfelgen mit Radkappen, Campingtisch, Komfortsitze vorne, mehrere 12-Volt-Steckdosen, Klimaanlage, Radio "Composition Colour" mit Touchscreen und Zentralverriegelung. Da es sich um einen Neuwagen mit rund zwei Monaten Lieferzeit handelt, ist nicht nur die Farbe "Ascotgrau", sondern auch die Ausstattung gegen Aufpreis individuell konfigurierbar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1855, 63, 37, N'Aufgrund einer hohen Nachfrage kann das Angebot laut sparneuwagen.de kurzfristig nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1856, 63, 38, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1857, 64, 0, N'Im Leasing gibt es einen gut ausgestatteten VW Touareg mit Dreiliter-Diesel und R-Line für günstige 309 Euro pro Monat. Das Angebot gilt aber nur für Gewerbekunden!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1858, 64, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1859, 64, 2, N'VW Touareg')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1860, 64, 3, N'hat keinen leichten Stand bei den Kunden! Seit 2018 ist die dritte Generation des Oberklasse-SUVs auf dem Markt und duelliert sich mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1861, 64, 4, N'BMW X5')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1862, 64, 5, N',')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1863, 64, 6, N'Mercedes GLE')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1864, 64, 7, N',')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1865, 64, 8, N'Porsche Cayenne')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1866, 64, 9, N'und Co. Nachdem der große V8-Diesel im Touareg gestrichen wurde, umfasst die Motorenpalette noch einen Sechszylinder-Benziner mit 340 PS, sowie zwei Dreiliter-Diesel mit wahlweise 231 oder 286 PS. Erst im Spätsommer 2020 wurde der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1867, 64, 10, N'Touareg R als Plug-in-Hybrid mit 462 PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1868, 64, 11, N'eingeführt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1869, 64, 12, N'Während das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1870, 64, 13, N'Topmodell mindestens 86.500 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1871, 64, 14, N'kostet, gibt es den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1872, 64, 15, N'Touareg in der Basisausstattung ab 61.460 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1873, 64, 16, N'. Damit ist der Touareg nicht teurer als die Konkurrenz, doch einige Kunden scheuen sich, so viel Geld für einen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1874, 64, 17, N'VW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1875, 64, 18, N'auszugeben. Wie gut, dass es das')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1876, 64, 19, N'große SUV im Leasing viel günstiger gibt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1877, 64, 20, N'!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1878, 64, 21, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) können Gewerbekunden den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1879, 64, 22, N'VW Touareg als 286 PS starken Diesel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1880, 64, 23, N'aktuell für vergleichsweise')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1881, 64, 24, N'günstige 309 Euro netto pro Monat leasen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1882, 64, 25, N'. Noch interessanter wird das Angebot dadurch, dass')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1883, 64, 26, N'keine Anzahlung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1884, 64, 27, N'nötig ist. Einzig die Überführungskosten von 1199 Euro brutto (1008 Euro netto) kommen als einmalige Kosten dazu. Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1885, 64, 28, N'Laufzeit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1886, 64, 29, N'ist mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1887, 64, 30, N'36 Monate')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1888, 64, 31, N'angegeben, kann auf Wunsch jedoch auf 48 Monate ausgeweitet werden und die Freikilometer sind mit den bei Leasingangeboten typischen 10.000 angegeben. Vielfahrer können jedoch bis zu 30.000 Kilometer jährlich mit dem Touareg zurücklegen, dann erhöht sich die monatliche Rate jedoch auf 473 Euro netto. Alternativ wird der Mehrkilometer mit 9,6 Cent berechnet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1889, 64, 32, N'(Unterhaltskosten berechnen? Zum Kfz-Versicherungsvergleich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1890, 64, 33, N'Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1891, 64, 34, N'Gesamtleasingkosten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1892, 64, 35, N'auf drei Jahre liegen somit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1893, 64, 36, N'bei 12.132 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1894, 64, 37, N'(309 Euro x 24 plus 1008 Euro). Dafür gibt es einen über 80.000 Euro teuren')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1895, 64, 38, N'VW Touareg')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1896, 64, 39, N'3.0 TDI mit R-Line und folgenden Ausstattungshighlights: Fahrerassistenzpaket Plus, elektrische Heckklappe, LED-Matrix-Scheinwerfer, 19-Zoll-Felgen, beheizbares Lenkrad, elektrische einstellbare Sitze, DAB+, Einparkhilfe,')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1897, 64, 40, N'Navi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1898, 64, 41, N'"Discover Pro" und mehr. Ab Werk wird der Touareg in der Farbe "Pure White" ausgeliefert, eine Metallic-Farbe nach Wunsch kostet zehn Euro extra pro Monat. Da es sich bei dem angebotenen Touareg um einen Neuwagen mit drei bis vier Monaten Lieferzeit handelt, ist die Konfiguration gegen Aufpreis änderbar. Wichtig: Das Angebot ist nur bis zum 30. März 20.21 verfügbar.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1899, 64, 42, N'Aufgrund einer hohen Nachfrage kann das Angebot laut sparneuwagen.de kurzfristig nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1900, 64, 43, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1901, 65, 0, N'Das Elektro-SUV Skoda Enyaq gibt es im Leasing für günstige 199 Euro pro Monat – inklusive Versicherung und Service. Das Angebot gilt auch für Privatkunden!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1902, 65, 1, N'AUTO BILD-Modellseite
            







                        Alles zum Skoda Enyaq
                    

                        Hier finden Sie alle Informationen zum aktuellen Skoda Enyaq: Preise, Design, Ausstattungen, Antriebe, Fahrberichte, Tests, Vergleichstests und Kaufberatungen.
                    




Skoda Enyaq')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1903, 65, 2, N'Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1904, 65, 3, N'Umweltprämie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1905, 65, 4, N'macht es möglich: Schon seit einigen Monaten gibt es immer wieder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1906, 65, 5, N'günstige Leasingdeals für Elektroautos und Plug-in-Hybride')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1907, 65, 6, N'. Nachdem erst kürzlich der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1908, 65, 7, N'VW ID.4 zum Schnäppchenpreis von 100 Euro netto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1909, 65, 8, N'zu haben war, folgt jetzt das nächste')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1910, 65, 9, N'Top-Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1911, 65, 10, N'– diesmal auch für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1912, 65, 11, N'Privatkunden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1913, 65, 12, N'!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1914, 65, 13, N'Bei sparneuwagen.de (Kooperationspartner von AUTO BILD) ist aktuell der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1915, 65, 14, N'Skoda Enyaq iV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1916, 65, 15, N'im Angebot. Inzwischen bietet Skoda sein erstes Elektro-SUV in drei unterschiedlichen Varianten an: Die Einstiegsversion ist der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1917, 65, 16, N'Enyaq')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1918, 65, 17, N'iV 50 mit 55-kWh-Batterie und 109 kW (148 PS) Leistung, darüber rangieren der Enyaq iV 60 mit 62-kWh-Batterie und 132 kW (180 PS) sowie das Topmodell Enyaq iV 80 mit 82-kWh-Batterie und 150 kW (204 PS) Leistung. Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1919, 65, 18, N'Basispreis des Enyaq')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1920, 65, 19, N'ohne Abzug der staatlichen Förderungen liegt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1921, 65, 20, N'bei 33.800 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1922, 65, 21, N'. Im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1923, 65, 22, N'Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1924, 65, 23, N'ist das 4,65 Meter lange Elektro-SUV richtig günstig:')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1925, 65, 24, N'Privatkunden zahlen für den Enyaq iV 50 lediglich 199 Euro brutto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1926, 65, 25, N'. Zwar wird eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1927, 65, 26, N'einmalige Sonderzahlung in Höhe von 6000 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1928, 65, 27, N'fällig, die der Leasingnehmer als Vorleistung erbringen muss – jedoch werden die 6000 Euro bei korrekter und fristgerechter Beantragung der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1929, 65, 28, N'Umweltprämie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1930, 65, 29, N'beim Bundesamt für Wirtschaft und Ausfuhrkontrolle (BAFA) erstattet. Einzige Voraussetzung für die volle Rückerstattung ist eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1931, 65, 30, N'Mindestvertragslaufzeit von 24 Monaten')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1932, 65, 31, N', die beim Enyaq-Deal erfüllt ist. Die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1933, 65, 32, N'Freikilometer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1934, 65, 33, N'sind mit')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1935, 65, 34, N'10.000 km pro Jahr')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1936, 65, 35, N'angegeben, können gegen Aufpreis jedoch auf bis zu 20.000 angehoben werden – dann kostet der Enyaq 262 Euro brutto pro Monat.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1937, 65, 36, N'(Unterhaltskosten berechnen? Zum Kfz-Versicherungsvergleich)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1938, 65, 37, N'Hinzu kommen noch einmalige')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1939, 65, 38, N'Bereitstellungskosten in Höhe von 990 Euro brutto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1940, 65, 39, N'. Somit liegen die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1941, 65, 40, N'Gesamtleasingkosten für zwei Jahre bei 5766 Euro brutto')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1942, 65, 41, N'(199 Euro x 24 plus 990 Euro). Positiv hervorzuheben ist, dass bei diesem Angebot bereits Wartungs- und Servicekosten sowie eine Vollkaskoversicherung (ohne')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1943, 65, 42, N'Haftpflicht')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1944, 65, 43, N') in der Rate mitenthalten sind. Zudem handelt es sich um ein frei konfigurierbares Bestellfahrzeug mit rund sechs Monaten Lieferzeit. Ab Werk wird der Skoda Enyaq in der auffälligen Unilackierung "Energy-Blau" ausgeliefert. Zur Serienausstattung gehören Tempomat, Zweizonen-Klimaautomatik, Spurhalteassistent, 18-Zoll-Stahlfelgen, Lederlenkrad, LED-Scheinwerfer, DAB+ sowie SmartLink inklusive Apple Carplay und Android Auto.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1945, 65, 44, N'Aufgrund einer hohen Nachfrage kann das Angebot laut sparneuwagen.de kurzfristig nicht mehr verfügbar sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1946, 65, 45, N'Eine Übersicht mit allen interessanten Leasing-Deals gibt es hier!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1947, 66, 0, N'Unsere Leser haben abgestimmt. Hier kommen die Gewinner des AUTO BILD-Firmenwagen-Award 2020!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1948, 66, 1, N'Man sieht es Ihnen nicht unbedingt an, aber die meisten Kfz auf unseren Straßen fahren dort nicht rum, weil Autofahren so viel Spaß bringt. Sie sind im Dienst. Bei einigen besonders populären Modellen macht die Anzahl der gewerblich zugelassenen Fahrzeuge gar nahezu 90 Prozent aus. Dazu passt, dass nach der Statistik des Kraftfahrtbundesamtes rund 62 Prozent aller neu zugelassenen Kraftfahrzeuge 2020 sogenannte Dienstwagen, also betrieblich genutzte Fahrzeuge, sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1949, 66, 2, N'ZoomSicherte sich gleich zweimal den Spitzenplatz: Der Audi A6, hier als Plug-in-Hybrid. Bild: HerstellerDie Einsatzgebiete sind dabei so vielfältig wie die dafür zur Verfügung stehenden Autos. Wer seine Pizza oder Pasta heiß an den Mann bringen muss, ist meist ebenso in einem Kleinwagen unterwegs wie die vielen hilfreichen Geister im mobilen Pflegeeinsatz. Eine Nummer größer wird es bei den vielen Außendienstlern, die so richtig Kilometer schrubben müssen. Auch in der Kompaktklasse ist die Auswahl groß, zumal viele Firmen sich vom früher beliebten Mono-Marken-Flottensystem abgewandt haben und ihren Mitarbeitern bei der Wahl "ihres" Dienstwagens freie Hand lassen. Klar, schließlich spielt beim Wettbewerb um gute Fachkräfte auch das Thema Auto eine große Rolle. "Warum soll ich meinen Kollegen zwingen, die Marke X zu fahren, wenn er doch Fan der Marke Y ist", bringt es ein Fuhrparkchef auf den Punkt. Laune und damit Leistungsbereitschaft könnten sinken, die Gefahr, dass sich der Mitarbeiter nach beruflichen Alternativen mit passendem Dienstwagen umsieht, dagegen steigen. In der hochpreisigen Luxusklasse finden sich dann sicher überwiegend Arbeitsschaffende aus der Abteilung Nadelstreifenanzug.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1950, 66, 3, N'Sicherte sich gleich zweimal den Spitzenplatz: Der Audi A6, hier als Plug-in-Hybrid.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1951, 66, 4, N'Aber egal, welche Klasse oder welches Auto, sie sind alle absolut dienstbereit. Doch welcher ist denn nun der beste Dienstwagen? Bereits zum dritten Mal stellten wir die Frage unseren Lesern. In zehn Kategorien – neun Fahrzeugklassen und eine für Dienstleister – haben Sie entschieden. Das sind die Sieger des Firmenwagen-Award von Europas größter Autozeitung, Ihrer AUTO BILD. Hier geht''s zur Bildergalerie!BildergalerieKameraFirmenwagen-Award 2020: Das sind die Sieger!20 BilderPfeil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1952, 66, 5, N'In dieser Bildergalerie zeigen wir alle Gewinner des Firmenwagen-Awards 2020, unterteilt in Kategorien. In jeder Kategorie gibt es zwei Gewinner: einen deutschen Sieger und einen Import-Sieger.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1953, 66, 6, N'Viel Spaß beim Durchklicken!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1954, 66, 7, N'Deutscher Sieger Kleinwagen: Audi A1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1955, 66, 8, N'Premium kommt an bei unseren Lesern. Kantiger und aggressiver als sein Vorgänger, fährt sich der A1 in die Herzen der Leser. Für den kleinsten Audi schon der zweite Sieg 2020. Auch bei den "')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1956, 66, 9, N'Besten Marken aller Klassen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1957, 66, 10, N'" gewann der Audi bei den Kleinen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1958, 66, 11, N'Import-Sieger Kleinwagen: Skoda Fabia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1959, 66, 12, N'Anfang des kommenden Jahres will Skoda die vierte Fabia-Generation präsentieren. Quasi als Abschiedsgeschenk kürten unsere Leser den kleinen Tschechen zum Kleinwagen-Sieger bei den Importen. Für den Fabia bereits der dritte Erfolg in Serie.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1960, 66, 13, N'Deutscher Sieger Kompaktklasse: Mercedes A-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1961, 66, 14, N'Mit der 2018 eingeführten A-Klasse hat Mercedes neue Standards gesetzt. Der stylische Kompakte mit Hightech-Features aus der Oberklasse liegt in der Leser-Gunst vorne. Kein Wunder, kommt das aktuelle Modell doch weit dynamischer daher als der staksige Urahn.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1962, 66, 15, N'Import-Sieger Kompaktklasse: Skoda Octavia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1963, 66, 16, N'Auch in dieser Klasse stellt VW-Tochter Skoda den Gewinner bei den Importeuren. Die vierte Octavia-Generation kommt ob seiner flachen Dachlinie fast coupéartig daher. In Sachen Motor haben Fahrer aktuell die Wahl zwischen allen verfügbaren Antriebsarten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1964, 66, 17, N'Deutscher Sieger Mittelklasse: BMW 3er')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1965, 66, 18, N'Seit Jahren ist der 3er das BMW-Topmodell im Dienstwagen-Zulassungsranking. Das deckt sich mit dem Votum unserer Leser: Klassensieg in der Mittelklasse. Die neueste Generation bietet dynamisches Design bei optimierter Funktionalität. Das wird honoriert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1966, 66, 19, N'Import-Sieger Mittelklasse: Skoda Superb')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1967, 66, 20, N'Seit 2015 ist der Superb das Skoda-Flaggschiff und macht dem Passat den Platz streitig. Eigenständiges, aggressives Design kennzeichen das 2019er-Facelift. Zudem punktet der aktuelle Superb mit moderner Technik, reichlich Komfort und einem großen Platzangebot.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1968, 66, 21, N'Deutscher Sieger Obere Mittelklasse: Audi A6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1969, 66, 22, N'Eine frische Optik und viel Hightech aus der Luxuslimousine A8 – so schickt Audi die fünfte Generation des A6 ins Rennen um die Krone in dieser Klasse. Und das erfolgreich, meinen jedenfalls unsere Leser.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1970, 66, 23, N'Import-Sieger Obere Mittelklasse: Volvo V90/S90')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1971, 66, 24, N'Stilsicher bis in die letzte Fuge – so punktet der Schwede offenbar auch bei den Lesern. Die meisten Stimmen unter den Import-Autos der oberen Mittelklasse entfielen auf den Volvo. Auch innen top. Das Platzangebot ist fast schon unverschämt gut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1972, 66, 25, N'Deutscher Sieger Luxusklasse: Mercedes S-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1973, 66, 26, N'Seit der Einführung 1972 ist die S-Klasse so was wie der Inbegriff einer Luxuslimousine. Mercedes nennt sie gar "das beste Auto der Welt". Es mag luxuriösere Autos geben, aber die S-Klasse steht wie kaum ein anderes Modell für Wohlfühlcharakter und modernste Technik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1974, 66, 27, N'Import-Sieger Luxusklasse: Tesla Model S')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1975, 66, 28, N'Hat die E-Mobilität in Deutschland doch eine Chance, die Massen zu begeistern? Offenbar ja, denn der Import-Sieger in der Luxusklasse heißt Tesla. Für den Amerikaner gilt: Spitzentechnik zum Spitzenpreis. Das Model S bietet immerhin 650 km Reichweite.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1976, 66, 29, N'Deutscher Sieger SUV: Mercedes GLC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1977, 66, 30, N'2015 erschien der GLC als Nachfolger des kantigen GLK. Das Mittelklasse-SUV strahlt Präsenz aus, ohne sich aufzudrängen. Komfort und Technik sind auf C-Klassen-Niveau. Kein Wunder, dass der große Schwabe in der Lesergunst ganz vorne landet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1978, 66, 31, N'Import-Sieger SUV: Skoda Kodiaq')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1979, 66, 32, N'Schiere Größe, durchdachte Funktionalität, moderne VW-Technik zu einem Skoda-typischen Preisleistungsverhältnis. Damit sorgt der Kodiaq im umkämpften SUV-Markt für Furore. Und punktet bei unseren Lesern: klarer Sieg im Import-Ranking dieser Klasse.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1980, 66, 33, N'Deutscher Sieger Elektroautos: Audi e-tron')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1981, 66, 34, N'Der e-tron ist das erste vollelektrische Modell der Marke. Mit 4,90 m Länge und 1,94 m Breite macht der Audi mächtig Eindruck. Eine Reichweite von bis zu 440 Kilometern soll der sportliche SUV in der Basis schaffen. Unsere Leser machen ihn zum Gewinner unter den E-Autos.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1982, 66, 35, N'Import-Sieger Elektroautos: Tesla Model 3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1983, 66, 36, N'Als erstes massentaugliches Elektroauto ist das Model 3 so etwas wie der Pionier moderner E-Mobilität. Und mit bis zu 580 km auch in Sachen Reichweite top! Das honorieren die Leser mit den meisten Stimmen bei den importierten E-Autos.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1984, 66, 37, N'Deutscher Sieger Plug-in-Hybride: Audi A6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1985, 66, 38, N'Mit gewohnt feiner Verarbeitung fährt der Audi A6 in der Mischmotorversion auf Platz eins der Lesergunst. Daran ändert auch der Einstiegspreis jenseits der 50.000 Euro nichts. Beim Hybriden verkleinert die über der Hinterachse platzierte Batterie das Ladevolumen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1986, 66, 39, N'Import-Sieger Plug-in-Hybride: Skoda Superb iV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1987, 66, 40, N'Auch mit Akku bleibt sich der Superb treu, ist Raumwunder und Alltagsheld in einem. Das Marken-Flaggschiff ist als erster Skoda seit Anfang des Jahres als Plug-in erhältlich und hat sich als Importsieger der Klasse direkt in die Leser-Herzen gefahren.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1988, 66, 41, N'Deutscher Sieger Transporter: Volkswagen T6.1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1989, 66, 42, N'Mit dem Facelift bekam der Klassendauersieger einen breiteren Kühlergrill, flachere Scheinwerfer mit aktueller VW-Leuchtsignatur, das neue Infotainmentsystem MIB3 und einen überarbeiteten TDI-Motor. An der Beliebtheit des Bulli hat das offenbar gar nichts geändert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1990, 66, 43, N'Import-Sieger Transporter: Toyota Proace')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1991, 66, 44, N'Am Gesicht des Proace erkennt man eindeutig den Toyota, dabei teilt sich der Kastenwagen die Plattform mit Citroën Berlingo und Opel Combo. Egal ob Langversion oder Doppelkabine, der Proace ist ein echtes Lastentier und holt sich den Sieg in der Import-Kategorie.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1992, 66, 45, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1993, 66, 46, N'Sieger Leasing: Sixt Leasing')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1994, 66, 47, N'Seit 50 Jahren zählt die Sixt Leasing SE zu den führenden Leasinganbietern in Deutschland. Optimale Mobilität zu geringen Kosten hat sich der Konzern auf die Fahnen geschrieben. Das kommt offenbar auch bei den Lesern an: Platz eins im Leasing-Vergleich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1995, 66, 48, N'Die besten Firmenwagen 2020: Hier geht''s zum Artikel!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1996, 66, 49, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1997, 67, 0, N'Der Vorgänger des aktuellen Opel Corsa ist aktuell noch mit wenigen Kilometern auf der Uhr zu fairen Preisen zu bekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1998, 67, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (1999, 67, 2, N'Opel Corsa')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2000, 67, 3, N'ist vor allem hierzulande einer der beliebtesten Kleinwagen. Das erste Modell, der Corsa A, wurde zwischen 1982 und 1993 angeboten. Inzwischen ist mit dem Corsa F die insgesamt sechste Generation im Verkauf, die zudem gerade ein Facelift und damit das moderne Opel-Markengesicht erhalten hat.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2001, 67, 4, N'Wer mit dem neuesten Kleinwagen mit Opel-Logo nicht viel anfangen kann, sollte unbedingt einen Blick auf den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2002, 67, 5, N'Gebrauchtwagenmarkt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2003, 67, 6, N'werfen. Denn dort ist der Vorgänger, der Corsa E, derzeit gerade günstig zu bekommen. Und das trifft auch auf gut erhaltene Modelle mit geringer Laufleistung zu. (')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2004, 67, 7, N'Hier geht es zur Übersicht aller Corsa-Angebote')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2005, 67, 8, N')')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2006, 67, 9, N'AUTO BILD Gebrauchtwagenmarkt9.390 €Opel Corsa E 1,2 Edition*SHZ*PDC*Garantie*TÜV18.785 km51 KW (69 PS)08/2015Zum AngebotBenzin, 5,4 l/100km (komb.), CO2 Ausstoß 128 g/km*9.510 €Opel Corsa 1.2 Selection*KLIMA*BLUETOOTH*CD-PLAYER*11.295 km51 KW (69 PS)07/2018Zum AngebotBenzin, 5,4 l/100km (komb.), CO2 Ausstoß 126 g/km*9.900 €Opel Corsa Corsa Edition ON19.880 km51 KW (69 PS)06/2018Zum AngebotBenzin, 5,6 l/100km (komb.)*9.950 €Opel Corsa Selection erst 5800 KM !! Klima/ TOP !5.800 km51 KW (69 PS)04/2018Zum AngebotBenzin, 5,4 l/100km (komb.), CO2 Ausstoß 127 g/km*9.999 €Opel Corsa E Selection *22.000 Km*20.000 km51 KW (69 PS)11/2017Zum AngebotBenzin, 5,4 l/100km (komb.), CO2 Ausstoß 128 g/km*10.070 €Opel Corsa 1.4 Active ecoFlex*SHZ*PDC*TEMPO*14.295 km66 KW (90 PS)07/2017Zum AngebotBenzin, 4,9 l/100km (komb.), CO2 Ausstoß 117 g/km*10.860 €Opel Corsa E Selection Klima17.000 km51 KW (69 PS)07/2018Zum AngebotBenzin, 5,4 l/100km (komb.), CO2 Ausstoß 128 g/km*10.900 €Opel Corsa 1.4 Edition18.000 km66 KW (90 PS)03/2015Zum AngebotBenzin, 5,2 l/100km (komb.), CO2 Ausstoß 120 g/km*10.950 €Opel Corsa 1.2 E Edition Klima+Pdc5.000 km51 KW (69 PS)09/2018Zum Angebot10.990 €Opel Corsa 1.4 TURBO SELECTION +COOL&SOUND+MET+ISOFIX+ZVR++7.900 km74 KW (101 PS)04/2015Zum AngebotBenzin, 5,3 l/100km (komb.), CO2 Ausstoß 123 g/km*Alle Opel Corsa gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2007, 67, 10, N'Da der Opel Corsa so beliebt ist, gibt es entsprechend zahlreiche Exemplare, die gerade als Gebrauchte verkauft werden. Insgesamt werden fast 10.000 Modelle der Baureihe (generationenübergreifend) verkauft. Die große Verbreitung sorgt auch dafür, dass der Corsa E auch heute noch auf dem Gebrauchtwagenmarkt vertreten ist, obwohl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2008, 67, 11, N'Opel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2009, 67, 12, N'den Verkauf bereits 2019 eingestellt hat.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2010, 67, 13, N'ZoomDer Innenraum des Corsa E dürfte Opel-Fans an die Zeit vor der Übernahme durch PSA erinnern. Bild: Autohero GmbH')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2011, 67, 14, N'Der Innenraum des Corsa E dürfte Opel-Fans an die Zeit vor der Übernahme durch PSA erinnern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2012, 67, 15, N'Sucht man nach Modellen, die zwischen 2015 und 2019 zugelassen wurden, werden mehr als 1000 Inserate angezeigt. Daher sollten Interessenten eine grobe Idee haben, welches Modell sie wollen oder zumindest anhand der Laufleistung filtern. Greift man zu letzterem Mittel und lässt sich nur Modelle des Corsa E anzeigen, die maximal 20.000 Kilometer auf der Uhr haben, bleiben nur 40 Exemplare übrig. Die Preise beginnen bei angenehm niedrigen 9390 Euro.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2013, 67, 16, N'Dass sich die Suche nach dem Vorgänger des aktuellen Corsa lohnen kann, zeigt dieser Corsa 1.4 ecoFlex, der aktuell beim Anbieter Autohero in Köln zum Verkauf steht. Der hellblau lackierte Kleinwagen wurde im Juli 2017 erstmals zugelassen und stammt aus zweiter Hand. Mit gerade einmal 14.295 Kilometern auf der Uhr dürfte der 1,4-Liter-Vierzylinder-Benziner mit 90 PS noch weit von der Verschleißgrenze entfernt sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2014, 67, 17, N'Gebrauchtwagenmarkt
            







                        Aktuelles Angebot: Opel Corsa
                    

                        Opel Corsa mit Garantie im AUTO BILD-Gebrauchtwagenmarkt.
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2015, 67, 18, N'Eine allzu große Auswahl an Komfortfeatures kann man bei dieser Klasse nicht erwarten. Dennoch verfügt der hier angebotene Opel Corsa')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2016, 67, 19, N'Active')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2017, 67, 20, N'über Annehmlichkeiten wie ein beheizbares Lederlenkrad, eine Klimaanlage, Sitzheizung vorn und Einparksensoren vorn wie hinten. Auf ein')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2018, 67, 21, N'Navigationssystem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2019, 67, 22, N'muss man bei diesem Corsa aber leider verzichten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2020, 67, 23, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2021, 67, 24, N'Bevor man beim attraktiven Preis von 10.460 Euro zuschlägt, sollte man die Historie des Corsa genauer unter die Lupe nehmen, da er als "repariert" angeboten wird. Eine zwölfmonatige Garantie sowie das 21-tägige Rückgaberecht sollten aber dafür sorgen, dass der Corsa seinem neuen Besitzer künftig viel Freude bringt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2022, 68, 0, N'Ab Montag (7. August) gibt es bei Lidl und Aldi neue Angebote aus dem Bereich Werkzeug. AUTO BILD hat für Sie einen Blick in den Prospekt geworfen und interessante Angebote herausgesucht!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2023, 68, 1, N'Beim Discounter Lidl, Aldi-Nord und Aldi-Süd gibt es immer wieder neue Angebote aus dem Werkzeugbereich – auch diese Woche locken einige spannende Deals in die Filiale. Es locken Angebote für Meißelhammer, Winkelschleifer, Akkuschrauber und mehr. AUTO BILD hat für Sie die interessantesten Angebote herausgesucht!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2024, 68, 2, N'Den Start der dieswöchigen Angebote macht der PBSA 20-Li')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2025, 68, 3, N'A1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2026, 68, 4, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2027, 68, 5, N'Akku-Bohrschrauber')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2028, 68, 6, N'von Parkside. Ein Schnellspannbohrfutter für Spannweiten von 0,8 bis 10 mm, maximal 500 Umdrehungen pro Minute und ein Drehmoment von 35 Nm verspricht Lidl mit dem Akku-Bohrschrauber, der für 29,99 Euro erhältlich sein wird. Mit dabei sind zusätzlich ein Transportkoffer sowie ein kleines Bit-Set. Der Akku ist in diesem Set inklusive.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2029, 68, 7, N'Zum Angebot: Parkside Akku-Bohrschrauber bei Lidl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2030, 68, 8, N'Nach dem Schrauben kommt das Bohren: Wer noch keinen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2031, 68, 9, N'Schlagbohrmaschine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2032, 68, 10, N'besitzt, der kann bei Aldi-Nord ab Montag fündig werden. Die Ferrex XYZ597')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2033, 68, 11, N'Schlagbohrmaschine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2034, 68, 12, N'soll mit maximal 3.000 Umdrehungen pro Minute drehen, das zuschaltbare Schlagwerk soll bis zu 48.000 Schläge pro Minute liefern. Zum Preis von 29,99 Euro sind vier Steinbohrer inklusive.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2035, 68, 13, N'Den passenden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2036, 68, 14, N'Akku-Bohrschrauber')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2037, 68, 15, N'gibt es zum Preis von 29,99 Euro bei Aldi-Süd. 65 Nm und mehrere Bohrer sind inklusive – der Akku und das benötigte Ladegerät allerdings nicht und müssen zusätzlich erworben werden!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2038, 68, 16, N'Ausgewählte Produkte 
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Preis
Zum Angebot












                                                                                    Bosch Professional  Bohrhammer GBH 2-28 F                                                                            




                                                                                    280,53 EUR
                                                                            





Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Makita  HP1631KX3 Schlagbohrmaschine                                                                            




                                                                                    95,95 EUR
                                                                            





Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Makita  Akku-Bohrschrauber                                                                             




                                                                                    115,49 EUR
                                                                            





Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    Einhell  Akku-Universalsäge                                                                            




                                                                                    59,95 EUR
                                                                            





Zum Angebot bei Amazon











Zum Angebot bei Ebay




















                                                                                    CCLIFE  Schraubstock                                                                            




                                                                                    30,99 EUR
                                                                            





Zum Angebot bei Amazon











Zum Angebot bei Ebay')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2039, 68, 17, N'Eine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2040, 68, 18, N'Säbelsäge')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2041, 68, 19, N'braucht man immer wieder – doch nicht immer ist eine Steckdose in der Nähe. Mit einer Akku-Säbelsäge sind die Steckdose oder verwirrender Kabelsalat kein Problem mehr. Zum Preis von 74,99 Euro gibt es die PSSAP 2028 A1 von Parkside inklusive Transportkoffer. Der Akku und das notwendige Ladegerät müssen allerdings extra gekauft werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2042, 68, 20, N'Zum Angebot: Parkside Akku-Säbelsäge bei Lidl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2043, 68, 21, N'Den PBH 1050 D4 von Parkside gibt es zum Preis von 54,99 Euro. Lidl wirbt hier mit 1.050 Watt, 3 Joule Schlagstärke und bis zu 5.300 Schlägen pro Minute. Mit dem Bohrer ist es also möglich zu Bohren, zu Schlagbohren oder zu Meißeln. Mehrere Meißel, Bohrer sowie ein Transportkoffer sind im Preis inklusive.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2044, 68, 22, N'Die passenden Meißel- oder Bohrersets gibt es ebenfalls ab Montag für 14,99 Euro bei Lidl.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2045, 68, 23, N'Der Parallelschraubstock mit integriertem Amboss kann einige Arbeiten in der hauseigenen Werkstatt leichter machen. Der Korpus aus Gusseisen besitzt eine Stahlspindel mit Ausdrehsperre, sowie eine Spannweite von 100mm. Preis: 24,99 Euro')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2046, 68, 24, N'Zum Angebot: Parkside Parallelschraubstock bei Lidl')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2047, 68, 25, N'Ab Montag gibt es ebenfalls bei Lidl einige weitere spannende Angebote: Schraubzwingensets (9,99 Euro), Spannzwingensets (3,99 Euro), Schraubendrehersets (4,99 Euro) und noch mehr sind einen Blick in die Filliale wert. Auch bei Aldi-Süd und Aldi-Nord locken weitere kleine Angebote für die Werkstatt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2048, 69, 0, N'Handschaltung und der Geruch von einem V8-Diesel: Was schon fast etwas retro klingt, wird mit dem Sondermodell des Land Cruisers Realität. Alle Infos!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2049, 69, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2050, 69, 2, N'Toyota Land Cruiser')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2051, 69, 3, N'J70 wird 40! 2024 nullt der Geländewagen zum vierten Mal und das zelebriert')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2052, 69, 4, N'Toyota')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2053, 69, 5, N'mit einer Neuauflage des Modells! Doch das Gute daran: Der Land Cruiser behält seinen originalen Look beinahe gänzlich! Und auch über die beiden verfügbaren Motorisierungen dürften sich die Fans sehr freuen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2054, 69, 6, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2055, 69, 7, N'Nix mit Elektrifizierung: Der Land Cruiser J70 bleibt auch als Jubiläums-Modell ein Diesel. Je nachdem, ob das Fahrzeug in Japan oder Australien ausgeliefert wird, gibt es zwei unterschiedliche Varianten. Das japanische Modell erhält den etwas zurückhaltenderen 2,8-Liter-Vierzylinder mit 201 PS und 500 NM maximalem Drehmoment. Diese Version ist auch in Australien verfügbar, doch dort wird es auch einen 4,5-Liter-V8 mit 202 PS und 430 Nm maximalem Drehmoment geben. Und bei der Auswahl müsste wahrscheinlich niemand lange überlegen!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2056, 69, 8, N'ZoomIn Australien wird es nur den Pick-up geben, dafür aber mit dem größeren Motor. Bild: Toyota')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2057, 69, 9, N'In Australien wird es nur den Pick-up geben, dafür aber mit dem größeren Motor.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2058, 69, 10, N'Wenn wir schon beiden landesbezogenen Unterschieden sind: Das Japan-Modell wird als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2059, 69, 11, N'SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2060, 69, 12, N'auf den Markt kommen, für Australien ist der Pick-Up vorgesehen! Und in Deutschland? Wir werden wohl leider keines der beides Modelle auf unseren Straßen zu sehen bekommen. Für nähere Informationen müssen wir uns aber noch bis Ende 2023 gedulden, dann werden die Sondermodelle präsentiert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2061, 69, 13, N'AUTO BILD Gebrauchtwagenmarkt71.800 €Toyota Land Cruiser 2.8-l-D-4D EXECUTIVE/7-SITZE/4x43.900 km150 KW (204 PS)03/2023Zum AngebotDiesel, 7,4 l/100km (komb.), CO2 Ausstoß 194 g/km*77.520 €Toyota Land Cruiser 2.8 D-4D 4x4 TEC-Edition +AHK2.800 km150 KW (204 PS)03/2023Zum AngebotDiesel, 9,7 l/100km (komb.), CO2 Ausstoß 254 g/km*64.850 €Toyota Land Cruiser 2.8 D-4D Automatik Executive6.500 km150 KW (204 PS)02/2023Zum Angebot73.900 €Toyota Land Cruiser Executive (J15)6.000 km150 KW (204 PS)02/2023Zum AngebotDiesel, 9,5 l/100km (komb.), CO2 Ausstoß 250 g/km*64.900 €Toyota Land Cruiser Comfort Automatik 2,8 Diesel9.870 km150 KW (204 PS)02/2023Zum AngebotDiesel, 8 l/100km (komb.), CO2 Ausstoß 212 g/km*78.990 €Toyota Land Cruiser 2.8 D-4D Autm.TEC-Edition *AHK*LED*6.500 km150 KW (204 PS)01/2023Zum AngebotDiesel, 7,6 l/100km (komb.), CO2 Ausstoß 201 g/km*71.990 €Toyota Land Cruiser 2.8 D-4D 6-Stufen-Automatik EXECUTIVE 360erKamera4.977 km150 KW (204 PS)01/2023Zum AngebotDiesel, 7,6 l/100km (komb.), CO2 Ausstoß 201 g/km*71.990 €Toyota Land Cruiser 2.8 D-4D Automatik Executive4.500 km150 KW (204 PS)01/2023Zum AngebotDiesel, 9,8 l/100km (komb.), CO2 Ausstoß 256 g/km*71.990 €Toyota Land Cruiser 2.8 D4-D TEC-Edition AHK; 7-Sitzer20.000 km130 KW (177 PS)01/2023Zum AngebotDiesel, 7,4 l/100km (komb.), CO2 Ausstoß 196 g/km*63.900 €Toyota Land Cruiser Comfort LEDER/AHK/SITZKLIMA5.800 km150 KW (204 PS)12/2022Zum AngebotDiesel, 8 l/100km (komb.), CO2 Ausstoß 212 g/km*Alle Toyota Land Cruiser gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2062, 69, 14, N'Einige Dinge hat Toyota aber modernisiert – vor allem im Innenraum. Denn hier findet sich nun ein 6,7-Zoll-Display. Außerdem verfügt der neue J70 über Apple CarPlay, Android Auto, einen Spurhalteassistenten und eine Verkehrszeichenerkennung. Und unter anderem die Scheinwerfer und Rückleuchten wurden natürlich auf den neuesten Stand gebracht. Aber Details, wie beispielsweise die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2063, 69, 15, N'Felgen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2064, 69, 16, N', sind stark an das Vorbild angelehnt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2065, 70, 0, N'Wer in Deutschland bei Rot über die Ampel fährt, muss mit harten Strafen rechnen. Sogar Gefängnis ist möglich.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2066, 70, 1, N'Als Autofahrer kennt man das: Man nähert sich einer Ampel, die auf Gelb umspringt. Heißt: Es kann nicht mehr lange dauern, bis Rot angezeigt wird. Viele versuchen es aber trotzdem noch, und prompt ist es zu spät: Sie huschen über die rote Ampel.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2067, 70, 2, N'Und jetzt? Zunächst einmal ist es völlig egal, ob man aus Versehen über Rot gefahren ist, also wie im beschriebenen Beispiel wusste, dass es schiefgehen konnte und es trotzdem probiert hat. Egal ist es genauso, wenn es ein Versehen war.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2068, 70, 3, N'Der wichtige Punkt bei einem Ampelverstoß ist die Unterscheidung zwischen einem einfachen und einem qualifizierten Delikt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2069, 70, 4, N'Hierbei kommt es auf die Dauer der Rotphase an. Ist die Ampel weniger als eine Sekunde lang rot, ist es ein einfacher Verstoß. Das hat ein Bußgeld in Höhe von 118,50 und einen Punkt in Flensburg zur Folge. Bei Gefährdung oder Sachbeschädigung sind es zwei Punkte und bis zu 268,50 Euro, hinzu kommt ein einmonatiges Fahrverbot.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2070, 70, 5, N'Ein qualifizierter Verstoß liegt vor, wenn die Ampel länger als eine Sekunde auf Rot steht. Dann wird es richtig teuer, das Bußgeld beginnt bei 228,50 Euro und kann bei Sachschaden auf bis zu 388,50 Euro anwachsen. Es gibt immer zwei Punkte und zudem ein einmonatiges Fahrverbot.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2071, 70, 6, N'ZoomDer wichtige Punkt bei einem Ampelverstoß ist die Unterscheidung zwischen einem einfachen und einem qualifizierten Delikt. Bild: Jürgen Christ')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2072, 70, 7, N'Der wichtige Punkt bei einem Ampelverstoß ist die Unterscheidung zwischen einem einfachen und einem qualifizierten Delikt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2073, 70, 8, N'Es geht aber noch heftiger.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2074, 70, 9, N'Denn wenn ein besonders rücksichtsloses Verhalten vorliegt und andere Verkehrsteilnehmer und/oder fremdes Eigentum beziehungsweise Sachen von bedeutendem Wert gefährdet werden oder sogar Schaden nehmen, kann ein Verstoß gegen das Rotlichtsignal als Straftat eingestuft werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2075, 70, 10, N'Es spielt dabei keine Rolle, ob es sich um einen einfachen oder qualifizierten Rotlichtverstoß handelt. Die Schwere der Sanktionen hängt von den verursachten Schäden und der Gefährdung ab. Dies kann zu erhöhten Bußgeldern, einem Anstieg der Punktzahl im Verkehrszentralregister und einer längeren Dauer des Fahrverbots führen. In schwerwiegenden Fällen kann der Verkehrssünder gemäß § 315 c des Strafgesetzbuches (StGB) sogar mit einer Freiheitsstrafe von bis zu fünf Jahren bestraft werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2076, 70, 11, N'Fahranfänger erwartet ebenfalls eine härtere Bestrafung. Überfahren sie eine rote Ampel, gilt zusätzlich zu den bereits erwähnten Konsequenzen die Verpflichtung, ein Aufbauseminar zu absolvieren. Dieses Seminar muss innerhalb eines von der Straßenverkehrsbehörde festgelegten Zeitraums durchgeführt werden. Falls der Nachweis über den Seminarbesuch nicht innerhalb dieser Frist erbracht wird, führt dies zum dauerhaften Entzug des Führerscheins. Darüber hinaus wird die Probezeit für')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2077, 70, 12, N'Fahranfänger')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2078, 70, 13, N'um weitere zwei Jahre verlängert, wenn sie eine rote Ampel missachten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2079, 71, 0, N'Wer einen neuen Dacia Sandero haben möchte, muss heute eine fünfstellige Summe zahlen. Es gibt den Kleinwagen aber natürlich auch gebraucht zu kaufen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2080, 71, 1, N'Der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2081, 71, 2, N'Dacia Sandero')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2082, 71, 3, N'gilt als der günstigste Neuwagen in Deutschland – und das seit Jahren. Inzwischen hat sich allerdings der Preis deutlich verändert.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2083, 71, 4, N'Waren es vor sechs Jahren noch knapp 7000 Euro als Einstieg in die Dacia-Welt, sind es für die dritte Generation heute über 11.000 Euro. Nach dem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2084, 71, 5, N'Duster')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2085, 71, 6, N'ist der Sandero in Deutschland das meistverkaufte Modell der Rumänen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2086, 71, 7, N'Aber: Es gibt den Sandero ja auch als')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2087, 71, 8, N'Gebrauchtwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2088, 71, 9, N'– und einen SCe 75 Ambiance von 2017 gibt es jetzt gebraucht zu kaufen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2089, 71, 10, N'AUTO BILD Gebrauchtwagenmarkt16.039 €Dacia Sandero Stepway Essential TCe 90 ABS Fahrerairba2.500 km67 KW (91 PS)07/2023Zum AngebotBenzin, 5,6 l/100km (komb.), CO2 Ausstoß 127 g/km*17.980 €Dacia Sandero Stepway Expression+ TCe 100 ECO-G5.500 km74 KW (101 PS)06/2023Zum AngebotCO2 Ausstoß 105 g/km*18.490 €Dacia Sandero Stepway Expression+ 100 ECO-G3.000 km74 KW (101 PS)06/2023Zum AngebotLPG, 5,5 l/100km (komb.), CO2 Ausstoß 131 g/km*18.999 €Dacia Sandero STEPWAY EXPRESSION+ TCe 100 ECO-G NAVI3.000 km74 KW (101 PS)05/2023Zum AngebotLPG, 7,4 l/100km (komb.), CO2 Ausstoß 115 g/km*16.990 €Dacia Sandero Stepway TCe 100 ECO-G Expression3.700 km74 KW (101 PS)05/2023Zum AngebotLPG, 6,7 l/100km (komb.)*19.499 €Dacia Sandero Stepway Expression+ TCe 100 ECO-G2.500 km74 KW (101 PS)05/2023Zum AngebotLPG, 7,4 l/100km (komb.), CO2 Ausstoß 114 g/km*18.690 €Dacia Sandero Stepway Expression TCe 100 ECO-G NAVI10.012 km74 KW (101 PS)05/2023Zum AngebotLPG, 6,7 l/100km (komb.), CO2 Ausstoß 105 g/km*18.380 €Dacia Sandero Stepway Expression+ TCe 100 ECO-G4.500 km74 KW (101 PS)04/2023Zum AngebotCO2 Ausstoß 123 g/km*18.950 €Dacia Sandero Stepway Expression + III 110 PS2.500 km81 KW (110 PS)04/2023Zum AngebotBenzin, 5,5 l/100km (komb.), CO2 Ausstoß 125 g/km*16.000 €Dacia Sandero Stepway TCe 100 ECO-G Comfort3.652 km74 KW (101 PS)04/2023Zum AngebotLPG, 7,4 l/100km (komb.), CO2 Ausstoß 115 g/km*Alle Dacia Sandero gebrauchtEin Service vonRechtliche Anmerkungen* Weitere Informationen zum offiziellen Kraftstoffverbrauch und zu den offiziellen spezifischen CO2-Emissionen und gegebenenfalls zum Stromverbrauch neuer Pkw können dem "Leitfaden über den offiziellen Kraftstoffverbrauch" entnommen werden, der an allen Verkaufsstellen und bei der "Deutschen Automobil Treuhand GmbH" unentgeltlich erhältlich ist www.dat.de.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2090, 71, 11, N'In Witten wird der Benziner für 8000 Euro angeboten. Der Preis ist Verhandlungssache. Wichtig zu wissen: Der im November 2017 zugelassene Sandero ist vergleichsweise wenige 35.883 Kilometer gelaufen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2091, 71, 12, N'ZoomDer Benziner wird in Witten für 8000 Euro angeboten.  Bild: Privat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2092, 71, 13, N'Der Benziner wird in Witten für 8000 Euro angeboten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2093, 71, 14, N'"Das Fahrzeug wurde hauptsächlich nur zum Einkaufen und für Arztbesuche genutzt", erklärt der Besitzer in der Anzeige. Es gab bislang nur einen Besitzer, der Wagen ist scheckheftgepflegt und mit einem Dreizylinder-Ottomotor mit, rund einem Liter Hubraum und 54 kW (73 PS) ausgestattet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2094, 71, 15, N'Gebrauchtwagenmarkt
            







                        Aktuelles Angebot: Dacia Sandero SCe 75 Ambiance
                    

                        Dacia Sandero SCe 75 Ambiance im AUTO BILD-Gebrauchtwagenmarkt.
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2095, 71, 16, N'Eine Inspektion wurde im Juli 2022 durchgeführt, im November 2022 wurden die Bremse gewartet und die Beläge erneuert, außerdem wurde das Auto mit neuen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2096, 71, 17, N'Allwetterreifen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2097, 71, 18, N'ausgestattet. TÜV/ASU wurden im Februar 2023 gemacht, wäre also erst wieder 2025 fällig. Eine komplette Endreinigung wurde bereits gemacht.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2098, 71, 19, N'Zur Ausstattung gehören ein Berganfahrassistent, elektrische Fensterheber, eine Klimaanlage und ein Multifunktionslenkrad. Als Extras gibt es Allwetterreifen und Stahlfelgen. Ein Marderschreck wurde zusätzlich eingebaut.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2099, 71, 20, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2100, 71, 21, N'Was der Sandero laut einem AUTO BILD-Test gut kann? "Vier Leute und deren Gepäck durch die Gegend kutschieren. Die Basis wiegt nur rund eine Tonne, das sorgt für flotte Fahrleistungen, und wegen der mäßigen Geräuschdämmung fühlt sich der Sandero sowieso immer schneller an, als man fährt", schrieb AUTOBILD: "Die simple Technik und der erfreulich hohe Nutzwert machen den Sandero zu einem sympathischen Minimalisten."')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2101, 72, 0, N'Was geht? Was steht? Das Marktbarometer beleuchtet die Entwicklungen bei den Pkw-Zulassungen. Der Markt erholt sich – nur eine Antriebsart wohl nie wieder!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2102, 72, 1, N'Mit 139.6870 Neuzulassungen übertrifft das erste Halbjahr 2023 den Vorjahreszeitraum um 12,8 Prozent. Ein Großteil dieses Zuwachses entfällt auf die Monate Mai (+19,2 Prozent gegenüber Mai 2022) und Juni (+24,8 Prozent).')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2103, 72, 2, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2104, 72, 3, N'Im Vergleich mit dem Vor-Corona-Jahr 2019 mit 1,85 Millionen Neuzulassungen fehlen allerdings noch rund 450.000 Pkw-Auslieferungen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2105, 72, 4, N'Ob es sich um einen langfristigen Aufwärtstrend handelt, ist indes fraglich. Laut Verband der Automobilindustrie (VDA) kam die hiesige Produktionssteigerung um 32 Prozent gegenüber dem ersten Halbjahr 2022 vor allem zustande, weil Lieferketten wieder funktionierten und so bestehende Aufträge abgearbeitet werden konnten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2106, 72, 5, N'Top 10: Neuzulassungen Pkw 1. Halbjahr 2023RangModellNeuzulassungen Jan. bis Juni 2023Veränderung ggü. Jan. bis Juni 2022 in %PfeilPfeilAbzweigung1AbzweigungAbzweigung2AbzweigungAbzweigung3AbzweigungAbzweigung4AbzweigungAbzweigung5AbzweigungAbzweigung6AbzweigungAbzweigung7AbzweigungAbzweigung8AbzweigungAbzweigung9AbzweigungAbzweigung10AbzweigungAbzweigungNeuzulassungen insgesamtAbzweigungVW GolfVW T-Roc VW Tiguan Tesla Model Y Opel Corsa Mercedes C-Klasse VW Passat Skoda Octavia Mini (alle Modelle) Fiat 500 37.79836.36533.09527.82525.83825.44423.63023.01121.79119.0451.396.870-12,034,033,9273,15,146,715,880,49,9-7,412,8PfeilPfeilQuelle: Kraftfahrt-Bundesamt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2107, 72, 6, N'Rang')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2108, 72, 7, N'Modell')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2109, 72, 8, N'Neuzulassungen Jan. bis Juni 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2110, 72, 9, N'Veränderung ggü. Jan. bis Juni 2022 in %')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2111, 72, 10, N'1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2112, 72, 11, N'2')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2113, 72, 12, N'3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2114, 72, 13, N'4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2115, 72, 14, N'5')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2116, 72, 15, N'6')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2117, 72, 16, N'7')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2118, 72, 17, N'8')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2119, 72, 18, N'9')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2120, 72, 19, N'10')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2121, 72, 20, N'Neuzulassungen insgesamt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2122, 72, 21, N'VW Golf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2123, 72, 22, N'VW T-Roc')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2124, 72, 23, N'VW Tiguan')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2125, 72, 24, N'Tesla Model Y')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2126, 72, 25, N'Opel Corsa')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2127, 72, 26, N'Mercedes C-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2128, 72, 27, N'VW Passat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2129, 72, 28, N'Skoda Octavia')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2130, 72, 29, N'Mini (alle Modelle)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2131, 72, 30, N'Fiat 500')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2132, 72, 31, N'37.798')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2133, 72, 32, N'36.365')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2134, 72, 33, N'33.095')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2135, 72, 34, N'27.825')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2136, 72, 35, N'25.838')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2137, 72, 36, N'25.444')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2138, 72, 37, N'23.630')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2139, 72, 38, N'23.011')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2140, 72, 39, N'21.791')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2141, 72, 40, N'19.045')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2142, 72, 41, N'1.396.870')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2143, 72, 42, N'-12,0')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2144, 72, 43, N'34,0')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2145, 72, 44, N'33,9')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2146, 72, 45, N'273,1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2147, 72, 46, N'5,1')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2148, 72, 47, N'46,7')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2149, 72, 48, N'15,8')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2150, 72, 49, N'80,4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2151, 72, 50, N'9,9')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2152, 72, 51, N'-7,4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2153, 72, 52, N'12,8')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2154, 72, 53, N'Die Zahl der inländischen Bestellungen sank dagegen bei deutschen Herstellern um 27 Prozent. Man rechne daher mit einer Abschwächung der Zuwachsraten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2155, 72, 54, N'Eine Antriebsart dürfte auch bei zukünftig positiver Entwicklung keine Rolle mehr spielen: Seit dem Wegfall der staatlichen Förderung für Plug-in-Hybride Anfang 2023 sind deren Zulassungszahlen stark gesunken (s. Bild ganz oben). Laut Branchendienst Dataforce waren im Jahr 2020 noch 52 Prozent der Neuerscheinungen mit dieser Antriebstechnik bestückt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2156, 72, 55, N'ZoomNeu- und Gebrauchtwagen fahren zur Jahreshalbzeit 2023 satt im Plus. (Quelle: Kraftfahrt-Bundesamt) Bild: AUTO BILD Montage')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2157, 72, 56, N'Neu- und Gebrauchtwagen fahren zur Jahreshalbzeit 2023 satt im Plus. (Quelle: Kraftfahrt-Bundesamt)')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2158, 72, 57, N'Schon 2025 werde es aber wohl keine Plug-in-Hybride als Neuerscheinung mehr geben. Die Brückentechnologie hätte sich damit erledigt – zugunsten reiner E-Autos, die immer attraktiver werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2159, 73, 0, N'Der AMG G 63 "Grand Edition", der elektrische EQG, die neue E-Klasse als Limousine und T-Modell und viele mehr: AUTO BILD zeigt alle Mercedes-Neuheiten bis 2025!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2160, 73, 1, N'Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2161, 73, 2, N'stellt sein Portfolio Schritt für Schritt auf vollelektrische Fahrzeuge um. Ab 2025 wird es aus Stuttgart nur noch neue Elektro-Plattformen geben, im selben Jahr will man direkt drei neue Architekturen vorstellen:')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2162, 73, 3, N'●')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2163, 73, 4, N'MB.EA')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2164, 73, 5, N'wird künftig die Basis der mittelgroßen bis großen Modelle;')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2165, 73, 6, N'●')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2166, 73, 7, N'AMG.EA')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2167, 73, 8, N'ist der Sportmarke vorbehalten und auf besonders viel Leistung ausgelegt;')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2168, 73, 9, N'●')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2169, 73, 10, N'VAN.EA')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2170, 73, 11, N'ist der Unterbau für die nächste Generation elektrischer Vans und Nutzfahrzeuge.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2171, 73, 12, N'Carwow
            







                        Auto ganz einfach zum Bestpreis online verkaufen
                    

                        Top-Preise durch geprüfte Käufer –  persönliche Beratung – stressfreie Abwicklung durch kostenlose Abholung!
                    




Zum Angebot')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2172, 73, 13, N'Wann komplett Schluss mit dem Verbrenner sein soll, sagt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2173, 73, 14, N'Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2174, 73, 15, N'allerdings nicht –')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2175, 73, 16, N'anders als andere Hersteller')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2176, 73, 17, N'. Stattdessen macht der Autobauer diesen Zeitpunkt vom Markt abhängig. "Wir werden bereit sein, wenn die Märkte bis zum Ende des Jahrzehnts vollständig auf Elektroautos umstellen", so Mercedes-Chef Ola Källenius.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2177, 73, 18, N'Nachdem bekannt wurde, dass')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2178, 73, 19, N'Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2179, 73, 20, N'2025 die A- und die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2180, 73, 21, N'B-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2181, 73, 22, N'einstellen wird, stellte sich natürlich sofort die Frage: Was kommt dann? Darauf gibt es nun zumindest erste Hinweise. Denn bekannt ist, dass es auf jeden Fall ein neues Einstiegsmodell geben wird und ein Konzeptfahrzeug existiert ebenfalls schon. Dieses wird bei der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2182, 73, 23, N'IAA Mobility 2023')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2183, 73, 24, N'präsentiert. Vorstellbar wäre, dass Mercedes einen Marktstart für 2024 plant. Doch für weitere Details heißt es noch: geduldig sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2184, 73, 25, N'ZoomWas kommt nach der A-Klasse als neues Einsteigsmodell? Dieses Bild gibt erste Hinweise auf die Optik. Bild: Mercedes-Benz Group AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2185, 73, 26, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2186, 73, 27, N'Was kommt nach der A-Klasse als neues Einsteigsmodell? Dieses Bild gibt erste Hinweise auf die Optik.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2187, 73, 28, N'Weil mehr Elektroautos auch mehr')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2188, 73, 29, N'Akkus')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2189, 73, 30, N'bedeuten, will Mercedes eine neue, standardisierte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2190, 73, 31, N'Batteriegeneration entwickeln')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2191, 73, 32, N'. Die soll in 90 Prozent der künftigen Fahrzeuge zum Einsatz kommen. Um ausreichend Batteriezellen produzieren zu können, sollen mit Partnern weltweit acht Gigafabriken entstehen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2192, 73, 33, N'Seit 2016 ist die Mercedes')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2193, 73, 34, N'E-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2194, 73, 35, N'der Generation')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2195, 73, 36, N'W 213')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2196, 73, 37, N'auf dem Markt. Obwohl sie erst 2020 einer umfassenden Modellpflege unterzogen wurde, steht jetzt die sechste Generation an. Besonders wichtig für den deutschen Markt: Auch die neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2197, 73, 38, N'E-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2198, 73, 39, N'wird es neben der Limousine als Kombi (')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2199, 73, 40, N'T-Modell')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2200, 73, 41, N') geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2201, 73, 42, N'Optisch ist der Benz kaum wiederzuerkennen. Zwar behält die neue')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2202, 73, 43, N'E-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2203, 73, 44, N'die Drei-Box-Limousinen-Proportionen mit langer Motorhaube und weit nach hinten versetzter Fahrgastzelle. Sie wirkt jedoch deutlich moderner – vor allem an der Front mit dem Black-Panel-ähnlichen Einleger, der den Kühlergrill mit den Scheinwerfern verbindet. Der Kühlergrill ist optional auch beleuchtet. Der wichtigste Unterschied zwischen Limousine und T-Modell ist der Kofferraum, der schrumpft beim Kombi zwar leicht, fasst aber immer noch zwischen 615 und 1830 Liter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2204, 73, 45, N'Innen wird die E-Klasse zur Entertainment-Klasse, bietet eine riesige Display-Landschaft, die dem Hyperscreen ähnelt. Dazu kommen zahlreiche neue Features und Drittanbieter-Apps wie beispielsweise TikTok oder Zoom (mit integrierter Kamera), die direkt im Infotainment untergebracht sind.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2205, 73, 46, N'Bei den Motoren gibt''s die Wahl zwischen jeweils drei Mild- und Plug-in-Hybriden. Die preisliche Basis bildet weiterhin der E 200 mit 204 PS. Vorerst der einzige Diesel ist der 197 PS starke E 220 d (optional mit Allradantrieb 4Matic). Die Stecker-Modelle kommen mit Systemleistungen zwischen 313 und 381 PS. Die Preise sind noch nicht bekannt, der Einstieg dürfte aber bei rund 54.000 Euro liegen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2206, 73, 47, N'Auch an einem Urgestein geht die Entwicklung zur Elektromobilität nicht vorbei. Mit einer Studie hat Mercedes auf der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2207, 73, 48, N'IAA 2021')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2208, 73, 49, N'in München gezeigt, wie man sich in Stuttgart die elektrische')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2209, 73, 50, N'G-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2210, 73, 51, N'vorstellt – den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2211, 73, 52, N'EQG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2212, 73, 53, N'. Das Design orientiert sich nah an der bisher kaum veränderten Ikone.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2213, 73, 54, N'Auch die Geländefähigkeiten will Mercedes in die neue Zeit retten. Sperren, Untersetzung und Ähnliches bleiben also erhalten – Allrad ist natürlich gesetzt! Die gute Nachricht: Die Verbrenner-Version bleibt erst mal im Portfolio und soll parallel angeboten werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2214, 73, 55, N'Man muss keine Glaskugel bemühen, um vorhersagen zu können, dass Mercedes an einer elektrischen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2215, 73, 56, N'C-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2216, 73, 57, N'arbeitet, die dann unter dem Namen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2217, 73, 58, N'EQC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2218, 73, 59, N'an den Start gehen dürfte. Die Stuttgarter haben inzwischen einen Großteil ihres Portfolios unter Strom gesetzt, vom Kompakt-SUV')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2219, 73, 60, N'EQA')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2220, 73, 61, N'bis zur Luxuslimousine')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2221, 73, 62, N'EQS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2222, 73, 63, N'. In der volumenstarken Mittelklasse aber überlassen sie das Feld derzeit noch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2223, 73, 64, N'Tesla Model 3')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2224, 73, 65, N'und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2225, 73, 66, N'BMW i4')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2226, 73, 67, N'. Dass sich das – voraussichtlich schon 2025 – ändert, ist also nur logisch.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2227, 73, 68, N'BildergalerieKameraNeue Mercedes und AMG (2023, 2024, 2025)26 BilderPfeil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2228, 73, 69, N'Die Wahrscheinlichkeit, dass die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2229, 73, 70, N'Elektro-C-Klasse')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2230, 73, 71, N'eine kleinere Version des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2231, 73, 72, N'EQE')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2232, 73, 73, N'oder')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2233, 73, 74, N'EQS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2234, 73, 75, N'wird, gilt als gering. Viel eher könnte sich die Mittelklasse-Limousine an der Studie')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2235, 73, 76, N'EQXX')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2236, 73, 77, N'orientieren, die konsequent auf optimale Aerodynamik setzt – was auch das sprichwörtlich etwas schräge Heckdesign erklärt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2237, 73, 78, N'Unter dem schnittigen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2238, 73, 79, N'EQC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2239, 73, 80, N'-Blech steckt die neue MB.EA-Architektur für mittlere und große Fahrzeuge, die 800-Volt-Technik und weiterhin eher konventionelle Radialfluss-Motoren mit voraussichtlich 250 bis 500')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2240, 73, 81, N'PS')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2241, 73, 82, N'bieten wird. Zudem soll die Energiedichte der Akkus deutlich gesteigert werden, was dazu führt, dass ein 100-kWh-Akku im')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2242, 73, 83, N'EQC')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2243, 73, 84, N'im Idealfall bis zu 1000 Kilometer Reichweite ermöglichen soll.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2244, 73, 85, N'AUTO BILD zeigt alle neuen Mercedes-Modelle bis 2025! Los geht''s mit dem Mercedes-AMG G 63 "Grand Edition"; Preis: ab 228.897 Euro; Marktstart: ab sofort.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2245, 73, 86, N'Zugegeben, der AMG G 63 ist schon so etwas wie ein Dinosaurier unter den Autos, jetzt bringt Mercedes noch ein auf 1000 Stück limitiertes Sondermodell "Grand Edition" – ein mattschwarzes Biest mit Akzenten in "Kalaharigold" und dem 585 PS starken V8-Biturbo.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2246, 73, 87, N'Mercedes E-Klasse; Preis: ab ca. 54.000 Euro; Marktstart: Sommer 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2247, 73, 88, N'Die Stuttgarter legen ihre Oberklasse-Limousine neu auf. Optisch wertet Mercedes die E-Klasse deutlich auf. Wie es sich gehört, wird die Baureihe auch weiterhin ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2248, 73, 89, N'... als Kombi (')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2249, 73, 90, N'T-Modell')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2250, 73, 91, N') angeboten. Der wichtigste Unterschied am E-Klasse T-Modell zur Limousine ist natürlich der Kofferraum, zwischen 615 und 1830 Liter passen ins Ladeabteil, beim Plug-in-Hybrid sind''s zwischen 460 und 1675 Liter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2251, 73, 92, N'Mercedes GLE Facelift; Preis: ab 85.055 Euro, Marktstart: Juli 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2252, 73, 93, N'Die Stuttgarter haben den GLE und GLE Coupé geliftet, mit serienmäßigem AMG-Paket, neuer Leuchtengrafik und durchgehend elektrifizierten Motoren mit bis zu 612 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2253, 73, 94, N'Mercedes-AMG C 63; Preis: knapp unter 90.000 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2254, 73, 95, N'Der nächste C 63 wird mit einem Vierzylinder als PHEV kommen. Dank großem Turbolader sind 476 PS drin, ein E-Motor pusht das S-Modell auf 680 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2255, 73, 96, N'Mercedes EQT; Preis: ca. 49.445 Euro, Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2256, 73, 97, N'Künftig wird es den Citan nur noch für Handwerker geben, die Personenvariante wird T-Klasse heißen und auch einen elektrischen Ableger bekommen, den EQT. Sah die Studie noch ein bisschen nach Raumschiff aus, ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2257, 73, 98, N'verzichtet Mercedes auf Experimente. Zu erkennen gibt sich der EQT nur am schwarz-glänzenden Kühlergrill (der E-Auto-untypisch nicht komplett geschlossen ist) – und am Schriftzug am Heck. Schade: Selbst der Stromer muss in der basis-Version mit Halogen-Leuchten Vorlieb nehmen, LED-Scheinwerfer gibt’s nur gegen Zuzahlung.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2258, 73, 99, N'Mercedes-AMG S 63 E Performance; Preis: ab 208.400 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2259, 73, 100, N'In Zukunft wird der S 63 das Topmodell der S-Klasse sein, denn Mercedes spart den S 65 ein. Die 612 Verbrenner-PS aus dem Vierliter-V8 bleiben, werden aber elektrisch unterstützt. In Summe ergibt das 802 PS.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2260, 73, 101, N'Mercedes GLA Facelift; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2261, 73, 102, N'Mit neuem Front- und Heckdesign, serienmäßigem 10,25-Zoll-Infotainment-Bildschirm und der neuesten MBUX-Technik fährt der GLA in seine zweite Lebenshälfte. Alle Benziner werden elektrifiziert und kommen mit einem 48-Volt-Bordnetz. Auch vier Diesel und ein Plug-in-Hybrid sind im Programm.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2262, 73, 103, N'Mercedes GLB Facelift; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2263, 73, 104, N'Neben dem Mercedes GLA bekommt auch der etwas größere GLB eine Modellpflege.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2264, 73, 105, N'Mercedes CLA Facelift; Preis: ab 34.694 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2265, 73, 106, N'Ein paar Monate nach A- und B-Klasse spendiert Mercedes auch CLA und CLA Shooting Brake eine Modellpflege. Angesetzt wird vor allem bei der Motorenpalette und der Serienausstattung. Die optische Überarbeitung fällt eher behutsam aus.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2266, 73, 107, N'Mercedes EQE SUV; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2267, 73, 108, N'Für den Antrieb haben die Stuttgarter gleich vier Optionen eingeplant: Das Einstiegsmodell kommt mit 60-kWh-Batterie und mindestens 140 kW Leistung, die stärkste Version erhält satte 640 kW und einen Stromspeicher mit 110 kWh.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2268, 73, 109, N'Mercedes CLE Coupé; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2269, 73, 110, N'Zukünftig werden die Coupé-Varianten der C- und E-Klasse durch ein Modell ersetzt, den CLE. Er soll die Sportlichkeit der zweitürigen C-Klasse mit größeren Abmessungen im E-Klasse-Format vereinen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2270, 73, 111, N'Mercedes CLE Cabrio; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2271, 73, 112, N'Obwohl die offene C-Klasse eigentlich vom Tisch war, wurden Prototypen gesichtet.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2272, 73, 113, N'Mercedes-AMG GT; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2273, 73, 114, N'Die kommende Generation des Coupés wird sich die Plattform sowie viele weitere Technik-Komponenten mit dem neuen SL (R 232) teilen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2274, 73, 115, N'Mercedes GLS Facelift; Preis: über 100.000 Euro; Marktstart: Oktober 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2275, 73, 116, N'Der GLS wird mit frischer Optik, neuer Software und elektrifizierten Antrieben zu den Händlern kommen, in den USA sogar bereits im September.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2276, 73, 117, N'Mercedes-Maybach EQS SUV; Preis: über 200.000 Euro; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2277, 73, 118, N'Mit 484 kW (658 PS) und gewaltigen 950 Nm Drehmoment mutiert die Maybach-Version zum stärksten Ableger des EQS SUV. Besonders luxuriös ist das Maybach-SUV im Fond – Mercedes spricht von der "Lounge".')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2278, 73, 119, N'Mercedes GLC Coupé; Marktstart: 2023.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2279, 73, 120, N'Den GLC hat Mercedes bereits 2022 neu aufgelegt, jetzt folgt die Coupé-Version des Mittelklasse-SUV. Optisch ähnelt er dem SUV, ein paar Details wie die Leuchtengrafik der Rückleuchten sind neu. Die Motoren mit durchgehender Elektrifizierung übernimmt er vom normalen GLC, ein Sechszylinder-Diesel und eine AMG-Version sollen folgen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2280, 73, 121, N'Mercedes CLE 63 Coupé; Marktstart: 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2281, 73, 122, N'Die AMG-Variante des neuen CLE Coupé startet voraussichtlich 2024. Aktuell ist noch nicht klar, ob mit dem Vierzylinder aus dem C 63 und GLC 63 oder doch mit einem Sechszylinder.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2282, 73, 123, N'Mercedes EQG; Preis: ca. 138.000 Euro; Marktstart: 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2283, 73, 124, N'Die G-Klasse wird ab 2024 auch elektrisch angeboten. Die Reichweite dürfte bei rund 450 bis 500 Kilometer liegen. Neben dem Alltag soll der EQG auch weiterhin die typischen Geländeeigenschaften der G-Klasse ins elektrische Zeitalter übertragen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2284, 73, 125, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2285, 73, 126, N'Mercedes G-Klasse Facelift; Marktstart: 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2286, 73, 127, N'Seit 2018 ist die aktuelle Mercedes G-Klasse mit dem Baucode W 464 auf dem Markt, bald wird es Zeit für ein Facelift. Äußerlich werden die Neuerungen wohl gering ausfallen, im Innenraum dürfte MBUX Einzug halten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2287, 73, 128, N'Mercedes-AMG E 63; Preis: ab ca. 150.000 Euro; Marktstart: 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2288, 73, 129, N'Wie auch schon bei der C-Klasse wird die Zeit des V8 unter der Haube wohl vorbei sein. Gerüchten zufolge dürfte der neue E 63 einen um die 700 PS starken Reihensechszylinder (1200 Nm Drehmoment) mit Plug-in-Hybrid-Technik bekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2289, 73, 130, N'Mercedes EQE Shooting Brake; Marktstart: nicht vor 2024.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2290, 73, 131, N'Auf Basis des EQE ist eine Kombi-Variante denkbar. Mit derselben Technik wie bei der E-Limousine.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2291, 73, 132, N'Neues Einstiegsmodell;')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2292, 73, 133, N'Marktstart eventuell 2024')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2293, 73, 134, N'. Im Herbst 2023 will Mercedes ein Konzeptfahrzeug präsentieren, welchen stellvertretend für das neue Einstiegssegment stehen soll.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2294, 73, 135, N'Mercedes EQC; Preis: ca. 55.000 Euro; Marktstart: 2025.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2295, 73, 136, N'Neben E- und S-Klasse darf natürlich auch eine elektrische C-Klasse nicht fehlen. Wahrscheinlich ist, dass das E-Auto unter dem Namen EQC und das SUV-Pendant als EQC SUV laufen wird.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2296, 73, 137, N'Denkbar wären beim EQC bis zu 1000 Kilometer Reichweite und 500 PS. Und auch die 800-Volt-Ladetechnik hat Mercedes für die Limousine angedacht. Ein T-Modell wird es von der Elektro-C-Klasse wahrscheinlich nicht geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2297, 74, 0, N'Aufgepasst, hier kommt ein echtes Schnäppchen: Den Ford Puma ST X gibt es jetzt schon für 399 Euro pro Monat All-Inclusive im Auto-Abo.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2298, 74, 1, N'Dieser Puma will gezähmt werden! Mit dem Auto-Abo gelingt das jedoch ganz leicht, denn bei diesem Angebot ist tatsächlich schon alles enthalten außer der Tankkosten: Für 399 Euro brutto im Monat gibt es den')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2299, 74, 2, N'Ford Puma')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2300, 74, 3, N'1,5 l EcoBoost ST X jetzt für Privatkunden')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2301, 74, 4, N'im Auto-Abo bei Like2Drive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2302, 74, 5, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2303, 74, 6, N'Trotz kleinem Motor fährt diese Raubkatze auf der Straße die Krallen aus: Denn unter der Haube des Mini-SUV lauert ein turbogeladener R3-Ottomotor mit Direkteinspritzung und Ladeluftkühler. Der Fronttriebler verfügt über sechs Gänge und bringt es immerhin auf 200 PS, von 0 auf 100 geht''s damit in nur 6,7 Sekunden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2304, 74, 7, N'ZoomDen Ford Puma ST X gibt es jetzt im All-Inclusive Auto-Abo. Bild: Like2Drive')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2305, 74, 8, N'Den Ford Puma ST X gibt es jetzt im All-Inclusive Auto-Abo.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2306, 74, 9, N'Mindestens so imposant ist beim Ford Puma ST X die Ausstattung: Mit integriertem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2307, 74, 10, N'Navigationssystem')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2308, 74, 11, N', virtuellem Cockpit, Sitzheizung und allerhand mehr, bietet er sowohl im Innenraum Komfort wie auch außen, wo beispielsweise Einparkhilfe und Rückfahrkamera für ein entspanntes Fahrerlebnis sorgen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2309, 74, 12, N'Kein Wunder, dass Ford aktuell die beliebteste Marke bei Auto-Abo-Kunden ist.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2310, 74, 13, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2311, 74, 14, N'ANZEIGEAuto AboIn Kooperation mitFlexibel und ohne Risiko zum WunschautoIhre Vorteile im Sixt+ Auto Abo:Keine AnschaffungskostenVolle FlexibilitätSofort erhältlichAlles inklusiveAngebote vergleichen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2312, 74, 15, N'Aber auch')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2313, 74, 16, N'das Auto-Abo selbst wird in Deutschland immer beliebter')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2314, 74, 17, N', Nutzer schätzen die kurzfristige Verfügbarkeit, die flexiblen Laufzeiten und natürlich den Luxus, sich um nichts kümmern zu müssen: Als All-Inclusive-Angebot fallen Kosten wie für Zulassung, jahreszeitgerechte')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2315, 74, 18, N'Bereifung')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2316, 74, 19, N',')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2317, 74, 20, N'Kfz-Steuer')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2318, 74, 21, N'und Versicherung oder den Service weg – alles ist bei den monatlich 399 Euro brutto bereits enthalten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2319, 74, 22, N'Sie können einfach drauflosfahren: Holen Sie den Ford Puma ST X in vier bis sechs Wochen im Großraum Berlin, Hamburg, München, Aachen, Düsseldorf, Memmingen oder Osnabrück ab. Alternativ kann das Auto auch für eine einmalige Gebühr von 249 Euro direkt zu ihnen nach Hause geliefert werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2320, 74, 23, N'Für mindestens ein Jahr dürfen Sie den flinken Puma dann ihr Eigen nennen, denn die Laufzeit beträgt zwölf Monate und beinhaltet 10.000 Freikilometer: Mehr als genug also für die ein oder andere aufregende')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2321, 74, 24, N'Safari')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2322, 74, 25, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2323, 75, 0, N'Der nächste VW Passat kommt nur noch als Kombi – AUTO BILD zeigt, wie der Wolfsburger aussehen könnte und machte die erste Fahrt im Prototyp!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2324, 75, 1, N'Schon seit 2014 ist die aktuelle Generation des')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2325, 75, 2, N'VW Passat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2326, 75, 3, N'auf dem Markt. Dem üblichen Zyklus nach wäre es langsam Zeit für einen Nachfolger. Der kommende')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2327, 75, 4, N'Passat')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2328, 75, 5, N'mit dem internen Baucode B9 wird')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2329, 75, 6, N'nur noch als Kombi namens Variant')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2330, 75, 7, N'zu haben sein – er könnte noch 2023 vorgestellt werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2331, 75, 8, N'Die beliebtesten Kombis
                

Ausgewählte Produkte in tabellarischer Übersicht


                                                Aktuelle Angebote
                                            
Preis
Zum Angebot












                                                                                    Skoda Octavia Combi                                                                            




                                                                                    UVP ab 35.870 EUR/Ersparnis bis zu 9116/Leasing-Bestpreis: 49,00 EUR
                                                                            










Zum Angebot bei Sparneuwagen
































                                                                                    Toyota Corolla Touring Sports                                                                            




                                                                                    UVP ab 34.540 EUR/Ersparnis bis zu 4669,00 EUR
                                                                            






















                                                                                    Kia  Ceed Sportswagon                                                                            




                                                                                    UVP ab 25.990 EUR/Ersparnis bis zu 8134,00 EUR
                                                                            






















                                                                                    Cupra Leon Sportstourer                                                                            




                                                                                    UVP ab 35.425 EUR/Ersparnis bis zu 11.659,00 EUR
                                                                            






















                                                                                    BMW 3er Touring                                                                            




                                                                                    UVP ab 46.300 EUR/Ersparnis bis zu 11.610/Leasing-Bestpreis: 134,00 EUR
                                                                            










Zum Angebot bei Sparneuwagen
































                                                                                    VW Golf Variant                                                                            




                                                                                    UVP ab 30.375 EUR/Ersparnis bis zu 5787/Leasing-Bestpreis: 89,00 EUR
                                                                            










Zum Angebot bei Sparneuwagen')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2332, 75, 9, N'Bei den Händlern dürfte der Passat B9 allerdings erst 2024 zu finden sein. Ein Grund dafür ist, dass die nächste Generation ins Werk im slowakischen Bratislava umziehen muss, weil im Passat-Stammwerk Emden (Niedersachsen) der ID.4 und künftig auch der Elektro-Kombi')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2333, 75, 10, N'ID.7')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2334, 75, 11, N'gebaut werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2335, 75, 12, N'Als sicher gilt, dass die vermutlich letzte Generation mit Verbrenner teurer werden wird. Aktuell startet der Passat Variant in der Ausstattung "Concept Line" bei 38.850 Euro, der Nachfolger wird mit ordentlicher Basisausstattung wohl über 40.000 Euro kosten.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2336, 75, 13, N'Schon bei der ersten Sitzprobe wird klar, der Passat fährt in eine andere Liga. Die bei')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2337, 75, 14, N'VW')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2338, 75, 15, N'müssen eine Tabelle mit allen Kritikpunkten der letzten drei Jahre ausgefüllt haben, etwa zu viel Hartplastik, lahmes Multimedia, komplizierte Bedienung. Die Oberflächenqualität ist bereits beim Prototyp gut. Überall da ist jetzt ein Haken dran: Hausaufgabe erledigt!')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2339, 75, 16, N'ZoomDie neue Passat-Generation wird es wohl als Diesel, als Benziner und in einer Plug-in-Hybridvariante geben. Bild: Volksawagen AG')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2340, 75, 17, N'')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2341, 75, 18, N'Die neue Passat-Generation wird es wohl als Diesel, als Benziner und in einer Plug-in-Hybridvariante geben.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2342, 75, 19, N'Unser Diesel für die erste Fahrt im getarnten Passat hat 150 PS, was aber gar nicht so entscheidend ist, denn heute geht es ums Fahrwerk. Der neue Passat steht wie der aktuelle')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2343, 75, 20, N'Golf')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2344, 75, 21, N'auf der modifizierten Plattform MQB evo. Und wie beim Golf GTI baut VW den "Fahrdynamikmanager" ein, der die elektromechanischen Fahrwerkssysteme abmischt.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2345, 75, 22, N'Durch den Pylonenkurs ist der Neue durch radindividuelle Bremseingriffe und Veränderung der Dämpferhärten zu jeder Zeit stabil, lenkt neutral ein und kommt erst sehr spät in den "roten Bereich", in dem das Stabilitätsprogramm deine Fahrfehler wiedergutmacht. Die Spreizung zwischen komfortablem Fahrwerk und Sportlichkeit ist in den verschiedenen Fahmodi gut spürbar, im Sport-Modus spürt man jedes Steinchen auf der Straße. Ist der komfortable Modus aktiv gleitet man förmlich und könnte sich die Frage stellen, ob das noch ein Passat, oder ein Mini-Phaeton ist. (')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2346, 75, 23, N'Den kompletten Fahrbericht gibt''s hier')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2347, 75, 24, N')')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2348, 75, 25, N'Die AUTO BILD-Erlkönigjäger haben den Passat nun zum ersten Mal mit Serienkarosserie erwischt. Trotz Tarnung lassen sich erste Details erkennen, der AUTO BILD-Zeichner hat bereits virtuell die Tarnfolie abgezogen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2349, 75, 26, N'ZoomSatte 15 Zentimeter wird der neue Passat länger, der Radstand wächst um fünf Zentimeter. Bild: Bernhard Reichel')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2350, 75, 27, N'Satte 15 Zentimeter wird der neue Passat länger, der Radstand wächst um fünf Zentimeter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2351, 75, 28, N'Die neue Frontschürze könnte größere Lufteinlässe erhalten, während der (beim Erlkönig mit einem Aufkleber getarnte) Grill sich zu einem Schlitz zusammenziehen könnte – wie schon beim Golf, Multivan oder anderen aktuellen Modellen mit Verbrenner aus Wolfsburg. Die Nebelscheinwerfer könnten hoch in den Hauptscheinwerfer wandern.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2352, 75, 29, N'BildergalerieKameraVW Passat B9 (2024)7 BilderPfeil')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2353, 75, 30, N'Ebenfalls auffällig: Die Seitenfenster laufen beim Erlkönig spitz zu, das Heck fällt flacher ab, weist weniger Rundungen auf. Die Rückleuchten dürften über ein breites Leuchtenband miteinander verbunden werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2354, 75, 31, N'Außerdem wird Auto länger als das aktuelle Modell. In der Länge wächst er um ganze 15 Zentimeter auf 4,92 Meter an, fünft Zentimeter gibt''s beim Radstand on Top. Mit den Extra-Zentimetern würde nebenbei die Familien-Rangordnung wieder zurechtgerückt, denn der')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2355, 75, 32, N'ebenfalls gewachsene Golf Variant')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2356, 75, 33, N'ist dem Passat zuletzt arg nahegekommen.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2357, 75, 34, N'Vor allem die Fond-Passagiere und der Kofferraum würden profitieren. Das Gepäckabteil könnte mehr als 1800 Liter fassen, aktuell sind es 1780 Liter.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2358, 75, 35, N'Auch der neue Passat nutzt die MQB-Plattform, antriebsseitig sind deshalb keine allzu großen Überraschungen zu erwarten. Denkbar wären zwei per doppeltem SCR-System gereinigte Zweiliter-Diesel mit rund 150 und 200 PS, dazu klassische Benziner (voraussichtlich rund 150 und 220 PS) und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2359, 75, 36, N'Plug-in-Hybride')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2360, 75, 37, N'.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2361, 75, 38, N'ANZEIGENeuwagen kaufenIn Kooperation mitIn Kooperation mitDer clevere Weg zum Neuwagen!Lokale Preise für ihr Wunschauto vergleichen.Ihre Vorteile:Großartige PreiseVon lokalen HändlernNur deutsche NeuwagenStressfrei & ohne VerhandelnMarkeBitte auswählenModellBitte auswählenAngebote vergleichen* Die durchschnittliche Ersparnis berechnet sich im Vergleich zur unverbindlichen Preisempfehlung des Herstellers aus allen auf carwow errechneten Konfigurationen zwischen Januar und Juni 2022. Sie ist ein Durchschnittswert aller angebotenen Modelle und variiert je nach Hersteller, Modell und Händler.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2362, 75, 39, N'Die Plug-in-Varianten könnten ebenfalls in zwei Leistungsstufen vorfahren. Das Topmodell kommt wohl auf rund 250 PS, der schwächere Antrieb knackt wahrscheinlich die 200-PS-Marke. Wichtiger als die Power ist beim Hybrid-Passat die elektrische')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2363, 75, 40, N'Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2364, 75, 41, N': Mit einem 20-kWh-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2365, 75, 42, N'Akku')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2366, 75, 43, N'könnten 100 Kilometer drin sein.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2367, 75, 44, N'Außerdem dürfte VW bei der Ladetechnik nachlegen: Statt 3,6 kW wären 11 kW Ladeleistung möglich – damit wäre der Akku nach rund zwei Stunden wieder voll.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2368, 75, 45, N'Die neue Generation des VW Passat (Baucode B9) kommt')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2369, 75, 46, N'wohl nur noch als Kombi namens Variant')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2370, 75, 47, N'und könnte 2023 vorgestellt werden. Bei den Händlern dürfte der neue Passat allerdings erst 2024 zu finden sein. Mit ordentlicher Basisausstattung könnten die Preise ab 35.000 Euro starten. Die AUTO BILD-Erlkönigjäger ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2371, 75, 48, N'... haben den Passat nun zum ersten Mal mit Serienkarosserie erwischt. Trotz Tarnung lassen sich erste Details erkennen: Die neue Frontschürze scheint größere Lufteinlässe zu erhalten, während der (beim Erlkönig mit einem Aufkleber getarnte) Grill sich zu einem Schlitz zusammenziehen könnte – wie schon ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2372, 75, 49, N'... beim Golf, Multivan oder anderen aktuellen Modellen mit Verbrenner aus Wolfsburg. Die Nebelscheinwerfer könnten hoch in den Hauptscheinfwerfer wandern. Ebenfalls auffällig: Die Seitenfenster laufen beim Erlkönig spitz zu, das Heck fällt flacher ab, weist weniger Rundungen auf. Die Rückleuchten dürften über ein breites Leuchtenband miteinander verbunden werden.')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2373, 75, 50, N'AUTO BILD hat die Tarnfolie einmal virtuell abgenommen und zeigt, wie die neue Generation schlussendlich aussehen könnte (Bild). Auf den ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2374, 75, 51, N'... Erlkönigbildern wirkt der Kombi länger als das aktuelle Modell. Das könnte unsere Vermutung bestätigen, dass der nächste Passat den Radstand des Skoda Superb übernehmen wird. Dann würde er um fünf Zentimeter auf gut 4,85 Meter Länge wachsen. Vor allem die Fond-Passagiere und der Kofferraum würden profitieren. Das Gepäckabteil könnte über 1800 Liter fassen, ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2375, 75, 52, N'... aktuell sind es 1780 Liter. Auch der neue Passat nutzt die MQB-Plattform, antriebsseitig sind deshalb keine allzu großen Überraschungen zu erwarten. Denkbar wären zwei Zweiliter-Diesel mit rund 150 und 200 PS, dazu klassische Benziner (voraussichtlich rund 150 und 220 PS) und')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2376, 75, 53, N'Plug-in-Hybride')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2377, 75, 54, N'. Letztere ...')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2378, 75, 55, N'... könnten ebenfalls in zwei Leistungsstufen vorfahren. Das Topmodell kommt wohl auf rund 250 PS, der schwächere Antrieb knackt wahrscheinlich die 200-PS-Marke. Wichtiger als die Power ist beim Plug-in die')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2379, 75, 56, N'Reichweite')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2380, 75, 57, N': Mit einem 20-kWh-')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2381, 75, 58, N'Akku')
GO
INSERT [dbo].[ArticleContents] ([Id], [article_Id], [LineIndex], [ContentLine]) VALUES (2382, 75, 59, N'könnten 100 Kilometern drin sein.')
GO
SET IDENTITY_INSERT [dbo].[ArticleContents] OFF
GO
SET IDENTITY_INSERT [dbo].[Articles] ON 
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (1, 3, 1348, NULL, N'''Baby Defender'' to join JLR''s compact SUV lineup by 2027', N'CEO confirms sign-off of long-awaited 4x4 as an Evoque sibling likely to be called the Defender Sport', N'Felix Page', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/new-cars/baby-defender-join-jlrs-compact-suv-lineup-2027')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (2, 3, 1348, NULL, N'Under the skin: autonomous cars still have a long way to go', NULL, N'Jesse Crosse', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/technology/under-skin-autonomous-cars-still-have-long-way-go')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (3, 3, 1348, NULL, N'Lexus RZ 2023 long-term test', NULL, N'Jesse Crosse', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-review/lexus/rz/long-term-reviews/lexus-rz-2023-long-term-test')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (4, 3, 1348, NULL, N'Volkswagen California T7: PHEV campervan confirmed for 2024', NULL, N'Charlie Martin', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/new-cars/volkswagen-california-t7-phev-campervan-confirmed-2024')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (5, 3, 1348, NULL, N'Best ULEZ-compliant used cars', NULL, N'Autocar', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/used-cars-second-hand-picks/best-ulez-compliant-used-cars')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (6, 3, 1348, NULL, N'Used car buying guide: Renault Scenic', NULL, N'John Evans', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/used-cars-used-car-buying-guides/used-car-buying-guide-renault-scenic')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (7, 3, 1348, NULL, N'Audi RS6 saloon primed for electric comeback in 2025', NULL, N'Greg Kable', N'2023-08-04 00:00', N'https://www.autocar.co.uk//car-news/new-cars/audi-rs6-saloon-primed-electric-comeback-2025')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (8, 3, 1348, NULL, N'2025 Fisker Pear urban EV to arrive with room for six from £28,000', NULL, N'Will Rimell', N'2023-08-04 00:00', N'https://www.autocar.co.uk//car-news/new-cars/2025-fisker-pear-urban-ev-arrive-room-six-%C2%A328000')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (9, 3, 1348, NULL, N'Non-ULEZ-compliant classics at bargain prices', NULL, N'Charlie Martin', N'2023-08-04 00:00', N'https://www.autocar.co.uk//car-news/used-cars-second-hand-picks/non-ulez-compliant-classics-bargain-prices')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (10, 3, 1348, NULL, N'The most obscure Fords ever sold', NULL, N'Charlie Martin', N'2023-08-07 00:00', N'https://www.autocar.co.uk//slideshow/most-obscure-fords-ever-sold-1')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (11, 3, 1348, NULL, NULL, N'Mercedes’ ‘old-timer’ roadster is off in a sportier direction, but is it the right one?', N'Charlie Martin', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-review/mercedes-amg/sl')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (12, 3, 1348, NULL, NULL, N'Time’s up for atmo-V8-engined, rear-driven, manual-shift muscle cars, right? Wrong, says seventh-generation ''Stang', N'Charlie Martin', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-review/ford/mustang-dark-horse')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (13, 3, 1348, NULL, NULL, N'Californian-based EV brand Fisker goes after style-savvy, range-conscious buyers with its first production model', N'Charlie Martin', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-review/fisker/ocean')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (14, 3, 1348, NULL, N'West Midlands battery factory ''hopeful'' of government support', NULL, N'Charlie Martin', N'2023-07-25 00:00', N'https://www.autocar.co.uk//car-news/business-infrastructure/west-midlands-battery-factory-hopeful-government-support')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (15, 3, 1348, NULL, N'How Jaguar rebuilds from a position of ''no equity whatsoever''', NULL, N'Nick Gibbs', N'2023-07-24 00:00', N'https://www.autocar.co.uk//car-news/business-finance/how-jaguar-rebuilds-position-no-equity-whatsoever')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (16, 3, 1348, NULL, N'Editor''s letter: Is Tata''s gigafactory the saviour of UK automotive?', NULL, N'Mark Tisshaw', N'2023-07-21 00:00', N'https://www.autocar.co.uk//opinion/business-manufacturing/editors-letter-tatas-gigafactory-saviour-uk-automotive')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (17, 3, 1348, NULL, N'Best ULEZ-compliant used cars', N'You don''t need to buy new to replace your car if it doesn''t comply with ULEZ standards. Here are our top used picksRead more', N'Autocar', N'2023-08-07 00:00', N'https://www.autocar.co.uk//car-news/used-cars-second-hand-picks/best-ulez-compliant-used-cars')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (18, 3, 1348, NULL, N'Used car buying guide: Alfa Romeo 4C', NULL, N'John Evans', N'2023-07-31 00:00', N'https://www.autocar.co.uk//car-news/used-cars-used-car-buying-guides/used-car-buying-guide-alfa-romeo-4c')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (19, 5, 1348, N'VW T6: Kunden klagen an', N'Motorschäden auch beim neuen Bulli', NULL, N'Roland Kontny', N'2023-08-07 06:00', N'https://www.autobild.de/artikel/vw-t6-probleme-mit-dieselmotor-22893247.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (20, 5, 1348, N'Mercedes-AMG GLC', N'Das kostet der Einstiegs-AMG des GLC', NULL, N'Sebastian Friemel', N'2023-08-07 06:00', N'https://www.autobild.de/artikel/mercedes-amg-glc-2023-vorstellung-22862019.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (21, 5, 1348, N'Camping-Trends und Camping-Ziele 2023', N'Neues vom Campingplatz', NULL, NULL, N'2023-08-07 06:00', N'https://www.autobild.de/artikel/camping-trends-und-camping-ziele-2023-22861777.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (22, 5, 1348, N'Die besten Marken in allen Klassen', N'Große Image-Studie – das sind Ihre Lieblinge!', NULL, NULL, NULL, N'https://aktionen.autobild.de/die-besten-marken/')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (23, 5, 1348, N'Alle kommenden BMW-Modelle bis 2025', N'Der neue 5er und i5, X3, i3 und Co', NULL, N'Peter R. Fischer', N'2023-08-07 06:00', N'https://www.autobild.de/artikel/alle-kommenden-bmw-modelle-bis-2025-1292770.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (24, 5, 1348, N'Gebrauchtwagen-Angebot', N'Glücksbringer gefällig? Renault Talisman gebraucht zu kaufen', NULL, N'Andreas Reiners', N'2023-08-06 20:34', N'https://www.autobild.de/artikel/gebrauchtwagen-angebot-renault-talisman-fuer-unter-30.000-euro-22896395.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (25, 5, 1348, N'Wissen über BMWs Werkstuner', N'9 Fakten rund um die M GmbH, die nicht jeder kennt', NULL, N'Jonas Uhlig', N'2023-07-14 18:26', N'https://www.autobild.de/artikel/m-gmbh-wissen-ueber-bmws-werkstuner-22843001.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (26, 5, 1348, N'Lkw mit Düsenantrieb und gut 64.000 PS', N'Dieser Truck hat das Triebwerk eines Abfangjägers', NULL, N'Jonas Uhlig', N'2023-07-10 09:45', N'https://www.autobild.de/artikel/ps-days-2023-in-hannover-lkw-mit-duesenantrieb-22841663.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (27, 5, 1348, N'Opel Vectra A: Tuning', N'Von wegen Rentnerauto! Ein Vectra für die Viertelmeile', NULL, N'Kim-Sarah Biehl', N'2023-07-10 09:44', N'https://www.autobild.de/artikel/opel-vectra-a-tuning-ps-days-22843129.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (28, 5, 1348, N'PS Days 2023 in Hannover', N'Ein Klassiker mit Summer Vibes: VW Typ 181', NULL, NULL, N'2023-07-10 06:00', N'https://www.autobild.de/artikel/ps-days-2023-in-hannover-vw-typ-181-22840557.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (29, 5, 1348, N'Suzuki Swift Sport: PS Days', N'Getunter Swift als Daily mit 197.000 km nach fünf Jahren', NULL, N'Jonas Uhlig', N'2023-07-09 21:00', N'https://www.autobild.de/artikel/suzuki-swift-sport-tuning-ps-days-2023-in-hannover-22842973.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (30, 5, 1348, N'Getunter BMW Z4 M40i im Test', N'So fühlen sich 400 PS im getunten Z4 Roadster an', NULL, N'Sebastian Friemel', N'2023-07-09 21:00', N'https://www.autobild.de/artikel/ac-schnitzer-bmw-z4-m40i-im-test-22841825.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (31, 5, 1348, N'Honda NSX NA1', N'Japanische Legende mit Leichtbau', NULL, N'Kim-Sarah Biehl', N'2023-07-08 21:10', N'https://www.autobild.de/artikel/honda-nsx-na1-mit-carbon-kleid-22843045.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (32, 5, 1348, N'Kommentar zur Ladies Lounge', N'Frauenbereich auf Tuningmesse: Total überflüssig!', NULL, N'Robin Hornig', N'2023-07-08 21:00', N'https://www.autobild.de/artikel/ps-days-kommentar-zur-ladies-lounge-auf-tuningmesse-22842719.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (33, 5, 1348, N'Getunter Mini Cooper', N'Tuning muss nicht immer extrem sein, wie dieser Mini zeigt', NULL, N'Sebastian Friemel', N'2023-07-08 20:45', N'https://www.autobild.de/artikel/dezent-getunter-mini-cooper-auf-den-ps-days-in-hannover-22843349.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (34, 5, 1348, N'DTM: Paul gewinnt im Grasser-Lambo', N'Youngster trumpfen im Regen am Nürburgring auf', NULL, N'Frederik Hackbarth', N'2023-08-06 15:28', N'https://www.autobild.de/artikel/dtm-paul-gewinnt-im-grasser-lambo-22896311.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (35, 5, 1348, N'DTM: Rennkalender 2024', N'DTM präsentiert neuen Rennkalender für nächste Saison', NULL, N'Frederik Hackbarth', N'2023-08-06 12:36', N'https://www.autobild.de/artikel/dtm-rennkalender-2024-22896367.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (36, 5, 1348, N'DTM: Kurioser Restart sorgt für Ärger', N'Ekel-Wette bei Auer, Frust über "Bummel"-Perera', NULL, N'Frederik Hackbarth', N'2023-08-05 19:10', N'https://www.autobild.de/artikel/dtm-kurioser-restart-sorgt-fuer-diskussionen-22896089.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (37, 5, 1348, N'DTM: Lambo-Erfolg am Nürburgring', N'Bortolotti feiert Premierensieg in der DTM', NULL, N'Frederik Hackbarth', N'2023-08-05 16:10', N'https://www.autobild.de/artikel/dtm-lambo-erfolg-am-nuerburgring-22896047.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (38, 5, 1348, N'Formel 1: Verstappen auf Rekordjagd', N'Alle Rennen gewonnen: Gelingt Red Bull die perfekte Saison?', NULL, N'Frederik Hackbarth', N'2023-08-04 16:00', N'https://www.autobild.de/artikel/formel-1-verstappen-auf-rekordjagd-22895219.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (39, 5, 1348, N'DTM: Rast fordert mehr Förderung', N'"Im deutschen Motorsport fehlt das Geld"', NULL, N'Bianca Garloff', N'2023-08-04 12:00', N'https://www.autobild.de/artikel/dtm-rene-rast-fordert-mehr-nachwuchsfoerderung-22886545.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (40, 5, 1348, N'Neues Topmodell kommt 2024', N'Audi arbeitet an einer neuen Hardcore-Version des RS 6', NULL, N'Jan Götze', N'2023-07-26 06:00', N'https://www.autobild.de/artikel/audi-rs-6-gt-2024-wird-neues-topmodell-22877511.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (41, 5, 1348, N'Ford Mustang Dark Horse Hennessey 850', N'Hennessey-Upgrade mit 850 PS für den Mustang', NULL, N'Sebastian Friemel', N'2023-07-21 05:00', N'https://www.autobild.de/artikel/ford-mustang-dark-horse-hennessey-850-22869387.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (42, 5, 1348, N'Mazda MX-5 NC mit 126 PS bei eBay', N'Knallroter MX-5 wurde nur bei gutem Wetter gefahren', NULL, N'Lars Hänsch-Petersen', N'2023-07-20 06:00', N'https://www.autobild.de/artikel/mazda-mx-5-nc-mit-126-ps-bei-ebay-22867903.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (43, 5, 1348, N'Ab Dezember 2023 erhältlich', N'Cayman GT4 RS Manthey Kit: 7000 Euro pro Sekunde', NULL, N'Jan Götze', N'2023-07-19 06:00', N'https://www.autobild.de/artikel/porsche-718-cayman-gt4-rs-manthey-kit-22864891.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (44, 5, 1348, N'Sport-SUV mit 300 PS', N'Der BMW X1 M35i erfüllt gleich drei Wünsche auf einmal', NULL, N'Alexander Bernt', N'2023-07-16 06:00', N'https://www.autobild.de/artikel/bmw-x1-m35i-sport-suv-mit-300-ps-22850941.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (45, 5, 1348, N'Subaru BRZ im Test', N'Der BRZ mit Boxer-Saugmotor ist ein Exot auf ganzer Linie', NULL, N'Jan Horn', N'2023-07-16 06:00', N'https://www.autobild.de/artikel/subaru-brz-im-test-22758733.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (46, 5, 1348, N'Jetzt auch mit V8-Twinturbo', N'Der Koenigsegg Gemera ist das stärkste Serienauto der Welt', NULL, N'Jan Götze', N'2023-07-13 06:00', N'https://www.autobild.de/artikel/koenigsegg-gemera-2023-jetzt-auch-mit-v8-16477519.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (47, 5, 1348, N'48 Monate Laufzeit, 10.000 km pro Jahr', N'So viel kostet ein Porsche Macan GTS im Privatleasing', NULL, N'Jan Götze', N'2023-06-29 10:06', N'https://www.autobild.de/artikel/porsche-macan-gts-2023-ist-im-leasing-kein-schnaeppchen-22820407.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (48, 5, 1348, N'Der Weg ist das Ziel', N'Mit einem Ferrari 296 GTS nach Le Mans', NULL, N'Alexander Bernt', N'2023-06-28 06:00', N'https://www.autobild.de/artikel/ferrari-296-gts-road-to-le-mans-22777937.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (49, 5, 1348, N'Simson S51 Comfort bei eBay', N'Diese schöne Simson S51 wurde neu aufgebaut', NULL, N'Lars Hänsch-Petersen', N'2023-07-28 12:21', N'https://www.autobild.de/artikel/simson-s51-comfort-bei-ebay-22878045.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (50, 5, 1348, N'BMW R80 Scrambler bei eBay', N'Wow, was für eine coole BMW!', NULL, N'Lars Hänsch-Petersen', N'2023-07-27 06:00', N'https://www.autobild.de/artikel/bmw-r80-scrambler-bei-ebay-22880071.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (51, 5, 1348, N'BMW R 1200 C bei eBay', N'James-Bond-Chopper von BMW für kleines Geld', NULL, N'Lars Hänsch-Petersen', N'2023-07-24 06:00', N'https://www.autobild.de/artikel/bmw-r-1200-c-bei-ebay-22872859.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (52, 5, 1348, N'Suzuki Hayabusa 25th Anniversary Edition', N'Unglaublich! Suzukis 300-km/h-Rakete wird 25', NULL, N'Lars Hänsch-Petersen', N'2023-07-16 06:00', N'https://www.autobild.de/artikel/suzuki-hayabusa-25th-anniversary-edition-22850237.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (53, 5, 1348, N'Suzuki GS 1000 "Wes Cooley" bei eBay', N'Dieser Cafe-Racer ist eine coole Yoshimura-Replik', NULL, N'Lars Hänsch-Petersen', N'2023-07-15 06:00', N'https://www.autobild.de/artikel/suzuki-gs-1000-wes-cooley-bei-ebay-22859371.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (54, 5, 1348, N'BMW CE 02: erster Kontakt', N'Jippie, BMW hat eine elektrische Honda Dax gebaut', NULL, N'Lars Hänsch-Petersen', N'2023-07-07 19:30', N'https://www.autobild.de/artikel/bmw-ce-02-erster-kontakt-22832039.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (55, 5, 1348, N'Yamaha TT 500 bei eBay', N'Schwester der Yamaha XT 500 zum günstigen Preis', NULL, N'Lars Hänsch-Petersen', N'2023-06-23 06:00', N'https://www.autobild.de/artikel/yamaha-tt-500-bei-ebay-22804855.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (56, 5, 1348, N'BMW F 800 GS bei eBay', N'Hübsche BMW GS ist ein bezahlbares Unikat', NULL, N'Lars Hänsch-Petersen', N'2023-06-22 06:00', N'https://www.autobild.de/artikel/bmw-f-800-gs-ebay-deal-22800971.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (57, 5, 1348, N'Simson S51 bei eBay', N'Hübsche Simson S51 als Enduro-Umbau', NULL, N'Lars Hänsch-Petersen', N'2023-06-16 08:16', N'https://www.autobild.de/artikel/simson-s51-bei-ebay-22746859.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (58, 5, 1348, N'Irmscher Opel Astra Sports Tourer', N'Irmscher schärft den brandneuen Kombi-Astra nach', NULL, N'Peter R. Fischer', N'2022-10-28 06:00', N'https://www.autobild.de/artikel/irmscher-opel-astra-sports-tourer-2022-tuning-is1-is2-is3-spoiler-fahrwerk-felgen-22236261.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (59, 5, 1348, N'Firmenwagen: Besteuerung von E-Autos', N'Viertel-Regelung für Elektro-Dienstwagen', NULL, N'Lena Trautermann', N'2021-12-15 06:00', N'https://www.autobild.de/artikel/elektroauto-firmenwagen-regelung-14414867.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (60, 5, 1348, N'Der AUTO BILD Firmenwagen Award 2021', N'Jetzt abstimmen und gewinnen!', NULL, NULL, N'2021-09-14 06:00', N'https://www.autobild.de/artikel/der-auto-bild-firmenwagen-award-2021-20513945.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (61, 5, 1348, N'Audi A3 Sportback 40 TFSI e', N'Audi A3 Sportback für 89 Euro leasen', NULL, N'Jan Götze', N'2021-03-31 14:24', N'https://www.autobild.de/artikel/audi-a3-sportback-40-tfsi-e-2021-leasing-preis-plug-in-hybrid-19455429.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (62, 5, 1348, N'Renault Zoe (2021): Leasing', N'Renault Zoe für nur 37,90 Euro leasen', NULL, N'Jan Götze', N'2021-03-30 11:15', N'https://www.autobild.de/artikel/renault-zoe-2021-leasing-preis-elektro-kaufen-guenstig-19451459.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (63, 5, 1348, N'VW Multivan (2021): Leasing', N'VW Multivan T6.1 für 259 Euro leasen', NULL, N'Jan Götze', N'2021-03-29 10:39', N'https://www.autobild.de/artikel/vw-multivan-2021-leasing-preis-guenstig-t6.1-bus-diesel-19447555.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (64, 5, 1348, N'VW Touareg R-Line (2021): Leasing', N'VW Touareg R-Line günstig leasen', NULL, N'Jan Götze', N'2021-03-25 10:46', N'https://www.autobild.de/artikel/vw-touareg-r-line-2021-leasing-preis-guenstig-kaufen-19436765.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (65, 5, 1348, N'Skoda Enyaq iV 50 (2021): Leasing', N'Skoda Enyaq für 199 Euro brutto leasen', NULL, N'Jan Götze', N'2021-03-23 10:48', N'https://www.autobild.de/artikel/skoda-enyaq-iv-50-2021-leasing-preis-elektro-guenstig-19424477.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (66, 5, 1348, N'Die besten Firmenwagen 2020', N'Echte Siegertypen', NULL, NULL, N'2020-12-07 14:53', N'https://www.autobild.de/artikel/die-besten-firmenwagen-2020-18626951.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (67, 5, 1348, N'Gebrauchter Corsa E im Angebot', N'Kleinwagen mit geringer Laufleistung', NULL, N'Jens Borkum', N'2023-08-06 06:00', N'https://www.autobild.de/artikel/opel-corsa-gebrauchter-corsa-e-im-angebot-22894161.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (68, 5, 1348, N'Lidl und Aldi-Angebote', N'Günstiges Akku-Werkzeug bei Lidl und Aldi', NULL, NULL, N'2023-08-06 06:00', N'https://www.autobild.de/artikel/angebot-der-woche-bei-lidl-werkzeug-deal-preis-22893963.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (69, 5, 1348, N'Toyota Land Cruiser im Retrolook', N'Sondermodell mit 4,5-Liter-Diesel-V8', NULL, N'Kim-Sarah Biehl', N'2023-08-06 06:00', N'https://www.autobild.de/artikel/toyota-land-cruiser-2024-mit-4-5-liter-diesel-v8-22891723.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (70, 5, 1348, N'Es kommt auf den Verstoß an', N'Gefängnis möglich! So hart sind die Strafen bei Rotlichtverstoß', NULL, N'Andreas Reiners', N'2023-08-05 10:07', N'https://www.autobild.de/artikel/geldstrafe-bis-gefaengnis-die-harten-strafen-bei-einem-rotlichtverstoss-22895875.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (71, 5, 1348, N'Gebrauchtwagen-Angebot', N'Der günstigste Neuwagen als Gebrauchter: Dacia Sandero im Angebot', NULL, N'Andreas Reiners', N'2023-08-05 09:47', N'https://www.autobild.de/artikel/gebrauchtwagen-angebot-dacia-sandero-fuer-8.000-euro-22895799.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (72, 5, 1348, N'E-Autos boomen, Plug-ins schwächeln', N'Neuzulassungen im Minus: Ist der Plug-in-Hybrid am Ende?', NULL, N'Roland Kontny', N'2023-08-05 06:00', N'https://www.autobild.de/artikel/pkw-zulassungen-im-1.-halbjahr-2023-22888197.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (73, 5, 1348, N'Neue Mercedes- und AMG-Modelle bis 2025', N'Kommt so die AMG-Variante des neuen CLE Coupés?', NULL, N'Jan Götze', N'2023-08-05 06:00', N'https://www.autobild.de/artikel/neue-mercedes-und-amg-modelle-2023-2024-und-2025--1292782.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (74, 5, 1348, N'Auto-Abo: Schnäppchen für Privatkunden', N'Ford Puma ST X für nur 399 Euro im Auto-Abo', NULL, NULL, N'2023-08-04 12:00', N'https://www.autobild.de/artikel/auto-abo-schnaeppchen-fuer-privatkunden-22894233.html')
GO
INSERT [dbo].[Articles] ([Id], [Site_Id], [Session_Id], [Overline], [Headline], [Subline], [Author], [PublicDate], [Url]) VALUES (75, 5, 1348, N'Neuer VW Passat B9 (2024)', N'Erste Fahrt im Prototyp – und so könnte er in Serie gehen', NULL, N'Katharina Berndt', N'2023-08-04 10:06', N'https://www.autobild.de/artikel/vw-passat-2024-motoren-limousine-gestrichen-innenraum-variant-plug-in-hybrid-kofferraum-marktstart-preis-18760729.html')
GO
SET IDENTITY_INSERT [dbo].[Articles] OFF
GO
SET IDENTITY_INSERT [dbo].[Sessions] ON 
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (2, CAST(N'2023-07-04T13:58:07.973' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (4, CAST(N'2023-07-04T14:01:05.610' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (5, CAST(N'2023-07-04T14:09:10.050' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (10, CAST(N'2023-07-04T15:15:17.170' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (12, CAST(N'2023-07-04T15:15:44.347' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (13, CAST(N'2023-07-04T15:16:39.673' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (14, CAST(N'2023-07-04T15:19:13.420' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (15, CAST(N'2023-07-04T15:20:58.530' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (16, CAST(N'2023-07-04T15:39:19.200' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (17, CAST(N'2023-07-04T15:39:34.777' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (18, CAST(N'2023-07-04T15:39:56.033' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (19, CAST(N'2023-07-04T15:41:40.567' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (20, CAST(N'2023-07-04T15:41:48.860' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (21, CAST(N'2023-07-04T16:46:18.987' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (22, CAST(N'2023-07-04T16:46:57.930' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (23, CAST(N'2023-07-04T16:50:53.060' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (24, CAST(N'2023-07-04T16:51:36.440' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (25, CAST(N'2023-07-04T17:49:33.227' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (26, CAST(N'2023-07-04T17:50:32.710' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (27, CAST(N'2023-07-04T17:57:39.197' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (28, CAST(N'2023-07-04T17:58:18.437' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (30, CAST(N'2023-07-04T18:01:05.747' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (31, CAST(N'2023-07-04T18:02:25.560' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (32, CAST(N'2023-07-04T18:03:18.030' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (33, CAST(N'2023-07-04T18:04:41.253' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (34, CAST(N'2023-07-04T18:04:55.027' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (35, CAST(N'2023-07-04T18:05:08.820' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (36, CAST(N'2023-07-04T18:09:09.387' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (37, CAST(N'2023-07-04T18:09:31.643' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (38, CAST(N'2023-07-04T18:09:57.023' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (39, CAST(N'2023-07-04T18:41:38.517' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (40, CAST(N'2023-07-04T21:41:08.927' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (41, CAST(N'2023-07-05T15:41:03.450' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (42, CAST(N'2023-07-05T15:42:06.970' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (43, CAST(N'2023-07-06T10:16:59.917' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (44, CAST(N'2023-07-06T10:31:36.790' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (45, CAST(N'2023-07-06T22:51:05.870' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (46, CAST(N'2023-07-07T12:06:59.097' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (47, CAST(N'2023-07-07T12:12:10.200' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (48, CAST(N'2023-07-07T12:13:31.780' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (49, CAST(N'2023-07-07T12:13:52.530' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (50, CAST(N'2023-07-07T12:14:16.940' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (51, CAST(N'2023-07-07T12:24:42.147' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (52, CAST(N'2023-07-07T12:25:28.733' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (53, CAST(N'2023-07-07T12:26:41.553' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (54, CAST(N'2023-07-07T12:28:32.913' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (55, CAST(N'2023-07-07T12:30:07.930' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (56, CAST(N'2023-07-07T12:32:08.160' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (57, CAST(N'2023-07-07T12:33:59.010' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (58, CAST(N'2023-07-07T12:37:14.770' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (59, CAST(N'2023-07-07T12:37:33.610' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (60, CAST(N'2023-07-07T12:39:36.927' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (61, CAST(N'2023-07-07T12:41:03.083' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (62, CAST(N'2023-07-07T12:41:51.513' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (63, CAST(N'2023-07-07T12:43:32.860' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (64, CAST(N'2023-07-07T12:45:24.317' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (65, CAST(N'2023-07-07T12:47:35.163' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (66, CAST(N'2023-07-07T12:48:47.560' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (67, CAST(N'2023-07-07T12:52:37.690' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (68, CAST(N'2023-07-07T12:53:16.790' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (69, CAST(N'2023-07-07T14:50:17.427' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (70, CAST(N'2023-07-07T14:51:57.727' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (71, CAST(N'2023-07-07T16:33:52.233' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (72, CAST(N'2023-07-07T16:34:41.653' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (73, CAST(N'2023-07-07T19:36:50.743' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (74, CAST(N'2023-07-07T19:37:07.307' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (75, CAST(N'2023-07-07T19:37:31.643' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (76, CAST(N'2023-07-07T19:43:31.813' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (77, CAST(N'2023-07-07T19:43:44.367' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (78, CAST(N'2023-07-07T19:44:11.513' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (79, CAST(N'2023-07-07T19:44:39.913' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (80, CAST(N'2023-07-07T19:45:48.907' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (81, CAST(N'2023-07-07T19:46:00.340' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (82, CAST(N'2023-07-07T19:58:10.803' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (83, CAST(N'2023-07-07T20:01:31.683' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (84, CAST(N'2023-07-07T20:10:17.050' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (85, CAST(N'2023-07-07T20:12:37.407' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (86, CAST(N'2023-07-07T20:13:05.593' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (87, CAST(N'2023-07-07T20:16:55.700' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (88, CAST(N'2023-07-07T20:19:19.980' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (89, CAST(N'2023-07-07T20:20:05.110' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (90, CAST(N'2023-07-07T20:20:18.150' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (91, CAST(N'2023-07-07T20:21:08.720' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (92, CAST(N'2023-07-08T16:10:09.753' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (93, CAST(N'2023-07-08T16:13:17.323' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (94, CAST(N'2023-07-09T11:04:31.580' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (95, CAST(N'2023-07-09T12:48:38.260' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (96, CAST(N'2023-07-09T12:49:53.343' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (97, CAST(N'2023-07-09T13:04:17.953' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (98, CAST(N'2023-07-09T13:06:32.040' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (99, CAST(N'2023-07-09T13:07:32.660' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (100, CAST(N'2023-07-09T13:58:10.343' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (101, CAST(N'2023-07-10T13:34:03.673' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (102, CAST(N'2023-07-10T13:39:58.823' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (103, CAST(N'2023-07-10T13:41:06.393' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (104, CAST(N'2023-07-10T13:41:18.503' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (105, CAST(N'2023-07-10T13:44:25.230' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (106, CAST(N'2023-07-10T16:35:41.310' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (107, CAST(N'2023-07-10T16:35:59.860' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (108, CAST(N'2023-07-10T23:16:35.740' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (109, CAST(N'2023-07-10T23:22:04.017' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (110, CAST(N'2023-07-11T12:29:27.340' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (111, CAST(N'2023-07-11T12:30:05.053' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (112, CAST(N'2023-07-11T12:30:27.430' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (113, CAST(N'2023-07-11T12:41:03.450' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (114, CAST(N'2023-07-11T12:41:55.750' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (115, CAST(N'2023-07-11T12:42:26.043' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (116, CAST(N'2023-07-11T12:43:56.847' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (117, CAST(N'2023-07-11T12:46:01.970' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (118, CAST(N'2023-07-11T12:58:46.933' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (119, CAST(N'2023-07-11T16:02:19.400' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (120, CAST(N'2023-07-11T19:46:25.660' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (121, CAST(N'2023-07-11T20:31:57.090' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (122, CAST(N'2023-07-11T22:52:14.737' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (123, CAST(N'2023-07-12T00:06:56.347' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (124, CAST(N'2023-07-12T00:12:45.220' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (125, CAST(N'2023-07-12T00:13:20.203' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (126, CAST(N'2023-07-12T15:42:56.273' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (127, CAST(N'2023-07-12T15:45:17.253' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (128, CAST(N'2023-07-12T15:48:29.267' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (129, CAST(N'2023-07-12T17:21:16.873' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (130, CAST(N'2023-07-12T17:52:38.767' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (131, CAST(N'2023-07-12T17:54:43.250' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (132, CAST(N'2023-07-12T18:13:33.160' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (133, CAST(N'2023-07-12T18:15:13.513' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (134, CAST(N'2023-07-12T18:17:29.380' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (135, CAST(N'2023-07-12T18:18:27.443' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (136, CAST(N'2023-07-12T19:11:51.637' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (137, CAST(N'2023-07-12T19:24:55.563' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (138, CAST(N'2023-07-12T19:28:16.580' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (139, CAST(N'2023-07-12T19:29:02.463' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (140, CAST(N'2023-07-12T19:29:58.410' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (141, CAST(N'2023-07-12T19:30:36.023' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (142, CAST(N'2023-07-12T19:31:32.333' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (143, CAST(N'2023-07-12T19:32:00.330' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (144, CAST(N'2023-07-12T19:33:16.070' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (145, CAST(N'2023-07-12T19:35:54.437' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (146, CAST(N'2023-07-12T19:36:34.777' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (147, CAST(N'2023-07-12T19:37:26.640' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (148, CAST(N'2023-07-12T19:38:53.593' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (149, CAST(N'2023-07-12T19:41:04.613' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (150, CAST(N'2023-07-12T19:42:05.360' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (151, CAST(N'2023-07-12T19:43:56.140' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (152, CAST(N'2023-07-12T19:44:31.857' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (153, CAST(N'2023-07-12T19:47:35.870' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (154, CAST(N'2023-07-12T19:48:01.480' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (155, CAST(N'2023-07-12T19:49:16.890' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (156, CAST(N'2023-07-12T19:50:07.980' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (157, CAST(N'2023-07-12T19:50:25.707' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (158, CAST(N'2023-07-12T19:51:40.260' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (159, CAST(N'2023-07-13T09:53:28.363' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (160, CAST(N'2023-07-13T09:54:31.647' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (161, CAST(N'2023-07-13T09:55:30.867' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (162, CAST(N'2023-07-13T09:56:07.347' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (163, CAST(N'2023-07-13T09:57:40.643' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (164, CAST(N'2023-07-13T09:57:59.830' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (165, CAST(N'2023-07-13T09:58:18.237' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (166, CAST(N'2023-07-13T09:59:08.390' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (167, CAST(N'2023-07-13T11:24:31.120' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (168, CAST(N'2023-07-13T11:25:44.320' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (169, CAST(N'2023-07-13T11:26:39.370' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (170, CAST(N'2023-07-13T11:27:42.310' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (171, CAST(N'2023-07-13T11:28:17.157' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (172, CAST(N'2023-07-13T11:28:33.660' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (173, CAST(N'2023-07-13T11:39:06.140' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (174, CAST(N'2023-07-13T11:39:53.423' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (175, CAST(N'2023-07-13T11:40:03.017' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (176, CAST(N'2023-07-13T11:40:40.203' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (177, CAST(N'2023-07-13T11:40:57.393' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (178, CAST(N'2023-07-13T11:43:08.743' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (179, CAST(N'2023-07-13T11:44:11.353' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (180, CAST(N'2023-07-13T11:58:54.983' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (181, CAST(N'2023-07-13T11:59:13.533' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (182, CAST(N'2023-07-13T12:06:47.157' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (183, CAST(N'2023-07-15T09:37:19.533' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (184, CAST(N'2023-07-15T09:37:55.857' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (185, CAST(N'2023-07-15T09:40:15.390' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (186, CAST(N'2023-07-15T09:41:46.460' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (187, CAST(N'2023-07-16T09:21:24.310' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (188, CAST(N'2023-07-16T09:25:29.680' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (189, CAST(N'2023-07-16T09:29:53.373' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (190, CAST(N'2023-07-16T09:31:27.263' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (191, CAST(N'2023-07-16T09:33:12.953' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (192, CAST(N'2023-07-16T09:33:58.260' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (193, CAST(N'2023-07-16T09:40:38.257' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (194, CAST(N'2023-07-16T09:45:16.180' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (195, CAST(N'2023-07-16T09:48:54.423' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (196, CAST(N'2023-07-16T09:50:33.743' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (197, CAST(N'2023-07-16T09:50:43.137' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (198, CAST(N'2023-07-16T09:51:04.387' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (199, CAST(N'2023-07-16T10:02:10.600' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (200, CAST(N'2023-07-16T14:21:09.997' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (201, CAST(N'2023-07-16T14:21:53.153' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (202, CAST(N'2023-07-16T14:42:03.820' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (203, CAST(N'2023-07-16T15:10:37.660' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (204, CAST(N'2023-07-16T15:43:49.997' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (205, CAST(N'2023-07-16T15:45:07.477' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (206, CAST(N'2023-07-16T15:45:42.377' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (207, CAST(N'2023-07-16T15:46:02.060' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (208, CAST(N'2023-07-16T15:58:16.113' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (209, CAST(N'2023-07-16T16:00:26.173' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (210, CAST(N'2023-07-16T16:05:18.280' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (211, CAST(N'2023-07-16T16:09:42.000' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (212, CAST(N'2023-07-16T16:11:09.110' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (213, CAST(N'2023-07-17T10:17:52.643' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (214, CAST(N'2023-07-17T10:20:58.707' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (215, CAST(N'2023-07-17T10:29:17.833' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (216, CAST(N'2023-07-17T10:31:51.660' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (217, CAST(N'2023-07-17T11:56:12.490' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (218, CAST(N'2023-07-17T15:34:39.277' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (219, CAST(N'2023-07-17T15:36:31.623' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (220, CAST(N'2023-07-17T15:38:46.503' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (221, CAST(N'2023-07-17T15:51:33.447' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (222, CAST(N'2023-07-17T15:52:22.710' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (223, CAST(N'2023-07-17T15:54:19.640' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (224, CAST(N'2023-07-17T15:55:18.623' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (225, CAST(N'2023-07-17T15:57:35.990' AS DateTime), NULL, N'WebScraper Version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (226, CAST(N'2023-07-17T15:58:42.600' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (227, CAST(N'2023-07-17T16:01:47.537' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (228, CAST(N'2023-07-17T16:44:20.700' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (229, CAST(N'2023-07-17T16:51:04.290' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (230, CAST(N'2023-07-18T16:43:16.070' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (231, CAST(N'2023-07-18T16:43:43.850' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (232, CAST(N'2023-07-18T16:55:57.610' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (233, CAST(N'2023-07-19T16:17:04.327' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (234, CAST(N'2023-07-19T16:18:04.287' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (235, CAST(N'2023-07-19T16:18:45.533' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (236, CAST(N'2023-07-20T11:44:33.503' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (237, CAST(N'2023-07-20T11:45:21.497' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (238, CAST(N'2023-07-20T12:01:19.820' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (239, CAST(N'2023-07-20T12:02:17.590' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (240, CAST(N'2023-07-20T12:02:57.310' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (241, CAST(N'2023-07-20T12:03:08.400' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (242, CAST(N'2023-07-20T12:05:30.813' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (243, CAST(N'2023-07-20T12:06:38.047' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (244, CAST(N'2023-07-20T12:09:04.580' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (245, CAST(N'2023-07-20T12:12:17.533' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (246, CAST(N'2023-07-20T12:20:51.773' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (247, CAST(N'2023-07-24T15:46:28.910' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (248, CAST(N'2023-07-24T15:47:03.007' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (249, CAST(N'2023-07-24T15:50:15.047' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (250, CAST(N'2023-07-24T15:52:14.800' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (251, CAST(N'2023-07-24T15:59:54.223' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (252, CAST(N'2023-07-24T16:01:10.893' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (253, CAST(N'2023-07-24T16:01:18.733' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (254, CAST(N'2023-07-24T16:02:12.440' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (255, CAST(N'2023-07-24T16:14:56.110' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (256, CAST(N'2023-07-24T16:16:58.720' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (257, CAST(N'2023-07-24T16:25:40.430' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (258, CAST(N'2023-07-24T16:36:21.007' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (259, CAST(N'2023-07-24T16:38:43.737' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (260, CAST(N'2023-07-24T17:11:05.263' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (261, CAST(N'2023-07-24T17:16:26.073' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (262, CAST(N'2023-07-24T17:17:53.313' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (263, CAST(N'2023-07-24T17:18:40.347' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (264, CAST(N'2023-07-25T10:43:33.517' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (265, CAST(N'2023-07-25T10:47:42.053' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (266, CAST(N'2023-07-26T12:39:08.450' AS DateTime), CAST(N'2023-07-26T18:05:39.313' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (267, CAST(N'2023-07-26T12:46:59.123' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (268, CAST(N'2023-07-26T18:23:28.577' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (269, CAST(N'2023-07-26T18:29:54.070' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (270, CAST(N'2023-07-26T18:31:15.357' AS DateTime), CAST(N'2023-07-26T18:31:27.903' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (271, CAST(N'2023-07-26T19:11:31.930' AS DateTime), CAST(N'2023-07-26T19:11:53.600' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (272, CAST(N'2023-07-26T19:15:36.383' AS DateTime), CAST(N'2023-07-26T19:15:47.127' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (273, CAST(N'2023-07-27T12:10:22.747' AS DateTime), CAST(N'2023-07-27T12:10:38.063' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (274, CAST(N'2023-07-27T12:17:00.390' AS DateTime), CAST(N'2023-07-27T12:17:01.300' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (275, CAST(N'2023-07-27T12:17:47.073' AS DateTime), CAST(N'2023-07-27T12:17:47.450' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (276, CAST(N'2023-07-27T12:18:07.323' AS DateTime), CAST(N'2023-07-27T12:18:34.957' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (277, CAST(N'2023-07-27T13:11:50.210' AS DateTime), CAST(N'2023-07-27T13:12:02.010' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (278, CAST(N'2023-07-27T13:12:58.037' AS DateTime), CAST(N'2023-07-27T13:12:59.080' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (279, CAST(N'2023-07-27T13:18:45.580' AS DateTime), CAST(N'2023-07-27T13:18:55.363' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (280, CAST(N'2023-07-27T14:04:14.557' AS DateTime), CAST(N'2023-07-27T14:04:14.923' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (281, CAST(N'2023-07-27T16:41:52.690' AS DateTime), CAST(N'2023-07-27T16:41:53.070' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (282, CAST(N'2023-07-27T16:42:26.720' AS DateTime), CAST(N'2023-07-27T16:42:27.157' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (283, CAST(N'2023-07-27T16:43:11.737' AS DateTime), CAST(N'2023-07-27T16:43:17.407' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (284, CAST(N'2023-07-27T16:56:28.333' AS DateTime), CAST(N'2023-07-27T16:56:50.137' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (285, CAST(N'2023-07-27T17:11:56.567' AS DateTime), CAST(N'2023-07-27T17:12:06.870' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (286, CAST(N'2023-07-27T17:15:27.153' AS DateTime), CAST(N'2023-07-27T17:15:32.880' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (287, CAST(N'2023-07-27T17:16:52.637' AS DateTime), CAST(N'2023-07-27T17:16:57.007' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (288, CAST(N'2023-07-27T17:20:02.750' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (289, CAST(N'2023-07-27T17:21:36.453' AS DateTime), CAST(N'2023-07-27T17:21:40.880' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (290, CAST(N'2023-07-27T17:26:23.963' AS DateTime), CAST(N'2023-07-27T17:26:43.650' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (291, CAST(N'2023-07-27T17:28:13.407' AS DateTime), CAST(N'2023-07-27T17:28:19.770' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (292, CAST(N'2023-07-27T17:51:01.530' AS DateTime), CAST(N'2023-07-27T17:51:02.547' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (293, CAST(N'2023-07-27T17:51:32.767' AS DateTime), CAST(N'2023-07-27T17:51:33.307' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (294, CAST(N'2023-07-27T17:51:45.830' AS DateTime), CAST(N'2023-07-27T17:52:01.840' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (295, CAST(N'2023-07-27T19:50:34.563' AS DateTime), CAST(N'2023-07-27T19:50:50.870' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (296, CAST(N'2023-07-27T19:52:22.337' AS DateTime), CAST(N'2023-07-27T19:52:40.100' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (297, CAST(N'2023-07-27T21:01:02.627' AS DateTime), NULL, N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (298, CAST(N'2023-07-27T21:02:59.970' AS DateTime), CAST(N'2023-07-27T21:03:17.410' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (299, CAST(N'2023-07-27T21:11:05.177' AS DateTime), CAST(N'2023-07-27T21:11:24.110' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (300, CAST(N'2023-07-27T21:12:36.887' AS DateTime), CAST(N'2023-07-27T21:12:54.810' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (301, CAST(N'2023-07-27T21:15:43.947' AS DateTime), CAST(N'2023-07-27T21:16:03.243' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (302, CAST(N'2023-07-27T21:16:43.583' AS DateTime), CAST(N'2023-07-27T21:16:58.630' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (303, CAST(N'2023-07-27T21:19:21.373' AS DateTime), CAST(N'2023-07-27T21:19:31.630' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (304, CAST(N'2023-07-27T21:34:28.280' AS DateTime), CAST(N'2023-07-27T21:34:35.447' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (305, CAST(N'2023-07-27T21:35:20.093' AS DateTime), CAST(N'2023-07-27T21:35:24.750' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (306, CAST(N'2023-07-27T21:36:06.670' AS DateTime), CAST(N'2023-07-27T21:36:11.597' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (307, CAST(N'2023-07-27T21:37:18.357' AS DateTime), CAST(N'2023-07-27T21:37:23.020' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (308, CAST(N'2023-07-27T21:38:04.510' AS DateTime), CAST(N'2023-07-27T21:38:09.970' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (309, CAST(N'2023-07-27T21:46:42.443' AS DateTime), CAST(N'2023-07-27T21:46:51.777' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (310, CAST(N'2023-07-27T21:49:25.070' AS DateTime), CAST(N'2023-07-27T21:49:29.870' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (311, CAST(N'2023-07-27T21:51:54.653' AS DateTime), CAST(N'2023-07-27T21:52:04.350' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (312, CAST(N'2023-07-27T21:58:32.840' AS DateTime), CAST(N'2023-07-27T21:58:50.273' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (313, CAST(N'2023-07-27T22:01:03.493' AS DateTime), CAST(N'2023-07-27T22:01:20.627' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (314, CAST(N'2023-07-27T22:02:01.723' AS DateTime), CAST(N'2023-07-27T22:02:16.987' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (315, CAST(N'2023-07-27T22:03:13.970' AS DateTime), CAST(N'2023-07-27T22:03:32.997' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (316, CAST(N'2023-07-27T22:04:22.477' AS DateTime), CAST(N'2023-07-27T22:04:40.480' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (317, CAST(N'2023-07-27T22:05:44.277' AS DateTime), CAST(N'2023-07-27T22:06:02.120' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (318, CAST(N'2023-07-27T22:08:23.267' AS DateTime), CAST(N'2023-07-27T22:08:41.483' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (319, CAST(N'2023-07-27T22:17:57.200' AS DateTime), CAST(N'2023-07-27T22:18:15.187' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (320, CAST(N'2023-07-27T22:18:34.763' AS DateTime), CAST(N'2023-07-27T22:18:54.270' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (321, CAST(N'2023-07-27T22:19:19.410' AS DateTime), CAST(N'2023-07-27T22:19:36.613' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (322, CAST(N'2023-07-27T22:46:01.080' AS DateTime), CAST(N'2023-07-27T22:46:29.247' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (323, CAST(N'2023-07-27T22:52:38.077' AS DateTime), CAST(N'2023-07-27T22:52:38.090' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (324, CAST(N'2023-07-27T22:53:39.767' AS DateTime), CAST(N'2023-07-27T22:53:40.840' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (325, CAST(N'2023-07-27T22:54:52.570' AS DateTime), CAST(N'2023-07-27T22:55:06.650' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (326, CAST(N'2023-07-27T22:55:46.493' AS DateTime), CAST(N'2023-07-27T22:56:12.800' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (327, CAST(N'2023-07-27T23:08:17.710' AS DateTime), CAST(N'2023-07-27T23:08:36.917' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (328, CAST(N'2023-07-27T23:10:23.453' AS DateTime), CAST(N'2023-07-27T23:10:28.850' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (329, CAST(N'2023-07-27T23:11:25.427' AS DateTime), CAST(N'2023-07-27T23:11:29.887' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (330, CAST(N'2023-07-27T23:12:23.043' AS DateTime), CAST(N'2023-07-27T23:12:28.053' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (331, CAST(N'2023-07-27T23:15:33.233' AS DateTime), CAST(N'2023-07-27T23:15:52.050' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (332, CAST(N'2023-07-27T23:26:36.090' AS DateTime), CAST(N'2023-07-27T23:26:36.460' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (333, CAST(N'2023-07-27T23:27:51.250' AS DateTime), CAST(N'2023-07-27T23:27:52.467' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (334, CAST(N'2023-07-27T23:30:14.150' AS DateTime), CAST(N'2023-07-27T23:30:14.840' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (335, CAST(N'2023-07-28T10:27:26.083' AS DateTime), CAST(N'2023-07-28T10:27:27.430' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (336, CAST(N'2023-07-28T10:28:34.997' AS DateTime), CAST(N'2023-07-28T10:28:52.773' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (337, CAST(N'2023-07-28T10:31:57.560' AS DateTime), CAST(N'2023-07-28T10:32:13.430' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (338, CAST(N'2023-07-28T10:35:54.643' AS DateTime), CAST(N'2023-07-28T10:36:12.200' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (339, CAST(N'2023-07-28T10:38:31.877' AS DateTime), CAST(N'2023-07-28T10:39:02.713' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (340, CAST(N'2023-07-28T10:40:13.083' AS DateTime), CAST(N'2023-07-28T10:40:36.813' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (341, CAST(N'2023-07-28T10:45:34.903' AS DateTime), CAST(N'2023-07-28T10:45:52.617' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (342, CAST(N'2023-07-28T10:49:12.047' AS DateTime), CAST(N'2023-07-28T10:49:32.227' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (343, CAST(N'2023-07-28T11:46:43.573' AS DateTime), CAST(N'2023-07-28T11:47:06.347' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (344, CAST(N'2023-07-28T11:48:43.877' AS DateTime), CAST(N'2023-07-28T11:49:04.007' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (345, CAST(N'2023-07-28T11:57:57.353' AS DateTime), CAST(N'2023-07-28T11:58:55.670' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (346, CAST(N'2023-07-28T12:08:28.760' AS DateTime), CAST(N'2023-07-28T12:11:01.303' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (347, CAST(N'2023-07-28T13:23:02.923' AS DateTime), CAST(N'2023-07-28T13:25:32.673' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (348, CAST(N'2023-08-03T09:51:06.547' AS DateTime), CAST(N'2023-08-03T09:52:50.960' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (349, CAST(N'2023-08-03T13:03:41.367' AS DateTime), CAST(N'2023-08-03T13:05:47.887' AS DateTime), N'WebScraper version 1.0')
GO
INSERT [dbo].[Sessions] ([Id], [StartTime], [EndTime], [Executor]) VALUES (1348, CAST(N'2023-08-07T12:42:54.373' AS DateTime), CAST(N'2023-08-07T12:44:47.477' AS DateTime), N'WebScraper version 1.0')
GO
SET IDENTITY_INSERT [dbo].[Sessions] OFF
GO
SET IDENTITY_INSERT [dbo].[Sites] ON 
GO
INSERT [dbo].[Sites] ([Id], [Name], [Active], [URL], [Module], [Method], [Configs]) VALUES (1, N'Wirtschaftswoche', 0, N'https://www.wiwo.de/unternehmen/auto/', N'wiwo_scraper.py', N'scrape_wiwo', NULL)
GO
INSERT [dbo].[Sites] ([Id], [Name], [Active], [URL], [Module], [Method], [Configs]) VALUES (3, N'Autocar', 1, N'https://www.autocar.co.uk/', N'autocar_scraper.py', N'scrape_autocar', NULL)
GO
INSERT [dbo].[Sites] ([Id], [Name], [Active], [URL], [Module], [Method], [Configs]) VALUES (5, N'Autobild', 1, N'https://www.autobild.de/news/', N'autobild_scraper.py', N'scrape_autobild', NULL)
GO
SET IDENTITY_INSERT [dbo].[Sites] OFF
GO
ALTER TABLE [dbo].[Sessions] ADD  CONSTRAINT [DF_Sessions_StartTime]  DEFAULT (getdate()) FOR [StartTime]
GO
ALTER TABLE [dbo].[Sites] ADD  CONSTRAINT [DF_Sites_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[ArticleContents]  WITH CHECK ADD  CONSTRAINT [FK_ArticleContents_articles] FOREIGN KEY([article_Id])
REFERENCES [dbo].[Articles] ([Id])
GO
ALTER TABLE [dbo].[ArticleContents] CHECK CONSTRAINT [FK_ArticleContents_articles]
GO
ALTER TABLE [dbo].[Articles]  WITH CHECK ADD  CONSTRAINT [FK_articles_Sessions] FOREIGN KEY([Session_Id])
REFERENCES [dbo].[Sessions] ([Id])
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_articles_Sessions]
GO
ALTER TABLE [dbo].[Articles]  WITH CHECK ADD  CONSTRAINT [FK_articles_Sites] FOREIGN KEY([Site_Id])
REFERENCES [dbo].[Sites] ([Id])
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_articles_Sites]
GO
/****** Object:  StoredProcedure [dbo].[CloseSession]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Giao Nguyen
-- Create date: 26.07.2023
-- Description:	Take sessionID and Update the endtime
-- =============================================

CREATE PROCEDURE [dbo].[CloseSession]
	@sessionID INT
AS
BEGIN
	SET NOCOUNT ON;
	UPDATE [dbo].[Sessions]
	SET EndTime = GETDATE()
	WHERE Id = @sessionID;
END
GO
/****** Object:  StoredProcedure [dbo].[CreateArticle]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Giao Nguyen
-- Create date: 17.07.2023
-- Description:	insert new article and returns its id
-- =============================================
CREATE   PROCEDURE [dbo].[CreateArticle] 
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
	DECLARE @hashValue varchar(32) = dbo.GetHashValue(@overline, @headline, @subline, @url);
	IF EXISTS (SELECT * FROM dbo.Articles WHERE HashValue=@hashValue)
	BEGIN
		SELECT 0 -- no row inserted
	END
	ELSE BEGIN
		INSERT INTO [dbo].[Articles] 
			(Site_Id, Session_Id, Overline, Headline, Subline, Author, Publicdate, Url)
			SELECT @siteId, @sessionId, NULLIF(@overline, ''), NULLIF(@headline, ''), NULLIF(@subline, ''), NULLIF(@author, ''), NULLIF(@publicdate, ''), NULLIF(@url, '');
		SELECT SCOPE_IDENTITY() -- return the inserted id
	END
END
GO
/****** Object:  StoredProcedure [dbo].[CreateSession]    Script Date: 08.08.2023 11:15:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Giao Nguyen
-- Create date: 17.07.2023
-- Description:	insert new article and returns its id
-- =============================================
CREATE   PROCEDURE [dbo].[CreateSession] 
	@executor nvarchar(240)
AS
BEGIN
	SET NOCOUNT ON;
	INSERT INTO [dbo].[Sessions] (Executor)
    VALUES(@executor);
	SELECT SCOPE_IDENTITY() -- return the inserted id
END
GO
USE [master]
GO
ALTER DATABASE [WebScraper] SET  READ_WRITE 
GO
