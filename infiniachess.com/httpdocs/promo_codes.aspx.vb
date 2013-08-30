Imports System
Imports System.Data

Partial Class promo_codes
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess

    Enum SaveMode
        smInserting
        smEditing
    End Enum
    ' ========================================================================================================
    Sub CheckAdminLevel()
        If Session("AdminLevel") < 3 Then
            Session("LoginReturnURL") = "promo_codes.aspx"
            Session("AdminLevelRequired") = 3
            Response.Redirect("customer-login.aspx")
        End If
    End Sub
    ' ========================================================================================================
    Sub RefreshGrid()
        Dim dt As DataTable
        dt = myDB.GetPromoCodes

        gridPromoCodes.DataSource = dt
        gridPromoCodes.DataBind()
    End Sub
    ' ========================================================================================================
    Sub RefreshPromoCodeUsage()
        Dim dt As DataTable
        If lblID.Text <> "" Then
            dt = myDB.GetPromoCodeUsage(CInt(lblID.Text))
            gridUsage.DataSource = dt
            gridUsage.DataBind()
        End If
    End Sub
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        myDB.Session = Session
        If Not IsPostBack Then CheckAdminLevel()

        RefreshGrid()
        If Not IsPostBack Then
            Dim M As ASP.masterpage_master = Me.Master
            M.SetAdminLevel()
            If gridPromoCodes.Rows.Count > 0 Then
                FillEditFields(gridPromoCodes.SelectedIndex)
                RefreshPromoCodeUsage()
            End If
            If gridPromoCodes.Rows.Count > 0 Then
                gridPromoCodes.SelectedIndex = 0
            End If
        End If
    End Sub
    ' ========================================================================================================
    Sub FillEditFields(ByVal p_SelectedIndex As Integer)
        If p_SelectedIndex = -1 Then Return

        Dim row As DataRow = CType(gridPromoCodes.DataSource, DataTable).Rows(p_SelectedIndex)
        chkEnabled.Checked = row("enabled")
        lblPromoCodeOld.Text = row("code")
        txtPromoCode.Text = row("code")
        txtAmount.Text = CDbl(row("amount")).ToString("N2")
        calExpire.TodayDayStyle.Reset()
        calExpire.SelectedDate = CType(row("ExpireDate"), DateTime).Date
        calExpire.VisibleDate = calExpire.SelectedDate


        chkDelivered.Checked = row("delivered")
        txtComments.Text = row("comments")
        lblID.Text = row("id")
        lblAdminCreated.Text = row("AdminCreated")
        lblDateCreated.Text = CType(row("DateCreated"), DateTime).ToShortDateString()

        lblUseCount.Text = row("trans_cnt")
        lblAmountSpent.Text = CDbl(row("AmountSpent")).ToString("N2")
        lblAmountBalance.Text = CDbl(row("AmountBalance")).ToString("N2")
    End Sub
    ' ========================================================================================================
    Protected Sub gridPromoCodes_SelectedIndexChanging(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewSelectEventArgs) Handles gridPromoCodes.SelectedIndexChanging
        FillEditFields(e.NewSelectedIndex)
        RefreshPromoCodeUsage()
    End Sub
    ' ========================================================================================================
    Sub Save(ByVal p_ID As Integer)
        Dim Amount As Double = Math.Round(DBChess.Str2Double(txtAmount.Text), 2)
        If myDB.SavePromoCode(p_ID, txtPromoCode.Text, Amount, _
                chkEnabled.Checked, calExpire.SelectedDate, chkDelivered.Checked, _
                txtComments.Text) Then
            RefreshGrid()
        Else
            Response.Redirect("sqlerror.aspx")
        End If
    End Sub
    ' ========================================================================================================
    Protected Sub btnEdit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnEdit.Click
        If CheckInput(SaveMode.smEditing) Then Save(CInt(lblID.Text))
    End Sub
    ' ========================================================================================================
    Protected Sub btnInsert_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnInsert.Click
        If CheckInput(SaveMode.smInserting) Then Save(0)
    End Sub
    ' ========================================================================================================
    Public Shared Function GenerateRandomString(ByVal p_Len As Integer) As String
        Dim str As New StringBuilder("")
        Dim base As String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        Dim rand As New Random()
        Dim i As Integer

        For i = 1 To p_Len
            str.Append(base.Substring(rand.Next(1, base.Length), 1))
        Next
        Return str.ToString()
    End Function
    ' ========================================================================================================
    Protected Sub btnRandomCode_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnRandomCode.Click
        Dim code As String
        Do
            code = GenerateRandomString(12)
        Loop While myDB.CheckPromotionExists(code)
        txtPromoCode.Text = code
    End Sub
    ' ========================================================================================================
    Protected Sub btnDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        If gridPromoCodes.SelectedIndex = -1 Then
            lblError.Text = "Please, choose a record first"
        ElseIf CInt(lblUseCount.Text) > 0 Then
            lblError.Text = "You cannot delete promo code that has been used. Just disable it instead."
        Else
            lblError.Text = ""
            myDB.DeletePromoCode(CInt(lblID.Text))
            RefreshGrid()
        End If
    End Sub
    ' ========================================================================================================
    Function CheckInput(ByVal p_Mode As SaveMode) As Boolean
        If txtPromoCode.Text.Trim() = "" Then
            lblError.Text = "Enter non-empty code"
        ElseIf p_Mode = SaveMode.smInserting And myDB.CheckPromotionExists(txtPromoCode.Text) Then
            lblError.Text = "This code is already exists. Enter or generate another one."
        ElseIf Not DBChess.StrIsDoubleNumber(txtAmount.Text) Then
            lblError.Text = "Amount field must be valid number"
        ElseIf chkEnabled.Checked And calExpire.SelectedDate <= Today Then
            lblError.Text = "Select expire date more then today"
        ElseIf gridPromoCodes.Rows.Count > 0 And _
               DBChess.StrIsDoubleNumber(lblAmountSpent.Text) And _
               DBChess.Str2Double(txtAmount.Text) < DBChess.Str2Double(lblAmountSpent.Text) Then
            lblError.Text = "Amount cannot be less then amount already spent"
        ElseIf lblUseCount.Text <> "" And CInt(lblUseCount.Text) > 0 And _
               lblPromoCodeOld.Text <> txtPromoCode.Text Then
            lblError.Text = "You cannot change 'code' field of promo code that has been used"
        Else
            lblError.Text = ""
        End If
        Return (lblError.Text = "")
    End Function
    ' ========================================================================================================
    Protected Sub gridPromoCodes_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gridPromoCodes.RowDataBound
        If e.Row.RowType <> DataControlRowType.DataRow Then Return

        Dim MinSubscriptionPrice As Single = myDB.GetMinSubscriptionPrice
        Dim row As DataRowView = CType(e.Row.DataItem, DataRowView)

        If row("AmountBalance") < MinSubscriptionPrice Then
            e.Row.Cells(3).ForeColor = Drawing.Color.Red
        ElseIf row("AmountBalance") < row("Amount") Then
            e.Row.Cells(3).ForeColor = Drawing.Color.Blue
        End If

        If row("trans_cnt") > 0 Then
            e.Row.Cells(4).Font.Bold = True
            e.Row.Cells(4).ForeColor = Drawing.Color.Blue
        End If

        If row("ExpireDate") < Today Then
            e.Row.Cells(5).ForeColor = Drawing.Color.Red
        End If
    End Sub
End Class
