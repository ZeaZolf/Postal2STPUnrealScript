///////////////////////////////////////////////////////////////////////////////
// GaryBookPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Gary Coleman autobiography book pickup.
//
///////////////////////////////////////////////////////////////////////////////

class GaryBookPickup extends BookPickup;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'GaryBookInv'
	PickupMessage="You picked up Gary Coleman's autobiography."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Stuff.stuff1.garybook'
	bPaidFor=true
	Price=0
	LegalOwnerTag=None
	bUseForErrands=true
	bAllowMovement=false
	}
