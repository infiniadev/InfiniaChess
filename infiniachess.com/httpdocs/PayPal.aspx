<!----------------------------------------------------------------------------
'
'  File:           PayPal.aspx
'
'  Facility:       The unit contains a payment form to be sent to PayPal.
'
'  Abstract:       It is used to generate a payment form and to send it to PayPal.
'
'  Environment:    VC 8.0
'
'  Author:         KB_Soft Group Ltd.
'
----------------------------------------------------------------------------->

<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PayPal.aspx.vb" Inherits="PayPal" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="payForm" method="post" action="<%Response.Write (URL)%>">
        <input type="hidden" name="cmd" value="<%Response.Write (cmd)%>" />
        <input type="hidden" name="business" value="<%Response.Write (business)%>" />
        <input type="hidden" name="item_name" value="<%Response.Write (item_name)%>" />
        <input type="hidden" name="item_number" value="<%Response.Write (item_number)%>" />
        <input type="hidden" name="amount" value="<%Response.Write (amount)%>" />
        <input type="hidden" name="no_shipping" value="<%Response.Write (no_shipping)%>" />
        <input type="hidden" name="return" value="<%Response.Write (return_url)%>" />
        <input type="hidden" name="rm" value="<%Response.Write (rm)%>" />
        <input type="hidden" name="notify_url" value="<%Response.Write (notify_url)%>" />
        <input type="hidden" name="cancel_return" value="<%Response.Write (cancel_url)%>" />
        <input type="hidden" name="currency_code" value="<%Response.Write (currency_code)%>" />
        <input type="hidden" name="custom" value="<%Response.Write (Login)%>" />
    </form>

    <script language="javascript">
    document.forms["payForm"].submit ();
    </script>

</body>
</html>
