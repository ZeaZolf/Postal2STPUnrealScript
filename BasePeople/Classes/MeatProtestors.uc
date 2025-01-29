//=============================================================================
// MeatProtestors
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for the meat protestor characters.
//
//=============================================================================
class MeatProtestors extends Protestors
	placeable;

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__151__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	ChameleonSkins(0)="ChameleonSkins.FW__088__Fem_LS_Skirt"
	ChameleonSkins(1)="ChameleonSkins.MW__042__Avg_M_SS_Pants"
	ChameleonSkins(2)="end"	// end-of-list marker (in case super defines more skins)

	Glaucoma=0.7
	Gang="MeatProtestors"
	}
