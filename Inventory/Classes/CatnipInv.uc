///////////////////////////////////////////////////////////////////////////////
// CatnipInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Tin of ultra-powered, psychotic-episode inducing catnip,
// in your inventory.
//
// If you activate it, you open it and throw it on the ground. It then
// attracts cats in the area.
// If you just drop it like normal, it doesn't do anything special.
//
///////////////////////////////////////////////////////////////////////////////
class CatnipInv extends OwnedInv;

///////////////////////////////////////////////////////////////////////////////
// vars/consts
///////////////////////////////////////////////////////////////////////////////
var Sound InhaleSound;
var Sound ExhaleSound;	// sounds for smokin'!
var vector SmokeColor;

///////////////////////////////////////////////////////////////////////////////
// Toss this item out.
///////////////////////////////////////////////////////////////////////////////
function DropFrom(vector StartLocation)
{
	Super.DropFrom(StartLocation);
	// We've completed how we're 'supposed' to use this
	TurnOffHints();
}

///////////////////////////////////////////////////////////////////////////////
// Active state: this inventory item is armed and ready to rock!
///////////////////////////////////////////////////////////////////////////////
state Activated
{
	ignores Activate;

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function BlowSmoke()
	{
		local P2MocapPawn CheckPawn;
		local P2Player p2p;

		CheckPawn = P2MocapPawn(Owner);
		p2p = P2Player(CheckPawn.Controller);

		p2p.BlowSmoke(SmokeColor);
	}

	function bool SmokeIt()
	{
		local P2Pawn CheckPawn;

		CheckPawn = P2Pawn(Owner);

		TurnOffHints();	// When you use it, turn off the hints

		if(P2Player(Pawn(Owner).Controller) != None)
			P2Player(Pawn(Owner).Controller).SmokeCatnip();
		ReduceAmount(1);
		return true;
	}
Begin:
	BlowSmoke();
	Owner.PlaySound(ExhaleSound);
	Sleep(Owner.GetSoundDuration(ExhaleSound));
	SmokeIt();
	GotoState('');
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'CatnipPickup'
	Icon=Texture'Hudpack.icons.icon_inv_catnip'
	InventoryGroup =119
	InhaleSound=Sound'WMaleDialog.wm_inhale'
	ExhaleSound=Sound'WMaleDialog.wm_exhale'
	Hint1="Press ' to drop the "
	Hint2="catnip tin and      "
	Hint3="attract nearby cats."
	SmokeColor=(X=0,Y=255,Z=0)
	}
