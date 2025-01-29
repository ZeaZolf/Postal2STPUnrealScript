///////////////////////////////////////////////////////////////////////////////
// RadarTargetPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Backup for radar pickup, plugs into it (when used with radar)
//
///////////////////////////////////////////////////////////////////////////////

class RadarTargetPickup extends OwnedPickup;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'RadarTargetInv'
	PickupMessage="You picked up the 'Chompy' Game Cartridge for BassSniffer Radar."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Josh_mesh.signs.Fish_Cartridge'
	Skins[0]=Texture'Josh-textures.Skins.Chompy_pack'
	BounceSound=Sound'MiscSounds.PickupSounds.BookDropping'
	}
