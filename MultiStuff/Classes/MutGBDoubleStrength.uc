///////////////////////////////////////////////////////////////////////////////
// MutGBDoubleStrength.
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// Double Strength for GrabBag only
//
// With this on, it doubles the strength boost you get from each bag.
//
///////////////////////////////////////////////////////////////////////////////
class MutGBDoubleStrength extends Mutator;


///////////////////////////////////////////////////////////////////////////////
// Doubles strength of default flavins.
///////////////////////////////////////////////////////////////////////////////
function ModifyPlayer(Pawn Other)
{
	if(MpPawn(Other) != None)
		MpPawn(Other).MagnifyFlavinMult(2.0);

	if ( NextMutator != None )
		NextMutator.ModifyPlayer(Other);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function bool MutatorIsAllowed()
{
	return true;
}

defaultproperties
{
	GroupName="GBDamage"
	FriendlyName="Grab: Double Strength"
	Description="For GrabBag games only--doubles the strength you get with each bag you pick up."
}