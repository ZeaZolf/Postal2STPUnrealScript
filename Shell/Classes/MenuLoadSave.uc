///////////////////////////////////////////////////////////////////////////////
// MenuLoadSave.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The Save menu.
//
// History:
//	02/19/03 JMI	Moved slot ownership into P2GameInfoSingle which seems to
//					have simplified things nicely.
//
//  02/02/03 JMI	Removed c_strGamePrefix as you can only save by digit which
//					works just as well.  Added ShellInfo to house save game
//					names where all menus can access them.  If they're saved
//					as a config item here, there ends up being two: one under
//					MenuLoad and the other under MenuSave.
//					Made MenuLoad not allowed to edit the labels so a simple
//					click can start the load process.
//
//	02/01/03 JMI	Now hooks Enter as the indication to perform the slot 
//					choice.  Changed the editbox to delayed notify mode so
//					it's not constantly updating the user save label with
//					each keystroke.
//
//	01/22/03 JMI	Started it.
//
///////////////////////////////////////////////////////////////////////////////
// The common base class for the load and save menus.  This way we can easily
// share load/save game names.
///////////////////////////////////////////////////////////////////////////////
class MenuLoadSave extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

const AUTO_SLOT_INDEX = 10;
const EASY_SLOT_INDEX = 9;
const c_iLastSpecialSlot = 1;

const c_strAutoSaveEnabledPath = "Postal2Game.P2GameInfoSingle bUseAutoSave";

const c_strSaveFileNameFormat	= "Save~0.usa";

const c_strSaveInfoLost = "<Unknown Day> - <Unknown Level> - <Difficulty?>";

var localized string MenuTitleText;
var localized string strSlotHelp;	// Should we decide help is necessary,
									// the derived class would set this.
var localized string strSlotEmpty;	// Text for an empty slot.
var bool			 bSortSlotsAscending;	// true to sort slots in ascending order (oldest on top).

var array<ShellTextControl>	SlotChoice;

var localized string		astrLabels[11];		// Special labels to precede special slots.
var bool					bShowSpecialSlots;	// true to specialized slots.

var array<int>				aiSlotOrder;	// Sorted order of slots.  Much better than actually reordering the slots--duh.


