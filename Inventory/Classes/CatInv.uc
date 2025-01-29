///////////////////////////////////////////////////////////////////////////////
// CatInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Cat inventory item.
//
// This uses UniqueSkins to save the skin texture for each unique cat that goes 
// into the inventory. It treats it as a stack, so the first cat in is the last cat(texture) out.
//
///////////////////////////////////////////////////////////////////////////////
class CatInv extends P2PowerupInv;

///////////////////////////////////////////////////////////////////////////////
// vars, consts
///////////////////////////////////////////////////////////////////////////////
var travel array<Material> UniqueSkins;		// Keep all the unique skins for each cat in this
											// inventory, and travel them

var localized string RemoveGoreHint;		// Tells you, you can't have cats on guns in no gore mode.

const DROP_CAT_RADIUS	=	100;

///////////////////////////////////////////////////////////////////////////////
// I'm sure there are more ways to do this (skin the cat, ha, ha!), but we're just going to 
// send in the skin of the new types being added and save it on our skins stack.
///////////////////////////////////////////////////////////////////////////////
function AddAmount(int AddThis, 
				   optional Texture NewSkin, 
				   optional StaticMesh NewMesh,
				   optional int IsTainted)
{
	local int cur, i;

	// Add in the number
	Super.AddAmount(AddThis);

	if(AddThis > 0)
	{
		// Save the skin, no matter if it's different or the same for the
		// cats we have already, add it to the stack
		cur = UniqueSkins.Length;
		UniqueSkins.Insert(UniqueSkins.Length, AddThis);
		for(i=0; i < AddThis; i++)
		{
			if(NewSkin != None)
				UniqueSkins[cur + i] = NewSkin;
			else
				UniqueSkins[cur + i] = Skins[0];
		}
		//log(self$" added "$UniqueSkins[UniqueSkins.Length-1]$" length "$UniqueSkins.Length);
	}
}

///////////////////////////////////////////////////////////////////////////////
// We're just going to delete the last skin in the array. Use GetNextSkin before
// this to get the skin out.
///////////////////////////////////////////////////////////////////////////////
function ReduceAmount(int UseAmount, 
					  optional out Texture NewSkin, 
					  optional out StaticMesh NewMesh,
					  optional out int IsTainted,
					  optional bool bNoUsedUp)
{
	if(UseAmount > 1)
		Warn(self$" ReduceAmount can't drop more than one thing at a time");

	NewSkin = Texture(UniqueSkins[UniqueSkins.Length-1]);

	//log(self$" removing "$NewSkin$" length "$UniqueSkins.Length);

	UniqueSkins.Remove(UniqueSkins.Length-UseAmount, UseAmount);

	Super.ReduceAmount(UseAmount, NewSkin, NewMesh, IsTainted, bNoUsedUp);
}

///////////////////////////////////////////////////////////////////////////////
// Active state: this inventory item is armed and ready to rock!
///////////////////////////////////////////////////////////////////////////////
state Activated
{
	function UseWithCurrentWeapon()
	{
		local P2Pawn CheckPawn;
		local P2Player p2p;
		local Inventory thisinv;
		local P2Weapon newgun;
		local CatableWeapon oldweap;

		CheckPawn = P2Pawn(Owner);	
		p2p = P2Player(CheckPawn.Controller);
			
		if(p2p == None)
			return;
		
		oldweap = CatableWeapon(CheckPawn.Weapon);
		// Check for the various weapons that sync with a cat
		// See if it's a normal shotgun/machinegun, that's waiting for nothing
		// Make sure you allow blood/gore/cats
		if(oldweap != None
			&& oldweap.ReadyForCat())
		{
			if(class'P2Player'.static.BloodMode())
			{
				// Don't need the hint anymore
				TurnOffHints();
				// Tell the current gun we're getting a cat put on us
				oldweap.bPutCatOnGun=true;
				// Set it here because we might try to level switch and we don't want to cheat the player
				oldweap.CatOnGun=1;
				// Use one cat--could be last one
				// and put the right skin on the gun
				ReduceAmount(1, oldweap.CatSkin);
				// Record that we used the cat
				if(P2GameInfoSingle(Level.Game) != None
					&& P2GameInfoSingle(Level.Game).TheGameState != None
					&& CheckPawn.bPlayer)
				{
					P2GameInfoSingle(Level.Game).TheGameState.CatsUsed++;
				}
				// put this weapon down so we can stick the cat on it
				p2p.NextWeapon();
			}
			else // If no gore, put a message so they know you can't do that
			{
				p2p.ClientMessage(RemoveGoreHint);
			}
		}
	}
Begin:
	UseWithCurrentWeapon();
	GotoState('');
}

///////////////////////////////////////////////////////////////////////////////
// Add a controller to our newly spawned cat
///////////////////////////////////////////////////////////////////////////////
function AddController(AnimalPawn newcat)
{
	if ( newcat.Controller == None
		&& newcat.Health > 0 )
	{
		if ( (newcat.ControllerClass != None))
			newcat.Controller = spawn(newcat.ControllerClass);
		if ( newcat.Controller != None )
			newcat.Controller.Possess(newcat);
		// Check for AI Script
		newcat.CheckForAIScript();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Toss out a cat pawn, but load it dynamically
///////////////////////////////////////////////////////////////////////////////
function DropFrom(vector StartLocation)
{
	local AnimalPawn ThrowMe;
	local class<AnimalPawn> aclass;
	local vector DropSpot, rot;
	local Texture NewSkin;

	aclass = class<AnimalPawn>(DynamicLoadObject("People.CatPawn", class'Class'));

	// Create it a distance in front of you
	DropSpot = Instigator.Location;
	rot = vector(Instigator.Rotation);
	DropSpot = rot*DROP_CAT_RADIUS + DropSpot;
	DropSpot.z+=Instigator.CollisionHeight;

	ThrowMe = spawn(aclass,,,DropSpot);
	// Throw out one
	if ( ThrowMe == None )
		return;

	ThrowMe.Instigator = Instigator;
	// It worked so alert the dogs
	ThrowMe.AlertPredator();

	// If throw each one and you have more than one, then only spawn a copy
	if(bThrowIndividually)
	{
		AddController(ThrowMe);
		AnimalController(ThrowMe.Controller).GotoStateSave('FallingFar');
		// Force the throw speed to be the animal's running speed
		ThrowMe.Velocity = ThrowMe.GroundSpeed*Normal(Velocity);
		Velocity = vect(0,0,0);
		// Reduce out inventory if this worked
		ReduceAmount(1,NewSkin);
		// Put the right skin on the new cat
		ThrowMe.Skins[0] = NewSkin;
	}
	else if(Amount == 0)
	{
		///////////////////////////////////////////////////////////////////////////////
		// Same as DropFrom in Inventory.uc, but we pass the instigator along to
		// the spawned pickup as its owner, because we want to know who most recently
		// dropped this for errands
		///////////////////////////////////////////////////////////////////////////////
		if ( Instigator != None )
		{
			DetachFromPawn(Instigator);	
			Instigator.DeleteInventory(self);
		}	
		SetDefaultDisplayProperties();
		Inventory = None;
		Instigator = None;
		StopAnimating();
		GotoState('');

		Destroy();
	}
}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'CatPickup'
	Icon=Texture'HUDPack.Icon_Inv_Cat'
	InventoryGroup =101
	Skins[0]=Texture'AnimalSkins.Cat_Orange'
	Hint1="Press Enter to put the cat on the     "
	Hint2="Shotgun when you have the Shotgun out."
	RemoveGoreHint="What are you trying to do with that cat? That would be *gory*."
	}
