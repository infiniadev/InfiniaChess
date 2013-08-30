Imports System
Imports System.Data
'Imports com.paypal.sdk.services
'Imports com.paypal.sdk.profiles
'Imports com.paypal.sdk.util

Imports System.Text
Imports System.Text.RegularExpressions
Imports System.Configuration
Imports System.Web.Security
Imports System.Net
Imports System.IO
' ========================================================================================================
Partial Class download_step2
    Inherits System.Web.UI.Page
    Dim myDB As New DBChess
    Dim ResultMSG As String
    ' ========================================================================================================
    Sub FillYears()
        Dim i As Integer
        ddlExpireYear.Items.Clear()
        ddlExpireYear.Items.Add(New ListItem(""))
        For i = 2009 To 2050
            ddlExpireYear.Items.Add(New ListItem(i, i))
        Next
    End Sub
    ' ========================================================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Session("Login") = Nothing Then
            Server.Transfer("customer-login.aspx")
        End If
        If Not IsPostBack Then
            lblAmountFull.Text = "$" & Session("AmountFull")
            lblAmountPromo.Text = "$" & Session("AmountPromo")
            lblAmount.Text = "$" & Session("Amount")

            myDB.FillStates(DLBillingState.Items)
            myDB.FillCountries(DLBillingCountry.Items)
            FillYears()
        End If

        trStateDropDown.Visible = (DLBillingCountry.SelectedItem.Text = "United States")
        trStateText.Visible = Not trStateDropDown.Visible
    End Sub
	' ========================================================================================================
    Protected Sub btnSubmit_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnSubmit.Click
        Session("NameOnCard") = txtNameOnCard.Text
        Session("CardType") = ddlCardType.SelectedValue
        Session("CardNumberFull") = txtCardNumber.Text
		Session("CardNumber") = Right(txtCardNumber.Text,4)
        Session("CardExpiry") = ddlExpireMonth.SelectedValue & "/" & ddlExpireYear.SelectedValue
        Session("CVV2") = txtCVV2.Text
        Session("BillingAddress") = txtBillingAddress.Text
        Session("BillingCity") = txtBillingCity.Text
        If trStateDropDown.Visible Then
            Session("BillingState") = DLBillingState.SelectedValue
        Else
            Session("BillingState") = txtBillingState.Text
        End If

        Session("BillingZip") = txtBillingZip.Text
        Session("BillingCountry") = DLBillingCountry.SelectedValue
        
        If ProcessPayPal() Then
            Server.Transfer("download-step3.aspx")
        Else
            lblMsg.Visible = True
            lblMsg.Text = "<br>Invalid Card Number or Type<br>" '& ResultMSG
        End If
    End Sub
	' ========================================================================================================
    Function ProcessPayPal() As Boolean
        Dim PayPal_APIUserName As String = "InfiniaChess1_api1.aol.com"
        Dim PayPal_APIPassword As String = "MLPYX8TEGADG7BF5"
        Dim PayPal_APISignature As String = "AF9XFh1Q4rNvPGyOMUmub6wfK6j4AUL5PzwsZEzFoF.mVsie04FhIC3E"

        Dim PaymentAction As String = "Authorization"
        Dim PaymentMethod As String = "DoDirectPayment"
        
        Dim gv_APIEndpoint As String = "https://api-3t.paypal.com/nvp"
        Dim gv_Version As String = "50"

        Dim nvpstr As String = _
        	"METHOD=" & PaymentMethod & _
        	"&USER=" & PayPal_APIUserName & _
        	"&PWD=" & PayPal_APIPassword & _
        	"&SIGNATURE=" & PayPal_APISignature & _
        	"&VERSION=" & gv_Version & _
        	"&PAYMENTACTION=" & PaymentAction & _
       		"&CreditCardType=" & Session("CardType") & _
       		"&ACCT=" & Session("CardNumberFull") & _
       		"&EXPDATE=" & Session("CardExpiry").Replace("/", "") & _
       		"&CVV2=" & Session("CVV2") & _
       		"&FIRSTNAME=" & Session("FirstName") & _
       		"&LASTNAME=" & Session("LastName") & _
       		"&STREET=" & Session("BillingAddress") & _
       		"&CITY=" & Session("BillingCity") & _
       		"&STATE=" & Session("BillingState") & _
       		"&ZIP=" & Session("BillingZip") & _
       		"&COUNTRY=" & Session("CountryText") & _
       		"&COUNTRYCODE=US" & _
       		"&CURRENCYCODE=USD" & _
       		"&IPADDRESS=" & Request.ServerVariables("REMOTE_ADDR") & _
       		"&DESC=Screen Name:" & Session("Login") & "-Membership Type:" & Session("SubscribeText") & _
       		"&SHIPTONAME=" & Session("NameOnCard") & _
       		"&SHIPTOSTREET=" & Session("BillingAddress") & _
       		"&SHIPTOCITY=" & Session("BillingCity") & _
       		"&SHIPTOSTATE=" & Session("BillingState") & _
       		"&SHIPTOZIP=" & Session("BillingZip") & _
       		"&SHIPTOCOUNTRYCODE=US" & _
       		"&SHIPTOPHONENUM=111-333-4444" & _
       		"&EMAIL=" & Session("Email") & _
			"&AMT=" & FormatCurrency(Session("Amount"))

        ' lblAmount.Text = nvpstr

        Dim result As [String] = ""
        Dim myWriter As StreamWriter = Nothing

        Dim objRequest As HttpWebRequest = CType(WebRequest.Create(gv_APIEndpoint), HttpWebRequest)
        objRequest.Method = "POST"
        objRequest.ContentLength = nvpstr.Length
        objRequest.ContentType = "application/x-www-form-urlencoded"

        Try
            myWriter = New StreamWriter(objRequest.GetRequestStream())
            myWriter.Write(nvpstr)
        Catch e As Exception
            ' lblAmountFull.Text = e.Message
            Return e.Message
        Finally
            myWriter.Close()
        End Try

        Dim objResponse As HttpWebResponse = CType(objRequest.GetResponse(), HttpWebResponse)
        Dim sr As New StreamReader(objResponse.GetResponseStream())
        result = sr.ReadToEnd()
        ResultMSG = result
        ' lblAmountFull.Text = ResultMSG
        sr.Close()

        myDB.InsertPayPalLog(nvpstr, result)
        Return InStr(result, "approved") <> 0 Or InStr(result, "Success") <> 0
    End Function
    ' ========================================================================================================
    Protected Sub imgRenew_Click(ByVal sender As Object, ByVal e As System.Web.UI.ImageClickEventArgs) Handles imgRenew.Click
        btnSubmit_Click(sender, e)
    End Sub
End Class
