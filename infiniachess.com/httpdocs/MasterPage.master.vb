
Partial Class MasterMain
    Inherits System.Web.UI.MasterPage

    Public Sub SetAdminLevel()
        trUsual.Visible = False
        trAdmin.Visible = True
    End Sub
End Class

