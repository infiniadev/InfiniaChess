<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false"
    CodeFile="promo_codes.aspx.vb" Inherits="promo_codes" title="Welcome to Perpetual Chess - Promo Code"%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <h2>Promo Codes</h2>
    <style type="text/css">
        .block1 { 
	        background: #eee;
	        padding: 5px;
	        padding-right: 20px; 
	        border: solid 1px black; 
	        float: left;
	        top: 5px;
        }
    </style> 
    <table>
    <tr>
    <td width="60%" valign="top">
    <asp:GridView ID="gridPromoCodes" runat="server" AllowSorting="True"
        DataKeyNames="ID"
        AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" 
        BorderStyle="None" BorderWidth="1px" CellPadding="3" 
        EmptyDataText="No Data Found" SelectedIndex="0">
        <FooterStyle BackColor="White" ForeColor="#000066" />
        <RowStyle ForeColor="#000066" />
        <Columns>
            <asp:CheckBoxField DataField="Enabled" HeaderText="Enabled" 
                ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:CheckBoxField>
            <asp:BoundField DataField="Code" HeaderText="Code" 
                ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="Amount" HeaderText="Amount" 
                DataFormatString="${0:F2}" ItemStyle-Font-Bold="True" >
<ItemStyle Font-Bold="True"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="AmountBalance" HeaderText="Amount Rest" 
                DataFormatString="${0:F2}" htmlencode="false" ItemStyle-Font-Bold="True" >
<ItemStyle Font-Bold="True"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="trans_cnt" HeaderText="Use Count" 
                ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:BoundField DataField="ExpireDate" HeaderText="Expire Date" 
                DataFormatString="{0:MMM dd, yyyy}" ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:BoundField>
            <asp:CheckBoxField DataField="Delivered" HeaderText="Delivered" 
                ItemStyle-HorizontalAlign="Center" >
<ItemStyle HorizontalAlign="Center"></ItemStyle>
            </asp:CheckBoxField>
            <asp:BoundField DataField="Comments" HeaderText="Comments" />
            <asp:CommandField ShowSelectButton="True" />
        </Columns>
        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
        <SelectedRowStyle BackColor="#CCCCCC" Font-Bold="False" />
        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
    </asp:GridView>
    </td>
    <td width="50%" valign="top">
    <div class="block1">
    <table style="width: 300px">
        <tr>
            <td>
                ID: <asp:Label ID="lblID" runat="server" Font-Bold="true"></asp:Label><br />
                Admin Created: <asp:Label ID="lblAdminCreated" runat="server" Font-Bold="true"></asp:Label><br />
                On: <asp:Label ID="lblDateCreated" runat="server" Font-Bold="true"></asp:Label><br /><br />
                <asp:CheckBox ID="chkEnabled" runat="server" Text="Enabled"/><br />
                Code:<br />
                <asp:Label ID="lblPromoCodeOld" runat="server" Visible="false"></asp:Label>
                <asp:TextBox ID="txtPromoCode" runat="server"></asp:TextBox><br />
                <asp:Button ID="btnRandomCode" runat="server" text="Generate Random"/>
                <br />
                Amount:<br />
                <asp:TextBox ID="txtAmount" runat="server"></asp:TextBox>
                <br /><br />
                <asp:CheckBox ID="chkDelivered" runat="server" Text="Delivered" />
            </td>
            <td align="center" style="width: 163px">
                <asp:Calendar ID="calExpire" runat="server" Caption="Expire Date"></asp:Calendar>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Comments:<br />
                <asp:TextBox ID="txtComments" runat="server" TextMode="MultiLine" Height="85px" 
                    Width="307px"></asp:TextBox>
                <br />
                <br />
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <asp:Label ID="lblError" runat="server" ForeColor="Red" Font-Bold="true"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <table>
                    <tr>
                        <td width="40" align="left">
                            <asp:Button ID="btnEdit" runat="server" Text="Edit Selected" />
                        </td>
                        <td width="40" align="left">
                            <asp:Button ID="btnDelete" runat="server" Text="Delete Selected" 
                                OnClientClick="return confirm('Are you sure you want to delete the record?');"/>
                        </td>
                        <td width="40" align="left">
                            <asp:Button ID="btnInsert" runat="server" Text="Insert New" />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    </div>
    <div id="divUsage" class="block1">
        <h3>Selected Code Usage</h3>
        Use Count: <asp:Label ID="lblUseCount" runat="server" Font-Bold="true"></asp:Label><br />
        Amount Spent: <asp:Label ID="lblAmountSpent" runat="server" Font-Bold="true"></asp:Label><br />
        Amount Rest: <asp:Label ID="lblAmountBalance" runat="server" Font-Bold="true"></asp:Label><br />
        <br />
        <asp:GridView ID="gridUsage" runat="server" AllowSorting="True"
            AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" 
            BorderStyle="None" BorderWidth="1px" CellPadding="3" 
            EmptyDataText="No Transactions Found">
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <RowStyle ForeColor="#000066" />
            <Columns>
                <asp:BoundField DataField="Login" HeaderText="Login" />
                <asp:BoundField DataField="TransactionDate" HeaderText="Date" 
                    DataFormatString="{0:MMM dd, yyyy}">
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="PromoAmount" HeaderText="Amount" DataFormatString="${0:F2}" htmlencode="false"/>
            </Columns>
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
        </asp:GridView>
    </div>
    </td>
    </tr>
    </table>
    <br /><br />
</asp:Content>