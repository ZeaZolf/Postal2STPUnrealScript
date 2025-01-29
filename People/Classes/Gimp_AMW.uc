//=============================================================================
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// It's the gimp!
//
//=============================================================================
class Gimp_AMW extends Bystander
	placeable;

defaultproperties
	{
	bCanTeleportWithPlayer=false
	Mesh=Mesh'Characters.Avg_Gimp'
	Skins[0]=Texture'ChameleonSkins.Special.Gimp'
	HeadSkin=Texture'ChamelHeadSkins.Special.Gimp'
	HeadMesh=Mesh'Heads.Masked'

	Talkative=0.0
	Beg=1.0
	Champ=0.0
	Cajones=0.0
	PainThreshold=1.0
	Stomach=1.0
	ControllerClass=class'GimpController'
	}
