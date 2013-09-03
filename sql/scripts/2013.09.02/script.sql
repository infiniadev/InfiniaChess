create table LoginsNotConfirmed (
	LoginNotConfirmedId int not null identity,
	Created datetime not null default getdate(),
	Login varchar(15) not null,
	Password varchar(15) not null,
	FirstName varchar(32) null,
	LastName varchar(32) null,
	CountryId int null,
	Email varchar(100) not null,
	ConfirmationCode varchar(32) not null,
	constraint PK_LoginsNotConfirmed
		primary key (LoginNotConfirmedId),
	constraint UQ_LoginsNotConfirmed_ConfirmationCode
		unique (ConfirmationCode)
)
go