///////////////////////////////////////////////////////////////////////////////
// MenuImageDemoExplain.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The "what's going on the demo" screen.
//
///////////////////////////////////////////////////////////////////////////////
class MenuImageDemoExplain extends MenuImage;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////
var localized string	NextText;
var ShellMenuChoice		StartChoice;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();

	ItemAlign  = TA_Left;
	ItemFont = F_FancyL;

	StartChoice	= AddChoice(NextText,"", ItemFont, ItemAlign);
	BackChoice = AddChoice(BackText,	"", ItemFont, ItemAlign, true);
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
				case BackChoice:
					GoBack();
					break;

				case StartChoice:
					GotoMenu(class'MenuImageKeys');
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
	NextText = "Next"

	TextureImageName = "DemoTextures.screens.Demo_Screen_Exp"

	aregButtons[0]=(X=560,Y=410,W=80,H=30)	// Using 640x480 locations to determine percentages.
	aregButtons[1]=(X=560,Y=440,W=80,H=30)	// Using 640x480 locations to determine percentages.
	}
