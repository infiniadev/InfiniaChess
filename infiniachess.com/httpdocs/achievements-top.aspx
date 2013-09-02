<%@ Page Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" 
    CodeFile="achievements-top.aspx.vb" Inherits="achievements_top" 
    title="Welcom to Infinia Chess - TOP 100 Users"%>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
        <br />
        <center>
        <asp:Image ID="imgHeader" runat="server" Height="66px" 
            ImageUrl="Images/PerpetHeader-2.jpg" Width="623px" />
        </center>
        <br />
        <br />
        <center>
        <asp:Button ID="btnByScore" runat="server" Text="TOP 100 BY SCORE" />
        <asp:Button ID="btnQuantity" runat="server" Text="TOP 100 BY QUANTITY" />
        </center>
        <br />
        <hr />
    
    <center>
    <asp:GridView ID="gridAch" runat="server" AutoGenerateColumns="False">
        <RowStyle Font-Size="Medium" />
        <Columns>
            <asp:BoundField DataField="Rank" HeaderText="Rank" >
                <ItemStyle BackColor="#FFFFCC" />
            </asp:BoundField>
            <asp:BoundField DataField="LoginWithTitle" HeaderText="User" >
                <ItemStyle BackColor="#CCFFCC" Font-Bold="True" />
            </asp:BoundField>
            <asp:BoundField DataField="RatingMax" HeaderText="Rating" >
                <ItemStyle BackColor="#FFFFCC" />
            </asp:BoundField>
            <asp:BoundField DataField="LastDate" HeaderText="Achieved At">
                <ItemStyle BackColor="#CCFFCC" Font-Size="Small" />
            </asp:BoundField>
            <asp:BoundField DataField="ScoreSum" HeaderText="Total Score">
                <ItemStyle BackColor="#FFFFCC" Font-Bold="True" ForeColor="#0000CC" />
            </asp:BoundField>
            <asp:BoundField DataField="cnt" HeaderText="Quantity" >
                <ItemStyle BackColor="#CCFFCC" Font-Bold="True" ForeColor="#0000CC" />
            </asp:BoundField>
        </Columns>
        <HeaderStyle BackColor="#CCFFFF" />
    </asp:GridView>
    </center>
</asp:Content> 