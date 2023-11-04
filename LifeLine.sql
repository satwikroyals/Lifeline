USE [LifeLine]
GO
/****** Object:  User [GmiAus]    Script Date: 18-08-2023 10:57:18 ******/
CREATE USER [GmiAus] FOR LOGIN [GmiAus] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [GmiAus]
GO
/****** Object:  UserDefinedTableType [dbo].[MemberSOSDatatbl]    Script Date: 18-08-2023 10:57:18 ******/
CREATE TYPE [dbo].[MemberSOSDatatbl] AS TABLE(
	[Name] [nvarchar](100) NULL,
	[EmailId] [nvarchar](100) NULL,
	[Mobile] [nvarchar](100) NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[geolocationdistancecaluclation]    Script Date: 18-08-2023 10:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[geolocationdistancecaluclation](@mlat [real], @mlong [real], @clat [real], @clong [real])
RETURNS [real] WITH EXECUTE AS CALLER
AS 
begin
Declare @R Float(8);
Declare @dLat Float(18);
Declare @dLon Float(18);
Declare @a Float(18);
Declare @c Float(18);
Declare @d Float(18);

Set @dLat = Radians(@mlat - @clat);

      Set @dLon = Radians(@mlong - @clong);

      Set @a = Sin(@dLat / 2) 
                 * Sin(@dLat / 2) 
                 + Cos(Radians(@mlat))
                 * Cos(Radians(@clat)) 
                 * Sin(@dLon / 2) 
                 * Sin(@dLon / 2);
      Set @c = 2 * Asin(Min(Sqrt(@a)));

      Set @d = 6367.45 * @c; 
      
return ceiling(@d)
end
GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 18-08-2023 10:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split](@String [nvarchar](max), @Delimiter [char](1))
RETURNS @temptable TABLE (
	[items] [nvarchar](max) NULL
) WITH EXECUTE AS CALLER
AS 
begin      
    declare @idx int       
    declare @slice varchar(8000)       

    select @idx = 1       
        if len(@String)<1 or @String is null  return       

    while @idx!= 0       
    begin       
        set @idx = charindex(@Delimiter,@String)       
        if @idx!=0       
            set @slice = left(@String,@idx - 1)       
        else       
            set @slice = @String       

        if(len(@slice)>0)  
            insert into @temptable(Items) values(@slice)       

        set @String = right(@String,len(@String) - @idx)       
        if len(@String) = 0 break       
    end   
return 
end;










GO
/****** Object:  Table [dbo].[Member]    Script Date: 18-08-2023 10:57:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Member](
	[MemberId] [bigint] IDENTITY(1,1) NOT NULL,
	[CoordinatorId] [bigint] NULL,
	[Firstname] [nvarchar](50) NULL,
	[Lastname] [nvarchar](50) NULL,
	[Gender] [int] NULL,
	[ProfilePic] [nvarchar](100) NULL,
	[UserId] [nvarchar](50) NULL,
	[Pin] [nvarchar](50) NULL,
	[Mobile] [nvarchar](50) NULL,
	[EmailId] [nvarchar](100) NULL,
	[LocationId] [int] NULL,
	[CountryId] [int] NULL,
	[StateId] [int] NOT NULL,
	[Longitude] [decimal](18, 6) NULL,
	[Latitude] [decimal](18, 6) NULL,
	[PostCode] [nvarchar](50) NULL,
	[GeoAddress] [nvarchar](200) NULL,
	[Street] [nvarchar](100) NULL,
	[Suburb] [nvarchar](100) NULL,
	[City] [nvarchar](100) NULL,
	[CommunityBelong] [nvarchar](50) NULL,
	[ReferredById] [bigint] NULL,
	[MemberInfo] [nvarchar](max) NULL,
	[IsCoordinator] [int] NULL,
	[IsDisclosed] [int] NULL,
	[Status] [int] NULL,
	[OrganisationName] [nvarchar](150) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Member] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AreaCoordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaCoordinator](
	[AreacoordinatorId] [int] IDENTITY(1,1) NOT NULL,
	[CurrentCoordinator] [int] NOT NULL,
	[LocationId] [int] NOT NULL,
	[AreaInfo] [nvarchar](max) NULL,
 CONSTRAINT [PK_AreaCoordinator] PRIMARY KEY CLUSTERED 
(
	[AreacoordinatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TownCoordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TownCoordinator](
	[TownCoordinatorId] [int] IDENTITY(1,1) NOT NULL,
	[TownId] [int] NULL,
	[CurrentTownCoordinator] [int] NOT NULL,
	[TownCoordinatorInfo] [nvarchar](max) NULL,
 CONSTRAINT [PK_TownCoordinator] PRIMARY KEY CLUSTERED 
(
	[TownCoordinatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Town]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Town](
	[TownId] [int] IDENTITY(1,1) NOT NULL,
	[Town] [nvarchar](50) NOT NULL,
	[RegionId] [int] NOT NULL,
	[TownInfo] [nvarchar](max) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Town] PRIMARY KEY CLUSTERED 
(
	[TownId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Country] [nvarchar](50) NULL,
	[ContinentId] [int] NULL,
	[CountryCode] [nvarchar](50) NULL,
	[Countryflag] [nvarchar](150) NULL,
	[CountryInfo] [nvarchar](50) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Location](
	[LocationId] [int] IDENTITY(1,1) NOT NULL,
	[Location] [nvarchar](100) NULL,
	[SenstitiveFlagId] [int] NULL,
	[TownId] [int] NULL,
	[LocationInfo] [nvarchar](max) NULL,
	[Latitude] [decimal](18, 6) NULL,
	[Longitude] [decimal](18, 6) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[State]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[State](
	[StateId] [int] IDENTITY(1,1) NOT NULL,
	[StateName] [nvarchar](100) NULL,
	[CountryId] [int] NULL,
	[StateInfo] [nvarchar](max) NULL,
	[HelpLineNumber] [nvarchar](50) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_State] PRIMARY KEY CLUSTERED 
(
	[StateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[LifeLineScript]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[LifeLineScript]
AS
SELECT        dbo.Member.MemberId, dbo.Member.Firstname, dbo.Member.Lastname, dbo.Member.Mobile, dbo.Member.PostCode, dbo.Member.GeoAddress, dbo.Member.CommunityBelong, dbo.Member.MemberInfo, dbo.Location.Location, 
                         dbo.Town.Town, dbo.Country.Country, dbo.AreaCoordinator.CurrentCoordinator
FROM            dbo.Member INNER JOIN
                         dbo.Location ON dbo.Member.LocationId = dbo.Location.LocationId INNER JOIN
                         dbo.Country ON dbo.Member.CountryId = dbo.Country.CountryId INNER JOIN
                         dbo.State ON dbo.Country.CountryId = dbo.State.CountryId INNER JOIN
                         dbo.Town ON dbo.Location.TownId = dbo.Town.TownId INNER JOIN
                         dbo.AreaCoordinator ON dbo.Location.LocationId = dbo.AreaCoordinator.LocationId INNER JOIN
                         dbo.TownCoordinator ON dbo.Town.TownId = dbo.TownCoordinator.TownId
GO
/****** Object:  Table [dbo].[AdminDetails]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AdminDetails](
	[AdminId] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nchar](10) NULL,
	[Email] [nvarchar](100) NULL,
	[Mobile] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NULL,
	[Password] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AdminDetails] PRIMARY KEY CLUSTERED 
(
	[AdminId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AreaVolunteer]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaVolunteer](
	[AreaVolunteerId] [int] IDENTITY(1,1) NOT NULL,
	[LocationId] [int] NOT NULL,
	[VolunteerId] [int] NOT NULL,
	[VolunteerInfo] [nvarchar](300) NULL,
 CONSTRAINT [PK_AreaVolunteer] PRIMARY KEY CLUSTERED 
(
	[AreaVolunteerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Campaign]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Campaign](
	[CampaignId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[CampaignTitle] [nvarchar](100) NULL,
	[Image] [nvarchar](100) NULL,
	[LocationId] [int] NOT NULL,
	[StartTime] [datetime] NULL,
	[EndTime] [datetime] NULL,
	[GeoLocation] [nvarchar](300) NULL,
	[Latitude] [decimal](18, 6) NULL,
	[Longitude] [decimal](18, 6) NULL,
	[CampaignInfo] [nvarchar](200) NULL,
	[SpecialInstructions] [nvarchar](1000) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED 
(
	[CampaignId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CampaignMember]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CampaignMember](
	[CampaignMemberId] [bigint] IDENTITY(1,1) NOT NULL,
	[CampaignId] [bigint] NOT NULL,
	[MemberId] [bigint] NOT NULL,
	[Message] [nvarchar](200) NULL,
	[Status] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_CampaignMember] PRIMARY KEY CLUSTERED 
(
	[CampaignMemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CampaignMemberTracking]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CampaignMemberTracking](
	[CampaignMemberTrackingId] [bigint] IDENTITY(1,1) NOT NULL,
	[CampaignId] [bigint] NOT NULL,
	[MemberId] [bigint] NULL,
	[Latitude] [decimal](18, 6) NULL,
	[Longitude] [decimal](18, 6) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_CampaignMemberTracking] PRIMARY KEY CLUSTERED 
(
	[CampaignMemberTrackingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatFriends]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatFriends](
	[ChatId] [int] IDENTITY(1,1) NOT NULL,
	[MemberId1] [bigint] NULL,
	[MemberId2] [bigint] NULL,
	[IsGroup] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[LastMessageId] [bigint] NULL,
	[LastMessageDate] [datetime] NULL,
 CONSTRAINT [PK_ChatFriends] PRIMARY KEY CLUSTERED 
(
	[ChatId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[MessageId] [int] IDENTITY(1,1) NOT NULL,
	[FromCId] [bigint] NULL,
	[ToCId] [bigint] NULL,
	[MessageText] [nvarchar](max) NULL,
	[Image] [nvarchar](500) NULL,
	[Video] [nvarchar](500) NULL,
	[IsViewed] [int] NULL,
	[ChatId] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ChatMessages] PRIMARY KEY CLUSTERED 
(
	[MessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Continent]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Continent](
	[ContinentId] [int] IDENTITY(1,1) NOT NULL,
	[Continent] [nvarchar](50) NULL,
	[ContinentInfo] [nvarchar](max) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Continent] PRIMARY KEY CLUSTERED 
(
	[ContinentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Coordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Coordinator](
	[CoordinatorId] [bigint] IDENTITY(1,1) NOT NULL,
	[Firstname] [nvarchar](50) NULL,
	[Lastname] [nvarchar](50) NULL,
	[Gender] [int] NULL,
	[ProfilePic] [nvarchar](100) NULL,
	[UserId] [nvarchar](50) NULL,
	[Pin] [int] NULL,
	[Mobile] [nvarchar](50) NULL,
	[EmailId] [nvarchar](100) NULL,
	[LocationId] [int] NULL,
	[CountryId] [int] NULL,
	[Longitude] [decimal](18, 6) NULL,
	[Latitude] [decimal](18, 6) NULL,
	[PostCode] [nvarchar](50) NULL,
	[GeoAddress] [nvarchar](200) NULL,
	[CommunityBelong] [nvarchar](50) NULL,
	[ReferredById] [bigint] NULL,
	[MemberInfo] [nvarchar](max) NULL,
	[IsCoordinator] [int] NULL,
	[IsDisclosed] [int] NULL,
	[Status] [int] NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Coordinator] PRIMARY KEY CLUSTERED 
(
	[CoordinatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[GroupMessage]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GroupMessage](
	[GMSGId] [int] IDENTITY(1,1) NOT NULL,
	[CGId] [bigint] NULL,
	[MemberId] [bigint] NOT NULL,
	[Message] [nvarchar](max) NULL,
	[PostImage] [nvarchar](500) NULL,
	[PostVideo] [nvarchar](500) NULL,
	[PostedDate] [datetime] NOT NULL,
	[ApprovedBy] [bigint] NULL,
	[ApprovedDate] [datetime] NULL,
	[RemovedBy] [bigint] NULL,
	[RemovedDate] [datetime] NULL,
	[Status] [int] NULL,
 CONSTRAINT [PK_GroupMessage] PRIMARY KEY CLUSTERED 
(
	[GMSGId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Help]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Help](
	[HelpId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[CoordinatorId] [bigint] NULL,
	[Message] [nvarchar](500) NULL,
	[Image] [nvarchar](100) NULL,
	[Latitude] [decimal](18, 6) NULL,
	[Longitude] [decimal](18, 6) NULL,
	[PostCode] [nvarchar](50) NULL,
	[Status] [int] NULL,
	[VolunteerIds] [nvarchar](100) NULL,
	[RespondId] [bigint] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Help] PRIMARY KEY CLUSTERED 
(
	[HelpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HelpImages]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HelpImages](
	[ImageId] [bigint] IDENTITY(1,1) NOT NULL,
	[HelpId] [bigint] NOT NULL,
	[ImageName] [nvarchar](200) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HelpImages] PRIMARY KEY CLUSTERED 
(
	[ImageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HelpRespondedVolunteers]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HelpRespondedVolunteers](
	[RespondId] [bigint] IDENTITY(1,1) NOT NULL,
	[HelpId] [bigint] NOT NULL,
	[MemberId] [bigint] NOT NULL,
	[IsAccepted] [bit] NOT NULL,
	[RespondDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HelpRespondedVolunteers] PRIMARY KEY CLUSTERED 
(
	[RespondId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[HelpVideos]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HelpVideos](
	[VideoId] [bigint] IDENTITY(1,1) NOT NULL,
	[HelpId] [bigint] NOT NULL,
	[VideoName] [nvarchar](200) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_HelpVideos] PRIMARY KEY CLUSTERED 
(
	[VideoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberAreaCoordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberAreaCoordinator](
	[MemberAreaId] [int] IDENTITY(1,1) NOT NULL,
	[MemberId] [int] NOT NULL,
	[AreaCoordinatorId] [int] NOT NULL,
	[Info] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_MemberAreaCoordinator] PRIMARY KEY CLUSTERED 
(
	[MemberAreaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberChatGroups]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberChatGroups](
	[CGId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[GroupName] [nvarchar](50) NULL,
	[GroupMembers] [nvarchar](max) NULL,
 CONSTRAINT [PK_CustomerChatGroups] PRIMARY KEY CLUSTERED 
(
	[CGId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberDevices]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberDevices](
	[CAppdeviceId] [int] IDENTITY(1,1) NOT NULL,
	[DeviceId] [nvarchar](max) NULL,
	[MemberId] [int] NULL,
	[DeviceType] [int] NULL,
	[AppId] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_CustomerDevices] PRIMARY KEY CLUSTERED 
(
	[CAppdeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberFriends]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberFriends](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NOT NULL,
	[FriendMemberId] [bigint] NOT NULL,
	[AddedDate] [date] NOT NULL,
	[Status] [int] NOT NULL,
 CONSTRAINT [PK_MemberFriends] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MemberSOScontacts]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MemberSOScontacts](
	[ContactId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[Name] [nvarchar](150) NULL,
	[EmailId] [nvarchar](100) NULL,
	[Mobile] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_MemberSOScontacts] PRIMARY KEY CLUSTERED 
(
	[ContactId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[NotificationMembers]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NotificationMembers](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[NotificationId] [bigint] NULL,
	[MemberId] [bigint] NULL,
	[Response] [nvarchar](200) NULL,
	[IsViewed] [int] NULL,
	[ResponseDate] [datetime] NULL,
 CONSTRAINT [PK_NotificationMembers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[NotificationId] [bigint] IDENTITY(1,1) NOT NULL,
	[CoordinatorId] [bigint] NULL,
	[MemberId] [nvarchar](max) NULL,
	[Title] [nvarchar](100) NULL,
	[Message] [nvarchar](500) NULL,
	[CreatedDate] [datetime] NULL,
	[IsActive] [int] NOT NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[NotificationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Region]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Region](
	[RegionId] [int] IDENTITY(1,1) NOT NULL,
	[Region] [nvarchar](50) NULL,
	[StateId] [int] NULL,
	[RegionInfo] [nvarchar](max) NULL,
	[CreatedDate] [smalldatetime] NULL,
 CONSTRAINT [PK_Region] PRIMARY KEY CLUSTERED 
(
	[RegionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RegionalCoordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegionalCoordinator](
	[RegionalCoordinatorId] [int] IDENTITY(1,1) NOT NULL,
	[RegionalId] [int] NULL,
	[CurrentRegionalCoordinator] [int] NULL,
	[RegionalCoordinatorInfo] [nvarchar](max) NULL,
 CONSTRAINT [PK_RegionalCoordinator] PRIMARY KEY CLUSTERED 
(
	[RegionalCoordinatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Resource]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resource](
	[ResourceId] [bigint] IDENTITY(1,1) NOT NULL,
	[DocTitle] [nvarchar](100) NULL,
	[ResourceBrief] [nvarchar](max) NULL,
	[ResourceDoc] [nvarchar](150) NULL,
	[CaseStudyId] [nvarchar](100) NULL,
	[VideoUrl] [nvarchar](4000) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_Resource] PRIMARY KEY CLUSTERED 
(
	[ResourceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SensitiveFlag]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SensitiveFlag](
	[SensitiveFlagId] [int] IDENTITY(1,1) NOT NULL,
	[SensitiveFlag] [nvarchar](30) NULL,
 CONSTRAINT [PK_SensitiveFlag] PRIMARY KEY CLUSTERED 
(
	[SensitiveFlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StateCoordinator]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StateCoordinator](
	[StateCoordiantorId] [int] IDENTITY(1,1) NOT NULL,
	[StateId] [int] NULL,
	[CurrentStateCoordinator] [int] NOT NULL,
	[StateCoordinatorInfo] [nvarchar](max) NULL,
 CONSTRAINT [PK_StateCoordinator] PRIMARY KEY CLUSTERED 
(
	[StateCoordiantorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SupportMessages]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupportMessages](
	[SupportId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[Subject] [nvarchar](150) NULL,
	[Message] [nvarchar](max) NULL,
	[HandledBy] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_SupportMessages] PRIMARY KEY CLUSTERED 
(
	[SupportId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VolunteerTasks]    Script Date: 18-08-2023 10:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VolunteerTasks](
	[TaskId] [bigint] IDENTITY(1,1) NOT NULL,
	[MemberId] [bigint] NULL,
	[CoordinatorId] [bigint] NULL,
	[VolunteerIds] [nvarchar](100) NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_VolunteerTasks] PRIMARY KEY CLUSTERED 
(
	[TaskId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[AdminDetails] ON 

INSERT [dbo].[AdminDetails] ([AdminId], [FirstName], [LastName], [Email], [Mobile], [UserName], [Password], [CreatedDate]) VALUES (1, N'john', N'peter     ', N'john@gmail.com', N'9787382782', N'admin', N'admin', NULL)
SET IDENTITY_INSERT [dbo].[AdminDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[AreaCoordinator] ON 

INSERT [dbo].[AreaCoordinator] ([AreacoordinatorId], [CurrentCoordinator], [LocationId], [AreaInfo]) VALUES (2, 1, 1, N'Rajamandri Area')
INSERT [dbo].[AreaCoordinator] ([AreacoordinatorId], [CurrentCoordinator], [LocationId], [AreaInfo]) VALUES (3, 2, 2, N'South East Queensland')
SET IDENTITY_INSERT [dbo].[AreaCoordinator] OFF
GO
SET IDENTITY_INSERT [dbo].[AreaVolunteer] ON 

INSERT [dbo].[AreaVolunteer] ([AreaVolunteerId], [LocationId], [VolunteerId], [VolunteerInfo]) VALUES (1, 1, 1, N'helping as a volunteer')
INSERT [dbo].[AreaVolunteer] ([AreaVolunteerId], [LocationId], [VolunteerId], [VolunteerInfo]) VALUES (2, 2, 2, NULL)
SET IDENTITY_INSERT [dbo].[AreaVolunteer] OFF
GO
SET IDENTITY_INSERT [dbo].[Campaign] ON 

INSERT [dbo].[Campaign] ([CampaignId], [MemberId], [CampaignTitle], [Image], [LocationId], [StartTime], [EndTime], [GeoLocation], [Latitude], [Longitude], [CampaignInfo], [SpecialInstructions], [CreatedDate]) VALUES (28, 72, N'Running Campaign', N'b80e0453-9ea1-416e-87ca-091437c7a2f5.jpg', 0, CAST(N'2022-01-10T13:30:00.000' AS DateTime), CAST(N'2022-01-19T13:30:00.000' AS DateTime), N'Hyderabad, Telangana, India', CAST(17.385044 AS Decimal(18, 6)), CAST(78.486671 AS Decimal(18, 6)), N'TATA HYDERBAD MARATHON 2022 ANNOUNCES RUN AS ONE
', N'Every Participant must have  their running shoes.', CAST(N'2022-01-10T08:02:49.360' AS DateTime))
INSERT [dbo].[Campaign] ([CampaignId], [MemberId], [CampaignTitle], [Image], [LocationId], [StartTime], [EndTime], [GeoLocation], [Latitude], [Longitude], [CampaignInfo], [SpecialInstructions], [CreatedDate]) VALUES (29, 95, N'Running Campaign', N'e3dcbfc2-81da-487a-afbb-f4bcd1cb11a4.jpeg', 0, CAST(N'2022-02-04T14:21:00.000' AS DateTime), CAST(N'2022-02-11T14:21:00.000' AS DateTime), N'Hyderabad, Telangana, India', CAST(17.385044 AS Decimal(18, 6)), CAST(78.486671 AS Decimal(18, 6)), N'running campaign ', N'Every person get their own pair of Shoes. ', CAST(N'2022-01-31T08:51:57.777' AS DateTime))
INSERT [dbo].[Campaign] ([CampaignId], [MemberId], [CampaignTitle], [Image], [LocationId], [StartTime], [EndTime], [GeoLocation], [Latitude], [Longitude], [CampaignInfo], [SpecialInstructions], [CreatedDate]) VALUES (30, 132, N'Running Campaign', N'f5b8eb28-186c-4960-9b28-2fc7e56e28b4.jpg', 0, CAST(N'2022-08-06T12:26:00.000' AS DateTime), CAST(N'2022-08-08T12:27:00.000' AS DateTime), N'Nizamabad, Telangana, India', CAST(18.672505 AS Decimal(18, 6)), CAST(78.094087 AS Decimal(18, 6)), NULL, N'Carry your won shoe with you.', CAST(N'2022-08-02T06:59:14.230' AS DateTime))
INSERT [dbo].[Campaign] ([CampaignId], [MemberId], [CampaignTitle], [Image], [LocationId], [StartTime], [EndTime], [GeoLocation], [Latitude], [Longitude], [CampaignInfo], [SpecialInstructions], [CreatedDate]) VALUES (31, 148, N'Campaign for Formula E car racing to kickstart in ', N'83339038-7994-4028-bf73-8033a44b6863.jpg', 0, CAST(N'2023-02-11T16:57:00.000' AS DateTime), CAST(N'2023-02-14T16:57:00.000' AS DateTime), N'Tank Bund Road, Gagan Mahal, Domalguda, Khairtabad, Hyderabad, Telangana, India', CAST(17.410459 AS Decimal(18, 6)), CAST(78.476241 AS Decimal(18, 6)), N'An earlier generation racing car will be on display for public on Tank Bund', NULL, CAST(N'2023-02-01T11:37:40.120' AS DateTime))
SET IDENTITY_INSERT [dbo].[Campaign] OFF
GO
SET IDENTITY_INSERT [dbo].[CampaignMember] ON 

INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (2, 4, 2, NULL, NULL, NULL)
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (3, 1, 3, N'""', NULL, CAST(N'2021-09-06T00:14:34.330' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (4, 11, 27, NULL, NULL, CAST(N'2021-09-06T00:51:29.793' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (5, 11, 27, NULL, NULL, CAST(N'2021-09-06T01:00:34.753' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (6, 1, 3, NULL, NULL, CAST(N'2021-09-06T02:10:12.660' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (7, 11, 29, NULL, NULL, CAST(N'2021-09-06T02:22:12.893' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (8, 11, 29, NULL, NULL, CAST(N'2021-09-06T02:24:22.277' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (9, 11, 29, NULL, NULL, CAST(N'2021-09-06T05:11:10.363' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (10, 11, 29, NULL, NULL, CAST(N'2021-09-06T05:12:23.010' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (11, 12, 52, N'this is Jannie', NULL, CAST(N'2021-09-06T08:39:07.137' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (12, 1, 3, N'""', NULL, CAST(N'2021-09-13T10:26:08.403' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (13, 11, 29, NULL, NULL, CAST(N'2021-09-17T17:10:04.080' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (14, 14, 52, NULL, NULL, CAST(N'2021-10-13T11:24:53.450' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (15, 14, 65, NULL, NULL, CAST(N'2021-10-22T11:01:06.943' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (16, 14, 66, NULL, NULL, CAST(N'2021-10-22T11:01:17.670' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (17, 16, 66, NULL, 0, CAST(N'2021-11-08T09:13:39.080' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (18, 16, 76, NULL, 0, CAST(N'2021-11-08T09:13:39.080' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (19, 17, 74, NULL, 1, CAST(N'2021-11-09T09:37:57.430' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (20, 17, 77, NULL, 0, CAST(N'2021-11-09T09:37:57.430' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (21, 18, 74, NULL, 1, CAST(N'2021-11-22T05:54:41.437' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (22, 19, 74, NULL, 1, CAST(N'2021-11-22T06:05:41.580' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (23, 20, 74, NULL, 1, CAST(N'2021-11-22T06:13:40.043' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (24, 21, 74, N'Hi', 1, CAST(N'2021-11-22T06:38:46.537' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (25, 21, 78, NULL, 0, CAST(N'2021-11-22T06:38:46.537' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (26, 22, 74, NULL, 1, CAST(N'2021-11-23T05:42:20.833' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (27, 23, 74, NULL, 0, CAST(N'2021-12-04T10:27:22.510' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (28, 23, 81, NULL, 1, CAST(N'2021-12-04T10:27:22.510' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (29, 24, 74, N'Hi', 1, CAST(N'2021-12-06T10:19:55.230' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (30, 25, 74, NULL, 1, CAST(N'2021-12-07T06:33:12.703' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (31, 26, 81, NULL, 1, CAST(N'2021-12-07T07:13:58.460' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (32, 27, 74, NULL, 0, CAST(N'2022-01-07T06:12:41.090' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (33, 28, 74, NULL, 1, CAST(N'2022-01-10T08:02:49.360' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (34, 28, 81, NULL, 0, CAST(N'2022-01-10T08:02:49.360' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (35, 29, 96, NULL, 0, CAST(N'2022-01-31T08:51:57.780' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (36, 29, 97, NULL, 0, CAST(N'2022-01-31T08:51:57.780' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (37, 30, 133, NULL, 1, CAST(N'2022-08-02T06:59:14.230' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (38, 31, 149, NULL, 0, CAST(N'2023-02-01T11:37:40.123' AS DateTime))
INSERT [dbo].[CampaignMember] ([CampaignMemberId], [CampaignId], [MemberId], [Message], [Status], [CreatedDate]) VALUES (39, 31, 150, NULL, 1, CAST(N'2023-02-01T11:37:40.123' AS DateTime))
SET IDENTITY_INSERT [dbo].[CampaignMember] OFF
GO
SET IDENTITY_INSERT [dbo].[CampaignMemberTracking] ON 

INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (1, 1, 23, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), CAST(N'2021-03-01T03:36:39.430' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (2, 1, 2, CAST(23.382700 AS Decimal(18, 6)), CAST(74.389800 AS Decimal(18, 6)), CAST(N'2021-03-01T03:36:49.470' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (3, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:36:57.703' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (4, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:36:57.717' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (5, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:37:47.920' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (6, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:37:47.933' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (7, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:38:38.083' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (8, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:38:38.083' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (9, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:39:28.260' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (10, 7, 23, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-01T03:39:28.263' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (11, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:01:50.383' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (12, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:02:26.103' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (13, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:03:16.370' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (14, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:04:06.547' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (15, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:04:56.783' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (16, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:05:47.027' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (17, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:06:04.337' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (18, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:06:41.743' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (19, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:06:46.270' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (20, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:07:31.513' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (21, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:07:36.530' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (22, 7, 27, CAST(37.400193 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:08:21.690' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (23, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:08:26.710' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (24, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:09:12.023' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (25, 7, 27, CAST(37.400183 AS Decimal(18, 6)), CAST(-122.074387 AS Decimal(18, 6)), CAST(N'2021-03-02T04:09:16.917' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (26, 9, 34, CAST(17.520480 AS Decimal(18, 6)), CAST(78.381073 AS Decimal(18, 6)), CAST(N'2021-03-24T11:13:10.417' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (27, 1, 35, CAST(12.910685 AS Decimal(18, 6)), CAST(77.554207 AS Decimal(18, 6)), CAST(N'2021-04-02T11:38:54.717' AS DateTime))
INSERT [dbo].[CampaignMemberTracking] ([CampaignMemberTrackingId], [CampaignId], [MemberId], [Latitude], [Longitude], [CreatedDate]) VALUES (28, 1, 35, CAST(12.910708 AS Decimal(18, 6)), CAST(77.554217 AS Decimal(18, 6)), CAST(N'2021-04-02T11:40:04.793' AS DateTime))
SET IDENTITY_INSERT [dbo].[CampaignMemberTracking] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatFriends] ON 

INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (1, 2, 3, 0, CAST(N'2021-02-20T03:02:10.877' AS DateTime), 3, CAST(N'2021-02-20T06:14:45.270' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (2, 24, 16, 0, CAST(N'2021-02-23T16:06:19.657' AS DateTime), 14, CAST(N'2021-02-25T04:18:08.173' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (3, 24, 25, 0, CAST(N'2021-02-25T02:02:34.430' AS DateTime), 13, CAST(N'2021-02-25T04:18:08.173' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (4, 27, 14, 0, CAST(N'2021-03-14T13:05:56.053' AS DateTime), 53, CAST(N'2021-04-06T14:45:44.370' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (6, 14, 26, 0, CAST(N'2021-03-14T14:27:46.967' AS DateTime), 25, CAST(N'2021-03-15T13:53:10.913' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (7, 30, 4, 0, CAST(N'2021-03-16T11:43:18.203' AS DateTime), 26, CAST(N'2021-03-16T11:43:18.203' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (8, 32, 34, 0, CAST(N'2021-03-29T07:10:13.767' AS DateTime), 56, CAST(N'2021-04-07T06:48:58.613' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (10, 46, 47, 0, CAST(N'2021-04-09T08:18:06.967' AS DateTime), 88, CAST(N'2021-04-16T09:48:01.007' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (11, 46, 4, 0, CAST(N'2021-04-09T10:18:21.493' AS DateTime), 69, CAST(N'2021-04-09T12:20:07.023' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (12, 46, 40, 0, CAST(N'2021-04-09T12:20:32.220' AS DateTime), 70, CAST(N'2021-04-09T12:20:32.220' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (13, 29, 27, 0, CAST(N'2021-04-09T13:05:40.363' AS DateTime), 77, CAST(N'2021-04-09T13:19:53.293' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (14, 29, 23, 0, CAST(N'2021-04-09T13:36:00.733' AS DateTime), 80, CAST(N'2021-04-10T14:27:00.610' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (15, 53, 52, 0, CAST(N'2021-09-06T09:56:44.790' AS DateTime), 99, CAST(N'2021-09-06T10:02:42.430' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (16, 65, 66, 0, CAST(N'2021-10-22T10:46:40.313' AS DateTime), 101, CAST(N'2021-10-22T10:46:54.950' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (17, 74, 77, 0, CAST(N'2021-11-09T09:49:45.107' AS DateTime), 106, CAST(N'2021-11-09T11:27:46.343' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (18, 77, 0, 0, CAST(N'2021-11-09T11:26:04.100' AS DateTime), 103, CAST(N'2021-11-09T11:26:04.100' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (19, 71, 75, 0, CAST(N'2021-11-10T02:53:49.930' AS DateTime), 115, CAST(N'2021-12-07T06:14:50.597' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (20, 74, 80, 0, CAST(N'2021-11-22T06:46:33.100' AS DateTime), 114, CAST(N'2021-12-07T06:13:31.927' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (21, 81, 74, 0, CAST(N'2021-12-07T07:05:36.670' AS DateTime), 118, CAST(N'2021-12-07T07:06:04.070' AS DateTime))
INSERT [dbo].[ChatFriends] ([ChatId], [MemberId1], [MemberId2], [IsGroup], [CreatedDate], [LastMessageId], [LastMessageDate]) VALUES (22, 86, 93, 0, CAST(N'2022-05-18T15:34:17.773' AS DateTime), 121, CAST(N'2022-05-18T15:34:33.587' AS DateTime))
SET IDENTITY_INSERT [dbo].[ChatFriends] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatMessages] ON 

INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (1, 2, 3, N'text7', N'', N'', 1, 1, CAST(N'2021-02-20T03:02:10.877' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (2, 2, 3, N'Hi', N'', N'', 1, 1, CAST(N'2021-02-20T06:05:16.170' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (3, 3, 2, N'Hello', N'', N'', 0, 1, CAST(N'2021-02-20T06:14:45.270' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (4, 24, 16, N'Hello', N'', N'', 0, 2, CAST(N'2021-02-23T16:06:19.657' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (5, 24, 16, N'Hi', N'', N'', 0, 2, CAST(N'2021-02-24T01:30:47.973' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (6, 24, 16, N'hello', N'', N'', 0, 2, CAST(N'2021-02-24T01:31:31.230' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (7, 24, 16, N'', N'', N'', 0, 2, CAST(N'2021-02-24T01:47:50.800' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (8, 24, 16, N'hello', N'', N'', 0, 2, CAST(N'2021-02-25T00:46:01.587' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (9, 24, 16, N'', N'', N'', 0, 2, CAST(N'2021-02-25T00:47:08.037' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (10, 24, 16, N'', N'24_16_image_3e6d60de-6d7b-4909-80e8-a13056c2c475..jpg', N'', 0, 2, CAST(N'2021-02-25T00:54:07.843' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (11, 24, 25, N'hi', N'', N'', 0, 3, CAST(N'2021-02-25T02:02:34.430' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (12, 24, 25, N'hi', N'', N'', 0, 3, CAST(N'2021-02-25T04:16:27.610' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (13, 24, 25, N'hi', N'', N'', 0, 3, CAST(N'2021-02-25T04:18:08.173' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (14, 24, 16, N'hi', N'', N'', 0, 2, CAST(N'2021-02-25T04:18:08.173' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (15, 27, 14, N'hi', N'', N'', 1, 4, CAST(N'2021-03-14T13:05:56.053' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (16, 34, 27, N'Hello
', N'', N'', 1, 4, CAST(N'2021-03-14T13:08:34.710' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (17, 34, 27, N'Hello', N'', N'', 1, 4, CAST(N'2021-03-14T13:12:43.453' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (18, 34, 27, N'Hi', N'', N'', 1, 4, CAST(N'2021-03-14T13:13:51.830' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (19, 34, 27, N'Hi', N'', N'', 1, 4, CAST(N'2021-03-14T13:30:53.877' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (20, 14, 27, N'Hi', N'', N'', 1, 4, CAST(N'2021-03-14T13:31:23.907' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (21, 14, 26, N'Hi', N'', N'', 0, 6, CAST(N'2021-03-14T14:27:46.967' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (22, 14, 26, N'Hello', N'', N'', 0, 6, CAST(N'2021-03-14T14:27:58.400' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (23, 14, 26, N'To', N'', N'', 0, 6, CAST(N'2021-03-14T14:30:56.820' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (24, 14, 26, N'Hi', N'', N'', 0, 6, CAST(N'2021-03-15T13:51:27.220' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (25, 14, 26, N'Hi', N'', N'', 0, 6, CAST(N'2021-03-15T13:53:10.913' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (26, 30, 4, N'Hi good evening ', N'', N'', 0, 7, CAST(N'2021-03-16T11:43:18.203' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (27, 27, 14, N'', N'', N'', 1, 4, CAST(N'2021-03-20T10:06:48.740' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (28, 27, 14, N'', N'', N'', 1, 4, CAST(N'2021-03-20T10:07:52.750' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (29, 27, 14, N'', N'', N'', 1, 4, CAST(N'2021-03-20T10:08:27.633' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (30, 27, 14, N'test', N'', N'', 1, 4, CAST(N'2021-03-20T10:12:13.767' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (31, 14, 27, N'', N'14__image_c9863756-db99-4984-92a5-36a546472f4a..jpg', N'', 1, 4, CAST(N'2021-03-20T10:27:14.500' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (32, 27, 14, N'', N'', N'', 1, 4, CAST(N'2021-03-20T10:33:35.577' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (33, 27, 14, N'', N'27_14_image_d54da61c-60c5-4485-a3ea-1a5f131985ed..jpg', N'', 1, 4, CAST(N'2021-03-20T10:36:31.997' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (34, 27, 14, N'', N'27__image_16714304-ba35-4495-b080-707567a50e8b..jpg', N'', 1, 4, CAST(N'2021-03-20T10:40:27.380' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (35, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-03-29T07:10:13.767' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (36, 34, 32, N'hay hi', N'', N'', 1, 8, CAST(N'2021-03-29T07:10:27.963' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (37, 32, 34, N'nice sunset', N'32__image_affa7386-e881-4e6d-91fc-6fa548e1aad7..jpg', N'', 1, 8, CAST(N'2021-03-29T07:11:26.100' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (38, 34, 32, N'yes', N'', N'', 1, 8, CAST(N'2021-03-29T07:11:58.920' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (39, 32, 34, N'yes', N'', N'', 1, 8, CAST(N'2021-03-29T07:12:31.770' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (40, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-03-29T07:13:00.560' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (41, 34, 32, N'good afternoon', N'', N'', 1, 8, CAST(N'2021-03-29T07:32:25.007' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (42, 34, 32, N'hi', N'', N'', 1, 8, CAST(N'2021-03-29T07:32:45.433' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (43, 27, 14, N'hi', N'', N'', 0, 4, CAST(N'2021-03-30T15:42:08.240' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (44, 32, 34, N'good afternoon', N'', N'', 1, 8, CAST(N'2021-03-31T05:49:24.183' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (45, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-03-31T07:22:28.707' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (46, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-03-31T11:41:01.750' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (47, 32, 34, N'hi hay', N'', N'', 1, 8, CAST(N'2021-03-31T11:42:06.003' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (48, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-04-06T11:42:52.457' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (49, 27, 14, N'hello', N'', N'', 0, 4, CAST(N'2021-04-06T14:36:01.963' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (50, 27, 14, N'test', N'', N'', 0, 4, CAST(N'2021-04-06T14:39:53.267' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (51, 27, 14, N'testing', N'', N'', 0, 4, CAST(N'2021-04-06T14:40:03.190' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (52, 27, 14, N'tedt', N'', N'', 0, 4, CAST(N'2021-04-06T14:43:39.247' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (53, 27, 14, N'hello', N'', N'', 0, 4, CAST(N'2021-04-06T14:45:44.370' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (54, 32, 34, N'good afternoon', N'', N'', 1, 8, CAST(N'2021-04-07T06:41:52.053' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (55, 32, 34, N'hi', N'', N'', 1, 8, CAST(N'2021-04-07T06:46:09.830' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (56, 32, 34, N'nice tree', N'32_34_image_b571c401-7662-45a9-a7fc-c4b16c2e55e1..jpg', N'', 1, 8, CAST(N'2021-04-07T06:48:58.613' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (57, 46, 47, N'Hi', N'', N'', 1, 10, CAST(N'2021-04-09T08:18:06.967' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (58, 46, 47, N'Good afternoon ', N'', N'', 1, 10, CAST(N'2021-04-09T08:18:23.270' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (59, 46, 47, N'', N'46__image_11c69d9d-a75c-4906-bf94-2f611f4440a9..jpg', N'', 1, 10, CAST(N'2021-04-09T08:19:03.393' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (60, 46, 47, N'', N'46__image_3e74e952-0a85-4f71-83a5-55d0185ec7b0..jpg', N'', 1, 10, CAST(N'2021-04-09T08:20:00.043' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (61, 46, 47, N'', N'46__image_f72bca0b-e1f9-466e-b744-35ef6f6d06ab..jpg', N'', 1, 10, CAST(N'2021-04-09T08:20:49.607' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (62, 46, 47, N'Good afternoon ', N'', N'', 1, 10, CAST(N'2021-04-09T08:21:39.860' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (63, 46, 47, N'Hi', N'', N'', 1, 10, CAST(N'2021-04-09T08:22:03.120' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (64, 46, 47, N'Test', N'', N'', 1, 10, CAST(N'2021-04-09T08:23:17.577' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (65, 47, 46, N'hi', N'', N'', 1, 10, CAST(N'2021-04-09T10:17:43.353' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (66, 46, 4, N'Hi', N'46_4_image_910d7d01-35c0-449e-a45f-ac623fc16407..jpg', N'', 0, 11, CAST(N'2021-04-09T10:18:21.493' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (67, 46, 4, N'Good evening ', N'', N'', 0, 11, CAST(N'2021-04-09T11:23:26.953' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (68, 46, 4, N'', N'46__image_8cac8481-5602-4c62-a24b-9aecfc70aa0c..jpg', N'', 0, 11, CAST(N'2021-04-09T11:23:44.517' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (69, 46, 4, N'Testing ', N'46__image_d7831bad-f06c-4688-9fe4-45286bccbe93..jpg', N'', 0, 11, CAST(N'2021-04-09T12:20:07.023' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (70, 46, 40, N'Hi', N'', N'', 0, 12, CAST(N'2021-04-09T12:20:32.220' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (71, 47, 46, N'hi', N'', N'', 1, 10, CAST(N'2021-04-09T12:43:12.580' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (72, 29, 27, N'Hi', N'', N'', 0, 13, CAST(N'2021-04-09T13:05:40.363' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (73, 29, 27, N'', N'29__image_45aecc9e-2bd4-4e09-9160-05e3282f1060..jpg', N'', 0, 13, CAST(N'2021-04-09T13:06:11.633' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (74, 29, 27, N'', N'29__image_42ad7eef-06ce-4600-9859-fb95c89aac41..jpg', N'', 0, 13, CAST(N'2021-04-09T13:06:32.570' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (75, 29, 27, N'', N'29__image_6c9c67f6-090a-4920-885f-004c410f323e..jpg', N'', 0, 13, CAST(N'2021-04-09T13:10:09.743' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (76, 29, 27, N'', N'29__image_26bd6d43-f147-4670-8cac-d7a8d6164935..jpg', N'', 0, 13, CAST(N'2021-04-09T13:16:50.450' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (77, 29, 27, N'', N'29__image_c8c93654-9a37-47e5-b9b0-e015bc41ab44..jpg', N'', 0, 13, CAST(N'2021-04-09T13:19:53.293' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (78, 29, 23, N'Hi', N'', N'', 0, 14, CAST(N'2021-04-09T13:36:00.733' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (79, 29, 23, N'', N'29__image_ee8588e4-fb53-4ee7-a100-67fd6a922aa2..jpg', N'', 0, 14, CAST(N'2021-04-10T14:08:40.407' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (80, 29, 23, N'hi fejfkj hash fjkahkjfhskj sdgksgdjsh gkjsdkjhdskjhsdkjgv jag gkjdsjk heading kjdshjkhdskjhsdjh HealthKit dkshkds kjhjkdsk jhkjsdh kjhkj hkhsdk hkhkshkjh Khadijah kjhjkskgsfks', N'', N'', 0, 14, CAST(N'2021-04-10T14:27:00.610' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (81, 46, 47, N'Hi', N'', N'', 0, 10, CAST(N'2021-04-12T06:27:44.020' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (82, 46, 47, N'Hi', N'', N'', 0, 10, CAST(N'2021-04-12T06:28:07.063' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (83, 46, 47, N'', N'46__image_a3c01135-566a-42d5-9690-59c16b425a26..jpg', N'', 0, 10, CAST(N'2021-04-12T06:28:29.620' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (84, 46, 47, N'Hi', N'', N'', 0, 10, CAST(N'2021-04-12T06:31:28.193' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (85, 46, 47, N'hello', N'', N'', 0, 10, CAST(N'2021-04-12T07:45:18.430' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (86, 46, 47, N'hi', N'', N'', 0, 10, CAST(N'2021-04-12T07:45:48.897' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (87, 46, 47, N'good evening', N'46__image_67fc71c8-14cb-4d17-9262-31cc74f82740..jpg', N'', 0, 10, CAST(N'2021-04-12T07:47:14.303' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (88, 46, 47, N'hi', N'', N'', 0, 10, CAST(N'2021-04-16T09:48:01.007' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (89, 53, 52, N'hi', N'', N'', 1, 15, CAST(N'2021-09-06T09:56:44.790' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (90, 52, 53, N'hi', N'', N'', 1, 15, CAST(N'2021-09-06T09:57:01.103' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (91, 53, 52, N'good morning', N'', N'', 1, 15, CAST(N'2021-09-06T09:57:11.430' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (92, 53, 52, N'good afternoon', N'', N'', 1, 15, CAST(N'2021-09-06T09:57:41.040' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (93, 53, 52, N'hi', N'', N'', 1, 15, CAST(N'2021-09-06T09:58:05.530' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (94, 52, 53, N'okay', N'', N'', 1, 15, CAST(N'2021-09-06T09:58:35.770' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (95, 52, 53, N'fine', N'', N'', 1, 15, CAST(N'2021-09-06T09:58:45.007' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (96, 53, 52, N'okay', N'', N'', 1, 15, CAST(N'2021-09-06T10:01:11.617' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (97, 52, 53, N'okay', N'', N'', 1, 15, CAST(N'2021-09-06T10:01:36.303' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (98, 53, 52, N'', N'', N'', 1, 15, CAST(N'2021-09-06T10:02:15.017' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (99, 52, 53, N'', N'', N'', 1, 15, CAST(N'2021-09-06T10:02:42.430' AS DateTime))
GO
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (100, 65, 66, N'Hi', N'', N'', 1, 16, CAST(N'2021-10-22T10:46:40.313' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (101, 66, 65, N'Hi', N'', N'', 1, 16, CAST(N'2021-10-22T10:46:54.950' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (102, 74, 77, N'Hi sir', N'', N'', 1, 17, CAST(N'2021-11-09T09:49:45.107' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (103, 77, 0, N'Hi design good ', N'77__image_0d66387d-91d1-4e08-94d4-bfe6edc9c7b3..jpg', N'', 0, 18, CAST(N'2021-11-09T11:26:04.100' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (104, 77, 74, N'The design is good', N'77_74_image_1295ae05-3976-4ec3-b967-cd977daee0f9..jpg', N'', 1, 17, CAST(N'2021-11-09T11:27:16.577' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (105, 74, 77, N'Hi', N'', N'', 1, 17, CAST(N'2021-11-09T11:27:38.800' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (106, 77, 74, N'Second message', N'77__image_186205ac-8540-409e-b09b-063db1df86e2..jpg', N'', 1, 17, CAST(N'2021-11-09T11:27:46.343' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (107, 71, 75, N'Hi
', N'', N'', 1, 19, CAST(N'2021-11-10T02:53:49.930' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (108, 74, 80, N'Hi', N'', N'', 0, 20, CAST(N'2021-11-22T06:46:33.100' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (109, 74, 80, N'Hi', N'', N'', 0, 20, CAST(N'2021-12-07T06:07:33.533' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (110, 75, 71, N'Hi', N'', N'', 0, 19, CAST(N'2021-12-07T06:11:41.870' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (111, 75, 71, N'Good morning', N'', N'', 0, 19, CAST(N'2021-12-07T06:12:16.777' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (112, 75, 71, N'Good evening', N'', N'', 0, 19, CAST(N'2021-12-07T06:12:41.600' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (113, 74, 80, N'Hi', N'', N'', 0, 20, CAST(N'2021-12-07T06:13:11.580' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (114, 74, 80, N'Hi good afternoon ', N'', N'', 0, 20, CAST(N'2021-12-07T06:13:31.927' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (115, 75, 71, N'Hi', N'', N'', 0, 19, CAST(N'2021-12-07T06:14:50.597' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (116, 81, 74, N'Hi…', N'', N'', 1, 21, CAST(N'2021-12-07T07:05:36.670' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (117, 74, 81, N'Hi', N'', N'', 1, 21, CAST(N'2021-12-07T07:05:46.017' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (118, 74, 81, N'Good afternoon ', N'', N'', 1, 21, CAST(N'2021-12-07T07:06:04.070' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (119, 86, 93, N'hi', N'', N'', 0, 22, CAST(N'2022-05-18T15:34:17.773' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (120, 86, 93, N'', N'', N'', 0, 22, CAST(N'2022-05-18T15:34:29.780' AS DateTime))
INSERT [dbo].[ChatMessages] ([MessageId], [FromCId], [ToCId], [MessageText], [Image], [Video], [IsViewed], [ChatId], [CreatedDate]) VALUES (121, 86, 93, N'hello', N'', N'', 0, 22, CAST(N'2022-05-18T15:34:33.587' AS DateTime))
SET IDENTITY_INSERT [dbo].[ChatMessages] OFF
GO
SET IDENTITY_INSERT [dbo].[Country] ON 

INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (1, N'India', 1, N'91', N'Indian-flag.png', N'Democratic Country', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (2, N'Australia', 2, N'61', N'Australia-flag.png', NULL, NULL)
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (3, N'USA', 3, N'1', N'United-States-Flag.png', NULL, NULL)
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (4, N'Canada', 4, N'1', N'canadaflag.png', NULL, CAST(N'2021-04-07T09:08:00' AS SmallDateTime))
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (5, N'UK', 5, N'44', N'uk.png', NULL, CAST(N'2021-04-07T09:10:00' AS SmallDateTime))
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (6, N'Kuwait', 6, N'965', N'kuwait.png', NULL, CAST(N'2021-04-07T09:12:00' AS SmallDateTime))
INSERT [dbo].[Country] ([CountryId], [Country], [ContinentId], [CountryCode], [Countryflag], [CountryInfo], [CreatedDate]) VALUES (7, N'New Zealand', 2, N'64', NULL, NULL, CAST(N'2021-04-07T09:12:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Country] OFF
GO
SET IDENTITY_INSERT [dbo].[GroupMessage] ON 

INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (1, 1, 2, N'hello', N'', N'', CAST(N'2021-02-22T03:07:19.417' AS DateTime), NULL, NULL, 2, CAST(N'2021-02-22T05:03:51.407' AS DateTime), -1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (2, 1, 4, N'hello', N'', N'', CAST(N'2021-02-22T04:15:17.980' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (3, 0, 24, N'test Message', N'', N'', CAST(N'2021-02-24T02:30:40.483' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (4, 0, 24, N'test', N'', N'', CAST(N'2021-02-25T00:56:55.920' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (5, 0, 24, N'', N'0_image_4aed0e61-15ef-4a41-8485-723cf66b3eb5..jpg', N'', CAST(N'2021-02-25T01:50:43.040' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (6, 0, 24, N'', N'0_image_46443372-00ef-4c6b-947e-15b48f8e220e..jpg', N'', CAST(N'2021-02-25T01:50:43.127' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (7, 0, 24, N'testing', N'', N'', CAST(N'2021-02-25T03:41:03.523' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (8, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T08:43:15.760' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (9, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T08:43:52.603' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (10, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T08:44:34.260' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (11, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T08:46:45.003' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (12, 0, 27, N'test', N'', N'', CAST(N'2021-03-14T08:58:02.077' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (13, 0, 27, N'testing', N'', N'', CAST(N'2021-03-14T08:59:51.267' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (14, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T09:02:08.217' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (15, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T14:23:37.987' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (16, 1, 34, N'Hi', N'', N'', CAST(N'2021-03-14T14:27:29.990' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (17, 1, 34, N'Hello', N'', N'', CAST(N'2021-03-14T14:28:05.140' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (18, 1, 34, N'Hellow', N'', N'', CAST(N'2021-03-14T14:29:39.980' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (19, 1, 34, N'Hi good evening ', N'', N'', CAST(N'2021-03-16T11:00:59.950' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (20, 1, 34, N'Good afternoon all', N'', N'', CAST(N'2021-03-29T07:33:18.873' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (21, 0, 34, N'good morning all', N'', N'', CAST(N'2021-03-29T07:33:45.613' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (22, 1, 34, N'Hi all', N'', N'', CAST(N'2021-03-29T07:37:21.650' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (23, 0, 27, N'good morning', N'', N'', CAST(N'2021-03-30T15:42:28.503' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (24, 0, 27, N'test', N'', N'', CAST(N'2021-03-30T15:44:21.510' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (25, 0, 27, N'testing', N'', N'', CAST(N'2021-03-30T15:45:02.100' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (26, 0, 32, N'good morning all', N'', N'', CAST(N'2021-03-31T07:49:56.143' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (27, 0, 31, N'testing from Charles', N'0_image_46e2ae2a-a6f2-43fa-937d-2e3efe2ff98b..jpg', N'', CAST(N'2021-04-06T00:42:14.237' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (28, 0, 31, N'testing from Charles', N'0_image_7fc0a703-a50a-4fb3-996f-8cf5c4db0de4..jpg', N'', CAST(N'2021-04-06T00:42:14.280' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (29, 0, 31, N'testing from Charles', N'0_image_dce8a1a7-914f-4650-933a-7b5a585a3f9e..jpg', N'', CAST(N'2021-04-06T00:42:14.303' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (30, 0, 31, N'test', N'', N'', CAST(N'2021-04-06T02:07:26.193' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (31, 0, 0, N'hi', N'', N'', CAST(N'2021-04-07T05:20:42.283' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (32, 0, 0, N'hi', N'', N'', CAST(N'2021-04-07T05:21:09.993' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (33, 0, 32, N'good evening all', N'0_image_de3e49c4-3d88-466f-9a6b-98a06daba9b6..jpg', N'', CAST(N'2021-04-07T06:52:06.453' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (34, 0, 32, N'good evening', N'', N'', CAST(N'2021-04-07T11:35:11.960' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (35, 1, 34, N'Good afternoon ', N'1_image_bf03aaa6-1665-4c7f-8811-7569a090eef9..jpg', N'', CAST(N'2021-04-09T10:20:04.557' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (36, 1, 34, N'Good evening ', N'1_image_44cf85e4-78a7-4dcb-89e3-e4f6179b2484..jpg', N'', CAST(N'2021-04-09T11:24:37.157' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (37, 1, 34, N'Testing from charles', N'', N'', CAST(N'2021-10-27T07:32:00.613' AS DateTime), NULL, NULL, NULL, NULL, 1)
INSERT [dbo].[GroupMessage] ([GMSGId], [CGId], [MemberId], [Message], [PostImage], [PostVideo], [PostedDate], [ApprovedBy], [ApprovedDate], [RemovedBy], [RemovedDate], [Status]) VALUES (38, 1, 34, N'Hi design good ', N'1_image_89e0decb-e8e0-4fd4-843c-1c62ce7c1888..jpg', N'', CAST(N'2021-11-09T11:26:07.923' AS DateTime), NULL, NULL, NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[GroupMessage] OFF
GO
SET IDENTITY_INSERT [dbo].[Help] ON 

INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (1, 11, 28, N'test', N'', CAST(12.911144 AS Decimal(18, 6)), CAST(77.556031 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-13T07:49:45.043' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (2, 12, 28, N'test', N'', CAST(12.911399 AS Decimal(18, 6)), CAST(77.555726 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-13T08:39:12.560' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (3, 13, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 2, NULL, 37, CAST(N'2021-02-13T09:00:30.617' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (4, 2, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-15T05:10:21.177' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (5, 2, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 2, NULL, NULL, CAST(N'2021-02-15T05:17:40.990' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (6, 2, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-15T05:24:06.683' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (7, 2, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-15T05:25:53.513' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (8, 2, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-15T05:30:48.297' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (9, 14, 28, N'test', N'', CAST(28.047305 AS Decimal(18, 6)), CAST(28.047305 AS Decimal(18, 6)), NULL, 2, NULL, NULL, CAST(N'2021-02-15T09:54:31.197' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10, 13, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-16T01:46:07.317' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11, 13, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-16T01:46:12.950' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (12, 17, 28, N'test', N'', CAST(13.610169 AS Decimal(18, 6)), CAST(79.586506 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-16T03:28:22.367' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (13, 17, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-16T03:35:26.173' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (14, 17, 28, N'test', N'', CAST(13.613653 AS Decimal(18, 6)), CAST(79.587861 AS Decimal(18, 6)), NULL, 2, NULL, NULL, CAST(N'2021-02-16T03:36:00.113' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (15, 18, 28, N'test', N'', CAST(13.613704 AS Decimal(18, 6)), CAST(79.587858 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-16T03:39:33.653' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (16, 18, 28, N'test', N'', CAST(13.613784 AS Decimal(18, 6)), CAST(79.587866 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-16T03:40:57.680' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (17, 19, 28, N'test', N'', CAST(13.613594 AS Decimal(18, 6)), CAST(79.587655 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-17T03:10:25.673' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (18, 21, 28, N'test', N'', CAST(13.613700 AS Decimal(18, 6)), CAST(79.587835 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-17T03:21:12.220' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (19, 23, 28, N'test', N'', CAST(12.783082 AS Decimal(18, 6)), CAST(77.658155 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-17T11:56:57.990' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (20, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-17T14:19:55.647' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (21, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-17T14:19:57.647' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (22, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-17T14:22:51.413' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (23, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-17T14:23:33.733' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (24, 14, 28, N'test', N'', CAST(77.657906 AS Decimal(18, 6)), CAST(77.657906 AS Decimal(18, 6)), NULL, 2, NULL, NULL, CAST(N'2021-02-17T17:38:40.113' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (25, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-18T06:39:06.063' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (26, 24, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-18T14:39:39.180' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (27, 24, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-18T14:57:31.093' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (28, 24, 28, N'test', N'', CAST(37.421998 AS Decimal(18, 6)), CAST(-122.084000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-02-18T14:57:37.780' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (29, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-22T15:40:46.187' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (30, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-26T07:02:15.227' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (31, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-26T07:07:20.363' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (32, 14, 28, N'test', N'', CAST(-0.133700 AS Decimal(18, 6)), CAST(-0.133700 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-26T07:09:09.040' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (33, 15, 28, N'', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-02-26T08:06:18.677' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (34, 15, 28, N'', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-26T08:07:23.797' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (35, 15, 28, N'', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 1, NULL, NULL, CAST(N'2021-02-26T08:08:35.100' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (36, 15, 28, N'', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-02-26T08:09:55.977' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (37, 15, 28, N'', N'', CAST(15.830925 AS Decimal(18, 6)), CAST(78.042537 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-02-26T11:26:15.177' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (38, 24, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-01T03:09:15.167' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (39, 24, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-01T03:09:19.727' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (40, 24, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-01T03:15:06.083' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (41, 24, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-01T03:15:14.510' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (51, 14, 28, N'test', N'', CAST(78.422250 AS Decimal(18, 6)), CAST(78.422250 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T07:12:28.777' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (52, 14, 28, N'test', N'', CAST(78.422266 AS Decimal(18, 6)), CAST(78.422266 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T07:12:32.253' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (53, 14, 28, N'test', N'', CAST(17.504311 AS Decimal(18, 6)), CAST(78.422305 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T07:14:32.627' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (54, 14, 28, N'test', N'', CAST(17.504288 AS Decimal(18, 6)), CAST(78.422299 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T07:31:35.660' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (55, 24, NULL, N'test', N'', CAST(17.512980 AS Decimal(18, 6)), CAST(78.391496 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-16T10:56:26.480' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (56, 24, NULL, N'test', N'', CAST(17.512978 AS Decimal(18, 6)), CAST(78.391491 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-16T10:56:38.840' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (57, 24, NULL, N'test', N'', CAST(17.512901 AS Decimal(18, 6)), CAST(78.391523 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-16T10:56:51.837' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (58, 30, 8, N'test', N'', CAST(17.520433 AS Decimal(18, 6)), CAST(78.381591 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T11:04:28.713' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (59, 30, 8, N'test', N'', CAST(17.520129 AS Decimal(18, 6)), CAST(78.381614 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T11:27:16.497' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (60, 30, 8, N'test', N'', CAST(17.519889 AS Decimal(18, 6)), CAST(78.381506 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-16T11:45:22.603' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (61, 3, 28, N'test', N'', CAST(19.017615 AS Decimal(18, 6)), CAST(72.856164 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-24T02:02:43.257' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (62, 3, 28, N'test', N'', CAST(19.017615 AS Decimal(18, 6)), CAST(72.856164 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-24T02:08:18.903' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (63, 3, 28, N'test', N'', CAST(19.017615 AS Decimal(18, 6)), CAST(72.856164 AS Decimal(18, 6)), NULL, 2, N'3', 3, CAST(N'2021-03-24T02:17:20.793' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (64, 3, 28, N'test', N'', CAST(19.017615 AS Decimal(18, 6)), CAST(72.856164 AS Decimal(18, 6)), NULL, 1, N'3', NULL, CAST(N'2021-03-24T02:36:02.470' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (65, 25, NULL, N'test', N'', CAST(-27.925610 AS Decimal(18, 6)), CAST(153.382236 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-24T04:37:54.337' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (74, 31, 8, N'test', N'', CAST(-27.925686 AS Decimal(18, 6)), CAST(153.382141 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-28T07:11:20.223' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (77, 31, 8, N'test', N'', CAST(40.719656 AS Decimal(18, 6)), CAST(29.819880 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-03-29T04:32:37.000' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (102, 35, 28, N'test', N'', CAST(12.910725 AS Decimal(18, 6)), CAST(77.554243 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-02T11:17:05.420' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (103, 35, 28, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-02T11:24:27.573' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (104, 31, 8, N'test', N'', CAST(-27.925614 AS Decimal(18, 6)), CAST(153.382188 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-06T00:35:47.460' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (105, 31, 8, N'test', N'', CAST(-27.925614 AS Decimal(18, 6)), CAST(153.382188 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-06T00:35:47.960' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (114, 14, NULL, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T02:29:55.033' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (115, 14, NULL, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T02:43:23.830' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (116, 14, NULL, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T02:49:08.163' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (117, 14, NULL, N'', N'', CAST(16.989100 AS Decimal(18, 6)), CAST(82.247500 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T02:50:49.627' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (118, 14, 28, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T02:55:19.063' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (119, 0, NULL, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T05:18:05.680' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (122, 0, NULL, N'test', N'', CAST(18.103837 AS Decimal(18, 6)), CAST(78.841108 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T07:17:49.820' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (125, 61, NULL, N'test', N'', CAST(15.355448 AS Decimal(18, 6)), CAST(77.524058 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T12:14:05.717' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (126, 0, NULL, N'test', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T23:21:48.137' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (127, 0, NULL, N'test', N'', CAST(18.105424 AS Decimal(18, 6)), CAST(78.839687 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-07T23:21:54.110' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (128, 46, 28, N'test', N'', CAST(15.355438 AS Decimal(18, 6)), CAST(77.524090 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-09T07:58:23.057' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (129, 46, 28, N'test', N'', CAST(15.355450 AS Decimal(18, 6)), CAST(77.524118 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-09T08:26:30.480' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (130, 46, 28, N'test', N'', CAST(15.355393 AS Decimal(18, 6)), CAST(77.524094 AS Decimal(18, 6)), NULL, 1, N'42,47,', NULL, CAST(N'2021-04-09T09:18:21.357' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (131, 46, 28, N'test', N'', CAST(15.355473 AS Decimal(18, 6)), CAST(77.524108 AS Decimal(18, 6)), NULL, 1, N'47', NULL, CAST(N'2021-04-09T09:23:38.293' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (133, 31, 8, N'test', N'', CAST(-27.487835 AS Decimal(18, 6)), CAST(153.038800 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-10T10:21:56.537' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (134, 46, 28, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-12T08:17:14.487' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (135, 8, 8, N'test', N'', CAST(-27.925662 AS Decimal(18, 6)), CAST(153.382120 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-04-19T01:20:07.063' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (136, 8, 8, N'test', N'', CAST(-27.925746 AS Decimal(18, 6)), CAST(153.382096 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-05-17T02:48:50.263' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (137, 8, 8, N'test', N'', CAST(-27.925856 AS Decimal(18, 6)), CAST(153.382063 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-07-22T04:57:55.953' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (138, 8, 8, N'test', N'', CAST(-27.925563 AS Decimal(18, 6)), CAST(153.382244 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-07-22T04:59:18.470' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (147, 52, 48, N'', N'', CAST(17.520562 AS Decimal(18, 6)), CAST(78.381483 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-08-12T10:02:06.493' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (148, 52, 48, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 1, N'3', NULL, CAST(N'2021-08-12T10:03:58.790' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (155, 0, NULL, N'test', N'', CAST(17.520353 AS Decimal(18, 6)), CAST(78.381411 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-03T07:06:47.947' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (156, 0, NULL, N'test', N'', CAST(17.520166 AS Decimal(18, 6)), CAST(78.381351 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-03T08:56:35.860' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (157, 0, NULL, N'test', N'', CAST(17.520193 AS Decimal(18, 6)), CAST(78.381585 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-03T08:58:35.777' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (158, 0, NULL, N'test', N'', CAST(17.520344 AS Decimal(18, 6)), CAST(78.381472 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-03T09:14:02.853' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (159, 52, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T07:59:19.467' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (160, 52, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T08:01:50.120' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (162, 52, NULL, N'', N'', CAST(17.520330 AS Decimal(18, 6)), CAST(78.381436 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T08:50:08.343' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (163, 52, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T08:57:32.350' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (166, 52, NULL, N'', N'', CAST(17.520315 AS Decimal(18, 6)), CAST(78.381437 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T09:01:19.073' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (167, 52, NULL, N'', N'', CAST(17.520373 AS Decimal(18, 6)), CAST(78.381488 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-06T09:04:26.313' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (170, 2, 8, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-07T04:56:37.653' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (171, 52, 8, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-07T05:41:58.890' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (174, 2, 8, N'test', N'', CAST(63.384787 AS Decimal(18, 6)), CAST(34.873890 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-09-15T11:30:56.067' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (175, 52, 0, N'test', N'', CAST(15.355476 AS Decimal(18, 6)), CAST(77.524106 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-13T11:30:57.687' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (176, 0, NULL, N'', N'', CAST(15.355473 AS Decimal(18, 6)), CAST(77.523980 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T06:14:48.863' AS DateTime))
GO
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (177, 0, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T06:31:30.973' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (178, 0, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T06:31:33.890' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (179, 0, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T06:31:39.763' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (180, 5, 8, N'test', N'', CAST(15.355455 AS Decimal(18, 6)), CAST(77.524121 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T08:48:11.663' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (181, 31, 8, N'test', N'', CAST(-27.925872 AS Decimal(18, 6)), CAST(153.382103 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T09:50:53.547' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (182, 0, NULL, N'', N'', CAST(15.355692 AS Decimal(18, 6)), CAST(77.524212 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T11:46:11.717' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (183, 0, NULL, N'', N'', CAST(15.355693 AS Decimal(18, 6)), CAST(77.524209 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-14T11:46:17.977' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (184, 64, 59, N'test', N'', CAST(15.355502 AS Decimal(18, 6)), CAST(77.524176 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-18T05:48:42.277' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (185, 64, 59, N'test', N'', CAST(15.355413 AS Decimal(18, 6)), CAST(77.524227 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-18T11:29:12.453' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (186, 60, 59, N'', N'', CAST(15.355536 AS Decimal(18, 6)), CAST(77.524083 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-22T07:11:24.590' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (187, 60, 59, N'', N'', CAST(15.355537 AS Decimal(18, 6)), CAST(77.524091 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-10-22T07:19:32.747' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (204, 64, NULL, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-11-02T04:38:13.033' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (205, 64, NULL, N'', N'', CAST(13.613430 AS Decimal(18, 6)), CAST(79.587940 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-11-02T04:41:04.753' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (206, 64, NULL, N'', N'', CAST(13.613565 AS Decimal(18, 6)), CAST(79.587897 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-11-02T04:41:13.577' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (209, 64, NULL, N'test', N'', CAST(17.502016 AS Decimal(18, 6)), CAST(78.423795 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2021-11-02T11:58:42.237' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (310, 74, 72, N'Need Help.', N'74_110202290707AM.png', CAST(15.355430 AS Decimal(18, 6)), CAST(77.524378 AS Decimal(18, 6)), N'518380', 0, NULL, NULL, CAST(N'2022-01-10T09:07:07.080' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (348, 74, 72, N'Need Help.', N'74_113202292806AM.png', CAST(15.351570 AS Decimal(18, 6)), CAST(77.510789 AS Decimal(18, 6)), N'518380', 0, NULL, NULL, CAST(N'2022-01-13T09:28:06.763' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (350, 74, 72, N'', N'', CAST(15.361943 AS Decimal(18, 6)), CAST(77.520632 AS Decimal(18, 6)), N'518380', 1, N'80,79,75,', NULL, CAST(N'2022-01-13T09:28:53.580' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (351, 74, 72, N'Need Help.', N'74_113202292946AM.png', CAST(15.351570 AS Decimal(18, 6)), CAST(77.510789 AS Decimal(18, 6)), N'518380', 1, N'80,79,75,', NULL, CAST(N'2022-01-13T09:29:46.923' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (356, 74, 72, N'Need Help.', N'74_1132022102245AM.png', CAST(15.355469 AS Decimal(18, 6)), CAST(77.524111 AS Decimal(18, 6)), N'518380', 0, NULL, NULL, CAST(N'2022-01-13T10:22:45.463' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (363, 72, 0, N'', N'', CAST(17.426459 AS Decimal(18, 6)), CAST(78.326463 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-01-14T02:47:59.683' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (364, 72, 0, N'', N'', CAST(17.426459 AS Decimal(18, 6)), CAST(78.326463 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-01-14T02:48:08.977' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (382, 89, 0, N'Need Help.', N'89_122202230706AM.png', CAST(-33.971250 AS Decimal(18, 6)), CAST(151.089351 AS Decimal(18, 6)), N'2222', 0, NULL, NULL, CAST(N'2022-01-22T03:07:06.583' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (386, 74, NULL, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381496 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2022-01-24T11:05:30.373' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (387, 74, NULL, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381496 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2022-01-24T11:05:34.423' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (582, 122, 122, N'Need Help.', N'122_3112022115819AM.png', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', 1, N'96,113,81,94,93,', NULL, CAST(N'2022-03-11T11:58:19.420' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10634, 0, 0, N'Need Help.', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', 0, NULL, NULL, CAST(N'2022-07-14T09:22:46.430' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10703, 134, 132, N'', N'', CAST(17.520186 AS Decimal(18, 6)), CAST(78.385111 AS Decimal(18, 6)), N'500090', 2, N'81,94,93,108,106,', NULL, CAST(N'2022-08-08T06:29:11.353' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10704, 133, 132, N'', N'', CAST(17.520332 AS Decimal(18, 6)), CAST(78.381490 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2022-08-08T06:54:05.053' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10705, 134, 132, N'Need Help.', N'134_88202290642AM.png', CAST(17.520325 AS Decimal(18, 6)), CAST(78.381462 AS Decimal(18, 6)), N'500090', 1, N'81,94,93,108,106,', NULL, CAST(N'2022-08-08T09:06:42.150' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10706, 134, 132, N'Need Help.', N'134_88202293429AM.png', CAST(17.520325 AS Decimal(18, 6)), CAST(78.381462 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2022-08-08T09:34:29.550' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10707, 134, 132, N'Need Help.', N'134_88202293517AM.png', CAST(17.520325 AS Decimal(18, 6)), CAST(78.381462 AS Decimal(18, 6)), N'500090', 2, NULL, NULL, CAST(N'2022-08-08T09:35:17.890' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10708, 134, 132, N'Need Help.', N'134_88202293549AM.png', CAST(17.520325 AS Decimal(18, 6)), CAST(78.381462 AS Decimal(18, 6)), N'500090', 1, N'81,94,93,108,106,', NULL, CAST(N'2022-08-08T09:35:49.453' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10709, 133, 132, N'Need Help.', N'133_8102022110825AM.png', CAST(17.466248 AS Decimal(18, 6)), CAST(78.284776 AS Decimal(18, 6)), N'502032', 1, N'92,134,137,138,133,81,94,91,125,93,', NULL, CAST(N'2022-08-10T11:08:25.213' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10724, 63, 63, N'Need Help.', N'63_812202233835PM.png', CAST(17.436111 AS Decimal(18, 6)), CAST(78.453910 AS Decimal(18, 6)), N'500016', 1, N'81,138,141,133,92,134,137,143,140,94,', NULL, CAST(N'2022-08-12T15:38:35.780' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10725, 63, 63, N'Need Help.', N'63_812202234315PM.png', CAST(17.436096 AS Decimal(18, 6)), CAST(78.453828 AS Decimal(18, 6)), N'500016', 1, N'81,138,141,133,92,134,137,143,140,94,', NULL, CAST(N'2022-08-12T15:43:15.023' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10726, 132, 132, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'90,125,140,92,133,134,137,141,143,138,', NULL, CAST(N'2022-08-13T11:12:43.887' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10727, 132, 132, N'', N'', CAST(17.426461 AS Decimal(18, 6)), CAST(78.326456 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T11:13:20.733' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10728, 132, 132, N'', N'', CAST(17.426458 AS Decimal(18, 6)), CAST(78.326447 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T11:45:15.860' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10729, 134, 132, N'', N'', CAST(17.426456 AS Decimal(18, 6)), CAST(78.326462 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-08-13T11:45:52.327' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10730, 132, 132, N'', N'', CAST(17.426471 AS Decimal(18, 6)), CAST(78.326456 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T11:56:03.420' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10731, 132, 132, N'', N'', CAST(17.426472 AS Decimal(18, 6)), CAST(78.326446 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T11:57:18.200' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10732, 134, 132, N'', N'', CAST(17.426506 AS Decimal(18, 6)), CAST(78.326397 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-08-13T11:59:09.430' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10733, 134, 132, N'', N'', CAST(17.426529 AS Decimal(18, 6)), CAST(78.326511 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T12:00:16.743' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10734, 134, 132, N'', N'', CAST(17.426529 AS Decimal(18, 6)), CAST(78.326511 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-08-13T12:00:16.920' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10735, 134, 132, N'', N'', CAST(17.426512 AS Decimal(18, 6)), CAST(78.326393 AS Decimal(18, 6)), N'500075', 2, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T12:02:13.983' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10736, 134, 132, N'', N'', CAST(17.426477 AS Decimal(18, 6)), CAST(78.326478 AS Decimal(18, 6)), N'500075', 2, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-13T12:03:34.733' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10738, 132, 132, N'', N'', CAST(17.426486 AS Decimal(18, 6)), CAST(78.326452 AS Decimal(18, 6)), N'500075', 2, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-18T01:51:46.517' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10739, 132, 132, N'', N'', CAST(17.426499 AS Decimal(18, 6)), CAST(78.326453 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-18T02:47:35.993' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10740, 132, 132, N'', N'', CAST(17.426455 AS Decimal(18, 6)), CAST(78.326370 AS Decimal(18, 6)), N'500075', 1, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-18T02:48:49.260' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10741, 132, 132, N'', N'', CAST(17.426456 AS Decimal(18, 6)), CAST(78.326469 AS Decimal(18, 6)), N'500075', 2, N'138,141,92,134,137,143,133,81,140,94,', NULL, CAST(N'2022-08-18T02:53:05.753' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10742, 133, 132, N'', N'', CAST(17.426477 AS Decimal(18, 6)), CAST(78.326360 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-08-18T03:04:05.497' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10743, 133, 132, N'', N'', CAST(17.426458 AS Decimal(18, 6)), CAST(78.326473 AS Decimal(18, 6)), N'500075', 0, NULL, NULL, CAST(N'2022-08-18T03:10:35.897' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10746, 63, 63, N'Need Help.', N'63_8222022101524AM.png', CAST(16.229539 AS Decimal(18, 6)), CAST(80.641122 AS Decimal(18, 6)), N'522202', 0, NULL, NULL, CAST(N'2022-08-22T10:15:24.303' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10747, 138, 132, N'', N'', CAST(17.520320 AS Decimal(18, 6)), CAST(78.381455 AS Decimal(18, 6)), N'500090', 1, N'92,133,134,137,143,141,138,140,81,94,', NULL, CAST(N'2022-08-26T10:30:04.523' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10757, 133, 133, N'Need Help', N'', CAST(17.520349 AS Decimal(18, 6)), CAST(78.381497 AS Decimal(18, 6)), N'', 1, N'92,133,134,137,143,141,138,140,81,94,', NULL, CAST(N'2022-09-05T10:20:39.130' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10758, 63, 63, N'Need Help.', N'63_99202253507AM.png', CAST(17.419553 AS Decimal(18, 6)), CAST(78.447802 AS Decimal(18, 6)), N'500034', 1, N'81,138,141,92,133,134,137,143,140,94,', NULL, CAST(N'2022-09-09T05:35:07.450' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10759, 63, 63, N'Need Help.', N'63_912202210223PM.png', CAST(16.980026 AS Decimal(18, 6)), CAST(82.230307 AS Decimal(18, 6)), N'533001', 1, N'93,91,94,81,138,141,92,133,143,134,', NULL, CAST(N'2022-09-12T13:02:23.477' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10767, 0, 0, N'Need Help.', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(144.592878 AS Decimal(18, 6)), N'3024', 0, NULL, NULL, CAST(N'2022-10-28T19:23:21.020' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10768, 63, 63, N'Need Help.', N'63_10302022105226AM.png', CAST(-37.873749 AS Decimal(18, 6)), CAST(144.592875 AS Decimal(18, 6)), N'3024', 1, N'106,109,100,99,101,104,102,107,108,83,', NULL, CAST(N'2022-10-30T10:52:26.840' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10769, 63, 63, N'Need Help.', N'63_10302022111914AM.png', CAST(-37.873566 AS Decimal(18, 6)), CAST(144.592988 AS Decimal(18, 6)), N'3024', 1, N'106,109,100,99,101,104,102,107,108,83,', NULL, CAST(N'2022-10-30T11:19:14.723' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10770, 63, 63, N'Need Help.', N'63_10302022111958AM.png', CAST(-37.873688 AS Decimal(18, 6)), CAST(144.592859 AS Decimal(18, 6)), N'3024', 0, NULL, NULL, CAST(N'2022-10-30T11:19:58.333' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10771, 63, 63, N'Need Help.', N'63_1215202231850PM.png', CAST(16.953293 AS Decimal(18, 6)), CAST(82.236335 AS Decimal(18, 6)), N'533001', 0, NULL, NULL, CAST(N'2022-12-15T15:18:50.650' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10773, 138, 132, N'', N'', CAST(17.520344 AS Decimal(18, 6)), CAST(78.381503 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-01-31T10:12:19.843' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10774, 132, 132, N'Need Help.', N'132_1312023101554AM.png', CAST(17.520233 AS Decimal(18, 6)), CAST(78.381494 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-01-31T10:15:54.623' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10775, 138, 132, N'', N'', CAST(17.520337 AS Decimal(18, 6)), CAST(78.381491 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-01-31T10:17:21.620' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10776, 132, 132, N'Need Help.', N'132_1312023101859AM.png', CAST(17.520233 AS Decimal(18, 6)), CAST(78.381494 AS Decimal(18, 6)), N'500090', 1, N'92,133,134,137,143,141,138,140,81,94,', NULL, CAST(N'2023-01-31T10:18:59.973' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10784, 63, 63, N'Need Help.', N'63_21202310401PM.png', CAST(16.980011 AS Decimal(18, 6)), CAST(82.230378 AS Decimal(18, 6)), N'533003', 1, N'146,147,93,91,94,81,138,141,149,92,', NULL, CAST(N'2023-02-01T13:04:01.920' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10878, 148, 0, NULL, N'', CAST(17.483353 AS Decimal(18, 6)), CAST(78.387067 AS Decimal(18, 6)), N'500085', 0, NULL, NULL, CAST(N'2023-02-06T13:29:51.413' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10965, 4, 1, N'', N'', CAST(16.938682 AS Decimal(18, 6)), CAST(78.182549 AS Decimal(18, 6)), N'509202', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-07T11:27:55.883' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10966, 4, 1, N'', N'', CAST(16.934136 AS Decimal(18, 6)), CAST(78.181526 AS Decimal(18, 6)), N'509202', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-07T11:28:38.233' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10967, 4, 1, N'', N'', CAST(16.898554 AS Decimal(18, 6)), CAST(78.174421 AS Decimal(18, 6)), N'509301', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-07T11:32:11.390' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10968, 6, 1, N'', N'', CAST(17.493294 AS Decimal(18, 6)), CAST(78.397238 AS Decimal(18, 6)), N'500085', 1, N'6,5,2,7,4,3,', NULL, CAST(N'2023-02-07T11:33:48.397' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10969, 1, 1, N'Need Help.', N'1_272023113555AM.png', CAST(17.466080 AS Decimal(18, 6)), CAST(78.284501 AS Decimal(18, 6)), N'502032', 0, NULL, NULL, CAST(N'2023-02-07T11:35:55.453' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10970, 6, 1, N'', N'', CAST(17.493292 AS Decimal(18, 6)), CAST(78.397238 AS Decimal(18, 6)), N'500085', 2, NULL, NULL, CAST(N'2023-02-07T11:36:37.960' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10971, 151, 151, N'', N'', CAST(17.490774 AS Decimal(18, 6)), CAST(78.396321 AS Decimal(18, 6)), N'500085', 0, NULL, NULL, CAST(N'2023-02-07T11:37:10.427' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10972, 151, 151, N'', N'', CAST(17.490868 AS Decimal(18, 6)), CAST(78.396417 AS Decimal(18, 6)), N'500072', 0, NULL, NULL, CAST(N'2023-02-07T11:37:44.560' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10973, 4, 1, N'', N'', CAST(16.811015 AS Decimal(18, 6)), CAST(78.146442 AS Decimal(18, 6)), N'509301', 2, NULL, NULL, CAST(N'2023-02-07T11:42:23.567' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10974, 3, 1, N'', N'', CAST(17.369959 AS Decimal(18, 6)), CAST(78.516396 AS Decimal(18, 6)), N'500036', 0, NULL, NULL, CAST(N'2023-02-08T03:41:07.577' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10975, 3, 1, N'test', N'', CAST(16.989100 AS Decimal(18, 6)), CAST(82.247500 AS Decimal(18, 6)), N'502302', 0, N'2', 2, CAST(N'2023-02-08T04:01:50.793' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10976, 3, 1, N'Help...', N'', CAST(17.368500 AS Decimal(18, 6)), CAST(78.531600 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2023-02-08T04:04:59.513' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10977, 3, 1, N'Help...', N'', CAST(17.368500 AS Decimal(18, 6)), CAST(78.531600 AS Decimal(18, 6)), NULL, 0, NULL, NULL, CAST(N'2023-02-08T04:06:43.810' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10978, 3, 1, N'Help...', N'', CAST(17.368500 AS Decimal(18, 6)), CAST(78.531600 AS Decimal(18, 6)), NULL, 0, N'2', 2, CAST(N'2023-02-08T04:07:15.733' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10979, 3, 1, N'Help...', N'', CAST(17.368500 AS Decimal(18, 6)), CAST(78.531600 AS Decimal(18, 6)), NULL, 2, NULL, NULL, CAST(N'2023-02-08T04:09:21.480' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10980, 3, 1, N'Help...', N'', CAST(17.368500 AS Decimal(18, 6)), CAST(78.531600 AS Decimal(18, 6)), NULL, 2, N'2', 2, CAST(N'2023-02-08T04:22:34.653' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10981, 3, 1, N'', N'', CAST(17.369739 AS Decimal(18, 6)), CAST(78.516567 AS Decimal(18, 6)), N'500036', 2, NULL, NULL, CAST(N'2023-02-08T04:23:31.280' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10982, 4, 1, N'', N'', CAST(15.811064 AS Decimal(18, 6)), CAST(78.041874 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T05:57:57.673' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10983, 7, 1, N'Need Help.', N'7_28202360447AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041789 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T06:04:47.933' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10984, 5, 1, N'', N'', CAST(17.493301 AS Decimal(18, 6)), CAST(78.397253 AS Decimal(18, 6)), N'500085', 2, NULL, NULL, CAST(N'2023-02-08T06:12:03.447' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10985, 5, 1, N'', N'', CAST(17.493291 AS Decimal(18, 6)), CAST(78.397236 AS Decimal(18, 6)), N'500085', 2, N'6,5,2,7,4,3,', NULL, CAST(N'2023-02-08T06:12:38.087' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10986, 4, 1, N'', N'', CAST(15.811110 AS Decimal(18, 6)), CAST(78.041927 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T06:55:38.560' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10987, 4, 1, N'Need Help.', N'4_28202371514AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041788 AS Decimal(18, 6)), N'518002', 1, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T07:15:14.750' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10988, 7, 1, N'', N'', CAST(15.811112 AS Decimal(18, 6)), CAST(78.041928 AS Decimal(18, 6)), N'518002', 2, NULL, NULL, CAST(N'2023-02-08T07:19:06.347' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10989, 4, 1, N'', N'', CAST(15.811052 AS Decimal(18, 6)), CAST(78.041870 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T09:10:58.883' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10990, 7, 1, N'', N'', CAST(15.811054 AS Decimal(18, 6)), CAST(78.041865 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-08T10:16:02.457' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10991, 4, 1, N'Need Help.', N'4_210202360424AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041789 AS Decimal(18, 6)), N'518002', 1, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T06:04:24.297' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10992, 7, 1, N'', N'', CAST(15.811049 AS Decimal(18, 6)), CAST(78.041853 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T07:05:05.333' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10993, 7, 1, N'', N'', CAST(15.811066 AS Decimal(18, 6)), CAST(78.041878 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T07:15:11.857' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10994, 4, 1, N'', N'', CAST(15.811053 AS Decimal(18, 6)), CAST(78.041869 AS Decimal(18, 6)), N'518002', 2, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T09:26:20.710' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10995, 4, 1, N'Need Help.', N'4_210202395113AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041789 AS Decimal(18, 6)), N'518002', 2, NULL, NULL, CAST(N'2023-02-10T09:51:13.250' AS DateTime))
GO
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10996, 4, 1, N'Need Help.', N'4_2102023100558AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041789 AS Decimal(18, 6)), N'502032', 1, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T10:05:58.010' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10997, 4, 1, N'Need Help.', N'4_2102023103437AM.png', CAST(15.810997 AS Decimal(18, 6)), CAST(78.041789 AS Decimal(18, 6)), N'518002', 1, N'6,5,2,3,7,4,', NULL, CAST(N'2023-02-10T10:34:37.723' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10998, 1, 1, N'Need Help.', N'1_212202361250AM.png', CAST(25.824444 AS Decimal(18, 6)), CAST(93.781499 AS Decimal(18, 6)), N'797115', 0, NULL, NULL, CAST(N'2023-02-12T06:12:50.200' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (10999, 1, 1, N'Need Help.', N'1_212202361312AM.png', CAST(25.824432 AS Decimal(18, 6)), CAST(93.781386 AS Decimal(18, 6)), N'797115', 0, NULL, NULL, CAST(N'2023-02-12T06:13:12.237' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11000, 1, 1, N'Need Help.', N'1_218202330329PM.png', CAST(16.979996 AS Decimal(18, 6)), CAST(82.230384 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-02-18T15:03:30.347' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11001, 1, 1, N'Need Help.', N'1_321202390828AM.png', CAST(-27.569885 AS Decimal(18, 6)), CAST(152.869163 AS Decimal(18, 6)), N'4070', 0, NULL, NULL, CAST(N'2023-03-21T09:08:29.113' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11002, 1, 1, N'Need Help.', N'1_4122023122014AM.png', CAST(-31.982956 AS Decimal(18, 6)), CAST(115.894013 AS Decimal(18, 6)), N'6100', 0, NULL, NULL, CAST(N'2023-04-12T00:20:14.627' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11003, 1, 1, N'Need Help.', N'1_620202330032PM.png', CAST(16.980042 AS Decimal(18, 6)), CAST(82.230432 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-06-20T15:00:32.767' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11004, 1, 1, N'Need Help.', N'1_620202330423PM.png', CAST(16.980042 AS Decimal(18, 6)), CAST(82.230432 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-06-20T15:04:23.203' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11005, 1, 1, N'Need Help.', N'1_620202330629PM.png', CAST(16.980042 AS Decimal(18, 6)), CAST(82.230432 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-06-20T15:06:29.057' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11006, 1, 1, N'Need Help.', N'1_624202324626AM.png', CAST(29.336731 AS Decimal(18, 6)), CAST(48.063095 AS Decimal(18, 6)), N'502032', 0, NULL, NULL, CAST(N'2023-06-24T02:46:26.293' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11007, 1, 1, N'Need Help.', N'1_625202390519AM.png', CAST(29.336685 AS Decimal(18, 6)), CAST(48.061725 AS Decimal(18, 6)), N'502032', 0, NULL, NULL, CAST(N'2023-06-25T09:05:19.670' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11008, 20, 20, N'Need Help.', N'20_87202384931AM.png', CAST(17.520394 AS Decimal(18, 6)), CAST(78.381474 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-07T08:49:31.960' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11009, 22, 20, N'Need Help.', N'22_87202385232AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381474 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-07T08:52:32.383' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11010, 23, 20, N'Need Help.', N'23_87202392428AM.png', CAST(17.520394 AS Decimal(18, 6)), CAST(78.381474 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-07T09:24:28.207' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11011, 24, 20, N'', N'', CAST(17.520350 AS Decimal(18, 6)), CAST(78.381410 AS Decimal(18, 6)), N'500090', 2, NULL, NULL, CAST(N'2023-08-07T09:43:11.293' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11012, 1, 1, N'', N'', CAST(16.980102 AS Decimal(18, 6)), CAST(82.230320 AS Decimal(18, 6)), N'533003', 2, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-07T10:28:35.297' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11013, 1, 1, N'', N'', CAST(16.979947 AS Decimal(18, 6)), CAST(82.230268 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-07T10:37:41.543' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11014, 4, 1, N'', N'', CAST(16.980011 AS Decimal(18, 6)), CAST(82.230653 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T10:49:50.253' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11015, 22, 20, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'13,12,6,5,2,18,21,22,23,7,', NULL, CAST(N'2023-08-07T13:05:51.870' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11016, 6, 1, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 0, NULL, NULL, CAST(N'2023-08-07T13:22:56.910' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11017, 22, 20, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'13,12,6,5,2,18,21,22,23,7,', NULL, CAST(N'2023-08-07T13:25:56.820' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11018, 22, 20, N'', N'', CAST(16.979953 AS Decimal(18, 6)), CAST(82.230244 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T13:27:35.570' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11019, 22, 20, N'', N'', CAST(16.979703 AS Decimal(18, 6)), CAST(82.230230 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T13:28:49.147' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11020, 22, 20, N'', N'', CAST(16.980102 AS Decimal(18, 6)), CAST(82.230324 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-07T13:29:25.670' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11021, 2, 1, N'', N'', CAST(17.005051 AS Decimal(18, 6)), CAST(81.781963 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:29:40.147' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11022, 6, 1, N'', N'', CAST(17.005048 AS Decimal(18, 6)), CAST(81.781953 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:30:11.013' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11023, 6, 1, N'', N'', CAST(17.005047 AS Decimal(18, 6)), CAST(81.781962 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:30:18.490' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11024, 24, 20, N'', N'', CAST(16.980112 AS Decimal(18, 6)), CAST(82.230327 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T13:30:24.270' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11025, 6, 1, N'', N'', CAST(17.005052 AS Decimal(18, 6)), CAST(81.781956 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:31:29.333' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11026, 6, 1, N'', N'', CAST(17.005052 AS Decimal(18, 6)), CAST(81.781961 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:32:05.353' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11027, 24, 20, N'', N'', CAST(16.979838 AS Decimal(18, 6)), CAST(82.230251 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T13:32:13.723' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11028, 2, 1, N'', N'', CAST(17.005046 AS Decimal(18, 6)), CAST(81.781951 AS Decimal(18, 6)), N'533103', 2, NULL, NULL, CAST(N'2023-08-07T13:32:36.313' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11029, 2, 1, N'', N'', CAST(17.005051 AS Decimal(18, 6)), CAST(81.781957 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:32:50.860' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11030, 6, 1, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 0, NULL, NULL, CAST(N'2023-08-07T13:33:22.557' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11031, 2, 1, N'', N'', CAST(17.005052 AS Decimal(18, 6)), CAST(81.781960 AS Decimal(18, 6)), N'533103', 0, NULL, NULL, CAST(N'2023-08-07T13:33:30.887' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11032, 22, 20, N'', N'', CAST(16.980088 AS Decimal(18, 6)), CAST(82.230314 AS Decimal(18, 6)), N'533002', 0, NULL, NULL, CAST(N'2023-08-07T14:53:54.197' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11033, 20, 20, N'Need Help.', N'20_87202325542PM.png', CAST(16.980026 AS Decimal(18, 6)), CAST(82.230413 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-07T14:55:42.120' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11034, 4, 1, N'', N'', CAST(16.980082 AS Decimal(18, 6)), CAST(82.230338 AS Decimal(18, 6)), N'533003', 2, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-08T05:55:31.030' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11035, 26, 26, N'', N'', CAST(16.980068 AS Decimal(18, 6)), CAST(82.230397 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-08T06:40:50.963' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11036, 22, 20, N'', N'', CAST(16.980107 AS Decimal(18, 6)), CAST(82.230324 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T06:52:16.880' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11037, 22, 20, N'', N'', CAST(16.980110 AS Decimal(18, 6)), CAST(82.230322 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T06:54:41.600' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11038, 22, 20, N'', N'', CAST(16.980065 AS Decimal(18, 6)), CAST(82.230330 AS Decimal(18, 6)), N'533002', 1, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-08T06:55:18.330' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11039, 22, 20, N'', N'', CAST(17.520316 AS Decimal(18, 6)), CAST(78.381489 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-08T07:05:52.703' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11040, 22, 20, N'', N'', CAST(17.520340 AS Decimal(18, 6)), CAST(78.381497 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-08T07:06:18.153' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11041, 22, 20, N'', N'', CAST(17.520241 AS Decimal(18, 6)), CAST(78.381436 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-08T07:09:11.640' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11042, 22, 20, N'', N'', CAST(16.980120 AS Decimal(18, 6)), CAST(82.230315 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-08T07:27:28.700' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11043, 24, 20, N'', N'', CAST(16.979934 AS Decimal(18, 6)), CAST(82.230252 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T07:28:41.313' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11044, 24, 20, N'', N'', CAST(16.980046 AS Decimal(18, 6)), CAST(82.230303 AS Decimal(18, 6)), N'533002', 2, N'13,12,6,5,2,18,21,22,23,3,', NULL, CAST(N'2023-08-08T07:28:51.993' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11045, 24, 20, N'', N'', CAST(16.980102 AS Decimal(18, 6)), CAST(82.230317 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T07:32:16.967' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11046, 24, 20, N'', N'', CAST(16.980102 AS Decimal(18, 6)), CAST(82.230317 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T07:32:17.200' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11047, 27, 26, N'', N'', CAST(16.980072 AS Decimal(18, 6)), CAST(82.230345 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T12:01:20.430' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11048, 27, 26, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 0, NULL, NULL, CAST(N'2023-08-08T12:03:11.137' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11049, 28, 25, N'', N'', CAST(16.980068 AS Decimal(18, 6)), CAST(82.230341 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T12:06:17.713' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11050, 28, 25, N'', N'', CAST(16.980068 AS Decimal(18, 6)), CAST(82.230336 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,28,', NULL, CAST(N'2023-08-08T12:08:30.220' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11051, 28, 25, N'', N'', CAST(16.980066 AS Decimal(18, 6)), CAST(82.230334 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T12:08:53.970' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11052, 28, 25, N'', N'', CAST(16.979968 AS Decimal(18, 6)), CAST(82.230428 AS Decimal(18, 6)), N'533002', 0, NULL, NULL, CAST(N'2023-08-08T12:35:34.710' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11053, 28, 25, N'', N'', CAST(16.979992 AS Decimal(18, 6)), CAST(82.230403 AS Decimal(18, 6)), N'533002', 0, NULL, NULL, CAST(N'2023-08-08T12:36:05.480' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11054, 29, 25, N'', N'', CAST(16.980074 AS Decimal(18, 6)), CAST(82.230342 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,27,', NULL, CAST(N'2023-08-08T12:57:13.627' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11055, 30, 26, N'', N'', CAST(16.979591 AS Decimal(18, 6)), CAST(82.230037 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T13:16:03.057' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11056, 30, 26, N'', N'', CAST(16.980075 AS Decimal(18, 6)), CAST(82.230342 AS Decimal(18, 6)), N'533002', 0, NULL, NULL, CAST(N'2023-08-08T13:17:31.883' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11057, 30, 26, N'', N'', CAST(16.980082 AS Decimal(18, 6)), CAST(82.230339 AS Decimal(18, 6)), N'533003', 0, NULL, NULL, CAST(N'2023-08-08T13:26:05.803' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11058, 30, 26, N'', N'', CAST(16.980076 AS Decimal(18, 6)), CAST(82.230340 AS Decimal(18, 6)), N'533002', 0, NULL, NULL, CAST(N'2023-08-08T13:28:18.493' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11059, 35, 20, N'Need Help.', N'35_814202371340AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:13:40.050' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11060, 6, 1, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:25:57.000' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11061, 37, 1, N'Need Help.', N'37_814202372839AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:28:39.297' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11062, 6, 1, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:43:37.993' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11063, 6, 1, N'', N'', CAST(17.005054 AS Decimal(18, 6)), CAST(81.781961 AS Decimal(18, 6)), N'533103', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:44:12.670' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11064, 5, 1, N'', N'', CAST(17.005055 AS Decimal(18, 6)), CAST(81.781959 AS Decimal(18, 6)), N'533103', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:44:32.273' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11065, 6, 1, N'', N'', CAST(17.005052 AS Decimal(18, 6)), CAST(81.781956 AS Decimal(18, 6)), N'533103', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:44:50.117' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11066, 5, 1, N'', N'', CAST(17.005051 AS Decimal(18, 6)), CAST(81.781948 AS Decimal(18, 6)), N'533103', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:48:19.417' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11067, 5, 1, N'', N'', CAST(17.005046 AS Decimal(18, 6)), CAST(81.781927 AS Decimal(18, 6)), N'533103', 2, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T07:52:19.547' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11068, 37, 1, N'Need Help.', N'37_814202380935AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:09:35.407' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11069, 37, 1, N'Need Help.', N'37_814202381056AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:10:56.610' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11070, 35, 20, N'Need Help.', N'35_814202381656AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:16:56.920' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11071, 37, 1, N'Need Help.', N'37_814202381917AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:19:17.680' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11072, 40, 38, N'', N'', CAST(17.520331 AS Decimal(18, 6)), CAST(78.381488 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:45:02.610' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11073, 40, 38, N'', N'', CAST(17.520313 AS Decimal(18, 6)), CAST(78.381486 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:46:12.677' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11074, 39, 38, N'Need Help.', N'39_814202384704AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:47:04.990' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11075, 39, 38, N'Need Help.', N'39_814202384816AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:48:16.787' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11076, 39, 38, N'', N'', CAST(17.520333 AS Decimal(18, 6)), CAST(78.381490 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:52:24.750' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11077, 5, 1, N'', N'', CAST(17.005051 AS Decimal(18, 6)), CAST(81.783278 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:53:44.457' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11078, 38, 38, N'Need Help.', N'38_814202385406AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:54:06.597' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11079, 5, 1, N'', N'', CAST(17.005049 AS Decimal(18, 6)), CAST(81.783279 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-14T08:54:07.957' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11080, 38, 38, N'Need Help.', N'38_814202385500AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:55:00.750' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11081, 38, 38, N'Need Help.', N'38_814202385651AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:56:51.070' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11082, 38, 38, N'Need Help.', N'38_814202385721AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 0, NULL, NULL, CAST(N'2023-08-14T08:57:21.860' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11083, 39, 38, N'', N'', CAST(17.520334 AS Decimal(18, 6)), CAST(78.381496 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:10:24.200' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11084, 40, 38, N'', N'', CAST(17.520327 AS Decimal(18, 6)), CAST(78.381489 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:11:47.810' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11085, 40, 38, N'', N'', CAST(17.520324 AS Decimal(18, 6)), CAST(78.381489 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:15:55.200' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11086, 40, 38, N'', N'', CAST(17.520333 AS Decimal(18, 6)), CAST(78.381474 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:16:43.170' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11087, 40, 38, N'', N'', CAST(17.520328 AS Decimal(18, 6)), CAST(78.381492 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:17:09.910' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11088, 40, 38, N'', N'', CAST(17.520340 AS Decimal(18, 6)), CAST(78.381498 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:17:31.160' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11089, 40, 38, N'', N'', CAST(17.520338 AS Decimal(18, 6)), CAST(78.381497 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:17:54.043' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11090, 40, 38, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381495 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:20:03.640' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11091, 40, 38, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381481 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:21:03.277' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11092, 40, 38, N'', N'', CAST(17.520307 AS Decimal(18, 6)), CAST(78.381492 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:21:17.713' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11093, 40, 38, N'', N'', CAST(17.520325 AS Decimal(18, 6)), CAST(78.381486 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:22:13.287' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11094, 40, 38, N'', N'', CAST(17.520356 AS Decimal(18, 6)), CAST(78.381487 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:24:17.933' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11095, 39, 38, N'', N'', CAST(17.520324 AS Decimal(18, 6)), CAST(78.381500 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:26:15.313' AS DateTime))
GO
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11096, 40, 38, N'', N'', CAST(17.520328 AS Decimal(18, 6)), CAST(78.381492 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:26:53.993' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11097, 40, 38, N'', N'', CAST(17.520312 AS Decimal(18, 6)), CAST(78.381473 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:28:20.840' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11098, 40, 38, N'', N'', CAST(17.520346 AS Decimal(18, 6)), CAST(78.381486 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:29:38.803' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11099, 40, 38, N'Need Help.', N'40_814202393118AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:31:18.560' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11100, 40, 38, N'Need Help.', N'40_814202394719AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:47:19.217' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11101, 39, 38, N'Need Help.', N'39_814202394843AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:48:43.227' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11102, 40, 38, N'Need Help.', N'40_814202394949AM.png', CAST(17.520386 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:49:49.503' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11103, 40, 38, N'', N'', CAST(17.520339 AS Decimal(18, 6)), CAST(78.381498 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:51:49.250' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11104, 40, 38, N'', N'', CAST(17.520331 AS Decimal(18, 6)), CAST(78.381495 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T09:55:19.470' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11105, 40, 38, N'', N'', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T10:27:27.100' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11106, 40, 38, N'', N'', CAST(17.520337 AS Decimal(18, 6)), CAST(78.381495 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-14T10:29:06.197' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11107, 39, 38, N'Need Help.', N'39_815202343826AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-15T04:38:26.900' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11108, 42, 38, N'', N'', CAST(17.005049 AS Decimal(18, 6)), CAST(81.783281 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-15T05:11:55.020' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11109, 42, 38, N'', N'', CAST(17.005057 AS Decimal(18, 6)), CAST(81.783290 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-15T05:14:25.740' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11110, 42, 38, N'', N'', CAST(17.005063 AS Decimal(18, 6)), CAST(81.783295 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-15T05:15:38.240' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11111, 42, 38, N'', N'', CAST(17.005046 AS Decimal(18, 6)), CAST(81.783277 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-15T05:16:26.570' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11112, 40, 38, N'', N'', CAST(17.520330 AS Decimal(18, 6)), CAST(78.381485 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-15T05:17:08.070' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11113, 42, 38, N'', N'', CAST(17.005068 AS Decimal(18, 6)), CAST(81.783307 AS Decimal(18, 6)), N'533101', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-15T06:02:33.007' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11114, 40, 38, N'', N'', CAST(17.520335 AS Decimal(18, 6)), CAST(78.381517 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-15T06:04:25.647' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11115, 52, 44, N'Need Help.', N'52_816202314301AM.png', CAST(16.980046 AS Decimal(18, 6)), CAST(82.230420 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T01:43:01.470' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11116, 52, 44, N'Need Help.', N'52_816202314432AM.png', CAST(16.980026 AS Decimal(18, 6)), CAST(82.230430 AS Decimal(18, 6)), N'533003', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T01:44:32.843' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11117, 53, 44, N'', N'', CAST(16.184539 AS Decimal(18, 6)), CAST(81.140353 AS Decimal(18, 6)), N'521001', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T02:00:51.747' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11118, 58, 55, N'Need Help.', N'58_816202334923AM.png', CAST(16.990390 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T03:49:23.540' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11119, 58, 55, N'Need Help.', N'58_816202335015AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T03:50:15.137' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11120, 4, 1, N'Need Help.', N'4_816202341018AM.png', CAST(17.520393 AS Decimal(18, 6)), CAST(78.381478 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:10:18.660' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11121, 38, 38, N'', N'', CAST(17.005354 AS Decimal(18, 6)), CAST(81.780240 AS Decimal(18, 6)), N'533103', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:11:28.127' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11122, 55, 55, N'Need Help.', N'55_816202341238AM.png', CAST(16.990362 AS Decimal(18, 6)), CAST(82.246412 AS Decimal(18, 6)), N'533005', 0, NULL, NULL, CAST(N'2023-08-16T04:12:38.820' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11123, 52, 44, N'Need Help.', N'52_816202341307AM.png', CAST(16.990417 AS Decimal(18, 6)), CAST(82.246358 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:13:07.473' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11124, 55, 55, N'Need Help.', N'55_816202341323AM.png', CAST(16.990390 AS Decimal(18, 6)), CAST(82.246395 AS Decimal(18, 6)), N'533005', 0, NULL, NULL, CAST(N'2023-08-16T04:13:23.303' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11125, 52, 44, N'Need Help.', N'52_816202341403AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246375 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:14:03.450' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11126, 52, 44, N'Need Help.', N'52_816202341442AM.png', CAST(16.990402 AS Decimal(18, 6)), CAST(82.246376 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:14:42.093' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11127, 55, 55, N'Need Help.', N'55_816202341519AM.png', CAST(16.990402 AS Decimal(18, 6)), CAST(82.246351 AS Decimal(18, 6)), N'533005', 0, NULL, NULL, CAST(N'2023-08-16T04:15:19.013' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11128, 4, 1, N'', N'', CAST(17.520329 AS Decimal(18, 6)), CAST(78.381501 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:15:43.773' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11129, 4, 1, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381532 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:19:15.230' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11130, 4, 1, N'', N'', CAST(17.520323 AS Decimal(18, 6)), CAST(78.381532 AS Decimal(18, 6)), N'500090', 1, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:19:20.707' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11131, 40, 38, N'', N'', CAST(17.520341 AS Decimal(18, 6)), CAST(78.381499 AS Decimal(18, 6)), N'500090', 2, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:22:22.680' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11132, 40, 38, N'', N'', CAST(17.520342 AS Decimal(18, 6)), CAST(78.381472 AS Decimal(18, 6)), N'500090', 2, N'13,12,6,5,2,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:23:33.727' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11133, 59, 44, N'Need Help.', N'59_816202345104AM.png', CAST(16.990390 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:51:04.100' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11134, 59, 44, N'Need Help.', N'59_816202345238AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T04:52:38.037' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11135, 59, 44, N'Need Help.', N'59_816202353516AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:35:16.383' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11136, 59, 44, N'Need Help.', N'59_816202353604AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:36:04.493' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11137, 59, 44, N'Need Help.', N'59_816202353640AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:36:40.213' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11138, 59, 44, N'Need Help.', N'59_816202353704AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:37:04.937' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11139, 59, 44, N'Need Help.', N'59_816202353734AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:37:34.697' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11140, 59, 44, N'Need Help.', N'59_816202353807AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:38:07.743' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11141, 59, 44, N'Need Help.', N'59_816202353831AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:38:31.070' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11142, 59, 44, N'Need Help.', N'59_816202353927AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:39:27.737' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11143, 59, 44, N'Need Help.', N'59_816202355036AM.png', CAST(16.990387 AS Decimal(18, 6)), CAST(82.246386 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T05:50:36.113' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11144, 72, 72, N'', N'', CAST(16.990340 AS Decimal(18, 6)), CAST(82.246448 AS Decimal(18, 6)), N'533005', 1, N'6,5,2,13,12,18,21,22,23,33,', NULL, CAST(N'2023-08-16T07:01:43.800' AS DateTime))
INSERT [dbo].[Help] ([HelpId], [MemberId], [CoordinatorId], [Message], [Image], [Latitude], [Longitude], [PostCode], [Status], [VolunteerIds], [RespondId], [CreatedDate]) VALUES (11145, 44, 44, N'Need Help.', N'44_816202350856PM.png', CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', 0, NULL, NULL, CAST(N'2023-08-16T17:08:56.633' AS DateTime))
SET IDENTITY_INSERT [dbo].[Help] OFF
GO
SET IDENTITY_INSERT [dbo].[HelpImages] ON 

INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (2, 282, N'81_1222202190306AM.png', CAST(N'2021-12-22T09:03:06.513' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (3, 283, N'81_1222202190525AM.png', CAST(N'2021-12-22T09:05:25.883' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (4, 284, N'81_1222202191653AM.png', CAST(N'2021-12-22T09:16:53.390' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (5, 285, N'81_1222202194921AM.png', CAST(N'2021-12-22T09:49:21.143' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (6, 286, N'74_12222021105021AM.png', CAST(N'2021-12-22T10:50:21.663' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (7, 287, N'81_12222021105706AM.png', CAST(N'2021-12-22T10:57:06.150' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (8, 288, N'74_12222021110906AM.png', CAST(N'2021-12-22T11:09:06.113' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (9, 289, N'74_12222021111020AM.png', CAST(N'2021-12-22T11:10:20.190' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10, 290, N'81_1223202125120AM.png', CAST(N'2021-12-23T02:51:20.783' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (11, 291, N'81_1224202184044AM.png', CAST(N'2021-12-24T08:40:44.213' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (12, 292, N'74_1224202184845AM.png', CAST(N'2021-12-24T08:48:45.680' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (13, 293, N'72_1224202185320AM.png', CAST(N'2021-12-24T08:53:20.953' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (14, 294, N'74_1224202190600AM.png', CAST(N'2021-12-24T09:06:00.120' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (15, 296, N'74_17202262505AM.png', CAST(N'2022-01-07T06:25:06.050' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (16, 297, N'74_17202262539AM.png', CAST(N'2022-01-07T06:25:39.070' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (17, 298, N'74_17202262614AM.png', CAST(N'2022-01-07T06:26:14.593' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (18, 299, N'74_17202262834AM.png', CAST(N'2022-01-07T06:28:34.197' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (19, 300, N'81_17202265037AM.png', CAST(N'2022-01-07T06:50:37.097' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (20, 301, N'72_17202270032AM.png', CAST(N'2022-01-07T07:00:32.173' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (21, 302, N'81_17202284625AM.png', CAST(N'2022-01-07T08:46:25.720' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (22, 303, N'81_17202284937AM.png', CAST(N'2022-01-07T08:49:37.570' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (23, 304, N'81_17202290822AM.png', CAST(N'2022-01-07T09:08:22.260' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (24, 305, N'81_17202291051AM.png', CAST(N'2022-01-07T09:10:51.980' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (25, 306, N'81_17202291924AM.png', CAST(N'2022-01-07T09:19:24.570' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (26, 307, N'74_17202292842AM.png', CAST(N'2022-01-07T09:28:42.563' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (27, 310, N'74_110202290707AM.png', CAST(N'2022-01-10T09:07:07.083' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (28, 311, N'82_1102022103637AM.png', CAST(N'2022-01-10T10:36:37.940' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (29, 314, N'82_1102022114813AM.png', CAST(N'2022-01-10T11:48:13.520' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (30, 315, N'84_112202282616AM.png', CAST(N'2022-01-12T08:26:16.300' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (31, 316, N'84_112202282900AM.png', CAST(N'2022-01-12T08:29:00.230' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (32, 317, N'84_112202284644AM.png', CAST(N'2022-01-12T08:46:44.177' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (33, 318, N'84_112202284721AM.png', CAST(N'2022-01-12T08:47:21.703' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (34, 319, N'84_112202290058AM.png', CAST(N'2022-01-12T09:00:58.010' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (35, 320, N'84_1122022105322AM.png', CAST(N'2022-01-12T10:53:23.283' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (36, 321, N'84_1122022105525AM.png', CAST(N'2022-01-12T10:55:25.380' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (37, 322, N'85_1122022105548AM.png', CAST(N'2022-01-12T10:55:48.920' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (38, 323, N'84_1122022105628AM.png', CAST(N'2022-01-12T10:56:29.003' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (39, 324, N'84_1122022105824AM.png', CAST(N'2022-01-12T10:58:24.933' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (40, 325, N'82_1122022105843AM.png', CAST(N'2022-01-12T10:58:43.257' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (41, 328, N'84_1122022110308AM.png', CAST(N'2022-01-12T11:03:08.613' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (42, 329, N'84_1122022110344AM.png', CAST(N'2022-01-12T11:03:44.810' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (43, 330, N'84_1122022110628AM.png', CAST(N'2022-01-12T11:06:28.600' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (44, 331, N'84_1122022110738AM.png', CAST(N'2022-01-12T11:07:38.583' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (45, 345, N'82_113202290353AM.png', CAST(N'2022-01-13T09:03:53.387' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (46, 346, N'82_113202290425AM.png', CAST(N'2022-01-13T09:04:25.800' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (47, 348, N'74_113202292806AM.png', CAST(N'2022-01-13T09:28:06.763' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (48, 349, N'81_113202292824AM.png', CAST(N'2022-01-13T09:28:24.640' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (49, 351, N'74_113202292946AM.png', CAST(N'2022-01-13T09:29:46.923' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (50, 352, N'81_113202293426AM.png', CAST(N'2022-01-13T09:34:26.330' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (51, 354, N'87_1132022100248AM.png', CAST(N'2022-01-13T10:02:48.790' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (52, 355, N'82_1132022101111AM.png', CAST(N'2022-01-13T10:11:11.570' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (53, 356, N'74_1132022102245AM.png', CAST(N'2022-01-13T10:22:45.463' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (54, 357, N'82_1132022102426AM.png', CAST(N'2022-01-13T10:24:26.133' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (55, 358, N'82_1132022102645AM.png', CAST(N'2022-01-13T10:26:45.787' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (56, 359, N'82_1132022102757AM.png', CAST(N'2022-01-13T10:27:57.510' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (57, 360, N'82_1132022102951AM.png', CAST(N'2022-01-13T10:29:51.303' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (58, 375, N'82_118202253923AM.png', CAST(N'2022-01-18T05:39:23.130' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (59, 376, N'82_118202254651AM.png', CAST(N'2022-01-18T05:46:51.530' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (60, 377, N'82_118202270738AM.png', CAST(N'2022-01-18T07:07:38.590' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (61, 378, N'84_118202285226AM.png', CAST(N'2022-01-18T08:52:26.997' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (62, 379, N'85_118202285632AM.png', CAST(N'2022-01-18T08:56:32.787' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (63, 380, N'85_118202285731AM.png', CAST(N'2022-01-18T08:57:31.070' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (64, 381, N'63_120202265648AM.png', CAST(N'2022-01-20T06:56:48.400' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (65, 382, N'89_122202230706AM.png', CAST(N'2022-01-22T03:07:06.587' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (66, 383, N'90_122202231023AM.png', CAST(N'2022-01-22T03:10:23.410' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (67, 384, N'90_122202231333AM.png', CAST(N'2022-01-22T03:13:33.960' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (68, 385, N'90_122202231859AM.png', CAST(N'2022-01-22T03:18:59.183' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (69, 400, N'97_125202262719AM.png', CAST(N'2022-01-25T06:27:19.587' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (70, 401, N'97_125202264952AM.png', CAST(N'2022-01-25T06:49:52.010' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (71, 402, N'97_125202270540AM.png', CAST(N'2022-01-25T07:05:40.083' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (72, 412, N'96_126202261024AM.png', CAST(N'2022-01-26T06:10:24.217' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (73, 413, N'97_126202262411AM.png', CAST(N'2022-01-26T06:24:11.200' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (74, 432, N'97_131202265647AM.png', CAST(N'2022-01-31T06:56:47.483' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (75, 433, N'97_21202235302PM.png', CAST(N'2022-02-01T15:53:02.523' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (76, 474, N'97_27202291644AM.png', CAST(N'2022-02-07T09:16:44.770' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (77, 475, N'95_27202295636AM.png', CAST(N'2022-02-07T09:56:36.790' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (78, 476, N'95_27202295744AM.png', CAST(N'2022-02-07T09:57:44.960' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (79, 477, N'95_27202295818AM.png', CAST(N'2022-02-07T09:58:18.110' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (80, 478, N'95_27202295901AM.png', CAST(N'2022-02-07T09:59:01.633' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (81, 490, N'86_214202293650AM.png', CAST(N'2022-02-14T09:36:50.217' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (82, 492, N'86_215202252303AM.png', CAST(N'2022-02-15T05:23:03.407' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (83, 493, N'86_215202254510AM.png', CAST(N'2022-02-15T05:45:10.513' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (84, 494, N'95_215202282708AM.png', CAST(N'2022-02-15T08:27:08.257' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (85, 496, N'97_215202284337AM.png', CAST(N'2022-02-15T08:43:37.480' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (86, 497, N'97_215202284520AM.png', CAST(N'2022-02-15T08:45:20.070' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (87, 503, N'95_215202293348AM.png', CAST(N'2022-02-15T09:33:48.317' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (88, 505, N'95_215202294618AM.png', CAST(N'2022-02-15T09:46:18.160' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (89, 506, N'95_215202295052AM.png', CAST(N'2022-02-15T09:50:52.237' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (90, 508, N'95_215202295455AM.png', CAST(N'2022-02-15T09:54:55.243' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (91, 514, N'95_2152022100012AM.png', CAST(N'2022-02-15T10:00:12.393' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (92, 575, N'96_37202291027AM.png', CAST(N'2022-03-07T09:10:27.237' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (93, 576, N'96_37202291152AM.png', CAST(N'2022-03-07T09:11:52.743' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (94, 577, N'97_37202291716AM.png', CAST(N'2022-03-07T09:17:16.630' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (95, 578, N'97_37202292223AM.png', CAST(N'2022-03-07T09:22:23.690' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (96, 579, N'97_37202293049AM.png', CAST(N'2022-03-07T09:30:49.187' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (97, 581, N'97_372022102927AM.png', CAST(N'2022-03-07T10:29:27.033' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (98, 582, N'122_3112022115819AM.png', CAST(N'2022-03-11T11:58:19.420' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (99, 583, N'63_312202285548PM.png', CAST(N'2022-03-12T20:55:49.000' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (100, 585, N'97_3172022105603AM.png', CAST(N'2022-03-17T10:56:03.987' AS DateTime))
GO
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (101, 586, N'97_3172022105636AM.png', CAST(N'2022-03-17T10:56:36.320' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (102, 588, N'97_319202284531AM.png', CAST(N'2022-03-19T08:45:31.610' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (103, 589, N'97_319202290800AM.png', CAST(N'2022-03-19T09:08:00.550' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (104, 598, N'123_3192022102805AM.png', CAST(N'2022-03-19T10:28:05.570' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (105, 599, N'96_3192022103530AM.png', CAST(N'2022-03-19T10:35:30.020' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (106, 600, N'123_3192022103649AM.png', CAST(N'2022-03-19T10:36:49.130' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (107, 604, N'112_3192022104519AM.png', CAST(N'2022-03-19T10:45:19.920' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (108, 613, N'97_323202282504AM.png', CAST(N'2022-03-23T08:25:04.693' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (109, 614, N'97_323202282625AM.png', CAST(N'2022-03-23T08:26:25.537' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (110, 620, N'97_323202283458AM.png', CAST(N'2022-03-23T08:34:58.653' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (111, 624, N'63_44202240428AM.png', CAST(N'2022-04-04T04:04:29.420' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (112, 625, N'63_413202294556AM.png', CAST(N'2022-04-13T09:45:56.110' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (113, 626, N'63_61202293459PM.png', CAST(N'2022-06-01T21:34:59.600' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (114, 627, N'63_622022120653AM.png', CAST(N'2022-06-02T00:06:53.100' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (115, 628, N'63_68202211426AM.png', CAST(N'2022-06-08T01:14:26.460' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (116, 629, N'63_68202280732AM.png', CAST(N'2022-06-08T08:07:32.840' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (117, 630, N'63_614202222616AM.png', CAST(N'2022-06-14T02:26:17.190' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10117, 10630, N'63_617202215103AM.png', CAST(N'2022-06-17T01:51:04.090' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10118, 10632, N'63_711202210605AM.png', CAST(N'2022-07-11T01:06:05.317' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10119, 10633, N'63_7112022103507AM.png', CAST(N'2022-07-11T10:35:07.587' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10120, 10640, N'86_82202291928AM.png', CAST(N'2022-08-02T09:19:28.033' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10121, 10647, N'136_82202295716AM.png', CAST(N'2022-08-02T09:57:16.827' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10122, 10667, N'133_84202261036AM.png', CAST(N'2022-08-04T06:10:36.260' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10123, 10668, N'133_84202261411AM.png', CAST(N'2022-08-04T06:14:11.503' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10124, 10669, N'133_84202261511AM.png', CAST(N'2022-08-04T06:15:11.457' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10125, 10670, N'133_84202261611AM.png', CAST(N'2022-08-04T06:16:11.667' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10126, 10676, N'133_84202265653AM.png', CAST(N'2022-08-04T06:56:53.627' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10127, 10677, N'133_84202265717AM.png', CAST(N'2022-08-04T06:57:17.587' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10128, 10684, N'93_84202275127AM.png', CAST(N'2022-08-04T07:51:27.353' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10129, 10688, N'134_84202280151AM.png', CAST(N'2022-08-04T08:01:51.700' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10130, 10689, N'134_84202281048AM.png', CAST(N'2022-08-04T08:10:48.310' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10131, 10690, N'134_84202282405AM.png', CAST(N'2022-08-04T08:24:05.490' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10132, 10693, N'133_86202264538AM.png', CAST(N'2022-08-06T06:45:38.740' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10133, 10696, N'134_86202291547AM.png', CAST(N'2022-08-06T09:15:47.967' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10134, 10697, N'134_86202291733AM.png', CAST(N'2022-08-06T09:17:33.840' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10135, 10698, N'134_862022102319AM.png', CAST(N'2022-08-06T10:23:19.977' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10136, 10699, N'132_862022103737AM.png', CAST(N'2022-08-06T10:37:37.187' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10137, 10700, N'63_88202243946AM.png', CAST(N'2022-08-08T04:39:46.210' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10138, 10701, N'63_88202244330AM.png', CAST(N'2022-08-08T04:43:30.190' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10139, 10702, N'63_88202245831AM.png', CAST(N'2022-08-08T04:58:31.200' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10140, 10705, N'134_88202290642AM.png', CAST(N'2022-08-08T09:06:42.150' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10141, 10706, N'134_88202293429AM.png', CAST(N'2022-08-08T09:34:29.550' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10142, 10707, N'134_88202293517AM.png', CAST(N'2022-08-08T09:35:17.890' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10143, 10708, N'134_88202293549AM.png', CAST(N'2022-08-08T09:35:49.453' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10144, 10709, N'133_8102022110825AM.png', CAST(N'2022-08-10T11:08:25.213' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10145, 10710, N'86_8102022113058AM.png', CAST(N'2022-08-10T11:30:58.103' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10146, 10711, N'86_8102022113430AM.png', CAST(N'2022-08-10T11:34:30.567' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10147, 10716, N'143_8112022103209AM.png', CAST(N'2022-08-11T10:32:09.153' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10148, 10717, N'141_8112022105321AM.png', CAST(N'2022-08-11T10:53:21.563' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10149, 10718, N'141_8112022105538AM.png', CAST(N'2022-08-11T10:55:38.817' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10150, 10722, N'141_8122022110444AM.png', CAST(N'2022-08-12T11:04:44.433' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10151, 10723, N'141_8122022110930AM.png', CAST(N'2022-08-12T11:09:30.837' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10152, 10724, N'63_812202233835PM.png', CAST(N'2022-08-12T15:38:35.783' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10153, 10725, N'63_812202234315PM.png', CAST(N'2022-08-12T15:43:15.040' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10154, 10746, N'63_8222022101524AM.png', CAST(N'2022-08-22T10:15:24.303' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10155, 10758, N'63_99202253507AM.png', CAST(N'2022-09-09T05:35:07.450' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10156, 10759, N'63_912202210223PM.png', CAST(N'2022-09-12T13:02:23.477' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10157, 10768, N'63_10302022105226AM.png', CAST(N'2022-10-30T10:52:26.840' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10158, 10769, N'63_10302022111914AM.png', CAST(N'2022-10-30T11:19:14.723' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10159, 10770, N'63_10302022111958AM.png', CAST(N'2022-10-30T11:19:58.333' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10160, 10771, N'63_1215202231850PM.png', CAST(N'2022-12-15T15:18:50.650' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10161, 10774, N'132_1312023101554AM.png', CAST(N'2023-01-31T10:15:54.623' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10162, 10776, N'132_1312023101859AM.png', CAST(N'2023-01-31T10:18:59.973' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10163, 10780, N'150_212023100535AM.png', CAST(N'2023-02-01T10:05:36.007' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10164, 10784, N'63_21202310401PM.png', CAST(N'2023-02-01T13:04:01.920' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10165, 10792, N'86_23202342416AM.png', CAST(N'2023-02-03T04:24:16.960' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10166, 10809, N'150_23202353904AM.png', CAST(N'2023-02-03T05:39:04.350' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10167, 10810, N'150_23202354119AM.png', CAST(N'2023-02-03T05:41:19.570' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10168, 10811, N'150_23202361202AM.png', CAST(N'2023-02-03T06:12:02.873' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10169, 10812, N'150_23202382830AM.png', CAST(N'2023-02-03T08:28:30.147' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10170, 10815, N'150_232023113145AM.png', CAST(N'2023-02-03T11:31:45.890' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10171, 10837, N'150_26202375204AM.png', CAST(N'2023-02-06T07:52:04.937' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10172, 10838, N'149_26202395807AM.png', CAST(N'2023-02-06T09:58:07.300' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10173, 10959, N'149_27202354431AM.png', CAST(N'2023-02-07T05:44:31.687' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10174, 10960, N'147_27202360918AM.png', CAST(N'2023-02-07T06:09:18.410' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10175, 10969, N'1_272023113555AM.png', CAST(N'2023-02-07T11:35:55.453' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10176, 10983, N'7_28202360447AM.png', CAST(N'2023-02-08T06:04:47.933' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10177, 10987, N'4_28202371514AM.png', CAST(N'2023-02-08T07:15:14.753' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10178, 10991, N'4_210202360424AM.png', CAST(N'2023-02-10T06:04:24.297' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10179, 10995, N'4_210202395113AM.png', CAST(N'2023-02-10T09:51:13.250' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10180, 10996, N'4_2102023100558AM.png', CAST(N'2023-02-10T10:05:58.010' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10181, 10997, N'4_2102023103437AM.png', CAST(N'2023-02-10T10:34:37.723' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10182, 10998, N'1_212202361250AM.png', CAST(N'2023-02-12T06:12:50.200' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10183, 10999, N'1_212202361312AM.png', CAST(N'2023-02-12T06:13:12.237' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10184, 11000, N'1_218202330329PM.png', CAST(N'2023-02-18T15:03:30.347' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10185, 11001, N'1_321202390828AM.png', CAST(N'2023-03-21T09:08:29.113' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10186, 11002, N'1_4122023122014AM.png', CAST(N'2023-04-12T00:20:14.627' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10187, 11003, N'1_620202330032PM.png', CAST(N'2023-06-20T15:00:32.767' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10188, 11004, N'1_620202330423PM.png', CAST(N'2023-06-20T15:04:23.203' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10189, 11005, N'1_620202330629PM.png', CAST(N'2023-06-20T15:06:29.057' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10190, 11006, N'1_624202324626AM.png', CAST(N'2023-06-24T02:46:26.293' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10191, 11007, N'1_625202390519AM.png', CAST(N'2023-06-25T09:05:19.670' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10193, 11009, N'22_87202385232AM.png', CAST(N'2023-08-07T08:52:32.383' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10195, 11033, N'20_87202325542PM.png', CAST(N'2023-08-07T14:55:42.120' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10196, 11059, N'35_814202371340AM.png', CAST(N'2023-08-14T07:13:40.050' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10197, 11061, N'37_814202372839AM.png', CAST(N'2023-08-14T07:28:39.297' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10198, 11068, N'37_814202380935AM.png', CAST(N'2023-08-14T08:09:35.407' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10199, 11069, N'37_814202381056AM.png', CAST(N'2023-08-14T08:10:56.610' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10200, 11070, N'35_814202381656AM.png', CAST(N'2023-08-14T08:16:56.920' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10201, 11071, N'37_814202381917AM.png', CAST(N'2023-08-14T08:19:17.680' AS DateTime))
GO
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10202, 11074, N'39_814202384704AM.png', CAST(N'2023-08-14T08:47:04.990' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10203, 11075, N'39_814202384816AM.png', CAST(N'2023-08-14T08:48:16.787' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10204, 11078, N'38_814202385406AM.png', CAST(N'2023-08-14T08:54:06.597' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10205, 11080, N'38_814202385500AM.png', CAST(N'2023-08-14T08:55:00.750' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10206, 11081, N'38_814202385651AM.png', CAST(N'2023-08-14T08:56:51.070' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10207, 11082, N'38_814202385721AM.png', CAST(N'2023-08-14T08:57:21.860' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10208, 11099, N'40_814202393118AM.png', CAST(N'2023-08-14T09:31:18.563' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10209, 11100, N'40_814202394719AM.png', CAST(N'2023-08-14T09:47:19.217' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10210, 11101, N'39_814202394843AM.png', CAST(N'2023-08-14T09:48:43.230' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10211, 11102, N'40_814202394949AM.png', CAST(N'2023-08-14T09:49:49.503' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10212, 11107, N'39_815202343826AM.png', CAST(N'2023-08-15T04:38:26.900' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10213, 11115, N'52_816202314301AM.png', CAST(N'2023-08-16T01:43:01.470' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10214, 11116, N'52_816202314432AM.png', CAST(N'2023-08-16T01:44:32.843' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10215, 11118, N'58_816202334923AM.png', CAST(N'2023-08-16T03:49:23.540' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10216, 11119, N'58_816202335015AM.png', CAST(N'2023-08-16T03:50:15.137' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10217, 11120, N'4_816202341018AM.png', CAST(N'2023-08-16T04:10:18.660' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10218, 11122, N'55_816202341238AM.png', CAST(N'2023-08-16T04:12:38.820' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10219, 11123, N'52_816202341307AM.png', CAST(N'2023-08-16T04:13:07.473' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10220, 11124, N'55_816202341323AM.png', CAST(N'2023-08-16T04:13:23.303' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10221, 11125, N'52_816202341403AM.png', CAST(N'2023-08-16T04:14:03.450' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10222, 11126, N'52_816202341442AM.png', CAST(N'2023-08-16T04:14:42.093' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10223, 11127, N'55_816202341519AM.png', CAST(N'2023-08-16T04:15:19.013' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10224, 11133, N'59_816202345104AM.png', CAST(N'2023-08-16T04:51:04.117' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10225, 11134, N'59_816202345238AM.png', CAST(N'2023-08-16T04:52:38.037' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10226, 11135, N'59_816202353516AM.png', CAST(N'2023-08-16T05:35:16.383' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10227, 11136, N'59_816202353604AM.png', CAST(N'2023-08-16T05:36:04.493' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10228, 11137, N'59_816202353640AM.png', CAST(N'2023-08-16T05:36:40.213' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10229, 11138, N'59_816202353704AM.png', CAST(N'2023-08-16T05:37:04.937' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10230, 11139, N'59_816202353734AM.png', CAST(N'2023-08-16T05:37:34.697' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10231, 11140, N'59_816202353807AM.png', CAST(N'2023-08-16T05:38:07.743' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10232, 11141, N'59_816202353831AM.png', CAST(N'2023-08-16T05:38:31.070' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10233, 11142, N'59_816202353927AM.png', CAST(N'2023-08-16T05:39:27.740' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10234, 11143, N'59_816202355036AM.png', CAST(N'2023-08-16T05:50:36.113' AS DateTime))
INSERT [dbo].[HelpImages] ([ImageId], [HelpId], [ImageName], [CreatedDate]) VALUES (10235, 11145, N'44_816202350856PM.png', CAST(N'2023-08-16T17:08:56.633' AS DateTime))
SET IDENTITY_INSERT [dbo].[HelpImages] OFF
GO
SET IDENTITY_INSERT [dbo].[HelpRespondedVolunteers] ON 

INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (5, 256, 81, 1, CAST(N'2021-12-14T10:43:21.930' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (6, 287, 81, 0, CAST(N'2021-12-14T10:43:21.930' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (7, 336, 96, 1, CAST(N'2022-01-27T05:49:40.083' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (8, 308, 96, 1, CAST(N'2022-01-27T06:10:34.073' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (9, 333, 96, 1, CAST(N'2022-01-27T08:54:47.323' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (10, 343, 96, 1, CAST(N'2022-01-27T10:11:21.587' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (11, 391, 93, 0, CAST(N'2022-01-31T02:27:19.233' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (12, 431, 96, 1, CAST(N'2022-01-31T08:49:41.797' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (13, 431, 96, 1, CAST(N'2022-01-31T08:49:46.980' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (14, 429, 96, 1, CAST(N'2022-01-31T08:50:40.540' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (15, 400, 96, 0, CAST(N'2022-02-15T11:07:18.030' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (16, 607, 113, 0, CAST(N'2022-03-23T02:41:34.010' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (17, 401, 93, 0, CAST(N'2022-03-23T02:58:24.650' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (18, 402, 93, 0, CAST(N'2022-03-23T02:58:36.090' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (19, 627, 85, 1, CAST(N'2022-06-02T00:07:54.260' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (20, 628, 85, 1, CAST(N'2022-06-08T01:46:44.630' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (21, 10632, 85, 1, CAST(N'2022-07-11T01:07:09.053' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (22, 10695, 133, 0, CAST(N'2022-08-06T07:44:29.640' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (23, 10696, 133, 0, CAST(N'2022-08-06T09:16:14.510' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (24, 10689, 133, 1, CAST(N'2022-08-06T10:21:53.507' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (25, 10703, 133, 0, CAST(N'2022-08-08T06:32:00.930' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (26, 10707, 141, 1, CAST(N'2022-08-11T07:21:06.687' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (27, 10716, 140, 0, CAST(N'2022-08-11T10:34:34.767' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (28, 10716, 143, 1, CAST(N'2022-08-11T10:34:54.910' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (29, 10716, 143, 1, CAST(N'2022-08-11T10:35:25.863' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (30, 10717, 141, 1, CAST(N'2022-08-11T10:54:28.980' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (31, 10720, 141, 1, CAST(N'2022-08-12T10:12:11.747' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (32, 10721, 141, 1, CAST(N'2022-08-12T10:15:25.770' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (33, 10710, 133, 0, CAST(N'2022-08-13T11:58:30.983' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (34, 10711, 133, 0, CAST(N'2022-08-13T11:58:37.513' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (35, 10735, 133, 0, CAST(N'2022-08-13T12:02:56.317' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (36, 10736, 133, 0, CAST(N'2022-08-13T12:04:15.720' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (37, 10737, 140, 1, CAST(N'2022-08-16T09:15:11.860' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (38, 10738, 133, 0, CAST(N'2022-08-18T01:53:04.860' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (39, 10738, 133, 0, CAST(N'2022-08-18T01:54:41.953' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (40, 10738, 133, 0, CAST(N'2022-08-18T01:55:17.123' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (41, 10738, 133, 0, CAST(N'2022-08-18T01:55:32.993' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (42, 10738, 133, 0, CAST(N'2022-08-18T01:55:55.030' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (43, 10738, 133, 0, CAST(N'2022-08-18T01:56:02.467' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (44, 10738, 133, 0, CAST(N'2022-08-18T01:56:22.590' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (45, 10741, 133, 1, CAST(N'2022-08-18T02:53:31.407' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (46, 10745, 140, 1, CAST(N'2022-08-18T10:00:38.573' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (47, 10778, 149, 1, CAST(N'2023-02-01T07:18:25.710' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (48, 10788, 149, 1, CAST(N'2023-02-02T08:54:31.740' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (49, 10812, 149, 1, CAST(N'2023-02-03T08:30:21.080' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (50, 10811, 149, 1, CAST(N'2023-02-03T09:21:06.447' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (51, 10814, 149, 1, CAST(N'2023-02-03T09:28:17.897' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (52, 10816, 85, 1, CAST(N'2023-02-04T00:37:20.257' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (53, 10820, 85, 1, CAST(N'2023-02-04T00:49:01.050' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (54, 10822, 154, 1, CAST(N'2023-02-04T12:38:01.940' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (55, 10834, 149, 1, CAST(N'2023-02-06T06:23:43.810' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (56, 10830, 149, 1, CAST(N'2023-02-06T07:28:10.310' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (57, 10831, 149, 1, CAST(N'2023-02-06T07:28:31.987' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (58, 10832, 149, 1, CAST(N'2023-02-06T07:28:36.310' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (59, 10833, 149, 1, CAST(N'2023-02-06T07:28:42.153' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (60, 10838, 149, 1, CAST(N'2023-02-06T10:56:31.393' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (61, 10837, 149, 1, CAST(N'2023-02-06T11:00:03.390' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (62, 10840, 149, 1, CAST(N'2023-02-06T11:21:00.170' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (63, 10963, 154, 1, CAST(N'2023-02-07T06:12:27.177' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (64, 10967, 6, 1, CAST(N'2023-02-07T11:43:12.960' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (65, 10973, 3, 1, CAST(N'2023-02-08T01:56:41.960' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (66, 10970, 3, 1, CAST(N'2023-02-08T01:56:53.627' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (67, 10985, 6, 1, CAST(N'2023-02-08T06:16:10.060' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (68, 10986, 3, 1, CAST(N'2023-02-08T07:05:23.963' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (69, 10988, 7, 1, CAST(N'2023-02-08T07:19:25.680' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (70, 10989, 7, 1, CAST(N'2023-02-08T09:12:04.740' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (71, 10983, 7, 1, CAST(N'2023-02-08T09:38:50.000' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (72, 10982, 7, 1, CAST(N'2023-02-08T09:40:48.920' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (73, 10966, 7, 1, CAST(N'2023-02-08T09:42:04.700' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (74, 10965, 7, 0, CAST(N'2023-02-08T10:15:03.777' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (75, 10990, 7, 1, CAST(N'2023-02-08T10:17:45.267' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (76, 10984, 3, 1, CAST(N'2023-02-09T02:26:40.780' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (77, 10981, 3, 1, CAST(N'2023-02-09T02:26:54.230' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (78, 10980, 3, 1, CAST(N'2023-02-09T02:29:43.560' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (79, 10979, 3, 1, CAST(N'2023-02-09T02:29:51.230' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (80, 10992, 7, 1, CAST(N'2023-02-10T07:13:16.387' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (81, 10993, 7, 1, CAST(N'2023-02-10T07:16:22.647' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (82, 10994, 7, 1, CAST(N'2023-02-10T09:30:39.473' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (83, 10995, 7, 1, CAST(N'2023-02-10T10:41:34.040' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (84, 11011, 23, 1, CAST(N'2023-08-07T09:43:45.497' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (85, 11012, 23, 1, CAST(N'2023-08-07T10:29:57.360' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (86, 11028, 24, 1, CAST(N'2023-08-07T13:32:51.083' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (87, 11034, 24, 1, CAST(N'2023-08-08T06:45:29.300' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (88, 24, 24, 1, CAST(N'2023-08-08T06:53:41.887' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (89, 11044, 6, 1, CAST(N'2023-08-08T07:31:32.167' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (90, 11067, 6, 1, CAST(N'2023-08-14T07:52:27.743' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (91, 11131, 39, 1, CAST(N'2023-08-16T04:22:58.547' AS DateTime))
INSERT [dbo].[HelpRespondedVolunteers] ([RespondId], [HelpId], [MemberId], [IsAccepted], [RespondDate]) VALUES (92, 11132, 39, 1, CAST(N'2023-08-16T04:24:04.120' AS DateTime))
SET IDENTITY_INSERT [dbo].[HelpRespondedVolunteers] OFF
GO
SET IDENTITY_INSERT [dbo].[HelpVideos] ON 

INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (4, 263, N'81_263_12142021105401AM.mp4', CAST(N'2021-12-14T10:54:01.093' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (5, 268, N'81_268_1215202190502AM.mp4', CAST(N'2021-12-15T09:05:02.457' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (6, 269, N'74_269_12152021103812AM.mp4', CAST(N'2021-12-15T10:38:12.443' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (7, 276, N'74_276_1216202143949AM.mp4', CAST(N'2021-12-16T04:39:49.207' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (8, 277, N'74_277_1217202184952AM.mp4', CAST(N'2021-12-17T08:49:52.827' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (9, 278, N'74_278_1221202173001AM.mp4', CAST(N'2021-12-21T07:30:01.917' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10, 279, N'74_279_1221202183028AM.mp4', CAST(N'2021-12-21T08:30:28.500' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (11, 277, N'72_277_1222202173601AM.mp4', CAST(N'2021-12-22T07:36:01.333' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (12, 281, N'81_281_1222202174615AM.mp4', CAST(N'2021-12-22T07:46:15.077' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (13, 282, N'81_282_1222202190318AM.mp4', CAST(N'2021-12-22T09:03:18.243' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (14, 283, N'81_283_1222202190542AM.mp4', CAST(N'2021-12-22T09:05:42.643' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (15, 282, N'81_282_1222202191414AM.mp4', CAST(N'2021-12-22T09:14:14.057' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (16, 282, N'81_282_22122021144452.mp4', CAST(N'2021-12-22T09:14:57.750' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (17, 284, N'81_284_1222202191705AM.mp4', CAST(N'2021-12-22T09:17:05.930' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (18, 282, N'81_282_22122021145653.mp4', CAST(N'2021-12-22T09:26:56.313' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (19, 282, N'81_282_22122021145741.mp4', CAST(N'2021-12-22T09:27:41.727' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (20, 285, N'81_285_1222202194934AM.mp4', CAST(N'2021-12-22T09:49:34.493' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (21, 286, N'74_286_12222021105044AM.mp4', CAST(N'2021-12-22T10:50:44.333' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (22, 286, N'81_286_12222021105704AM.mp4', CAST(N'2021-12-22T10:57:04.420' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (23, 288, N'74_288_12222021110918AM.mp4', CAST(N'2021-12-22T11:09:18.190' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (24, 289, N'74_289_12222021111051AM.mp4', CAST(N'2021-12-22T11:10:51.350' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (25, 291, N'81_291_1224202184103AM.mp4', CAST(N'2021-12-24T08:41:03.317' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (26, 292, N'74_292_1224202184850AM.mp4', CAST(N'2021-12-24T08:48:50.613' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (27, 277, N'72_277_1224202185325AM.mp4', CAST(N'2021-12-24T08:53:25.757' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (28, 294, N'74_294_1224202190632AM.mp4', CAST(N'2021-12-24T09:06:32.830' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (29, 295, N'74_295_1227202161347AM.mp4', CAST(N'2021-12-27T06:13:47.917' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (30, 263, N'81_263_17202290409AM.mp4', CAST(N'2022-01-07T09:04:09.800' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (31, 305, N'81_305_17202291109AM.mp4', CAST(N'2022-01-07T09:11:09.867' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (32, 306, N'81_306_17202291934AM.mp4', CAST(N'2022-01-07T09:19:34.753' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (33, 307, N'74_307_17202292955AM.mp4', CAST(N'2022-01-07T09:29:55.553' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (34, 308, N'81_308_172022101510AM.mp4', CAST(N'2022-01-07T10:15:10.430' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (35, 309, N'74_309_172022102001AM.mp4', CAST(N'2022-01-07T10:20:01.280' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (36, 310, N'74_310_110202290717AM.mp4', CAST(N'2022-01-10T09:07:17.690' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (37, 311, N'82_311_1102022103646AM.mp4', CAST(N'2022-01-10T10:36:46.713' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (38, 312, N'82_312_1102022110623AM.mp4', CAST(N'2022-01-10T11:06:23.457' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (39, 313, N'82_313_1102022114448AM.mp4', CAST(N'2022-01-10T11:44:48.097' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (40, 314, N'82_314_1102022114817AM.mp4', CAST(N'2022-01-10T11:48:17.730' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (41, 316, N'84_316_112202282914AM.mp4', CAST(N'2022-01-12T08:29:14.423' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (42, 325, N'82_325_1122022105851AM.mp4', CAST(N'2022-01-12T10:58:51.757' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (43, 326, N'82_326_1122022110005AM.mp4', CAST(N'2022-01-12T11:00:05.497' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (44, 327, N'82_327_1122022110154AM.mp4', CAST(N'2022-01-12T11:01:54.943' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (45, 345, N'82_345_113202290407AM.mp4', CAST(N'2022-01-13T09:04:07.150' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (46, 346, N'82_346_113202290430AM.mp4', CAST(N'2022-01-13T09:04:30.657' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (47, 347, N'82_347_113202292000AM.mp4', CAST(N'2022-01-13T09:20:00.090' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (48, 348, N'74_348_113202292810AM.mp4', CAST(N'2022-01-13T09:28:10.340' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (49, 349, N'81_349_113202292848AM.mp4', CAST(N'2022-01-13T09:28:48.220' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (50, 350, N'74_350_113202292907AM.mp4', CAST(N'2022-01-13T09:29:07.730' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (51, 351, N'74_351_113202292955AM.mp4', CAST(N'2022-01-13T09:29:55.650' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (52, 352, N'81_352_113202293444AM.mp4', CAST(N'2022-01-13T09:34:44.213' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (53, 353, N'87_353_1132022100224AM.mp4', CAST(N'2022-01-13T10:02:24.200' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (54, 354, N'87_354_1132022100311AM.mp4', CAST(N'2022-01-13T10:03:11.750' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (55, 355, N'82_355_1132022101116AM.mp4', CAST(N'2022-01-13T10:11:16.300' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (56, 357, N'82_357_1132022102433AM.mp4', CAST(N'2022-01-13T10:24:33.580' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (57, 358, N'82_358_1132022102653AM.mp4', CAST(N'2022-01-13T10:26:53.920' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (58, 361, N'81_361_114202224603AM.mp4', CAST(N'2022-01-14T02:46:03.853' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (59, 362, N'81_362_114202224722AM.mp4', CAST(N'2022-01-14T02:47:22.660' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (60, 0, N'63_0_1142022125014PM.mp4', CAST(N'2022-01-14T12:50:14.223' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (61, 370, N'87_370_117202294632AM.mp4', CAST(N'2022-01-17T09:46:32.450' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (62, 370, N'87_370_117202294632AM.mp4', CAST(N'2022-01-17T09:46:32.480' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (63, 372, N'87_372_117202294827AM.mp4', CAST(N'2022-01-17T09:48:27.320' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (64, 375, N'82_375_118202253931AM.mp4', CAST(N'2022-01-18T05:39:31.300' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (65, 376, N'82_376_118202254703AM.mp4', CAST(N'2022-01-18T05:47:03.110' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (66, 377, N'82_377_118202270743AM.mp4', CAST(N'2022-01-18T07:07:43.763' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (67, 378, N'84_378_118202285244AM.mp4', CAST(N'2022-01-18T08:52:44.727' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (68, 277, N'63_277_120202265714AM.mp4', CAST(N'2022-01-20T06:57:14.270' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (69, 0, N'74_0_1242022110543AM.mp4', CAST(N'2022-01-24T11:05:43.633' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (70, 388, N'92_388_1242022110643AM.mp4', CAST(N'2022-01-24T11:06:43.627' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (71, 389, N'92_389_1242022110946AM.mp4', CAST(N'2022-01-24T11:09:46.940' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (72, 0, N'86_0_1242022120710PM.mp4', CAST(N'2022-01-24T12:07:10.313' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (73, 0, N'86_0_1242022120717PM.mp4', CAST(N'2022-01-24T12:07:17.220' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (74, 0, N'86_0_125202245935AM.mp4', CAST(N'2022-01-25T04:59:35.980' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (75, 399, N'93_399_125202252459AM.mp4', CAST(N'2022-01-25T05:24:59.340' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (76, 400, N'97_400_125202262735AM.mp4', CAST(N'2022-01-25T06:27:35.130' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (77, 402, N'97_402_125202270545AM.mp4', CAST(N'2022-01-25T07:05:45.530' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (78, 405, N'96_405_126202210520AM.mp4', CAST(N'2022-01-26T01:05:20.223' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (79, 407, N'96_407_126202231248AM.mp4', CAST(N'2022-01-26T03:12:48.570' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (80, 412, N'96_412_126202261033AM.mp4', CAST(N'2022-01-26T06:10:33.793' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (81, 413, N'97_413_126202262421AM.mp4', CAST(N'2022-01-26T06:24:21.660' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (82, 417, N'96_417_126202272001AM.mp4', CAST(N'2022-01-26T07:20:01.173' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (83, 418, N'96_418_126202282146AM.mp4', CAST(N'2022-01-26T08:21:46.777' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (84, 423, N'96_423_127202223739AM.mp4', CAST(N'2022-01-27T02:37:39.290' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (85, 432, N'97_432_131202265702AM.mp4', CAST(N'2022-01-31T06:57:02.430' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (86, 433, N'97_433_21202235320PM.mp4', CAST(N'2022-02-01T15:53:20.660' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (87, 435, N'93_435_24202291850AM.mp4', CAST(N'2022-02-04T09:18:50.617' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (88, 436, N'97_436_24202282303PM.mp4', CAST(N'2022-02-04T20:23:03.953' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (89, 0, N'86_0_25202260956AM.mp4', CAST(N'2022-02-05T06:09:56.833' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (90, 0, N'86_0_25202261042AM.mp4', CAST(N'2022-02-05T06:10:42.957' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (91, 0, N'86_0_25202261118AM.mp4', CAST(N'2022-02-05T06:11:18.883' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (92, 447, N'97_447_25202261433AM.mp4', CAST(N'2022-02-05T06:14:33.407' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (93, 0, N'63_0_262022120942PM.mp4', CAST(N'2022-02-06T12:09:42.360' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (94, 464, N'93_464_262022121100PM.mp4', CAST(N'2022-02-06T12:11:00.763' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (95, 467, N'97_467_27202255702AM.mp4', CAST(N'2022-02-07T05:57:02.847' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (96, 468, N'96_468_27202262134AM.mp4', CAST(N'2022-02-07T06:21:34.523' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (97, 472, N'97_472_27202274456AM.mp4', CAST(N'2022-02-07T07:44:56.340' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (98, 474, N'97_474_27202291650AM.mp4', CAST(N'2022-02-07T09:16:50.800' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (99, 484, N'93_484_212202255507AM.mp4', CAST(N'2022-02-12T05:55:07.293' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (100, 485, N'93_485_212202260518AM.mp4', CAST(N'2022-02-12T06:05:18.113' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (101, 486, N'93_486_212202260729AM.mp4', CAST(N'2022-02-12T06:07:29.123' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (102, 487, N'93_487_212202261225AM.mp4', CAST(N'2022-02-12T06:12:25.537' AS DateTime))
GO
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (103, 488, N'93_488_212202261408AM.mp4', CAST(N'2022-02-12T06:14:08.620' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (104, 489, N'93_489_212202261855AM.mp4', CAST(N'2022-02-12T06:18:55.263' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (105, 277, N'86_277_214202293702AM.mp4', CAST(N'2022-02-14T09:37:02.070' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (106, 492, N'86_492_215202252344AM.mp4', CAST(N'2022-02-15T05:23:44.420' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (107, 493, N'86_493_215202254518AM.mp4', CAST(N'2022-02-15T05:45:18.683' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (108, 494, N'95_494_215202282719AM.mp4', CAST(N'2022-02-15T08:27:19.203' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (109, 495, N'96_495_215202284105AM.mp4', CAST(N'2022-02-15T08:41:05.573' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (110, 503, N'95_503_215202293353AM.mp4', CAST(N'2022-02-15T09:33:53.523' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (111, 506, N'95_506_215202295102AM.mp4', CAST(N'2022-02-15T09:51:02.157' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (112, 508, N'95_508_215202295503AM.mp4', CAST(N'2022-02-15T09:55:03.637' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (113, 522, N'86_522_216202241050AM.mp4', CAST(N'2022-02-16T04:10:50.670' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (114, 532, N'97_532_216202245018AM.mp4', CAST(N'2022-02-16T04:50:18.830' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (115, 535, N'86_535_216202284309AM.mp4', CAST(N'2022-02-16T08:43:09.057' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (116, 536, N'97_536_216202284416AM.mp4', CAST(N'2022-02-16T08:44:16.517' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (117, 538, N'113_538_217202254248AM.mp4', CAST(N'2022-02-17T05:42:48.813' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (118, 575, N'96_575_37202291040AM.mp4', CAST(N'2022-03-07T09:10:40.270' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (119, 576, N'96_576_37202291200AM.mp4', CAST(N'2022-03-07T09:12:00.943' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (120, 577, N'97_577_37202291724AM.mp4', CAST(N'2022-03-07T09:17:24.567' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (121, 577, N'97_577_37202292231AM.mp4', CAST(N'2022-03-07T09:22:31.413' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (122, 582, N'122_582_3112022115847AM.mp4', CAST(N'2022-03-11T11:58:47.400' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (123, 589, N'97_589_319202290808AM.mp4', CAST(N'2022-03-19T09:08:08.830' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (124, 612, N'112_612_323202230854AM.mp4', CAST(N'2022-03-23T03:08:54.450' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (125, 614, N'97_614_323202282635AM.mp4', CAST(N'2022-03-23T08:26:35.800' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (126, 620, N'97_620_323202283510AM.mp4', CAST(N'2022-03-23T08:35:10.823' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (127, 621, N'95_621_323202284349AM.mp4', CAST(N'2022-03-23T08:43:49.790' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (128, 624, N'63_624_44202240651AM.mp4', CAST(N'2022-04-04T04:06:51.090' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (129, 625, N'63_625_413202294637AM.mp4', CAST(N'2022-04-13T09:46:37.250' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (130, 626, N'63_626_61202293511PM.mp4', CAST(N'2022-06-01T21:35:11.467' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (131, 627, N'63_627_622022120732AM.mp4', CAST(N'2022-06-02T00:07:32.143' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (132, 628, N'63_628_68202211443AM.mp4', CAST(N'2022-06-08T01:14:43.130' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (133, 630, N'63_630_614202222627AM.mp4', CAST(N'2022-06-14T02:26:27.160' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10133, 10632, N'63_10632_711202210613AM.mp4', CAST(N'2022-07-11T01:06:13.783' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10134, 10633, N'63_10633_7112022103603AM.mp4', CAST(N'2022-07-11T10:36:03.543' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10135, 10635, N'133_10635_82202272210AM.mp4', CAST(N'2022-08-02T07:22:10.530' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10136, 10639, N'135_10639_82202291842AM.mp4', CAST(N'2022-08-02T09:18:42.933' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10137, 10640, N'86_10640_82202292002AM.mp4', CAST(N'2022-08-02T09:20:02.713' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10138, 10641, N'136_10641_82202294449AM.mp4', CAST(N'2022-08-02T09:44:49.090' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10139, 10647, N'136_10647_82202295722AM.mp4', CAST(N'2022-08-02T09:57:22.077' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10140, 10657, N'93_10657_83202221228PM.mp4', CAST(N'2022-08-03T14:12:28.640' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10141, 10659, N'112_10659_84202243837AM.mp4', CAST(N'2022-08-04T04:38:37.143' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10142, 10660, N'93_10660_84202244249AM.mp4', CAST(N'2022-08-04T04:42:49.550' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10143, 10664, N'112_10664_84202244621AM.mp4', CAST(N'2022-08-04T04:46:21.313' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10144, 10665, N'112_10665_84202245325AM.mp4', CAST(N'2022-08-04T04:53:25.937' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10145, 10677, N'133_10677_84202265728AM.mp4', CAST(N'2022-08-04T06:57:28.943' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10146, 10678, N'133_10678_84202270307AM.mp4', CAST(N'2022-08-04T07:03:07.697' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10147, 10684, N'93_10684_84202275154AM.mp4', CAST(N'2022-08-04T07:51:54.223' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10148, 10689, N'134_10689_84202281057AM.mp4', CAST(N'2022-08-04T08:10:57.187' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10149, 10690, N'134_10690_84202282424AM.mp4', CAST(N'2022-08-04T08:24:24.523' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10150, 10691, N'133_10691_85202284142AM.mp4', CAST(N'2022-08-05T08:41:42.237' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10151, 10693, N'133_10693_86202264553AM.mp4', CAST(N'2022-08-06T06:45:53.290' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10152, 10696, N'134_10696_86202291558AM.mp4', CAST(N'2022-08-06T09:15:58.213' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10153, 10697, N'134_10697_86202291746AM.mp4', CAST(N'2022-08-06T09:17:46.867' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10154, 10699, N'132_10699_862022103743AM.mp4', CAST(N'2022-08-06T10:37:43.023' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10155, 10702, N'63_10702_88202245842AM.mp4', CAST(N'2022-08-08T04:58:42.607' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10156, 10703, N'134_10703_88202262942AM.mp4', CAST(N'2022-08-08T06:29:42.177' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10157, 10704, N'133_10704_88202265455AM.mp4', CAST(N'2022-08-08T06:54:55.553' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10158, 10705, N'134_10705_88202290651AM.mp4', CAST(N'2022-08-08T09:06:51.743' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10159, 10706, N'134_10706_88202293437AM.mp4', CAST(N'2022-08-08T09:34:37.653' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10160, 10708, N'134_10708_88202293558AM.mp4', CAST(N'2022-08-08T09:35:58.793' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10161, 10709, N'133_10709_8102022110831AM.mp4', CAST(N'2022-08-10T11:08:31.267' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10162, 10710, N'86_10710_8102022113125AM.mp4', CAST(N'2022-08-10T11:31:25.307' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10163, 10711, N'86_10711_8102022113435AM.mp4', CAST(N'2022-08-10T11:34:35.377' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10164, 10713, N'140_10713_811202275750AM.mp4', CAST(N'2022-08-11T07:57:50.777' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10165, 10715, N'141_10715_8112022102133AM.mp4', CAST(N'2022-08-11T10:21:33.833' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10166, 10716, N'143_10716_8112022103218AM.mp4', CAST(N'2022-08-11T10:32:18.710' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10167, 10717, N'141_10717_8112022105329AM.mp4', CAST(N'2022-08-11T10:53:29.700' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10168, 10722, N'141_10722_8122022110502AM.mp4', CAST(N'2022-08-12T11:05:02.480' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10169, 10723, N'141_10723_8122022110945AM.mp4', CAST(N'2022-08-12T11:09:45.287' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10170, 10724, N'63_10724_812202233854PM.mp4', CAST(N'2022-08-12T15:38:54.470' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10171, 10725, N'63_10725_812202234326PM.mp4', CAST(N'2022-08-12T15:43:26.010' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10172, 10727, N'132_10727_8132022111343AM.mp4', CAST(N'2022-08-13T11:13:43.740' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10173, 10731, N'132_10731_8132022115740AM.mp4', CAST(N'2022-08-13T11:57:40.060' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10174, 10732, N'134_10732_8132022115928AM.mp4', CAST(N'2022-08-13T11:59:28.230' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10175, 10733, N'134_10733_8132022120036PM.mp4', CAST(N'2022-08-13T12:00:36.683' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10176, 10737, N'143_10737_816202291425AM.mp4', CAST(N'2022-08-16T09:14:25.423' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10177, 10738, N'132_10738_818202215215AM.mp4', CAST(N'2022-08-18T01:52:15.310' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10178, 10739, N'132_10739_818202224824AM.mp4', CAST(N'2022-08-18T02:48:24.930' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10179, 10741, N'132_10741_818202225326AM.mp4', CAST(N'2022-08-18T02:53:26.810' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10180, 10742, N'133_10742_818202230559AM.mp4', CAST(N'2022-08-18T03:05:59.633' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10181, 10743, N'133_10743_818202231049AM.mp4', CAST(N'2022-08-18T03:10:49.543' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10182, 10744, N'141_10744_818202292546AM.mp4', CAST(N'2022-08-18T09:25:46.487' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10183, 10745, N'143_10745_818202295908AM.mp4', CAST(N'2022-08-18T09:59:08.880' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10184, 10747, N'138_10747_8262022103014AM.mp4', CAST(N'2022-08-26T10:30:14.950' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10185, 10753, N'137_10753_95202281643AM.mp4', CAST(N'2022-09-05T08:16:43.980' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10186, 10755, N'137_10755_952022101833AM.mp4', CAST(N'2022-09-05T10:18:33.627' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10187, 10756, N'137_10756_952022101912AM.mp4', CAST(N'2022-09-05T10:19:12.630' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10188, 10757, N'133_10757_952022102106AM.mp4', CAST(N'2022-09-05T10:21:06.693' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10189, 639, N'133_639_95202232505PM.mp4', CAST(N'2022-09-05T15:25:05.847' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10190, 642, N'137_642_96202261328AM.mp4', CAST(N'2022-09-06T06:13:28.420' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10191, 646, N'135_646_96202262336AM.mp4', CAST(N'2022-09-06T06:23:36.180' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10192, 650, N'145_650_962022110953AM.mp4', CAST(N'2022-09-06T11:09:54.507' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10193, 651, N'145_651_962022111028AM.mp4', CAST(N'2022-09-06T11:10:28.647' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10194, 10758, N'63_10758_99202253517AM.mp4', CAST(N'2022-09-09T05:35:17.110' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10195, 10759, N'63_10759_912202210253PM.mp4', CAST(N'2022-09-12T13:02:53.183' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10196, 10768, N'63_10768_10302022105229AM.mp4', CAST(N'2022-10-30T10:52:29.670' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10197, 10769, N'63_10769_10302022111921AM.mp4', CAST(N'2022-10-30T11:19:21.300' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10198, 10776, N'132_10776_1312023101904AM.mp4', CAST(N'2023-01-31T10:19:04.690' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10199, 10779, N'145_10779_21202371258AM.mp4', CAST(N'2023-02-01T07:12:58.730' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10200, 10780, N'150_10780_212023100622AM.mp4', CAST(N'2023-02-01T10:06:22.663' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10201, 10782, N'150_10782_212023115357AM.mp4', CAST(N'2023-02-01T11:53:57.687' AS DateTime))
GO
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10202, 10783, N'150_10783_212023120227PM.mp4', CAST(N'2023-02-01T12:02:27.617' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10203, 10784, N'63_10784_21202310408PM.mp4', CAST(N'2023-02-01T13:04:08.763' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10204, 10786, N'150_10786_22202363949AM.mp4', CAST(N'2023-02-02T06:39:49.927' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10205, 10787, N'150_10787_22202385129AM.mp4', CAST(N'2023-02-02T08:51:29.130' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10206, 10788, N'149_10788_22202385259AM.mp4', CAST(N'2023-02-02T08:52:59.160' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10207, 10789, N'150_10789_22202390639AM.mp4', CAST(N'2023-02-02T09:06:39.673' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10208, 10792, N'86_10792_23202342435AM.mp4', CAST(N'2023-02-03T04:24:35.293' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10209, 10796, N'153_10796_23202350855AM.mp4', CAST(N'2023-02-03T05:08:55.953' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10210, 10797, N'145_10797_23202351044AM.mp4', CAST(N'2023-02-03T05:10:44.787' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10211, 10801, N'154_10801_23202351328AM.mp4', CAST(N'2023-02-03T05:13:28.990' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10212, 10809, N'150_10809_23202353920AM.mp4', CAST(N'2023-02-03T05:39:20.693' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10213, 10810, N'150_10810_23202354130AM.mp4', CAST(N'2023-02-03T05:41:30.670' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10214, 10811, N'150_10811_23202361212AM.mp4', CAST(N'2023-02-03T06:12:12.893' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10215, 10812, N'150_10812_23202382837AM.mp4', CAST(N'2023-02-03T08:28:37.190' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10216, 10813, N'150_10813_23202391938AM.mp4', CAST(N'2023-02-03T09:19:38.303' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10217, 10814, N'150_10814_23202392729AM.mp4', CAST(N'2023-02-03T09:27:29.903' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10218, 10815, N'150_10815_232023113157AM.mp4', CAST(N'2023-02-03T11:31:57.340' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10219, 10826, N'153_10826_242023124648PM.mp4', CAST(N'2023-02-04T12:46:48.593' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10220, 10836, N'150_10836_26202375215AM.mp4', CAST(N'2023-02-06T07:52:15.957' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10221, 10837, N'150_10837_26202375224AM.mp4', CAST(N'2023-02-06T07:52:24.043' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10222, 10839, N'150_10839_262023105346AM.mp4', CAST(N'2023-02-06T10:53:46.503' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10223, 10959, N'149_10959_27202354439AM.mp4', CAST(N'2023-02-07T05:44:39.743' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10224, 10960, N'147_10960_27202360926AM.mp4', CAST(N'2023-02-07T06:09:26.720' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10225, 10962, N'151_10962_27202361054AM.mp4', CAST(N'2023-02-07T06:10:54.490' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10226, 10963, N'151_10963_27202361139AM.mp4', CAST(N'2023-02-07T06:11:39.670' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10227, 10968, N'6_10968_272023113358AM.mp4', CAST(N'2023-02-07T11:33:58.100' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10228, 10969, N'1_10969_272023113601AM.mp4', CAST(N'2023-02-07T11:36:01.947' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10229, 10974, N'3_10974_28202334132AM.mp4', CAST(N'2023-02-08T03:41:32.880' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10230, 10981, N'3_10981_28202342351AM.mp4', CAST(N'2023-02-08T04:23:51.803' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10231, 10982, N'4_10982_28202355813AM.mp4', CAST(N'2023-02-08T05:58:13.797' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10232, 10983, N'7_10983_28202360459AM.mp4', CAST(N'2023-02-08T06:04:59.933' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10233, 10986, N'4_10986_28202365552AM.mp4', CAST(N'2023-02-08T06:55:52.060' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10234, 10987, N'4_10987_28202371522AM.mp4', CAST(N'2023-02-08T07:15:22.367' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10235, 10988, N'7_10988_28202371917AM.mp4', CAST(N'2023-02-08T07:19:17.193' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10236, 10989, N'4_10989_28202391115AM.mp4', CAST(N'2023-02-08T09:11:15.323' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10237, 10990, N'7_10990_282023101622AM.mp4', CAST(N'2023-02-08T10:16:22.617' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10238, 10993, N'7_10993_210202371529AM.mp4', CAST(N'2023-02-10T07:15:29.323' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10239, 10994, N'4_10994_210202392649AM.mp4', CAST(N'2023-02-10T09:26:49.757' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10240, 11001, N'1_11001_321202390835AM.mp4', CAST(N'2023-03-21T09:08:35.907' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10241, 11002, N'1_11002_4122023122021AM.mp4', CAST(N'2023-04-12T00:20:21.940' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10242, 11003, N'1_11003_620202330038PM.mp4', CAST(N'2023-06-20T15:00:38.597' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10243, 11004, N'1_11004_620202330431PM.mp4', CAST(N'2023-06-20T15:04:31.643' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10244, 11005, N'1_11005_620202331302PM.mp4', CAST(N'2023-06-20T15:13:02.737' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10245, 11006, N'1_11006_624202324633AM.mp4', CAST(N'2023-06-24T02:46:33.057' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10246, 11007, N'1_11007_625202390528AM.mp4', CAST(N'2023-06-25T09:05:28.677' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10247, 11008, N'20_11008_87202384937AM.mp4', CAST(N'2023-08-07T08:49:37.657' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10248, 11009, N'22_11009_87202385238AM.mp4', CAST(N'2023-08-07T08:52:38.860' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10249, 11011, N'24_11011_87202394337AM.mp4', CAST(N'2023-08-07T09:43:37.187' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10250, 11012, N'1_11012_872023103009AM.mp4', CAST(N'2023-08-07T10:30:09.723' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10251, 11015, N'22_11015_87202310639PM.mp4', CAST(N'2023-08-07T13:06:39.793' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10252, 11016, N'6_11016_87202312317PM.mp4', CAST(N'2023-08-07T13:23:17.157' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10253, 11017, N'22_11017_87202312613PM.mp4', CAST(N'2023-08-07T13:26:13.647' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10254, 11018, N'22_11018_87202312751PM.mp4', CAST(N'2023-08-07T13:27:51.647' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10255, 11019, N'22_11019_87202312901PM.mp4', CAST(N'2023-08-07T13:29:01.350' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10256, 11020, N'22_11020_87202312944PM.mp4', CAST(N'2023-08-07T13:29:44.490' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10257, 11021, N'2_11021_87202313003PM.mp4', CAST(N'2023-08-07T13:30:03.630' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10258, 11024, N'24_11024_87202313036PM.mp4', CAST(N'2023-08-07T13:30:36.993' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10259, 11026, N'6_11026_87202313222PM.mp4', CAST(N'2023-08-07T13:32:22.373' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10260, 11027, N'24_11027_87202313224PM.mp4', CAST(N'2023-08-07T13:32:24.770' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10261, 11032, N'22_11032_87202325434PM.mp4', CAST(N'2023-08-07T14:54:34.203' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10262, 11033, N'20_11033_87202325552PM.mp4', CAST(N'2023-08-07T14:55:52.563' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10263, 11034, N'4_11034_88202355550AM.mp4', CAST(N'2023-08-08T05:55:50.770' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10264, 11036, N'22_11036_88202365251AM.mp4', CAST(N'2023-08-08T06:52:51.787' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10265, 11037, N'22_11037_88202365456AM.mp4', CAST(N'2023-08-08T06:54:56.707' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10266, 11038, N'22_11038_88202365534AM.mp4', CAST(N'2023-08-08T06:55:34.677' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10267, 11040, N'22_11040_88202370624AM.mp4', CAST(N'2023-08-08T07:06:24.857' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10268, 11042, N'22_11042_88202372750AM.mp4', CAST(N'2023-08-08T07:27:50.963' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10269, 11048, N'27_11048_882023120327PM.mp4', CAST(N'2023-08-08T12:03:27.680' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10270, 11049, N'28_11049_882023120625PM.mp4', CAST(N'2023-08-08T12:06:25.063' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10271, 11051, N'28_11051_882023120902PM.mp4', CAST(N'2023-08-08T12:09:02.697' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10272, 11054, N'29_11054_882023125734PM.mp4', CAST(N'2023-08-08T12:57:34.360' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10273, 11056, N'30_11056_88202311759PM.mp4', CAST(N'2023-08-08T13:17:59.597' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10274, 11059, N'35_11059_814202371356AM.mp4', CAST(N'2023-08-14T07:13:56.643' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10275, 11061, N'37_11061_814202372929AM.mp4', CAST(N'2023-08-14T07:29:29.060' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10276, 11066, N'5_11066_814202374854AM.mp4', CAST(N'2023-08-14T07:48:54.977' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10277, 11061, N'37_11061_814202380939AM.mp4', CAST(N'2023-08-14T08:09:39.970' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10278, 11068, N'37_11068_814202381101AM.mp4', CAST(N'2023-08-14T08:11:01.173' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10279, 11069, N'35_11069_814202381700AM.mp4', CAST(N'2023-08-14T08:17:00.827' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10280, 11070, N'37_11070_814202381923AM.mp4', CAST(N'2023-08-14T08:19:23.187' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10281, 11072, N'40_11072_814202384514AM.mp4', CAST(N'2023-08-14T08:45:14.827' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10282, 11073, N'40_11073_814202384622AM.mp4', CAST(N'2023-08-14T08:46:22.633' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10283, 11074, N'39_11074_814202384726AM.mp4', CAST(N'2023-08-14T08:47:26.630' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10284, 11075, N'39_11075_814202384820AM.mp4', CAST(N'2023-08-14T08:48:20.613' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10285, 11076, N'39_11076_814202385246AM.mp4', CAST(N'2023-08-14T08:52:46.107' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10286, 11077, N'5_11077_814202385405AM.mp4', CAST(N'2023-08-14T08:54:05.380' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10287, 11078, N'38_11078_814202385436AM.mp4', CAST(N'2023-08-14T08:54:36.130' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10288, 11081, N'38_11081_814202385654AM.mp4', CAST(N'2023-08-14T08:56:54.423' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10289, 11082, N'38_11082_814202385728AM.mp4', CAST(N'2023-08-14T08:57:28.677' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10290, 11083, N'39_11083_814202391038AM.mp4', CAST(N'2023-08-14T09:10:38.653' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10291, 11088, N'40_11088_814202391746AM.mp4', CAST(N'2023-08-14T09:17:46.857' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10292, 277, N'40_277_814202393124AM.mp4', CAST(N'2023-08-14T09:31:24.570' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10293, 11100, N'40_11100_814202394730AM.mp4', CAST(N'2023-08-14T09:47:30.377' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10294, 11100, N'39_11100_814202394849AM.mp4', CAST(N'2023-08-14T09:48:49.440' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10295, 11102, N'40_11102_814202394959AM.mp4', CAST(N'2023-08-14T09:49:59.110' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10296, 11115, N'52_11115_816202314316AM.mp4', CAST(N'2023-08-16T01:43:16.237' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10297, 11116, N'52_11116_816202314443AM.mp4', CAST(N'2023-08-16T01:44:43.150' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10298, 11117, N'53_11117_816202320118AM.mp4', CAST(N'2023-08-16T02:01:18.713' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10299, 11118, N'58_11118_816202335005AM.mp4', CAST(N'2023-08-16T03:50:05.110' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10300, 11119, N'58_11119_816202335112AM.mp4', CAST(N'2023-08-16T03:51:12.360' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10301, 11120, N'4_11120_816202341026AM.mp4', CAST(N'2023-08-16T04:10:26.280' AS DateTime))
GO
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10302, 277, N'52_277_816202341312AM.mp4', CAST(N'2023-08-16T04:13:12.290' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10303, 11125, N'52_11125_816202341421AM.mp4', CAST(N'2023-08-16T04:14:21.770' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10304, 11125, N'52_11125_816202341448AM.mp4', CAST(N'2023-08-16T04:14:48.450' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10305, 11128, N'4_11128_816202341600AM.mp4', CAST(N'2023-08-16T04:16:00.247' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10306, 11130, N'4_11130_816202341933AM.mp4', CAST(N'2023-08-16T04:19:33.840' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10307, 11131, N'40_11131_816202342251AM.mp4', CAST(N'2023-08-16T04:22:51.297' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10308, 11132, N'40_11132_816202342351AM.mp4', CAST(N'2023-08-16T04:23:51.603' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10309, 11133, N'59_11133_816202345125AM.mp4', CAST(N'2023-08-16T04:51:25.510' AS DateTime))
INSERT [dbo].[HelpVideos] ([VideoId], [HelpId], [VideoName], [CreatedDate]) VALUES (10310, 11145, N'44_11145_816202350859PM.mp4', CAST(N'2023-08-16T17:08:59.333' AS DateTime))
SET IDENTITY_INSERT [dbo].[HelpVideos] OFF
GO
SET IDENTITY_INSERT [dbo].[Location] ON 

INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (1, N'East Rajamandri', 1, 1, N'East Rajamandri Location', CAST(17.000500 AS Decimal(18, 6)), CAST(81.804000 AS Decimal(18, 6)), NULL)
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (2, N'South East Queensland', 2, 3, N'Brisbane is the largest city in both the South East Queensland region and the state of Queensland.', CAST(-28.016666 AS Decimal(18, 6)), CAST(153.399994 AS Decimal(18, 6)), NULL)
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (3, N'Kakinada', 1, 2, NULL, CAST(16.989065 AS Decimal(18, 6)), CAST(82.247467 AS Decimal(18, 6)), NULL)
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (4, N'North Chennai Thermal Power Station Road', NULL, 4, NULL, CAST(13.254838 AS Decimal(18, 6)), CAST(80.279186 AS Decimal(18, 6)), CAST(N'2021-11-02T05:58:17.203' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (5, N'Siddipet', NULL, 5, NULL, CAST(18.101800 AS Decimal(18, 6)), CAST(78.851960 AS Decimal(18, 6)), CAST(N'2021-11-02T15:33:02.297' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (6, N'Jagathgiri Gutta', NULL, 6, NULL, CAST(17.507334 AS Decimal(18, 6)), CAST(78.407742 AS Decimal(18, 6)), CAST(N'2021-11-02T15:40:17.513' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (7, N'Vikruthamala', NULL, 7, NULL, CAST(13.620476 AS Decimal(18, 6)), CAST(79.564207 AS Decimal(18, 6)), CAST(N'2021-11-02T15:47:28.507' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (8, N'7 Brisbane Road', NULL, 9, NULL, CAST(-27.937567 AS Decimal(18, 6)), CAST(153.406441 AS Decimal(18, 6)), CAST(N'2022-01-10T10:22:13.247' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (9, N'Rathana', NULL, 10, NULL, CAST(15.356116 AS Decimal(18, 6)), CAST(77.522529 AS Decimal(18, 6)), CAST(N'2022-01-10T10:30:17.250' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (10, N'20 Middle Quay Drive', NULL, 9, NULL, CAST(-27.925599 AS Decimal(18, 6)), CAST(153.382137 AS Decimal(18, 6)), CAST(N'2022-01-12T06:16:08.540' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (11, N'Cairnlea Drive', NULL, 9, NULL, CAST(-27.826032 AS Decimal(18, 6)), CAST(153.287255 AS Decimal(18, 6)), CAST(N'2022-01-12T06:18:59.720' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (12, N'58 Residences Cct', NULL, 9, NULL, CAST(-27.830377 AS Decimal(18, 6)), CAST(153.294351 AS Decimal(18, 6)), CAST(N'2022-01-12T06:20:25.550' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (13, N'Blacktown NSW', NULL, 11, NULL, CAST(-33.766098 AS Decimal(18, 6)), CAST(150.912693 AS Decimal(18, 6)), CAST(N'2022-01-22T02:26:31.817' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (14, N'Canberra ACT', NULL, 12, NULL, CAST(-35.307500 AS Decimal(18, 6)), CAST(149.124417 AS Decimal(18, 6)), CAST(N'2022-01-22T02:29:11.807' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (15, N'Siddipet Head Post Office', NULL, 15, NULL, CAST(18.104984 AS Decimal(18, 6)), CAST(78.843706 AS Decimal(18, 6)), CAST(N'2022-01-24T10:02:35.633' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (16, N'Chandaluru - Inkollu Road', NULL, 16, NULL, CAST(15.785365 AS Decimal(18, 6)), CAST(80.138227 AS Decimal(18, 6)), CAST(N'2022-01-24T10:35:26.407' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (17, N'Kakaji Colony', NULL, 17, NULL, CAST(18.004462 AS Decimal(18, 6)), CAST(79.568422 AS Decimal(18, 6)), CAST(N'2022-01-24T10:43:04.117' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (18, N'G V R Colony', NULL, 15, NULL, CAST(17.364092 AS Decimal(18, 6)), CAST(78.602277 AS Decimal(18, 6)), CAST(N'2022-01-24T10:54:32.907' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (19, N'Hi-Rise Colony', NULL, 15, NULL, CAST(17.518821 AS Decimal(18, 6)), CAST(78.380490 AS Decimal(18, 6)), CAST(N'2022-01-25T06:01:55.957' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (20, N'Adelaide Street', NULL, 14, NULL, CAST(-33.887053 AS Decimal(18, 6)), CAST(151.211639 AS Decimal(18, 6)), CAST(N'2022-02-01T06:02:24.283' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (21, N'MG Road', NULL, 18, NULL, CAST(9.981899 AS Decimal(18, 6)), CAST(76.282876 AS Decimal(18, 6)), CAST(N'2022-03-11T10:45:28.377' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (22, N'19 Rode Road', NULL, 3, NULL, CAST(-27.397552 AS Decimal(18, 6)), CAST(153.058234 AS Decimal(18, 6)), CAST(N'2022-03-28T02:17:56.237' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (23, N'19 Rode Road', NULL, 19, NULL, CAST(-27.397552 AS Decimal(18, 6)), CAST(153.058234 AS Decimal(18, 6)), CAST(N'2022-03-28T02:25:29.457' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (24, N'9 Rode Road', NULL, 19, NULL, CAST(-27.397482 AS Decimal(18, 6)), CAST(153.058579 AS Decimal(18, 6)), CAST(N'2022-03-28T02:33:59.873' AS DateTime))
INSERT [dbo].[Location] ([LocationId], [Location], [SenstitiveFlagId], [TownId], [LocationInfo], [Latitude], [Longitude], [CreatedDate]) VALUES (25, N'6MM2+M5Q', NULL, 20, NULL, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), CAST(N'2022-08-25T05:58:12.880' AS DateTime))
SET IDENTITY_INSERT [dbo].[Location] OFF
GO
SET IDENTITY_INSERT [dbo].[Member] ON 

INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (1, 0, N'Sateesh', N'D', 0, NULL, N'Sateesh', N'0576', N'8686860576', N'sateesh@gmail.com', 0, 1, 2, CAST(78.365150 AS Decimal(18, 6)), CAST(17.471519 AS Decimal(18, 6)), N'00084', N'RTA Office, Kondapur, Silpa Park, Hafeezpet, Kondapur, Telangana, India', NULL, NULL, N'Hyderbad', NULL, 0, NULL, 2, NULL, 1, NULL, CAST(N'2023-02-07T07:40:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (2, 1, N'Sai', N'Kumar', 1, NULL, N'Sai', N'1234', N'8686863442', N'sai@gmail.com', 0, 1, 2, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'500089', N' C92G+RVW, Manikonda Garden, Sri Balaji Nagar Colony, Hyderabad, Telangana 500089', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-07T07:43:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (3, 1, N'Kiran ', N'Chand', 1, NULL, N'Kiran', N'1234', N'9989255237', N'kiran@gmail.com', 0, 1, 2, CAST(78.525702 AS Decimal(18, 6)), CAST(17.368519 AS Decimal(18, 6)), N'500013', N'2-3-426/A, NH163, Poornodhaya Colony, MCH Quarters, Amberpet, Hyderabad, Telangana 500013', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-07T07:48:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (4, 1, N'Jahnavi', N'Jahnavi', 2, NULL, N'Jahnavi', N'1234', N'7032656730', N'januporeddy@gmail.com', 0, 1, 2, CAST(78.377854 AS Decimal(18, 6)), CAST(17.519668 AS Decimal(18, 6)), N'500090', N'Nizampet, Hyderabad, Telangana, India', NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, 1, NULL, CAST(N'2023-02-07T08:08:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (5, 1, N'Calvin', N'Rose', 1, NULL, N'Calvin', N'1234', N'7569332729', N'calvin@gmail.com', 0, 1, 2, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'500082', N'Maitrivanam Building, Kumar Basti, Ameerpet, Hyderabad, Telangana 500082', NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, 1, NULL, CAST(N'2023-02-07T08:10:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (6, 1, N'Vijay', N'Prasad', 1, NULL, N'Vijay', N'1234', N'7286976174', N'vijayprasad0302@gmail.com', 0, 1, 2, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'500073', N'1St Floor, Nagarjuna Nagar, Ameerpet, Beside Image Hospital, Hyderabad, Telangana 500073', N'street', N'Hyderabad', N'Hyderabad ', NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-10T09:18:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (7, 1, N'James', N'James', 1, NULL, N'James', N'1234', N'6767676767', N'james@gmail.com', 0, 1, 2, CAST(78.377854 AS Decimal(18, 6)), CAST(17.519668 AS Decimal(18, 6)), N'500090', N'Nizampet, Hyderabad, Telangana, India', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-07T09:49:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (8, 1, N'Kiran', N'Chand', NULL, NULL, N'kkkk', N'1234', N'9989255233', N'a.kiran.u@gmail.com', NULL, NULL, 0, CAST(78.531600 AS Decimal(18, 6)), CAST(17.368500 AS Decimal(18, 6)), N'500060', N'Dilsukh Nagar', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-13T08:12:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (9, 1, N'Apple', N'Test', 0, NULL, N'appleTest', N'1234', N'7777777777', N'test@gmail.com', 0, 1, 0, CAST(78.531600 AS Decimal(18, 6)), CAST(17.368500 AS Decimal(18, 6)), N'500060', N'Dilsukh Nagar', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-14T07:56:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (10, 1, N'Henry ', N'Leo', 0, NULL, N'Henry ', N'1234', N'5656565656', N'Henry@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'Hyderbad', NULL, NULL, N'Hyderbad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-02-14T09:55:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (11, 10, N'Baker', N'Leo', 0, N'nO50tc-14Aug2023024029960.jpg', N'Baker', N'1234', N'5656565666', N'', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'', N'', N'', N'Hyderbad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-02-14T09:58:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (12, 10, N'Licas', N'Leo', 0, NULL, N'Lucas', N'1234', N'4545454545', N'Lucas@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-14T10:05:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (13, 10, N'Oliver', N'Leo', 0, NULL, N'Oliver', N'1234', N'2323232323', N'Oliver@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-14T10:08:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (14, 0, N'Benjamin ', N'Lucas', 0, NULL, N'Benjamin ', N'1234', N'2525252525', N'Benjamin', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'', NULL, NULL, N'Hyderbad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-02-14T10:12:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (15, 0, N'Sao', N'Kumar', 0, NULL, N'saii', N'1234', N'8686868686', N'', 0, 1, 0, CAST(-122.084000 AS Decimal(18, 6)), CAST(37.421998 AS Decimal(18, 6)), N'500032', N'Hyderabad', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-15T01:33:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (16, 11, N'Sai', N'Kumar', 0, NULL, N'saiii', N'1234', N'8888888888', N'', 0, 1, 0, CAST(-122.084000 AS Decimal(18, 6)), CAST(37.421998 AS Decimal(18, 6)), N'500032', N'Hyderabad', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-15T01:37:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (17, 0, N'Sai', N'Kumar', 0, NULL, N'saik', N'1234', N'0000000000', N'', 0, 1, 0, CAST(-122.084000 AS Decimal(18, 6)), CAST(37.421998 AS Decimal(18, 6)), N'500032', N'Hyderbad', NULL, NULL, N'Hyderbad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-02-15T01:38:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (18, 14, N'Bomen', N'Lucas', 0, NULL, N'Bomen', N'1234', N'5656595959', N'Benjamin', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-15T06:10:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (19, 11, N'Baker', N'Leo', 0, NULL, N'baker1', N'1234', N'4545454544', N'', 0, 1, 0, CAST(78.381482 AS Decimal(18, 6)), CAST(17.520301 AS Decimal(18, 6)), N'500090', N'Nizampet Hyderabad ', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-02-15T06:26:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (20, 0, N'George', N'Reece', 0, NULL, N'George', N'1234', N'4545454444', N'George@gmail.com', 0, 1, 0, CAST(78.377803 AS Decimal(18, 6)), CAST(17.519603 AS Decimal(18, 6)), N'500090', N'Nizampet Hyderabad Telangana Estate, Hill County, Nizampet, Hyderabad, Telangana, India', NULL, NULL, N'Hyderbad', NULL, 0, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-07T10:13:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (21, 11, N'James', N'James', 0, NULL, N'Jamess', N'1234', N'1212121212', N'J@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'Hyderbad', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-07-12T06:40:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (22, 20, N'Michael', N'Hack', 0, NULL, N'Michael', N'1234', N'6767676767', N'boomer@gmail.com', 0, 1, 2, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'500090', N'Postmaster, Nizampet S.O, Hyderabad, Telangana, 500090', NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-07T10:17:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (23, 20, N'Sergi', N'Hen', 0, NULL, N'Sergi', N'1234', N'2323232322', N'Sergi@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'Hyderbad', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-07T09:24:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (24, 20, N'Oliver', N'Jake', 1, NULL, N'Oliver', N'1234', N'1212121211', N'simon@gmail.com', 0, 1, 0, CAST(78.381744 AS Decimal(18, 6)), CAST(17.520185 AS Decimal(18, 6)), N'500090', N'NH 65, Bhavani Nagar, Moosapet, Hyderabad, Telangana 500072', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-07T10:16:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (25, 0, N'Jahnavi ', N'Jahnavi ', 0, NULL, N'Janu', N'1234', N'4564564564', N'Jahnavi@gmail.com', 0, 1, 0, CAST(78.381491 AS Decimal(18, 6)), CAST(17.520322 AS Decimal(18, 6)), N'500090', N'Hyderabad ', NULL, NULL, N'Hyderbad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-07T09:47:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (26, 0, N'John', N'John', 0, NULL, N'John', N'8008', N'8367564277', N'veerababujitthuka7337@gmail.com', 0, 1, 1, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533468', N'Kakinada', NULL, NULL, N'Kakinada', NULL, 0, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-08T06:14:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (27, 26, N'Veerababu', N'J', 0, NULL, N'Veerababu', N'8008', N'9347713415', N'veerababujitthuka7337@gmail.com', 0, 1, 0, CAST(82.230345 AS Decimal(18, 6)), CAST(16.980060 AS Decimal(18, 6)), N'533468', N'Kakinada', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-08T11:54:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (28, 25, N'Satwik', N'K', 0, NULL, N'Satwik', N'8008', N'7729918977', N'veerababujitthuka7337@gmail.com', 0, 1, 0, CAST(82.230342 AS Decimal(18, 6)), CAST(16.980068 AS Decimal(18, 6)), N'533468', N'Kakinada', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-08T12:05:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (29, 25, N'Jeevan', N'B', 0, NULL, N'Jeevan', N'9951', N'9951577568', N'Jeevan@gmail.com', 0, 1, 0, CAST(82.230343 AS Decimal(18, 6)), CAST(16.980075 AS Decimal(18, 6)), N'533007', N'Hyderabad', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-08T12:57:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (30, 26, N'Nandu ', N'M', 0, NULL, N'Nandu', N'1425', N'9392390348', N'nanduangel1012@gmail.com', 0, 1, 0, CAST(82.230292 AS Decimal(18, 6)), CAST(16.980037 AS Decimal(18, 6)), N'533468', N'Kakinada', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-08T13:15:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (31, 0, N'Kolaventi ', N'Satwik', 0, NULL, N'Ramesh', N'1425', N'8008520148', N'satwikroyals101097@gmail.com', 0, 1, 0, CAST(82.230340 AS Decimal(18, 6)), CAST(16.980079 AS Decimal(18, 6)), N'533468', N'Kakinada', NULL, NULL, N'Kakinada', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-10T11:58:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (32, 31, N'John', N'Babu', 0, NULL, N'john john', N'1414', N'1122334556', N'john@mail.com', 0, 1, 0, CAST(82.230336 AS Decimal(18, 6)), CAST(16.980076 AS Decimal(18, 6)), N'553300', N'Find To D Hot Hdurb', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-10T12:01:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (33, 0, N'Firstname12', N'Lastname12', 0, N'qboQsM-14Aug2023024903825.jpg', N'', N'243a', N'4523432216', N'asdwa@g.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'546564', N'', NULL, NULL, N'City', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-14T02:49:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (34, 1, N'Apple', N'Test', 0, N'WsjLRC-14Aug2023061245040.jpg', N'', N'1234', N'2424242424', N'bruce@mac.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'502032', N'Hyderabad', N'', N'', N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-14T05:53:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (35, 20, N'Halvin', N'Halvin', 0, N'BoFA7Y-14Aug2023071309077.jpg', N'Halvin', N'1234', N'2323232333', N'James@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'500090', N'Hyderbad', NULL, NULL, N'', NULL, 0, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-14T08:16:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (37, 1, N'Apple ', N'Sateesh', 0, N'JPX9lp-14Aug2023072637271.jpg', N'', N'1234', N'3636363636', N'', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', N'', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-14T07:27:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (38, 0, N'Ethan', N'Hunt', 0, N'c997420f-27d2-4e2d-9ca8-594eb63039bd.jpg', N'Ethan', N'1234', N'7878787878', N'Ethan@gmail.com', 0, 1, 2, CAST(78.389849 AS Decimal(18, 6)), CAST(17.498535 AS Decimal(18, 6)), N'500090', N'Nizampet Cross Road, Nagarjuna Homes, Kukatpally, Hyderabad, Telangana', NULL, NULL, N'Hyderbad', NULL, 0, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-14T08:34:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (39, 38, N'Joseph', N'Luke', 1, N'24139cc8-c794-4ce4-9bfc-71175ee7e39c.jpg', N'Joseph', N'1234', N'5675675675', N'luke@gmail.com', 0, 1, 2, CAST(78.377854 AS Decimal(18, 6)), CAST(17.519668 AS Decimal(18, 6)), N'500090', N'Nizampet, Hyderabad, Telangana, India', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-14T08:42:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (40, 38, N'Thomas', N'Luke', 1, N'9ed12b14-ba2e-455f-be00-e07b1228109c.jpg', N'Thomas', N'1234', N'5645645644', N'thomas@gmail.com', 0, 1, 2, CAST(78.389849 AS Decimal(18, 6)), CAST(17.498535 AS Decimal(18, 6)), N'500090', N'Nizampet Cross Road, Nagarjuna Homes, Kukatpally, Hyderabad, Telangana', NULL, NULL, NULL, NULL, 0, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-14T08:42:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (41, 38, N'Nolan', N'Nolan', 1, NULL, N'Nolan', N'1234', N'3453345343', N'nolan@gmail.com', 0, 1, 2, CAST(78.388564 AS Decimal(18, 6)), CAST(17.512616 AS Decimal(18, 6)), N'500090', N'Nijampet, Pragathi Nagar, Hyderabad, Telangana, India', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-14T10:23:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (42, 38, N'Jaxon', N'Jaxon', 1, NULL, N'Jaxon', N'1234', N'76767676766', N'Jaxon@gmail.com', 0, 1, 2, CAST(78.389849 AS Decimal(18, 6)), CAST(17.498535 AS Decimal(18, 6)), N'500090', N'Nizampet Cross Road, Nagarjuna Homes, Kukatpally, Hyderabad, Telangana', NULL, NULL, NULL, NULL, 0, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-14T10:26:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (43, 11, N'Test', N'Test', 0, N'y5YPdQ-15Aug2023123507773.jpg', N'', N'2580', N'7995881839', N'test@gmail.com', 0, 1, 0, CAST(78.428298 AS Decimal(18, 6)), CAST(17.533716 AS Decimal(18, 6)), N'2580', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-15T12:35:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (44, 25, N'Charles', N'Nallimelli', 0, N'dykqe5-15Aug2023142211202.jpg', N'', N'1234', N'0405678431', N'cnallimelli@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'4216', N'20 Middle Quay Drive', NULL, NULL, N'Gold coast ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-15T14:22:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (45, 11, N'Test', N'Test', 0, N'38j5wn-15Aug2023151617249.jpg', N'', N'2580', N'9999998553', N'mail2ushabangaru@gmail.com', 0, 1, 0, CAST(78.428251 AS Decimal(18, 6)), CAST(17.533648 AS Decimal(18, 6)), N'852369', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-15T15:16:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (46, 11, N'Test', N'Test', 0, N'JmXlNG-15Aug2023151708138.jpg', N'', N'2580', N'9658674588', N'mail2ushabangaru@gmail.com', 0, 1, 0, CAST(78.423500 AS Decimal(18, 6)), CAST(17.531550 AS Decimal(18, 6)), N'963588', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-15T15:17:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (47, 11, N'Test ', N'Test', 0, N'yU1TvW-15Aug2023154250312.jpg', N'', N'2580', N'9658726586', N'mail2ushabangaru@gmail.com', 0, 1, 0, CAST(78.428232 AS Decimal(18, 6)), CAST(17.533705 AS Decimal(18, 6)), N'985355', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-15T15:43:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (48, 0, N'Test', N'Test', 0, N'uEmcIf-15Aug2023161405574.jpg', N'', N'2580', N'9668875588', N'mail2ushabangaru@gmail.com', 0, 1, 0, CAST(78.428240 AS Decimal(18, 6)), CAST(17.533690 AS Decimal(18, 6)), N'258668', N'Test ', NULL, NULL, N'', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-15T16:14:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (49, 0, N'Test', N'Test', 0, N'xko8Ho-15Aug2023161437125.jpg', N'', N'2580', N'9875688866', N'mail2ushabangaru@gmail.com', 0, 1, 0, CAST(78.428270 AS Decimal(18, 6)), CAST(17.533628 AS Decimal(18, 6)), N'668755', N'Test', NULL, NULL, N'test', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-15T16:15:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (50, 10, N'Sai', N'Kumar', 0, N'Pa6A7h-16Aug2023011745735.jpg', N'', N'1234', N'8686863333', N'saiiii@gmail.com', 0, 1, 0, CAST(78.393425 AS Decimal(18, 6)), CAST(17.449995 AS Decimal(18, 6)), N'500032', N'Hyderabad', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T01:18:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (51, 0, N'Sai', N'Kumar', 0, N'klpQXC-16Aug2023011903413.jpg', N'', N'1234', N'8686864444', N'saiiii@gmail.com', 0, 1, 0, CAST(78.393425 AS Decimal(18, 6)), CAST(17.449995 AS Decimal(18, 6)), N'500003', N'Hyderabad', NULL, NULL, N'hyderabad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T01:19:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (52, 44, N'Jayapaul', N'Nallimelli', 0, N'YOxXMm-16Aug2023014132074.jpg', N'', N'1234', N'0405678432', N'cnallimelli@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533003', N'Ashok Nagar', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T01:42:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (53, 45, N'Saikiran', N'Lanke', 0, N'FXmIgA-16Aug2023023210136.jpg', N'', N'1234', N'8688372323', N'saikiran.lanke@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'521001', N'Machilipatnam', N'batchupeta', N'near Hanuman temple', N'Machilipatnam ', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T02:00:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (54, 55, N'Bodda', N'Vanajakshi', 0, N'wAK92d-16Aug2023025601040.jpg', N'', N'0907', N'9494376801', N'boddavanajakshi@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Berachah Blessing Church', NULL, NULL, N'Kakinada', NULL, NULL, NULL, 0, NULL, 0, NULL, CAST(N'2023-08-16T02:56:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (55, 0, N'Govada', N'Joseph Benny', 0, N'oVuBpI-16Aug2023030743095.jpg', N'', N'0907', N'9848233834', N'berachahblessingchurch@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Berachah Blessing Church', NULL, NULL, N'Kakinada', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T03:08:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (56, 0, N'Charlie', N'Apple', 0, N'wIbCeZ-16Aug2023031029485.jpg', N'', N'1234', N'4747474747', N'', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'', N'', NULL, NULL, N'Hyderabad', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T03:10:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (57, 44, N'Kolaventi ', N'Satwik', 0, N'8opNZ9-16Aug2023034426775.jpg', N'satwik', N'1414', N'7569786659', N'satwikroyals101097@gmail.com', 0, 1, 0, CAST(82.230391 AS Decimal(18, 6)), CAST(16.980043 AS Decimal(18, 6)), N'533003', N'Test', NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T03:44:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (58, 44, N'Bodda', N'Vanajakshi', 0, N'N2Xgbf-16Aug2023034853179.jpg', N'', N'0907', N'8985070806', N'boddavanajakshi@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Berachah Blessing Church', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T03:49:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (59, 44, N'Satwik', N'Kolaventi', 0, N'NRh90C-16Aug2023045040875.jpg', N'', N'1414', N'7799189772', N'satwikroals@mail.com', 0, 1, 0, CAST(82.246386 AS Decimal(18, 6)), CAST(16.990387 AS Decimal(18, 6)), N'533003', N'Test', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T04:51:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (60, 0, N'D SHYAM ', N'KISHORE BABU', 0, N'P2FfjK-16Aug2023051850142.jpg', N'', N'6534', N'8499839993', N'shyamicpfkkd@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Flot No E2, Shanker Towers, Gaigolapadu. Kakinada ', NULL, NULL, N'Kakinada ', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T05:19:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (61, 44, N'Rahul ', N'Paul ', 0, N'kZgtxQ-16Aug2023052718084.jpg', N'', N'9999', N'9492508180', N'rahulpauldevisetty@gmai.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Devisetty Street, Sarpavaram , Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T05:27:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (62, 44, N'DEVISETTY ', N'CHARLES', 0, N'JE817Y-16Aug2023060439561.jpg', N'', N'1234', N'9440697095', N'charlesdevisetti494@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Devisetty Street, Sarpavaram , Kakinad', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T06:05:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (63, 55, N'Sowmya', N'Sumalatha', 0, N'7CyXjG-16Aug2023062239428.jpg', N'', N'2064', N'7337272727', N'sowmyathesweetone@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533434', N'KTC Residencial Campus, Brahmanandapuram, Unduru.', N'', N'', N'Kakinada', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T06:15:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (64, 55, N'S L', N'Raj ', 0, N'hSMmMJ-16Aug2023061446204.jpg', N'', N'5859', N'9494489116', N's.lakshmiraj5859@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T06:15:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (65, 55, N'Lalitha', N'T', 0, N'2U2E1H-16Aug2023062017114.jpg', N'', N'2727', N'9866396668', N'lalithalally74@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'Vakalapudi', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T06:20:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (66, 0, N'Patri', N'Madhukiran', 0, N'Flev1J-16Aug2023062814495.jpg', N'', N'2223', N'9177977407', N'advicmadhu@gmail.com', 0, 1, 0, CAST(82.246464 AS Decimal(18, 6)), CAST(16.990306 AS Decimal(18, 6)), N'533002', N'Mahalaxminagar, Do.62-22-88, ', NULL, NULL, NULL, NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T06:28:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (67, 44, N'Priyanka ', N'Yeluduti', 0, N'zGcLl6-16Aug2023063314951.jpg', N'', N'2308', N'8523059414', N'pyeluduti@gmail.com', 0, 1, 0, CAST(82.246453 AS Decimal(18, 6)), CAST(16.990303 AS Decimal(18, 6)), N'533006', N'Vidyuth Nagar Ideal College ,68-8-15/5C', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T06:33:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (68, 0, N'Gorla', N'Samuel', 0, N'ihHbhL-16Aug2023064959665.jpg', N'', N'2255', N'9676921014', N'gorlasamule123@gmail.com', 0, 1, 0, CAST(82.246461 AS Decimal(18, 6)), CAST(16.990304 AS Decimal(18, 6)), N'533006', N'2-225, Chinna Swamy Nagar ', NULL, NULL, N'kakinada', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T06:50:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (69, 0, N'Vasubabu', N'P', 0, N'jUjcJi-16Aug2023065518801.jpg', N'', N'0099', N'9959496671', N'vasubabuwith@gmail.com', 0, 1, 0, CAST(82.246460 AS Decimal(18, 6)), CAST(16.990306 AS Decimal(18, 6)), N'533003', N'3-16A-79, BURMACOLONY, BEHIND RTC COPLEX, KAKINADA ', NULL, NULL, N'KAKINADA ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T06:55:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (70, 0, N'G Kumarpaul ', N'G Kumarpaul ', 0, N'kZFFq5-16Aug2023065528093.jpg', N'', N'1234', N'9100290799', N'gkpaul5678@gmail.com', 0, 1, 0, CAST(82.245267 AS Decimal(18, 6)), CAST(16.988576 AS Decimal(18, 6)), N'533435', N'J Kothuru Jaggampeta ', NULL, NULL, N'jaggampeta ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T06:55:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (71, 0, N'Georgebob ', N'Satyada ', 0, N'3NxaY4-16Aug2023065913095.jpg', N'', N'1964', N'9908055599', N'revivalsindia@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533435', N'Church', NULL, NULL, N'Rajapudi ', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T06:59:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (72, 0, N'Satti', N'Babu', 0, N'8rTvu7-16Aug2023070050549.jpg', N'', N'9041', N'9989801379', N'sattibabu17039@gmail.com', 0, 1, 0, CAST(82.246418 AS Decimal(18, 6)), CAST(16.990385 AS Decimal(18, 6)), N'533005', N'Block No Ff7', NULL, NULL, N'kakinada ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T07:01:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (73, 0, N'Sudarsan', N'Rao', 0, N'gWiW7Q-16Aug2023070225762.jpg', N'', N'1980', N'9849322930', N'sudarsan.angelshome@gmail.com', 0, 1, 0, CAST(82.245876 AS Decimal(18, 6)), CAST(16.990593 AS Decimal(18, 6)), N'533435', N'Mppp School Street ', NULL, NULL, N'jaggampeta ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T07:02:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (74, 0, N'Joel', N'Madiki', 0, N'Ds5s8o-16Aug2023070227697.jpg', N'', N'2001', N'9849998699', N'joelmadiki@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533450', N'Agraharam', NULL, NULL, N'Pithapuram', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-16T07:02:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (75, 0, N'Moses Kumar ', N'Kundety ', 0, N'TrtMYp-16Aug2023074610238.jpg', N'', N'6688', N'9440336688', N'kunkumer@gmail.com', 0, 1, 0, CAST(82.228982 AS Decimal(18, 6)), CAST(16.931426 AS Decimal(18, 6)), N'533002', N'Jagannaikpur ', NULL, NULL, N'kakinada ', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T07:46:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (76, 75, N'Moses Kumar ', N'Kundety ', 0, N'CxvpLm-16Aug2023075640428.jpg', N'', N'6688', N'9491259299', N'kunkumer@gmail.com', 0, 1, 0, CAST(82.229026 AS Decimal(18, 6)), CAST(16.931420 AS Decimal(18, 6)), N'533002', N'Jagannaikpur Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T07:57:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (77, 55, N'Peddapudi', N'Raju', 0, N'qtzOgq-16Aug2023081152538.jpg', N'', N'9949', N'9949565847', N'joshuaraju.p@gmail.com', 0, 1, 0, CAST(82.250388 AS Decimal(18, 6)), CAST(16.953836 AS Decimal(18, 6)), N'533001', N'D.No.17-2-59/90A, Nookalamma Manyam, Dairy Form, Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T08:12:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (78, 55, N'Joshua', N'Raju', 0, N'yAVyFF-16Aug2023115742888.jpg', N'', N'5847', N'8309074708', N'joshuaraju9949@gmail.com', 0, 1, 0, CAST(82.250390 AS Decimal(18, 6)), CAST(16.953871 AS Decimal(18, 6)), N'533001', N'17-2-59/90A, Nookalamma Manyam, Dairy Farm Centre, Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T11:58:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (79, 55, N'Hepsiba', N'Peddapudi ', 0, N'CNkL61-16Aug2023120142760.jpg', N'', N'1804', N'7680896357', N'hepsiba4christ18@gmail.com', 0, 1, 0, CAST(82.250395 AS Decimal(18, 6)), CAST(16.953875 AS Decimal(18, 6)), N'533001', N'17-2-59/90A, Nookalamma Manyam, Dairy Farm Center, Kakinada ', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-16T12:02:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (80, 0, N'Rangarao ', N'Sigatapu ', 0, N'YpNqlG-16Aug2023125120270.jpg', N'', N'0000', N'7981027243', N'', 0, 1, 0, CAST(82.255151 AS Decimal(18, 6)), CAST(17.000148 AS Decimal(18, 6)), N'533005', N'Rangaraosigatapu@Gmail.Com', NULL, NULL, N'Kakinada', NULL, NULL, NULL, 2, NULL, 1, NULL, CAST(N'2023-08-16T12:51:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (81, 11, N'Daniel', N'P', 0, N'TJfZl8-17Aug2023035359281.jpg', N'', N'8844', N'9032309509', N'danielperla4567@gmail.com', 0, 1, 0, CAST(82.283062 AS Decimal(18, 6)), CAST(17.016234 AS Decimal(18, 6)), N'4488', N'Suryarao Peta ', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-17T03:54:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (82, 44, N'Surendra Kumar', N'Pydimalla ', 0, N'dvgtJs-17Aug2023063233166.jpg', N'', N'1974', N'8121253532', N'his.sowers@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533435', N'11-145, MPPP School Street, Kakinada Dt., Andhra Pradesh', NULL, NULL, N'Jaggampeta ', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-17T06:33:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (83, 55, N'Seeram Blessy', N'Rose Isaac', 0, N'NEy5AZ-17Aug2023121159232.jpg', N'', N'1997', N'9493103280', N'seeramblessy@gmail.com', 0, 1, 0, CAST(0.000000 AS Decimal(18, 6)), CAST(0.000000 AS Decimal(18, 6)), N'533005', N'69-1-29/12/2 Gaigolupadu Kakinada', NULL, NULL, N'', NULL, NULL, NULL, 0, NULL, 1, NULL, CAST(N'2023-08-17T12:12:00' AS SmallDateTime))
INSERT [dbo].[Member] ([MemberId], [CoordinatorId], [Firstname], [Lastname], [Gender], [ProfilePic], [UserId], [Pin], [Mobile], [EmailId], [LocationId], [CountryId], [StateId], [Longitude], [Latitude], [PostCode], [GeoAddress], [Street], [Suburb], [City], [CommunityBelong], [ReferredById], [MemberInfo], [IsCoordinator], [IsDisclosed], [Status], [OrganisationName], [CreatedDate]) VALUES (84, 44, N'Sundarapalli', N'Sudhakarkumar', 0, N'j4e5d9-18Aug2023035802506.jpg', N'', N'7812', N'9059747812', N'sudhakar.hop@gmail.com', 0, 1, 0, CAST(82.243945 AS Decimal(18, 6)), CAST(16.956729 AS Decimal(18, 6)), N'533001', N'Sambhamurty Nagar.3Rd Street.Dr No 16.35.33 Kakinada.', NULL, NULL, N'', NULL, NULL, NULL, 1, NULL, 1, NULL, CAST(N'2023-08-18T03:58:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Member] OFF
GO
SET IDENTITY_INSERT [dbo].[MemberAreaCoordinator] ON 

INSERT [dbo].[MemberAreaCoordinator] ([MemberAreaId], [MemberId], [AreaCoordinatorId], [Info], [CreatedDate]) VALUES (1, 1, 1, N'Coordinator for the area', NULL)
SET IDENTITY_INSERT [dbo].[MemberAreaCoordinator] OFF
GO
SET IDENTITY_INSERT [dbo].[MemberChatGroups] ON 

INSERT [dbo].[MemberChatGroups] ([CGId], [MemberId], [GroupName], [GroupMembers]) VALUES (1, 2, N'test', N'3,4,4,5,6,7,')
SET IDENTITY_INSERT [dbo].[MemberChatGroups] OFF
GO
SET IDENTITY_INSERT [dbo].[MemberDevices] ON 

INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (2, N'fcqfeFZHRlyhn-ugnW_68Z:APA91bG07MxD0oL-dFNxCinec5ZU31wU0GB6c0EpMGNHnlMo6fbJuVrN1ARrkbbIVlQkO1tM82tPojPzj8j6iRU2ouO6logXldIKdrNAb-3YO_D2ztzjk9Xx9irCEKl4XRUEP8i5VdEh', 4, 1, NULL, CAST(N'2023-08-16T04:14:09.147' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (3, N'ejReuSLgR1WpaqJVr_MeOi:APA91bFXYRiIr6gU2mNV45jhtpz6EmXa94IslX2sQvtFNFmzDydDmKE88BSQ2QAE04NwiqQc6Qt3p7acLIj0-0-WgTeurQO6fUsPsLnUGNE9E6yoIVNGnrl8wCxXJgigNAnfmkHRvirg', 6, 1, NULL, CAST(N'2023-08-07T13:22:44.050' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (4, N'cBBxLYa6Q0K3WB8M6I8GNK:APA91bFDsVvkV3GJ5rOeaDLHSaAT-Hmpdd-5PN0x1VRjGnYO3wAhz8_qFBu0G6NgnRYd5mbBJkepFtlNHwwl9vC8o7k0KfwHvKFXl2GsZNmn3zjsFen_A4DHoAXUK47fP7-HZL2K52KY', 5, 1, NULL, CAST(N'2023-08-14T08:56:00.750' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (5, N'cPtY43GATZ2lBUN78-2SvZ:APA91bGPiiMAJE_-mBhTuvUbE46FtPZnlaP-b7tehfrhcLgX4_NVUudhHB2-9WvaMK48Qt3P5GH5BUFGonl3OZoI28wj24-nlfd9Ox2zba_U7jvHDPi32gFi2Hyb8xz2Gun_L_y1M3OH', 3, 1, NULL, CAST(N'2023-02-09T02:26:23.607' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (6, N'f471992bb26546ace568049f5da4b4f3b76f8974d379dbf886aef0ffffa8e242', 1, 2, NULL, CAST(N'2023-08-16T04:06:22.320' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (7, N'002b821e528cff2e7dfddedd4a456110fc59363f8c66a030edb1247543cc4014', 7, 2, NULL, CAST(N'2023-08-16T04:18:35.120' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (8, N'ctbu7_IlQeWkPwDkF-6I5f:APA91bFoQDya6pfkUIXv8RIgKR1syuLrvUoDnt-9Z8fFrS5qbcvhQa4ioFM-mxMvWZlgxZXzQxGJOA34wEXQFjjRiEvO426oGl8NcOkhbxveNqz48SfBIubAydEyvTJ3yi-56MwJ6ST8', 7, 1, NULL, CAST(N'2023-02-10T09:29:31.200' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (9, N'dttt51-uQ8m9Y8Lni-a1aP:APA91bGwaTwgDIcpB9Uo7U_InLQxA_9_2X4Axkyto83Cj5odO9yBjcAe0tYVzG_4X7EcmkFBJiEjQ_gxYJhMioMR20W70lceln74UfByWm5sSyf2PzulbLUtOMMXDI8S4RvUTIMMT6Zf', 1, 1, NULL, CAST(N'2023-08-07T10:28:21.500' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (10, N'002b821e528cff2e7dfddedd4a456110fc59363f8c66a030edb1247543cc4014', 4, 2, NULL, CAST(N'2023-08-16T04:09:51.283' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (11, N'fQPI_GcBRLCuWBaQmp-h8P:APA91bFTexbezZpFiTLZU8Ljv_lVUVI8bdC-O82Z6ef59BGy-QIdocIlh13nwqZZI-TqSFDxrvqT6zoGZ8T8NnnH1IgGF-myGLbic-yErM97uqmEXVJ0E4_62p9UGJd9ksXIppScNyVG', 2, 1, NULL, CAST(N'2023-08-07T13:29:00.397' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (12, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 10, 2, NULL, CAST(N'2023-02-14T09:55:47.290' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (13, N'ca5e97d18d1b65ce8e430a2181c82a6a5c644ae181553c0c5f745a7f51a85a9b', 12, 2, NULL, CAST(N'2023-08-11T10:49:17.993' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (14, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 13, 2, NULL, CAST(N'2023-02-14T10:08:32.110' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (15, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 14, 2, NULL, CAST(N'2023-02-14T10:20:38.547' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (16, N'eg7l49o2TxKT6t_ylcsQe2:APA91bE3pNGQt5BO-HfAXke1HkX17lTOAIxSpVMCOO6sNrKahVxicwMW2vgSFmctYhPWWT6sYWbxatshyV41amUZOFmBh4C-vaADbCXKoBam2sSucXReEAecopG06QPenyesX32fBMdC', 19, 1, NULL, CAST(N'2023-02-15T06:26:31.663' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (17, N'eGvCNVbQSUSe1rNi5Pbta-:APA91bHyAeJivTiy2kowQjjlkdXT9vO8yxKcGSleRPVIKMd42inarZVc7JOpEHqAu4WeQ9CW1CIW3g6HdAM4RhrW0NV003NSbtOFKXLVZwAWH81-xIqFXxpUVgYOsK--VY-HbYi_rZXr', 20, 1, NULL, CAST(N'2023-08-08T06:54:22.193' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (18, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 21, 2, NULL, CAST(N'2023-07-12T06:39:41.927' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (19, N'748277f2504a9a7a438e3b3539ae907f526052d13d1a8a8280b46b6cf7cf86b5', 20, 2, NULL, CAST(N'2023-08-14T07:06:18.327' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (20, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 22, 2, NULL, CAST(N'2023-08-07T08:52:15.047' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (21, N'5124d950034b299c5bd932182ae2d21eed7a7ab9092689386c3ac614da32f347', 23, 2, NULL, CAST(N'2023-08-07T09:24:05.897' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (22, N'eqxYMISXSrO-gPwA7uFHK5:APA91bFticshEzod7SxSB9j23wY_FHO3AXliO2bDnSy4gUWBa_sKLLaY3JQ4Ba86vsEbx6wFHH0v8ucGEscp0HKkMiW-7hQtjwodukO7QqXaFtStaP627ZAZ4FL8R7hLvZYOHMG0ioBL', 24, 1, NULL, CAST(N'2023-08-14T08:16:33.380' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (23, N'eqxYMISXSrO-gPwA7uFHK5:APA91bFticshEzod7SxSB9j23wY_FHO3AXliO2bDnSy4gUWBa_sKLLaY3JQ4Ba86vsEbx6wFHH0v8ucGEscp0HKkMiW-7hQtjwodukO7QqXaFtStaP627ZAZ4FL8R7hLvZYOHMG0ioBL', 22, 1, NULL, CAST(N'2023-08-08T07:05:47.283' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (24, N'eGvCNVbQSUSe1rNi5Pbta-:APA91bHyAeJivTiy2kowQjjlkdXT9vO8yxKcGSleRPVIKMd42inarZVc7JOpEHqAu4WeQ9CW1CIW3g6HdAM4RhrW0NV003NSbtOFKXLVZwAWH81-xIqFXxpUVgYOsK--VY-HbYi_rZXr', 26, 1, NULL, CAST(N'2023-08-08T06:29:21.193' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (25, N'emdi4aZtQF2bPIYY8iQSsK:APA91bFMkNYgnJ7R3YMhotfl48HzlpRwE0r7NpK09iO6q4QFEVAklKP1u70RobtJGS-0Iwxa3rMPYsxRL00JNS2hDdSZ3eCIF09DHNncyOpRVsUsmI1gMohvaYM79t_8PSYJR--Goko0', 27, 1, NULL, CAST(N'2023-08-08T12:03:02.677' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (26, N'fKFuUzzjTXi1x4GKAy1aiV:APA91bHCR_TbdXeL0U-uhr60mWNcBLwy7HInZ9WJT0dqe_Cz7dCbq6CLHpCzP8ELFo-a3QlZtWmUPYgYuWqRt45VtAMx9RHVFD0VyDqWLSiQ95jdgKZDToMJ-kYzYfA4lSe0PI9Dis2W', 28, 1, NULL, CAST(N'2023-08-08T12:05:21.997' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (27, N'emdi4aZtQF2bPIYY8iQSsK:APA91bFMkNYgnJ7R3YMhotfl48HzlpRwE0r7NpK09iO6q4QFEVAklKP1u70RobtJGS-0Iwxa3rMPYsxRL00JNS2hDdSZ3eCIF09DHNncyOpRVsUsmI1gMohvaYM79t_8PSYJR--Goko0', 25, 1, NULL, CAST(N'2023-08-08T12:08:24.047' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (28, N'fKFuUzzjTXi1x4GKAy1aiV:APA91bHCR_TbdXeL0U-uhr60mWNcBLwy7HInZ9WJT0dqe_Cz7dCbq6CLHpCzP8ELFo-a3QlZtWmUPYgYuWqRt45VtAMx9RHVFD0VyDqWLSiQ95jdgKZDToMJ-kYzYfA4lSe0PI9Dis2W', 29, 1, NULL, CAST(N'2023-08-08T12:57:02.393' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (29, N'e8nLfkVFRqKkHUWRgATdxh:APA91bF4WiJZa7orrhfLacVVEujLwFUMEd0oMj7qzM_VrYX1TCLuk5herPiUKXB58iwukkAtazGX7VckoY4f1zfIl5HLDfF828VvnigzJiyfAPtkqBOwU4ejKVOYtl_K-7Tt8xc1Ohn2', 30, 1, NULL, CAST(N'2023-08-08T13:15:23.637' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (30, N'fKFuUzzjTXi1x4GKAy1aiV:APA91bHCR_TbdXeL0U-uhr60mWNcBLwy7HInZ9WJT0dqe_Cz7dCbq6CLHpCzP8ELFo-a3QlZtWmUPYgYuWqRt45VtAMx9RHVFD0VyDqWLSiQ95jdgKZDToMJ-kYzYfA4lSe0PI9Dis2W', 31, 1, NULL, CAST(N'2023-08-10T12:01:40.140' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (31, N'808bdaeea0431b17952af0a1a6075d5ebe3bbb0f62f5171f290c0feeb36bc6f2292d7fe25c3b3511fbd745fa694bc8eb3198257241b51706a64f61a76a65b5e6709fcd500ef538727310c3032ab147ef', 34, 2, NULL, CAST(N'2023-08-14T05:54:25.043' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (32, N'748277f2504a9a7a438e3b3539ae907f526052d13d1a8a8280b46b6cf7cf86b5', 35, 2, NULL, CAST(N'2023-08-14T08:15:50.000' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (33, N'808bdaeea0431b17952af0a1a6075d5ebe3bbb0f62f5171f290c0feeb36bc6f2292d7fe25c3b3511fbd745fa694bc8eb3198257241b51706a64f61a76a65b5e6709fcd500ef538727310c3032ab147ef', 36, 2, NULL, CAST(N'2023-08-14T07:21:13.643' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (34, N'deviceID', 37, 2, NULL, CAST(N'2023-08-14T09:33:48.430' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (35, N'eqxYMISXSrO-gPwA7uFHK5:APA91bFticshEzod7SxSB9j23wY_FHO3AXliO2bDnSy4gUWBa_sKLLaY3JQ4Ba86vsEbx6wFHH0v8ucGEscp0HKkMiW-7hQtjwodukO7QqXaFtStaP627ZAZ4FL8R7hLvZYOHMG0ioBL', 35, 1, NULL, CAST(N'2023-08-14T08:10:36.640' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (36, N'fcqfeFZHRlyhn-ugnW_68Z:APA91bG07MxD0oL-dFNxCinec5ZU31wU0GB6c0EpMGNHnlMo6fbJuVrN1ARrkbbIVlQkO1tM82tPojPzj8j6iRU2ouO6logXldIKdrNAb-3YO_D2ztzjk9Xx9irCEKl4XRUEP8i5VdEh', 40, 1, NULL, CAST(N'2023-08-16T04:22:11.570' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (37, N'002b821e528cff2e7dfddedd4a456110fc59363f8c66a030edb1247543cc4014', 39, 2, NULL, CAST(N'2023-08-16T04:21:47.400' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (38, N'002b821e528cff2e7dfddedd4a456110fc59363f8c66a030edb1247543cc4014', 38, 2, NULL, CAST(N'2023-08-15T06:03:35.650' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (39, N'dFsWCOiuQLajOFnweWH7K5:APA91bHWfFunrDicxglFtb-p23GfIlXn8EhVZvuL0o-yhybZt2v1Vn62U6htNgBY0Nh8yC_AfT_0vwjceCKaXsK_IVqGrGYuur_9Z7EpGVLS_LQDDPVmNoKx5ZVfoo8sNJcdBi8JCnza', 39, 1, NULL, CAST(N'2023-08-14T09:49:37.563' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (40, N'002b821e528cff2e7dfddedd4a456110fc59363f8c66a030edb1247543cc4014', 40, 2, NULL, CAST(N'2023-08-14T09:49:24.883' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (41, N'deviceID', 2, 2, NULL, CAST(N'2023-08-14T09:40:56.630' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (42, N'ejReuSLgR1WpaqJVr_MeOi:APA91bFXYRiIr6gU2mNV45jhtpz6EmXa94IslX2sQvtFNFmzDydDmKE88BSQ2QAE04NwiqQc6Qt3p7acLIj0-0-WgTeurQO6fUsPsLnUGNE9E6yoIVNGnrl8wCxXJgigNAnfmkHRvirg', 38, 1, NULL, CAST(N'2023-08-14T10:28:55.520' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (43, N'ejReuSLgR1WpaqJVr_MeOi:APA91bFXYRiIr6gU2mNV45jhtpz6EmXa94IslX2sQvtFNFmzDydDmKE88BSQ2QAE04NwiqQc6Qt3p7acLIj0-0-WgTeurQO6fUsPsLnUGNE9E6yoIVNGnrl8wCxXJgigNAnfmkHRvirg', 41, 1, NULL, CAST(N'2023-08-14T10:25:13.140' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (44, N'cBBxLYa6Q0K3WB8M6I8GNK:APA91bFDsVvkV3GJ5rOeaDLHSaAT-Hmpdd-5PN0x1VRjGnYO3wAhz8_qFBu0G6NgnRYd5mbBJkepFtlNHwwl9vC8o7k0KfwHvKFXl2GsZNmn3zjsFen_A4DHoAXUK47fP7-HZL2K52KY', 42, 1, NULL, CAST(N'2023-08-15T05:13:34.537' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (45, N'08ef3cd4c54df1a4fa96c66d23a397005af7a27dab31d8bfd16a3996ee41d6e4', 44, 2, NULL, CAST(N'2023-08-16T04:13:42.513' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (46, N'fzBbjsuWSe65hUQ8WSbcL1:APA91bEdGOPG0gQg7XfZmQvdWuU6CHEEbQGQlHd4H4UjGgzNke8KRLNKlB2vnL7uznSjHKlc1Wu2L6AQ25Dv5t5yuN3jKtq7W_InKAOihEZV33hNk40Qpkt5pLmQ3eaKMg_fWdFb7uR7', 50, 1, NULL, CAST(N'2023-08-16T01:17:57.120' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (47, N'fzBbjsuWSe65hUQ8WSbcL1:APA91bEdGOPG0gQg7XfZmQvdWuU6CHEEbQGQlHd4H4UjGgzNke8KRLNKlB2vnL7uznSjHKlc1Wu2L6AQ25Dv5t5yuN3jKtq7W_InKAOihEZV33hNk40Qpkt5pLmQ3eaKMg_fWdFb7uR7', 51, 1, NULL, CAST(N'2023-08-16T01:19:12.010' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (48, N'87960c2cd1ea86d97f967da3c6c9a643f1ef4adb4ccdab613148cd21425792e3', 52, 2, NULL, CAST(N'2023-08-16T01:41:42.737' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (49, N'eHi3NSb8SA6XQA1xSxmECp:APA91bHV0JVfzPnQIDlAHw9kKQad5jA0-BHua1aJaEg1h_mmCEvxlBp12WYJUYvyJei2h9ayn4ouU1_6kVjQD-HfbjwuQRh1vsbxpkuLeuJMrsXCVCwk3rCnC65dILnpkvuD_HC892ni', 53, 1, NULL, CAST(N'2023-08-16T02:05:37.370' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (50, N'dad95817638c92b66d1d0b0c2365b84d463e0f2717f6dead2623c9b424205d10', 54, 2, NULL, CAST(N'2023-08-16T02:56:14.807' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (51, N'7f010792dc96381a6ae3089bafe122bc2145643711d3d514628a689aa19e4345', 55, 2, NULL, CAST(N'2023-08-16T03:45:20.950' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (52, N'ac4317af22da9349ed52f1833b51362488e59207df3ac4b38ab5d027bd1aae69', 58, 2, NULL, CAST(N'2023-08-16T03:49:09.853' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (53, N'ac4317af22da9349ed52f1833b51362488e59207df3ac4b38ab5d027bd1aae69', 59, 2, NULL, CAST(N'2023-08-16T04:50:48.913' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (54, N'98f18777da148005cb0e72d7777984fc7c4bc8f7184734442f5b9b9f6b6aac32', 60, 2, NULL, CAST(N'2023-08-16T05:19:00.407' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (55, N'a869ba74ecca283976b7d49e6068cd4599346a1e6735e1e42b1065ddd73c9f62', 61, 2, NULL, CAST(N'2023-08-16T05:27:24.593' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (56, N'72cc7c3a4b6481596db0ff69ae9778d9ac1869761e1502509dd3e19c7b6c05a8', 62, 2, NULL, CAST(N'2023-08-16T06:04:45.017' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (57, N'3ff25727d542f7ab979ea13b4ae7d4ea9671ab6c2f76c82ba755e72090abd0b5', 64, 2, NULL, CAST(N'2023-08-16T06:14:57.747' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (58, N'514e840c5d2829e594057ac4cd956d5eac0498d8157d66488e5f887cdcfba6ac', 63, 2, NULL, CAST(N'2023-08-16T06:15:14.210' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (59, N'ac25be75dda823e8990ffcaafb4f0ec779d1acc7d433307358076578b9f5c414', 65, 2, NULL, CAST(N'2023-08-16T06:20:40.573' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (60, N'fUzpkFdBQ6mz8_mtCRStLj:APA91bGoGfJFH7I1fRpDxiKQvRa_Xism_2LqWemmxXOWG91AlTXkPBA4rgHfXQ1fROU_BofO9fSLPiRGCyb87PVtJxcNQqAbxWpMyHtuk-xakLpFRCcps2IVY5g4lqP08CRyxRNSy8RT', 68, 1, NULL, CAST(N'2023-08-16T06:53:54.813' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (61, N'eo2ktGjwQxOrWf54CRgYaS:APA91bHIiFhG6Xm8852jBUyL2SHphqJM_I2xMQ0Bgfqi66V6JGDYngZTW-_Q30u635XfYM4aFic7yDGTEQXl98Og_lYOxhAVYEjhXYyiQ6pX8R9AYU1BVG161v8BxjQvNLvByDQ8ycch', 69, 1, NULL, CAST(N'2023-08-16T06:56:05.510' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (62, N'7606f2c0229d7f7fe9d2a0be3871b8b1ff503fd609f80337b4fae06f252c3681', 71, 2, NULL, CAST(N'2023-08-16T06:59:25.037' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (63, N'dT5GONRwRvC4lloQcoQyIC:APA91bHVlrbgd9LUtCeQe3yNBRwjIzzTfcx0zz_rSjgziQ7snn95bIQl95LPIaQfpvVE7pLEBXMsY_5szxh6S7oLSTDRplGIYlXg89QwL8ZtfW6l-Qkw2Cr_bXss3SSamsNp2_LKd5OX', 72, 1, NULL, CAST(N'2023-08-16T07:01:11.843' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (64, N'd3a94138fc36c022683c7b8d0adf37357629d3fafaf43228dedc184102a26651', 74, 2, NULL, CAST(N'2023-08-16T07:02:38.123' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (65, N'321196a48cc4630f1528822ab08853c61db29ba7cec07f3198ef97f822522d3b', 82, 2, NULL, CAST(N'2023-08-17T06:32:46.863' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (66, N'79d6fbb82699210186ad6721c88de97e4ddea55d30c655593e74c1ccbacda51c', 83, 2, NULL, CAST(N'2023-08-17T12:12:06.890' AS DateTime))
INSERT [dbo].[MemberDevices] ([CAppdeviceId], [DeviceId], [MemberId], [DeviceType], [AppId], [CreatedDate]) VALUES (67, N'cRk4a8aNS4q6xQkqYcL02h:APA91bEKu_dhCBhlcko2bf1gWEe4CZolGXGazeaqypP_x3g0SWeA2e0i_VYrpCTbA0KPItc-oZXWCJ77zjzdmfVpEDgW-JSZKyleuOaFZ5VxtELSZUnNz6C6ItrXsXlIoisGqv6CTCHI', 67, 1, NULL, CAST(N'2023-08-17T15:57:55.860' AS DateTime))
SET IDENTITY_INSERT [dbo].[MemberDevices] OFF
GO
SET IDENTITY_INSERT [dbo].[MemberFriends] ON 

INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (1, 59, 34, CAST(N'2021-02-20' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (2, 2, 3, CAST(N'2021-02-20' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (3, 24, 4, CAST(N'2021-02-22' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (4, 24, 2, CAST(N'2021-02-22' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (5, 24, 14, CAST(N'2021-02-22' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (6, 24, 3, CAST(N'2021-02-22' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (7, 24, 16, CAST(N'2021-02-22' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (8, 25, 18, CAST(N'2021-02-25' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (9, 25, 19, CAST(N'2021-02-25' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (10, 25, 21, CAST(N'2021-02-25' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (11, 25, 24, CAST(N'2021-02-25' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (12, 24, 15, CAST(N'2021-02-25' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (13, 34, 0, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (14, 27, 2, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (15, 27, 23, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (16, 27, 29, CAST(N'2021-03-14' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (17, 27, 22, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (18, 27, 20, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (19, 27, 16, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (20, 27, 15, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (21, 27, 14, CAST(N'2021-03-14' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (22, 27, 26, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (23, 27, 28, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (24, 27, 17, CAST(N'2021-03-14' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (25, 14, 29, CAST(N'2021-03-14' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (26, 14, 26, CAST(N'2021-03-14' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (27, 14, 23, CAST(N'2021-03-15' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (28, 14, 22, CAST(N'2021-03-15' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (29, 22, 28, CAST(N'2021-03-16' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (30, 29, 26, CAST(N'2021-03-20' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (31, 34, 32, CAST(N'2021-03-24' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (32, 32, 33, CAST(N'2021-03-29' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (33, 31, 4, CAST(N'2021-04-06' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (34, 31, 3, CAST(N'2021-04-06' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (35, 32, 30, CAST(N'2021-04-07' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (36, 64, 32, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (37, 46, 4, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (38, 47, 8, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (39, 47, 46, CAST(N'2021-04-09' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (40, 47, 37, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (41, 29, 15, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (42, 29, 16, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (43, 29, 23, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (44, 29, 49, CAST(N'2021-04-09' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (45, 38, 3, CAST(N'2021-08-12' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (46, 52, 4, CAST(N'2021-09-06' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (47, 53, 52, CAST(N'2021-09-06' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (48, 60, 62, CAST(N'2021-10-22' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (49, 65, 66, CAST(N'2021-10-22' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (50, 50, 67, CAST(N'2021-11-05' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (51, 74, 77, CAST(N'2021-11-09' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (52, 75, 71, CAST(N'2021-11-09' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (53, 80, 74, CAST(N'2021-11-09' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (54, 74, 81, CAST(N'2021-12-07' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (55, 93, 86, CAST(N'2022-05-06' AS Date), 1)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (56, 126, 63, CAST(N'2022-05-18' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (57, 86, 108, CAST(N'2022-05-18' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (58, 86, 112, CAST(N'2022-05-18' AS Date), 2)
INSERT [dbo].[MemberFriends] ([Id], [MemberId], [FriendMemberId], [AddedDate], [Status]) VALUES (59, 86, 95, CAST(N'2022-05-18' AS Date), 2)
SET IDENTITY_INSERT [dbo].[MemberFriends] OFF
GO
SET IDENTITY_INSERT [dbo].[MemberSOScontacts] ON 

INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (7, 13, N'sai', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2021-02-16T01:47:48.973' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (8, 17, N'sqi', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2021-02-16T03:28:17.250' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (9, 18, N'saikumarbadapatla@gmail.com', N'', N'918686863442', CAST(N'2021-02-16T03:39:06.567' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (10, 19, N'sai', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2021-02-17T02:37:16.407' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (13, 21, N'Sai kumar', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2021-02-17T03:20:05.963' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (14, 14, N'Raj ', N'sat@gmail.com ', N'9874563210 ', CAST(N'2021-02-17T03:33:47.163' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (17, 14, N'sandeep ', N'san@gmail.com ', N'9874563210 ', CAST(N'2021-02-17T03:45:10.443' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (18, 23, N'sathish', N'sat@gmail.com', N'9087654321', CAST(N'2021-02-17T11:56:48.157' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (19, 24, N'sai', N'', N'918686863442', CAST(N'2021-02-18T14:39:30.677' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (20, 25, N'sai', N'saikimar@gmail.com', N'918686863442', CAST(N'2021-02-25T01:15:49.133' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (22, 30, N'Edward  ', N'Edward@gmail.com ', N'8099999060 ', CAST(N'2021-03-16T10:22:27.873' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (25, 31, N'grace matcha ', N'mjsgrace@hotmail.com ', N'0416445760 ', CAST(N'2021-03-24T04:36:52.303' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (26, 32, N'Henry', N'Henry@gmail.com', N'8099999060', CAST(N'2021-03-24T06:00:07.933' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (28, 32, N'nick ', N'nick ', N'5555566666 ', CAST(N'2021-03-29T16:15:51.090' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (34, 31, N'Sobha', N'mjsgrace@hotmail.com', N'0416445760', CAST(N'2021-04-02T02:02:32.803' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (35, 0, N'john doe', N'playstorecnxnew10@gmail.com', N'560067', CAST(N'2021-04-02T17:48:29.410' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (36, 0, N'john doe', N'playstorecnxnew10@gmail.com', N'560067', CAST(N'2021-04-02T17:48:32.197' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (40, 29, N'Sathish', N'', N'919632587410', CAST(N'2021-04-06T07:24:54.660' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (41, 0, N'ravi', N'developer11.kansolve@gmail.com', N'916362289136', CAST(N'2021-04-06T12:10:36.700' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (42, 27, N'test', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2021-04-06T15:48:58.250' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (43, 27, N'tedt', N'saikumarbadapatla@gmail.com', N'918586863442', CAST(N'2021-04-06T16:10:36.193' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (45, 34, N'Edward ', N'', N'9180999999060', CAST(N'2021-04-07T11:39:07.080' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (52, 34, N'Hunter', N'Hunter@gmail.com', N'61789654669', CAST(N'2021-04-07T11:55:14.570' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (58, 57, N'test', N'ghdjdjjd', N'9184946464466', CAST(N'2021-04-07T12:01:47.137' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (59, 57, N'bdhbffjfjdjdjd', N'gdhhdhdjdjd', N'91848464656', CAST(N'2021-04-07T12:02:16.633' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (60, 57, N'hfhdhdjd', N'hdhdhhddjddj', N'91586585589898', CAST(N'2021-04-07T12:02:30.743' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (61, 34, N'Peter', N'peter@gmail.com', N'91545454455454', CAST(N'2021-04-07T12:03:52.760' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (62, 45, N'sat', N'', N'911234567890', CAST(N'2021-04-09T01:16:05.697' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (64, 32, N'rechal ', N'', N'918454557586', CAST(N'2021-04-09T06:41:47.450' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (65, 46, N'Chase Bobby ', N'', N'918099999060', CAST(N'2021-04-09T07:45:11.567' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (66, 47, N'Jessie ', N'', N'917032656730', CAST(N'2021-04-09T08:07:28.193' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (68, 49, N'sat', N'okay@gmai.com', N'9136985214780', CAST(N'2021-04-09T10:02:02.403' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (69, 47, N'chriss', N'', N'86375357357', CAST(N'2021-04-09T12:39:36.897' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (70, 29, N'Sarah', N'', N'919632587410', CAST(N'2021-04-09T12:49:49.180' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (75, 46, N'gary', N'', N'91647747474474', CAST(N'2021-04-12T07:42:40.853' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (79, 29, N'ujjjgjj', N'', N'917867688876', CAST(N'2021-04-26T16:36:25.080' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (80, 50, N'charvik', N'balachander.ch@gmail.com', N'balachander.ch@gmail.com', CAST(N'2021-08-12T09:13:11.993' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (81, 51, N'james', N'james@gmail.com', N'8099999060', CAST(N'2021-08-12T09:23:51.173' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (83, 50, N'charvik', N'balachander.ch@gmail.com', N'balachander.ch@gmail.com', CAST(N'2021-08-12T11:08:08.080' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (84, 53, N'Jannie', N'januporeddy@gmail.com', N'917032656730', CAST(N'2021-09-06T08:46:26.777' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (86, 52, N'James Reed', N'januporeddy@gmail.com', N'918099999060', CAST(N'2021-10-13T11:26:49.640' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (87, 52, N'Harry', N'harry@gmail.com', N'912323232323', CAST(N'2021-10-13T11:27:56.603' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (88, 52, N'William', N'william@gmail.com', N'912525252525', CAST(N'2021-10-13T11:28:40.140' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (89, 5, N'Anil', N'', N'916362289136', CAST(N'2021-10-14T07:51:20.273' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (90, 5, N'Upendra', N'', N'918099999060', CAST(N'2021-10-14T07:51:50.320' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (91, 5, N'Jahnavi', N'', N'917032656730', CAST(N'2021-10-14T07:53:22.927' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (93, 64, N'Jahnavi', N'', N'917032656730', CAST(N'2021-10-18T05:46:41.633' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (94, 64, N'Upendra', N'', N'918099999060', CAST(N'2021-10-18T05:48:28.397' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (95, 64, N'Charles nallimelli', N'', N'61405678430', CAST(N'2021-10-18T11:28:45.900' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (96, 60, N'clark', N'', N'8099999060', CAST(N'2021-10-22T07:03:52.750' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (97, 60, N'test', N'', N'1234567891', CAST(N'2021-10-22T07:05:43.370' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (98, 60, N'test 2', N'', N'2123456789989566', CAST(N'2021-10-22T07:06:47.057' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (102, 70, N'Upendra ', N'', N'918099999060', CAST(N'2021-10-27T09:07:29.960' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (103, 70, N'Charles sir', N'', N'61405678430', CAST(N'2021-10-27T09:11:36.127' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (108, 81, N'Sateesh', N'sateesh08576@gmail.com', N'918686860576', CAST(N'2021-12-06T06:51:49.290' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (116, 73, N'Sathish', N'sathishkumar@gmail.com', N'919966831917', CAST(N'2021-12-07T08:33:39.193' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (117, 73, N'sat', N'sat@gmail.com', N'919966831917', CAST(N'2021-12-07T09:10:41.427' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (122, 81, N'Applicaton Dev', N'testing@icloud.com', N'918686860576', CAST(N'2021-12-13T11:15:00.427' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (123, 72, N'Sateesh Kansolve', N'sateesh576@gmail.com', N'918686860576', CAST(N'2021-12-27T05:01:42.713' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (129, 84, N'Charles Uncle', N'rahulgupthach@gmail.com', N'61405678430', CAST(N'2022-01-12T08:28:24.813' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (131, 84, N'Nav', N'rahul@gmail.com', N'61424704442', CAST(N'2022-01-12T09:04:02.593' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (132, 72, N'Sateesh D', N'bruce576@gmail.com', N'918686860576', CAST(N'2022-01-13T09:46:26.953' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (150, 97, N'Jackson ', N'Jackson@gmail.com', N'8099999060', CAST(N'2022-02-07T07:44:22.570' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (151, 96, N'test', N'', N'2648484', CAST(N'2022-02-10T07:58:33.610' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (152, 93, N'sai', N'saikumarbadapatla@gmail.com', N'918686863442', CAST(N'2022-02-12T05:31:28.707' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (157, 95, N'test', N'', N'8099999060', CAST(N'2022-03-19T10:04:50.550' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (160, 86, N'Sateesh', N'mypersonal.576@gmail.com', N'918686860576', CAST(N'2022-08-02T09:22:09.990' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (163, 147, N'pavan123', N'pavanpeters11@gmail.com', N'9640808054', CAST(N'2023-02-03T05:43:22.880' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (167, 4, N'Henry ', N'henry@gmail.com', N'915656565656', CAST(N'2023-02-10T10:21:00.070' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (168, 26, N'Satwik', N'satwikroyals101097@gmail.com', N'7729918977', CAST(N'2023-08-08T06:39:04.667' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (169, 61, N'Devisetty charles ', N'charlesdevisetti494@gmail.com', N'919440697095', CAST(N'2023-08-16T06:05:33.390' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (170, 62, N'Rahul paul ', N'rahulpauldevisetty@gmail.com', N'919492508180', CAST(N'2023-08-16T06:06:14.263' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (171, 63, N'Lalitha', N'lalithalally74@gmail.com', N'919866396668', CAST(N'2023-08-16T06:16:51.213' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (172, 63, N'Bobby', N'jesuswithpraveen@yahoo.com', N'919866910092', CAST(N'2023-08-16T06:18:24.560' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (173, 63, N'S l raj sagar', N's.lakshmiraj5859@gmail.com', N'919494489116', CAST(N'2023-08-16T06:19:44.387' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (174, 65, N'Sowmya', N'sowmyathesweetone@gmail.com', N'917337272727', CAST(N'2023-08-16T06:22:42.277' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (175, 65, N'Mahesh', N'umamaheshk12@gmail.com', N'919848305949', CAST(N'2023-08-16T06:23:16.870' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (176, 74, N'Abhilash Kumar', N'1@1.in', N'919849700006', CAST(N'2023-08-16T07:12:20.767' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (177, 74, N'Ruth Madiki', N'1@1.in', N'919849989981', CAST(N'2023-08-16T07:12:56.403' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (178, 74, N'T V Cyril', N'1@1.in', N'919849295239', CAST(N'2023-08-16T07:14:00.120' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (179, 82, N'Neelu', N'his.neelu@gmail.com', N'9187900 43685', CAST(N'2023-08-17T06:35:19.613' AS DateTime))
INSERT [dbo].[MemberSOScontacts] ([ContactId], [MemberId], [Name], [EmailId], [Mobile], [CreatedDate]) VALUES (180, 82, N'Sudarshan ', N'sudarsan.angelshome@gmail.com', N'919849322930', CAST(N'2023-08-17T06:45:01.063' AS DateTime))
SET IDENTITY_INSERT [dbo].[MemberSOScontacts] OFF
GO
SET IDENTITY_INSERT [dbo].[NotificationMembers] ON 

INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (1, 1, 42, NULL, 0, NULL)
INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (2, 1, 23, NULL, 1, CAST(N'2021-10-21T08:56:03.520' AS DateTime))
INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (3, 2, 2, NULL, 0, CAST(N'2021-10-20T09:24:35.000' AS DateTime))
INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (4, 2, 3, NULL, 0, CAST(N'2021-10-20T09:24:35.000' AS DateTime))
INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (5, 2, 4, NULL, 0, CAST(N'2021-10-20T09:24:35.003' AS DateTime))
INSERT [dbo].[NotificationMembers] ([Id], [NotificationId], [MemberId], [Response], [IsViewed], [ResponseDate]) VALUES (6, 1, 64, NULL, 1, NULL)
SET IDENTITY_INSERT [dbo].[NotificationMembers] OFF
GO
SET IDENTITY_INSERT [dbo].[Notifications] ON 

INSERT [dbo].[Notifications] ([NotificationId], [CoordinatorId], [MemberId], [Title], [Message], [CreatedDate], [IsActive]) VALUES (1, 59, NULL, N'Test', N'Testing', NULL, 1)
INSERT [dbo].[Notifications] ([NotificationId], [CoordinatorId], [MemberId], [Title], [Message], [CreatedDate], [IsActive]) VALUES (2, 1, NULL, N'test', N'testing', CAST(N'2021-10-20T09:24:35.000' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Notifications] OFF
GO
SET IDENTITY_INSERT [dbo].[Region] ON 

INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (1, N'East Godavari', 1, N'Biggest in population ', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (2, N'West Godavari', 1, N'Biggest in population ', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (3, N'Anatapur', 1, N'Brisbane is the largest city in both the South East Queensland region and the state of Queensland.', CAST(N'2021-02-12T10:19:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (4, N'Prakasam', 1, NULL, CAST(N'2021-11-02T05:56:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (5, N'Medak', 2, NULL, CAST(N'2021-11-02T15:32:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (6, N'Hyderabad ', 2, NULL, CAST(N'2021-11-02T15:39:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (7, N'Nellore', 1, NULL, CAST(N'2021-11-02T15:46:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (8, N'Kurnool', 1, NULL, CAST(N'2021-11-03T08:52:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (9, N'Chittor', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (10, N'Guntur', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (11, N'Kapada', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (12, N'Krishna', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (13, N'Srikakulam', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (14, N'Visakhapatnam', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (15, N'Vizianagaram', 1, NULL, NULL)
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (16, N'Mica Creek', 4, NULL, CAST(N'2022-01-10T10:20:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (17, N'NSW', 8, NULL, CAST(N'2022-01-22T02:23:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (18, N'Canberra', 9, NULL, CAST(N'2022-01-22T02:28:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (19, N'Perth', 10, NULL, CAST(N'2022-01-22T02:30:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (20, N'Adelaide', 11, NULL, CAST(N'2022-01-22T02:42:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (21, N'Panguluru', 1, NULL, CAST(N'2022-01-24T10:33:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (22, N'Ernakulam', 7, NULL, CAST(N'2022-03-11T10:44:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (23, N'QLD', 4, NULL, CAST(N'2022-03-28T02:19:00' AS SmallDateTime))
INSERT [dbo].[Region] ([RegionId], [Region], [StateId], [RegionInfo], [CreatedDate]) VALUES (24, N'QLD', 12, NULL, CAST(N'2022-03-28T02:32:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Region] OFF
GO
SET IDENTITY_INSERT [dbo].[Resource] ON 

INSERT [dbo].[Resource] ([ResourceId], [DocTitle], [ResourceBrief], [ResourceDoc], [CaseStudyId], [VideoUrl], [CreatedDate]) VALUES (3, N'SOS Self-Organization for Survival', N'Introducing fairness in emergency communication to save lives
', N'6b129767-0dff-4bbf-bd5c-25705e910712.pdf', NULL, N'https://www.youtube.com/watch?v=GDa8kZLNhJ4', CAST(N'2021-11-29T07:23:28.530' AS DateTime))
INSERT [dbo].[Resource] ([ResourceId], [DocTitle], [ResourceBrief], [ResourceDoc], [CaseStudyId], [VideoUrl], [CreatedDate]) VALUES (5, N' An Illustrated Guide on COVID Appropriate Behaviour ', N'As you are aware, the COVID 19 pandemic
has led to unprecedented and
unanticipated challenges requiring
collective action and support from all', N'ae72ed0a-1372-4633-b4c1-8c5c695d13ea.pdf', NULL, NULL, CAST(N'2022-01-12T08:43:31.650' AS DateTime))
INSERT [dbo].[Resource] ([ResourceId], [DocTitle], [ResourceBrief], [ResourceDoc], [CaseStudyId], [VideoUrl], [CreatedDate]) VALUES (8, N'First aid Heart attack', N'A heart attack generally causes chest pain for more than 15 minutes. Some people have mild chest pain, while others have more-severe pain. The discomfort is commonly described as a pressure or chest heaviness, although some people have no chest pain or pressure at all. Women tend to have more-vague symptoms, such as nausea or back or jaw pain.', N'a4dc32c0-b062-4467-9ec8-ce41aca720eb.pdf', NULL, NULL, CAST(N'2023-02-01T11:25:02.490' AS DateTime))
INSERT [dbo].[Resource] ([ResourceId], [DocTitle], [ResourceBrief], [ResourceDoc], [CaseStudyId], [VideoUrl], [CreatedDate]) VALUES (9, N'Child protection', N'a completed guide on children trafficking and child safety guidelines', N'6e2da3df-006e-4395-a539-dc77ff33f820.pdf', NULL, NULL, CAST(N'2023-02-03T05:40:36.427' AS DateTime))
SET IDENTITY_INSERT [dbo].[Resource] OFF
GO
SET IDENTITY_INSERT [dbo].[SensitiveFlag] ON 

INSERT [dbo].[SensitiveFlag] ([SensitiveFlagId], [SensitiveFlag]) VALUES (1, N'India')
INSERT [dbo].[SensitiveFlag] ([SensitiveFlagId], [SensitiveFlag]) VALUES (2, N'Australia')
SET IDENTITY_INSERT [dbo].[SensitiveFlag] OFF
GO
SET IDENTITY_INSERT [dbo].[State] ON 

INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (1, N'Andhra Pradesh', 1, N'Telugu State', N'9738727168', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (2, N'Telangana', 1, N'Another Telugu State', NULL, CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (3, N'Victoria', 2, N'Victoria is a state in southeast Australia. It encompasses mountains, national parks, wineries and surfing beaches.', NULL, CAST(N'2021-02-12T10:01:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (4, N'Queensland', 2, N'Queensland is an Australian state covering the continent’s northeast, with a coastline stretching nearly 7,000km.', NULL, CAST(N'2021-02-12T10:05:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (5, N'Karnataka', 1, NULL, NULL, CAST(N'2021-04-09T11:04:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (6, N'Tamil Nadu', 1, NULL, NULL, CAST(N'2021-11-02T05:55:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (7, N'Kerala', 1, NULL, NULL, CAST(N'2022-01-10T06:47:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (8, N'New South Wales', 2, NULL, NULL, CAST(N'2022-01-22T02:22:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (9, N'ACT', 2, NULL, NULL, CAST(N'2022-01-22T02:27:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (10, N'Western Australia', 2, NULL, NULL, CAST(N'2022-01-22T02:30:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (11, N'South Australia', 2, NULL, NULL, CAST(N'2022-01-22T02:41:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (12, N'QLD', 2, NULL, NULL, CAST(N'2022-03-28T02:19:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (13, N'Andhrapradesh', 1, NULL, NULL, CAST(N'2023-02-02T06:16:00' AS SmallDateTime))
INSERT [dbo].[State] ([StateId], [StateName], [CountryId], [StateInfo], [HelpLineNumber], [CreatedDate]) VALUES (14, N'Andrapradesh', 1, NULL, NULL, CAST(N'2023-08-08T06:07:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[State] OFF
GO
SET IDENTITY_INSERT [dbo].[StateCoordinator] ON 

INSERT [dbo].[StateCoordinator] ([StateCoordiantorId], [StateId], [CurrentStateCoordinator], [StateCoordinatorInfo]) VALUES (2, 4, 1, N'Harvey Glen Is a State Coordinator')
SET IDENTITY_INSERT [dbo].[StateCoordinator] OFF
GO
SET IDENTITY_INSERT [dbo].[SupportMessages] ON 

INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (1, 14, N'test', N'test', NULL, CAST(N'2021-04-06T03:05:43.593' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (2, 14, N'test', N'test', NULL, CAST(N'2021-04-06T03:06:03.807' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (3, 27, N'test', N'test', NULL, CAST(N'2021-04-06T03:14:07.747' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (4, 0, N'Support ', N'Message for support ', NULL, CAST(N'2021-04-06T05:53:01.740' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (5, 0, N'Support ', N'Message for support ', NULL, CAST(N'2021-04-06T05:53:14.377' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (6, 29, N'Test', N'Test', NULL, CAST(N'2021-04-06T06:00:25.787' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (7, 0, N'Test', N'Testing', NULL, CAST(N'2021-04-06T07:03:20.090' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (8, 0, N'Test', N'Testing', NULL, CAST(N'2021-04-06T07:03:24.147' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (9, 0, N'Test', N'Testing', NULL, CAST(N'2021-04-06T07:03:37.727' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (10, 29, N'Test', N'Test', NULL, CAST(N'2021-04-06T07:04:55.760' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (11, 29, N'Test	', N'Test', NULL, CAST(N'2021-04-06T07:20:10.110' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (12, 29, N'Test', N'Testing', NULL, CAST(N'2021-04-06T07:35:12.230' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (13, 32, N'Enquiry ', N'Enquiry ', NULL, CAST(N'2021-04-06T08:59:55.630' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (14, 27, N'trst', N'trdt', NULL, CAST(N'2021-04-06T16:03:13.990' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (15, 27, N'test', N'test', NULL, CAST(N'2021-04-06T16:07:12.607' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (16, 0, N'ba', N'hi

', NULL, CAST(N'2021-04-07T05:21:40.687' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (17, 0, N'ba', N'hi

', NULL, CAST(N'2021-04-07T05:21:40.960' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (18, 32, N'enquiry', N'test message test message test message test message test message test message test message test message test message test message test message test message test message test message test message test message test message ', NULL, CAST(N'2021-04-07T06:23:17.450' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (19, 32, N'enquiry', N'test message test message test message test message test message test message test message test message test message test message test ', NULL, CAST(N'2021-04-07T06:25:33.967' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (20, 32, N'', N'test message', NULL, CAST(N'2021-04-07T06:40:59.390' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (21, 0, N'', N'', NULL, CAST(N'2021-04-07T07:18:00.347' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (22, 0, N'bdg', N'ghfgh




', NULL, CAST(N'2021-04-07T07:18:22.350' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (23, 0, N'bdg', N'ghfgh




', NULL, CAST(N'2021-04-07T07:18:29.640' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (24, 32, N'', N'', NULL, CAST(N'2021-04-07T09:43:41.383' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (25, 32, N'', N'', NULL, CAST(N'2021-04-07T09:44:02.977' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (26, 32, N'', N'test', NULL, CAST(N'2021-04-07T09:44:16.787' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (27, 34, N'Text ', N'Test', NULL, CAST(N'2021-04-07T09:46:29.337' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (28, 32, N'test', N'test', NULL, CAST(N'2021-04-07T09:50:56.647' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (29, 32, N'test', N'test', NULL, CAST(N'2021-04-07T09:52:42.373' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (30, 32, N'test', N'test', NULL, CAST(N'2021-04-07T09:52:46.677' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (31, 32, N'test', N'test', NULL, CAST(N'2021-04-07T09:53:31.753' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (32, 0, N'', N'', NULL, CAST(N'2021-04-07T23:22:16.940' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (33, 63, N'Enquiry ', N'Enquiry ', NULL, CAST(N'2021-04-09T06:38:05.467' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (34, 47, N'', N'test', NULL, CAST(N'2021-04-09T12:44:18.313' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (35, 46, N'enquiry', N'test message', NULL, CAST(N'2021-04-12T06:47:26.460' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (36, 46, N'enquiry', N'test message', NULL, CAST(N'2021-04-12T08:12:05.653' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (37, 52, N'emergency', N'need help', NULL, CAST(N'2021-08-12T10:10:42.410' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (38, 0, N'Title', N'Description ', NULL, CAST(N'2021-09-03T07:23:38.070' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (39, 27, N'', N'', NULL, CAST(N'2021-09-14T01:20:23.773' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (40, 50, N'', N'', NULL, CAST(N'2021-11-05T09:21:15.923' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (41, 79, N'', N'', NULL, CAST(N'2021-11-06T07:05:23.097' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (42, 74, N'Campaign ', N'Campaign ', NULL, CAST(N'2021-11-22T06:54:36.523' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (43, 74, N'Enquiry ', N'Enquiry ', NULL, CAST(N'2021-11-22T06:55:18.340' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (44, 74, N'Hi', N'Hi', NULL, CAST(N'2021-11-22T07:26:50.107' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (45, 74, N'te ar t', N'twst', NULL, CAST(N'2021-11-23T01:35:06.010' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (46, 74, N'Hi', N'Hi', NULL, CAST(N'2021-11-23T05:37:56.470' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (47, 74, N'Hi', N'Hi', NULL, CAST(N'2021-11-23T11:04:53.267' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (48, 74, N'Hi hello', N'Hi', NULL, CAST(N'2021-12-07T06:04:25.887' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (49, 74, N'Hi', N'Hi', NULL, CAST(N'2021-12-09T10:10:47.913' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (50, 82, N'Testing', N'No need to verify, this is just testing from an iOS new build.', NULL, CAST(N'2021-12-13T11:34:57.360' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (51, 81, N'Testing', N'No need to verify, this is just testing from an iOS application development. ', NULL, CAST(N'2021-12-14T02:42:43.557' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (52, 81, N'Test', N'This is testing from an iOS', NULL, CAST(N'2022-01-13T06:49:00.250' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (53, 82, N'Enquiry ', N'Enquiry ', NULL, CAST(N'2022-01-13T09:03:06.483' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (54, 84, N'Testing', N'Testing in progress', NULL, CAST(N'2022-01-18T08:52:06.203' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (55, 95, N'Enquiry ', N'Need assistance ', NULL, CAST(N'2022-02-05T06:31:24.290' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (56, 96, N'Enquiry ', N'H', NULL, CAST(N'2022-02-15T11:18:13.547' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (57, 92, N'Hi', N'Testing from android ', NULL, CAST(N'2022-06-20T09:54:56.490' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (58, 92, N'', N'', NULL, CAST(N'2022-07-27T09:59:26.083' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (59, 63, N'Test', N'Testing', NULL, CAST(N'2022-08-08T04:32:51.607' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (60, 63, N'Test', N'Test', NULL, CAST(N'2022-08-12T06:38:59.477' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (61, 0, NULL, N'test', NULL, CAST(N'2022-09-04T01:49:03.340' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (62, 133, N'testing message ', N'testing message ', NULL, CAST(N'2022-09-06T11:26:02.640' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (63, 150, N'Need help', N'Testing message from ios', NULL, CAST(N'2023-02-03T10:22:46.327' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (64, 150, N'need help', N'testing message from Android ', NULL, CAST(N'2023-02-03T10:22:51.093' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (65, 148, N'Test', N'Test_101', NULL, CAST(N'2023-02-04T17:58:25.763' AS DateTime))
INSERT [dbo].[SupportMessages] ([SupportId], [MemberId], [Subject], [Message], [HandledBy], [CreatedDate]) VALUES (66, 53, N'hello ', N'testing ', NULL, CAST(N'2023-08-16T02:28:07.727' AS DateTime))
SET IDENTITY_INSERT [dbo].[SupportMessages] OFF
GO
SET IDENTITY_INSERT [dbo].[Town] ON 

INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (1, N'Rajahmundry', 1, N'good town', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (2, N'Kakinada', 1, N'district town', CAST(N'2021-02-08T00:00:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (3, N'Brisbane', 3, N'Brisbane is the capital city of Queensland and located in the south-east corner of the state. Gold Coast. Sunshine Coast.', CAST(N'2021-02-12T10:20:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (4, N'Chennai', 4, NULL, CAST(N'2021-11-02T05:56:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (5, N'Siddipet', 5, NULL, CAST(N'2021-11-02T15:33:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (6, N'Jagathgiri Gutta ', 6, NULL, CAST(N'2021-11-02T15:40:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (7, N'Vikruthamala', 7, NULL, CAST(N'2021-11-02T15:47:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (8, N'Hindupur', 3, NULL, CAST(N'2022-01-08T05:31:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (9, N'Brisbane', 16, NULL, CAST(N'2022-01-10T10:22:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (10, N'Pattikonda', 8, NULL, CAST(N'2022-01-10T10:27:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (11, N'Sydney', 17, NULL, CAST(N'2022-01-22T02:23:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (12, N'Canberra', 18, NULL, CAST(N'2022-01-22T02:28:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (13, N'Perth', 19, NULL, CAST(N'2022-01-22T02:31:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (14, N'Adelaide', 20, NULL, CAST(N'2022-01-22T02:42:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (15, N'Hyderbad', 6, NULL, CAST(N'2022-01-24T10:01:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (16, N'chandaluru', 21, NULL, CAST(N'2022-01-24T10:33:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (17, N'Hanmakonda', 6, NULL, CAST(N'2022-01-24T10:43:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (18, N'Kochi', 22, NULL, CAST(N'2022-03-11T10:44:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (19, N'Brisbane', 23, NULL, CAST(N'2022-03-28T02:20:00' AS SmallDateTime))
INSERT [dbo].[Town] ([TownId], [Town], [RegionId], [TownInfo], [CreatedDate]) VALUES (20, N'Tenali', 10, NULL, CAST(N'2022-08-25T05:58:00' AS SmallDateTime))
SET IDENTITY_INSERT [dbo].[Town] OFF
GO
SET IDENTITY_INSERT [dbo].[TownCoordinator] ON 

INSERT [dbo].[TownCoordinator] ([TownCoordinatorId], [TownId], [CurrentTownCoordinator], [TownCoordinatorInfo]) VALUES (1, 3, 1, NULL)
SET IDENTITY_INSERT [dbo].[TownCoordinator] OFF
GO
ALTER TABLE [dbo].[HelpRespondedVolunteers] ADD  CONSTRAINT [DF_HelpRespondedVolunteers_IsAccepted]  DEFAULT ((0)) FOR [IsAccepted]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_Gender]  DEFAULT ((0)) FOR [Gender]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_LocationId]  DEFAULT ((0)) FOR [LocationId]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_CountryId]  DEFAULT ((1)) FOR [CountryId]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_StateId]  DEFAULT ((0)) FOR [StateId]
GO
ALTER TABLE [dbo].[Member] ADD  CONSTRAINT [DF_Member_IsCoordinator]  DEFAULT ((0)) FOR [IsCoordinator]
GO
ALTER TABLE [dbo].[MemberFriends] ADD  CONSTRAINT [DF_MemberFriends_Status]  DEFAULT ((1)) FOR [Status]
GO
ALTER TABLE [dbo].[Notifications] ADD  CONSTRAINT [DF_Notifications_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
/****** Object:  StoredProcedure [dbo].[AddCoordinatorCampaign]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddCoordinatorCampaign]--AddCoordinatorCampaign 16,63,'test','9c669586-561e-4441-ab68-24dbd84fda00.jpg',0,'2021-11-08 14:25:00.000','2021-11-15 14:25:00.000','Kurnool, Andhra Pradesh, India','15.828126','78.037279','test','test',',66,76'
(
@CampaignId bigint,
@MemberId bigint,
@CampaignTitle nvarchar(100),
@Image nvarchar(100),
@LocationId int,
@StartTime datetime,
@EndTime datetime,
@GeoLocation nvarchar(300),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@CampaignInfo nvarchar(200),
@SpecialInstructions nvarchar(1000),
@ToCids nvarchar(500)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @toidstbl table(Id bigint identity(1,1),ToId bigint)
insert @toidstbl(ToId) (select distinct items from dbo.split(@ToCids,','))
declare @toidscount int=(select count(*) from @toidstbl)
declare @CurrentId bigint=0
declare @Date datetime=getdate()
if(@CampaignId=0)
begin
insert into Campaign(
MemberId,
CampaignTitle,
Image,
LocationId,
StartTime,
EndTime,
GeoLocation,
Latitude,
Longitude,
CampaignInfo,
SpecialInstructions,
CreatedDate
)values(
@MemberId,
@CampaignTitle,
@Image,
@LocationId,
@StartTime,
@EndTime,
@GeoLocation,
@Latitude,
@Longitude,
@CampaignInfo,
@SpecialInstructions,
@Date
)
set @StatusCode=@@Identity
set @StatusMessage='Added Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
else
begin
Update Campaign set
MemberId=@MemberId,
CampaignTitle=@CampaignTitle,
Image=@Image,
LocationId=@LocationId,
StartTime=@StartTime,
EndTime=@EndTime,
GeoLocation=@GeoLocation,
Latitude=@Latitude,
Longitude=@Longitude,
CampaignInfo=@CampaignInfo,
SpecialInstructions=@SpecialInstructions where CampaignId=@CampaignId
set @StatusCode=@CampaignId
set @StatusMessage='Updated Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
while (@CurrentId<@toidscount)
  begin
   set @CurrentId=@CurrentId+1
   declare @ToId bigint=(select ToId from @toidstbl where Id=@CurrentId)
   if not exists(select CampaignMemberId from CampaignMember where CampaignId=@StatusCode and MemberId=@ToId)
   begin
       insert CampaignMember(CampaignId,MemberId,Status,CreatedDate)values(@StatusCode,@ToId,0,getdate())
	   end
  end  
END


GO
/****** Object:  StoredProcedure [dbo].[AddLocation]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddLocation]
(
@TownId bigint,
@Location nvarchar(100),
@Latitude decimal(18,6),
@Longitude decimal(18,6)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
if exists(select Location from Location where Location=@Location and TownId=@TownId)
begin
set @StatusCode=-1
set @StatusMessage='Location Exists in Database.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
return
end
else 
begin
insert into Location(TownId,Location,Latitude,Longitude,CreatedDate)values(@TownId,@Location,@Latitude,@Longitude,getdate())
set @StatusCode=1
set @StatusMessage='Added.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END
GO
/****** Object:  StoredProcedure [dbo].[AddMemberCampaign]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddMemberCampaign]
(
@MemberId bigint,
@CampaignTitle nvarchar(100),
@Image nvarchar(100),
@LocationId int,
@StartTime datetime,
@EndTime datetime,
@GeoLocation nvarchar(300),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@CampaignInfo nvarchar(200),
@SpecialInstructions nvarchar(1000)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @Date datetime=getdate()
insert into Campaign(
MemberId,
CampaignTitle,
Image,
LocationId,
StartTime,
EndTime,
GeoLocation,
Latitude,
Longitude,
CampaignInfo,
SpecialInstructions,
CreatedDate
)values(
@MemberId,
@CampaignTitle,
@Image,
@LocationId,
@StartTime,
@EndTime,
@GeoLocation,
@Latitude,
@Longitude,
@CampaignInfo,
@SpecialInstructions,
@Date
)
set @StatusCode=@@Identity
set @StatusMessage='Added Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
END


GO
/****** Object:  StoredProcedure [dbo].[AddMemberHelpVideos]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddMemberHelpVideos]--AddMemberHelpVideos 1,1,'test.mp4'
(
@HelpId bigint,
@MemberId bigint,
@VideoName nvarchar(500)
)
AS
BEGIN
 
insert into HelpVideos(
HelpId,
VideoName,
CreatedDate
)values(
@HelpId,
@VideoName,
getdate()
)
select @@Identity as VideoId,
		1 as IsSuccess,
		'Videos uploaded successfully.' as ResultMessage

END

GO
/****** Object:  StoredProcedure [dbo].[AddMemberSOS]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddMemberSOS]--AddMemberSOS
(
@MemberId bigint,
@Name nvarchar(100),
@EmailId nvarchar(100),
@Mobile nvarchar(100)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @Count int
set @Count=(select count(MemberId) from MemberSOScontacts where MemberId=@MemberId)
if(@Count>=3)
begin
set @StatusCode=-1
set @StatusMessage='Max 3 Contacts.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
return
end
else
begin
insert into MemberSOScontacts(
MemberId,
Name,
EmailId,
Mobile,
CreatedDate
)values(
@MemberId,
@Name,
@EmailId,
@Mobile,
Getdate()
)
set @StatusCode=@@Identity
set @StatusMessage='Added Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END




GO
/****** Object:  StoredProcedure [dbo].[AddorRemoveGroupMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[AddorRemoveGroupMembers]
(
 @GroupId bigint,
 @GroupMembers nvarchar(max),
 @IsRemove int
)
as
begin
 declare @members nvarchar(max)=(select GroupMembers from MemberChatGroups where CGId=@GroupId)
 if(@IsRemove=0)
 begin
  update MemberChatGroups set GroupMembers=@members+','+@GroupMembers where CGId=@GroupId
 end
 else
 begin
  declare @newgmembers nvarchar(max)=''
  select @newgmembers=@newgmembers+items+',' from dbo.spilt(@members,',') where items not in (select items from dbo.split(@GroupMembers,','))
   update MemberChatGroups set GroupMembers=@newgmembers where CGId=@GroupId
 end
 select 1 as StatusCode,'Successful' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[AddRegion]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddRegion]
(
@StateId bigint,
@Region nvarchar(100)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
if exists(select Region from Region where Region=@Region and StateId=@StateId)
begin
set @StatusCode=-1
set @StatusMessage='Region Exists in Database.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
return
end
else 
begin
insert into Region(StateId,Region,CreatedDate)values(@StateId,@Region,getdate())
set @StatusCode=1
set @StatusMessage='Added.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END
GO
/****** Object:  StoredProcedure [dbo].[AddRemoveMemberFriend]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AddRemoveMemberFriend]--AddRemoveCustomerFriend 59,34,1
	@MemberId bigint,
	@MemberFriendId bigint,
	@Action int,
	@Res bigint=0 output
AS
BEGIN

declare @Date datetime=getdate()

if @Action<>0
begin

if not exists(select id from memberfriends where ((@MemberId in (memberid,friendmemberid)) and (@MemberFriendId in (memberid,friendmemberid))))
begin
insert into MemberFriends(memberid,friendmemberid,addeddate,status)
values(@MemberId,@MemberFriendId,@date,@Action)

--insert into customerfriends(customerid,friendcustomerid,addeddate,status)
--values(@FriendCustomerId,@CustomerId,(select dbo.convertutcdatetime()),1)

end
else 
begin
Update MemberFriends set Status=@Action where ((@MemberId in (memberid,friendmemberid)) and (@MemberFriendId in (memberid,friendmemberid)))
end
end
else if @Action=-1
begin

if not exists(select id from MemberFriends where ((@MemberId in (memberid,friendmemberid)) and (@MemberFriendId in (memberid,friendmemberid))))
begin
insert into MemberFriends(memberid,friendmemberid,addeddate,status)
values(@MemberId,@MemberFriendId,@Date,-1)

end
end
else if @Action=0
begin

delete from MemberFriends where ((@MemberId in (memberid,friendmemberid)) and (@MemberFriendId in (memberid,friendmemberid))) --customerid=@CustomerId and friendcustomerid=@FriendCustomerId
--delete from customerfriends where customerid=@FriendCustomerId and friendcustomerid=@CustomerId
end

SET @Res=1

SELECT @Res
END
GO
/****** Object:  StoredProcedure [dbo].[AddResourceDocument]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddResourceDocument]
(
@ResourceId bigint,
@CaseStudyId nvarchar(100),
@DocTitle nvarchar(100),
@ResourceDoc nvarchar(200),
@ResourceBrief nvarchar(MAX),
@VideoUrl nvarchar(4000)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @Date datetime=getdate()
if(@ResourceId=0)
begin
insert into Resource(
CaseStudyId,
DocTitle,
ResourceDoc,
ResourceBrief,
VideoUrl,
CreatedDate
)values(
@CaseStudyId,
@DocTitle,
@ResourceDoc,
@ResourceBrief,
@VideoUrl,
@Date
)
set @StatusCode=@@IDENTITY
set @StatusMessage='Added Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
else
begin
Update Resource set
CaseStudyId=@CaseStudyId,
DocTitle=@DocTitle,
ResourceDoc=@ResourceDoc,
ResourceBrief=@ResourceBrief,
VideoUrl=@VideoUrl where ResourceId=@ResourceId
set @StatusCode=@ResourceId
set @StatusMessage='Updated Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END
GO
/****** Object:  StoredProcedure [dbo].[AddState]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddState]
(
@CountryId bigint,
@StateName nvarchar(100)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
if exists(select StateName from State where StateName=@StateName and CountryId=@CountryId)
begin
set @StatusCode=-1
set @StatusMessage='State Exists in Database.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
return
end
else 
begin
insert into State(CountryId,StateName,CreatedDate)values(@CountryId,@StateName,getdate())
set @StatusCode=1
set @StatusMessage='Added.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END
GO
/****** Object:  StoredProcedure [dbo].[AddTown]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AddTown]
(
@RegionId bigint,
@Town nvarchar(100)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
if exists(select Town from Town where Town=@Town and RegionId=@RegionId)
begin
set @StatusCode=-1
set @StatusMessage='Town Exists in Database.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
return
end
else 
begin
insert into Town(RegionId,Town,CreatedDate)values(@RegionId,@Town,getdate())
set @StatusCode=1
set @StatusMessage='Added.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
end
END
GO
/****** Object:  StoredProcedure [dbo].[AdminAddCoordinator]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AdminAddCoordinator]--MemberRegister 1,'anil kumar','9738727168','1212','paatilanil@gmail.com','hyderabad','male',''
(
@MemberId bigint,
@CoordinatorId bigint,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@UserId nvarchar(50),
@Pin nvarchar(50),
@LocationId bigint,
@CountryId int,
@StateId int,
@Gender int,
@GeoAddress nvarchar(150),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@CommunityBelong nvarchar(50),
@ReferredById bigint,
@MemberInfo nvarchar(MAX),
@Mobile nvarchar(50),
@EmailId nvarchar(100),
@PostCode nvarchar(100),
@ProfilePic nvarchar(200),
@IsCoordinator int,
@Status int,
@OrganisationName nvarchar(150)
)
AS
BEGIN
 declare @Date datetime=Getdate()
 declare  @StatusCode table(Id bigint,StatusCode int,StatusMessage nvarchar(50))
 --if exists (select MemberId from Member where LocationId=@LocationId and MemberId<>@MemberId)
 --begin
 -- insert @StatusCode(Id,StatusCode,StatusMessage)values(0,-1,'This Location Already Have Coordinator.')
 -- select * from @StatusCode
 -- return
 --end
 if(@MemberId=0)
 begin
insert Member(
CoordinatorId,
FirstName,
LastName,
UserId,
Pin,
LocationId,
CountryId,
StateId,
Gender,
GeoAddress,
Latitude,
Longitude,
CommunityBelong,
ReferredById,
MemberInfo,
Mobile,
EmailId,
PostCode,
ProfilePic,
IsCoordinator,
Status,
OrganisationName,
CreatedDate
)values(
@CoordinatorId,
@FirstName,
@LastName,
@UserId,
@Pin,
@LocationId,
@CountryId,
@StateId,
@Gender,
@GeoAddress,
@Latitude,
@Longitude,
@CommunityBelong,
@ReferredById,
@MemberInfo,
@Mobile,
@EmailId,
@PostCode,
@ProfilePic,
@IsCoordinator,
@Status,
@OrganisationName,
@Date)
declare @id bigint=@@identity
 insert @StatusCode(Id,StatusCode,StatusMessage)values(@id,@id,'Registered Successfully.')
end
else
begin
update Member
set CoordinatorId=@CoordinatorId,
FirstName=@FirstName,
LastName=@LastName,
UserId=@UserId,
Pin=@Pin,
LocationId=@LocationId,
CountryId=@CountryId,
StateId=@StateId,
Gender=@Gender,
GeoAddress=@GeoAddress,
Latitude=@Latitude,
Longitude=@Longitude,
CommunityBelong=@CommunityBelong,
ReferredById=@ReferredById,
MemberInfo=@MemberInfo,
Mobile=@Mobile,
EmailId=@EmailId,
PostCode=@PostCode,
ProfilePic=@ProfilePic,
IsCoordinator=@IsCoordinator,
OrganisationName=@OrganisationName,
Status=@Status,
CreatedDate=@Date where MemberId=@MemberId
 insert @StatusCode(Id,StatusCode,StatusMessage)values(@MemberId,@MemberId,'Updated Successfully.')
end
  select * from @StatusCode
  return
End


--select * from Member
GO
/****** Object:  StoredProcedure [dbo].[AdminGetNotifications]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminGetNotifications]  --AdminGetNotifications 1,1,25,1,'',1
(
@AdminId Bigint,
@CoordinatorId Bigint,
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1
)
AS
BEGIN
	
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='d.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='d.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

 SET @SQLString=N' ROW_NUMBER() over(order by d.CreatedDate desc) as Sno,d.*,COUNT(d.NotificationId) OVER() as TotalRecords 
from Notifications d Where 1=1 '

IF LEN(@CoordinatorId) > 0  AND @CoordinatorId != ''
        SET @SQLString=@SQLString + 'and d.CoordinatorId='+cast(@CoordinatorId as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and d.Title LIKE ''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@CoordinatorId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@CoordinatorId=@CoordinatorId

END
GO
/****** Object:  StoredProcedure [dbo].[AdminGetResources]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[AdminGetResources]  --AdminGetNotifications 1,1,25,1,'',1
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1
)
AS
BEGIN
	
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='d.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='d.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

 SET @SQLString=N' ROW_NUMBER() over(order by d.CreatedDate desc) as Sno,d.*,COUNT(d.ResourceId) OVER() as TotalRecords 
from Resource d Where 1=1 '

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and d.DocTitle LIKE ''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50)'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring

END
GO
/****** Object:  StoredProcedure [dbo].[AssignVolunteerTask]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[AssignVolunteerTask]
(
@HelpId bigint,
@VolunteerIds nvarchar(100)
)
AS
BEGIN
declare @Date datetime=getdate()
declare @StatusCode int
declare @StatusMessage nvarchar(50)
Update Help set VolunteerIds=@VolunteerIds,Status=1 where HelpId=@HelpId 
set @StatusCode=1
set @StatusMessage='Assigned.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
END
GO
/****** Object:  StoredProcedure [dbo].[ChatreplyMessage]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[ChatreplyMessage]
(
 @FromId bigint,
 @ToId bigint,
 @ChatId bigint,
 @MessageText nvarchar(max),
 @Image nvarchar(500),
 @Video nvarchar(500)
)
as
begin
declare @Date datetime=getdate()
 insert ChatMessages(FromCId,ToCId,MessageText,[Image],Video,IsViewed,ChatId,CreatedDate) values(@FromId,@ToId,@MessageText,@Image,@Video,0,@ChatId,@Date)
 update ChatFriends set LastMessageId=@@identity,LastMessageDate=@Date where ChatId=@ChatId
 update ChatMessages set IsViewed=1 where FromCId=@ToId and ToCId=@FromId and IsViewed=0
 select @ChatId as StatusCode,'Message Sent Successful' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[CheckAdminLogin]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[CheckAdminLogin]--CheckAdminLogin 'admin','admin'
(
 @UserName nvarchar(50),
 @Password nvarchar(50)
)
as
begin
 select AdminId,FirstName,LastName,Email,UserName,[Password],Mobile,CreatedDate
  from AdminDetails
  where UserName=@UserName and [Password]=@Password
end
GO
/****** Object:  StoredProcedure [dbo].[CheckCoordinatorLogin]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[CheckCoordinatorLogin]--CheckAdminLogin '0405678430','1234'
(
 @UserName nvarchar(50),
 @Password nvarchar(50)
)
as
begin
 select *
  from Member
  where ((UserId=@UserName and Pin=@Password) or (Mobile=@UserName and Pin=@Password)) and IsCoordinator=2 and status=1
end
GO
/****** Object:  StoredProcedure [dbo].[CheckMemberRegister]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[CheckMemberRegister]--CheckMemberRegister '917032656730','lkgrieutkkl',1
(
@Mobile nvarchar(50),
@DeviceId Nvarchar(max),
@AppType int
)
AS
BEGIN
 declare  @Status table(StatusCode int)
 declare @MemberId bigint
 declare @date datetime=GETUTCDATE()
 select @MemberId=isnull(MemberId,0) from Member
where ((Mobile=@Mobile)) 
if(@MemberId<>0)
 begin
 if exists(select * from MemberDevices where MemberId=@MemberId and DeviceType=@AppType)
begin
update MemberDevices set DeviceId=@DeviceId,CreatedDate=@date  where MemberId=@MemberId and DeviceType=@AppType
end
else
begin
 insert MemberDevices(DeviceId,MemberId,DeviceType,CreatedDate)values(@DeviceId,@MemberId,@AppType,@date)
end
  insert @Status(StatusCode)values(1)
  Select c.MemberId as StatusCode,(case when c.IsCoordinator=1 then 1 else 0 end) as IsVolunteer,m.Mobile as CoordinatorNumber,s.HelpLineNumber from Member c 
inner join Member m on m.MemberId=c.CoordinatorId
left join Location l on l.LocationId=c.LocationId
left join Town t on t.TownId=l.TownId
left join Region r on r.RegionId=t.RegionId
left join State s on s.StateId=r.StateId where c.Mobile=@Mobile
  --select MemberId as StatusCode,(case when IsCoordinator=1 then 1 else 0 end) as IsVolunteer from Member where Mobile=@Mobile
  return
 end
 else
 select 0 as StatusCode,'User Not Exist.' as StatusMessage
 END


 --select * from Member where Mobile='917032656730'

 

 
GO
/****** Object:  StoredProcedure [dbo].[CreateCustomerGroup]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CreateCustomerGroup]
(
 @MemberId bigint,
 @GroupName nvarchar(50),
 @GroupMembers nvarchar(max)
)
as
begin
 insert MemberChatGroups(MemberId,GroupName,GroupMembers)values(@MemberId,@GroupName,@GroupMembers)
 select @@Identity as StatusCode,'Created Successful' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[CreateMemberGroup]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[CreateMemberGroup]
(
 @MemberId bigint,
 @GroupName nvarchar(50),
 @GroupMembers nvarchar(max)
)
as
begin
 insert MemberChatGroups(MemberId,GroupName,GroupMembers)values(@MemberId,@GroupName,@GroupMembers)
 select @@Identity as StatusCode,'Created Successful' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[DeleteDocument]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[DeleteDocument]
(
@ResourceId bigint
)
AS
BEGIN
delete from Resource where ResourceId=@ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteSOScontact]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[DeleteSOScontact]
(
@ContactId bigint
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
delete from MemberSOScontacts where ContactId=@ContactId
set @StatusMessage='Deleted.'
select @StatusMessage as StatusMessage
END
GO
/****** Object:  StoredProcedure [dbo].[GetAdminCampaignList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAdminCampaignList]-- GetAdminCampaignList 10,1,'',1,28
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@MemberId bigint
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='c.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='c.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' c.*,c.GeoLocation as Location,COUNT(c.CampaignId) OVER() as TotalRecords from Campaign c
inner join Member m on m.MemberId=c.MemberId
left outer join Location l on l.LocationId=m.LocationId where (1=1)'

 IF LEN(@MemberId) > 0  AND @MemberId != ''
        SET @SQLString=@SQLString + 'and c.MemberId='+cast(@MemberId as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and c.CampaignTitle LIKE ''%'+@Searchstr+'%''or l.Location LIKE''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@MemberId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@MemberId=@MemberId

END

GO
/****** Object:  StoredProcedure [dbo].[GetAdminCoordinatorList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAdminCoordinatorList]-- GetAdminCoordinatorList 10,1,'',1,0
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@LocationId bigint
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='m.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='m.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' m.*,l.Location,COUNT(m.MemberId) OVER() as TotalRecords from Member m
left outer join Location l on l.LocationId=m.LocationId where m.Status>=0 and m.IsCoordinator=2'

 IF LEN(@LocationId) > 0  AND @LocationId != ''
        SET @SQLString=@SQLString + 'and m.LocationId='+cast(@LocationId as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and m.Firstname LIKE ''%'+@Searchstr+'%''or m.Mobile LIKE''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@LocationId bigint'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@LocationId=@LocationId

END























GO
/****** Object:  StoredProcedure [dbo].[GetAdminddlLocations]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAdminddlLocations]--GetAdminddlLocations 3,8
@TownId bigint,
@MemberId bigint
AS
BEGIN
--if(@MemberId=0)
--begin
select l.LocationId,l.Location as Location,l.TownId from Location L where @TownId in(l.TownId,0) 
--left join Member m on m.LocationId=l.LocationId 
--and l.LocationId not in(select LocationId from Member where IsCoordinator=2)
--end
--else
--begin 
--select l.LocationId,l.Location as Location,l.TownId from Location L
--left join Member m on m.LocationId=l.LocationId where @TownId in(l.TownId,0) and m.MemberId=@MemberId
--UNION ALL
--select l.LocationId,l.Location as Location,l.TownId from Location L
--left join Member m on m.LocationId=l.LocationId where @TownId in(l.TownId,0) and l.LocationId not in(select LocationId from Member where IsCoordinator=2)
 
--end
END





GO
/****** Object:  StoredProcedure [dbo].[GetAdminMembersList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAdminMembersList]-- GetAdminMembersList 10,1,'',1,0,0
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@LocationId bigint,
@Volunteer int
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='m.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='m.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' m.*,l.Location,COUNT(m.MemberId) OVER() as TotalRecords from Member m
left outer join Location l on l.LocationId=m.LocationId where m.Status>=0 '

 IF LEN(@LocationId) > 0  AND @LocationId != ''
        SET @SQLString=@SQLString + 'and m.CoordinatorId='+cast(@LocationId as nvarchar(10))

 IF LEN(@Volunteer) > 0  AND @Volunteer != ''
        SET @SQLString=@SQLString + 'and m.IsCoordinator='+cast(@Volunteer as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and m.Firstname LIKE ''%'+@Searchstr+'%''or m.Mobile LIKE''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@LocationId bigint,@Volunteer int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@LocationId=@LocationId,@Volunteer=@Volunteer

END






















GO
/****** Object:  StoredProcedure [dbo].[GetAllCustomerIds]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAllCustomerIds]-- GetAllCustomerIds 1,1
(
@MemberId bigint
)
AS
BEGIN
SET NOCOUNT ON;
begin
select cd.MemberId from Member cd
where cd.CoordinatorId=@MemberId 
end
end
GO
/****** Object:  StoredProcedure [dbo].[GetAllMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetAllMembers]--GetAllMembers 2,'anil'
(
@MemberId bigint,
@Search nvarchar(50)
)
AS
BEGIN
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 
if(@Search is null)
begin
 set @Search=''
end
SET @SQLString = N'(case when (cf.id is null) then 0 else 1 end) IsFriend,cd.* from member cd
left join memberfriends cf on 
(cd.memberid in (cf.memberid,cf.friendmemberid)) and (@MemberId in (cf.memberid,cf.friendmemberid))
where  isnull(cf.status,0) >-1
and cd.memberid != @MemberId '
 IF LEN(@Search) >0 AND @Search != '' 
        SET @SQLString=@SQLString + 'and (cd.FirstName+cd.LastName) LIKE ''%'+@Search+'%'''
		SET @SQLString=@SQLString +' order by IsFriend desc'
		begin
		set @SQLString='Select '+@SQLString 
		end
		print @SQLString
		SET @ParmDefinition = N'@Search nvarchar(50),@MemberId bigint'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Search=@Search,@MemberId=@MemberId
END

GO
/****** Object:  StoredProcedure [dbo].[GetCampaignById]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCampaignById]--GetCampaignById 11
(
@CampaignId bigint
)
AS
BEGIN
declare @MemberIds nvarchar(50)='';
select @MemberIds=@MemberIds+CAST(MemberId as nvarchar(50))+',' from CampaignMember where CampaignId=@CampaignId
select *,@MemberIds  as ToIds from Campaign where CampaignId=@CampaignId
END
GO
/****** Object:  StoredProcedure [dbo].[GetCampaignddl]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCampaignddl]
(
@CoordinatorId bigint
)
AS
BEGIN
select * from Campaign where MemberId=@CoordinatorId
END
GO
/****** Object:  StoredProcedure [dbo].[GetCampaigns]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCampaigns]--GetCampaigns 74
(
@MemberId bigint
)
AS
BEGIN
select cm.CampaignMemberId,c.*,cm.Status from Campaign c
inner join CampaignMember cm on cm.CampaignId=c.CampaignId where c.EndTime>getdate() and cm.MemberId=@MemberId and cm.Status=0

select c.*,cm.Status from CampaignMember cm
inner join Campaign c on c.CampaignId=cm.CampaignId where cm.MemberId=@MemberId and cm.Status=1

select c.* from Campaign c where c.EndTime<getdate() and @MemberId in (select MemberId from CampaignMember where CampaignId=c.CampaignId)
END

--select * from CampaignMember








GO
/****** Object:  StoredProcedure [dbo].[GetCampaignSignedMembersList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCampaignSignedMembersList]-- GetCampaignSignedMembersList 10,1,'',1,0
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@CampaignId bigint
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='c.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='c.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' cm.*,c.CampaignTitle,c.GeoLocation as Location,m.FirstName,m.LastName,m.Mobile,COUNT(cm.CampaignMemberId) OVER() as TotalRecords from CampaignMember cm
inner join Member m on m.MemberId=cm.MemberId
inner join Campaign c on c.CampaignId=cm.CampaignId where cm.Status>0 and cm.CampaignId=@CampaignId '

 --IF LEN(@CampaignId) > 0  AND @CampaignId != ''
 --       SET @SQLString=@SQLString + 'and cm.CampaignId='+cast(@CampaignId as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and c.CampaignTitle LIKE ''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@CampaignId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@CampaignId=@CampaignId

END


GO
/****** Object:  StoredProcedure [dbo].[GetChatFriendsList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[GetChatFriendsList]
(
 @MemberId bigint
)
as
begin
 select chf.ChatId,chf.MemberId2 as MemberId,chf.IsGroup,chf.CreatedDate,chf.LastMessageId,chf.LastMessageDate,
 cd.FirstName,cd.LastName,cd.ProfilePic,cm.MessageText,cm.[Image],cm.Video from ChatFriends chf 
 inner join chatmessages cm on cm.MessageId=chf.LastMessageId
 inner join Member cd on cd.MemberId=chf.MemberId2
 where chf.MemberId1=@MemberId
 union 
  select chf.ChatId,chf.MemberId1 as MemberId,chf.IsGroup,chf.CreatedDate,chf.LastMessageId,chf.LastMessageDate,
 cd.FirstName,cd.LastName,cd.ProfilePic,cm.MessageText,cm.[Image],cm.Video from ChatFriends chf 
 inner join chatmessages cm on cm.MessageId=chf.LastMessageId
 inner join Member cd on cd.MemberId=chf.MemberId1
 where chf.MemberId2=@MemberId
 order by LastMessageDate desc
end
GO
/****** Object:  StoredProcedure [dbo].[GetChatMessagesByChatId]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetChatMessagesByChatId]--GetChatMessagesByChatId 4,6,1,-1
(
@MemberId bigint,
@ChatId bigint,
@PageIndex int,
@PageSize int
)
as
begin
 declare @minimumIndex int
  declare  @maximumIndex int
  if(@PageSize=-1)
  begin
   set @minimumIndex=1
   set @maximumIndex=1000
  end
  else
  begin
SET @minimumIndex=(@PageIndex - 1) * @PageSize + 1
SET @maximumIndex=@PageIndex * @PageSize
end
 update ChatMessages set IsViewed=1 where ChatId=@ChatId and ToCid=@MemberId
 select * from 
 (select ROW_NUMBER() OVER (ORDER BY cm.CreatedDate ASC) AS rownum,cm.FromCId as SenderId,cm.ToCId as ReceiverId,cm.MessageId,cm.MessageText,cm.[Image],cm.Video,cm.IsViewed,cm.ChatId,cm.CreatedDate,
  (cdf.FirstName+' '+Isnull(cdf.LastName,'')) as SenderName,cdf.ProfilePic as SenderImage,(cdt.FirstName+' '+isnull(cdt.LastName,'')) as ReceiverName,cdt.ProfilePic  as ReceiverImage,(case when cm.FromCId=@MemberId then 1 else 0 end) as IsSender 
   from ChatMessages cm
			inner join Member cdf on cdf.MemberId=cm.FromCId 
			inner join Member cdt on cdt.MemberId=cm.ToCId where cm.ChatId=@ChatId) as chatmessages
			where rownum >=@minimumIndex and rownum<=@maximumIndex;
end
GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorCampaignMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorCampaignMembers]--GetCoordinatorCampaignMembers 28,7
(
@CoordinatorId bigint,
@CampaignId bigint
)
AS
BEGIN
select a.CampaignMemberTrackingId,a.CampaignId,a.MemberId,a.Latitude,a.Longitude,b.FirstName,b.LastName,b.ProfilePic,c.CampaignTitle 
from CampaignMemberTracking a
inner join Member b on a.MemberId=b.MemberId
left join Campaign c on a.CampaignId=c.CampaignId
where a.CampaignMemberTrackingId in 
(
    select max(CampaignMemberTrackingId) from CampaignMemberTracking 
    group by MemberId
) and a.CampaignId=@CampaignId and c.MemberId=@CoordinatorId
order by b.FirstName
END

--select * from Campaign
--select * from CampaignMemberTracking set MemberId=23 where MemberId=24

--select * from Member


GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorDevicesByMemberId]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetCoordinatorDevicesByMemberId]
(
 @MemberId bigint
)
as
begin

declare @coordinatormemberid bigint=0

select @coordinatormemberid=CoordinatorId from member where MemberId=@MemberId

 select * from MemberDevices where MemberId=@coordinatormemberid
end
GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorHelpList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorHelpList]-- GetCoordinatorHelpList 10,1,'',1,1
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@MemberId int
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@Searchstr is null)
begin
 set @Searchstr=''
end

if(@SortBy=1)
begin
 set @Orderbystring='h.CreatedDate desc'
end
if(@SortBy=2)
begin
 set @Orderbystring='h.CreatedDate asc'
end
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' h.*,
(SELECT TOP 1 videoid 
     FROM helpvideos (NOLOCK)
	 Where Helpid=h.helpid 
     ORDER BY createddate) as VideoId,
(SELECT TOP 1 VideoName 
     FROM helpvideos (NOLOCK)
	 Where Helpid=h.helpid 
     ORDER BY createddate) as VideoName,
	 (SELECT TOP 1 ImageId 
     FROM helpimages (NOLOCK)
	 Where Helpid=h.helpid 
     ORDER BY createddate) as IncidentImageId,
(SELECT TOP 1 Imagename 
     FROM helpimages (NOLOCK)
	 Where Helpid=h.helpid 
     ORDER BY createddate) as IncidentImageName,
(m.FirstName+'' ''+m.LastName) as VictimName,m.ProfilePic,m.Mobile,(mr.FirstName+'' ''+mr.LastName) as HelperName,COUNT(h.HelpId) OVER() as TotalRecords from Help h
left join Member m on m.MemberId=h.MemberId
left join Member mr on mr.MemberId=h.RespondId 
where h.Status>=0 '

 IF LEN(@MemberId) > 0  AND @MemberId != ''
        SET @SQLString=@SQLString + 'and h.CoordinatorId='+cast(@MemberId as nvarchar(10))

 IF LEN(@Searchstr) >0 AND @Searchstr != '' 
        SET @SQLString=@SQLString + 'and m.Firstname LIKE ''%'+@Searchstr+'%''or m.Mobile LIKE''%'+@Searchstr+'%'''
				 
		SET @SQLString=@SQLString +'order by '+@Orderbystring

 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString 
end

--print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@MemberId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@MemberId=@MemberId

END
GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorLocationMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorLocationMembers]--GetCoordinatorLocationMembers 28
(
@MemberId bigint
)
AS
BEGIN
select * from Member where LocationId in (select LocationId from Member where MemberId=@MemberId)
END
GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorMembers]--GetCoordinatorMembers 86
(
@MemberId bigint
)
AS
BEGIN
select * from Member where CoordinatorId=@MemberId and status>=0
END


GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorSOSMemebers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorSOSMemebers]--GetCoordinatorSOSMemebers 28
(
@CoordinatorId bigint
)
AS
BEGIN
select m.MemberId,m.FirstName,m.LastName,m.ProfilePic,m.GeoAddress,(l.Location+','+t.Town) as Location,h.* from Help h
inner join Member m on m.MemberId=h.MemberId
left outer join Location l on l.LocationId=m.LocationId
left outer join Town t on t.TownId=l.TownId where h.MemberId=m.MemberId and h.Status=0 order by h.CreatedDate desc

select m.MemberId,m.FirstName,m.LastName,m.ProfilePic,m.GeoAddress,(l.Location+','+t.Town) as Location,h.* from Help h
inner join Member m on m.MemberId=h.MemberId
left outer join Location l on l.LocationId=m.LocationId
left outer join Town t on t.TownId=l.TownId where h.MemberId=m.MemberId and h.Status=1  order by h.CreatedDate desc
END





GO
/****** Object:  StoredProcedure [dbo].[GetCoordinatorVolunteers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetCoordinatorVolunteers]
(
@CoordinatorId bigint
)
AS
BEGIN
select * from Member Where IsCoordinator=1 and LocationId=(select LocationId from Member where MemberId=@CoordinatorId)
END
GO
/****** Object:  StoredProcedure [dbo].[GetDdlCoordinators]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetDdlCoordinators]-- GetDdlCoordinators 1
(
@Status int=1
)
AS
BEGIN

DECLARE @SQLString nvarchar(max); 
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = N' Select MemberId as Id, FirstName+'' ''+LastName as Text,City from Member where IsCoordinator=2'

 IF @Status!=100
 begin
        SET @SQLString=@SQLString + ' and Status=@PStatus'
		end

		 SET @SQLString=@SQLString + ' Order by FirstName '

SET @ParmDefinition = N'@PStatus int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@PStatus=@Status

END























GO
/****** Object:  StoredProcedure [dbo].[GetddlCountries]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetddlCountries]
AS
BEGIN
select * from Country
END
GO
/****** Object:  StoredProcedure [dbo].[GetddlLocations]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetddlLocations]
@TownId bigint
AS
BEGIN
select l.LocationId,l.Location,T.* from Location L
inner join Town t on t.TownId=l.TownId where @TownId in (l.TownId,0)
END
GO
/****** Object:  StoredProcedure [dbo].[GetddlMembers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetddlMembers]
AS
BEGIN
select MemberId,FirstName+' '+LastName as Name from Member 
END
GO
/****** Object:  StoredProcedure [dbo].[GetHelpById]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetHelpById]
(
@HelpId bigint
)
AS
BEGIN
select * from Help where HelpId=@HelpId
END
GO
/****** Object:  StoredProcedure [dbo].[GetHelpRespondedVolunteerDetails]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetHelpRespondedVolunteerDetails] --1,1
(
@HelpId bigint,
@MemberId bigint
)
AS
BEGIN
select hrv.RespondId,hrv.HelpId,hrv.IsAccepted,hrv.RespondDate,m.* from HelpRespondedVolunteers hrv 
inner join Member m on m.Memberid=hrv.MemberId
where hrv.HelpId=@HelpId and hrv.MemberId=@MemberId
END
GO
/****** Object:  StoredProcedure [dbo].[GetHelpSeekingMember]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetHelpSeekingMember]--GetHelpSeekingMember 52
(
@MemberId bigint
)
AS
BEGIN
select top 1 m.MemberId,m.FirstName,m.LastName,m.ProfilePic,m.GeoAddress,l.Location,h.* from Help h
inner join Member m on m.MemberId=h.MemberId
left join Location l on l.LocationId=m.LocationId where h.MemberId=@MemberId order by h.CreatedDate DESC
END 

GO
/****** Object:  StoredProcedure [dbo].[GetHelpSeekingMemberDetails]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetHelpSeekingMemberDetails]--GetHelpSeekingMemberDetails 28
(
@HelpId bigint
)
AS
BEGIN
select h.*, m.MemberId,m.FirstName,m.LastName,m.ProfilePic,m.GeoAddress,(l.Location+','+t.Town) as Location from help h 
inner join member m on m.MemberId=h.MemberId
left outer join Location l on l.LocationId=m.LocationId
left outer join Town t on t.TownId=l.TownId 
where h.helpid=@HelpId

select * from helpimages where helpid=@HelpId

select * from helpvideos where helpid=@HelpId

END





GO
/****** Object:  StoredProcedure [dbo].[GetHelpSentVolunteers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetHelpSentVolunteers]--GetHelpSentVolunteers 197
(
@HelpId bigint
)
AS
BEGIN
declare @Volunteerids nvarchar(max)
select @Volunteerids=volunteerids from help  where helpid=@HelpId
select  *from member where memberid in (select * from dbo.split(@Volunteerids,','))
END

GO
/****** Object:  StoredProcedure [dbo].[GetIncidentNearestVolunteers]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetIncidentNearestVolunteers]--GetIncidentNearestVolunteers 17.520325,78.381462,'533101'
(
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@Postcode nvarchar(50)
)
AS
BEGIN
DECLARE @GEO1 GEOGRAPHY = NULL
SET @geo1= geography::Point(@Latitude, @Longitude, 4326)  
--if exists(select MemberID from Member where PostCode=@Postcode and @Postcode<>'')
--begin


--select top 5 md.*,(c.CountryCode+md.Mobile) as Mobile,LEFT(CONVERT(VARCHAR,
--    (@geo1.STDistance(geography::Point(ISNULL(l.Latitude,0),
--    ISNULL(l.Longitude,0), 4326)))/1000),1)+' Km' as DISTANCE from Member md
--	inner join Location l on l.LocationId=md.LocationId
--	left join Country c on c.CountryId=md.CountryId  where md.IsCoordinator=1 or md.PostCode=@Postcode
--order by [dbo].[geolocationdistancecaluclation]((Case when md.Latitude='0.000000' then l.Latitude else md.Latitude end),(case when md.Longitude='0.000000' then l.Latitude else md.Longitude end),@Latitude,@Longitude)



--end
--else
--begin
select top 10 md.*,(c.CountryCode+md.Mobile) as Mobile,LEFT(CONVERT(VARCHAR,
    (@geo1.STDistance(geography::Point(ISNULL(l.Latitude,0),
    ISNULL(l.Longitude,0), 4326)))/1000),1)+' Km' as DISTANCE from Member md
	left outer join Location l on l.LocationId=md.LocationId
	left join Country c on c.CountryId=md.CountryId  where (md.IsCoordinator=0 or  md.IsCoordinator=1 )
    --(@geo1.STDistance(geography::Point(ISNULL(L.Latitude,0),
    --ISNULL(L.Longitude,0), 4326)))/1000 <= 10
order by [dbo].[geolocationdistancecaluclation]((Case when md.Latitude='0.000000' then l.Latitude else md.Latitude end),(case when md.Longitude='0.000000' then l.Latitude else md.Longitude end),@Latitude,@Longitude)
--end
END



GO
/****** Object:  StoredProcedure [dbo].[GetMemberChatGroups]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberChatGroups]--GetMemberChatGroups 7
(
@MemberId bigint
)
AS
BEGIN
select CGId,MemberId,GroupName,GroupMembers from MemberChatGroups where MemberId=@MemberId or @MemberId in(select items from dbo.split(GroupMembers,','))
END
GO
/****** Object:  StoredProcedure [dbo].[GetMemberDevices]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[GetMemberDevices]
(
 @MemberId bigint
)
as
begin
 select * from MemberDevices where MemberId=@MemberId
end
GO
/****** Object:  StoredProcedure [dbo].[GetMemberFriends]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberFriends]-- GetMemberFriends 2,1,''
(
 @MemberId bigint,
 @Status int,
 @SearchName nvarchar(500)=''
)
AS
BEGIN
	declare @CustId nvarchar(50)
	set @CustId=convert(nvarchar,@MemberId)
declare @Orderbystring nvarchar(500)
declare @DateRange nvarchar(100)

if(@SearchName is null)
begin
 set @SearchName=''
end

DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500); 

SET @SQLString = 'select (case when (cf.memberid=@MemberId) then ''Requested'' else ''Got Friend Request'' end) as RequestStatus,
(case when (cf.memberid=@MemberId) then 1 else 0 end) as Requestsent,cd.* from member cd
 inner join memberfriends cf on cf.status=@Status and
(cd.memberid in (cf.memberid,cf.friendmemberid)) and ('+@CustId+' in (cf.memberid,cf.friendmemberid))
where 1=1 and cd.memberid !='+ @CustId +' '

--(case when (cf.id is null) and cf.Status=1 then 0 else 1 end) IsFriend
IF LEN(@SearchName) >0 AND @SearchName !=''
begin
 set @SQLString=@SQLString+' and (cd.FirstName+cd.LastName) like ''%'+@SearchName+'%'' or cd.mobile like ''%'+@SearchName+'%'') '
end
--begin
--set @SQLString='Select '+@SQLString 
--end

print @SQLString

SET @ParmDefinition = N'@SearchName nvarchar(50),@MemberId int,@Status int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@SearchName=@SearchName,@MemberId=@MemberId,@Status=@Status

END
GO
/****** Object:  StoredProcedure [dbo].[GetMemberGroupMessageList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberGroupMessageList]--GetMemberGroupMessageList -1,1,'',1,14
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@GroupId bigint,
@MemberId bigint
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
if(@Searchstr is null)
begin
 set @Searchstr=''
end
--if(@SortBy=1)
--begin
-- set @Orderbystring='c.CityName desc'
--end
--if(@SortBy=2)
--begin
-- set @Orderbystring='c.CityName asc'
--end
set @Orderbystring='gm.PostedDate desc'
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500);  

SET @SQLString = N'gm.GMSGId,gm.MemberId,gm.Message,gm.PostedDate,gm.ApprovedBy,gm.ApprovedDate,gm.Status,
(select cd1.FirstName+'' ''+cd1.LastName)as SenderName,gm.PostImage,gm.PostVideo,cd1.ProfilePic as MemberImage,
(case when gm.MemberId=@MemberId then 1 else 0 end) as Sender
from GroupMessage  gm
inner join Member cd on cd.MemberId=@MemberId
inner join Member cd1 on cd1.MemberId=gm.MemberId
where  gm.Status>=1 '

  IF LEN(@GroupId) >0  AND @GroupId != ''
        SET @SQLString=@SQLString + 'and gm.CGId='+cast(@GroupId as nvarchar(10))

		SET @SQLString=@SQLString +'order by '+@Orderbystring
--1 as send and 0 as Reciever
 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@MemberId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@MemberId=@MemberId

END



GO
/****** Object:  StoredProcedure [dbo].[GetMemberHelpVideos]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberHelpVideos]--GetMemberHelpVideos 1,1
(
@MemberId bigint,
@HelpId bigint=0
)
AS
BEGIN
IF @HelpId=0
BEGIN
select hv.* from helpvideos hv where HelpId in(select helpid from help where Memberid=@MemberId) order by createddate desc
END
ELSE
BEGIN
select hv.* from helpvideos hv where HelpId =@HelpId order by createddate desc
END
END








GO
/****** Object:  StoredProcedure [dbo].[GetMemberLogin]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetMemberLogin]--GetMemberLogin 'charles','1234','45486748389348387893',1
(
@UserId Nvarchar(500),
@Pin Nvarchar(50),
@DeviceId Nvarchar(max),
@AppType int
)
AS
BEGIN
SET NOCOUNT ON;
declare @MemberId bigint
declare @StatusCode int
declare @StatusMessage nvarchar(20)

declare @date datetime=GETUTCDATE()
select @MemberId=isnull(MemberId,0) from Member
where ((UserId=@UserId and Pin=@Pin and IsCoordinator=2) or (EmailId=@UserId and Pin=@Pin and IsCoordinator=2)) and status=1
if(@MemberId<>0)
begin
if exists(select * from MemberDevices where MemberId=@MemberId and DeviceType=@AppType)
begin
update MemberDevices set DeviceId=@DeviceId,CreatedDate=@date  where MemberId=@MemberId and DeviceType=@AppType
end
else
begin
 insert MemberDevices(DeviceId,MemberId,DeviceType,CreatedDate)values(@DeviceId,@MemberId,@AppType,@date)
end

end
--if(@CustomerId<>0)
--begin
Select c.* from Member c where c.MemberId=@MemberId
--end
--else
--begin
--set @StatusCode=-1
--set @StatusMessage='It seems your username and/or password do not match—please try again.'
--select @StatusCode as StatusCode,@StatusMessage as StatusMessage
--end

END

--select * from Member
GO
/****** Object:  StoredProcedure [dbo].[GetMemberNotifications]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberNotifications]--GetMemberNotifications 1
(
@MemberId bigint
)
AS
BEGIN
select Top 10 (m.FirstName+' '+m.LastName) as FromName,nm.Id,nm.IsViewed,n.* from Notifications n 
left join NotificationMembers nm on nm.NotificationId=n.NotificationId 
left join Member m on m.MemberId=n.CoordinatorId where nm.MemberId=@MemberId and nm.IsViewed<>1 order by CreatedDate DESC
END
GO
/****** Object:  StoredProcedure [dbo].[GetMemberProfile]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberProfile]
(
@MemberId bigint
)
AS
BEGIN
select * from Member where MemberId=@MemberId
END
GO
/****** Object:  StoredProcedure [dbo].[GetMembersByGroupId]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[GetMembersByGroupId]--GetMembersByGroupId 1
(
 @GroupId bigint
)
as
begin
 declare @members nvarchar(max)=(select GroupMembers from MemberChatGroups where CGId=@GroupId)
 select cd.MemberId,cd.EmailId,cd.Mobile,cd.Firstname,cd.Lastname,cd.ProfilePic from Member cd
 where MemberId in(select items from dbo.split(@members,','))
end
GO
/****** Object:  StoredProcedure [dbo].[GetMemberSOSContact]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberSOSContact]--GetMemberSOSContact 2
(
@MemberId bigint
)
AS
BEGIN
declare @TownId int
set @TownId=(select t.TownId from Member m left join Location l on l.LocationId=m.LocationId left join Town t on t.TownId=l.TownId where MemberId=@MemberId)

select * from MemberSOScontacts where MemberId=@MemberId

select m.* from Member m 
inner join Location l on l.LocationId=m.LocationId
left join Town t on t.TownId=l.TownId where t.TownId=@TownId and m.IsCoordinator=3

select * from Member Where IsCoordinator=2 and LocationId=(select LocationId from Member where MemberId=@MemberId)

select * from Member Where IsCoordinator=1 and LocationId=(select LocationId from Member where MemberId=@MemberId)


--LocationId=(select TownId from Town Left join Location l on l.TownId=TownId where MemberId=@MemberId)
--select m.* from TownCoordinator tc
--inner join Member m on m.MemberId=tc.CurrentTownCoordinator
--left join Location l on l.LocationId=m.LocationId 
--left join Town t on t.TownId=l.TownId where l.LocationId=(select LocationId from Member where MemberId=@MemberId)

--select m.* from AreaCoordinator ac
--inner join Member m on m.MemberId=ac.CurrentCoordinator where m.LocationId=(select LocationId from Member where MemberId=@MemberId)
END



GO
/****** Object:  StoredProcedure [dbo].[GetMemberTracking]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberTracking]
(
@MemberId bigint,
@CampaignId bigint
)
AS
BEGIN
select * from CampaignMemberTracking where MemberId=@MemberId and CampaignId=@CampaignId
END
GO
/****** Object:  StoredProcedure [dbo].[GetMemberWallPostMessageList]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetMemberWallPostMessageList]--GetMemberGroupMessageList -1,1,'',1,1,2
(
@PageSize [int]=-1,
@PageIndex [int]=1,
@Searchstr [nvarchar](50)='',
@SortBy [int]=1,
@MemberId bigint
)
AS
BEGIN
declare @Orderbystring nvarchar(500)
if(@Searchstr is null)
begin
 set @Searchstr=''
end
--if(@SortBy=1)
--begin
-- set @Orderbystring='c.CityName desc'
--end
--if(@SortBy=2)
--begin
-- set @Orderbystring='c.CityName asc'
--end
set @Orderbystring='gm.PostedDate desc'
DECLARE @SQLString nvarchar(max);  
DECLARE @ParmDefinition nvarchar(500);  

SET @SQLString = N'gm.GMSGId,gm.MemberId,gm.Message,gm.PostedDate,gm.ApprovedBy,gm.ApprovedDate,gm.Status,
(select cd1.FirstName+'' ''+cd1.LastName)as SenderName,gm.PostImage,gm.PostVideo,cd1.ProfilePic as MemberImage,
(case when gm.MemberId=@MemberId then 1 else 0 end) as Sender
from GroupMessage  gm
inner join Member cd on cd.MemberId=@MemberId
inner join Member cd1 on cd1.MemberId=gm.MemberId
where  gm.Status>=1 and CGId=0'

		SET @SQLString=@SQLString +'order by '+@Orderbystring
--1 as send and 0 as Reciever
 if(@PageSize!=-1)
begin
exec USP_GetPaggingData @PageSize,@PageIndex,@SQLString out
end
else
begin
set @SQLString='Select '+@SQLString
end

print @SQLString

SET @ParmDefinition = N'@Searchstr nvarchar(50),@Orderbystring nvarchar(50),@MemberId int'

EXECUTE sp_executesql @SQLString,@ParmDefinition,@Searchstr=@Searchstr,@Orderbystring=@Orderbystring,@MemberId=@MemberId

END
GO
/****** Object:  StoredProcedure [dbo].[GetRegionddl]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetRegionddl]
@StateId bigint
AS
BEGIN
select * from Region where @StateId in(StateId,0)
end 
GO
/****** Object:  StoredProcedure [dbo].[GetResourceById]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetResourceById]
(
@ResourceId bigint
)
AS
BEGIN
select * from Resource where ResourceId=@ResourceId
END
GO
/****** Object:  StoredProcedure [dbo].[GetResourceDocuments]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetResourceDocuments]
AS
BEGIN
select * from Resource
END
GO
/****** Object:  StoredProcedure [dbo].[GetStateddl]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetStateddl]
@CountryId bigint
AS
BEGIN
select * from State where @CountryId in (CountryId,0)
end 
GO
/****** Object:  StoredProcedure [dbo].[GetTownddl]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetTownddl]
@RegionId bigint
as
begin
select * from Town where @RegionId in (RegionId,0)
end
GO
/****** Object:  StoredProcedure [dbo].[GetUserLogin]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserLogin]--GetUserLogin 'Charles','1234','45486748389348387893',1
(
@UserId Nvarchar(500),
@Pin Nvarchar(50),
@DeviceId Nvarchar(max),
@AppType int
)
AS
BEGIN
SET NOCOUNT ON;
declare @MemberId bigint
declare @StatusCode int
declare @StatusMessage nvarchar(20)

declare @date datetime=GETUTCDATE()
select @MemberId=isnull(MemberId,0) from Member
where ((UserId=@UserId and Pin=@Pin) or (Mobile=@UserId and Pin=@Pin)) and status=1 
if(@MemberId<>0)
begin
if exists(select * from MemberDevices where MemberId=@MemberId and DeviceType=@AppType)
begin
update MemberDevices set DeviceId=@DeviceId,CreatedDate=@date  where MemberId=@MemberId and DeviceType=@AppType
end
else
begin
 insert MemberDevices(DeviceId,MemberId,DeviceType,CreatedDate)values(@DeviceId,@MemberId,@AppType,@date)
end

end
--Select c.* from Member c where c.MemberId=@MemberId

 Select c.*,c.MemberId as StatusCode,(case when c.IsCoordinator=1 then 1 else 0 end) as IsVolunteer,m.Mobile as CoordinatorNumber,s.HelpLineNumber from Member c 
left join Member m on m.MemberId=c.CoordinatorId
left join Location l on l.LocationId=c.LocationId
left join Town t on t.TownId=l.TownId
left join Region r on r.RegionId=t.RegionId
left join State s on s.StateId=r.StateId where c.MemberId=@MemberId
END
GO
/****** Object:  StoredProcedure [dbo].[GetVolunteerTask]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[GetVolunteerTask] --[GetVolunteerTask] 81
(
@MemberId bigint
)
AS
BEGIN
select m.MemberId,m.FirstName,m.LastName,m.ProfilePic,m.GeoAddress,(l.Location+','+t.Town) as Location,h.* from Help h
inner join Member m on m.MemberId=h.MemberId
inner join Location l on l.LocationId=m.LocationId
inner join Town t on t.TownId=l.TownId where h.MemberId=m.MemberId and h.Status=1 and @MemberId in(select items from dbo.split(VolunteerIds,','))
END
GO
/****** Object:  StoredProcedure [dbo].[InactiveMemberFromMobileApp]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InactiveMemberFromMobileApp]
(
@MemberId bigint
)
AS
BEGIN
Update member set status=0 where MemberId=@MemberId
END
GO
/****** Object:  StoredProcedure [dbo].[InsertCampaignMember]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertCampaignMember]
(
@CampaignId bigint,
@MemberId bigint,
@Message nvarchar(200)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @Date datetime=getdate()
Update CampaignMember set Message=@Message,Status=1 where CampaignId=@CampaignId and MemberId=@MemberId
--insert into CampaignMember(
--CampaignId,
--MemberId,
--Message,
--CreatedDate
--)values(
--@CampaignId,
--@MemberId,
--@Message,
--@Date)
set @StatusCode=@@Identity
set @StatusMessage='Signed in Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
END
GO
/****** Object:  StoredProcedure [dbo].[InsertChatNewMessages]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[InsertChatNewMessages]  --InsertChatNewMessages 2,'3',0,0,'text7','',''
(
 @FromCId bigint,
 @ToCids nvarchar(500),
 @IsMultiple int,
 @IsGroup int,
 @MessageText nvarchar(max),
 @Image nvarchar(500),
 @Video nvarchar(500)
)
as
begin
declare @Date datetime=Getdate()
declare @ChatId bigint=0
 if(@IsMultiple=0)
 begin
  
  if exists(select ChatId from ChatFriends where (@FromCId=MemberId1 and @ToCids=MemberId2) or (@FromCId=MemberId2 and @ToCids=MemberId1))
  begin
   select @ChatId=ChatId from ChatFriends where (@FromCId=MemberId1 and @ToCids=MemberId2) or (@FromCId=MemberId2 and @ToCids=MemberId1)
   insert ChatMessages(FromCId,ToCId,MessageText,[Image],Video,IsViewed,ChatId,CreatedDate)values(@fromCId,@ToCids,@MessageText,@Image,@Video,0,@ChatId,@Date)
   update ChatFriends set LastMessageId=@@identity,LastMessageDate=@Date where ChatId=@ChatId
   update ChatMessages set IsViewed=1 where FromCId=@ToCids and ToCId=@FromCId and IsViewed=0
  end
  else
  begin
   insert ChatFriends(MemberId1,MemberId2,IsGroup,CreatedDate,LastMessageId,LastMessageDate)values(@FromCId,@ToCids,0,@Date,0,@Date)
   set @ChatId=@@identity
    insert ChatMessages(FromCId,ToCId,MessageText,[Image],Video,IsViewed,ChatId,CreatedDate)values(@fromCId,@ToCids,@MessageText,@Image,@Video,0,@ChatId,@Date)
	update ChatFriends set LastMessageId=@@identity,LastMessageDate=@Date where ChatId=@ChatId
  end
 end
 else if(@IsMultiple=1 and @IsGroup=0)
 begin
  declare @toidstbl table(Id bigint identity(1,1),ToId bigint)
  insert @toidstbl(ToId) (select distinct items from dbo.split(@ToCids,','))
  declare @toidscount int=(select count(*) from @toidstbl)
  declare @CurrentId bigint=0
  while (@CurrentId<@toidscount)
  begin
   set @CurrentId=@CurrentId+1
   declare @ToId bigint=(select ToId from @toidstbl where Id=@CurrentId)
   
  if exists(select ChatId from ChatFriends where (@FromCId=MemberId1 and @ToId=MemberId2) or (@FromCId=MemberId2 and @ToId=MemberId1))
  begin
   select @ChatId=ChatId from ChatFriends where (@FromCId=MemberId1 and @ToId=MemberId2) or (@FromCId=MemberId2 and @ToId=MemberId1)
   insert ChatMessages(FromCId,ToCId,MessageText,[Image],Video,IsViewed,ChatId,CreatedDate)values(@fromCId,@ToId,@MessageText,@Image,@Video,0,@ChatId,@Date)
   update ChatFriends set LastMessageId=@@identity,LastMessageDate=@Date where ChatId=@ChatId
   update ChatMessages set IsViewed=1 where FromCId=@ToId and ToCId=@FromCId and IsViewed=0
  end
  else
  begin
   insert ChatFriends(MemberId1,MemberId2,IsGroup,CreatedDate,LastMessageId,LastMessageDate)values(@FromCId,@ToId,0,@Date,0,@Date)
   set @ChatId=@@identity
    insert ChatMessages(FromCId,ToCId,MessageText,[Image],Video,IsViewed,ChatId,CreatedDate)values(@FromCId,@ToId,@MessageText,@Image,@Video,0,@ChatId,@Date)
	update ChatFriends set LastMessageId=@@identity,LastMessageDate=@Date where ChatId=@ChatId
  end
  end
 end
 select @ChatId as StatusCode,'Message Sent Successful' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[InsertCoordinatorHelp]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertCoordinatorHelp]--InsertCoordinatorHelp 63,'test','',16.989100,82.247500,502302
(
@MemberId bigint,
@HelpText nvarchar(500),
@Image nvarchar(100),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@PostCode nvarchar(50)
)
AS
BEGIN
declare @HelpId bigint=0
declare @StatusCode int
declare @StatusMessage nvarchar(100)
DECLARE @GEO1 GEOGRAPHY = NULL
SET @geo1= geography::Point(@Latitude, @Longitude, 4326)  
insert into  Help(
MemberId,
CoordinatorId,
Message,
Image,
Latitude,
Longitude,
Status,
PostCode,
CreatedDate
)values(
@MemberId,
@MemberId,
@HelpText,
@Image,
@Latitude,
@Longitude,
0,
@PostCode,
getdate()
)

SET @HelpId=@@Identity
SET @HelpId=ISNULL(@HelpId,0)

if @HelpId>0 and LEN(@Image)>0
begin
insert into helpimages (helpid,imagename,createddate)
values(@HelpId,@Image,getdate())
end

--Return coordinator details.
select @HelpId as HelpId,md.memberid,md.FirstName,md.LastName,md.EmailId,(c.CountryCode+md.Mobile) as Mobile,md.CoordinatorId,md.Longitude,md.Latitude,md.PostCode,md.GeoAddress from Member md
left join Country c on c.CountryId=md.CountryId 
where md.MemberId=@MemberId

END

GO
/****** Object:  StoredProcedure [dbo].[InsertMemberHelp]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertMemberHelp]--InsertMemberHelp 81,'test','',16.989100,82.247500,502302
(
@MemberId bigint,
@HelpText nvarchar(500),
@Image nvarchar(100),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@PostCode nvarchar(50)
)
AS
BEGIN
declare @HelpId bigint=0
declare @StatusCode int
declare @StatusMessage nvarchar(100)
DECLARE @GEO1 GEOGRAPHY = NULL
SET @geo1= geography::Point(@Latitude, @Longitude, 4326)  
insert into  Help(
MemberId,
CoordinatorId,
Message,
Image,
Latitude,
Longitude,
Status,
PostCode,
CreatedDate
)values(
@MemberId,
(select CoordinatorId from Member Where MemberId=@MemberId),
@HelpText,
@Image,
@Latitude,
@Longitude,
0,
@PostCode,
getdate()
)

SET @HelpId=@@Identity
SET @HelpId=ISNULL(@HelpId,0)

if @HelpId>0 and LEN(@Image)>0
begin
insert into helpimages (helpid,imagename,createddate)
values(@HelpId,@Image,getdate())
end

--Return coordinator details.
select @HelpId as HelpId,md.memberid,md.FirstName,md.LastName,md.EmailId,(c.CountryCode+md.Mobile) as Mobile,md.CoordinatorId,md.Longitude,md.Latitude,md.PostCode,md.GeoAddress from Member m
inner join member md on md.MemberId=m.CoordinatorId
left join Country c on c.CountryId=md.CountryId 
where md.IsCoordinator=2 and m.MemberId=@MemberId

--select md.*,LEFT(CONVERT(VARCHAR,
--    (@geo1.STDistance(geography::Point(ISNULL(l.Latitude,0),
--    ISNULL(l.Longitude,0), 4326)))/1000),1)+' Km' as DISTANCE from Member md
--	inner join Member m on m.CoordinatorId=md.MemberId  where md.IsCoordinator=2
--order by [dbo].[geolocationdistancecaluclation](l.Latitude,l.Longitude,@Latitude,@Longitude)
END

GO
/****** Object:  StoredProcedure [dbo].[InsertMemberNotificationResponse]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertMemberNotificationResponse]
(
@Id bigint,
@Response nvarchar(200)
)
as
begin
declare @StatusCode int
Update NotificationMembers set Response=@Response,ResponseDate=getdate() where Id=@Id
set @StatusCode=@Id
select @StatusCode as StatusCode
end
GO
/****** Object:  StoredProcedure [dbo].[InsertMemberSupport]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertMemberSupport]
(
@SupportId bigint,
@MemberId bigint,
@Subject nvarchar(150),
@Message nvarchar(MAX)
)
AS
BEGIN
declare @Date datetime=getdate()
declare @StatusCode int
declare @StatusMessage nvarchar(50)
insert into SupportMessages(
MemberId,
Subject,
Message,
CreatedDate
)values(
@MemberId,
@Subject,
@Message,
@Date
)
set @StatusCode=@@IDENTITY
set @StatusMessage='Message Sent Successfully.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
END
GO
/****** Object:  StoredProcedure [dbo].[InsertNotification]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[InsertNotification]--InsertNotification 0,1,'test','testing',1,'2,3,4'
(
@NotificationId bigint,
@CoordinatorId bigint,
@Title nvarchar(100),
@Message nvarchar(500),
@IsActive int,
@ToCids nvarchar(500)
)
AS
BEGIN 
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @toidstbl table(Id bigint identity(1,1),ToId bigint)
insert @toidstbl(ToId) (select distinct items from dbo.split(@ToCids,','))
declare @toidscount int=(select count(*) from @toidstbl)
declare @CurrentId bigint=0
insert into Notifications(CoordinatorId,Title,Message,IsActive,CreatedDate)values(@CoordinatorId,@Title,@Message,1,getdate())
set @StatusCode=@@IDENTITY
while (@CurrentId<@toidscount)
  begin
   set @CurrentId=@CurrentId+1
   declare @ToId bigint=(select ToId from @toidstbl where Id=@CurrentId)
       insert NotificationMembers(NotificationId,MemberId,IsViewed,ResponseDate)values(@StatusCode,@ToId,0,getdate())
  end  
  set @StatusMessage='sent.'
  select @StatusCode as StatusCode,@StatusMessage as StatusMessage
 END

 
GO
/****** Object:  StoredProcedure [dbo].[MemberRegister]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[MemberRegister]--MemberRegister 1,'anil kumar','9738727168','1212','paatilanil@gmail.com','hyderabad','male',''
(
@MemberId bigint,
@CoordinatorId bigint,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@UserId nvarchar(50),
@Pin nvarchar(50),
@LocationId bigint,
@CountryId int,
@StateId int,
@Gender int,
@GeoAddress nvarchar(150),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@CommunityBelong nvarchar(50),
@ReferredById bigint,
@MemberInfo nvarchar(MAX),
@Mobile nvarchar(50),
@EmailId nvarchar(100),
@PostCode nvarchar(100),
@ProfilePic nvarchar(200)
)
AS
BEGIN
 declare @Date datetime=Getdate()
 declare  @Status table(Id bigint,StatusCode int,StatusMessage nvarchar(50))
 --if exists (select MemberId from Members where Mobile=@Mobile and MemberId<>@MemberId)
 --begin
 -- insert @Status(Id,StatusCode,StatusMessage)values(0,-1,'Mobile Already Exists')
 -- select * from @Status
 -- return
 --end
 -- if exists (select MemberId from Members where Email=@Email and MemberId<>@MemberId)
 --begin
 -- insert @Status(Id,StatusCode,StatusMessage)values(0,-2,'Email Already Exists')
 -- select * from @Status
 -- return
 --end
 if(@MemberId=0)
 begin
insert Member(
CoordinatorId,
FirstName,
LastName,
UserId,
Pin,
LocationId,
CountryId,
StateId,
Gender,
GeoAddress,
Latitude,
Longitude,
CommunityBelong,
ReferredById,
MemberInfo,
Mobile,
EmailId,
PostCode,
ProfilePic,
IsCoordinator,
CreatedDate
)values(
@CoordinatorId,
@FirstName,
@LastName,
@UserId,
@Pin,
@LocationId,
@CountryId,
@StateId,
@Gender,
@GeoAddress,
@Latitude,
@Longitude,
@CommunityBelong,
@ReferredById,
@MemberInfo,
@Mobile,
@EmailId,
@PostCode,
@ProfilePic,
0,
@Date)
declare @id bigint=@@identity
 insert @Status(Id,StatusCode,StatusMessage)values(@id,@id,'Registered Successfully.')
end
if(@ProfilePic='' and @MemberId<>0)
begin
update Member
set CoordinatorId=@CoordinatorId, 
FirstName=@FirstName,
LastName=@LastName,
UserId=@UserId,
Pin=@Pin,
LocationId=@LocationId,
CountryId=@CountryId,
StateId=@StateId,
Gender=@Gender,
GeoAddress=@GeoAddress,
Latitude=@Latitude,
Longitude=@Longitude,
CommunityBelong=@CommunityBelong,
ReferredById=@ReferredById,
MemberInfo=@MemberInfo,
Mobile=@Mobile,
EmailId=@EmailId,
PostCode=@PostCode,
CreatedDate=@Date where MemberId=@MemberId
 insert @Status(Id,StatusCode,StatusMessage)values(@MemberId,@MemberId,'Updated Successfully.')
end
else
begin
update Member
set FirstName=@FirstName,
LastName=@LastName,
UserId=@UserId,
Pin=@Pin,
LocationId=@LocationId,
CountryId=@CountryId,
Gender=@Gender,
GeoAddress=@GeoAddress,
Latitude=@Latitude,
Longitude=@Longitude,
CommunityBelong=@CommunityBelong,
ReferredById=@ReferredById,
MemberInfo=@MemberInfo,
Mobile=@Mobile,
EmailId=@EmailId,
PostCode=@PostCode,
ProfilePic=@ProfilePic,
CreatedDate=@Date where MemberId=@MemberId
 insert @Status(Id,StatusCode,StatusMessage)values(@MemberId,@MemberId,'Updated Successfully.')
end
  select * from @Status
  return
End

GO
/****** Object:  StoredProcedure [dbo].[MemberRegisterMobileApp]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[MemberRegisterMobileApp]--MemberRegisterMobileApp 1,'anil kumar','9738727168','1212','paatilanil@gmail.com','hyderabad','male',''
(
@CoordinatorId bigint,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@UserId nvarchar(50),
@Pin nvarchar(50),
@GeoAddress nvarchar(150),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@Mobile nvarchar(50),
@EmailId nvarchar(100),
@PostCode nvarchar(100),
@MemberType int=0,
@ProfilePic  nvarchar(100),
@City nvarchar(100)
)
AS
BEGIN
 declare @Date datetime=Getdate()
 declare  @Id bigint,@ResultMessage nvarchar(100)
 --if exists (select MemberId from Members where Mobile=@Mobile and MemberId<>@MemberId)
 --begin
 -- insert @Status(Id,StatusCode,StatusMessage)values(0,-1,'Mobile Already Exists')
 -- select * from @Status
 -- return
 --end
 -- if exists (select MemberId from Members where Email=@Email and MemberId<>@MemberId)
 --begin
 -- insert @Status(Id,StatusCode,StatusMessage)values(0,-2,'Email Already Exists')
 -- select * from @Status
 -- return
 --end

 --DECLARE @IsCoordinator int=0

 --IF @MemberType=2
 --SET @IsCoordinator=2
 --ELSE IF @MemberType=0
 --SET @IsCoordinator=0
 -- ELSE IF @MemberType=1
 --SET @IsCoordinator=1

 IF Exists(select MemberId from Member where Mobile=@Mobile)
 BEGIN
  SELECT @Id as Id,'Mobile number already exists.' as Message
 END
 --ELSE IF Exists(select MemberId from Member where UserId=@UserId)
 --BEGIN
 -- SELECT @Id as Id,'Username already exists.' as Message
 --END
 ELSE
 BEGIN
insert Member(
CoordinatorId,
FirstName,
LastName,
UserId,
Pin,
GeoAddress,
Latitude,
Longitude,
Mobile,
EmailId,
PostCode,
IsCoordinator,
Status,
Gender,
CreatedDate,
ProfilePic,
City
)values(
@CoordinatorId,
@FirstName,
@LastName,
@UserId,
@Pin,
@GeoAddress,
@Latitude,
@Longitude,
@Mobile,
@EmailId,
@PostCode,
@MemberType,
1,
0,
@Date
,@ProfilePic
,@City)
SET @id =@@identity
 SELECT @Id as Id,'Registered Successfully.' as Message
 END

End

GO
/****** Object:  StoredProcedure [dbo].[PostMessage]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[PostMessage]--PostMessage 1,1,1,'hello'
(
 @GroupId bigint,
 @MemberId bigint,
 @Message nvarchar(500),
 @PostImage nvarchar(500),
 @PostVideo nvarchar(500)
)
as
begin
 declare @Date datetime
 set @Date=getutcdate();
 declare @Res bigint=0
 declare @StatusMSg nvarchar(100)=''
 insert GroupMessage (CGId,MemberId,Message,PostImage,PostVideo,PostedDate,[Status]) values(@GroupId,@MemberId,@Message,@PostImage,@PostVideo,@Date,1)
 set @Res=@@identity
  set @StatusMsg='Posted Successfully'

  select @Res as StatusCode,@StatusMsg as StatusMessage
 
end
GO
/****** Object:  StoredProcedure [dbo].[RemoveMessage]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[RemoveMessage]--RemoveMessage 1,2
(
 @GMSGId bigint,
 @MemberId bigint
)
as
begin
 declare @Res bigint=0
 declare @StatusMSg nvarchar(100)=''
 declare @Date datetime=getutcdate()
 update GroupMessage set Status=-1,RemovedBy=@MemberId,RemovedDate=@Date where GMSGId=@GMSGId 
  set @Res=1
  set @StatusMsg='Removed Successful'

  select @Res as StatusCode,@StatusMsg as StatusMessage
  
end
GO
/****** Object:  StoredProcedure [dbo].[RescueActionbtn]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[RescueActionbtn]--RescueActionbtn 5,1
(
@HelpId bigint,
@Action int
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
Update Help set Status=@Action where HelpId=@HelpId
set @StatusCode=@HelpId
select MemberId as StatusCode,Latitude,Longitude,PostCode,Message as StatusMessage from Help where HelpId=@HelpId
END





GO
/****** Object:  StoredProcedure [dbo].[RespondHelpByVolunteer]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[RespondHelpByVolunteer]--RespondHelpByVolunteer 5,1,1
(
@HelpId bigint,
@MemberId bigint,
@IsAccepted bit
)
AS
BEGIN
declare @Date datetime=getdate()
declare @RespondId bigint
declare @RespondedMemberId bigint=0
declare @RespondedMemberName nvarchar(200)=''
select @RespondedMemberId=MemberId from help where HelpId=@HelpId and Status=2

SET @RespondedMemberId=ISNULL(@RespondedMemberId,0)
if @RespondedMemberId=0
begin
Update Help set Status=2 where HelpId=@HelpId
insert into HelpRespondedVolunteers (HelpId,MemberId,IsAccepted,RespondDate)
values(@HelpId,@MemberId,@IsAccepted,@Date)
set @RespondId=@@IDENTITY
select @RespondId as RespondId,@RespondedMemberId as RespondedMemberId,@RespondedMemberName as RespondedMemberName,'Accepted.' as Message
END
else
begin
select @RespondedMemberName=firstname+' '+Lastname  from Member where memberid=@RespondedMemberId
select 0 as RespondId,@RespondedMemberId as RespondedMemberId,@RespondedMemberName as RespondedMemberName,'Already volunteer '+@RespondedMemberName+' has accepted.' as Message
end
END
GO
/****** Object:  StoredProcedure [dbo].[SendtoNearestCoordinator]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[SendtoNearestCoordinator]--SendtoNearestCoordinator 16.4956621,80.6542015,'533101'
(
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@Postcode nvarchar(50)
)
AS
BEGIN
DECLARE @GEO1 GEOGRAPHY = NULL
SET @geo1= geography::Point(@Latitude, @Longitude, 4326)  
if exists(select MemberID from Member where PostCode=@Postcode and @Postcode<>'')
begin
select top 5 md.*,(c.CountryCode+md.Mobile) as Mobile,LEFT(CONVERT(VARCHAR,
    (@geo1.STDistance(geography::Point(ISNULL(l.Latitude,0),
    ISNULL(l.Longitude,0), 4326)))/1000),1)+' Km' as DISTANCE from Member md
	inner join Location l on l.LocationId=md.LocationId
	left join Country c on c.CountryId=md.CountryId  where md.IsCoordinator=1 and md.PostCode=@Postcode
order by [dbo].[geolocationdistancecaluclation]((Case when md.Latitude='0.000000' then l.Latitude else md.Latitude end),(case when md.Longitude='0.000000' then l.Latitude else md.Longitude end),@Latitude,@Longitude)
end
else
begin
select top 5 md.*,(c.CountryCode+md.Mobile) as Mobile,LEFT(CONVERT(VARCHAR,
    (@geo1.STDistance(geography::Point(ISNULL(l.Latitude,0),
    ISNULL(l.Longitude,0), 4326)))/1000),1)+' Km' as DISTANCE from Member md
	inner join Location l on l.LocationId=md.LocationId
	left join Country c on c.CountryId=md.CountryId  where md.IsCoordinator=1 
    --(@geo1.STDistance(geography::Point(ISNULL(L.Latitude,0),
    --ISNULL(L.Longitude,0), 4326)))/1000 <= 10
order by [dbo].[geolocationdistancecaluclation]((Case when md.Latitude='0.000000' then l.Latitude else md.Latitude end),(case when md.Longitude='0.000000' then l.Latitude else md.Longitude end),@Latitude,@Longitude)
end
END



GO
/****** Object:  StoredProcedure [dbo].[StartCampaignTracking]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[StartCampaignTracking]--StartCampaignTracking 1,23,'0.000','0.000'
(
@CampaignId bigint,
@MemberId bigint,
@Latitude decimal(18,6),
@Longitude decimal(18,6)
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(50)
declare @Date datetime=getdate()
insert into CampaignMemberTracking(
CampaignId,
MemberId,
Latitude,
Longitude,
CreatedDate
)values(
@CampaignId,
@MemberId,
@Latitude,
@Longitude,
@Date
)
set @StatusCode=@@Identity
set @StatusMessage='Started.'
select @StatusCode as StatusCode,@StatusMessage as StatusMessage
END


GO
/****** Object:  StoredProcedure [dbo].[TestGetAreaCoordinatorByMember]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[TestGetAreaCoordinatorByMember]
(
 @MemberId  int 
)
As
Select  * from Member 
where locationid in ( select locationid from member where memberid =@MemberId)
and IsAreaCoordinator=1
GO
/****** Object:  StoredProcedure [dbo].[UpdateCampaignNotificationCustomerView]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[UpdateCampaignNotificationCustomerView]
(
@Id bigint
)
AS
BEGIN
declare @StatusCode int
Update CampaignMember set Status=1 where CampaignMemberId=@Id
set @StatusCode=@Id
select @StatusCode as StatusCode
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateChatView]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UpdateChatView]
(
 @MemberId bigint,
 @ChatId bigint
)
as
begin
  update ChatMessages set IsViewed=1 where ChatId=@ChatId and ToCid=@MemberId and IsViewed=0
  select 1 as StatusCode,'Updated' as StatusMessage
end
GO
/****** Object:  StoredProcedure [dbo].[UpdateMemberProfileMobileApp]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[UpdateMemberProfileMobileApp]--UpdateProfileMobileApp
(
@MemberId bigint,
@FirstName nvarchar(50),
@LastName nvarchar(50),
@GeoAddress nvarchar(150),
@Latitude decimal(18,6),
@Longitude decimal(18,6),
@Mobile nvarchar(50),
@EmailId nvarchar(100),
@PostCode nvarchar(100),
@Street nvarchar(100),
@Suburb nvarchar(100),
@City nvarchar(100),
@ProfilePicFilename nvarchar(100)
)

AS
BEGIN
 declare @Date datetime=Getdate()
  declare  @Status table(Id bigint,StatusCode int,StatusMessage nvarchar(50))
update Member
set FirstName=@FirstName,
LastName=@LastName,
GeoAddress=@GeoAddress,
Latitude=@Latitude,
Longitude=@Longitude,
Mobile=@Mobile,
EmailId=@EmailId,
PostCode=@PostCode,
Street=@Street,
Suburb=@Suburb,
City=@City,
ProfilePic=@ProfilePicFilename
 where MemberId=@MemberId
  insert @Status(Id,StatusCode,StatusMessage)values(@MemberId,@MemberId,'Updated Successfully.')
  select * from @Status
End

GO
/****** Object:  StoredProcedure [dbo].[UpdateNotificationCustomerView]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[UpdateNotificationCustomerView]
(
@Id bigint
)
AS
BEGIN
declare @StatusCode int
Update NotificationMembers set IsViewed=1 where Id=@Id
set @StatusCode=@Id
select @StatusCode as StatusCode
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPaggingData]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetPaggingData]
(	@PageSize [int],
	@PageIndex [int],
	@Query [nvarchar](max) out
	)
WITH EXECUTE AS CALLER
AS
begin
 declare @Offset int = (@PageIndex -1) * @PageSize 
 declare @LowestRowNumber int = @Offset
 declare @HighestRowNumber int = @Offset + @PageSize 

  set @Query='Select '+@Query+ ' offset '+cast(@LowestRowNumber as nvarchar(50))+' rows fetch next '+cast(@PageSize as nvarchar(50))+' rows only'
end
GO
/****** Object:  StoredProcedure [dbo].[VolunteerRescueActionbtn]    Script Date: 18-08-2023 10:57:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE[dbo].[VolunteerRescueActionbtn]--RescueActionbtn 5,1
(
@HelpId bigint,
@VolunteerId bigint
)
AS
BEGIN
declare @StatusCode int
declare @StatusMessage nvarchar(100)
Update Help set Status=2,RespondId=@VolunteerId where HelpId=@HelpId
set @StatusCode=@HelpId
select @StatusCode as StatusCode
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: not seen,1:seen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CampaignMember', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:AreaVolunteer;2AreaCoordinator;3:TownCoordinator;4:RegionalCoordinator;5:StateCoordinator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Coordinator', @level2type=N'COLUMN',@level2name=N'IsCoordinator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:Latest;1:Noticed;2:Rescued' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Help', @level2type=N'COLUMN',@level2name=N'Status'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1:AreaVolunteer;2AreaCoordinator;3:TownCoordinator;4:RegionalCoordinator;5:StateCoordinator' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Member', @level2type=N'COLUMN',@level2name=N'IsCoordinator'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[37] 4[17] 2[43] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Member"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 370
               Right = 228
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "Location"
            Begin Extent = 
               Top = 6
               Left = 266
               Bottom = 215
               Right = 437
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Country"
            Begin Extent = 
               Top = 284
               Left = 389
               Bottom = 414
               Right = 559
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "State"
            Begin Extent = 
               Top = 271
               Left = 224
               Bottom = 401
               Right = 394
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Town"
            Begin Extent = 
               Top = 0
               Left = 450
               Bottom = 130
               Right = 620
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "AreaCoordinator"
            Begin Extent = 
               Top = 242
               Left = 562
               Bottom = 412
               Right = 755
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TownCoordinator"
            Begin Extent = 
               Top = 5
               Left = 716
               Bottom = 135
               Right = 938
            End
            DisplayFla' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LifeLineScript'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'gs = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 14
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LifeLineScript'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'LifeLineScript'
GO
