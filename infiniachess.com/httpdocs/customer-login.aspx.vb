Imports System.Security.Cryptography

Partial Class customer_login
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not IsPostBack Then
            txtLogin.Text = Request("Login")
        End If
    End Sub
	' ========================================================================================================
    Protected Sub cmdSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmdSubmit.Click
    	Dim LoginID As Integer
        LoginID = myDB.GetLoginID(Trim(txtLogin.Text), Trim(txtPwd.Text))
        If LoginID <> 0 Then
            Session("LoginID") = LoginID
            Session("Login") = Trim(txtLogin.Text)
            Session("Password") = Trim(txtPwd.Text)

            If Session("AdminLevelRequired") <> Nothing Then
                Dim AdminLevelRequired As Integer = Session("AdminLevelRequired")
                Dim AdminLevel As Integer = myDB.GetAdminLevel(Session("Login"))
                If AdminLevel < AdminLevelRequired Then
                    Session("LoginID") = Nothing
                    txtError.Text = "You must have at least admin level " & AdminLevelRequired & _
                        " to complete this operation"
                    Return
                Else
                    Session("AdminLevel") = AdminLevel
                    Session("AdminLevelRequired") = Nothing
                End If
            End If

            If Session("LoginReturnURL") <> "" Then
                Dim ReturnURL = Session("LoginReturnURL")
                Session("LoginReturnURL") = Nothing
                Response.Redirect(ReturnURL)
            Else
                Response.Redirect("customer-profile.aspx")
            End If
        Else
            Session("LoginID") = Nothing
            txtError.Text = "Invalid UserName or Password"
        End If
    End Sub
	' ========================================================================================================
End Class
