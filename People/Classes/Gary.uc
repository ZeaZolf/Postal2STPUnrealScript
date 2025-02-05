//=============================================================================
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class Gary extends Bystander
	placeable;

defaultproperties
	{
	Mesh=Mesh'Gary_Characters.Mini_M_Jacket_Pants'
	Skins[0]=Texture'ChameleonSkins.Special.Gary'
	HeadSkin=Texture'ChamelHeadSkins.Special.Gary'
	HeadMesh=Mesh'Heads.Gary'

    Begin Object Class=KarmaParamsSkel Name=GarySkel
		KSkeleton="Avg_Mini_Skel"
		KFriction=0.5
	    KStartEnabled=False
        Name="GarySkel"
    End Object
    KParams=KarmaParamsSkel'GarySkel'

	CoreMeshAnim=MeshAnimation'Gary_Characters.animMini'
	DialogClass=class'BasePeople.DialogGary'

	PeeBody=class'UrineSmallBodyDrip'
	GasBody=class'GasSmallBodyDrip'

	bRandomizeHeadScale=false
	bPersistent=true
	bHasRef=false
	bKeepForMovie=true
	bCanTeleportWithPlayer=false
	AnimGroupUsed=-1

	ControllerClass=class'GaryController'
	BaseEquipment[0]=(weaponclass=class'Inventory.MachinegunWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.GrenadeWeapon')
	BaseEquipment[2]=(weaponclass=class'Inventory.GaryBookInv')
	WeapChangeDist=800
	DamageMult=2.0
	Psychic=1.0
	Champ=0.9
	Cajones=1.0
	Temper=1.0
	Glaucoma=0.5
	Twitch=1.0
	TwitchFar=3.5
	Rat=0.1
	Compassion=0.0
	WarnPeople=0.0
	Conscience=0.0
	Beg=0.0
	PainThreshold=1.0
	Reactivity=0.5
	Confidence=1.0
	Rebel=0.0
	Curiosity=0.5
	Patience=0.5
	WillDodge=0.5
	WillKneel=0.05
	WillUseCover=0.9
	Talkative=0.2
	Stomach=1.0
	VoicePitch=1.0
	TalkWhileFighting=0.5
	TalkBeforeFighting=1.0
	HealthMax=550.0
	bStartupRandomization=false
	TakesShotgunHeadShot=	0.05
	TakesRifleHeadShot=		0.15
	TakesShovelHeadShot=	0.15
	TakesOnFireDamage=		0.25
	TakesAnthraxDamage=		0.25
	TakesShockerDamage=		0.1
	TakesPistolHeadShot=    0.25
	TakesMachinegunDamage=  0.3
	TakesChemDamage=		0.1
	}
