///////////////////////////////////////////////////////////////////////////////
// In gun ammo
///////////////////////////////////////////////////////////////////////////////
class RifleAmmoInv extends P2AmmoInv;

///////////////////////////////////////////////////////////////////////////////
// Add in the instigator
///////////////////////////////////////////////////////////////////////////////
function SpawnRifleProjectile(vector Start, vector Dir)
{
	local RifleProjectile rp;

	AmmoAmount -= 1;
	rp = RifleProjectile(spawn(ProjectileClass,Instigator,, Start));
	rp.SetVelocity(Dir);
	//log(self$" spawned rifle proj "$rp$" at "$rp.Location$" player loc "$Instigator.Location$" speed "$rp.Velocity$" rot "$Instigator.Rotation);
}

defaultproperties
	{
	ProjectileClass=class'RifleProjectile'
	PickupClass=class'RifleAmmoPickup'
	bInstantHit=false
	WarnTargetPct=+0.2
	bLeadTarget=true
	RefireRate=0.990000
	MaxAmmo=40
	MaxAmmoMP=8
	DamageAmount=25
	MomentumHitMag=10000
	DamageTypeInflicted=class'RifleDamage'
	Texture=Texture'HUDPack.Icons.Icon_Weapon_Rifle'
	}