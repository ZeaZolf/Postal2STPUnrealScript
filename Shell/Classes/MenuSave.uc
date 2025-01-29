///////////////////////////////////////////////////////////////////////////////
// MenuSave.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The Save menu.
//
// History:
//  02/02/03 JMI	Removed c_strGamePrefix, added help string, and put in
//					message box notifying the game was saved..
//
//	01/22/03 JMI	Started it.
//
///////////////////////////////////////////////////////////////////////////////
// Extended MenuSave class merely chooses what to do when a slot is chosen.
///////////////////////////////////////////////////////////////////////////////
class MenuSave extends MenuLoadSave;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string	SavedGameTitle;
var localized string	SavedGameText;

var localized string	ReplaceGameTitle;
var localized string	ReplaceGameText;

var int					iCurSlot;

///////////////////////////////////////////////////////////////////////////////
// Behavior for when a slot is chosen.
///////////////////////////////////////////////////////////////////////////////
function OnSlotChoice(int i)
{
	if (IsSlotEmpty(i) )
		SaveSlot(i);
	else
		{
		iCurSlot = i;
		MessageBox(ReplaceGameTitle, ReplaceGameText, MB_YESNO, MR_NO, MR_YES);
		}
}

///////////////////////////////////////////////////////////////////////////////
// Actually save the game to the current slot.
///////////////////////////////////////////////////////////////////////////////
function SaveSlot(int i)
	{
	if (i >= 0)
		{
		// NOTE: I had tried to make sure the game was not paused prior to
		// saving it so that when it is loaded it won't be paused, but that
		// didn't work and I don't know why.  Instead, it seemed just as
		// easy to handle this after a game has been loaded.

		// 02/19/03 JMI Slot value is now represented in a separate sorted 
		//				array and the slots themselves are not sorted.
		GetGameSingle().SaveGame(aiSlotOrder[i], false);
		UpdateSlotUI(i);

		MessageBox(SavedGameTitle, SavedGameText, MB_OK, MR_OK, MR_OK);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Notification that the message box has finished.
///////////////////////////////////////////////////////////////////////////////
function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	switch (Result)
		{
		case MR_OK:
			// If it's the game menu then resume the game
			if (IsGameMenu())
				HideMenu();
			break;
		case MR_YES:
			// Replace existing slot.
			SaveSlot(iCurSlot);
			break;
		case MR_NO:
			// Whimped out..carry on.
			break;
		}

	iCurSlot = -1;
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
	MenuTitleText = "Save Game"

	strSlotHelp = "Save game to this slot";

	SavedGameTitle = "Save Game"
	SavedGameText  = "Your game has been saved"

	ReplaceGameTitle = "Save Over Game"
	ReplaceGameText  = "Are you sure you want to save over this slot?"
	
	// 02/16/03 JMI No longer changing the sort between menus--it's weird.
	// bSortSlotsAscending = true	// Oldest entries on top as we probably want to overwrite these.

	bShowSpecialSlots = false;
}
