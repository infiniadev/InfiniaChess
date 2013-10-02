
Partial Class confirmation
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim code As String = Request("code")
        myDB.Session = Session
        ' If String.IsNullOrEmpty(code) Then Return
        Dim message As String = myDB.ConfirmUser(code)
        Dim isSuccessful As Boolean = String.IsNullOrEmpty(message)
        lblSuccessful.Visible = isSuccessful
        lblErrorHeader.Visible = Not isSuccessful
        lblErrorMessage.Visible = Not isSuccessful
        lblErrorMessage.Text = message
    End Sub
End Class
