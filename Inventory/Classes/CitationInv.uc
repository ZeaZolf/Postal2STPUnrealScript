///////////////////////////////////////////////////////////////////////////////
// CitationInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Citation inventory item for a traffic violation.
//
///////////////////////////////////////////////////////////////////////////////

class CitationInv extends BookInv;

///////////////////////////////////////////////////////////////////////////////
// Active state: this inventory item is armed and ready to rock!
///////////////////////////////////////////////////////////////////////////////
state Activated
{
Begin:
	CheckToGiveToInterestAndPay();
	GotoState('');
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'CitationPickup'
	Icon=Texture'HUDPack.Icon_Inv_Citation'
	InventoryGroup =115
	Price=300
	bPaidFor=false
	LegalOwnerTag="Dick"
	UseForErrands=1
	PaidHint1="Take to the police department"
	PaidHint2="You owe: $"
	Hint1="Press the 'Use Item' key (Enter) to pay."
	Hint2="Take to the police department."
	bUseCashierHints=true
	}
