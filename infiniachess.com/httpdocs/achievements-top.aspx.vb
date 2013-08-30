Imports System.Data

Partial Class achievements_top
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
    Sub GetData(ByVal p_Order As Integer)
        Dim dt As DataTable
        dt = myDB.GetTop100Achievements(p_Order)

        gridAch.DataSource = dt
        gridAch.DataBind()
    End Sub

    Protected Sub btnByScore_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnByScore.Click
        imgHeader.ImageUrl = "images/achtop100_by_score.jpg"
        GetData(0)
    End Sub

    Protected Sub btnQuantity_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnQuantity.Click
        imgHeader.ImageUrl = "images/achtop100_by_quantity.jpg"
        GetData(1)
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        btnByScore_Click(sender, e)
    End Sub
End Class
