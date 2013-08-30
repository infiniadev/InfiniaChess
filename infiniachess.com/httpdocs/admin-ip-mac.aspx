<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" 
    CodeFile="admin-ip-mac.aspx.vb" Inherits="admin_ip_mac" title="Welcome to Infinia Chess - IP MAC Search" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder2" Runat="Server">
    <asp:Panel ID="pnlSearch" runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
        <asp:Label ID="lblError" runat="server" align="center" font-bold="true" ForeColor="Red" Text=""></asp:Label>    
        <table cellpadding="4" cellspacing=0>
            <tr>
                <td align="right">IP:</td>
                <td><asp:TextBox ID="txtIP" runat="server" ></asp:TextBox></td>
            </tr>
            <tr>
                <td align="right">MAC:</td>
                <td><asp:TextBox ID="txtMAC" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td></td>
                <td><asp:Button ID="btnSearch" runat="server" text="Search"/></td>
            </tr>
        </table>
    </asp:Panel>
    <br />
    <asp:Panel ID="pnlGrid" runat="server" BorderColor="Gray" BorderStyle="Solid">
        <asp:GridView ID="gridHistory" runat="server" AllowSorting="True"
            AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" 
            BorderStyle="None" BorderWidth="1px" CellPadding="3" 
            EmptyDataText="No Data Found" SelectedIndex="0">
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <RowStyle ForeColor="#000066" />
            <HeaderStyle BackColor="#00CCFF" />
            <Columns>
                <asp:HyperLinkField DataTextField="login" DataNavigateUrlFields="login" 
                    HeaderText="Login" ItemStyle-HorizontalAlign="Center"
                    DataNavigateUrlFormatString="admin-user.aspx?login={0}" />
                <asp:BoundField DataField="first_date" HeaderText="First Date" 
                    DataFormatString="{0:MMM dd, yyyy}"
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="last_date" HeaderText="Last Date" 
                    DataFormatString="{0:MMM dd, yyyy}"
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                <asp:BoundField DataField="co" HeaderText="Count" 
                    ItemStyle-HorizontalAlign="Center" >
                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                </asp:BoundField>
                
            </Columns>
        </asp:GridView>
     </asp:Panel>
</asp:Content>

