<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false"
    CodeFile="admin-user.aspx.vb" Inherits="admin_user" title="Welcome to Infinia Chess - User Administration Page"%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <h2><asp:Label runat="server" ID="lblUser" Text="User Management"></asp:Label></h2>
    <table>
    <tr>
        <td>
            Login:
            <asp:TextBox ID="txtUser" runat="server"></asp:TextBox>
            <asp:Button ID="btnManage" runat="server" Text="Manage"/>
        </td>
    </tr>
    <tr>
    <td>
    <asp:Menu
        ID="Menu1"
        Width="168px"
        runat="server"
        Orientation="Horizontal"
        StaticEnableDefaultPopOutImage="False"
        OnMenuItemClick="Menu1_MenuItemClick" BackColor="#CCFFFF" BorderColor="Gray" 
            BorderStyle="Solid" BorderWidth="1px" CssClass="AdminSelectBox" 
            Font-Bold="True" Font-Size="Larger" 
            StaticTopSeparatorImageUrl="~/images/ver_separator01.bmp">
        <Items>
            <asp:MenuItem Text="General" Value="0"></asp:MenuItem>
            <asp:MenuItem Text="Rating" Value="1"></asp:MenuItem>
            <asp:MenuItem Text="Bans" Value="2"></asp:MenuItem>
            <asp:MenuItem Text="IP & MAC" Value="3"></asp:MenuItem>
            <asp:MenuItem Text="Names" Value="4"></asp:MenuItem>
            <asp:MenuItem Text="Login History" Value="5"></asp:MenuItem>
            <asp:MenuItem Text=" " Value="-1"></asp:MenuItem>
        </Items>
    </asp:Menu>
    <asp:Label ID="lblError" runat="server" align="center" font-bold="true" forecolor="Red" Text=""></asp:Label>
    
    <asp:MultiView 
        ID="MultiView1"
        runat="server"
        ActiveViewIndex="0"  >
       <asp:View ID="Tab1" runat="server"  >
            <table width="600" cellpadding="5" cellspacing="0">
                <tr>
                    <td align="right">ID: </td>
                    <td><asp:Label runat="server" ID="lblID" Font-Bold="true"></asp:Label></td>
                </tr>
                <tr>
                    <td align="right">Admin Level: </td> 
                    <td><asp:DropDownList ID="ddlAdminLevel" runat="server">
                            <asp:ListItem Value="0">None</asp:ListItem>
                            <asp:ListItem Value="1">Helper</asp:ListItem>
                            <asp:ListItem Value="2">Admin</asp:ListItem>
                            <asp:ListItem Value="3">Super Admin</asp:ListItem>
                        </asp:DropDownList>
                        <asp:Button ID="btnChangeAdminLevel" runat="server" text="Change"/>
                    </td>
                </tr>
                <tr>
                    <td align="right">Title: </td>
                    <td>
                        <asp:TextBox ID="txtTitle" runat="server" MaxLength="3"></asp:TextBox>
                        <asp:Button ID="btnChangeTitle" runat="server" text="Change"/>
                    </td>
                </tr>
            </table>
         </asp:View>
        <asp:View ID="Tab2" runat="server">
            <asp:Panel ID="pnlRating" runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
                <table cellpadding="4" cellspacing=0>
                    <tr>
                        <td align="right">Type:</td>
                        <td>
                            <asp:DropDownList ID="ddlRatedType" runat="server"></asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Rating: </td>
                        <td>
                            <asp:TextBox ID="txtRating" runat="server"></asp:TextBox>
                            <asp:RegularExpressionValidator  ID="regRating" Font-Size="7" Font-Names="Arial"  ControlToValidate="txtRating" Runat="server" ErrorMessage="Rating must be the number" Display="Dynamic" ValidationExpression="\d*" ></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <asp:CheckBox ID="chkProvisional" runat="server" text="Provisional"/>
                        </td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><asp:Button ID="btnChangeRating" runat="server" Text="Change"/></td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlRatingTable" runat="server" BorderColor="Gray" BorderStyle="Solid">
                    <asp:GridView ID="GridRatings" runat="server" AllowSorting="True" width="100%" 
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                        EmptyDataText="No Data Found" SelectedIndex="0">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <RowStyle ForeColor="#000066" />
                        <HeaderStyle BackColor="#00CCFF" />
                        <Columns>
                            <asp:BoundField DataField="RatedName" HeaderText="Rating Type"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Rating" HeaderText="Rating" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Provisional" HeaderText="Provisional" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="RatedScore" HeaderText="Rated Results" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="UnratedScore" HeaderText="Unrated Results" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
            </asp:Panel>
        </asp:View>
        <asp:View ID="Tab3" runat="server">
            <asp:Panel runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
                <table cellpadding="4" cellspacing=0>
                    <tr>
                        <td align="right">Type:</td>
                        <td>
                            <asp:DropDownList ID="ddlBanTypes" runat="server">
                                <asp:ListItem Value="1">Ban</asp:ListItem>
                                <asp:ListItem Value="2">Mute</asp:ListItem>
                                <asp:ListItem Value="3">Event Ban</asp:ListItem>
                                <asp:ListItem Value="5">Profile Ban</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Hours:</td>
                        <td>
                            <asp:TextBox ID="txtHours" runat="server"></asp:TextBox>
                            <asp:RegularExpressionValidator  ID="regHours" Font-Size="7" Font-Names="Arial"  ControlToValidate="txtHours" Runat="server" ErrorMessage="Hours must be the number" Display="Dynamic" ValidationExpression="\d*" ></asp:RegularExpressionValidator>
                            <asp:CheckBox ID="chkForever" runat="server" text="Forever"/>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Admin Reason:</td>
                        <td>
                            <asp:TextBox ID="txtReason" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right"><asp:Button ID="btnBan" runat="server" Text="Ban"/></td>
                        <td><asp:Button ID="btnUnban" runat="server" Text="Unban"/></td>
                    </tr>
                </table>
            </asp:Panel>
            <br />
            <asp:Panel runat="server" BorderColor="Gray" BorderStyle="Solid">
                    <asp:GridView ID="gridBanHistory" runat="server" AllowSorting="True"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" 
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                        EmptyDataText="No Data Found" SelectedIndex="0">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <RowStyle ForeColor="#000066" />
                        <HeaderStyle BackColor="#00CCFF" />
                        <Columns>
                            <asp:BoundField DataField="IsActive" HeaderText="Ban Type" 
                                Visible="false"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="BanTypeName" HeaderText="Ban Type" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="Admin" HeaderText="Admin" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="date_" HeaderText="Date" 
                                DataFormatString="{0:MMM dd, yyyy}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="HoursText" HeaderText="Hours" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="AdminReason" HeaderText="Admin Reason" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="UnbanDate" HeaderText="Unban Date" 
                                DataFormatString="{0:MMM dd, yyyy}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="UnbanAdmin" HeaderText="Unban Admin" 
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
             </asp:Panel>
        </asp:View>
        <asp:View ID="Tab4" runat="server">
            <table width="100%" cellspacing="5">
                <tr>
                    <td align="left" valign="top">
                    <asp:GridView ID="gridIP" runat="server" AllowSorting="True" width="100%" valign="top"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" PageSize="200"
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                        EmptyDataText="No Data Found" SelectedIndex="0">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <RowStyle ForeColor="#000066" />
                        <HeaderStyle BackColor="#00CCFF" />
                        <Columns>
                            <asp:HyperLinkField DataTextField="ip_address" DataNavigateUrlFields="ip_address" 
                                HeaderText="IP-Address" ItemStyle-HorizontalAlign="Center"
                                DataNavigateUrlFormatString="admin-ip-mac.aspx?ip={0}" />
                            <asp:BoundField DataField="first_date" HeaderText="first_date" 
                                DataFormatString="{0:MMM dd, yyyy}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="last_date" HeaderText="last_date" 
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
                    </td>
                    <td align="left" valign="top">
                    <asp:GridView ID="gridMac" runat="server" AllowSorting="True" width="100%" valign="top"
                        AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" PageSize="200"
                        BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                        EmptyDataText="No Data Found" SelectedIndex="0">
                        <FooterStyle BackColor="White" ForeColor="#000066" />
                        <RowStyle ForeColor="#000066" />
                        <HeaderStyle BackColor="#00CCFF" />
                        <Columns>
                            <asp:HyperLinkField DataTextField="mac_address" DataNavigateUrlFields="mac_address" 
                                HeaderText="MAC-Address" ItemStyle-HorizontalAlign="Center"
                                DataNavigateUrlFormatString="admin-ip-mac.aspx?mac={0}" />
                            <asp:BoundField DataField="first_date" HeaderText="first_date" 
                                DataFormatString="{0:MMM dd, yyyy}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                            </asp:BoundField>
                            <asp:BoundField DataField="last_date" HeaderText="last_date" 
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
                    </td>
                </tr>
            </table>
        </asp:View>
        <asp:View ID="Tab5" runat="server">
            <br />
            <asp:Panel ID="pnlNames" runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
                <p>This list is created on the base of general ip and mac addresses. </p>
                <p>Only logins from Jan 01, 2009 are used.</p>
                <p><p><span style="color:red">Warning: this report does not give 100% guarantee, it's just information for think. </span> </p>
                <asp:Button ID="btnNamesSearch" runat="server" Text="Search"/>
                <br />
            </asp:Panel>
            <br />
            <asp:GridView ID="gridNames" runat="server" AllowSorting="True" width="100%" valign="top"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" PageSize="200"
                BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                EmptyDataText="No Data Found" SelectedIndex="0">
                <FooterStyle BackColor="White" ForeColor="#000066" />
                <RowStyle ForeColor="#000066" />
                <HeaderStyle BackColor="#00CCFF" />
                <Columns>
                    <asp:HyperLinkField DataTextField="login" DataNavigateUrlFields="login" 
                        HeaderText="Login" ItemStyle-HorizontalAlign="Center"
                        DataNavigateUrlFormatString="admin-user.aspx?login={0}" />
                    <asp:BoundField DataField="ip_cnt" HeaderText="Joint IP Count" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="mac_cnt" HeaderText="Joint MAC Count" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="co" HeaderText="Login Count" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </asp:View>
        <asp:View ID="Tab6" runat="server">
            <asp:Panel ID="pnlLoginHistory" runat="server" BackColor="#EEEEEE" BorderColor="Gray" BorderStyle="Solid">
                <table style="width: 100%;">
                <tr>
                    <td align="center" class="style1" style="width: 163px">
                        <asp:Calendar ID="calFrom" runat="server" Caption="Date From"></asp:Calendar>
                    </td>
                    <td align="center" class="style2" style="width: 160px">
                        <asp:Calendar ID="calTo" runat="server" Caption="Date To"></asp:Calendar>
                    </td>
                    <td>
                        IP Address:<br />
                        <asp:TextBox ID="txtIP" runat="server"></asp:TextBox>
                        <br />
                        MAC Address:<br />
                        <asp:TextBox ID="txtMAC" runat="server"></asp:TextBox>
                        <br />
                        Version:<br />
                        <asp:TextBox ID="txtVersion" runat="server"></asp:TextBox>
                        <br />
                        <br />
                        <asp:Button ID="btnLoginHistorySearch" runat="server" Text="Search" />
                        <asp:Button ID="btnLoginHistoryReset" runat="server" Text="Reset" />
                    </td>
                </tr>
            </table>
            </asp:Panel>
            <br />
            <asp:GridView ID="gridLoginHistory" runat="server" AllowSorting="True" width="100%" valign="top"
                AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" PageSize="200"
                BorderStyle="None" BorderWidth="1px" CellPadding="3" 
                EmptyDataText="No Data Found" SelectedIndex="0">
                <FooterStyle BackColor="White" ForeColor="#000066" />
                <RowStyle ForeColor="#000066" />
                <HeaderStyle BackColor="#00CCFF" />
                <Columns>
                    <asp:BoundField DataField="LoginDate" HeaderText="Login Date" 
                                DataFormatString="{0:MMM dd, yyyy HH:mm}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="LogoutDate" HeaderText="Logout Date" 
                                DataFormatString="{0:MMM dd, yyyy HH:mm}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="LoginMinutes" HeaderText="Login Time (minutes)" 
                                DataFormatString="{0:F0}"
                                ItemStyle-HorizontalAlign="Center" >
                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:HyperLinkField DataTextField="ip_address" DataNavigateUrlFields="ip_address" 
                        HeaderText="IP-Address" ItemStyle-HorizontalAlign="Center"
                        DataNavigateUrlFormatString="admin-ip-mac.aspx?mac={0}" />
                    <asp:HyperLinkField DataTextField="mac" DataNavigateUrlFields="mac" 
                        HeaderText="MAC-Address" ItemStyle-HorizontalAlign="Center"
                        DataNavigateUrlFormatString="admin-ip-mac.aspx?mac={0}" />
                    <asp:BoundField DataField="mac" HeaderText="MAC Address" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="version" HeaderText="Version" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="result_name" HeaderText="Result" 
                        ItemStyle-HorizontalAlign="Center" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </asp:View>
    </asp:MultiView>
    </td>
    </tr>
    </table>

</asp:Content>
