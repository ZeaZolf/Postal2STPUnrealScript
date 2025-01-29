///////////////////////////////////////////////////////////////////////////////
// MenuGame.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The In-Game menu.
//
// History:
//	01/22/03 JMI	Save option now brings up Save menu.
//
//	01/13/03 JMI	Added Load option.
//
//	01/13/03 JMI	Added strHelp parameter to AddChoice() allowing us to pass
//					in many help strings that had been created but were not 
//					being used for standard menu choices.  Added generic 
//					RestoreHelp for menus sporting a Restore option.
//
//	09/04/02 MJR	Major rework for new system.
//
///////////////////////////////////////////////////////////////////////////////
// This class describes the game menu details and processes game menu events.
///////////////////////////////////////////////////////////////////////////////
class MenuGame extends BaseMenuBig;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var ShellMenuChoice		ResumeChoice;
var localized string	ResumeText;

var ShellMenuChoice		CheatsChoice;
var localized string	CheatsText;
var localized string	CheatsHelp;

var ShellMenuChoice		LoadChoice;

var ShellMenuChoice		SaveChoice;
var localized string	SaveText;

var ShellMenuChoice		QuitChoice;
var localized string	QuitText;

var localized string	DisabledForCinematicHelpText;
var localized string	DisabledNowText;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	local String OptionsHelpText;
	local bool bOptionsActive;
	local String LoadHelpText;
	local String SaveHelpText;
	local bool bLoadActive;
	local bool bSaveActive;

	Super.CreateMenuContents();

	bOptionsActive = true;
	bLoadActive = true;
	bSaveActive = true;

	if (GetGameSingle().IsCinematic())
		{
		OptionsHelpText = DisabledForCinematicHelpText;
		bOptionsActive = false;
		LoadHelpText = DisabledForCinematicHelpText;
		SaveHelpText = DisabledForCinematicHelpText;
		bLoadActive = false;
		bSaveActive = false;
		}

	if (!GetGameSingle().IsSaveAllowed(P2Player(GetPlayerOwner())))
		{
		bSaveActive = false;
		SaveHelpText = DisabledNowText;
		}

	// Check for demo last so this help text will override other help text
	if (bInDemo)
		{
		LoadHelpText = OptionUnavailableInDemoHelpText;
		SaveHelpText = OptionUnavailableInDemoHelpText;
		bLoadActive = false;
		bSaveActive = false;
		}

	AddTitleBitmap(TitleTexture);
	if(GetGameSingle() != None && GetGameSingle().FinallyOver() && !bInDemo)
		CheatsChoice	= AddChoice(CheatsText,	CheatsHelp,			ItemFont, ItemAlign);
	SaveChoice		= AddChoice(SaveText,		SaveHelpText,		ItemFont, ItemAlign);
	LoadChoice		= AddChoice(LoadGameText,	LoadHelpText,		ItemFont, ItemAlign);
	OptionsChoice	= AddChoice(OptionsText,	OptionsHelpText,	ItemFont, ItemAlign);
	QuitChoice		= AddChoice(QuitText,		"",					ItemFont, ItemAlign);
	ResumeChoice	= AddChoice(ResumeText,		"",					ItemFont, ItemAlign);

	// Enable/disable various options (only works with MenuChoice)
	OptionsChoice.bActive = bOptionsActive;
	SaveChoice.bActive = bSaveActive;
	LoadChoice.bActive = bLoadActive;
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	local String StartURL;

	Super.Notify(C, E);
	switch(E)
		{
		case DE_Click:
			switch (C)
				{
				case ResumeChoice:
					ResumeGame();
					break;
				case CheatsChoice:
					GoToMenu(class'MenuCheats');
					break;
				case SaveChoice:
					GoToMenu(class'MenuSave');
					break;
				case LoadChoice:
					GoToMenu(class'MenuLoad');
					break;
				case QuitChoice:
					GoToMenu(class'MenuQuitExitConfirmation');	// 01/21/03 JMI Now looks for confirmation.
					break;
				case OptionsChoice:
					GoToMenu(class'MenuOptions');
					break;
				}
			break;
		}
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
				ResumeGame();
				return true;
			}
		}
	
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Resume playing game
///////////////////////////////////////////////////////////////////////////////
function ResumeGame()
	{
	HideMenu();
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	ResumeText = "Resume Game"
	SaveText = "Save Game"
	QuitText = "Quit Game"
	
	CheatsText = "Cheats"
	CheatsHelp = "Grant yourself various cheats for extra fun!"
	
	DisabledForCinematicHelpText = "Not available during cinematic"
	DisabledNowText = "Not available in this state"

	bBlockConsole=false
	}
