
Partial Class admin
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim M As ASP.masterpage_master = Me.Master
        M.SetAdminLevel()
        myDB.Session = Session
    End Sub

End Class
