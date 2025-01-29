///////////////////////////////////////////////////////////////////////////////
// Shovel attachment for 3rd person
///////////////////////////////////////////////////////////////////////////////
class ShovelAttachment extends P2WeaponAttachment;

defaultproperties
	{
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'TP_Weapons.Shovel3'
	RelativeRotation=(Pitch=0,Yaw=0,Roll=0)
	FiringMode="SHOVEL1"
	WeapClass=class'ShovelWeapon'
	}
