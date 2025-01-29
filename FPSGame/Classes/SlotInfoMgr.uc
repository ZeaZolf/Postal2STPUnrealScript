///////////////////////////////////////////////////////////////////////////////
// SlotInfoMgr.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// Simple class for keeping track of slot information.  The only reason this
// is in a separate class is because we want this info to be in a separate
// ini file so that the info isn't lost when the other ini files are deleted.
//
///////////////////////////////////////////////////////////////////////////////
class SlotInfoMgr extends Info
	config(SavedGameInfo);


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

struct SlotInfo
{
	var string	Name;	// Name assigned by user.
	var int		Day;	// Current day when game was saved
	var string	Time;	// Time of last save.
	var	int		lTime;	// C Time used as sort key.
};

var globalconfig array<SlotInfo> Slots;


///////////////////////////////////////////////////////////////////////////////
// Fill in the info
///////////////////////////////////////////////////////////////////////////////
function SetInfo(int Slot, string Name, int Day, string Time, int lTime)
	{
	Slots[Slot].Name  = Name;
	Slots[Slot].Day = Day;
	Slots[Slot].Time  = Time;
	Slots[Slot].lTime = lTime;
	SaveConfig();
	}

function SlotInfo GetInfo(int Slot)
	{
	return Slots[Slot];
	}

function int NumSlots()
	{
	return Slots.length;
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	Slots(0)=(Name="",Day=0,Time="",lTime=0)
	Slots(1)=(Name="",Day=0,Time="",lTime=0)
	Slots(2)=(Name="",Day=0,Time="",lTime=0)
	Slots(3)=(Name="",Day=0,Time="",lTime=0)
	Slots(4)=(Name="",Day=0,Time="",lTime=0)
	Slots(5)=(Name="",Day=0,Time="",lTime=0)
	Slots(6)=(Name="",Day=0,Time="",lTime=0)
	Slots(7)=(Name="",Day=0,Time="",lTime=0)
	Slots(8)=(Name="",Day=0,Time="",lTime=0)
	Slots(9)=(Name="",Day=0,Time="",lTime=0)
	Slots(10)=(Name="",Day=0,Time="",lTime=0)
	}
