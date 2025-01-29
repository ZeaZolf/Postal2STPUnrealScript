///////////////////////////////////////////////////////////////////////////////
// CopBrown
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Toughest cops
//
//	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
//	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
//	BaseEquipment[2]=(weaponclass=class'Inventory.ShotgunWeapon')
///////////////////////////////////////////////////////////////////////////////
class CopBrown extends Police
	placeable;

function PreBeginPlay()
	{
	Super.PreBeginPlay();

	// Do this here because we can't use enums in default properties
	ChameleonOnlyHasGender = Gender_Male;
	}

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__145__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	ChameleonSkins(0)="ChameleonSkins.MB__036__Avg_M_SS_Pants"
	ChameleonSkins(1)="ChameleonSkins.MM__037__Avg_M_SS_Pants"
	ChameleonSkins(2)="ChameleonSkins.MW__038__Avg_M_SS_Pants"
	ChameleonSkins(3)="end"	// end-of-list marker (in case super defines more skins)

	HealthMax=160
	WillDodge=0.4
	WillKneel=0.1
	WillUseCover=0.7
	Champ=0.45
	Cajones=0.8
	DonutLove=0.3
	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
	BaseEquipment[2]=(weaponclass=class'Inventory.ShotgunWeapon')
	TakesShotgunHeadShot=	0.2
	TakesRifleHeadShot=		1.0
	TakesShovelHeadShot=	1.0
	TakesOnFireDamage=		0.8
	TakesAnthraxDamage=		1.0
	TakesShockerDamage=		0.5
	TakesChemDamage=		0.9
	}
