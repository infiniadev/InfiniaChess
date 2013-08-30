object fCLRegister: TfCLRegister
  Left = 486
  Top = 385
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Register New Login'
  ClientHeight = 349
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 13
  object lblAccount: TLabel
    Left = 4
    Top = 0
    Width = 412
    Height = 30
    AutoSize = False
    Caption = 
      'Use this form to register a new login name with the Infinia Ches' +
      's server. A login name is required in order to connect to the se' +
      'rver and play.'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Layout = tlCenter
    WordWrap = True
  end
  object lblLogin: TLabel
    Left = 16
    Top = 120
    Width = 26
    Height = 13
    Caption = 'Login'
  end
  object lblPassword1: TLabel
    Left = 16
    Top = 152
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object lblEmail: TLabel
    Left = 16
    Top = 216
    Width = 25
    Height = 13
    Caption = 'Email'
  end
  object lblInfo: TLabel
    Left = 16
    Top = 266
    Width = 388
    Height = 49
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object lblInstruction2: TLabel
    Left = 16
    Top = 36
    Width = 378
    Height = 26
    AutoSize = False
    Caption = 
      'Choose a login name and password. Logins must be ast least 3 cha' +
      'racters and passwords 6. They must consist of letters and number' +
      's only.'
    WordWrap = True
  end
  object lblInstruction3: TLabel
    Left = 16
    Top = 68
    Width = 377
    Height = 39
    AutoSize = False
    Caption = 
      'Your email is considered confidential. You will get confirmation' +
      ' key on this email, so enter only legal emails! Forgotten passwo' +
      'rds will also be sent ONLY to the registered email address.'
    WordWrap = True
  end
  object lblPassword2: TLabel
    Left = 16
    Top = 180
    Width = 46
    Height = 26
    Caption = 'Confirm '#13#10'Password'
  end
  object Label1: TLabel
    Left = 190
    Top = 120
    Width = 36
    Height = 13
    Caption = 'Country'
  end
  object Label2: TLabel
    Left = 202
    Top = 184
    Width = 18
    Height = 13
    Caption = 'Sex'
  end
  object Label4: TLabel
    Left = 178
    Top = 152
    Width = 48
    Height = 13
    Caption = 'Language'
  end
  object Label5: TLabel
    Left = 184
    Top = 214
    Width = 38
    Height = 13
    Caption = 'Birthday'
  end
  object edtLogin: TEdit
    Left = 72
    Top = 116
    Width = 100
    Height = 21
    MaxLength = 15
    TabOrder = 0
  end
  object edtPassword1: TEdit
    Left = 72
    Top = 148
    Width = 100
    Height = 21
    MaxLength = 15
    PasswordChar = '*'
    TabOrder = 1
  end
  object edtEmail: TEdit
    Left = 72
    Top = 212
    Width = 100
    Height = 21
    MaxLength = 100
    TabOrder = 3
  end
  object btnRegister: TButton
    Left = 259
    Top = 322
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Register'
    TabOrder = 4
    OnClick = btnRegisterClick
  end
  object btnCancel: TButton
    Left = 341
    Top = 322
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object edtPassword2: TEdit
    Left = 72
    Top = 180
    Width = 100
    Height = 21
    MaxLength = 15
    PasswordChar = '*'
    TabOrder = 2
  end
  object cbCountry: TComboBox
    Left = 234
    Top = 116
    Width = 165
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 6
    Items.Strings = (
      'Afghanistan'
      'Albania'
      'Algeria'
      'American Samoa'
      'Andorra'
      'Angola'
      'Anguilla'
      'Antarctica'
      'Antigua and Barbuda'
      'Argentina'
      'Armenia'
      'Aruba'
      'Asia '
      'Australia'
      'Austria'
      'Azerbaijan'
      'Bahamas'
      'Bahrain'
      'Bangladesh'
      'Barbados'
      'Belarus'
      'Belgium'
      'Belize'
      'Benin'
      'Bermuda'
      'Bhutan'
      'Bolivia'
      'Bosnia and Herzegowina'
      'Botswana'
      'Bouvet Island'
      'Brazil'
      'British Indian Ocean Territory'
      'British Virgin Islands'
      'Brunei Darussalam'
      'Bulgaria'
      'Burkina Faso'
      'Burundi'
      'Cambodia'
      'Cameroon'
      'Canada'
      'Cape Verde'
      'Cayman Islands'
      'Central African Republic'
      'Chad'
      'Chile'
      'China'
      'Christmas Island'
      'Cocos (keeling) Islands'
      'Colombia'
      'Comoros'
      'Congo'
      'Congo - the Democratic Rep of'
      'Cook Islands'
      'Costa Rica'
      'Cote Ivoire'
      'Croatia'
      'Cuba'
      'Cyprus'
      'Czech Republic'
      'Denmark'
      'Djibouti'
      'Dominica'
      'Dominican Republic'
      'East Timor'
      'Ecuador'
      'Egypt'
      'El Salvador'
      'Equatorial Guinea'
      'Eritrea'
      'Estonia'
      'Ethiopia'
      'Europe'
      'Falkland Islands'
      'Faroe Islands'
      'Fiji'
      'Finland'
      'France'
      'French Guiana'
      'French Polynesia'
      'French Southern Territories'
      'Gabon'
      'Gambia'
      'Georgia'
      'Germany'
      'Ghana'
      'Gibraltar'
      'Greece'
      'Greenland'
      'Grenada'
      'Guadeloupe'
      'Guam'
      'Guatemala'
      'Guinea'
      'Guinea-Bissau'
      'Guyana'
      'Haiti'
      'Heard and Mcdonald Islands'
      'Holy See (Vatican City State'
      'Honduras'
      'Hong Kong'
      'Hungary'
      'Iceland'
      'India'
      'Indonesia'
      'Invalid'
      'Iran'
      'Iraq'
      'Ireland'
      'Israel'
      'Italy'
      'Jamaica'
      'Japan'
      'Jordan'
      'Kazakhstan'
      'Kenya'
      'Kiribati'
      'Korea - North'
      'Korea - South'
      'Kuwait'
      'Kyrgyzstan'
      'Lao'
      'Latvia'
      'Lebanon'
      'Lesotho'
      'Liberia'
      'Libyan Arab Jamahiriya'
      'Liechtenstein'
      'Lithuania'
      'Luxembourg'
      'Macau'
      'Macedonia'
      'Madagascar'
      'Malawi'
      'Malaysia'
      'Maldives'
      'Mali'
      'Marshall Islands'
      'Martinique'
      'Mauritania'
      'Mauritius'
      'Mayotte'
      'Mexico'
      'Micronesia'
      'Moldova'
      'Monaco'
      'Mongolia'
      'Montserrat'
      'Morocco'
      'Mozambique'
      'Myanmar'
      'Namibia'
      'Nauru'
      'Nepal'
      'Netherlands'
      'Netherlands Antilles'
      'New Caledonia'
      'New Zealand'
      'Nicaragua'
      'Niger'
      'Nigeria'
      'Niue'
      'Norfolk Island'
      'Northern Mariana Islands'
      'Norway'
      'Oman'
      'Pakistan'
      'Palau'
      'Palestinian territories'
      'Panama'
      'Papua New Guinea'
      'Paraguay'
      'Peru'
      'Philippines'
      'Pitcairn'
      'Poland'
      'Portugal'
      'Puerto Rico'
      'Qatar'
      'Reunion'
      'Romania'
      'Russian Federation'
      'Rwanda'
      'Saint Kitts and Nevis'
      'Saint Lucia'
      'Saint Vincent'
      'Samoa'
      'San Marino'
      'Sao Tome'
      'Saudi Arabia'
      'Senegal'
      'Seychelles'
      'Sierra Leone'
      'Singapore'
      'Slovakia'
      'Slovenia'
      'Solomon Islands'
      'Somalia'
      'South Africa'
      'South Georgia'
      'Spain'
      'Sri Lanka'
      'St. Helena'
      'St. Pierre and Miquelon'
      'Sudan'
      'Suriname'
      'Svalbard Islands'
      'Swaziland'
      'Sweden'
      'Switzerland'
      'Syrian Arab Republic'
      'Taiwan - Province of China'
      'Tajikistan'
      'Tanzania'
      'Thailand'
      'Togo'
      'Tokelau'
      'Tonga'
      'Trinidad and Tobago'
      'Tunisia'
      'Turkey'
      'Turkmenistan'
      'Turks and Caicos Islands'
      'Tuvalu'
      'Uganda'
      'Ukraine'
      'United Arab Emirates'
      'United Kingdom'
      'United States'
      'Uruguay'
      'Us Minor Outlying Islands'
      'Us Virgin Islands'
      'Uzbekistan'
      'Vanuatu'
      'Venezuela'
      'Vietnam'
      'Wallis and Futuna Islands'
      'Western Sahara'
      'Yemen'
      'Yugoslavia'
      'Zambia'
      'Zimbabwe')
  end
  object cbSex: TComboBox
    Left = 234
    Top = 180
    Width = 93
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 7
    Items.Strings = (
      'Male'
      'Female')
  end
  object cbLanguage: TComboBox
    Left = 234
    Top = 148
    Width = 165
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 8
    Items.Strings = (
      'Arabic'
      'Bengali'
      'Bulgarian'
      'Cambodian'
      'Cantonese'
      'Chinese'
      'Croatian'
      'Czech'
      'Danish'
      'Dutch'
      'English'
      'Farsi'
      'Finnish'
      'French'
      'German'
      'Greek'
      'Gujarati'
      'Hebrew'
      'Hindi'
      'Hungarian'
      'Indonesian'
      'Italian'
      'Japanese'
      'Korean'
      'Latin'
      'Malayalam'
      'Marathi'
      'Norwegian'
      'Persian'
      'Polish'
      'Portuguese'
      'Punjabi'
      'Russian'
      'Serbian'
      'Spanish'
      'Swedish'
      'Tagalog'
      'Tamil'
      'Telugu'
      'Thai'
      'Ukrainian'
      'Urdu'
      'Vietnamese')
  end
  object chkShowEmail: TCheckBox
    Left = 56
    Top = 240
    Width = 117
    Height = 17
    Caption = 'Show email in profile'
    Checked = True
    State = cbChecked
    TabOrder = 9
  end
  object CheckBox1: TCheckBox
    Left = 206
    Top = 240
    Width = 137
    Height = 17
    Caption = 'Show birthday in profile'
    TabOrder = 10
  end
  object cmbDay: TComboBox
    Left = 316
    Top = 210
    Width = 39
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 11
  end
  object cmbMonth: TComboBox
    Left = 234
    Top = 210
    Width = 81
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 12
    Items.Strings = (
      'January'
      'February'
      'March'
      'April'
      'May'
      'June'
      'July'
      'August'
      'September'
      'October'
      'November'
      'December')
  end
  object cmbYear: TComboBox
    Left = 358
    Top = 210
    Width = 45
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 13
  end
end
