�
 TFCLMATCH 0.  TPF0	TfCLMatchfCLMatchLeft�Top�BorderStylebsDialogCaptionMatch DialogClientHeight�ClientWidth8Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style OldCreateOrder	PositionpoScreenCenterOnClose	FormCloseOnCreate
FormCreateOnPaint	FormPaintPixelsPerInch`
TextHeight TLabellblMatchLeftTop Width�HeightAutoSizeCaption�Matches issued are displayed in the Seeks frame of the player challenged. If the player clicks your match a game will automatically begin.ColorclWhiteFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameMS Sans Serif
Font.Style ParentColor
ParentFontLayouttlCenterWordWrap	  TPanelPanel3Left Top�Width8Height"AlignalBottom
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder  TButtonbtnIssueLeftTopWidthKHeightAnchorsakLeftakBottom CaptionIssue MatchEnabledModalResultTabOrder OnClickbtnIssueClick  TButton	btnCancelLeftRTopWidthKHeightAnchorsakLeftakBottom Cancel	CaptionCancelModalResultTabOrder   TPanelPanel4Left Top Width8Height+AlignalClient
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder TLabellblOpponentLeftTopWidth/HeightCaptionOpponent  TLabel	lblInitalLeftTop.WidthWHeightCaption&Initial game time ofFocusControl
edtInitial  TLabellblIncLeft� Top.WidthHeight	AlignmenttaRightJustifyCaptionplusFocusControledtInc  TLabellblInc2LeftDTop.WidthWHeightCaptionseconds per move  TLabellblStyleLeftTopNWidth`HeightCaption&Style of game will be  TLabellblRatedLeftTopnWidth<HeightCaptionGame will be  TLabellblColorLeftTop� WidthHHeightCaptionMy color will be  TEditedtOpponentLeftxTop
Width� HeightTabOrder   TEdit
edtInitialLeftxTop*Width!Height	MaxLengthTabOrderText20OnChangeTimeControlChange
OnKeyPressControlKeyPress  TUpDown	udInitialLeft� Top*WidthHeight	Associate
edtInitialMinMax�PositionTabOrder	ThousandsWrap
OnChangingTimeControlChanging  	TComboBoxcbDimensionLeft� Top*Width=HeightStylecsDropDownList
ItemHeightTabOrderItems.Stringsminutesseconds   TEditedtIncLeftTop*Width!Height	MaxLengthTabOrderText0OnChangeTimeControlChange
OnKeyPressControlKeyPress  TUpDownudIncLeft-Top*WidthHeight	AssociateedtIncMin Max�Position TabOrder	ThousandsWrap
OnChangingTimeControlChanging  	TComboBox
cbGameTypeLeftxTopJWidth� HeightStylecsDropDownList
ItemHeightTabOrderOnChangeTimeControlChangeItems.StringsNormalCrazy HouseFischer RandomLoser's   TPanelpnlRatedLeftvTopkWidth� Height
BevelOuterbvNoneTabOrder TRadioButtonrbRatedLeftTopWidthAHeightCaption&RatedTabOrder OnClickrbRatedClick  TRadioButton	rbUnratedLeftHTopWidthAHeightCaption&UnratedTabOrderOnClickrbRatedClick   TPanelpnlColorLeftvTop� WidthHeight
BevelOuterbvNoneTabOrder TRadioButtonrbWhiteTagLeftTopWidthAHeightCaption&WhiteTabOrder   TRadioButtonrbBlackTag�LeftHTopWidthAHeightCaption&BlackTabOrder  TRadioButtonrbServerLeft� TopWidth� HeightCaption&Decided by the serverTabOrder    TPanelPanel1Left Top+Width8HeightHAlignalBottom
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder TLabellblAutoTimeOddsLeftXTopWidthHeightCaption;(server will automatically set odds on the base of ratings)  	TCheckBoxchkTimeOddsLeftTopWidthIHeightCaption	Time OddsTabOrder OnClickchkTimeOddsClick  TPanelpnlTimeOddsLeftTop#Width�Height!AnchorsakLeftakBottom 
BevelOuterbvNoneTabOrderVisible TLabelLabel1LeftTop
WidthgHeightCaptionMy initial game time ofFocusControledtOddsInitMin  TLabelLabel4Left� Top
WidthHeightCaptionmin  TLabelLabel5Left� TopWidth'HeightCaptionsec plus  TLabelLabel3LeftPTopWidth,HeightCaptionseconds 
per move  TEditedtOddsInitMinLefttTopWidth!HeightEnabled	MaxLengthTabOrder Text20OnChangeTimeControlChange
OnKeyPressControlKeyPress  TUpDownudOddsInitMinLeft� TopWidthHeight	AssociateedtOddsInitMinEnabledMinMax�PositionTabOrder	ThousandsWrap
OnChangingTimeControlChanging  TEditedtOddsInitSecLeft� TopWidth!HeightEnabled	MaxLengthTabOrderText0OnChangeTimeControlChange
OnKeyPressControlKeyPress  TUpDownudOddsInitSecLeft� TopWidthHeight	AssociateedtOddsInitSecEnabledMin Max;Position TabOrder	ThousandsWrap
OnChangingTimeControlChanging  TEdit
edtOddsIncLeftTopWidth!HeightEnabled	MaxLengthTabOrderText0OnChangeTimeControlChange
OnKeyPressControlKeyPress  TUpDown	udOddsIncLeft=TopWidthHeight	Associate
edtOddsIncEnabledMin Max�Position TabOrder	ThousandsWrap
OnChangingTimeControlChanging   TPanelpnlTimeOddsDirectionLeftTopWidth� Height
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder TRadioButtonrbTimeOddsGiveLeftTopWidthCHeightCaptionYou giveChecked	TabOrder TabStop	  TRadioButtonrbTimeOddsAskLeftJTopWidth<HeightCaptionYou askTabOrder    TPanelPanel2Left TopsWidth8Height)AlignalBottom
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder 	TComboBoxcmbPieceOddsLeft\Top
WidthsHeightStylecsDropDownList
ItemHeightTabOrder Items.StringsPawnKnightBishopRookQueen   	TCheckBoxchkPieceOddsLeft
TopWidthMHeightCaption
Piece OddsTabOrderOnClickchkPieceOddsClick  TPanelpnlPieceOddsDirectionLeftTopWidth� Height
BevelInnerbvRaised
BevelOuter	bvLoweredTabOrder TRadioButtonrbPieceOddsGiveLeftTopWidthCHeightCaptionYou giveChecked	TabOrder TabStop	  TRadioButtonrbPieceOddsAskLeftJTopWidth<HeightCaptionYou askTabOrder     