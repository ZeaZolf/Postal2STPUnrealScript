///////////////////////////////////////////////////////////////////////////////
// Pistol attachment for 3rd person
//
// Weapon attachment gets it's ThirdPersonEffects called on all remote
// clients all the time when things are fired. Instead of having PlayOwnedSound
// *also* getting replicated to all remote clients to play the firing sound
// for fast-firing things like guns, I put it into here. It's messier, but
// it saves bandwidth.
///////////////////////////////////////////////////////////////////////////////
class PistolAttachment extends P2WeaponAttachment;

defaultproperties
{	
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'TP_Weapons.pistol3'
	RelativeRotation=(Pitch=0,Yaw=0,Roll=32768)
	RelativeLocation=(X=0.000000,Y=1.0000,Z=-0.3000)

	MuzzleFlashClass=class'PistolMuzzleFlash'
	MuzzleRotationOffset=(Pitch=0,Yaw=0,Roll=0)
	MuzzleOffset=(X=28.000000,Y=0.000000,Z=5.000000)
	WeapClass=class'PistolWeapon'

	FireSound=Sound'WeaponSounds.pistol_fire'
}
