///////////////////////////////////////////////////////////////////////////////
// CopBlack
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Traditional city police.
//
///////////////////////////////////////////////////////////////////////////////
class CopBlack extends Police
	placeable;

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__144__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	ChameleonSkins(0)="ChameleonSkins.FB__126__Fem_LS_Pants"
	ChameleonSkins(1)="ChameleonSkins.FM__125__Fem_LS_Pants"
	ChameleonSkins(2)="ChameleonSkins.FW__127__Fem_LS_Pants"
	ChameleonSkins(3)="ChameleonSkins.MB__032__Avg_M_SS_Pants"
	ChameleonSkins(4)="ChameleonSkins.MM__030__Avg_M_SS_Pants"
	ChameleonSkins(5)="ChameleonSkins.MW__031__Avg_M_SS_Pants"
	ChameleonSkins(6)="end"	// end-of-list marker (in case super defines more skins)
	}
