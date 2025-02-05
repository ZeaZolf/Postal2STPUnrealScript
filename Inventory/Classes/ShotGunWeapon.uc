//=============================================================================
// ShotGunWeapon
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Shotgun weapon (first and third person).
// This can have a cat put on the end on the of the weapon.
//
// For AI characters, this weapon scales the number of times it's shot continuously
// with the difficulty level. Higher difficulty--more they shoot in one burst.
//
//	History:
//		01/29/02 MJR	Started history, probably won't be updated again until
//							the pace of change slows down.
//
//=============================================================================

class ShotGunWeapon extends CatableWeapon;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts
///////////////////////////////////////////////////////////////////////////////

var float SPAccuracy;				// How accurate we are in single player games.

//const BASE_FLASH_OFFSET_X = 0.06;
//const BASE_FLASH_OFFSET_Y = 0.015;
const BASE_FLASH_OFFSET_X = 0.055;
const BASE_FLASH_OFFSET_Y = 0.01;
const RAND_OFFSET = 0.01;

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
			AI_BurstCountExtra+=(diffoffset/2);
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
	LightSaturation=150;
	LightHue=22+FRand()*10;
	LightRadius=24+FRand()*6;
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

//	FlashOffsetX = BASE_FLASH_OFFSET_X + FRand()*RAND_OFFSET;
//	FlashOffsetY = BASE_FLASH_OFFSET_Y + FRand()*RAND_OFFSET;

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

	for(i=0; i<ShotCountMaxForNotify; i++)
	{
		Super.TraceFire(Accuracy, YOffset, ZOffset);
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
	ItemName="Shotgun"
	AmmoName=class'ShotGunBulletAmmoInv'
	PickupClass=class'ShotGunPickup'
	AttachmentClass=class'ShotgunAttachment'

//	Mesh=Mesh'FP_Weapons.FP_Dude_Shotgun'
	Mesh=Mesh'MP_Weapons.MP_LS_Shotgun'

	Skins[0]=Texture'MP_FPArms.LS_arms.LS_hands_dude'
//	Skins[0]=Texture'WeaponSkins.Dude_Hands'
	Skins[1]=Texture'WeaponSkins.shotgun_timb'
	Skins[2]=Texture'AnimalSkins.Cat_Orange'
	Skins[3]=Texture'AnimalSkins.Cat_Orange'
	FirstPersonMeshSuffix="Shotgun"

//	CatMesh=Mesh'FP_Weapons.FP_Dude_ShotgunCat'
	CatMesh=Mesh'MP_Weapons.MP_LS_ShotgunCat'
	CatFireSound=Sound'WeaponSounds.shotgun_catfire'
	CatSkinIndex=2

    bDrawMuzzleFlash=True
	MuzzleScale=1.0
	FlashOffsetY=-0.05
	FlashOffsetX=0.06
	FlashLength=0.05
	MuzzleFlashSize=128
    MFTexture=Texture'Timb.muzzleflash.shotgun_corona'
	MFBloodTexture=Texture'nathans.muzzleflashes.bloodmuzzleflash'

    //MuzzleFlashStyle=STY_Translucent
	MuzzleFlashStyle=STY_Normal
    //MuzzleFlashMesh=Mesh'Weapons.Shotgun3'
    MuzzleFlashScale=2.40000
    //MuzzleFlashTexture=Texture'MuzzyPulse'

	holdstyle=WEAPONHOLDSTYLE_Double
	switchstyle=WEAPONHOLDSTYLE_Double
	firingstyle=WEAPONHOLDSTYLE_Double

	//ShakeMag=1000.000000
	//ShakeRollRate=20000
	//ShakeOffsetTime=2.0
	//ShakeTime=0.500000
	//ShakeVert=(Z=10.0)
	ShakeOffsetMag=(X=20.0,Y=4.0,Z=4.0)
	ShakeOffsetRate=(X=1000.0,Y=1000.0,Z=1000.0)
	ShakeOffsetTime=2.5
	ShakeRotMag=(X=400.0,Y=50.0,Z=50.0)
	ShakeRotRate=(X=10000.0,Y=10000.0,Z=10000.0)
	ShakeRotTime=2.5

	FireSound=Sound'WeaponSounds.shotgun_fire'
	SoundRadius=255
	CombatRating=4.0
	AIRating=0.3
	AutoSwitchPriority=3
	InventoryGroup=3
	GroupOffset=1
	BobDamping=0.975000
	ReloadCount=0
	TraceAccuracy=0.7
	SPAccuracy=1.4
	ShotCountMaxForNotify=4
	AI_BurstCountExtra=0
	AI_BurstCountMin=3
	ViolenceRank=3

	WeaponSpeedIdle	   = 0.8
	WeaponSpeedHolster = 1.5
	WeaponSpeedLoad    = 1.5
	WeaponSpeedReload  = 1.0
	WeaponSpeedShoot1  = 1.0
	WeaponSpeedShoot1Rand=0.3
	WeaponSpeedShoot2  = 1.0

	StartShotsWithCat=9
	AimError=400
	RecognitionDist=1100

	MaxRange=512
	MinRange=200
	}
