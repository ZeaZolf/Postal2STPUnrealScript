///////////////////////////////////////////////////////////////////////////////
// Urethra attachment for 3rd person
// A censored bar shows up in thrd person, as a sprite
///////////////////////////////////////////////////////////////////////////////
class UrethraAttachment extends P2WeaponAttachment;

defaultproperties
{	
	Mesh=None
	DrawType=DT_Sprite
	Texture=Texture'P2Misc.Icons.Censored'
	DrawScale=0.2
	FiringMode="URETHRA1"
	WeapClass=class'UrethraWeapon'
}
