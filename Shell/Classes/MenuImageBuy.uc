///////////////////////////////////////////////////////////////////////////////
// MenuImageBuy.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The Buy menu.
//
//	History:
//	01/26/03 JMI	Super's notify was executing a goback on exit b/c we're using
//					the BackChoice for quit.  Since we're also doing something
//					with this option, changed to just use a different choice to
//					avoid doing too much.  Not sure if there would be a side
//					effect but it seems like, at the least, there was a possibility
//					of accidentally catching a glimpse of the Confirmation menu 
//					before quiting which would be weird.
//
//	01/23/03 JMI	Now actually launches the strBuyLink.
//
//	01/22/03 JMI	Started from MenuImage.
//
///////////////////////////////////////////////////////////////////////////////
// This class describes the plead for money screen.
//
// Future enhancements:
//
///////////////////////////////////////////////////////////////////////////////
class MenuImageBuy extends MenuImage;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string strExitText;
var localized string strBuyText;
var localized string strBuyLink;

var ShellMenuChoice BuyChoice;
var ShellMenuChoice	ExitChoice;

var transient int	SongHandle;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();

	SongHandle = GetGameSingle().PlayMusicExt("endmusic.ogg", 0.1);

	ItemAlign  = TA_Center;
	BuyChoice  = AddChoice(strBuyText,	"", ItemFont, ItemAlign, false);
	ExitChoice = AddChoice(strExitText,	"", ItemFont, ItemAlign, false);
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	Super.Notify(C, E);
	switch(E)
		{
		case DE_Click:
			switch (C)
				{
				case BuyChoice:
					GetPlayerOwner().ConsoleCommand("start"@strBuyLink);
					// Intentional fall through to exit game.
				case ExitChoice:
					if (SongHandle != 0)
						{
						GetGameSingle().StopMusicExt(SongHandle, 0.1);
						SongHandle = 0;
						}
					ShellRootWindow(Root).ExitApp();
					break;
				}
			break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	TextureImageName = "buyscreen.buynow"

	strExitText = "EXIT"
	strBuyText = "BUY"
	strBuyLink = "http://www.gopostal.com/Postal2DemoBuy/"

	aregButtons[0]=(X=366,Y=440,W=110,H=30)	// Using 640x480 locations to determine percentages.  Could make this automatic..?
	aregButtons[1]=(X=500,Y=440,W=110,H=30)	// Using 640x480 locations to determine percentages.	
	}
