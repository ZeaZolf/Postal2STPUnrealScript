///////////////////////////////////////////////////////////////////////////////
// ShotGunBulletAmmoInv
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Shotgun ammo inventory item (as opposed to pickup).
//
//	History:
//		01/29/02 MJR	Started history, probably won't be updated again until
//							the pace of change slows down.
//
///////////////////////////////////////////////////////////////////////////////

class ShotGunBulletAmmoInv extends P2AmmoInv;


var travel int CatAmmoLeft;		// How many shots we've taken with the cat, when this reaches
								// 0, the cat shoots off
var int ShotsWithCat;			// total shots we get with a cat, probably 9 for 9 lives
var float FleshRad;
var Sound FleshHit[4];

///////////////////////////////////////////////////////////////////////////////
// Process a trace hitting something
///////////////////////////////////////////////////////////////////////////////
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Rotator NewRot;

	if ( Other == None )
		return;

	if (Other.bStatic)//Other.bWorldGeometry ) 
	{
		spawn(class'ShotgunBulletHitPack',W.Owner, ,HitLocation, Rotator(HitNormal));
	}
	else 
	{
		Other.TakeDamage(DamageAmount, Pawn(Owner), HitLocation, MomentumHitMag*X, DamageTypeInflicted);

		if((Pawn(Other) != None && Other != Owner)
			|| PeoplePart(Other) != None
			|| CowheadProjectile(Other) != None)
		{
			if(Rand(2) == 0)
				Other.PlaySound(FleshHit[Rand(ArrayCount(FleshHit))],SLOT_Pain,,,FleshRad,GetRandPitch());
		}
		else // anything else--make a spark hit
		{
			spawn(class'BulletSparkPack',W.Owner, ,HitLocation, Rotator(HitNormal));
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
//	ProjectileClass=Class'ShotGunBulletProj'
	PickupClass=class'ShotgunAmmoPickup'
	bInstantHit=true
	WarnTargetPct=+0.2
	bLeadTarget=true
	RefireRate=0.990000
	MaxAmmo=100
	MaxAmmoMP=40
	DamageAmount=11
	DamageAmountMP=16
	MomentumHitMag=100000
	DamageTypeInflicted=class'ShotGunDamage'
	Texture=Texture'hudpack.icons.Icon_Weapon_Shotgun'

	FleshHit[0]=Sound'WeaponSounds.bullet_hitflesh1'
	FleshHit[1]=Sound'WeaponSounds.bullet_hitflesh2'
	FleshHit[2]=Sound'WeaponSounds.bullet_hitflesh3'
	FleshHit[3]=Sound'WeaponSounds.bullet_hitflesh4'
	FleshRad=200
	}
