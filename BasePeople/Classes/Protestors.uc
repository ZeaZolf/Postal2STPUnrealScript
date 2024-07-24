//=============================================================================
// Protestors
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for all protestor characters.
//
//=============================================================================
class Protestors extends Marchers
	notplaceable
	Abstract;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Confused before next state 
// Generally be confused then do your next state, like attack the guy
// you were confused about
// Requires InterestVect be set first for the focal point interest
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state ConfusedByDanger
{
	///////////////////////////////////////////////////////////////////////////////	
	///////////////////////////////////////////////////////////////////////////////
	function bool SayWhat()
	{
		return true;
	}
}

defaultproperties
	{
	ControllerClass=class'ProtestorController'
	bIsTrained=false
	// give protestors a picket sign (derived classes can assign different skins)
	Boltons[0]=(staticmesh=staticmesh'timb_mesh.items.picket_timb',bCanDrop=true)
	// protestors are always armed (imagine that)
	BaseEquipment[0]=(weaponclass=class'Inventory.PistolWeapon')
	Gang="Protestors"
	Psychic=0.15
	Talkative=0.0
	Cajones=1.0
	Rebel=1.0
	PainThreshold=1.0
	ViolenceRankTolerance=1
	}
