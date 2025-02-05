///////////////////////////////////////////////////////////////////////////////
// LauncherAmmoInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Launcher ammo inventory item (as opposed to pickup).
//
///////////////////////////////////////////////////////////////////////////////

class LauncherAmmoInv extends P2AmmoInv;



///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	ProjectileClass=Class'LauncherProjectile'
	PickupClass=class'LauncherAmmoPickup'
	bInstantHit=false
	WarnTargetPct=+0.2
	bLeadTarget=true
	RefireRate=0.990000
	MaxAmmo=300
	MaxAmmoMP=150
	Texture=Texture'HUDPack.Icon_Weapon_Launcher'
	}
