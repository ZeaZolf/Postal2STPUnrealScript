//=============================================================================
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class UncleDave extends Bystander
	placeable;

defaultproperties
	{
	Mesh=Mesh'Characters.Avg_M_SS_Pants'
	Skins[0]=Texture'ChameleonSkins.Special.UncleDave'
	HeadSkin=Texture'ChamelHeadSkins.Special.UncleDave'
	HeadMesh=Mesh'Heads.AvgMale'

	bRandomizeHeadScale=false
	bPersistent=true
	bKeepForMovie=true
	bCanTeleportWithPlayer=false
	bUseForErrands=true

	ControllerClass=class'DaveController'
	bIsTrained=true
	BaseEquipment[0]=(weaponclass=class'Inventory.ShotgunWeapon')
	bPlayerIsFriend=true
	Gang="DaveGang"
	bStartupRandomization=false
	HealthMax=200
	PainThreshold=0.95
	VoicePitch=1.15
	Rebel=1.0
	Cajones=1.0
	Stomach=0.95
	TakesShotgunHeadShot=	0.2
	TakesRifleHeadShot=		0.3
	TakesShovelHeadShot=	0.3
	TakesOnFireDamage=		0.3
	TakesAnthraxDamage=		0.4
	TakesShockerDamage=		0.1
	TakesPistolHeadShot=	0.3
	TakesChemDamage=		0.3
	}
