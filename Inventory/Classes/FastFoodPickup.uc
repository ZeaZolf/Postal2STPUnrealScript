///////////////////////////////////////////////////////////////////////////////
// FastFoodPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// A tastey, fatty, bag of fast food
//
///////////////////////////////////////////////////////////////////////////////

class FastFoodPickup extends OwnedPickup;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'FastFoodInv'
	PickupMessage="You picked up a bag of Fast Food."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'stuff.stuff1.food'

	bEdible=true
	DesireMarkerClass=class'OtherFoodMarker'
	BounceSound=Sound'MiscSounds.PickupSounds.BookDropping'
	bNoBotPickup=true
	MaxDesireability = -1.0
	}
