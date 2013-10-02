Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports Microsoft.VisualBasic

Public Class Conn
    Public Connection As New SqlConnection("data source=localhost;initial catalog=CLServer;persist security info=False;user id=clsa;password=Nf6=Q;packet size=4096")
    'Public Connection As New SqlConnection("data source=67.192.255.154;initial catalog=CLServer;persist security info=False;user id=clsa;password=Nf6=Q;packet size=4096")
    ''Public ConnVBulletinStr As String = "Driver={MySQL ODBC 5.1 Driver};Data Source=localhost;Database=chess_vbulletin;uid=chess_admin;pwd=chess;option=3"
	' ========================================================================================================
    Sub dbopen()
        Try
            If Not Connection.State = ConnectionState.Open Then
                Connection.Open()
            End If
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
        End Try
    End Sub
	' ========================================================================================================
    Sub dbclose()
        Try
            If Connection.State = ConnectionState.Open Then
                Connection.Close()
            End If
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
        End Try
    End Sub
	' ========================================================================================================
    Function SelectTable(ByVal SQL As String) As DataTable
        Dim SQA As SqlDataAdapter
        Try
            dbopen()
            SQA = New SqlDataAdapter(SQL, Connection)

            Dim CustomDataTable As New DataSet
            SQA.Fill(CustomDataTable)

            SelectTable = CustomDataTable.Tables(0)

            SQA.Dispose()
            dbclose()
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
            SelectTable = Nothing
        Finally
            dbclose()
        End Try
    End Function
	' ========================================================================================================
    Function ExecSql(ByVal p_SQL As String) As Boolean
        Try
            dbopen()
            Dim myCommand As SqlCommand = Connection.CreateCommand
            myCommand.CommandText = p_SQL
            myCommand.ExecuteNonQuery()
            myCommand.CommandText = "select IsNull(@@Identity, 0)"
            myCommand.ExecuteScalar()
            ExecSql = True
        Catch ex As Exception
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
            ExecSql = False
        Finally
            dbclose()
        End Try
    End Function
    ' ========================================================================================================
    Function GetIntegerValue(ByVal p_SQL As String) As Integer
        Dim dbWasAlreadyOpened As Boolean = Connection.State = ConnectionState.Open
        Try
            If Not dbWasAlreadyOpened Then dbopen()
            Dim myCommand As SqlCommand = Connection.CreateCommand
            myCommand.CommandText = p_SQL
            GetIntegerValue = myCommand.ExecuteScalar()
        Catch ex As Exception
            GetIntegerValue = 0
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
        Finally
            If Not dbWasAlreadyOpened Then dbclose()
        End Try
    End Function
	' ========================================================================================================
    Function GetStringValue(ByVal p_SQL As String) As String
        Try
            dbopen()
            Dim myCommand As SqlCommand = Connection.CreateCommand
            myCommand.CommandText = p_SQL
            GetStringValue = myCommand.ExecuteScalar()
        Catch ex As Exception
            GetStringValue = ""
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
        Finally
            dbclose()
        End Try
    End Function
   	' ========================================================================================================
    Function GetSingleValue(ByVal p_SQL As String) As Single
        Try
            dbopen()
            Dim myCommand As SqlCommand = Connection.CreateCommand
            myCommand.CommandText = p_SQL
            GetSingleValue = myCommand.ExecuteScalar()
        Catch ex As Exception
            GetSingleValue = "0"
            System.Diagnostics.Trace.WriteLine("[ValidateUser] Exception " & ex.Message)
        Finally
            dbclose()
        End Try
    End Function
    ' ========================================================================================================
End Class
