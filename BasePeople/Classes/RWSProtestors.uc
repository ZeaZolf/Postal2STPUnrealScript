//=============================================================================
// Protestors
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for the RWS protestor characters.
//
//=============================================================================
class RWSProtestors extends Protestors
	placeable;

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__155__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	ChameleonSkins(0)="ChameleonSkins.FW__089__Fem_LS_Skirt"
	ChameleonSkins(1)="ChameleonSkins.MW__054__Avg_M_SS_Pants"
	ChameleonSkins(2)="end"	// end-of-list marker (in case super defines more skins)

	Glaucoma=0.8
	Gang="RWSProtestors"
	}
