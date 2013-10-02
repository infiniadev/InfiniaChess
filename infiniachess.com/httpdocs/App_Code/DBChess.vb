Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic
Imports System.Security.Cryptography
Imports System.Net

Public Class DBChess
    Dim myConnection As New Conn
    'Dim myConn As New Odbc.OdbcConnection(myConnection.ConnVBulletinStr)
    Public Session As HttpSessionState
    Const VBULLETIN_SALT As String = "AQI"
    Dim ConnString As String = "data source=localhost;initial catalog=CLServer;persist security info=False;user id=clsa;password=Nf6=Q;packet size=4096"
    ''Dim ConnString As String = "data source=67.192.255.154;initial catalog=CLServer;persist security info=False;user id=clsa;password=Nf6=Q;packet size=4096"

    Public ErrDesc As String
    ' ========================================================================================================
    Public Shared Function Str2Double(ByVal p_Str As String) As Double
        Dim Result As Double = 0
        Dim separator As String = System.Globalization.NumberFormatInfo.CurrentInfo.CurrencyDecimalSeparator
        If Not Double.TryParse(System.Text.RegularExpressions.Regex.Replace(p_Str.Trim, ",|\.", separator), _
            System.Globalization.NumberStyles.Any, _
            System.Threading.Thread.CurrentThread.CurrentCulture, Result) Then
            Throw New OverflowException
        End If
        Return Result
    End Function
    ' ========================================================================================================
    Public Shared Function StrIsDoubleNumber(ByVal p_Str As String) As Double
        Try
            Dim dumb As Double = Str2Double(p_Str)
            Return True
        Catch ex As Exception
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Public Shared Function SafeNull(ByVal sender As Object) As Object
        If sender Is Nothing Then
            Return DBNull.Value
        Else
            Return sender
        End If
    End Function
    ' ========================================================================================================
    Public Function LoginExists(ByVal p_Login As String) As Boolean
        Try
            Dim sql As String = "select count(*) from Logins where Login='" & p_Login & "'"
            Return myConnection.GetIntegerValue(sql) > 0
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        End Try
    End Function
    ' ========================================================================================================
    Public Function EmailExists(ByVal p_Email As String) As Boolean
        Try
            Dim sql As String = "select count(*) from LoginPrivate where Email='" & p_Email & "'"
            Return myConnection.GetIntegerValue(sql) > 0
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        End Try
    End Function
    ' ========================================================================================================
    Public Function CheckLoginPassword(ByVal p_Login As String, ByVal p_Password As String) As Boolean
        Try
            Dim sql As String = _
             " select count(*) from Logins where Login='" & p_Login & "'" & _
             " and Password = '" & p_Password & "'"
            Return myConnection.GetIntegerValue(sql) > 0
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        End Try
    End Function
    ' ========================================================================================================
    Public Function CheckPromotionExists(ByVal p_PromoCode As String) As Boolean
        Try
            Dim sql As String = "select count(ID) from v_promo_codes where Code='" & p_PromoCode & "'" & _
              " and Enabled = 1 and AmountBalance > 0 and ExpireDate > getdate()"
            Return myConnection.GetIntegerValue(sql) > 0
        Catch ex As Exception
            Throw New Exception(ex.Message.ToString())
        End Try
    End Function
    ' ========================================================================================================
    Function GetCountryName(ByVal p_CountryID As Integer) As String
        Return myConnection.GetStringValue("select name as Country from Countries where id = " & p_CountryID)
    End Function
    ' ========================================================================================================
    Function GetLoginID(ByVal p_Login As String, ByVal p_Password As String) As Integer
        Return myConnection.GetIntegerValue("select LoginID from Logins where Login = '" & _
         p_Login & "' and password = '" & p_Password & "'")
    End Function
    ' ========================================================================================================
    Function GetLoginID(ByVal p_Login As String) As Integer
        Return myConnection.GetIntegerValue("select LoginID from Logins where Login = '" & p_Login & "'")
    End Function
    ' ========================================================================================================
    Function GetAdminLevel(ByVal p_Login As String) As Integer
        Return myConnection.GetIntegerValue("select AdminLevel from Logins where Login = '" & p_Login & "'")
    End Function
    ' ========================================================================================================
    Function GetRandomConfirmationCode() As String
        Dim Symbols = "abcdefghijklmnopqrstuvwxyz0123456789"
        Dim sb = New StringBuilder()
        Dim Generator As System.Random = New System.Random()
        For i = 1 To 20
            Dim position As Integer = Generator.Next(1, Symbols.Length)
            sb.Append(Symbols(position))
        Next
        Return sb.ToString()
    End Function
    ' ========================================================================================================
    Function GetUniqueConfirmationCode() As String
        Dim code As String
        Do
            code = GetRandomConfirmationCode()
        Loop Until Not ConfirmationCodeExists(code)

        Return code
    End Function
    ' ========================================================================================================
    Function ConfirmationCodeExists(code As String) As Boolean
        Return myConnection.GetIntegerValue("select count(*) from LoginsNotConfirmed where ConfirmationCode = '" + code + "'") > 0
    End Function
    ' ========================================================================================================
    Function CreateNewNotConfirmedUser() As Boolean
        Dim myCommand As SqlCommand = myConnection.Connection.CreateCommand
        Dim myTrans As SqlTransaction

        myConnection.Connection.Open()
        myTrans = myConnection.Connection.BeginTransaction(IsolationLevel.ReadCommitted, "CreateNewUser")

        myCommand.Connection = myConnection.Connection
        myCommand.Transaction = myTrans

        Try
            Dim ConfirmationCode As String = GetUniqueConfirmationCode()
            Session("ConfirmationCode") = ConfirmationCode
            Session("LastSQL") = "insert into LoginsNotConfirmed (Login, Password, FirstName, LastName, CountryId, Email, ConfirmationCode) " & _
                "values ('" & Session("Login") & "', '" & Session("PasswordPlain") & "', '" & Session("FirstName") & "', '" & Session("LastName") & "', '" & _
                Session("CountryID") & "', '" & Session("Email") & "', '" & ConfirmationCode & "')"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            myTrans.Commit()
            Session("SQLError") = Nothing
            Return True
        Catch e As Exception
            Session("SQLError") = e.Message
            myTrans.Rollback("CreateNewUser")
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & e.Message)
            Return False
        Finally
            myConnection.Connection.Close()
        End Try
    End Function
    ' ========================================================================================================
    Function ConfirmUser(confirmationCode As String) As String
        Session("LastSQL") = "select * from LoginsNotConfirmed where ConfirmationCode = '" & confirmationCode & "'"
        Dim notConfirmedUser As DataTable = myConnection.SelectTable(Session("LastSQL"))
        If notConfirmedUser.Rows.Count = 0 Then Return "Confirmation Code does not exists"
        If LoginExists(notConfirmedUser.Rows(0).Item("Login").ToString()) Then Return "User has already been registered"
        Session("FirstName") = notConfirmedUser.Rows(0).Item("FirstName")
        Session("LastName") = notConfirmedUser.Rows(0).Item("LastName")
        Session("CountryID") = notConfirmedUser.Rows(0).Item("CountryID")
        Session("Email") = notConfirmedUser.Rows(0).Item("Email")
        Session("Login") = notConfirmedUser.Rows(0).Item("Login")
        Session("PasswordPlain") = notConfirmedUser.Rows(0).Item("Password")
        If Not CreateNewUser() Then Return Session("SQLError")
        Return String.Empty
    End Function
    ' ========================================================================================================
    Function CreateNewUser() As Boolean
        Dim myCommand As SqlCommand = myConnection.Connection.CreateCommand
        Dim myTrans As SqlTransaction

        myConnection.Connection.Open()
        myTrans = myConnection.Connection.BeginTransaction(IsolationLevel.ReadCommitted, "CreateNewUser")

        myCommand.Connection = myConnection.Connection
        myCommand.Transaction = myTrans

        Try
            Session("LastSQL") = "insert into Logins (Login, Password) values ('" & Session("Login") & "', '" & Session("PasswordPlain") & "')"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            Session("LastSQL") = "SELECT @@IDENTITY"
            myCommand.CommandText = Session("LastSQL")
            Session("LoginID") = myCommand.ExecuteScalar()

            Session("LastSQL") = "insert into LoginXRef (Login, LoginID) values ('" & Session("Login") & "', " & Session("LoginID") & ")"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            Session("LastSQL") = "insert into LoginRatings(LoginID, RatedType) select " & Session("LoginID") & ", r.RatedType from RatedTypes r"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            Session("LastSQL") = "insert into LoginPrivate (LoginID, FirstName, LastName, Email, CountryID)" & _
             " values (" & Session("LoginID") & ", '" & Session("FirstName") & "', '" & Session("LastName") & "', '" & _
             Session("Email") & "', " & Session("CountryID") & ")"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            Session("LastSQL") = "delete from LoginsNotConfirmed where Login = '" + Session("Login") + "'"
            myCommand.CommandText = Session("LastSQL")
            myCommand.ExecuteNonQuery()

            myTrans.Commit()
            Session("SQLError") = Nothing
            Return True
        Catch e As Exception
            Session("SQLError") = e.Message
            myTrans.Rollback("CreateNewUser")
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & e.Message)
            Return False
        Finally
            myConnection.Connection.Close()
        End Try
    End Function
    ' ========================================================================================================
    Function InsertUserTran(ByVal p_LoginID As Integer) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_SaveLoginTransactions"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@id", 0)
            myCommand.Parameters.AddWithValue("@TransactionDate", Now())
            myCommand.Parameters.AddWithValue("@deleted", 0)
            myCommand.Parameters.AddWithValue("@LoginID", p_LoginID)

            If Session("AmountFull") > 0 Then
                myCommand.Parameters.AddWithValue("@MembershipType", 2)
            Else
                myCommand.Parameters.AddWithValue("@MembershipType", 1)
            End If

            myCommand.Parameters.AddWithValue("@SubscribeType", Session("SubscribeID"))
            myCommand.Parameters.AddWithValue("@SourceType", 1) ' source is web site
            myCommand.Parameters.AddWithValue("@ExpireDate", Now().AddDays(Session("SubscribeDays")))
            myCommand.Parameters.AddWithValue("@Amount", Session("Amount"))
            myCommand.Parameters.AddWithValue("@AmountFull", Session("AmountFull"))

            myCommand.Parameters.AddWithValue("@NameOnCard", SafeNull(Session("NameOnCard")))
            myCommand.Parameters.AddWithValue("@CardType", SafeNull(Session("CardType")))
            myCommand.Parameters.AddWithValue("@CardNumber", SafeNull(Session("CardNumber")))

            If Session("PromoCode") <> "" Then
                myCommand.Parameters.AddWithValue("@PromoID", GetPromoID(Session("PromoCode")))
            Else
                myCommand.Parameters.AddWithValue("@PromoID", DBNull.Value)
            End If

            myCommand.Parameters.AddWithValue("@AdminCreated", DBNull.Value)
            myCommand.Parameters.AddWithValue("@AdminDeleted", DBNull.Value)
            myCommand.Parameters.AddWithValue("@AdminComment", DBNull.Value)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    'Function CreateVBulletinUser(ByVal p_LoginID As Integer, ByVal p_Login As String, ByVal p_Password As String, _
    'ByVal p_Email As String, ByVal p_AdminLevel As Integer, Optional ByVal p_OpenConn As Boolean = True) As Boolean
    '    Try
    '        If p_OpenConn Then
    '            myConn.Open()
    '        End If
    '        Session("LastSQL") = " select count(*) from chess_vbulletin.user where userid = " & p_LoginID
    '        Dim olecmd As New Odbc.OdbcCommand(Session("LastSQL"), myConn)
    '        Dim cnt As Integer = olecmd.ExecuteScalar()
    '        Dim UserGroupID As Integer

    '        Select Case p_AdminLevel
    '            Case 0
    '                UserGroupID = 2
    '            Case 1
    '                UserGroupID = 7
    '            Case 2
    '                UserGroupID = 5
    '            Case 3
    '                UserGroupID = 6
    '        End Select

    '        If cnt = 0 Then
    '            Session("LastSQL") = _
    '             " insert into chess_vbulletin.user(" & _
    '             " userid, usergroupid, displaygroupid, username, password, passworddate, email, styleid, showvbcode, showbirthday, " & _
    '             " usertitle, customtitle, lastpost, lastpostid, posts, reputation, reputationlevelid, " & _
    '             " timezoneoffset, pmpopup, avatarid, avatarrevision, profilepicrevision, sigpicrevision, " & _
    '             " options, referrerid, languageid, emailstamp, threadedmode, autosubscribe, pmtotal, " & _
    '             " pmunread, salt, ipoints, infractions, warnings, infractiongroupid, adminoptions) " & _
    '             " values (" & p_LoginID & "," & UserGroupID & ",0, " & _
    '             " '" & p_Login & "', '" & GetVBulletinPassword(p_Password) & "', '2009-06-05', " & _
    '             " '" & p_Email & "', " & _
    '             " 0, 1, 0, 'Junior  Member', 0, 0, 0, 0, 10, 5, 0, 0, 0, 0, " & _
    '             " 0, 0, 3159, 0, 1, 0, 0, -1, 0, 0, '" & VBULLETIN_SALT & "', 0, 0, 0, 0, 0)"

    '            olecmd.CommandText = Session("LastSQL")
    '            olecmd.ExecuteNonQuery()
    '        End If

    '        Session("SQLError") = Nothing
    '        Return True
    '    Catch e As Exception
    '        Session("SQLError") = e.Message
    '        Return False
    '    Finally
    '        If p_OpenConn Then
    '            myConn.Close()
    '        End If
    '    End Try
    'End Function
    ' ========================================================================================================
    'Function TransferUsersToForum() As Boolean
    '    Dim dt As New Datatable
    '    Dim i As Integer
    '    myConn.Open()
    '    Try
    '        dt = GetLogin(0)
    '        If dt Is Nothing Then Return False

    '        For i = 0 To dt.Rows.Count - 1
    '            If Not CreateVBulletinUser(dt.Rows(i).Item("LoginID"), dt.Rows(i).Item("Login"), _
    '              dt.Rows(i).Item("Password"), _
    '              dt.Rows(i).Item("Email"), dt.Rows(i).Item("AdminLevel"), False) Then
    '                Return False
    '            End If
    '        Next
    '        Return True
    '    Finally
    '        myConn.Close()
    '    End Try
    'End Function
    ' ========================================================================================================
    Function ChangePassword(ByVal p_Login As String, ByVal p_Password As String) As Boolean
        Try
            Session("LastSQL") = " update Logins set Password = '" & p_Password & "' where Login = '" & p_Login & "'"
            myConnection.ExecSql(Session("LastSQL"))

            'myConn.Open()
            'Session("LastSQL") = " update user set password = '" & GetVBulletinPassword(p_Password) & "' where username = '" & p_Login & "'"
            'Dim olecmd As New Odbc.OdbcCommand(Session("LastSQL"), myConn)												
            'olecmd.ExecuteNonQuery()

            Session("SQLError") = Nothing
            Return True
        Catch e As Exception
            Session("SQLError") = e.Message
            Return False
        Finally
            'myConn.Close()
        End Try
    End Function
    ' ========================================================================================================
    Function SendMail(ByVal SenderName As String, ByVal SenderEmail As String, ByVal RecipientName As String, ByVal RecipientEmail As String, ByVal Subject As String, ByVal Message As String) As Boolean
        Try
            Dim smtpObj As New System.Net.Mail.SmtpClient(ApplicationSettings.SmtpHost)
            smtpObj.Port = ApplicationSettings.SmtpPort
            smtpObj.Credentials = New NetworkCredential(ApplicationSettings.SmtpUser, ApplicationSettings.SmtpPassword)
            smtpObj.EnableSsl = True

            'Specify the sender
            Dim o_FromAddress As System.Net.Mail.MailAddress = New System.Net.Mail.MailAddress(SenderEmail, SenderName)

            'Add a normal recipient
            Dim o_ToAddress As System.Net.Mail.MailAddress = New System.Net.Mail.MailAddress(Trim(RecipientEmail), Trim(RecipientName))
            Dim o_Message As System.Net.Mail.MailMessage = New System.Net.Mail.MailMessage(o_FromAddress, o_ToAddress)

            o_Message.Subject = Subject
            o_Message.Body = Message

            'Set message body
            o_Message.IsBodyHtml = False

            'Send the message
            smtpObj.Send(o_Message)

            SendMail = True
        Catch SMTPProtocolExcep As Exception
            ErrDesc = SMTPProtocolExcep.Message
            SendMail = False
        End Try
    End Function
    ' ========================================================================================================
    Function GetPromoAmount(ByVal p_PromoCode As String) As Single
        Return myConnection.GetSingleValue("select IsNull(AmountBalance, 0) from v_promo_codes where Code='" & p_PromoCode & "'")
    End Function
    ' ========================================================================================================
    Function GetSubscribeAmount(ByVal p_SubscribeType As Integer) As Single
        Return myConnection.GetSingleValue("Select Amount from SubscribeTypes where id = " & p_SubscribeType)
    End Function
    ' ========================================================================================================
    Function GetSubscribeDays(ByVal p_SubscribeType As Integer) As Integer
        Return myConnection.GetIntegerValue("Select Days from SubscribeTypes where id = " & p_SubscribeType)
    End Function
    ' ========================================================================================================
    Function GetPromoID(ByVal p_PromoCode As String) As Integer
        Return myConnection.GetIntegerValue("select ID from PromoCodes where Code = '" & p_PromoCode & "'")
    End Function
    ' ========================================================================================================
    Function GetLogin(ByVal p_LoginID As Integer) As DataTable
        Dim SQL = _
         " select L.LoginID, L.Login, L.Password, L.AdminLevel, L.Title, IsNull(LP.FirstName,'') as FirstName, " & _
         " IsNull(LP.LastName,'') as LastName, IsNull(LP.Email,'') as Email, " & _
         " IsNull(LP.CountryID,227) as CountryID, IsNull(C.Name,'United States') as Country " & _
         " from Logins L left join LoginPrivate LP on L.LoginID = LP.LoginID " & _
         "   left join Countries C on LP.CountryID = C.ID "

        If p_LoginID <> 0 Then
            SQL = SQL & " where L.LoginID = " & p_LoginID
        Else
            SQL = SQL & " where L.LoginID > 33988"
        End If

        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function FillLoginInfo(ByVal p_LoginID As Integer) As Boolean
        Dim dt As New DataTable

        dt = GetLogin(p_LoginID)
        If Not dt Is Nothing And dt.Rows.Count > 0 Then
            Session("Login") = dt.Rows(0).Item("Login")
            Session("PasswordPlain") = dt.Rows(0).Item("Password")
            Session("AdminLevel") = dt.Rows(0).Item("AdminLevel")
            Session("FirstName") = dt.Rows(0).Item("FirstName")
            Session("LastName") = dt.Rows(0).Item("LastName")
            Session("Email") = dt.Rows(0).Item("Email")
            Session("CountryID") = dt.Rows(0).Item("CountryID")
            Session("CountryText") = dt.Rows(0).Item("Country")
            Return True
        Else
            Return False
        End If
    End Function
    ' ========================================================================================================
    Function GetLoginTransaction(ByVal p_LoginID As Integer) As DataTable
        Dim SQL = " select case LT.SubscribeType when 6 then MT.name else ST.Name end as SubscribeTypeName, " & _
            " MT.ShowPayment, LT.* " & _
            " from LoginTransactions LT inner join SubscribeTypes ST on LT.SubscribeType = ST.ID " & _
            "   inner join MembershipTypes MT on LT.MembershipType = MT.ID " & _
            " where Deleted = 0 and LT.LoginID = " & p_LoginID & _
            " order by ExpireDate desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetPromoCodeUsage(ByVal p_PromoID As Integer) As DataTable
        Dim SQL = " select * from v_promo_codes_usage where PromoID = " & p_PromoID
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetPromoCodes() As DataTable
        Dim SQL = " select v.*, convert(varchar, expiredate, 101) as ExpireDateShort," & _
            "   convert(varchar, datecreated, 101) as DateCreatedShort" & _
            " from v_promo_codes v order by Id"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetChat(ByVal p_DateFrom As DateTime, ByVal p_DateTo As DateTime, _
         ByVal p_Login As String, ByVal p_Place As String, _
         ByVal p_Text As String, ByRef pp_SQL As String) As DataTable
        Dim dtFrom As Integer = p_DateFrom.ToOADate - 2

        Dim dtTo As Integer = p_DateTo.ToOADate - 1
        Dim sFrom As String = p_DateFrom.ToString("yyyy.MM.dd")
        Dim sTo As String = p_DateTo.ToString("yyyy.MM.dd")
        Dim SQL = _
         " select dt, place, login, str " & _
         " from ChatLog " & _
         " where Login like '%" & p_Login & "%'" & _
         "   and Place like '%" & p_Place & "%'" & _
         "   and str   like '%" & p_Text & "%'" & _
         "   and dt between " & dtFrom & " and " & dtTo & _
         " order by id"
        ' "   and convert(varchar, dt, 102) between '" & sFrom & "' and '" & sTo & "'" & _
        pp_SQL = SQL
        GetChat = myConnection.SelectTable(SQL)

        SaveCommandsUsage(Session("Login"), "@chatlog", _
         " '" & sFrom & " " & sTo & " {" & p_Login & "} {" & p_Place & "} {" & p_Text & "}')")
    End Function
    ' ========================================================================================================
    Function GetTop100Achievements(ByVal p_Order As Integer) As DataTable
        Dim OrderField As String
        If p_Order = 0 Then
            OrderField = "ScoreSum"
        Else
            OrderField = "cnt"
        End If
        Dim Order As String = OrderField & " desc, LastDate"
        Dim SQL As String = _
         " select top 100 LoginWithTitle, RatingMax, LastDate, ScoreSum, cnt, " & _
         "   row_number() over (order by " & Order & ") as rank " & _
         " from v_ach_completed_summary_r " & _
         " order by " & Order
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Sub CountAmounts()
        Session("SubscribeDays") = GetSubscribeDays(Session("SubscribeID"))
        Session("AmountFull") = GetSubscribeAmount(Session("SubscribeID"))
        Session("AmountPromo") = GetPromoAmount(Session("PromoCode"))

        If Session("AmountFull") > 0 Then
            If Session("AmountPromo") > Session("AmountFull") Then
                Session("AmountPromoRest") = Session("AmountPromo") - Session("AmountFull")
                Session("AmountPromo") = Session("AmountFull")
            Else
                Session("AmountPromoRest") = 0
            End If
        End If
        Session("Amount") = Session("AmountFull") - Session("AmountPromo")
    End Sub
    ' ========================================================================================================
    ' must contain "text" and "value" fields
    Sub FillItems(ByVal p_Items As ListItemCollection, ByVal p_Sql As String, Optional ByVal p_Selected As String = "")
        Dim i As Integer
        Dim dt As New DataTable
        p_Items.Clear()
        dt = myConnection.SelectTable(p_Sql)
        If Not dt Is Nothing Then
            For i = 0 To dt.Rows.Count - 1
                p_Items.Insert(i, New ListItem(dt.Rows(i).Item("text").ToString, dt.Rows(i).Item("value").ToString))
                If p_Selected <> "" And dt.Rows(i).Item("text").ToString = p_Selected Then
                    p_Items(i).Selected = True
                End If
            Next
        End If
    End Sub
    ' ========================================================================================================
    Sub FillCountries(ByVal Items As ListItemCollection, Optional ByVal p_Selected As String = "United States")
        FillItems(Items, "select id as value, name as text from Countries", p_Selected)
    End Sub
    ' ========================================================================================================
    Sub FillSubscribeTypes(ByVal Items As ListItemCollection, ByVal p_PaidOnly As Boolean)
        Dim SQL As String
        SQL = "select id as value, name as text from SubscribeTypes where active = 1"
        If p_PaidOnly Then
            SQL = SQL & " and Amount > 0"
        End If
        Try
            If Session("Login") = "urise" Then
                SQL = SQL & " or id = 4" ' test membership $1
            End If
        Catch
        End Try

        SQL = SQL & " order by OrderID"
        FillItems(Items, SQL)
    End Sub
    ' ========================================================================================================
    Sub FillStates(ByVal Items As ListItemCollection)
        FillItems(Items, "select '-1' as value, 'Please Select' as text union select StateCode as value, name as text from states")
    End Sub
    ' ========================================================================================================
    Sub UpdateLoginInfo()
        Dim SQL = _
         " update LoginPrivate " & _
         " set FirstName = '" & Session("FirstName") & "', " & _
         " 	  LastName ='" & Session("LastName") & "', " & _
         " 	  Email = '" & Session("Email") & "', " & _
         " 	  CountryID = " & Session("CountryID") & _
         " where LoginID = " & Session("LoginID")
        myConnection.ExecSql(SQL)
    End Sub
    ' ========================================================================================================
    'Sub UpdateCustomervBulletinPassword()
    '    Try
    '        Dim conn As New Odbc.OdbcConnection(myConnection.ConnVBulletinStr)
    '        Dim olecmd As New Odbc.OdbcCommand("Update chess_vbulletin.user Set password='" & PasswordMySQL & "', email='" & Email & "' WHERE username='" & Username & "'", conn)
    '        conn.Open()
    '        olecmd.ExecuteNonQuery()
    '    Catch e As Exception

    '    Finally

    '    End Try
    'End Sub
    ' ========================================================================================================
    Public Shared Function GetMD5Hash(ByVal str As String) As String
        Try
            Dim MD5Hasher As New MD5CryptoServiceProvider
            Dim rawBytes As Byte() = ASCIIEncoding.ASCII.GetBytes(str)
            Dim myHash As Byte() = MD5Hasher.ComputeHash(rawBytes)
            Dim myCapacity As Integer = Convert.ToInt32(((myHash.Length * 2) + (myHash.Length / 8)))
            Dim sb As System.Text.StringBuilder = New System.Text.StringBuilder(myCapacity)

            For i As Integer = 0 To myHash.Length - 1
                sb.Append(BitConverter.ToString(myHash, i, 1))
            Next

            Return sb.ToString().TrimEnd(New Char() {" "c}).ToLower
        Catch ex As Exception
            Return ""
        End Try
    End Function
    ' ========================================================================================================
    Public Shared Function GetVBulletinPassword(ByVal p_Str As String) As String
        Return GetMD5Hash(GetMD5Hash(p_Str) & VBULLETIN_SALT)
    End Function
    ' ========================================================================================================
    Sub InsertPayPalLog(ByVal p_SendString As String, ByVal p_Result As String)
        Dim SQL = _
         " insert into PayPalLog(sendstring, result)" & _
         " values ('" & p_SendString & "', '" & p_Result & "')"
        myConnection.ExecSql(SQL)
    End Sub
    ' ========================================================================================================
    Public Shared Function BoolTo01(ByVal p_Boolean As Boolean) As Integer
        If p_Boolean Then
            Return 1
        Else
            Return 0
        End If
    End Function
    ' ========================================================================================================
    Function SavePromoCode(ByVal p_ID As Integer, ByVal p_Code As String, ByVal p_Amount As Single, _
     ByVal p_Enabled As Boolean, ByVal p_ExpireDate As DateTime, _
     ByVal p_Delivered As Boolean, ByVal p_Comments As String) As Boolean
        Dim nExpireDate As Double = p_ExpireDate.ToOADate()

        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_SavePromoCode"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@id", p_ID)
            myCommand.Parameters.AddWithValue("@code", p_Code)
            myCommand.Parameters.AddWithValue("@amount", p_Amount)
            myCommand.Parameters.AddWithValue("@enabled", BoolTo01(p_Enabled))
            myCommand.Parameters.AddWithValue("@ExpireDate", p_ExpireDate)
            myCommand.Parameters.AddWithValue("@AdminCreated", Session("Login"))
            myCommand.Parameters.AddWithValue("@DateCreated", Now())
            myCommand.Parameters.AddWithValue("@Delivered", BoolTo01(p_Delivered))
            myCommand.Parameters.AddWithValue("@Comments", p_Comments)


            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Sub DeletePromoCode(ByVal p_PromoID As Integer)
        Dim SQL As String
        SQL = "delete from PromoCodes where id = " & p_PromoID
        myConnection.ExecSql(SQL)
    End Sub
    ' ========================================================================================================
    Function GetMinSubscriptionPrice() As Single
        Dim SQL As String = " select min(amount) from SubscribeTypes where active = 1 and amount > 0"
        Return myConnection.GetSingleValue(SQL)
    End Function
    ' ========================================================================================================
    Function SavePayPalResponse(ByVal p_Success As Boolean, ByVal p_TxnId As String, _
           ByVal p_TxnType As String, ByVal p_PayerEmail As String, _
           ByVal p_ReceiverEmail As String, ByVal p_IPNResponse As String, _
           ByVal p_Custom As String, ByVal p_McGross As Decimal, _
           ByVal p_McCurrency As String) As Boolean

        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_SavePayPalResponse"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@success", p_Success)
            myCommand.Parameters.AddWithValue("@txn_id", p_TxnId)
            myCommand.Parameters.AddWithValue("@txn_type", SafeNull(p_TxnType))
            myCommand.Parameters.AddWithValue("@payer_email", SafeNull(p_PayerEmail))
            myCommand.Parameters.AddWithValue("@receiver_email", SafeNull(p_ReceiverEmail))
            myCommand.Parameters.AddWithValue("@IPNResponse", SafeNull(p_IPNResponse))
            myCommand.Parameters.AddWithValue("@custom", SafeNull(p_Custom))
            myCommand.Parameters.AddWithValue("@mc_gross", SafeNull(p_McGross))
            myCommand.Parameters.AddWithValue("@mc_currency", SafeNull(p_McCurrency))
            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Function PayPalResponseExists(ByVal p_TxnID As String) As Boolean
        Dim SQL = "select count(*) from PayPalResponses where txn_id = '" & p_TxnID & "'"
        Dim cnt As Integer = myConnection.GetIntegerValue(SQL)
        Return cnt > 0
    End Function
    ' ========================================================================================================
    Function GetBanHistory(ByVal p_Login As String) As DataTable
        Dim SQL As String = _
         " select * from v_BanHistory where Login = '" & p_Login & "'" & _
         " order by IsActive desc, Date_ desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetRatings(ByVal p_LoginID As Integer) As DataTable
        Dim SQL As String = _
         " select * from v_www_ratings where LoginID = " & p_LoginID
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetLoginIP(ByVal p_Login As String) As DataTable
        Dim SQL As String = _
         " select * from v_www_login_ip where login = '" & p_Login & "' order by last_date desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetLoginMac(ByVal p_Login As String) As DataTable
        Dim SQL As String = _
         " select * from v_www_login_mac where login = '" & p_Login & "' order by last_date desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetNames(ByVal p_Login As String) As DataTable
        Dim SQL As String = _
         " select Q1.*, ip_cnt * mac_cnt as rating from " & _
         "   (select Login, count(*) as co, count(distinct LH.ip_address) as ip_cnt," & _
         "           count(distinct LH.mac) as mac_cnt" & _
         " from LoginHistory LH inner join" & _
         "   (select distinct ip_address, mac from LoginHistory" & _
         "    where Login = '" & p_Login & "' and res = 0" & _
         "      and date_ >= '2009.01.01' and ip_address is not null) Q" & _
         "   on LH.ip_address = Q.ip_address and LH.mac = Q.mac" & _
         " where LH.res = 0 and date_ >= '2009.01.01'" & _
         " group by Login) Q1" & _
         " order by rating desc, co desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function GetLoginHistory(ByVal p_Login As String, ByVal p_DateFrom As DateTime, ByVal p_DateTo As DateTime, _
      ByVal p_IP As String, ByVal p_MAC As String, ByVal p_Version As String) As DataTable
        Dim sFrom As String = p_DateFrom.ToString("yyyy.MM.dd")
        Dim sTo As String = p_DateTo.ToString("yyyy.MM.dd")
        Dim SQL As String = _
         " select * from v_www_login_history " & _
         " where login = '" & p_Login & "'" & _
         "   and convert(varchar, logindate, 102) between '" & sFrom & "' and '" & sTo & "'"
        If p_IP <> "" Then
            SQL = SQL & " and ip_address = '" & p_IP & "'"
        End If

        If p_MAC <> "" Then
            SQL = SQL & " and mac = '" & p_MAC & "'"
        End If

        If p_Version <> "" Then
            SQL = SQL & " and version = '" & p_Version & "'"
        End If

        SQL = SQL & " order by LoginDate desc"
        Return myConnection.SelectTable(SQL)
    End Function
    ' ========================================================================================================
    Function IsBanActive(ByVal p_Login As String, ByVal p_BanType As Integer) As Boolean
        Dim SQL As String = _
         " select count(*) from v_BanHistory where login = '" & p_Login & "'" & _
         "   and BanType = " & p_BanType & " and IsActive = 1"
        Dim cnt As Integer = myConnection.GetIntegerValue(SQL)
        Return cnt > 0
    End Function

    Function ProcBan(ByVal p_Login As String, ByVal p_Hours As Integer, ByVal p_Admin As String, _
      ByVal p_AdminReason As String) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_Ban"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@hours", p_Hours)
            myCommand.Parameters.AddWithValue("@admin", p_Admin)
            myCommand.Parameters.AddWithValue("@adminreason", p_AdminReason)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Function ProcBanHistory(ByVal p_Login As String, ByVal p_Admin As String, _
      ByVal p_Type As Integer, ByVal p_BanType As Integer, _
      ByVal p_Hours As Integer, ByVal p_AdminReason As String) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_BanHistory"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@admin", p_Admin)
            myCommand.Parameters.AddWithValue("@type_", p_Type)
            myCommand.Parameters.AddWithValue("@BanType", p_BanType)
            myCommand.Parameters.AddWithValue("@hours", p_Hours)
            myCommand.Parameters.AddWithValue("@AdminReason", p_AdminReason)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Sub FillRatedTypes(ByVal Items As ListItemCollection)
        Dim SQL As String
        SQL = "select RatedType as value, RatedName as text from RatedTypes order by RatedType"
        FillItems(Items, SQL)
    End Sub
    ' ========================================================================================================
    Function ProcSetRating(ByVal p_Login As String, ByVal p_Rating As Integer, _
      ByVal p_Type As Integer, ByVal p_Provisional As Boolean) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_SetRating"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@rating", p_Rating)
            myCommand.Parameters.AddWithValue("@type_", p_Type)
            myCommand.Parameters.AddWithValue("@provisional", p_Provisional)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function
    ' ========================================================================================================
    Function GetIpMacHistory(ByVal p_IP As String, ByVal p_MAC As String) As DataTable
        Dim SQL As String = _
         " select login, min(date_) as first_date, max(date_) as last_date, count(*) as co" & _
         " from LoginHistory where 0 = 0"

        If p_IP <> "" Then
            SQL = SQL + " and ip_address = '" & p_IP & "'"
        End If

        If p_MAC <> "" Then
            SQL = SQL + " and mac = '" & p_MAC & "'"
        End If

        SQL = SQL + " group by login order by last_date desc"
        Return myConnection.SelectTable(SQL)
    End Function

    Function SaveCommandsUsage(ByVal p_Admin As String, ByVal p_Command As String, _
      ByVal p_Params As String) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_CommandsUsage"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.AddWithValue("@admin", p_Admin)
            myCommand.Parameters.AddWithValue("@command", p_Command)
            myCommand.Parameters.AddWithValue("@params", p_Params)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function

    Function HaveRight(ByVal p_Login As String, ByVal p_Command As String) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_HaveRight"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure
            myCommand.Parameters.Add(New SqlParameter("RETURN VALUE", SqlDbType.Int))
            myCommand.Parameters(0).Direction = ParameterDirection.ReturnValue

            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@command", p_Command)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return myCommand.Parameters("RETURN VALUE").Value = 0
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function

    Function ChangeAdminLevel(ByVal p_Login As String, ByVal p_AdminLevel As Integer) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_SetAdminLevel"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure

            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@adminlevel", p_AdminLevel)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function

    Function ChangeTitle(ByVal p_Login As String, ByVal p_Title As String) As Boolean
        Dim conn As New SqlConnection(ConnString)
        conn.Open()
        Try
            Session("LastSQL") = "dbo.proc_LoginTitleChange"
            Dim myCommand As New SqlCommand(Session("LastSQL"), conn)
            myCommand.CommandType = CommandType.StoredProcedure

            myCommand.Parameters.AddWithValue("@login", p_Login)
            myCommand.Parameters.AddWithValue("@title", p_Title)

            myCommand.ExecuteNonQuery()
            Session("SQLError") = Nothing
            Return True
        Catch ex As Exception
            Session("SQLError") = ex.Message
            Return False
        End Try
    End Function

End Class
