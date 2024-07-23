///////////////////////////////////////////////////////////////////////////////
// CopBlue
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Generally act as security guards. Weakest of cops. Don't have radios.
//
///////////////////////////////////////////////////////////////////////////////
class CopBlue extends Police
	placeable;

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__146__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	// No fat female cops -- they look stupid
	ChameleonSkins(0)="ChameleonSkins.FB__128__Fem_LS_Pants"
	ChameleonSkins(1)="ChameleonSkins.FM__129__Fem_LS_Pants"
	ChameleonSkins(2)="ChameleonSkins.FW__130__Fem_LS_Pants"
	ChameleonSkins(3)="ChameleonSkins.MB__033__Avg_M_SS_Pants"
	ChameleonSkins(4)="ChameleonSkins.MM__034__Avg_M_SS_Pants"
	ChameleonSkins(5)="ChameleonSkins.MW__035__Avg_M_SS_Pants"
	ChameleonSkins(6)="ChameleonSkins.MW__108__Fat_M_SS_Pants"
	ChameleonSkins(7)="end"	// end-of-list marker (in case super defines more skins)

	HealthMax=125
	Reactivity=0.2
	Glaucoma=0.85
	WillDodge=0.25
	DonutLove=0.9
	}
