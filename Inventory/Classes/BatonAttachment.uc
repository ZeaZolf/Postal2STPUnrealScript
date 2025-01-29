///////////////////////////////////////////////////////////////////////////////
// Baton attachment for 3rd person
///////////////////////////////////////////////////////////////////////////////
class BatonAttachment extends P2WeaponAttachment;

defaultproperties
	{
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'TP_Weapons.Baton3'
	RelativeRotation=(Pitch=0,Yaw=0,Roll=32768)
	FiringMode="BATON1"
	WeapClass=class'BatonWeapon'
	}
