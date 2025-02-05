//=============================================================================
// MachineGunWeapon
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Machine gun weapon (first and third person).
//
// For AI characters, this weapon scales the number of times it's shot continuously
// with the difficulty level. Higher difficulty--more they shoot in one burst.
//
//	History:
//		01/29/02 MJR	Started history, probably won't be updated again until
//							the pace of change slows down.
//
//=============================================================================

class MachineGunWeapon extends CatableWeapon;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts
///////////////////////////////////////////////////////////////////////////////
var travel byte ShootScissors;		// Cheat that makes you shoot bouncing scissors instead
var float SPAccuracy;				// How accurate we are in single player games.

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function PostBeginPlay()
{
	local float diffoffset;

	Super.PostBeginPlay();

	// If it's a single player game, make our accuracy much worse
	if(Level.Game != None
		&& FPSGameInfo(Level.Game).bIsSinglePlayer)
	{
		TraceAccuracy = SPAccuracy;

		// Based on the difficulty, bump up the number of times AI will continuously
		// shoot this weapon
		diffoffset = P2GameInfo(Level.Game).GetDifficultyOffset();
		if(diffoffset > 0)
		{
			AI_BurstCountExtra+=diffoffset;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// This will randomly change the color and the size of the dynamic
// light associate with the flash. Change in each weapon's file,
// but call each time you start up the flash again.
// This function is also used by the third-person muzzle flash, so the 
// colors will look the same
///////////////////////////////////////////////////////////////////////////////
simulated function PickLightValues()
{
	LightBrightness=150;
	LightSaturation=180;
	LightHue=12+FRand()*15;
	LightRadius=16+FRand()*16;
}

///////////////////////////////////////////////////////////////////////////////
// Tell ammo to make this scissors type
///////////////////////////////////////////////////////////////////////////////
function SpawnScissors(bool bMakeSpinner)
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
	local actor Other;
	local ScissorsProjectile sic;
	local P2Player p2p;
	
	GetAxes(Instigator.GetViewRotation(),X,Y,Z);
	StartTrace = GetFireStart(X,Y,Z); 
	AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError);	
	sic = spawn(class'ScissorsAltProjectile',Instigator,,StartTrace, AdjustedAim);
}

///////////////////////////////////////////////////////////////////////////////
// See what we hit
///////////////////////////////////////////////////////////////////////////////
function TraceFire( float Accuracy, float YOffset, float ZOffset )
{
	local int i;
	
	// Reduce the ammo only by 1 here, for the shotgun, but shoot
	// ShotCountMaxForNotify number of pellets each time.
	P2AmmoInv(AmmoType).UseAmmoForShot();

	// Reduce the cat ammo if we're using one
	if(CatOnGun == 1)
		CatAmmoLeft--;

	if(ShootScissors==1)
		SpawnScissors(true);
	else
		Super.TraceFire(Accuracy, YOffset, ZOffset);
}

///////////////////////////////////////////////////////////////////////////////
// DrawMuzzleFlash()
//Default implementation assumes that flash texture can be drawn inverted in X and/or Y direction to increase apparent
//number of flash variations
// We might need to draw a dark blood splat
///////////////////////////////////////////////////////////////////////////////
simulated function DrawMuzzleFlash(Canvas Canvas)
{
	local float Scale, ULength, VLength, UStart, VStart;

	// Form dynamic muzzle flash size
	MuzzleScale = FRand()*(default.MuzzleScale);
	// Form offset based on that
//	FlashOffsetX = -(MuzzleScale/500) + default.FlashOffsetX;
//	FlashOffsetY = -(MuzzleScale/500) + default.FlashOffsetY;

	MuzzleScale += 1.0;

	if(CatOnGun == 0
		|| !class'P2Player'.static.BloodMode())
		Super.DrawMuzzleFlash(Canvas);
	else	// if a cat, then draw it alpha blended with a gross blood splat
	{
		Scale = MuzzleScale * Canvas.ClipX/640.0;
		Canvas.Style = ERenderStyle.STY_Alpha;
		ULength = MFTexture.USize;
		if ( FRand() <= 0.5 )
		{
			UStart = ULength;
			ULength = -1 * ULength;
		}
		VLength = MFTexture.VSize;
		if ( FRand() <= 0.5 )
		{
			VStart = VLength;
			VLength = -1 * VLength;
		}

		Canvas.DrawTile(MFTexture, Scale * MFTexture.USize, Scale * MFTexture.VSize, 
					UStart, VStart, ULength, VLength);
		Canvas.Style = ERenderStyle.STY_Normal;
	}
}
state ClientFiring
{
}
state NormalFire
{
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	ItemName="Machine gun"
	AmmoName=class'MachineGunBulletAmmoInv'
	PickupClass=class'MachineGunPickup'
	AttachmentClass=class'MachinegunAttachment'

//	Mesh=Mesh'FP_Weapons.FP_Dude_Machinegun'
	Mesh=Mesh'MP_Weapons.MP_LS_Machinegun'

//	Skins[0]=Texture'WeaponSkins.Dude_Hands'
	Skins[0]=Texture'MP_FPArms.LS_arms.LS_hands_dude'
	Skins[1]=Texture'WeaponSkins.m-16_timb'
	Skins[2]=Texture'WeaponSkins.brass-01'
	Skins[3]=Texture'AnimalSkins.Cat_Orange'
	FirstPersonMeshSuffix="MachineGun"

//	CatMesh=Mesh'FP_Weapons.FP_Dude_MachinegunCat'
	CatMesh=Mesh'MP_Weapons.MP_LS_MachinegunCat'
	CatFireSound=Sound'WeaponSounds.machinegun_catfire'

	PlayerViewOffset=(X=1.0000,Y=0.300000,Z=-1.3000)

    bDrawMuzzleFlash=True
	MuzzleScale=0.2
	FlashOffsetY=-0.03
	FlashOffsetX=0.03
	FlashLength=0.1
	MuzzleFlashSize=128
    MFTexture=Texture'Timb.muzzleflash.machine_gun_corona'
	MFBloodTexture=Texture'nathans.muzzleflashes.bloodmuzzleflash'

    //MuzzleFlashStyle=STY_Translucent
	MuzzleFlashStyle=STY_Normal
    //MuzzleFlashMesh=Mesh'Weapons.Shotgun3'
    MuzzleFlashScale=2.40000
    //MuzzleFlashTexture=Texture'MuzzyPulse'

	holdstyle=WEAPONHOLDSTYLE_Both
	switchstyle=WEAPONHOLDSTYLE_Both
	firingstyle=WEAPONHOLDSTYLE_Both

	ShakeOffsetMag=(X=3.0,Y=2.5,Z=2.5)
	ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
	ShakeOffsetTime=2.0
	ShakeRotMag=(X=120.0,Y=30.0,Z=30.0)
	ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
	ShakeRotTime=2.0

	FireSound=Sound'WeaponSounds.machinegun_fire'
	SoundRadius=255
	CombatRating=5.0
	AIRating=0.4
	AutoSwitchPriority=4
	InventoryGroup=4
	GroupOffset=1
	BobDamping=0.975000
	ReloadCount=0
	SPAccuracy=0.7
	TraceAccuracy=0.11
	ShotCountMaxForNotify=20
	AI_BurstCountExtra=10
	AI_BurstCountMin=6
	AI_BurstTime=0.15
	ViolenceRank=5

	WeaponSpeedHolster = 1.5
	WeaponSpeedLoad    = 1.5
	WeaponSpeedReload  = 1.5
	WeaponSpeedShoot1  = 25.0
	WeaponSpeedShoot1Rand=0.0
	WeaponSpeedShoot2  = 1.0

	StartShotsWithCat=9
	AimError=600
	RecognitionDist=1300

	MaxRange=1200
	MinRange=300
	}

