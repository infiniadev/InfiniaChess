Imports System
Imports System.Data

Partial Class admin_ip_mac
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim M As ASP.masterpage_master = Me.Master
        M.SetAdminLevel()
        myDB.Session = Session
        If Request("ip") <> "" Or Request("mac") <> "" Then
            txtIP.Text = Request("ip")
            txtMAC.Text = Request("mac")
            Search()
        End If
    End Sub

    Sub Search()
        If txtIP.Text = "" And txtMAC.Text = "" Then
            lblError.Text = "Enter IP or MAC"
            Return
        End If
        lblError.Text = ""
        Dim dt As DataTable
        dt = myDB.GetIpMacHistory(txtIP.Text, txtMAC.Text)
        gridHistory.DataSource = dt
        gridHistory.DataBind()
    End Sub

    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        Search()
    End Sub
End Class
