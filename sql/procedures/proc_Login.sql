ALTER PROCEDURE [dbo].[proc_Login]
	(@Login varchar(15),
	@Password varchar(15),
	@MAC varchar(50)= null,
	@IP varchar(15)=null,
	@TestAuthKey integer = 1)

as

set nocount on

declare @LoginID int
declare @MaxCount int
declare @type_ int
declare @date_ datetime
declare @hours int
declare @maxid int
declare @cnt int
declare @LoggedIn bit

--Retreive the LoginID from a table of clustered Logins
set @LoginID = (select LoginID from LoginXRef where Login = @Login)
if @LoginID is null return -2


--check then Banned MAC list
set @MAC = ltrim(rtrim(@MAC))

-- if user is paid member, we cannot forbid him to login
-- set @cnt = (select count(*) from LoginTransactions LT where LoginID = @LoginID
-- 	and MembershipType = 4 and getdate() between TransactionDate and ExpireDate) 
set @cnt = 0 -- nobody is paid member now

if @cnt = 0
begin
	if (select count(*)  from LoginMAC where BannedMAC = @MAC and not @MAC like '44-45%') > 0
	  or (select count(*)  from LoginIp where @IP like BannedIp) > 0 
	begin
		return -4
	end 

	set @maxid = (select max(id) from BanHistory where Login = @Login and Bantype = 1)
	if @maxid is not null
	begin
		set @type_ = (select type_ from BanHistory where id = @maxid)
		set @date_ = (select date_ from BanHistory where id = @maxid)
		set @hours = (select hours from BanHistory where id = @maxid)

		if @type_ = 1 and @date_ + convert(float,@hours)/24 < getdate() 
			execute dbo.proc_Unban @Login, 'server'
		else 
		if @type_ <> 2
		begin
			return -4
		end 
	end 
end 

if @TestAuthKey = 1
begin
	if (select auth_key from dbo.LoginPrivate where LoginId = @LoginId and sent = 1 and confirmed = 0) is not null
	begin
		return -8
	end
end

--Check the Login/Password/LoggedIn state. If valid set the LoggedIn flag, return a recordset..
if (select count(*) from Logins with (xlock) where LoginID = @LoginID and [Password] = @Password) = 1
begin
	update Logins 
	set LoggedIn = 1, 
		LoginTS = getdate(), 
		MAC = @MAC,
		ip_address = @IP
	where Login = @Login

	--Temporary, log the maximun number of players logged in
	set @MaxCount = (select count(*) from Logins where LoggedIn = 1)
	update LoginsMax set MaxCount = case when @MaxCount > MaxCount then @MaxCount else MaxCount end

	--login info
	select * from Logins where Login = @Login

	select * from LoginRatings where LoginID = @LoginID

	--Logins expecting notification of my arrival and departure.
	select l.LoginID, l.Login, l.Title, n.NotifyType  from LoginNotify n inner join Logins l on n.NotifyID = l.LoginID where n.LoginID = @LoginID order by n.LoginID, NotifyType, n.NotifyID
	
	select * from LoginPrivate where LoginID = @LoginID

	select 2 as MembershipType, 6 as SubscribeType, 
		CONVERT(datetime, '2020.01.01', 101) as ExpireDate,
		@LoginId as LoginId, 
		1 as OrderId
	--select * from v_actual_transactions where LoginID = @LoginID
	--order by orderID, expireDate desc

	return 0
end
