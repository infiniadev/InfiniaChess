Imports System
Imports System.Data

Partial Class admin_user
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess

    Sub RefreshBanButtons()
        Select Case ddlBanTypes.SelectedValue
            Case 1
                btnBan.Enabled = myDB.HaveRight(Session("Login"), "ban")
                btnUnban.Enabled = myDB.HaveRight(Session("Login"), "unban")
            Case 2
                btnBan.Enabled = myDB.HaveRight(Session("Login"), "mute")
                btnUnban.Enabled = myDB.HaveRight(Session("Login"), "unmute")
            Case 3
                btnBan.Enabled = myDB.HaveRight(Session("Login"), "event_ban")
                btnUnban.Enabled = myDB.HaveRight(Session("Login"), "event_unban")
            Case 5
                btnBan.Enabled = myDB.HaveRight(Session("Login"), "banprofile")
                btnUnban.Enabled = myDB.HaveRight(Session("Login"), "unbanprofile")
        End Select
    End Sub

    Sub RefreshBanGrid()
        Dim dt As DataTable
        dt = myDB.GetBanHistory(Session("ed_login"))
        gridBanHistory.DataSource = dt
        gridBanHistory.DataBind()
    End Sub

    Sub RefreshRatingGrid()
        Dim dt As DataTable
        If Session("ed_login_id") = Nothing Then
            dt = myDB.GetRatings(0)
        Else
            dt = myDB.GetRatings(Session("ed_login_id"))
        End If
        GridRatings.DataSource = dt
        GridRatings.DataBind()

        btnChangeRating.Enabled = myDB.HaveRight(Session("Login"), "setrating")
    End Sub

    Sub RefreshIpMacGrid()
        Dim dt As DataTable

        dt = myDB.GetLoginIp(Session("ed_login"))
        gridIP.DataSource = dt
        gridIP.DataBind()

        dt = myDB.GetLoginMac(Session("ed_login"))
        gridMac.DataSource = dt
        gridMac.DataBind()
    End Sub

    Sub RefreshNames()
        Dim dt As DataTable

        dt = myDB.GetNames(Session("ed_login"))
        gridNames.DataSource = dt
        gridNames.DataBind()
    End Sub

    Sub RefreshLoginHistory()
        Dim dt As DataTable

        dt = myDB.GetLoginHistory(Session("ed_login"), calFrom.SelectedDate, calTo.SelectedDate, _
            txtIP.Text, txtMAC.Text, txtVersion.Text)
        gridLoginHistory.DataSource = dt
        gridLoginHistory.DataBind()
    End Sub

    Sub RefreshGeneral()
        Dim dt As New DataTable
        Dim LoginID As Integer = Session("ed_login_id")
        dt = myDB.GetLogin(LoginID)
        lblID.Text = LoginID
        ddlAdminLevel.SelectedIndex = dt.Rows(0).Item("AdminLevel")
        txtTitle.Text = dt.Rows(0).Item("Title")

        btnChangeAdminLevel.Enabled = myDB.HaveRight(Session("Login"), "setadminlevel")
        btnChangeTitle.Enabled = myDB.HaveRight(Session("Login"), "changetitle")
    End Sub

    Sub Refresh()
        Select Case MultiView1.ActiveViewIndex
            Case 0
                RefreshGeneral()
            Case 1
                myDB.FillRatedTypes(ddlRatedType.Items)
                RefreshRatingGrid()
            Case 2
                RefreshBanGrid()
            Case 3
                RefreshIpMacGrid()
            Case 5
                RefreshLoginHistory()
        End Select
    End Sub

    Sub CheckAdminLevel()
        'If Session("Login") = "" Then
        'Session("Login") = "modest"
        'Session("AdminLevel") = 2
        'End If

        If Session("AdminLevel") < 1 Then
            Session("LoginReturnURL") = "admin-user.aspx"
            Session("AdminLevelRequired") = 1
            Response.Redirect("customer-login.aspx")
        End If
    End Sub

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim M As ASP.masterpage_master = Me.Master
        M.SetAdminLevel()
        myDB.Session = Session
        CheckAdminLevel()

        If IsPostBack Then Return

        Dim Login As String = Request("login")
        If Login = "" Then Login = Session("ed_login")
        If Login = "" Then
            Session("ed_login_id") = Nothing
            Return
        End If
        txtUser.Text = Login

        Session("ed_login") = Login

        Dim LoginID As Integer = myDB.GetLoginID(Login)
        If LoginID = 0 Then
            lblUser.Text = "Wrong User Name"
            lblUser.ForeColor = Drawing.Color.Red
            txtUser.Text = ""
            Return
        Else
            lblUser.Text = "User Management (" & Login & ")"
            lblUser.ForeColor = Drawing.Color.Black
            txtUser.Text = Login
        End If
        Session("ed_login_id") = LoginID

        calFrom.TodayDayStyle.Reset()
        calFrom.SelectedDate = Now().AddDays(-30).Date
        calFrom.VisibleDate = calFrom.SelectedDate
        calTo.TodayDayStyle.Reset()
        calTo.SelectedDate = CType(Now(), DateTime).Date
        calTo.VisibleDate = calTo.SelectedDate

        Refresh()
    End Sub

    Protected Sub Menu1_MenuItemClick(ByVal sender As Object, _
          ByVal e As MenuEventArgs) Handles Menu1.MenuItemClick
        MultiView1.ActiveViewIndex = Int32.Parse(e.Item.Value)
        e.Item.Selected = True
        Refresh()
    End Sub

    Protected Sub btnBan_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnBan.Click
        Dim sCommand As String
        Select Case ddlBanTypes.SelectedValue
            Case 1
                sCommand = "ban"
            Case 2
                sCommand = "mute"
            Case 3
                sCommand = "event_ban"
            Case 4
                sCommand = "banprofile"
        End Select
        If Not myDB.HaveRight(Session("Login"), sCommand) Then
            lblError.Text = "You have not got access to do this"
            Return
        End If
        If Not chkForever.Checked And txtHours.Text = "" Then
            lblError.Text = "Enter Hours or check Forever box"
        Else
            lblError.Text = ""
            Dim hours As Integer

            If chkForever.Checked Then
                hours = 100000
            Else
                hours = CInt(txtHours.Text)
            End If

            If myDB.ProcBanHistory(Session("ed_login"), Session("Login"), 1, ddlBanTypes.SelectedIndex + 1, hours, txtReason.Text) Then
                RefreshBanGrid()
                chkForever.Checked = False
                txtHours.Text = ""
                txtReason.Text = ""
            End If
        End If
    End Sub

    Protected Sub btnUnban_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUnban.Click
        Dim sCommand As String
        Select Case ddlBanTypes.SelectedValue
            Case 1
                sCommand = "unban"
            Case 2
                sCommand = "unmute"
            Case 3
                sCommand = "event_unban"
            Case 4
                sCommand = "unbanprofile"
        End Select
        If Not myDB.HaveRight(Session("Login"), sCommand) Then
            lblError.Text = "You have not got access to do this"
            Return
        End If
        If Not myDB.IsBanActive(Session("ed_login"), ddlBanTypes.SelectedIndex + 1) Then
            lblError.Text = "User is not banned with this ban type"
        Else
            lblError.Text = ""
            Dim admin = "urise"
            If myDB.ProcBanHistory(Session("ed_login"), admin, 2, ddlBanTypes.SelectedIndex + 1, 100000, "") Then
                RefreshBanGrid()
                chkForever.Checked = False
                txtHours.Text = ""
                txtReason.Text = ""
            End If
        End If
    End Sub

    Protected Sub gridBanHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gridBanHistory.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Return
        Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)

        If row("IsActive") = 0 Then
            e.Row.BackColor = Drawing.Color.LightGray
        Else
            e.Row.BackColor = Drawing.Color.LightGreen
        End If
    End Sub

    Protected Sub gridRatings_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles GridRatings.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Return
        Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)

        e.Row.Cells(1).Font.Bold = True
        If row("Provisional") Then
            e.Row.Cells(1).ForeColor = Drawing.Color.Red
        End If
    End Sub

    Protected Sub btnChangeRating_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChangeRating.Click
        If myDB.ProcSetRating(Session("ed_login"), CInt(txtRating.Text), ddlRatedType.SelectedIndex, chkProvisional.Checked) Then
            RefreshRatingGrid()
        End If
    End Sub

    Protected Sub btnLoginHistorySearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnLoginHistorySearch.Click
        RefreshLoginHistory()
    End Sub

    Protected Sub btnManage_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnManage.Click
        Session("ed_login") = txtUser.Text
        Response.Redirect("admin-user.aspx")
    End Sub

    Protected Sub btnChangeAdminLevel_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChangeAdminLevel.Click
        CheckAdminLevel()
        myDB.ChangeAdminLevel(Session("ed_login"), ddlAdminLevel.SelectedIndex)
        myDB.SaveCommandsUsage(Session("Login"), "@setadminlevel", _
            Session("ed_login") & " " & ddlAdminLevel.SelectedIndex)
        RefreshGeneral()
    End Sub

    Protected Sub btnChangeTitle_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChangeTitle.Click
        CheckAdminLevel()
        myDB.ChangeTitle(Session("ed_login"), txtTitle.Text)
        myDB.SaveCommandsUsage(Session("Login"), "@changetitle", _
            Session("ed_login") & " " & txtTitle.Text)
        RefreshGeneral()
    End Sub

    Protected Sub btnNamesSearch_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnNamesSearch.Click
        RefreshNames()
    End Sub

    Protected Sub gridLoginHistory_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gridLoginHistory.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Return
        Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)

        If row("res") = 0 Then
            e.Row.Cells(7).BackColor = Drawing.Color.LightGreen
        Else
            e.Row.Cells(7).BackColor = Drawing.Color.LightPink
        End If
    End Sub
End Class
