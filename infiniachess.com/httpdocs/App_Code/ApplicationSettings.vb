Imports Microsoft.VisualBasic
Imports System.Configuration.ConfigurationManager

Public Class ApplicationSettings

    Public Shared ReadOnly Property EmailConfirmationRequired As Boolean
        Get
            Return AppSettings("EmailConfirmationRequired") = "True"
        End Get
    End Property

End Class

