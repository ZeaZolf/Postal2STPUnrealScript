///////////////////////////////////////////////////////////////////////////////
// KrotchyPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Krotchy toy in a box pickup.
//
//
///////////////////////////////////////////////////////////////////////////////

class KrotchyPickup extends OwnedPickup;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	Price=0
	InventoryType=class'KrotchyInv'
	PickupMessage="You picked up a Krotchy doll."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Stuff.stuff1.Krotchytoy'
	bPaidFor=true
	LegalOwnerTag="Krotchy"
	bUseForErrands=true
	bAllowMovement=false
	CollisionHeight=20.0
	}
