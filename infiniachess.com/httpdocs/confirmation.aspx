<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="confirmation.aspx.vb" Inherits="confirmation" Title="Welcome to Infinia Chess - Confirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="body">
        <tr>
            <td align="left" valign="top">
                <h2>Membership</h2>
                <p>
                    <asp:Label runat="server" ID="lblSuccessful" Font-Bold="True" Text="You have successfully completed registration!"></asp:Label></select>
                    <asp:Label runat="server" ID="lblErrorHeader" Font-Bold="True" Visible="false"
                        ForeColor="Red" Text="Confirmation is not successful!"></asp:Label></select>
                </p>
                <p>
                    <asp:Label runat="server" ID="lblErrorMessage" Visible="false"
                        Text=""></asp:Label></select>
                </p>

                <p><a href="index.html">Click Here To Go To Main Page</a></p>
            </td>
        </tr>
    </table>
</asp:Content>
