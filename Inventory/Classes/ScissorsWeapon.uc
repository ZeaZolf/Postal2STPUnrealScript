///////////////////////////////////////////////////////////////////////////////
// ScissorsWeapon
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Scissors that you throw.
//
///////////////////////////////////////////////////////////////////////////////

class ScissorsWeapon extends P2Weapon;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts
///////////////////////////////////////////////////////////////////////////////

var float WeaponSpeedShoot1MP;	// Allow faster shooting in multiplayer.
var float WeaponSpeedShoot2MP;


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// If it's a MP game, make them fire faster
	if(Level.Game == None
		|| !Level.Game.bIsSinglePlayer)
	{
		WeaponSpeedShoot1 = WeaponSpeedShoot1MP;
		WeaponSpeedShoot2 = WeaponSpeedShoot2MP;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Throws like a dart.
//
// Only spawn them here in MP because the anim notify can't keep up
// when it plays so fast.
///////////////////////////////////////////////////////////////////////////////
function ProjectileFire()
{
	if(Level.Game == None
		|| !Level.Game.bIsSinglePlayer)
//		|| (Instigator != None
//			&& PersonController(Instigator.Controller) != None))
	{
		SpawnScissors(false);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Play firing animation/sound/etc
// Set here that we want to reload after each throw
///////////////////////////////////////////////////////////////////////////////
simulated function PlayFiring()
{
	Super.PlayFiring();
	bForceReload=true;
}
simulated function PlayAltFiring()
{
	Super.PlayAltFiring();
	bForceReload=true;
}

///////////////////////////////////////////////////////////////////////////////
// Throws ricocheting scissors.
//
// Only spawn them here in MP because the anim notify can't keep up
// when it plays so fast.
///////////////////////////////////////////////////////////////////////////////
function ProjectileAltFire()
{
	if(Level.Game == None
		|| !Level.Game.bIsSinglePlayer)
		SpawnScissors(true);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function PlayReloading()
{
	PlayAnim('Load', WeaponSpeedReload, 0.05);
	
	P2MocapPawn(Instigator).PlayWeaponSwitch(self);
}

///////////////////////////////////////////////////////////////////////////////
// Called on client's side to make the gun fire
// Check here to throw out danger markers to let people know the gun has gone
// off.
///////////////////////////////////////////////////////////////////////////////
simulated function LocalFire()
{
	local P2Player P;
	
	bPointing = true;

	// Same as the one in P2Weapon, but we don't do the camera shake here
	// We make it shake when he throws

	if ( Affector != None )
		Affector.FireEffect();
	PlayFiring();
}		

///////////////////////////////////////////////////////////////////////////////
// Same as above.. we don't want the shake here
///////////////////////////////////////////////////////////////////////////////
simulated function LocalAltFire()
{
	local PlayerController P;

	bPointing = true;

	// Same as the one in P2Weapon, but we don't do the camera shake here
	// We make it shake when he throws

	if ( Affector != None )
		Affector.FireEffect();
	PlayAltFiring();
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
	
	if(AmmoType != None
		&& AmmoType.HasAmmo())
	{
		GetAxes(Instigator.GetViewRotation(),X,Y,Z);
		StartTrace = GetFireStart(X,Y,Z); 
		AdjustedAim = Instigator.AdjustAim(AmmoType, StartTrace, 2*AimError);	
		if(bMakeSpinner)
		{
			TurnOffHint();
			sic = spawn(class'ScissorsAltProjectile',Instigator,,StartTrace, AdjustedAim);
		}
		else
			sic = spawn(class'ScissorsProjectile',Instigator,,StartTrace, AdjustedAim);
		// Make sure it got made
		if(sic != None)
			P2AmmoInv(AmmoType).UseAmmoForShot();

		// Shake the view when you throw it
		if ( Instigator != None)
		{
			p2p = P2Player(Instigator.Controller);
			if (p2p!=None)
			{
				p2p.ClientShakeView(ShakeRotMag, ShakeRotRate, ShakeRotTime, 
							ShakeOffsetMag, ShakeOffsetRate, ShakeOffsetTime);
			}
		}
	}
	// Turn off the thing in his hand as it leaves
	if(ThirdPersonActor != None)
		ThirdPersonActor.bHidden=true;
}

///////////////////////////////////////////////////////////////////////////////
// Throw the scissors like a dart
//
// Because the animation is played much more slowly in SP allow the
// notify to throw the scissors. In MP spawn them at the start
// of the animation
///////////////////////////////////////////////////////////////////////////////
simulated function Notify_ThrowScissors()
	{
	if(Level.Game != None
		&& Level.Game.bIsSinglePlayer)
		{
			SpawnScissors(false);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Throw the scissors like a bouncing, spinning blade
//
// Because the animation is played much more slowly in SP allow the
// notify to throw the scissors. In MP spawn them at the start
// of the animation
///////////////////////////////////////////////////////////////////////////////
simulated function Notify_AltThrowScissors()
	{
	if(Level.Game != None
		&& Level.Game.bIsSinglePlayer)
		SpawnScissors(true);
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Idle
//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state Idle
{
	///////////////////////////////////////////////////////////////////////////////
	// Make sure you're attachment is visible on idle start
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		Super.BeginState();
		if(ThirdPersonActor != None)
			ThirdPersonActor.bHidden=false;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bUsesAltFire=true
	ItemName="Scissors"
	AmmoName=class'ScissorsAmmoInv'
	PickupClass=class'ScissorsPickup'
	AttachmentClass=class'ScissorsAttachment'

//	Mesh=Mesh'FP_Weapons.FP_Dude_Scissors'
	Mesh=Mesh'MP_Weapons.MP_LS_Scissors'

	Skins[0]=Texture'MP_FPArms.LS_arms.LS_hands_dude'
//	Skins[0]=Texture'WeaponSkins.Dude_Hands'
	FirstPersonMeshSuffix="Scissors"

	FireOffset=(X=15.0000,Y=5.000000,Z=-5.00000)

    bDrawMuzzleFlash=False

	holdstyle=WEAPONHOLDSTYLE_Toss
	switchstyle=WEAPONHOLDSTYLE_Toss
	firingstyle=WEAPONHOLDSTYLE_Toss

	//shakemag=0.000000
	//shaketime=0.000000
	//shakevert=(X=0.0,Y=0.0,Z=0.00000)
	ShakeOffsetMag=(X=0.0,Y=0.0,Z=0.0)
	ShakeOffsetRate=(X=0.0,Y=0.0,Z=0.0)
	ShakeOffsetTime=0
	ShakeRotMag=(X=200.0,Y=30.0,Z=30.0)
	ShakeRotRate=(X=3000.0,Y=5000.0,Z=5000.0)
	ShakeRotTime=2.0

	FireSound=Sound'WeaponSounds.scissors_fire1'
	AltFireSound=Sound'WeaponSounds.scissors_fire2'
	CombatRating=1.8
	AIRating=0.5
	AutoSwitchPriority=6
	InventoryGroup=6
	GroupOffset=3
	BobDamping=0.975000
	ReloadCount=0
	TraceAccuracy=0.1
	ShotCountMaxForNotify=0
	ViolenceRank=1
	bBumpStartsFight=false
	bThrownByFiring=true

	WeaponSpeedHolster = 1.5
	WeaponSpeedLoad    = 1.25
	WeaponSpeedReload  = 5.0
	WeaponSpeedShoot1  = 1.0
	WeaponSpeedShoot1MP= 6.0
	WeaponSpeedShoot1Rand=0.05
	WeaponSpeedShoot2  = 1.0
	WeaponSpeedShoot2MP= 5.0
	WeaponSpeedShoot2Rand=0.05

	AimError=500

	MaxRange=1024
	RecognitionDist=300

	NoAmmoChangeState = "EmptyDownWeapon"

	HudHint1="Alt Fire (Right Mouse Button) throws"
	HudHint2="ricocheting scissors."
	bAllowHints=true
	bShowHints=true
	}
