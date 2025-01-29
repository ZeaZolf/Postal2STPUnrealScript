///////////////////////////////////////////////////////////////////////////////
// GimpClothesPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Stack of clothes pickup for dude to wear 
// of the gimp clothing.
//
///////////////////////////////////////////////////////////////////////////////

class GimpClothesPickup extends ClothesPickup
placeable;

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'GimpClothesInv'
	PickupMessage="You found a stack of Gimp clothes"
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Stuff.stuff1.GimpUniform'
	bPaidFor=true
	Price=20
	LegalOwnerTag=None
	}
