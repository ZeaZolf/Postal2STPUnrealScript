///////////////////////////////////////////////////////////////////////////////
// LibraryBookInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Library Book inventory item.
//
///////////////////////////////////////////////////////////////////////////////
class LibraryBookInv extends BookInv;



///////////////////////////////////////////////////////////////////////////////
// Give hints about this item
///////////////////////////////////////////////////////////////////////////////
function GetHints(P2Pawn PawnOwner, out String str1, out String str2, out String str3,
				  out byte InfiniteHintTime)
{
	local P2Player checkp;

	if(!bPaidFor)
	{
		checkp = P2Player(PawnOwner.Controller);

		if(checkp.InterestPawn != None
			&& PersonController(checkp.InterestPawn.Controller) != None
			&& (PersonController(checkp.InterestPawn.Controller).InterestInventoryClass == class))
		{
			str1 = Hint1;
			InfiniteHintTime=1;
		}
		else
		{
			str1 = Hint2;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'LibraryBookPickup'
	Icon=Texture'HUDPack.Icon_Inv_LibraryBook'
	InventoryGroup =127
	Price=40
	bPaidFor=false
	LegalOwnerTag="betty"
	UseForErrands=1
	ExamineAnimType="Book"
	ExamineDialog=Sound'DudeDialog.dude_ithinkineedthat'
	Hint1="Press the 'Use Item' key (Enter) to return it and pay."
	Hint2="Head to the library."
	Hint3=""
	bUseCashierHints=true
	}
