Imports Microsoft.VisualBasic
Imports System.Configuration.ConfigurationManager

Public Class ApplicationSettings

    Public Shared ReadOnly Property EmailConfirmationRequired As Boolean
        Get
            Return AppSettings("EmailConfirmationRequired").ToLower() = "true"
        End Get
    End Property

    Public Shared ReadOnly Property SmtpHost As String
        Get
            Return AppSettings("SmtpHost")
        End Get
    End Property

    Public Shared ReadOnly Property SmtpPort As Integer
        Get
            Dim port As Integer
            If Integer.TryParse(AppSettings("SmtpPort"), port) Then
                Return port
            Else
                Return 25
            End If
        End Get
    End Property

    Public Shared ReadOnly Property SmtpUser As String
        Get
            Return AppSettings("SmtpUser")
        End Get
    End Property

    Public Shared ReadOnly Property SmtpPassword As String
        Get
            Return AppSettings("SmtpPassword")
        End Get
    End Property

    Public Shared ReadOnly Property CheckEmailExists As Boolean
        Get
            Return AppSettings("CheckEmailExists").ToLower() = "true"
        End Get
    End Property

End Class

