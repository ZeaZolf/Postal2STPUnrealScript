///////////////////////////////////////////////////////////////////////////////
// ATFAgent
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Field officers. good shots
//
//	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
//	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
//	BaseEquipment[2]=(weaponclass=class'Inventory.PistolWeapon')
///////////////////////////////////////////////////////////////////////////////
class ATFAgent extends Police
	placeable;


defaultproperties
	{
	// Default to chameleon mode
	Skins[0]=Texture'ChameleonSkins.XX__140__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'
	ChameleonSkins(0)="ChameleonSkins.FW__111__Fat_F_SS_Pants"
	ChameleonSkins(1)="ChameleonSkins.FW__116__Fem_LS_Pants"
	ChameleonSkins(2)="ChameleonSkins.MW__023__Avg_M_SS_Pants"
	ChameleonSkins(3)="ChameleonSkins.MW__101__Fat_M_SS_Pants"
	ChameleonSkins(4)="end"	// end-of-list marker (in case super defines more skins)

	HealthMax=110
	WillDodge=0.5
	WillKneel=0.1
	WillUseCover=0.9
	Champ=0.55
	DonutLove=0.1
	Glaucoma=0.5
	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
	BaseEquipment[2]=(weaponclass=class'Inventory.PistolWeapon')
	TakesShotgunHeadShot=	0.2
	TakesRifleHeadShot=		1.0
	TakesShovelHeadShot=	1.0
	TakesOnFireDamage=		0.6
	TakesAnthraxDamage=		1.0
	TakesShockerDamage=		0.3
	TakesChemDamage=		0.5
	Boltons[0]=(bone="cop_badge",staticmesh=None,bCanDrop=false,bInActive=true)
	}
