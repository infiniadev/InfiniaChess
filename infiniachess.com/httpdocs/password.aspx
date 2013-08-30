<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="password.aspx.vb" Inherits="password" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

	<asp:Label ID="lblMsg" runat="server" Visible="false" Font-Bold="true" ForeColor="Red"></asp:Label>
    <table width="90%" class="body">
        <tr>
            <td>
            <h2>Change Password</h2>
           
            <table align="center">
                <tr>
                    <td align="right">Username: </td>
                    <td valign=top>
                    	<asp:Label runat="server" ID="lblLogin"></asp:Label>
                    	<asp:TextBox runat="server" ID="txtLogin"></asp:TextBox>
                    </td>
                </tr>
                <tr>
					<td align="right">Old Password: </td>
                    <td valign=top><asp:TextBox runat="server" TextMode="Password" ID="txtOldPassword"></asp:TextBox></td>
                    <asp:CustomValidator ID="cvLoginPassword" runat="server" Display="Dynamic" OnServerValidate="CheckLoginPassword" SetFocusOnError="true" Text="Wrong Username or Password"></asp:CustomValidator>
                </tr>
                <tr>
					<td align="right">New Password: </td>
                    <td valign=top><asp:TextBox runat="server" TextMode="Password" ID="txtNewPassword" MAXLENGTH="16"></asp:TextBox></td>
                    <asp:requiredfieldvalidator Font-Size=7 id="reqNewPassword" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtNewPassword"></asp:requiredfieldvalidator>
                </tr>
                <tr>
					<td align="right">Repeat New Password: </td>
                    <td valign=top><asp:TextBox runat="server" TextMode="Password" ID="txtNewPassword2" MAXLENGTH="16"></asp:TextBox></td>
                    <asp:comparevalidator id="comp1" Font-Size=7 controltovalidate="txtNewPassword2" controltocompare="txtNewPassword"   ErrorMessage="Password Mismatch"   type="String" runat="server" />
                </tr>
                <tr>
					<td></td>
					<td align=left><asp:Button ID="btnChange" runat="server" Text="Change" /></td>						
				</tr>
            </table>
            </td>
        </tr>
    </table>
</asp:Content>