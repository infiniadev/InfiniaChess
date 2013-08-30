Imports System.Net
Imports System.IO
Imports System.Globalization
Imports System.Configuration.ConfigurationManager
Imports System.Data
Imports System.Xml

Partial Class IPNHandler
    Inherits System.Web.UI.Page

    Private business As String = AppSettings("BusinessEmail")
    Private currency_code As String = AppSettings("CurrencyCode")

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    End Sub
End Class
