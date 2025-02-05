///////////////////////////////////////////////////////////////////////////////
// MenuControlsEditWeapons.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
//	02/01/03 JMI	Moved all control definitions into the base class.  The idea
//					is to be able to know all the mappable controls from all the
//					menus.  GetControls() still returns the controls this menu
//					will edit.
//
// 12/17/02 NPF Moved some new items here from Character (Actions) and made it
//				not just about hotkeys.
//
///////////////////////////////////////////////////////////////////////////////
class MenuControlsEditWeapons extends MenuControlsEdit;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string ControlsTitleText;

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();

	AddTitle(ControlsTitleText, TitleFont, TitleAlign);
	}

///////////////////////////////////////////////////////////////////////////////
// Get the controls to be edited.  Tells the base class what to edit.
///////////////////////////////////////////////////////////////////////////////
function array<Control> GetControls()
{
	return aWeaponControls;
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	ControlsTitleText = "Weapons Controls"
	}