///////////////////////////////////////////////////////////////////////////////
// Update a slot's UI
// 02/16/03 JMI Added specialized labels to precede slot name when not empty.
// 02/16/03 JMI Updated to center the label when the slot is empty and changed
//				to do all empty vs. full decisions right here eliminating the
//				separate decision points for this that may have caused one 
//				column to display invalid info.
// 02/10/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function UpdateSlotUI(int iSlot)
	{
	local string			strLabel;

	strLabel = "";
	if (aiSlotOrder[iSlot] < ArrayCount(astrLabels) )
		strLabel = astrLabels[aiSlotOrder[iSlot] ];

	if (IsSlotEmpty(iSlot) )
		{
		SlotChoice[iSlot].SetText (strLabel $ strSlotEmpty);
		SlotChoice[iSlot].SetValue("");
		SlotChoice[iSlot].Align			= TA_Left;
		SlotChoice[iSlot].ValueAlign	= TA_Center;
		}
	else
		{
		SlotChoice[iSlot].SetText (GetSlotTime(iSlot) );
		SlotChoice[iSlot].SetValue(strLabel $ GetSlotName(iSlot));
		SlotChoice[iSlot].Align			= TA_Right;
		SlotChoice[iSlot].ValueAlign	= TA_Left;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Get the save filename for a slot.
// 02/20/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function string GetSlotFileName(int iSlot)
	{
	local array<string> astrArgs;
	astrArgs[0] = "" $ iSlot;
	return Sprintf(c_strSaveFileNameFormat, astrArgs);
	}

///////////////////////////////////////////////////////////////////////////////
// Get the display time for a slot.
// 02/21/03 JMI Now determines time of save by file's last modification date.
//				We could eliminate the storage of the time altogether and just
//				use this technique unless we're concerned with weird time 
//				conversion issues.
// 02/09/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function string GetSlotTime(int iSlot)
	{
	local string strTime;
	if (IsSlotEmpty(iSlot) )
		return "";
	else
		{
		// 02/20/03 JMI If there's no stored time, attempt to get it.
		strTime = GetSlot(iSlot).Time ;
		if (strTime == "")
			{
			strTime = GetPlayerOwner().ConsoleCommand("GETFILETIMESTR" @ GetSlotFileName(aiSlotOrder[iSlot]) );
			}

		return strTime;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Get the name for a slot.
// 02/21/03 JMI Now displays special string for lost slot info.
// 02/09/03 JMI Changed to never display empty text.  Empty is now displayed
//				in time column.
// 02/09/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function string GetSlotName(int iSlot)
	{
	local string strName;
	strName = GetSlot(iSlot).Name;
	// Detect lost save slot info and display string.
	if (strName == "")
		strName = c_strSaveInfoLost;

	return strName;
	}

///////////////////////////////////////////////////////////////////////////////
// Check if a slot is empty.
// 02/09/03 JMI Started to check all that can be checked to determine if a slot
//				is empty.
///////////////////////////////////////////////////////////////////////////////
function bool IsSlotEmpty(int iSlot)
	{
	// 02/20/03 JMI Now we only check if the savegame filename exists ignoring 
	//				blank INI entries.
	if (int(GetPlayerOwner().ConsoleCommand("CHECKSAVEGAME " $ aiSlotOrder[iSlot] ) ) == 0)
		return true;
	else
		return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Check if auto save is empty.
// 02/16/03 JMI Although this check is fairly simple, it takes up a lot of room
//				and I'm trying to keep CreateMenuContents clean.
///////////////////////////////////////////////////////////////////////////////
function bool IsAutoSaveEnabled()
	{
	return bool(GetPlayerOwner().ConsoleCommand("get" @ c_strAutoSaveEnabledPath) );
	}

///////////////////////////////////////////////////////////////////////////////
// Get a slot utilizing the ordering indirection, aiSlotOrder.
///////////////////////////////////////////////////////////////////////////////
function SlotInfoMgr.SlotInfo GetSlot(int iApparentIndex)
	{
	return GetGameSingle().MySlotInfoMgr.GetInfo(aiSlotOrder[iApparentIndex]);
	}

///////////////////////////////////////////////////////////////////////////////
// Sort the slots.  Named for the beauty of the algorithm.
///////////////////////////////////////////////////////////////////////////////
function HorrorSortSlots(int iStart, int iCount, bool bAscending)
{
	local int iMover;
	local int iIter;
	local int iNewPos;
	local int iSlotMax;
	local int iIndex;

	iSlotMax = min(GetGameSingle().MySlotInfoMgr.NumSlots(), iStart + iCount);

	for (iMover = iStart; iMover < iSlotMax; iMover++)
	{
		for (iIter = iStart; iIter < iSlotMax; iIter++)
		{
			if (iMover != iIter && (GetSlot(iMover).lTime < GetSlot(iIter).lTime) == bAscending)
				break;
		}

		// Two step process for simplicity.
		if (iMover != iIter)
		{

			iIndex	= aiSlotOrder[iMover];
			aiSlotOrder.Remove(iMover, 1);
			// Note that if iMover is before iIter, this affects the location of iIter.
			// Note that this should also handle the iIter == iSlotMax case b/c, since iMover
			// is always less than iSlotMax, we'd definitely subtract one from iIter in such
			// a case.
			if (iMover < iIter)
				iIter--;
			aiSlotOrder.Insert(iIter, 1);
			aiSlotOrder[iIter] = iIndex;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	local int	i;
	local int	iMaxSlot;
	local bool 	bAddSlot;
	local ShellMenuChoice chSeparator;
	
	Super.CreateMenuContents();
	
	TitleAlign = TA_Center;
	AddTitle(MenuTitleText, TitleFont, TitleAlign);

	ItemFont = F_FancyS;
	
	if (GetGameSingle() != none)
		{
		iMaxSlot = GetGameSingle().MySlotInfoMgr.NumSlots();

		// Sort the items first.
		HorrorSortSlots(0,						 c_iLastSpecialSlot + 1,			bSortSlotsAscending);
		HorrorSortSlots(c_iLastSpecialSlot + 1, (iMaxSlot - c_iLastSpecialSlot),	bSortSlotsAscending);

		for (i = 0; i < iMaxSlot; i++)
			{
			// Add separator between special and non-special slots.
			if (i == c_iLastSpecialSlot + 1 && MenuItems.Length > 0)
				{
				chSeparator = AddChoice("", "", ItemFont, ItemAlign);
				chSeparator.bActive = false;
				}

			switch (aiSlotOrder[i] )
				{
				case AUTO_SLOT_INDEX:
					bAddSlot = (bShowSpecialSlots && !IsSlotEmpty(i) && IsAutoSaveEnabled() );
					break;
				case EASY_SLOT_INDEX:
					bAddSlot = (bShowSpecialSlots && !IsSlotEmpty(i) );
					break;
				default:
					bAddSlot = true;
					break;
				}

			if (bAddSlot)
				{
					SlotChoice[i] = AddTextItem("", strSlotHelp, ItemFont);
					UpdateSlotUI(i);
				}
			}
		}

	ItemFont = F_FancyM; // make the BACK choice stand out more
	BackChoice = AddChoice(BackText, "", ItemFont, TA_Center, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Behavior for when a slot is chosen.
///////////////////////////////////////////////////////////////////////////////
function OnSlotChoice(int i);

///////////////////////////////////////////////////////////////////////////////
// Find the specified slot index.
///////////////////////////////////////////////////////////////////////////////
function int FindSlot(UWindowDialogControl C)
{
	local int i;
	for (i = 0; i < SlotChoice.Length; i++)
	{
		if (C == SlotChoice[i] )
		{
			return i;
		}
	}

	return -1;
}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
{
	local int i;
	
	Super.Notify(C, E);
	switch(E)
	{
	case DE_Click:
		switch (C)
		{
		case BackChoice:
			GoBack();
			break;
		default:
			// If no editing allowed, there's no reason to wait for the enter.
			i = FindSlot(C);
			if (i >= 0)
				OnSlotChoice(i);
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
	MenuWidth = 640		   // 02/22/03 MJR needed EVEN MORE space for long titles
	fCommonCtlArea = 0.70
	TitleSpacingY = 5
	ItemHeight = 25
	ItemSpacingY = 2

	strSlotEmpty = "<empty>"

	// Note that Easy and Auto saves are first.
	aiSlotOrder[0]  = 9 /*EASY_SLOT_INDEX*/;
	aiSlotOrder[1]  = 10/*AUTO_SLOT_INDEX*/;
	aiSlotOrder[2]  = 0 ;
	aiSlotOrder[3]  = 1 ;
	aiSlotOrder[4]  = 2 ;
	aiSlotOrder[5]  = 3 ;
	aiSlotOrder[6]  = 4 ;
	aiSlotOrder[7]  = 5 ;
	aiSlotOrder[8]  = 6 ;
	aiSlotOrder[9]  = 7 ;
	aiSlotOrder[10] = 8 ;

	astrLabels[9 /*EASY_SLOT_INDEX*/] = "<Easy Save> ";
	astrLabels[10/*AUTO_SLOT_INDEX*/] = "<Auto Save> ";

	bShowSpecialSlots = true;
}

