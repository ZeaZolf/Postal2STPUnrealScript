//=============================================================================
// Nurses
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// This is a base class for all people of this type and it can also be placed
// into the level to generate a random person of this type.
//
//=============================================================================
class Nurses extends Bystander
	placeable;


defaultproperties
	{
	bUsePawnSlider=true
	Skins[0]=Texture'ChameleonSkins.FW__086__Fem_LS_Skirt'
	Mesh=Mesh'Characters.Fem_LS_Skirt'
	ControllerClass=class'NurseController'
	bIsFemale=true
	bInnocent=true
	}
