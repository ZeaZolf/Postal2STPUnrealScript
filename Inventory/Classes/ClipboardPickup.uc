///////////////////////////////////////////////////////////////////////////////
// ClipboardPickup
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Collection can weapon pickup.
//
///////////////////////////////////////////////////////////////////////////////

class ClipboardPickup extends P2WeaponPickup;

var ()bool bMoneyGoesToCharity;		// Defaults true. This means the money goes to an errand and
									// not to your wallet.

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'ClipboardWeapon'
	PickupMessage="You picked up a Clipboard."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'stuff.stuff1.Clipboard'
	bMoneyGoesToCharity=true
	}
