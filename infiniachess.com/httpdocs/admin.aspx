<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" 
    CodeFile="admin.aspx.vb" Inherits="admin" title="Welcome to Infinia Chess - Admin Tasks" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <asp:Panel ID="pnlAdmin" runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
        <table cellpadding="4" cellspacing=0 align="center">
            <tr>
                <td align="center"><asp:Button ID="btnUser" runat="server" Text="User Management"/></td>
            </tr>
            <tr>
                <td align="center"><asp:Button ID="btnIpMac" runat="server" Text="IP MAC Search"/></td>
            </tr>
        </table>
    </asp:Panel>
</asp:Content>

