<%@ Page Language="VB" aspcompat="true" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="download-step2.aspx.vb" Inherits="download_step2" title="Welcome to Perpetual Chess - Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    
    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="body">
            <tr>
              <td align="left" valign="top">
				<h2>Payment</h2>
				
		
				* = Mandatory Field
				<center><asp:Label ID="lblMsg" runat="server" Visible="false" Font-Bold="true" ForeColor="Red"></asp:Label></center>
				<table width="90%" cellpadding="0" cellspacing="0" border="1" bordercolor="black" align="center">
					<tr>
						<td>
						<table width="100%" cellpadding="5" cellspacing="0" border="0" bordercolor="black">
							<tr>
								<td colspan="2" bgcolor="black"><font color="white" size="3" face="arial"><b>Billing Information</b></font></td>						
							</tr>
							<tr>
								<td align="right" valign="top">* Name On Card: </td>
								<td valign="top">
								    <asp:textbox id="txtNameOnCard"  runat="server" text="" MAXLENGTH="50" size="30"></asp:textbox>
									<asp:RequiredFieldValidator ID="Requiredfieldvalidator8" ErrorMessage="* Required Field" Display="Dynamic" ControlToValidate="txtNameOnCard"  Runat="server"></asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr>
								<td align="right" valign="top">* Card Type: </td>
								<td valign="top">
								    <asp:DropDownList ID="ddlCardType" runat="server">
                                        <asp:ListItem Value="" Selected="True">Please Select</asp:ListItem>
                                        <asp:ListItem Value="Visa">Visa Card</asp:ListItem>
                                        <asp:ListItem Value="Mastercard">Master Card</asp:ListItem>
                                        <asp:ListItem Value="Discover">Discover</asp:ListItem>
                                        <asp:ListItem Value="Amex">American Express</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="Requiredfieldvalidator2314" ErrorMessage="* Required Field" Display="Dynamic" ControlToValidate="ddlCardType"  Runat="server"></asp:RequiredFieldValidator>
                                    <asp:label ID="lblCardType" Runat="server" Visible="false" ForeColor=red Text="* Please Select"></asp:label>
								</td>
							</tr>
							<tr>
								<td align="right" valign="top">* Card Number: </td>
								<td valign="top">
							        <asp:textbox id="txtCardNumber"  runat="server" text="" MAXLENGTH="16" size="30"></asp:textbox>
									<asp:RequiredFieldValidator ID="RequiredFieldValidator9" ErrorMessage="* Required Field" Display="Dynamic" ControlToValidate="txtCardNumber" Runat="server"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator4" ErrorMessage="Invalid Number" Display="Dynamic" ControlToValidate="txtCardNumber" Runat="server" ValidationExpression="\d*"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td align="right" valign="top">* Expiration Date: </td>
								<td valign="top">
								    <asp:DropDownList ID="ddlExpireMonth" runat="server">
								        <asp:ListItem Value="" Selected="True"></asp:ListItem>
								        <asp:ListItem Value="01">01</asp:ListItem>
								        <asp:ListItem Value="02">02</asp:ListItem>
								        <asp:ListItem Value="03">03</asp:ListItem>
								        <asp:ListItem Value="04">04</asp:ListItem>
								        <asp:ListItem Value="05">05</asp:ListItem>
								        <asp:ListItem Value="06">06</asp:ListItem>
								        <asp:ListItem Value="07">07</asp:ListItem>
								        <asp:ListItem Value="08">08</asp:ListItem>
								        <asp:ListItem Value="09">09</asp:ListItem>
								        <asp:ListItem Value="10">10</asp:ListItem>
								        <asp:ListItem Value="11">11</asp:ListItem>
								        <asp:ListItem Value="12">12</asp:ListItem>
								    </asp:DropDownList>
								    <asp:requiredfieldvalidator Font-Size="7" id="RequiredfieldvalidatorMonth" runat="server" ErrorMessage="<br>Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="ddlExpireMonth"></asp:RequiredFieldValidator>
								    <b>/</b>
								    <asp:DropDownList ID="ddlExpireYear" runat="server">
                                        <asp:ListItem Value="" Selected="True"></asp:ListItem>								    
                                        <asp:ListItem Value="2009">2009</asp:ListItem>
                                        <asp:ListItem Value="2010">2010</asp:ListItem>
                                        <asp:ListItem Value="2011">2011</asp:ListItem>
                                        <asp:ListItem Value="2012">2012</asp:ListItem>
                                        <asp:ListItem Value="2013">2013</asp:ListItem>
                                        <asp:ListItem Value="2014">2014</asp:ListItem>
                                        <asp:ListItem Value="2015">2015</asp:ListItem>
                                        <asp:ListItem Value="2016">2016</asp:ListItem>
								    </asp:DropDownList>
								    <asp:requiredfieldvalidator Font-Size=7 id="RequiredfieldvalidatorYear" runat="server" ErrorMessage="<br>Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="ddlExpireYear"></asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr>
								<td align="right" valign="top">* Security Code: </td>
								<td valign="top">
								    <asp:textbox id="txtCVV2"  runat="server"  MAXLENGTH="4" size="10"></asp:textbox>
								    <asp:RequiredFieldValidator  ID="RequiredFieldValidator10" ErrorMessage="* Required Field" Display="Dynamic" ControlToValidate="txtCVV2"  Runat="server"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="RegularExpressionValidator5" ErrorMessage="InValid Number" Display="Dynamic" ControlToValidate="txtCVV2"  Runat="server" ValidationExpression="\d*"></asp:RegularExpressionValidator>
								</td>
							</tr>
							<tr>
								<td colspan="2" bgcolor="black"><font color="white" size="3" face="arial"><b>Billing Address</b></font></td>						
							</tr>
							<tr>
							    <td align="right" valign="top">* Address: </td>
							    <td valign="top">
							        <asp:TextBox ID="txtBillingAddress" runat="server" MaxLength="250"  ></asp:TextBox>
							        <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator4" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtBillingAddress"></asp:requiredfieldvalidator>
							    </td>
						    </tr>
						    <tr>
							    <td align="right" valign="top">* City: </td>
							    <td valign="top">
							        <asp:TextBox ID="txtBillingCity" runat="server" MaxLength="250"></asp:TextBox>
							        <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator3" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtBillingCity"></asp:requiredfieldvalidator>
							    </td>
						    </tr>
						    <tr runat="server" id="trStateDropDown">
							    <td align="right" valign="top">* State / Provence: </td>
							    <td valign="top">
							        <asp:DropDownList runat="server" ID="DLBillingState"></asp:DropDownList>
							        <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator2" runat="server" ErrorMessage="<br>Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="DLBillingState"></asp:RequiredFieldValidator>
							    </td>
						    </tr>
						    <tr runat="server" id="trStateText">
							    <td align="right" valign=top>* State / Provence: </td>
							    <td valign="top">
							        <asp:TextBox ID="txtBillingState" runat="server" MaxLength="250"></asp:TextBox>
							        <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator2a" runat="server" ErrorMessage="<br>Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtBillingState"></asp:RequiredFieldValidator>
							    </td>
						    </tr>
						    <tr>
							    <td align="right" valign="top">* Zip: </td>
							    <td valign="top">
							        <asp:TextBox ID="txtBillingZip" runat="server" MaxLength="10"></asp:TextBox>
					                <asp:requiredfieldvalidator  id="Requiredfieldvalidator31" Font-Size="7" Font-Names="Arial" runat="server" ErrorMessage="Required Field" Display="Dynamic" ControlToValidate="txtBillingZip"></asp:RequiredFieldValidator>
							    </td>
						    </tr>
						    <tr>
							    <td align="right" valign="top">* Country: </td>
							    <td valign="top">
							        <asp:DropDownList runat="server" ID="DLBillingCountry" AutoPostBack="True"></asp:DropDownList>
							        <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator29" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="DLBillingCountry"></asp:RequiredFieldValidator>
							    </td>
						    </tr>
						    
						    <tr>
								<td colspan="2" bgcolor="black"><font color="white" size="3" face="arial"><b>Amount</b></font></td>						
							</tr>
							<tr>
								<td align="right" valign="top">Membership Price: </td>
								<td valign="top"><asp:Label runat="server" ID="lblAmountFull"></asp:Label></td>
							</tr>
							<tr>
								<td align="right" valign=top>Promo Code Amount: </td>
								<td valign="top"><asp:Label runat="server" ID="lblAmountPromo"></asp:Label></td>
							</tr>
							<tr>
								<td align="right" valign=top>Amount To Pay: </td>
								<td valign="top"><asp:Label runat="server" ID="lblAmount"></asp:Label></td>
							</tr>
							
							
							<tr>
							    <td></td>
								<td align="left">
								    <asp:Button ID="btnSubmit" runat="server" cssclass="gray"  Text="Next" Visible="false" />
								    <asp:ImageButton ID="imgRenew" runat="server" align="center"
                                        ImageUrl="images/bankcard_paynow.bmp" />
								</td>						
							</tr>
						</table><br><br>
						</td>
					</tr>
				</table>
				<br><br>


			  </td>
            </tr>
          </table>
</asp:Content>

