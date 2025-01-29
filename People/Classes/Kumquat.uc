//=============================================================================
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class Kumquat extends Bystander
 	placeable;

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.Special.Kumquat'
	Mesh=Mesh'Characters.Fem_LS_Skirt'
	HeadSkin=Texture'ChamelHeadSkins.Special.Kumquat'
	HeadMesh=Mesh'Heads.FemSHcropped'
	bRandomizeHeadScale=false
	BaseEquipment[0]=(weaponclass=class'Inventory.PistolWeapon')
	ControllerClass=class'KumquatController'
	Gang="Kumquat"
	bIsFemale=true
	bIsHindu=true
	TalkWhileFighting=0.0
	Boltons[0]=(bone="NODE_Parent",staticmesh=staticmesh'boltons.Burka_Mask_Sara',bCanDrop=false,bAttachToHead=true)
	}
