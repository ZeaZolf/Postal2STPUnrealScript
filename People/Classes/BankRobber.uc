//=============================================================================
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class BankRobber extends Bystander
 	placeable;

defaultproperties
	{
	PainThreshold=1.0
	Cajones=1.0
	Skins[0]=Texture'ChameleonSkins.MM__018__Avg_M_Jacket_Pants'
	Mesh=Mesh'Characters.Avg_M_Jacket_Pants'
	HeadSkin=Texture'ChamelHeadSkins.Special.Robber'
	HeadMesh=Mesh'Heads.Masked'
	BaseEquipment[0]=(weaponclass=class'Inventory.ShotgunWeapon')
	ControllerClass=class'RobberController'
	// Pick nothing on startup--let controller take over
	StartWeapon_Group=-1
	StartWeapon_Offset=-1
	}
