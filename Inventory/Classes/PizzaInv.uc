///////////////////////////////////////////////////////////////////////////////
// PizzaInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Pizza inventory item.
//
//	You can eat Pizza to get a little bit of health back. 
//
///////////////////////////////////////////////////////////////////////////////

class PizzaInv extends OwnedInv;

///////////////////////////////////////////////////////////////////////////////
// vars
///////////////////////////////////////////////////////////////////////////////
var float HealingPct;	// Percentage of how much health you add

///////////////////////////////////////////////////////////////////////////////
// Generally used by QuickHealth player key to determine which powerup he
// should use next when healing himself.
///////////////////////////////////////////////////////////////////////////////
function float RateHealingPower()
{
	local P2Pawn CheckPawn;

	CheckPawn = P2Pawn(Owner);
	if(CheckPawn != None)
	{
		return CheckPawn.HealthPctConversion*HealingPct;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Active state: this inventory item is armed and ready to rock!
///////////////////////////////////////////////////////////////////////////////
state Activated
{
	function bool EatIt()
	{
		local P2Pawn CheckPawn;

		CheckPawn = P2Pawn(Owner);

		// if tainted == 1, we'll divide 2, otherwise, the normal amount will be granted.
		if(CheckPawn.AddHealthPct(HealingPct/(1 + Tainted), Tainted, , , , true))
		{
			TurnOffHints();	// When you use it, turn off the hints

			ReduceAmount(1);
			return true;
		}
		return false;
	}
Begin:
	EatIt();
	GotoState('');
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	HealingString="You ate a piece of pizza."
	HealingPct=5
	PickupClass=class'PizzaPickup'
	Icon=Texture'Hudpack.icons.icon_inv_pizza'
	InventoryGroup =122
	bEdible=true
	ExamineAnimType="Letter"
	ExamineDialog=Sound'DudeDialog.dude_ithinkineedthat'
	Hint1="Magically cures light wounds "
	Hint2="if eaten. Press Enter to eat."
	}
