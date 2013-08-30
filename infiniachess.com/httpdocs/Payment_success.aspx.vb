Imports System.Net
Imports System.IO
Imports System.Globalization
Imports System.Configuration.ConfigurationManager
Imports System.Data

Partial Class Payment_success
    Inherits System.Web.UI.Page

    ' the parameters to be checked
    Dim myDB As New DBChess
    Private business As String = AppSettings("BusinessEmail")
    Private currency_code As String = AppSettings("CurrencyCode")
    Private URL As String = AppSettings("PayPalUrl")

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        myDB.Session = Session
        Dim strFormValues As String = Encoding.ASCII.GetString(Request.BinaryRead(Request.ContentLength))
        Dim strNewValue As String = ""

        ' Create the request back
        Dim req As HttpWebRequest = CType(WebRequest.Create(URL), HttpWebRequest)

        ' Set values for the request back
        req.Method = "POST"
        req.ContentType = "application/x-www-form-urlencoded"
        strNewValue = strFormValues + "&cmd=_notify-validate"
        req.ContentLength = strNewValue.Length

        ' Write the request back IPN strings
        Dim stOut As StreamWriter = New StreamWriter(req.GetRequestStream(), Encoding.ASCII)
        stOut.Write(strNewValue)
        stOut.Close()

        'send the request, read the response
        Dim strResponse As HttpWebResponse = CType(req.GetResponse(), HttpWebResponse)
        Dim IPNResponseStream As Stream = strResponse.GetResponseStream
        Dim encode As Encoding = System.Text.Encoding.GetEncoding("utf-8")
        Dim readStream As New StreamReader(IPNResponseStream, encode)

        Dim read(256) As [Char]
        ' Reads 256 characters at a time.
        Dim count As Integer = readStream.Read(read, 0, 256)
        Dim IPNResponse As New [String](read, 0, count)
        Dim Success As Boolean

        Success = IPNResponse = "VERIFIED" And Request("receiver_email") = business And _
            Request("txn_type") = "web_accept" And Not myDB.PayPalResponseExists(Request("txn_id")) And _
            (Request("payment_status") = "Completed" Or Request("pending_reason") = "intl")

        myDB.SavePayPalResponse(Success, Request("txn_id"), Request("txn_type"), _
                                Request("payer_email"), Request("receiver_email"), _
                                IPNResponse, Request("custom"), _
                                CDec(DBChess.Str2Double(Request("mc_gross"))), _
                                Request("mc_currency"))

        readStream.Close()
        strResponse.Close()
        Session("CardType") = "PayPal"
        Session("NameOnCard") = Request("first_name") & " " & Request("last_name")
        Response.Redirect("download-step3.aspx")
    End Sub
End Class
