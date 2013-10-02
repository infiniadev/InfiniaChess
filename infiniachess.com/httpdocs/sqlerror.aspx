<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="sqlerror.aspx.vb" Inherits="sqlerrorform" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table width="90%" class="body">
        <tr>
            <td>
            <h2>SQL Error</h2>
           
            <table align="center">
                <tr>
                    <td align="right">Error: </td>
                    <td valign=top><asp:Label runat="server" ID="lblError"></asp:Label></td>
                </tr>
                
                <tr>
					<td align="right">SQL: </td>
                    <td valign=top><asp:Label runat="server" ID="lblSQL"></asp:Label></td>
                </tr>
            </table>
            </td>
        </tr>
    </table>
</asp:Content>