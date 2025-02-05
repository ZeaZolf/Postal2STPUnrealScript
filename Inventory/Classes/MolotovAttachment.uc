///////////////////////////////////////////////////////////////////////////////
// Molotov attachment for 3rd person
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// It's a molotov in a guy's hand, that you can see in 3rd person
//
///////////////////////////////////////////////////////////////////////////////
class MolotovAttachment extends P2WeaponAttachment;

defaultproperties
	{	
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'TP_Weapons.Molotov3'
	RelativeRotation=(Pitch=0,Yaw=0,Roll=32768)
	RelativeLocation=(X=0.000000,Y=1.0000,Z=-0.3000)
	WeapClass=class'MolotovWeapon'
	}
