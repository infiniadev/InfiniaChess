<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="customer-profile.aspx.vb" Inherits="customer_profile" title="Welcome to Infinia Chess - Customer Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
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

    <table cellpadding="0" cellspacing="0" border="0" width="100%" class="body">
        <tr>
          <td align="left" valign="top">
			<h2>Welcome to the fastest growing Chess Site on the Internet.</h2>  

 			<p>At Infinia you will find a group of people having fun while dedicated to promoting the game of chess. </p> 

			<p>To name only a few of our features, you  will be able to attend interesting and educational lectures by masters,  master events, puzzles for members, an active lobby where members can meet and chat, the ability to choose your own colors for your board, interface, fonts and even  choose your own chess pieces.  </p>
			
			<p><a href="http://buckeyechess.com/files/Perpetual Chess Setup.exe">Click Here To Download The Chess Client</a> and start playing today.</p>
	
			<asp:Label ID="lblMsg" runat="server" Visible="false" Font-Bold="true" ForeColor="Red"></asp:Label>
			<table width=90% cellpadding=0 cellspacing=0 border="0" align=center>
			    <tr>
			        <td align="right"><asp:LinkButton runat="server" ID="lbtnLogout" Text="Logout"></asp:LinkButton></td>
			    </tr>
			</table>
			<table width=90% cellpadding=0 cellspacing=0 border=1 bordercolor=black align=center>
				<tr>
					<td>
					<table width=100% cellpadding=5 cellspacing=0 border=0 bordercolor=black>
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Member Information</b></font></td>						
						</tr>
						<tr>
							<td align=right valign=top>Username: </td>
							<td valign=top><asp:Label runat="server" ID="lblLogin"></asp:Label><br></td>
						</tr>
						<tr>
							<td colspan=2 align=center valign=top><asp:Button ID="btnUserPassword" runat="server" Text="Change Password" /></asp:Button></td>
						</tr>
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Contact Information</b></font></td>						
						</tr>
						<tr>
							<td align=right valign=top>First Name: </td>
							<td valign=top>
							    <asp:TextBox ID="txtFirstName" runat="server" MaxLength="127"></asp:TextBox>
							    <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtFirstName"></asp:requiredfieldvalidator>
							</td>
						</tr>
						<tr>
							<td align=right valign=top>Last Name: </td>
							<td valign=top>
							    <asp:TextBox ID="txtLastName" runat="server" MaxLength="127"></asp:TextBox>
							    <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator1" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtLastName"></asp:requiredfieldvalidator>
							</td>
						</tr>
						<tr>
							<td align=right valign=top>Country: </td>
							<td valign=top>
							    <asp:DropDownList runat="server" ID="DLCountry"></asp:DropDownList>
							    <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator29" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="DLCountry"></asp:RequiredFieldValidator>
							</td>
						</tr>
						<tr>
							<td align=right valign=top>Email: </td>
							<td valign=top>
							    <asp:TextBox ID="txtEmail" runat="server" MaxLength="255"></asp:TextBox>
					            <asp:requiredfieldvalidator Font-Size=7 id="Requiredfieldvalidator19" runat="server" ErrorMessage="Required Field" cssclass="textfield" Display="Dynamic" ControlToValidate="txtEmail"></asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator Font-Size=7 ID="RegularExpressionValidator2" cssclass="textfield"  ControlToValidate="txtEmail" Display="Dynamic" Runat="server" ErrorMessage="InValid Email" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
							</td>
						</tr>
						<tr>
							<td> </td>
							<td align=left><asp:Button ID="btnUpdate" runat="server" Text="Update Profile" /></td>						
						</tr>
						<tr runat="server" visible="false">
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Membership Type</b></font></td>										
						</tr>
						<tr runat="server" id="trSubscribeExists" Visible="false">
						    <td>
						    <tr>
							    <td align=right valign=top>Membership: </td>
							    <td valign=top><asp:Label runat="server" Font-Bold="true" ID="lblSubscribeTypeText"></asp:Label></td>
						    </tr>
						    <tr>
							    <td align=right><asp:Label runat="server" ID="lblSubscribeExpireTitle"></asp:Label><br></td>
							    <td valign=top><asp:Label runat="server" Font-Bold="true" ID="lblSubscribeExpire"></asp:Label><br></td>
						    </tr>
						    </td>
						</tr>
						
						<tr runat="server" id="trRenew" visible="false">
						    <td>
						    <tr>
							    <td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Renew Membership</b></font></td>										
						    </tr>
						    <tr>
							    <td valign=top colspan="2">
							        <asp:Label ID="lblSpecialOffer" runat="server" Font-Bold="True" Font-Size="Medium"  Visible="false"
                                        ForeColor="#990000" 
                                        Text="Special offer!!! Limited! First 200 members will get 18 months instead of 12!"></asp:Label>
							        <asp:RadioButtonList ID="rdoSubscribeType" runat="server" RepeatColumns="1">
							        </asp:RadioButtonList>								    
							    </td>
						    </tr>
						    <tr id="trPaymentOptions1">
						        <td valign="top">
						            <table width="100%">
						                <tr valign="top"><td bgcolor=black valign="top"><font color="white" size="3" face="arial"><b>Pay By Credit Card</b></font></td></tr>
						                <tr><td size="3"></td></tr>
						                <tr><td size="3"></td></tr>
						                <tr><td size="3"></td></tr>
						                <tr><td size="3"></td></tr>
						                <tr valign="top"><td valign="center" align="center"><asp:ImageButton ID="imgRenew" runat="server" ImageUrl="images/bankcard_paynow.bmp" /></td></tr>
						            </table>
						        </td>
						        
						        <td valign="top">
						           <table width="100%">
						                <tr><td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Pay By Check or Money Order</b></font></td></tr>
						                <tr>
						                    <td align="center" width="100%">
						                       <div class="block1">
                                                  You can send checks or money orders in US Dollars. Please include your 
                                                  screen name and membership type you are paying for with your payment. 
                                                  Allow 10-14 days for checks to be processed. International payments 
                                                  may take longer to process.
                                                </div>
                                            </td>
                                        </tr>
                                        <tr align="center">
                                            <td align="center" width="100%">
                                               <div align="center" class="block1">
						                          InfiniaChess LLC<br />
                                                  PO Box 281<br />
                                                  Raeford, NC 28376
                                               </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
						    </tr>
						    <tr id="trPaymentOptions2">
						        <td valign="top">
						            <table width="100%">
						                <tr><td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Use Promotional Code</b></font></td></tr>
						                <tr><td align="center">
						                    <asp:TextBox ID="txtPromoCode" runat="server" Width="225" MaxLength="32"></asp:TextBox>
							                <asp:CustomValidator ID="CustomValidator1" runat="server" Display="Dynamic" OnServerValidate="CheckPromoCode" SetFocusOnError="true" Text="Promo Code Expired or Invalid"></asp:CustomValidator>
							                <asp:Button ID="btnPromoCode" runat="server" text="Use Code" align="center" OnClick="imgRenew_Click" style="display:none"/>
							            </td></tr>
						            </table>
						        </td>
						        <td valign="top">
						            <table width="100%">
						                <tr><td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Pay By PayPal</b></font></td></tr>
						                <tr><td align="center"><asp:ImageButton ID="imgPayPal" runat="server" ImageUrl="images/paypal_paynow.gif" /><br /><br /></td></tr>
						            </table>
						        </td>
						    </tr>
						    </td>
						</tr>
						
						<tr runat="server" id="trAdmin" visible="false">
						    <td>
						        <tr>
							        <td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Admin Tasks</b></font></td>										
						        </tr>
						        <tr>
							        <td align=right valign=top>Copy User List To Forum:</td>
							        <td align=left><asp:Button ID="btnTransferUsers" runat="server" Text="Go" />
							        <asp:Label runat="server" Font-Bold="true" ID="lblTransferUsersResult"></asp:Label>
							        </td>
						        </tr>
						        <tr>
						            <td align="right" valign="top">Promo Codes:</td>
						            <td align="left"><asp:Button ID="btnPromoCodes" runat="server" Text="Go" /></td>
						        </tr>
						    </td>
						</tr>

					</table><br><br>
					</td>
				</tr>
			</table>
			<br /><br />
		  </td>
        </tr>
      </table>

</asp:Content>

