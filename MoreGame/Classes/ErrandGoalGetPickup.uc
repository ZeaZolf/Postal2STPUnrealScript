///////////////////////////////////////////////////////////////////////////////
// ErrandGoalGetPickup
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Errand goal that requires the dude get a certain item
//
///////////////////////////////////////////////////////////////////////////////
class ErrandGoalGetPickup extends ErrandGoal;

///////////////////////////////////////////////////////////////////////////////
// Vars
///////////////////////////////////////////////////////////////////////////////
var () Name	PickupClassName;	// Class of item we want to trigger
								// the end of the errand
var () Name	PickupTag;			// Tag for specific item we want to trigger, if this
								// isn't set, then the pickup class type must be 

///////////////////////////////////////////////////////////////////////////////
// Check to see if this errand is done
///////////////////////////////////////////////////////////////////////////////
function bool CheckForCompletion(Actor Other, Actor Another, Pawn ActionPawn)
{
	local Pickup pcheck;

	pcheck = Pickup(Other);
	
	// Check if the player is picking up this item, if it's not
	// a player, then skip
	if(pcheck != None
		&& ActionPawn != None
		&& P2Player(ActionPawn.Controller) != None)
	{
		// if the same tag
		if(pcheck.Tag == PickupTag)
			return true;
		// if the same class
		if(PickupClassName != '' && pcheck.IsA(PickupClassName))
			return true;
	}

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Check if Other is used by an errand
///////////////////////////////////////////////////////////////////////////////
function bool CheckForErrandUse(Actor Other)
{
	if(Other.Tag == PickupTag
		|| (PickupClassName != '' && Other.IsA(PickupClassName)))
		return true;

	return false;
}


defaultproperties
{
}
