﻿Partial Class download_step3
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
    Public CardConfirmation As String
    ' ========================================================================================================
    Private Sub ProcessPayment()
        myDB.CountAmounts()

        If Session("PromoCode") <> "" Then
            trPromotion.Visible = True
            lblPromoCode.Text = Session("PromoCode")
            lblPromoAmountRest.Text = Session("AmountPromoRest")
        End If

        If Session("Amount") <> 0 Then
            CardConfirmation = "Your credit card ending in " & Session("CardNumber") & " has been charged $" & Session("Amount")
        Else
            CardConfirmation = "Your Payment was made through Promotional Offer."
        End If

        If Session("LoginTransactionSaved") = Nothing Then
            myDB.InsertUserTran(Session("LoginID"))
            Session("LoginTransactionSaved") = True
        End If

        If Session("DBError") <> Nothing Then
            lblFirstName.Text = Session("DBError")
            lblLastName.Text = Session("SQL")
        End If

        Dim MemberName As String = Session("FirstName") & " " & Session("LastName")
        Dim Message As String = "Hello " & Session("FirstName") & " " & Session("LastName") & ",<br><br>Thank you for registering with Infinia Chess. We have received your Application, and it is under process. One of our staff representative will get to you as soon as the processing gets completed. <br><br>Thank You!<br>Infinia Chess"
        'myDB.SendMail("Infinia Chess", "support@infiniachess.com", MemberName, myDB.Email, "Infinia Chess Registration", Message)

        Message = "New Registration for " & MemberName & ".<br><br>" & vbCrLf & _
                  "Name: " & MemberName & "<br>" & vbCrLf & _
                  "Email: " & Session("Email") & "<br>" & vbCrLf & _
                  "Username: " & Session("Login") & "<br>" & vbCrLf & _
                  "Password: " & Session("Password") & "<br>" & vbCrLf & _
                  "Membership Type: " & Session("SubscribeID") & "<br>" & vbCrLf & _
                  "Name On Card: " & Session("NameOnCard") & "<br>" & vbCrLf & _
                  "Card Type: " & Session("CardType") & "<br>" & vbCrLf & _
                  "Card Number: ************" & Session("CardNumber") & "<br>"

        If Session("PromoCode") <> "" Then
            Message = Message & "Promotion Code: " & Session("PromoCode")
        End If
    End Sub
    ' ========================================================================================================
    Private Function GetEmailConfirmationText(ByVal fullName As String, ByVal link As String) As String
        Dim text = System.IO.File.ReadAllText(AppDomain.CurrentDomain.BaseDirectory + "App_Code\EmailPatterns\EmailConfirmation.ptrn")
        Return text.Replace("%FULL_NAME%", fullName).Replace("%CONFIRMATION_LINK%", link)
    End Function
    ' ========================================================================================================
    Private Function GetConfirmationLink() As String
        Dim uri = HttpContext.Current.Request.Url.AbsoluteUri
        Dim n = uri.IndexOf("download-step3.aspx")
        Return uri.Substring(0, n) & "confirmation.aspx?code=" & Session("ConfirmationCode")
    End Function
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If IsPostBack Then Return

        lblFirstName.Text = Session("FirstName")
        lblLastName.Text = Session("LastName")
        lblCountry.Text = Session("CountryText")
        lblEmail.Text = Session("Email")
        lblLogin.Text = Session("Login") ' Session("Login")
        lblSubscribeExpire.Text = Now.AddDays(Session("SubscribeDays"))
        lblSubscribeTypeText.Text = Session("SubscribeText")
        lblPleaseConfirm.Visible = ApplicationSettings.EmailConfirmationRequired

        myDB.Session = Session
        If Session("LoginID") = Nothing Then
            If ApplicationSettings.EmailConfirmationRequired Then
                If Not myDB.CreateNewNotConfirmedUser() Then
                    Response.Redirect("sqlerror.aspx")
                End If
                Dim MemberName As String = Session("FirstName").ToString() & " " & Session("LastName").ToString()
                myDB.SendMail("Perpetual Chess", "infiniadev@gmail.com", MemberName, Session("Email").ToString(), "Perpetual Chess Registration", _
                              GetEmailConfirmationText(MemberName, GetConfirmationLink()))
            Else
                If Not myDB.CreateNewUser() Then
                    Response.Redirect("sqlerror.aspx")
                End If
            End If
        End If

        'myDB.SendMail(MemberName, Session("Email"), "Infinia Chess", "info@infiniachess.com", "New Member Signup", Message)
    End Sub
	' ========================================================================================================
	Protected Sub btnProfile_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnProfile.Click
		Response.Redirect("customer-profile.aspx")
	End Sub
End Class
