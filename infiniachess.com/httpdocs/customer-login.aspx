<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="customer-login.aspx.vb" Inherits="customer_login" title="Welcome to Perpetual Chess - Customer Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table width="90%" class="body">
        <tr>
            <td>
            <h2>Member Login</h2>
            <p>This area is for Members only to access their accounts. All activity will be 
                monitored and recorded.</p>
           
            <table align="left">
                <tr>
                    <td align="right">Login: </td>
                    <td><asp:TextBox ID="txtLogin" runat="server" size="15" Width="96px" TabIndex="1"></asp:TextBox>
                    <asp:requiredfieldvalidator  id="Requiredfieldvalidator4" runat="server" ErrorMessage="*" Display="Static" ControlToValidate="txtLogin"></asp:requiredfieldvalidator>
                  </td>
                </tr>
                
                <tr>
                    <td align="right">Password: </td>
                    <td><asp:TextBox ID="txtPwd" runat="server" size="15" Width="96px" TextMode="Password" TabIndex="1" ></asp:TextBox>
                    	<asp:requiredfieldvalidator  id="Requiredfieldvalidator1" runat="server" ErrorMessage="*" Display="Static" ControlToValidate="txtPwd"></asp:requiredfieldvalidator>
                    </td>
                </tr>
                
                <tr><td colspan="2" align="center"><asp:Label ID="txtError" runat="server" ForeColor="Red" TabIndex="1"></asp:Label></td></tr>
                
                <tr>
                	<td> </td>
                    <td align="left"><asp:Button ID="cmdSubmit" TabIndex="0" runat="server" Text="Sign In" /></td>
                </tr>
                <tr>
                <td></td>
                <td><a href="download.aspx">Register New User</a></td>
                </tr>
            </table>
            </td>
        </tr>
    </table>

</asp:Content>

