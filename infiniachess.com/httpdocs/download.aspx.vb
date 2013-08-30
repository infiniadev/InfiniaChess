Imports System
Imports System.Data
Imports DBChess

Partial Class download
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
	' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    	Session.Clear
        If Not IsPostBack Then
            myDB.FillCountries(DLCountry.Items)
        End If
    End Sub
	' ========================================================================================================
    Sub Next_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        If Page.IsValid = True Then
            Session("FirstName") = txtFirstName.Text
            Session("LastName") = txtLastName.Text
            Session("CountryText") = DLCountry.SelectedItem.Text
            Session("CountryID") = DLCountry.SelectedValue
            Session("Email") = txtEmail.Text
            Session("Login") = txtLogin.Text
            Session("Login") = txtLogin.Text

            Session("PasswordPlain") = Trim(txtPassword.Text)
            Session("PasswordMySQL") = GetVBulletinPassword(Session("PasswordPlain"))

            myDB.Session = Session
            myDB.CountAmounts()

            'myDB.SendMail("Infinia Chess", "support@infiniachess.com", txtFirstName.Text & " " & txtLastName.Text, txtCEmail.Text, "Infinia Chess Registration", "This is a Test Message")
            'Response.Write("***" & MailSent & "-" & myDB.ErrDesc & "***")
            'Response.End()

            If Session("Amount") > 0 Then
                If CType(sender, ImageButton).ID = "imgRenew" Then
                    Response.Redirect("download-step2.aspx")
                ElseIf CType(sender, ImageButton).ID = "imgPayPal" Then
                    Response.Redirect("paypal.aspx")
                    'Response.Redirect("payment_success.aspx?txn_id=qwerererer&txn_type=web_accept&payer_email=aa@a.a&receiver_email=InfiniaChess1@aol.com&custom=pafnutiy&mc_gross=29.95&mc_currensy=USD&first_name=pafnutiy&last_name=bbb")
                End If
            Else
                Response.Redirect("download-step3.aspx")
            End If
        End If
    End Sub
	' ========================================================================================================
    Public Sub CheckLoginAllowed(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        Try
            e.IsValid = not myDB.CheckLoginExists(txtLogin.Text)
        Catch ex As Exception
            lblMsg.Text = ex.Message.ToString()
        End Try
    End Sub
    ' ========================================================================================================
    Public Sub CheckEmailAllowed(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        Try
            e.IsValid = Not myDB.CheckEmailExists(txtEmail.Text)
        Catch ex As Exception
            lblMsg.Text = ex.Message.ToString()
        End Try
    End Sub
	' ========================================================================================================
    Public Sub CheckLoginCurse(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        Try
            e.IsValid = Instr(LCase(txtLogin.Text),"cunt") = 0 and Instr(LCase(txtLogin.Text),"damn") = 0 _
              and Instr(LCase(txtLogin.Text),"fuck") = 0 and Instr(LCase(txtLogin.Text),"shit") = 0
        Catch ex As Exception
            lblMsg.Text = ex.Message.ToString()
        End Try
    End Sub
	' ========================================================================================================
    Public Sub CheckLoginGuest(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        Try
            e.IsValid = Instr(LCase(txtLogin.Text),"guest") = 0
        Catch ex As Exception
            lblMsg.Text = ex.Message.ToString()
        End Try
    End Sub
	' ========================================================================================================
    Protected Sub btnNext_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNext.Click
        Next_Click(sender, e)
    End Sub
    ' ========================================================================================================
End Class
