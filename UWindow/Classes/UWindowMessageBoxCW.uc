class UWindowMessageBoxCW extends UWindowDialogClientWindow;

var MessageBoxButtons Buttons;

var MessageBoxResult EnterResult;
var UWindowSmallButton YesButton, NoButton, OKButton, CancelButton;
var localized string YesText, NoText, OKText, CancelText;
var UWindowMessageBoxArea MessageArea;

var float MB_BorderW;				// How much space to add on left and right sides of client area
var float MB_BorderH;				// How much space to add above and below client area
var float MB_ButtonWidth;			// Button width
var float MB_ButtonHeight;			// Button height
var float MB_ButtonBorderW;			// Extra space around buttons
var float MB_ButtonBorderH;			// Extra space around buttons

var float MB_ButtonAreaHeight;			// Calculated at runtime -- height of button area
var float MB_ButtonDistFromFrameBottom;	// Calculated at runtime -- distance of buttons from bottom of frame window

function Created()
{
	Super.Created();
	SetAcceptsFocus();

	MB_ButtonAreaHeight = MB_ButtonHeight + MB_ButtonBorderH * 2;
	MB_ButtonDistFromFrameBottom = MB_ButtonHeight + ((MB_ButtonAreaHeight - MB_ButtonHeight) / 2);

	MessageArea = UWindowMessageBoxArea(CreateWindow(class'UWindowMessageBoxArea', MB_BorderW, MB_BorderH, WinWidth - MB_BorderW*2, WinHeight - MB_BorderH*2 - MB_ButtonAreaHeight));
}

function KeyDown(int Key, float X, float Y)
{
	local UWindowMessageBox P;

	P = UWindowMessageBox(ParentWindow);

	if(Key == GetPlayerOwner().Player.Console.EInputKey.IK_Enter && EnterResult != MR_None)
	{
		P = UWindowMessageBox(ParentWindow);
		P.Result = EnterResult;
		P.Close();
	}
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);

	MessageArea.SetSize(WinWidth - MB_BorderW*2, WinHeight - MB_BorderH*2 - MB_ButtonAreaHeight);

	switch(Buttons)
	{
	case MB_YesNoCancel:
		CancelButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW);
		CancelButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		NoButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW) * 2;
		NoButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		YesButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW) * 3;
		YesButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		break;
	case MB_YesNo:
		NoButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW);
		NoButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		YesButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW) * 2;
		YesButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		break;
	case MB_OKCancel:
		CancelButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW);
		CancelButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		OKButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW) * 2;
		OKButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		break;
	case MB_OK:
		OKButton.WinLeft = WinWidth - (MB_ButtonWidth + MB_ButtonBorderW);
		OKButton.WinTop = WinHeight - MB_ButtonDistFromFrameBottom;
		break;
	}
}

function Resized()
{
	Super.Resized();
	MessageArea.SetSize(WinWidth - MB_BorderW*2, WinHeight - MB_BorderH*2 - MB_ButtonAreaHeight);
}

function float GetHeight(Canvas C)
{
	return MB_BorderH*2 + MB_ButtonAreaHeight + MessageArea.GetHeight(C);
}

function Paint(Canvas C, float X, float Y)
{
	local Texture T;
	Super.Paint(C, X, Y);
	T = GetLookAndFeelTexture();
	// This big thing across the bottom of the window looks stupid
//	DrawUpBevel( C, 0, WinHeight-MB_ButtonAreaHeight, WinWidth, MB_ButtonAreaHeight, T);
}

function SetupMessageBoxClient(string InMessage, MessageBoxButtons InButtons, MessageBoxResult InEnterResult)
{
	MessageArea.Message = InMessage;
	Buttons = InButtons;
	EnterResult = InEnterResult;

	// Create buttons
	switch(Buttons)
	{
	case MB_YesNoCancel:
		CancelButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW), WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		CancelButton.SetText(CancelText);
		CancelButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_Cancel)
			CancelButton.SetFont(F_Bold);
		else
			CancelButton.SetFont(F_Normal);
		NoButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW)*2, WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		NoButton.SetText(NoText);
		NoButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_No)
			NoButton.SetFont(F_Bold);
		else
			NoButton.SetFont(F_Normal);
		YesButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW)*3, WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		YesButton.SetText(YesText);
		YesButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_Yes)
			YesButton.SetFont(F_Bold);
		else
			YesButton.SetFont(F_Normal);
		break;
	case MB_YesNo:
		NoButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW), WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		NoButton.SetText(NoText);
		NoButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_No)
			NoButton.SetFont(F_Bold);
		else
			NoButton.SetFont(F_Normal);
		YesButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW)*2, WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		YesButton.SetText(YesText);
		YesButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_Yes)
			YesButton.SetFont(F_Bold);
		else
			YesButton.SetFont(F_Normal);
		break;
	case MB_OKCancel:
		CancelButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW), WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		CancelButton.SetText(CancelText);
		CancelButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_Cancel)
			CancelButton.SetFont(F_Bold);
		else
			CancelButton.SetFont(F_Normal);
		OKButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW)*2, WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		OKButton.SetText(OKText);
		OKButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_OK)
			OKButton.SetFont(F_Bold);
		else
			OKButton.SetFont(F_Normal);
		break;
	case MB_OK:
		OKButton = UWindowSmallButton(CreateControl(class'UWindowSmallButton', WinWidth - (MB_ButtonWidth + MB_ButtonBorderW), WinHeight - MB_ButtonDistFromFrameBottom, MB_ButtonWidth, MB_ButtonHeight));
		OKButton.SetText(OKText);
		OKButton.WinHeight = MB_ButtonHeight;
		if(EnterResult == MR_OK)
			OKButton.SetFont(F_Bold);
		else
			OKButton.SetFont(F_Normal);
		break;
	}
}

function Notify(UWindowDialogControl C, byte E)
{
	local UWindowMessageBox P;

	P = UWindowMessageBox(ParentWindow);

	if(E == DE_Click)
	{
		switch(C)
		{
		case YesButton:
			P.Result = MR_Yes;
			P.Close();			
			break;
		case NoButton:
			P.Result = MR_No;
			P.Close();
			break;
		case OKButton:
			P.Result = MR_OK;
			P.Close();
			break;
		case CancelButton:
			P.Result = MR_Cancel;
			P.Close();
			break;
		}
	}
}

defaultproperties
{
	YesText="Yes"
	NoText="No"
	OKText="OK"
	CancelText="Cancel"
	MB_ButtonWidth = 68	// was 48
	MB_ButtonHeight = 28
	MB_ButtonBorderW = 6
	MB_ButtonBorderH = 6
	MB_BorderW = 16
	MB_BorderH = 20
	}