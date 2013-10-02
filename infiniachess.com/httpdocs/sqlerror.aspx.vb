Imports System.Security.Cryptography

Partial Class SqlErrorForm
    Inherits System.Web.UI.Page
	' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
    	lblError.Text = Session("SQLError")
    	lblSQL.Text = Session("LastSQL")
    End Sub
	' ========================================================================================================
End Class
