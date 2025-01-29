///////////////////////////////////////////////////////////////////////////////
// Police
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for all police characters.
//
//	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
//	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
//	BaseEquipment[2]=(weaponclass=class'Inventory.PistolWeapon')
///////////////////////////////////////////////////////////////////////////////
class Police extends AuthorityFigure
	notplaceable
	Abstract;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function PostBeginPlay()
	{
	Super.PostBeginPlay();

	Cowardice=0.0;
	}

///////////////////////////////////////////////////////////////////////////////
// Set dialog class
///////////////////////////////////////////////////////////////////////////////
function SetDialogClass()
	{
	if (bIsFemale)
		DialogClass=class'BasePeople.DialogFemaleCop';
	else
		DialogClass=class'BasePeople.DialogMaleCop';
	}


defaultproperties
	{
	bHasRadio=true
	bFriendWithAuthority=true
	ViolenceRankTolerance=0
	HealthMax=140
	Psychic=0.2
	Rat=1.0
	Compassion=1.0
	WarnPeople=1.0
	Conscience=1.0
	Reactivity=0.4
	Champ=0.5
	Cajones=0.6
	PainThreshold=1.0
	TalkWhileFighting=0.0
	TalkBeforeFighting=0.0
	Glaucoma=0.8
	Rebel=1.0
	Temper=0.12
	WillDodge=0.3
	WillKneel=0.1
	WillUseCover=0.6
	DonutLove=0.75
	Fitness=0.55
	AttackRange=(Min=256,Max=4096)
    ControllerClass=class'PoliceController'
	Gang="Police"
	BaseEquipment[0]=(weaponclass=class'Inventory.HandCuffsWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.BatonWeapon')
	BaseEquipment[2]=(weaponclass=class'Inventory.PistolWeapon')
	CloseWeaponIndex=2
	FarWeaponIndex=3
	TakesShotgunHeadShot=	0.2
	TakesRifleHeadShot=		1.0
	TakesShovelHeadShot=	1.0
	TakesOnFireDamage=		1.0
	TakesAnthraxDamage=		1.0
	TakesShockerDamage=		0.7
	FriendDamageThreshold=0.0
	// give all cops badges
	Boltons[0]=(bone="cop_badge",staticmesh=staticmesh'boltons.cop_badge',bCanDrop=false)
	}
