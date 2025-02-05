///////////////////////////////////////////////////////////////////////////////
// DudeClothesInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Clothing inventory item. You're not wearing this, you have it
// folded up right now, so it's not active.
//
// This is the dudes original clothes for when he's wearing some other
// outfit.
//
///////////////////////////////////////////////////////////////////////////////

class DudeClothesInv extends ClothesInv;

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'DudeClothesPickup'
	Icon=Texture'hudpack.icons.Icon_Inv_DudeUniform'
	InventoryGroup =109
	Price=100
	bPaidFor=true
	LegalOwnerTag="Qing"
	UseForErrands=1
	Hint1="Press Enter to wear"
	Hint2="Dude Clothes."
	Hint3=""
	}
