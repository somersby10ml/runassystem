VERSION 5.00
Begin VB.Form Form1 
   BorderStyle     =   1  '���� ����
   Caption         =   "[VB6] ADS (Zone.Identifier) Search (ver 0.1)"
   ClientHeight    =   2040
   ClientLeft      =   45
   ClientTop       =   375
   ClientWidth     =   7875
   BeginProperty Font 
      Name            =   "���� ���"
      Size            =   9
      Charset         =   129
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   2040
   ScaleWidth      =   7875
   StartUpPosition =   2  'ȭ�� ���
   Begin VB.CheckBox Check1 
      Caption         =   "������������"
      Enabled         =   0   'False
      Height          =   255
      Left            =   6240
      TabIndex        =   5
      Top             =   600
      Width           =   1455
   End
   Begin VB.CommandButton Command3 
      Caption         =   "��ü����"
      Height          =   495
      Left            =   6240
      TabIndex        =   4
      Top             =   1440
      Width           =   1575
   End
   Begin VB.CommandButton Command2 
      Caption         =   "����"
      Height          =   375
      Left            =   6240
      TabIndex        =   3
      Top             =   960
      Width           =   1575
   End
   Begin VB.CommandButton Command1 
      Caption         =   "�˻�"
      Height          =   375
      Left            =   6240
      TabIndex        =   2
      Top             =   120
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Alignment       =   2  '��� ����
      Height          =   270
      Left            =   120
      OLEDropMode     =   1  '����
      TabIndex        =   1
      Text            =   "�������"
      Top             =   120
      Width           =   6015
   End
   Begin VB.ListBox List1 
      Height          =   1485
      IntegralHeight  =   0   'False
      Left            =   120
      TabIndex        =   0
      Top             =   480
      Width           =   6015
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function WritePrivateProfileString Lib "kernel32.dll" Alias "WritePrivateProfileStringA" ( _
    ByVal lpAppName As String, _
    ByVal lpKeyName As String, _
    ByVal lpString As String, _
    ByVal lpFileName As String _
) As Long

Private Declare Function DeleteFile Lib "kernel32.dll" Alias "DeleteFileA" (ByVal lpFileName As String) As Long

Private Declare Function GetFileAttributes Lib "kernel32.dll" Alias "GetFileAttributesA" (ByVal lpFileName As String) As Long


Private Declare Function GetLogicalDriveStrings Lib "kernel32.dll" Alias "GetLogicalDriveStringsA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long
Private Declare Function GetVolumeInformationA Lib "kernel32.dll" ( _
    ByVal lpRootPathName As String, _
    ByVal lpVolumeNameBuffer As String, _
    ByVal nVolumeNameSize As Long, _
    ByRef lpVolumeSerialNumber As Long, _
    ByRef lpMaximumComponentLength As Long, _
    ByRef lpFileSystemFlags As Long, _
    ByVal lpFileSystemNameBuffer As String, _
    ByVal nFileSystemNameSize As Long) As Long


Private FilePath() As String, NumPath As Long

Private Sub Command2_Click()
    Dim SelectPath As String
    SelectPath = FilePath(List1.ListIndex)

    If List1.ListIndex <> &HFFFFFFFF Then
        If GetFileAttributes(SelectPath & ":Zone.Identifier") <> &HFFFFFFFF Then
        
            If DeleteFile(SelectPath & ":Zone.Identifier") = 0& Then
                If WritePrivateProfileString("ZoneTransfer", "ZoneId", "0", SelectPath & ":Zone.Identifier") = 0& Then
                    MsgBox "�ٿ�ε� ǥ�ø� ���� �� �������ϴ�.", vbCritical, ""
                End If
            End If
        End If
    End If

    MsgBox SelectPath & vbCrLf & "�� �ٿ�ε� ǥ�ø� �������ϴ�.", vbInformation, ""
End Sub

Private Sub Command3_Click()
    Dim i As Long
    For i = 0 To NumPath - 1
        If GetFileAttributes(FilePath(i) & ":Zone.Identifier") <> &HFFFFFFFF Then
        
            If DeleteFile(FilePath(i) & ":Zone.Identifier") = 0& Then
                If WritePrivateProfileString("ZoneTransfer", "ZoneId", "0", FilePath(i) & ":Zone.Identifier") = 0& Then
                    MsgBox "�ٿ�ε� ǥ�ø� ���� �� �������ϴ�.", vbCritical, ""
                End If
            End If
        End If
    Next i

    MsgBox NumPath & "���� �ٿ�ε� ǥ�ø� �������ϴ�.", vbInformation, ""
End Sub

