///////////////////////////////////////////////////////////////////////////////
// HandCuffsWeapon
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// HandCuffs weapon--no violent hand cuffs
//
//	History:
//		02/12/02 NPF	Started history, probably won't be updated again until
//							the pace of change slows down.
//
///////////////////////////////////////////////////////////////////////////////

class HandCuffsWeapon extends P2Weapon;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Stub these two out so the handCuffs can't 'fire'
///////////////////////////////////////////////////////////////////////////////
function ServerFire()
{
	log("no serverfire "$self);
}
function LocalFire()
{
	log("no localfire "$self);
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bNoHudReticle=true
	ItemName="Handcuffs"
	AmmoName=class'HandCuffsAmmoInv'
	AttachmentClass=class'HandCuffsAttachment'

	Mesh=Mesh'FP_Weapons.FP_Dude_Nothing'
	Skins[0]=Texture'WeaponSkins.Dude_Hands'
	FirstPersonMeshSuffix="Nothing"

	SelectSound=None
	AIRating=0.01
	AutoSwitchPriority=0
	InventoryGroup=0
	GroupOffset=3
	BobDamping=0.975000
	ReloadCount=0
	ViolenceRank=0
	bBumpStartsFight=false
	bCanThrow=false

	MaxRange=150
	}
