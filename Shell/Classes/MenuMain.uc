///////////////////////////////////////////////////////////////////////////////
// MenuMain.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The Main menu.
//
// History:
//
//	01/19/03 JMI	Removed multiplayer choice.
//
//	01/13/03 JMI	Added strHelp parameter to AddChoice() allowing us to pass
//					in many help strings that had been created but were not 
//					being used for standard menu choices.  Added generic 
//					RestoreHelp for menus sporting a Restore option.
//
//	09/04/02 MJR	Major rework for new system.
//
///////////////////////////////////////////////////////////////////////////////
// This class describes the main menu details and processes main menu events.
///////////////////////////////////////////////////////////////////////////////
class MenuMain extends BaseMenuBig;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////
var ShellMenuChoice		NewChoice;
var localized string	NewGameText;

// For when you beat the game
var ShellMenuChoice		EnhancedChoice;
var localized string	EnhancedText;

var ShellMenuChoice		LoadChoice;

var ShellMenuChoice		MultiChoice;
var localized string	MultiText;

var ShellMenuChoice		ExitChoice;
var localized string	ExitGameText;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	AddTitleBitmap(TitleTexture);
	NewChoice     = AddChoice(NewGameText,		"",									ItemFont, ItemAlign);

	if(GetGameSingle() != None && GetGameSingle().VerifySeqTime(true))
		ShellRootWindow(Root).bVerified = true;
	// Only add this option in after you've beaten the game
	if(ShellRootWindow(Root).bVerified)
		EnhancedChoice= AddChoice(EnhancedText,		"",									ItemFont, ItemAlign);
	LoadChoice    = AddChoice(LoadGameText,		OptionUnavailableInDemoHelpText,	ItemFont, ItemAlign);
	MultiChoice   = AddChoice(MultiText,		"",									ItemFont, ItemAlign);
	OptionsChoice = AddChoice(OptionsText,		"",									ItemFont, ItemAlign);
	ExitChoice    = AddChoice(ExitGameText,		"",									ItemFont, ItemAlign);

	// 01/23/03 JMI Don't allow access to load or save in demos.
	//				NOTE: This only works for ShellMenuChoices--not actual controls.
	LoadChoice.bActive = !bInDemo;

	// Reset this value. When MenuDifficultyPatch starts up, it's the only one that needs it
	// and it will set it when necessary.
	ShellRootWindow(Root).bFixSave=false;
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	local String NewGameURL;

	Super.Notify(C, E);
	switch(E)
		{
		case DE_Click:
			if (C != None)
				switch (C)
					{
					case NewChoice:
						// Start new game
						SetSingleplayer();
						ShellRootWindow(Root).bVerifiedPicked=false;
						if(!bInDemo)
							// If not in the demo--allow them to pick the difficulty
							GotoMenu(class'MenuStart');
						else
							// The difficulty is set to default for the demo.
							// Go to the explaination instead.
							GotoMenu(class'MenuImageDemoExplain');
						break;

					case EnhancedChoice:
						SetSingleplayer();
						ShellRootWindow(Root).bVerifiedPicked=true;
						GotoMenu(class'MenuEnhanced');
						break;

					case LoadChoice:
						SetSingleplayer();
						GotoMenu(class'MenuLoad');
						break;

					case MultiChoice:
						GotoMenu(class'MenuMulti');
						break;

					case OptionsChoice:
						GoToMenu(class'MenuOptions');
						break;

					case ExitChoice:
						GoToMenu(class'MenuQuitExitConfirmation');	// 01/21/03 JMI Now looks for confirmation.
						break;
					}
				break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Set temp options for singleplayer game
///////////////////////////////////////////////////////////////////////////////
function SetSingleplayer()
	{
	ShellRootWindow(Root).bLaunchedMultiplayer = false;
	GetPlayerOwner().UpdateURL("Name", class'GameInfo'.Default.DefaultPlayerName, false);
	GetPlayerOwner().UpdateURL("Class", "People.PostalDude", false);
	}

///////////////////////////////////////////////////////////////////////////////
// Handle a key event
///////////////////////////////////////////////////////////////////////////////
function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
	{
	if (Action == IST_Release)
		{
		switch (Key)
			{
			case IK_ESCAPE:
				// Only allow ESC to hide the main menu if it was also used to show it
				if (ShellRootWindow(root).bMainMenuShownViaESC)
					HideMenu();
				return true;
			}
		}
	
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	NewGameText = "New Game"
	EnhancedText = "Enhanced Game"
	MultiText = "Multiplayer"
	ExitGameText = "Exit"

	bBlockConsole=false
	}
