//=============================================================================
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class Priest_AMW extends Bystander
	placeable;

defaultproperties
	{
	VoicePitch=1.0
	bStartupRandomization=false
	Skins[0]=Texture'ChameleonSkins.Special.Priest'
	Mesh=Mesh'Characters.Avg_M_Jacket_Pants'
	HeadSkin=Texture'ChamelHeadSkins.MWA__007__AvgMale'
	ControllerClass=class'PriestController'
	DialogClass=class'BasePeople.DialogPriest'
	}
