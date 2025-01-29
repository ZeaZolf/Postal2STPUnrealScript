//=============================================================================
// RWSStaff.uc
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for all RWS staff members.
//
//=============================================================================
class RWSStaff extends Bystander
	notplaceable
	Abstract;


defaultproperties
	{
	ControllerClass=class'RWSController'
	// rws staff are trained and well armed
	bIsTrained=true
	BaseEquipment[0]=(weaponclass=class'Inventory.PistolWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.MachinegunWeapon')
	bPlayerIsFriend=true
	Gang="RWSStaff"
	bRandomizeHeadScale=false
	bStartupRandomization=false
	HealthMax=200
	PainThreshold=1.0
	Rebel=1.0
	DamageMult=2.5
	Cajones=1.0
	Stomach=1.0
	Psychic=0.4
	Glaucoma=0.3
	ViolenceRankTolerance=0
	FriendDamageThreshold=170

	TakesShotgunHeadShot=	0.25
	TakesShovelHeadShot=	0.35
	TakesOnFireDamage=		0.4
	TakesAnthraxDamage=		0.5
	TakesShockerDamage=		0.3
	TakesChemDamage=		0.6
	}
