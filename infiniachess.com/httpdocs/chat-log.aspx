<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false"
    CodeFile="chat-log.aspx.vb" Inherits="chat_log" title="Welcome to Perpetual Chess - Chat Log"%>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <h2>Chat Log</h2>
    <table style="width: 100%;">
        <tr>
            <td align="center" class="style1" style="width: 163px">
                <asp:Calendar ID="calFrom" runat="server" Caption="Date From"></asp:Calendar>
            </td>
            <td align="center" class="style2" style="width: 160px">
                <asp:Calendar ID="calTo" runat="server" Caption="Date To"></asp:Calendar>
            </td>
            <td>
                Login:<br />
                <asp:TextBox ID="txtLogin" runat="server"></asp:TextBox>
                <br />
                Place:<br />
                <asp:TextBox ID="txtPlace" runat="server"></asp:TextBox>
                <br />
                Text To Search:<br />
                <asp:TextBox ID="txtText" runat="server"></asp:TextBox>
                <br />
                <br />
                <asp:Button ID="btnSearch" runat="server" Text="Search" />
                <asp:Button ID="btnReset" runat="server" Text="Reset" />
            </td>
        </tr>
    </table>
        <asp:GridView ID="gridChat" runat="server" AutoGenerateColumns="False" 
        AllowPaging="True" BackColor="#00CCFF" PageSize="200">
            <Columns>
                <asp:BoundField DataField="dt" HeaderText="Date &amp; Time">
                    <ItemStyle BackColor="#CCFFCC" />
                </asp:BoundField>
                <asp:BoundField DataField="Place" HeaderText="Place" >
                    <ItemStyle BackColor="#FFFFCC" Font-Bold="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Login" HeaderText="User's Login">
                    <ItemStyle BackColor="#CCFFCC" Font-Bold="True" />
                </asp:BoundField>
                <asp:BoundField DataField="str" HeaderText="Text" >
                    <ItemStyle BackColor="#FFFFCC" />
                </asp:BoundField>
            </Columns>
        </asp:GridView>
    <br />
</asp:Content>
