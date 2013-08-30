ALTER PROCEDURE [dbo].[proc_LoginProfile]
	(@Login varchar(15))
as
begin
set nocount on

declare @LoginID int
declare @PageSize int

if object_id('tempdb..#Games', 'U') is not null drop table #Games
if object_id('tempdb..#Games1', 'U') is not null drop table #Games1

set @LoginID = (select LoginID from LoginXRef where Login = @Login)

if @LoginID is null 
begin
	set @LoginID = -1
	return -1
end

--Return the LoginID for the @Login param
select LoginID, Login, Title from Logins where LoginID = @LoginID

--Retreive all games for @LoginID, put in to a temp table. 
select  L.GameType, 
  G.GameID, G.BlackLoginID, G.BlackLogin,G.BlackTitle,
  G.BlackMSec, G.BlackRating,
  G.Date, G.ECO, G.Event, G.FEN,
  G.InitialMSec, G.IncMSec, G.Rated, G.RatedType,
  G.Result, G.Round, G.Site, G.WhiteLoginID, G.WhiteLogin,
  G.WhiteTitle, G.WhiteMSec, G.WhiteRating,
  0 as LoggedIn
into #Games
from GameHeaders G 
inner join LoginGames L on G.GameID = L.GameID 
where L.LoginID = @LoginId

--Update the LoggedIn field for the opponents of @LoginID
update G 
set LoggedIn = L.LoggedIn 
from #Games G 
inner join Logins L 
on (G.BlackLoginID = L.LoginID) or (G.WhiteLoginID = L.LoginID)
where L.LoginID <> @LoginID
and G.GameType = 2

--Return the games results
select * from #Games 
order by GameType, [Date]

select 1 as PageCo from Dual

--Other single line data (Potential exists for addition data to come from the Login table via an Inner Join) 
select P.* 
from LoginPublic P 
where LoginID = @LoginID

--Ratings (multi-line) recordset
select L.LoginID, L.RatedType, L.Rating, L.Provisional, 
  L.RatedWins, L.RatedLosses, L.RatedDraws,
  L.UnratedWins, L.UnratedLosses, L.UnratedDraws,
  L.EP, L.Best, 
  case when L.Best = 0 then '' else L.Date end as Date,
  R.RatedName
from LoginRatings L
inner join RatedTypes R
on L.RatedType = R.RatedType
where L.LoginID = @LoginID	

drop table #Games

select L.Created,L.LoginTS,IsNull(LP.email,null) as email,IsNull(LP.PublicEmail, 0) as PublicEmail, C.Name as Country,
  IsNull(LP.SexId, 0) as SexID,IsNull(LP.Age, 0) as Age,
  IsNull(LP.Language, 0) as Language, IsNull(LP.Birthday,0), IsNull(LP.ShowBirthday,0)
from Logins L left join LoginPrivate LP on L.LoginId = LP.LoginId
  left join Countries C on LP.CountryID = C.id
where L.LoginId = @LoginID

-- beginning statistics
if object_id('tempdb..#BStat', 'U') is not null drop table #BStat

select ECO, LoginID, Color, 
	case
		when result in (5,7,11,13) then 1
		when result in (4,6,10,12) then -1
		when result in (3,8,9) then 0
	end as Result
into #BStat
from 
(select 1 as Color, WhiteLoginID as LoginID, ECO, result
 from GameHeaders G
 where G.result > 2
	and G.rated = 1
	and G.ratedtype <= 2
    and @LoginId = WhiteLoginId
	and G.WhiteLoginID <> G.BlackLoginID
 union all
 select -1 as Color, BlackLoginID as LoginID, ECO, result
 from GameHeaders G
 where G.result > 2
	and G.rated = 1
	and G.ratedtype <= 2
    and @LoginId = BlackLoginId
	and G.WhiteLoginID <> G.BlackLoginID
) Q

select 
	IsNull(#BStat.ECO, '?'),
	#BStat.Color,
	#BStat.Color * #BStat.Result as MyResult,
	ECO.ECODesc,
	ECO.PGN,
	count(*) as cnt
from #BStat left join ECO on #BStat.ECO = ECO.ECO
group by
	#BStat.ECO, #BStat.Color, #BStat.Result,
	ECO.ECODesc, ECO.PGN

drop table #BStat

select 2 as MembershipType, 6 as SubscribeType, 
		CONVERT(datetime, '2020.01.01', 101) as ExpireDate,
		@LoginId as LoginId, 
		1 as OrderId
		
--select LT.MembershipType, LT.SubscribeType,  ExpireDate, LT.LoginID, MT.OrderID
--from LoginTransactions LT inner join MembershipTypes MT on LT.MembershipType = MT.id
--where LoginID = @LoginID and deleted = 0
--order by orderID, expireDate desc

return 0
end
go
