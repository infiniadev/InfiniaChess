<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false"
    CodeFile="download.aspx.vb" Inherits="download" Title="Welcome to Infinia Chess - Registration" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <style type="text/css">
        .block1
        {
            background: #eee;
            padding: 5px;
            padding-right: 20px;
            border: solid 1px black;
            float: left;
            top: 5px;
        }
    </style>
    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="body">
        <tr>
            <td align="left" valign="top">
                <h2>
                    We welcome you to join the fastest growing Chess Site on the Internet.</h2>
                <p>
                    <strong>If you find you cannot create an account - Please go to &quot;Contact Us&quot;and
                        follow the instructions there. </strong><strong>We apologize for any inconvenience.
                            &quot;Contact Us&quot; and we will make the account for you. </strong>.</p>
                <p>
                    <strong>PLEASE NOTE:</strong> In the section <strong>MEMBER INFORMATION</strong>
                    your user name<strong> must not begin with a number</strong>, must have <strong>at least
                        3 characters,</strong><strong> cannot exceed 11 characters, cannot contain spaces
                    </strong>and <strong>must be in english.</strong></p>
                <p>
                    * = Mandatory Field
                    <asp:Label ID="lblMsg" runat="server" Visible="false" Font-Bold="true" ForeColor="Red"></asp:Label>
                </p>
                <table width="90%" cellpadding="0" cellspacing="0" border="1" bordercolor="black"
                    align="center">
                    <tr>
                        <td>
                            <table width="100%" cellpadding="5" cellspacing="0" border="0" bordercolor="black">
                                <tr>
                                    <td colspan="2" bgcolor="black">
                                        <font color="white" size="3" face="arial"><b>Contact Information</b></font>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * First Name:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtFirstName" runat="server" MaxLength="127"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtFirstName"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * Last Name:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtLastName" runat="server" MaxLength="127"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator1" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtLastName"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * Country:
                                    </td>
                                    <td valign="top">
                                        <asp:DropDownList runat="server" ID="DLCountry" AutoPostBack="True">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator29" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="DLCountry"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * Email:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtEmail" runat="server" MaxLength="255"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator19" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator Font-Size="7" ID="RegularExpressionValidator2" CssClass="textfield"
                                            ControlToValidate="txtEmail" Display="Dynamic" runat="server" ErrorMessage="InValid Email"
                                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                        <asp:CustomValidator ID="cvldEmailAllowed" runat="server" Display="Dynamic" OnServerValidate="CheckEmailAllowed"
                                            SetFocusOnError="true" Text="Email Already Exists"></asp:CustomValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" bgcolor="black">
                                        <font color="white" size="3" face="arial"><b>Member Information</b></font>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * User Name:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtLogin" runat="server" MaxLength="255"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator21" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtLogin"></asp:RequiredFieldValidator>
                                        <asp:CustomValidator ID="cvldLoginAllowed" runat="server" Display="Dynamic" OnServerValidate="CheckLoginAllowed"
                                            SetFocusOnError="true" Text="Username Already Exists"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cvldLoginCurse" runat="server" Display="Dynamic" OnServerValidate="CheckLoginCurse"
                                            SetFocusOnError="true" Text="User name cannot contain dirty words"></asp:CustomValidator>
                                        <asp:CustomValidator ID="cvldLoginGuest" runat="server" Display="Dynamic" OnServerValidate="CheckLoginGuest"
                                            SetFocusOnError="true" Text="User name cannot contain the word 'guest'"></asp:CustomValidator>
                                        <asp:RegularExpressionValidator ID="REVLoginFormat1" Font-Size="7" Font-Names="Arial"
                                            ControlToValidate="txtLogin" runat="server" ErrorMessage="User name can consist of english letters and digits only"
                                            Display="Dynamic" ValidationExpression="[a-zA-Z0-9]+"></asp:RegularExpressionValidator>
                                        <asp:RegularExpressionValidator ID="REVLoginFormat2" Font-Size="7" Font-Names="Arial"
                                            ControlToValidate="txtLogin" runat="server" ErrorMessage="User name must contain from 3 to 11 symbols"
                                            Display="Dynamic" ValidationExpression="\S{3,11}"></asp:RegularExpressionValidator>
                                        <asp:RegularExpressionValidator ID="REVLoginFormat3" Font-Size="7" Font-Names="Arial"
                                            ControlToValidate="txtLogin" runat="server" ErrorMessage="User name cannot start from digit"
                                            Display="Dynamic" ValidationExpression="[a-zA-Z]\S*"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * Password:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtPassword" TextMode="Password" runat="server" MaxLength="15"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidator22" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtPassword"></asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" valign="top">
                                        * Repeat Password:
                                    </td>
                                    <td valign="top">
                                        <asp:TextBox ID="txtCPassword" TextMode="Password" runat="server" MaxLength="15"></asp:TextBox>
                                        <asp:RequiredFieldValidator Font-Size="7" ID="Requiredfieldvalidatoyr23" runat="server"
                                            ErrorMessage="Required Field" CssClass="textfield" Display="Dynamic" ControlToValidate="txtCPassword"></asp:RequiredFieldValidator>
                                        <asp:CompareValidator ID="comp1" Font-Size="7" ControlToValidate="txtCPassword" ControlToCompare="txtPassword"
                                            ErrorMessage="Password Mismatch" Type="String" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td />
                                    <td valign="top">
                                        <asp:Button ID="btnNext" runat="server" Text="Next" />
                                    </td>
                                </tr>
                            </table>
                            <br>
                            <br>
                        </td>
                    </tr>
                </table>
                <br>
                <br>
            </td>
        </tr>
    </table>
</asp:Content>
