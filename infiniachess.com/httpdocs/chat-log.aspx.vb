Imports System.Data

Partial Class chat_log
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess

    ' ========================================================================================================
    Protected Sub btnSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSearch.Click
        CheckAdminLevel()

        Dim dt As DataTable
        Dim SQL As String = ""
        dt = myDB.GetChat(calFrom.SelectedDate, calTo.SelectedDate, txtLogin.Text, _
                          txtPlace.Text, txtText.Text, SQL)

        gridChat.DataSource = dt
        gridChat.DataBind()
    End Sub
    ' ========================================================================================================
    Protected Sub btnReset_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnReset.Click
        calFrom.TodayDayStyle.Reset()
        calFrom.SelectedDate = Now().Date
        calFrom.VisibleDate = calFrom.SelectedDate
        calTo.TodayDayStyle.Reset()
        calTo.SelectedDate = calFrom.SelectedDate
        calTo.VisibleDate = calTo.SelectedDate
        txtLogin.Text = ""
        txtPlace.Text = ""
        txtText.Text = ""
    End Sub
    ' ========================================================================================================
    Sub CheckAdminLevel()
        If Session("AdminLevel") < 3 Then
            Session("LoginReturnURL") = "chat-log.aspx"
            Session("AdminLevelRequired") = 3
            Response.Redirect("customer-login.aspx")
        End If
    End Sub
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim M As ASP.masterpage_master = Me.Master
        M.SetAdminLevel()
        myDB.Session = Session
        If Not IsPostBack Then
            CheckAdminLevel()
            btnReset_Click(sender, e)
        End If
    End Sub
    ' ========================================================================================================
    Protected Sub gridChat_PageIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewPageEventArgs) Handles gridChat.PageIndexChanging
        gridChat.PageIndex = e.NewPageIndex
        btnSearch_Click(sender, e)
    End Sub
End Class
