///////////////////////////////////////////////////////////////////////////////
// CopClothesPickup
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Stack of clothes pickup for dude to wear 
// that's a cop uniform
//
///////////////////////////////////////////////////////////////////////////////

class CopClothesPickup extends ClothesPickup
placeable;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	InventoryType=class'CopClothesInv'
	PickupMessage="You picked up a Police Uniform."
	DrawType=DT_StaticMesh
	StaticMesh=StaticMesh'Stuff.stuff1.CopUniform'
	bPaidFor=true
	Price=20
	LegalOwnerTag=None
	bBreaksWindows=false
	}
