///////////////////////////////////////////////////////////////////////////////
// ErrandGoalGiveInventory
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// When the KillMeTag person dies, the dudes errand will be complete
//
///////////////////////////////////////////////////////////////////////////////
class ErrandGoalKillMe extends ErrandGoal;

///////////////////////////////////////////////////////////////////////////////
// Vars
///////////////////////////////////////////////////////////////////////////////
var ()name KillMeTag;			// Uniquely tagged person that must die for you
								// to complete the errand. 

///////////////////////////////////////////////////////////////////////////////
// Check to see if this errand is done
///////////////////////////////////////////////////////////////////////////////
function bool CheckForCompletion(Actor Other, Actor Another, Pawn ActionPawn)
{
	// check if it's the droid we're looking for
	if(FPSPawn(ActionPawn) != None
		&& ActionPawn.Health <= 0				// Definitely dead
		&& FPSPawn(ActionPawn).bUseForErrands	// Used for an errand
		&& ActionPawn.Tag == KillMeTag)
			return true;

	return false;
}

defaultproperties
{
}
