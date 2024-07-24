///////////////////////////////////////////////////////////////////////////////
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
//  Country rednecks. One of the groups to end up hating the dude.
//
///////////////////////////////////////////////////////////////////////////////
class Rednecks extends Bystander
	placeable;


function PreBeginPlay()
	{
	Super.PreBeginPlay();

	// Do this here because we can't use enums in default properties
	ChameleonOnlyHasGender = Gender_Male;
	}

defaultproperties
	{
	Skins[0]=Texture'ChameleonSkins.XX__154__Avg_M_SS_Pants'
	Mesh=Mesh'Characters.Avg_M_SS_Pants'

	ChameleonSkins(0)="ChameleonSkins.MW__055__Avg_M_SS_Pants"
	ChameleonSkins(1)="ChameleonSkins.MW__072__Big_M_LS_Pants"
	ChameleonSkins(2)="ChameleonSkins.MW__103__Fat_M_SS_Pants"
	ChameleonSkins(3)="end"	// end-of-list marker (in case super defines more skins)

	bIsTrained=false
	BaseEquipment[0]=(weaponclass=class'Inventory.ShotgunWeapon')
	Gang="Rednecks"
	HealthMax=100
	PainThreshold=0.95
	Glaucoma=0.8
	Rebel=1.0
	Cajones=0.8
	Stomach=0.9
	Greed=0.8
	ViolenceRankTolerance=1
	TalkWhileFighting=0.3
	TalkBeforeFighting=0.5
    ControllerClass=class'RedneckController'
	DialogClass=class'BasePeople.DialogRedneck'
	}
