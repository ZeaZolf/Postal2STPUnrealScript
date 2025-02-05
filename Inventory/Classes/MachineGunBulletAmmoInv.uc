///////////////////////////////////////////////////////////////////////////////
// In gun ammo
///////////////////////////////////////////////////////////////////////////////
class MachineGunBulletAmmoInv extends P2AmmoInv;

const FLESH_HIT_MAX	=	4;

var Sound FleshHit[FLESH_HIT_MAX];
var float FleshRad;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ProcessTraceHit(Weapon W, Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
	local Rotator NewRot;

	if ( Other == None )
		return;

	if(Other.bStatic)
	{
		spawn(class'MachinegunBulletHitPack',W.Owner, ,HitLocation, Rotator(HitNormal));
	}
	else 
	{
		Other.TakeDamage(DamageAmount, Pawn(Owner), HitLocation, MomentumHitMag*X, DamageTypeInflicted);

		if((Pawn(Other) != None && Other != Owner)
			|| PeoplePart(Other) != None
			|| CowheadProjectile(Other) != None)
		{
			Other.PlaySound(FleshHit[Rand(ArrayCount(FleshHit))],SLOT_Pain,,,FleshRad,GetRandPitch());
		}
		else // anything else--make a spark hit
		{
			spawn(class'BulletSparkPack',W.Owner, ,HitLocation, Rotator(HitNormal));
		}
	}
}

defaultproperties
	{
//	ProjectileClass=Class'MachineGunBulletProj'
	PickupClass=class'MachinegunAmmoPickup'
	bInstantHit=true
	WarnTargetPct=+0.2
	bLeadTarget=true
	RefireRate=0.990000
	MaxAmmo=400
	MaxAmmoMP=200
	DamageAmount=8
	DamageAmountMP=10
	MomentumHitMag=50000
	DamageTypeInflicted=class'MachineGunDamage'
	Texture=Texture'HUDpack.Icons.Icon_Weapon_Machinegun'

	FleshHit[0]=Sound'WeaponSounds.bullet_hitflesh1'
	FleshHit[1]=Sound'WeaponSounds.bullet_hitflesh2'
	FleshHit[2]=Sound'WeaponSounds.bullet_hitflesh3'
	FleshHit[3]=Sound'WeaponSounds.bullet_hitflesh4'

	FleshRad=200
	}