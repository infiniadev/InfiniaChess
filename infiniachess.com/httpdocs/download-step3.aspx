<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="download-step3.aspx.vb" Inherits="download_step3" title="Welcome to Perpetual Chess - Confirmation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <table cellpadding=0 cellspacing=0 border=0 width=100% class=body>
        <tr>
          <td align="left" valign="top">
			<h2>Membership</h2>
	
			<P><b>Thank you for joining Perpetual Chess!</b>  <%=CardConfirmation %>  </P>
			
			<P><a href="clients/ic_setup.exe">Click Here To Download The Chess Client</a> and start playing today.</P>
			
			<P>A copy of this page has been sent to <%=Context.Items("Email") %> for your records.</P>
			
			
			
			<table width=90% cellpadding=0 cellspacing=0 border=1 bordercolor=black align=center>
				<tr>
					<td>
					<table width=100% cellpadding=5 cellspacing=0 border=0 bordercolor=black>
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Contact Information</b></font></td>						
						</tr>
						<tr>
							<td align=right valign=top>First Name: </td>
							<td valign=top><asp:Label runat="server" ID="lblFirstName"></asp:Label></td>
						</tr>
						<tr>
							<td align=right valign=top>Last Name: </td>
							<td valign=top><asp:Label runat="server" ID="lblLastName"></asp:Label></td>
						</tr>
						<tr>
							<td align=right valign=top>Country: </td>
							<td valign=top><asp:Label runat="server" ID="lblCountry"></asp:Label></select> 
							</td>
						</tr>
						<tr>
							<td align=right valign=top>Email: </td>
							<td valign=top><asp:Label runat="server" ID="lblEmail"></asp:Label></td>
						</tr>
						
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Member Information</B></FONT></TD>
						</tr>
						<tr>
							<td align=right valign=top>User Name: </td>
							<td valign=top><asp:Label runat="server" ID="lblLogin"></asp:Label></td>
						</tr>
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Membership Type</B></FONT></TD>						
						</tr>
						<tr>
							<td align=right valign=top>Membership: </td>
							<td valign=top><asp:Label runat="server" ID="lblSubscribeTypeText"></asp:Label></td>
						</tr>
						<tr>
							<td align=right valign=top>Valid Through: </td>
							<td valign=top><asp:Label runat="server" ID="lblSubscribeExpire"></asp:Label><br></td>
						</tr>

						<tr runat="server" id="trPromotion" visible="false">
						<td>
						<tr>
							<td colspan=2 bgcolor=black><font color="white" size="3" face="arial"><b>Promotion Code Used</B></FONT></TD>						
						</tr>
						<tr>
							<td align=right valign=top>Promo Code: </td>
							<td valign=top><asp:Label runat="server" ID="lblPromoCode"></asp:Label><br></td>
						</tr>
						<tr>
							<td align=right valign=top>Amount Rest: </td>
							<td valign=top><asp:Label runat="server" ID="lblPromoAmountRest"></asp:Label><br></td>
						</tr>
						</td>
						</tr>
						
						<tr>
						    <td></td>
                            <td><asp:Label runat="server" ID="lblPleaseConfirm" Font-Bold="True" ForeColor="Purple">Please, confirm your email before using this login!</asp:Label></td>
						</tr>
						<tr>
						<td> </td>
						<td align=left><asp:Button ID="btnProfile" runat="server" Text="Go To Profile" /></td>
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