Private Sub Form_Load()
    Text1.Text = "C:\Users\Root\Desktop"
    
'    Dim LogicalDriver As String, cbLogicalDriver As Long
'    cbLogicalDriver = 10&
'    LogicalDriver = String$(cbLogicalDriver&, 0)
'    GetLogicalDriveStrings cbLogicalDriver&, LogicalDriver
'
'    Dim FileSystemName As String, cbFileSystemName As Long
'    cbFileSystemName = 10&
'    FileSystemName = String$(cbFileSystemName&, 0)
'
'
'    Call GetVolumeInformationA(LogicalDriver, vbNullString, 0&, ByVal 0&, ByVal 0&, ByVal 0&, FileSystemName, cbFileSystemName)
'    'FileSystemName = Left$(FileSystemName, InStr(1, FileSystemName, vbNullChar, vbBinaryCompare) - 1)
'
'    If StrComp(FileSystemName, "NTFS", vbTextCompare) Then
'        MsgBox "���Ͻý����� NTFS �� �ƴմϴ�.", vbInformation, ""
'        End
'    End If
    
End Sub

Private Function CheckNTFS(ByRef FolderPath As String) As Boolean

    Dim FileSystemName As String, cbFileSystemName As Long
    cbFileSystemName = 20&
    FileSystemName = String$(cbFileSystemName&, 0)

    Call GetVolumeInformationA(Left(FolderPath, 3), vbNullString, 0&, ByVal 0&, ByVal 0&, ByVal 0&, FileSystemName, cbFileSystemName)
    'FileSystemName = Left$(FileSystemName, InStr(1, FileSystemName, vbNullChar, vbBinaryCompare) - 1)
    
    If StrComp(FileSystemName, "NTFS", vbTextCompare) = 0& Then
        CheckNTFS = True
    End If
End Function
Private Sub Command1_Click()
    On Error Resume Next
    List1.Clear
    
    Dim SearchFlags As Long
    SearchFlags = vbHidden Or vbNormal Or vbSystem Or vbReadOnly
    
    Dim FolderPath As String
    FolderPath = Text1.Text
    
    If LenB(Dir$(FolderPath, SearchFlags Or vbDirectory)) = 0& Then
        MsgBox "�ش� ������ �����ϴ�.", vbCritical, ""
        Exit Sub
    End If
    
    If CheckNTFS(FolderPath) = False Then
        MsgBox "�ش� ������ ���Ͻý����� NTFS �� �ƴմϴ�.", vbInformation, ""
        Exit Sub
    End If
    
    
    If Right(FolderPath, 1) <> "\" Then
        FolderPath = FolderPath & "\"
    End If
    
    If Check1.Value Then
        SearchFlags = SearchFlags Or vbDirectory
    End If
    
    
    Dim Temp As String
    Temp = Dir$(FolderPath, SearchFlags)

    '## �����ڵ带 ó���ϱ� ���� �������
    '## (����Ʈ�� ������ ? ���ڸ� �״�� �о�鿩�� �ȵ�)
    
    
    Erase FilePath
    NumPath = 0&
    
    Do While LenB(Temp)
    
'        Dim Attributes As Long
'        Attributes = GetFileAttributes(FolderPath & Temp)
        
        If GetFileAttributes(FolderPath & Temp & ":Zone.Identifier") <> &HFFFFFFFF Then
            ReDim Preserve FilePath(NumPath) As String
            FilePath(NumPath) = FolderPath & Temp
            NumPath = NumPath + 1&
            List1.AddItem Temp
        End If
            
        Temp = Dir$
    Loop
    
End Sub

'Private Sub Form_Load()

'    On Error Resume Next
'    ' ### Zone.Identifier ADS(Alternate Data Stream) ���� ���� Ȯ��
'    GetAttr "C:\test.bat:Zone.Identifier"
'    If Err = 0 Then
'        ' ### ADS Stream�� Kill �Լ��δ� ������ �Ұ����ϹǷ� DeleteFile API�� ���ؼ� ������
'        If DeleteFile("C:\test.bat:Zone.Identifier") = 0& Then
'            ' ### ������ ������ ��� ZoneId ���� 0(URLZONE_LOCAL_MACHINE)���� �ٲ���
'            If WritePrivateProfileString("ZoneTransfer", "ZoneId", "0", "C:\test.bat:Zone.Identifier") = 0& Then
'                MsgBox "�ٿ�ε� ǥ�ø� ���� �� �������ϴ�."
'            End If
'        End If
'    End If
'    On Error GoTo 0

'End Sub



Private Sub Text1_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
    Text1.Text = Data.Files(1)
End Sub
