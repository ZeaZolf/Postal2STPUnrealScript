///////////////////////////////////////////////////////////////////////////////
// PreLoader.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// History:
//	07/10/02 MJR	Started by copying errand stuff from DudePlayer.
//
///////////////////////////////////////////////////////////////////////////////
//
// This class is designed to be placed into a map for the purpose of
// preloading other objects (classes, textures, whatever).
//
//
///////////////////////////////////////////////////////////////////////////////
class PreLoader extends Info
	placeable;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

// References to items to preload when this class is loaded.  Anything in this
// list will always be preloaded.
var() array<Object>		AutoLoads;

// Names of items to preload when this object is triggered.  Anything in tihs
// list will only be preloaded if this object is triggered.
var() array<String>		TrigLoads;
var bool				bTriggered;


///////////////////////////////////////////////////////////////////////////////
// Trigger can be used to tell preload when to load
///////////////////////////////////////////////////////////////////////////////
function Trigger(Actor Other, Pawn Instigator)
	{
	local int i;

	if (!bTriggered)
		{
		for (i = 0; i < TrigLoads.Length; i++)
			{
			if (DynamicLoadObject(TrigLoads[i], class'Object') == None)
				Warn("Couldn't load "$TrigLoads[i]);
			}

		bTriggered = true;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	}
