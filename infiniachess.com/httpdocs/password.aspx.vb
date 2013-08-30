Imports System.Security.Cryptography
' ========================================================================================================
Partial Class Password
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
	' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    	myDB.Session = Session
    	If Not IsPostBack Then
    		lblLogin.Text = Session("Login")
    		txtLogin.Text = Session("Login")
    		txtLogin.Visible = Session("AdminLevel") >= 2
    		lblLogin.Visible = not txtLogin.Visible
    		txtOldPassword.Visible = Session("AdminLevel") < 2
    	End If
    End Sub
	' ========================================================================================================
    Public Sub CheckLoginPassword(ByVal sender As Object, ByVal e As ServerValidateEventArgs)
        Try
            e.IsValid = not txtOldPassword.Visible or myDB.CheckLoginPassword(txtLogin.Text, txtOldPassword.Text)
        Catch ex As Exception
            lblMsg.Text = ex.Message.ToString()
        End Try
    End Sub
    ' ========================================================================================================
    Protected Sub btnChange_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChange.Click
    	If Page.IsValid Then
    		Dim vLogin as String
    	
    		If txtLogin.Visible Then
    			vLogin = txtLogin.Text
    		Else
    			vLogin = lblLogin.Text
    		End If
    	
    		If myDB.ChangePassword(vLogin, txtNewPassword.Text) Then
    			Response.Redirect("customer-profile.aspx")
    		Else
    			Response.Redirect("sqlerror.aspx")
    		End If
    	End If
    End Sub
    ' ========================================================================================================
End Class
