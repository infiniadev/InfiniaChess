Imports System
Imports System.Data
Imports System.Security.Cryptography

Partial Class customer_profile
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
	' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Me.Title = "Edit Customer Profile"
		myDB.Session = Session
		
		lblLogin.Text = Session("Login")
		
		If Session("LoginID") = Nothing Then
			Response.Redirect("customer-login.aspx")
		Else
			If Not IsPostBack Then
				If Not myDB.FillLoginInfo(Session("LoginID")) Then
					Return
				End If
				myDB.FillCountries(DLCountry.Items, Session("CountryText"))
				myDB.FillSubscribeTypes(rdoSubscribeType.Items, True)
				rdoSubscribeType.SelectedIndex = 0
            	FillProfile()
            	trAdmin.Visible = Session("AdminLevel") = 3
        	End If	
		End If
    End Sub
	' ========================================================================================================
    Sub FillProfile()
    	lblLogin.Text = Session("Login")
    	txtFirstName.Text = Session("FirstName")
    	txtLastName.text = Session("LastName")
    	txtEmail.Text = Session("Email")

        trRenew.Visible = False
        'Dim dt As New DataTable

        'dt = myDB.GetLoginTransaction(Session("LoginID"))
        'If Not dt Is Nothing And dt.Rows.Count > 0 Then
        '    If dt.Rows(0).Item("ExpireDate") > Now() Then
        '    	lblSubscribeTypeText.Text = dt.Rows(0).Item("SubscribeTypeName")
        '    	lblSubscribeExpireTitle.Text = "Valid Through:"
        '    	lblSubscribeExpire.Text = FormatDateTime(dt.Rows(0).Item("ExpireDate"), DateFormat.ShortDate)
        '        lblSubscribeTypeText.ForeColor = Drawing.Color.Blue
        '        lblSubscribeExpire.ForeColor = Drawing.Color.Blue
        '        trRenew.Visible = dt.Rows(0).Item("ShowPayment") OR dt.Rows(0).Item("ExpireDate") < Now().AddDays(30)
        '    Else
        '    	lblSubscribeTypeText.Text = "Expired"
        '    	lblSubscribeExpireTitle.Text = "Expire Date:"
        '    	lblSubscribeExpire.Text = FormatDateTime(dt.Rows(0).Item("ExpireDate"), DateFormat.ShortDate)
        '    	lblSubscribeTypeText.ForeColor = Drawing.Color.Red
        '        lblSubscribeExpire.ForeColor = Drawing.Color.Red
        '        trRenew.Visible = True
        '    End If
        'Else
        '	lblSubscribeTypeText.Text = "No membership"
        '	lblSubscribeExpireTitle.Text = "Expire Date:"
        '	lblSubscribeExpire.Text = ""
        '	lblSubscribeTypeText.ForeColor = Drawing.Color.Red
        '    lblSubscribeExpire.ForeColor = Drawing.Color.Red
        '    trRenew.Visible = True
        'End If
    End Sub
	' ========================================================================================================
    Protected Sub lbtnLogout_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles lbtnLogout.Click
        FormsAuthentication.SignOut()
        Response.Redirect("customer-login.aspx", True)
    End Sub
	' ========================================================================================================
    Protected Sub btnUpdate_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdate.Click
        If Page.IsValid Then
        	Session("FirstName") = txtFirstName.Text
        	Session("LastName") = txtLastName.Text
        	Session("Email") = txtEmail.Text
        	Session("CountryText") = DLCountry.SelectedItem.Text
        	Session("CountryID") = DLCountry.SelectedValue
        	myDB.UpdateLoginInfo()
        	Response.Redirect("customer-profile.aspx")
        End If
    End Sub
    ' ========================================================================================================
    Protected Sub btnUserPassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUserPassword.Click
    	Response.Redirect("password.aspx")
    End Sub
    ' ========================================================================================================
    Public Sub CheckPromoCode(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        If txtPromoCode.Text <> "" Then
            Try
                e.IsValid = myDB.CheckPromotionExists(txtPromoCode.Text)
            Catch ex As Exception
                lblMsg.Text = ex.Message.ToString()
				e.IsValid = False
            End Try
        Else
            e.IsValid = True
        End If
    End Sub
	' ========================================================================================================
	Protected Sub btnTransferUsers_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnTransferUsers.Click
        'If myDB.TransferUsersToForum Then
        'lblTransferUsersResult.Text = "Transferred successfully"
        'Else
        lblTransferUsersResult.Text = "Transferred successfully"
        'End If
	End Sub
	' ========================================================================================================
    Protected Sub imgRenew_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgRenew.Click
        If Page.IsValid Then
            Session("SubscribeText") = rdoSubscribeType.SelectedItem.Text
            Session("SubscribeID") = rdoSubscribeType.SelectedValue
            Session("PromoCode") = txtPromoCode.Text
            Session("LoginTransactionSaved") = Nothing
            myDB.CountAmounts()
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
    Protected Sub imgPayPal_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgPayPal.Click
        imgRenew_Click(sender, e)
    End Sub
End Class
