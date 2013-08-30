Imports System.Configuration.ConfigurationManager
Imports System.Globalization

Partial Class PayPal
    Inherits System.Web.UI.Page
    Protected cmd As String = "_xclick"
    Protected business As String = AppSettings("BusinessEmail")
    Protected item_name As String
    Protected item_number As Integer
    Protected amount As String
    Protected return_url As String = AppSettings("ReturnUrl")
    Protected notify_url As String = AppSettings("NotifyUrl")
    Protected cancel_url As String = AppSettings("CancelPurchaseUrl")
    Protected currency_code As String = AppSettings("CurrencyCode")
    Protected no_shipping As String = "1"
    Protected URL As String = AppSettings("PayPalUrl")
    Protected Login As String
    Protected rm As String = "2"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        item_name = Session("SubscribeText")
        item_number = Session("SubscribeID")
        Login = Session("Login")

        Dim ci As CultureInfo = New CultureInfo("en-us")
        Dim decAmount As Decimal = CType(Session("Amount"), Decimal)
        amount = decAmount.ToString(ci)
    End Sub
End Class
