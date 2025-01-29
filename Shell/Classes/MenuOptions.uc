///////////////////////////////////////////////////////////////////////////////
// MenuOptions.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The Options menu.
//
// History:
//	01/26/03 JMI	Added Credits option.
//	01/13/03 JMI	Added strHelp parameter to AddChoice() allowing us to pass
//					in many help strings that had been created but were not 
//					being used for standard menu choices.  Added generic 
//					RestoreHelp for menus sporting a Restore option.
//	01/12/03 JMI	Changed bDontAsk to bAsk.
//	01/12/03 JMI	Added intermediate menu introducing Wizard and Advanced.
//	12/18/02 JMI	Per Mike's suggestion, reversed the order of the menus.
//					The old Performance menu became the Advanced menu and the
//					Performance Wizard became the Performance menu.
//  12/17/02 NPF	Moved performance menu here from Video
//	06/29/02 MJR	Started it.
//
///////////////////////////////////////////////////////////////////////////////
class MenuOptions extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var ShellMenuChoice		CreditsChoice;
var localized string	CreditsText;
var localized string	CreditsHelp;

var ShellMenuChoice		CustomMapChoice;
var localized string	CustomMapText;
var localized string	CustomMapHelp;

var int					CustomMapWidth;
var int					CustomMapHeight;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	
	AddTitle(OptionsText, TitleFont, TitleAlign);

	GameChoice			= AddChoice(GameOptionsText,	GameOptionsHelp,	ItemFont, ItemAlign);
	ControlsChoice		= AddChoice(ControlOptionsText, ControlOptionsHelp,	ItemFont, ItemAlign);
	VideoChoice			= AddChoice(VideoOptionsText,	VideoOptionsHelp,	ItemFont, ItemAlign);
	AudioChoice			= AddChoice(AudioOptionsText,	AudioOptionsHelp,	ItemFont, ItemAlign);
	PerformanceChoice	= AddChoice(PerformanceText,	PerformanceHelp,	ItemFont, ItemAlign);
	if(bInDemo)
		{
		CustomMapChoice	= AddChoice(CustomMapText,		OptionUnavailableInDemoHelpText,ItemFont, ItemAlign);
		CustomMapChoice.bActive=false;
		}
	else
		CustomMapChoice	= AddChoice(CustomMapText,		CustomMapHelp,		ItemFont, ItemAlign);
	if (!bInDemo)
		CreditsChoice	= AddChoice(CreditsText,		CreditsHelp,		ItemFont, ItemAlign);
	BackChoice			= AddChoice(BackText, "", ItemFont, ItemAlign, true);
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
			if (C != None)
				switch (C)
					{
					case BackChoice:
						GoBack();
						break;
					case VideoChoice:
						GoToMenu(class'MenuVideo');
						break;
					case AudioChoice:
						GoToMenu(class'MenuAudio');
						break;
					case ControlsChoice:
						GoToMenu(class'MenuControls');
						break;
					case GameChoice:
						GoToMenu(class'MenuGameSettings');
						break;
					case PerformanceChoice:
						GoToMenu(class'MenuPerformance');
						break;
					case CreditsChoice:
						GoToMenu(class'MenuImageCredits');
						break;
					case CustomMapChoice:
						Root.ShowModal(Root.CreateWindow(class'ShellMapListFrame', 
										(Root.WinWidth - CustomMapWidth) /2, 
										(Root.WinHeight - CustomMapHeight) /2, 
										CustomMapWidth, CustomMapHeight, self));
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
	MenuWidth	= 250	// 01/26/03 JMI Decreased menu size for better centered
						//				appearance.
	HintLines	= 4		// 01/26/03 JMI Increased hint lines b/c we made this menu
						//				even thinner.
						// 01/19/03 JMI Increased number of hint lines required
						//				b/c this is a particularly thin menu.

	CreditsText		= "Credits"
	CreditsHelp		= ""

	CustomMapText	= "Custom Map"
	CustomMapHelp	= "Opens a browser for playing user-made levels created with the editor."
	CustomMapWidth	= 350
	CustomMapHeight	= 250
	}
