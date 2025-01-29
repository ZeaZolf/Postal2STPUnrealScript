///////////////////////////////////////////////////////////////////////////////
// MenuControls.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The controls menu.
//
// History:
//	01/13/03 JMI	Added strHelp parameter to AddChoice() allowing us to pass
//					in many help strings that had been created but were not 
//					being used for standard menu choices.  Added generic 
//					RestoreHelp for menus sporting a Restore option.
//
//	12/17/02 NPF	Made entires fit those in the manual, ie, Character is now Actions, etc.
//	11/12/02 NPF	Filled out more options, changed some names
//
//	09/22/02 JMI	Filled in options.
//
//	08/31/02 MJR	Started it.
//
///////////////////////////////////////////////////////////////////////////////
class MenuControls extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string ControlsTitleText;

var ShellMenuChoice		MovementChoice;
var localized string	MovementControlsText;
var localized string	MovementControlsHelp;

var ShellMenuChoice		ActionsChoice;
var localized string	ActionsControlsText;
var localized string	ActionsControlsHelp;

var ShellMenuChoice		WeaponChoice;
var localized string	WeaponControlsText;
var localized string	WeaponControlsHelp;

var ShellMenuChoice		InvChoice;
var localized string	InvControlsText;
var localized string	InvControlsHelp;

var ShellMenuChoice		MiscChoice;
var localized string	MiscControlsText;
var localized string	MiscControlsHelp;

var ShellMenuChoice		DisplayChoice;
var localized string	DisplayControlsText;
var localized string	DisplayControlsHelp;

var ShellMenuChoice		InputChoice;
var localized string	InputText;
var localized string	InputHelp;

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	AddTitle(ControlsTitleText, TitleFont, TitleAlign);

	MovementChoice		= AddChoice(MovementControlsText	, MovementControlsHelp,	ItemFont, ItemAlign);
	ActionsChoice		= AddChoice(ActionsControlsText		, ActionsControlsHelp,	ItemFont, ItemAlign);
	WeaponChoice		= AddChoice(WeaponControlsText		, WeaponControlsHelp,	ItemFont, ItemAlign);
	InvChoice			= AddChoice(InvControlsText			, InvControlsHelp,		ItemFont, ItemAlign);
	MiscChoice			= AddChoice(MiscControlsText		, MiscControlsHelp,		ItemFont, ItemAlign);
	DisplayChoice		= AddChoice(DisplayControlsText		, DisplayControlsHelp,	ItemFont, ItemAlign);
	InputChoice			= AddChoice(InputText				, InputHelp,			ItemFont, ItemAlign);

	BackChoice			= AddChoice(BackText 				, "", ItemFont, ItemAlign, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	local ShellMenuCW		mnuNext;

	Super.Notify(C, E);
	switch (E)
		{
		case DE_Change:
			switch (C)
				{
				}
			break;
		case DE_Click:
			switch (C)
				{
				case MovementChoice		:
					mnuNext = GoToMenu(class'MenuControlsEditMovement');
					break;
				case ActionsChoice			:
					mnuNext = GoToMenu(class'MenuControlsEditActions');
					break;
				case WeaponChoice		:
					mnuNext = GoToMenu(class'MenuControlsEditWeapons');
					break;
				case InvChoice		:
					mnuNext = GoToMenu(class'MenuControlsEditInv');
					break;
				case MiscChoice		:
					mnuNext = GoToMenu(class'MenuControlsEditMisc');
					break;
				case DisplayChoice		:
					mnuNext = GoToMenu(class'MenuControlsEditDisplay');
					break;
				case InputChoice		:
					mnuNext = GoToMenu(class'MenuInput');
					break;
				case BackChoice:
					GoBack();
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
	MenuWidth	= 250	// 02/01/03 JMI Decreased menu size for better centered
						//				appearance.
	HintLines	= 4		// 02/01/03 JMI Increased hint lines b/c we made this menu
						//				even thinner.

	ControlsTitleText			= "Controls"

	MovementControlsText		= "Movement"
	MovementControlsHelp		= "Edit the keys for character movement"

	ActionsControlsText			= "Actions"
	ActionsControlsHelp			= "Edit the keys for character actions"

	WeaponControlsText			= "Weapons"
	WeaponControlsHelp			= "Edit the keys for changing and using weapons"

	InvControlsText				= "Inventory"
	InvControlsHelp				= "Edit the keys for changing and using inventory items"

	MiscControlsText			= "Miscellaneous"
	MiscControlsHelp			= "Edit the keys for things like pause and taking screenshots"

	DisplayControlsText			= "Display"
	DisplayControlsHelp			= "Edit the keys for modifying the display"

	InputText			= "Input Config"
	InputHelp			= "Edit your mouse and joystick options"
	}
