//=============================================================================
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//=============================================================================
class Krotchy extends Bystander
	placeable;

// All we can do is scratch our mega-balls
simulated function name GetAnimIdle()
	{
	return 's_idle_crotch';
	}

function SetupHead()
	{
	Super.SetupHead();
	
	// Krotchy doesn't really want a head, so scale the head way down so it isn't seen
	if (myHead != None)
		myHead.SetDrawScale(0.1);
	}

defaultproperties
	{
	Mesh=Mesh'Krotchy_Characters.Krotchy'
	Skins[0]=Texture'ChameleonSkins.Special.Krotchy'
	// Head doesn't really matter -- see above
	HeadSkin=Texture'ChamelHeadSkins.MBA__013__AvgBrotha'
	HeadMesh=Mesh'Heads.AvgBrotha'
	DialogClass=class'BasePeople.DialogKrotchy'

	bRandomizeHeadScale=false
	bPersistent=true
	bHasRef=false
	bKeepForMovie=true
	bCanTeleportWithPlayer=false
	AnimGroupUsed=-1

	ControllerClass=class'KrotchyController'
	BaseEquipment[0]=(weaponclass=class'Inventory.ShotgunWeapon')
	BaseEquipment[1]=(weaponclass=class'Inventory.LauncherWeapon')
	BaseEquipment[2]=(weaponclass=class'Inventory.KrotchyInv')
	bAdvancedFiring=true
	WeapChangeDist=500
	bFriendWithAuthority=true
	Psychic=1.0
	Champ=0.9
	Cajones=1.0
	Temper=1.0
	Glaucoma=0.4
	Twitch=1.0
	TwitchFar=3.0
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
	WillDodge=0.1
	WillKneel=0.05
	WillUseCover=0.1
	Talkative=0.2
	Stomach=1.0
	VoicePitch=1.0
	TalkWhileFighting=0.4
	TalkBeforeFighting=1.0
	HealthMax=500.0
	TakesShotgunHeadShot=	0.0
	TakesRifleHeadShot=		0.0
	TakesShovelHeadShot=	0.0
	TakesPistolHeadShot=	0.0
	TakesMachinegunDamage=	0.0
	TakesOnFireDamage=		0.5
	TakesAnthraxDamage=		0.0
	TakesShockerDamage=		0.0
	TakesChemDamage=		0.0
	bHeadCanComeOff=false
	bStartupRandomization=false
	}
