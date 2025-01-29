///////////////////////////////////////////////////////////////////////////////
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
//  Fanatics. One of the groups to end up hating the dude.
//
///////////////////////////////////////////////////////////////////////////////
class Fanatics extends Bystander
	placeable;

function PreBeginPlay()
	{
	Super.PreBeginPlay();

	// Do this here because we can't use enums in default properties
	ChameleonOnlyHasGender = Gender_Male;
	}

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__147__Avg_Dude'
	Mesh=Mesh'Characters.Avg_Dude'

	ChameleonSkins(0)="ChameleonSkins.MF__009__Avg_Dude"
	ChameleonSkins(1)="ChameleonSkins.MF__010__Avg_Dude"
	ChameleonSkins(2)="ChameleonSkins.MF__011__Avg_Dude"
	ChameleonSkins(3)="end"	// end-of-list marker (in case super defines more skins)

	// These were picked from the general pool because they look good as cops, swat, etc.
	ChamelHeadSkins(0)="ChamelHeadSkins.MFA__018__AvgFanatic"
	ChamelHeadSkins(1)="ChamelHeadSkins.MFA__019__AvgFanatic"
	ChamelHeadSkins(2)="ChamelHeadSkins.MFA__020__AvgFanatic"
	ChamelHeadSkins(3)="end"	// end-of-list marker (in case super defines more skins)

	DialogClass=class'BasePeople.DialogHabib'

	ViolenceRankTolerance=1
	bIsTrained=true
	BaseEquipment[0]=(weaponclass=class'Inventory.MachinegunWeapon')
	Gang="Fanatics"
	HealthMax=80
	Glaucoma=0.7
	TalkWhileFighting=0.0
	TalkBeforeFighting=0.0
	PainThreshold=1.0
	Rebel=1.0
	Cajones=1.0
	Stomach=0.9
	TakesShotgunHeadShot=	0.4
	TakesRifleHeadShot=		0.5
	TakesShovelHeadShot=	0.5
	TakesOnFireDamage=		0.1
	TakesAnthraxDamage=		0.7
	TakesShockerDamage=		0.2
	}
