///////////////////////////////////////////////////////////////////////////////
// Postal 2 player controller
//
// Dude controller, placed here so it has access in default properties
// to all the inventory items and things defined so late in the ucc make.
// 
// If you put these defaults in Postal2Game.P2Player, then you run into dependency
// issues with things like the MilkPickup and such
///////////////////////////////////////////////////////////////////////////////
class DudePlayer extends MpPlayer;

///////////////////////////////////////////////////////////////////////////////
// VARS
///////////////////////////////////////////////////////////////////////////////
var Sound GaryTalking;
var array<Texture> GarySkins;

///////////////////////////////////////////////////////////////////////////////
// CONST
///////////////////////////////////////////////////////////////////////////////
const	WATCH_ME_CHANGE_RADIUS	= 4096;
const	MAKE_OUT_CHANGE_RADIUS	= 1024;
const	PETITION_FOV			= 0.2;
const   BONE_HEAD				= 'MALE01 head';


replication
{
	reliable if( RemoteRole==ROLE_AutonomousProxy ) 
		ClientToggleToHands;
}


///////////////////////////////////////////////////////////////////////////////
// called after a level travel
///////////////////////////////////////////////////////////////////////////////
event TravelPostAccept()
{
	local P2GameInfoSingle checkg;

	Super.TravelPostAccept();

	checkg = P2GameInfoSingle(Level.Game);

	// Start of new day
	if(checkg == None
		|| checkg.TheGameState == None
		|| (checkg.TheGameState.bFirstLevelOfDay
			&& !checkg.bLoadedSavedGame) )
	{
		// Switch to your hands on the start of a new day
		SwitchToLastWeaponInGroup(MyPawn.HandsClass.default.InventoryGroup);

		if(MyPawn.Weapon != None)
		{
			// Remember what our hands are
			LastWeaponGroupHands = MyPawn.Weapon.InventoryGroup;
			LastWeaponOffsetHands= MyPawn.Weapon.GroupOffset;
		}

		// Switch your inventory to your map on the start of a new day
		SwitchToThisPowerup(class'MapInv'.default.InventoryGroup, class'MapInv'.default.GroupOffset);

		// To start a new day, give the player full health if he's low (he could
		// be over the max with crack, so make sure to check)
		if(MyPawn.Health < MyPawn.HealthMax)
			MyPawn.Health = MyPawn.HealthMax;
	}
	else
	{
		// If it's not a new day (just another level) restore the inventory item
		// we had when going through the transition
		if(checkg.TheGameState.LastSelectedInventoryGroup >= 0)
			SwitchToThisPowerup(checkg.TheGameState.LastSelectedInventoryGroup, 
								checkg.TheGameState.LastSelectedInventoryOffset);
	}

	// Set no-fire damage for enhanced mode
	if(checkg.VerifySeqTime())
		MyPawn.TakesOnFireDamage=0.0;

	log(self$" &&&&&&&&&&&&&&&&&&&&TravelPostAccept, starting up health "$MyPawn.Health$" mypawn "$MyPawn.HealthMax);
	MyPawn.bPlayerStarting=false;
}

///////////////////////////////////////////////////////////////////////////////
// See if we picked up a weapon, and if we're in a disguise, change the hands
// on the weapon to match our diguise
///////////////////////////////////////////////////////////////////////////////
function NotifyAddInventory(inventory NewItem)
{
	local class<ClothesInv> UseNewClass;
	local P2Weapon p2weap;

	Super.NotifyAddInventory(NewItem);

	// Check for weapons and change hand textures to match our disguise
	p2weap = P2Weapon(NewItem);
	if(p2weap != None)
	{
		if(CurrentClothes != DefaultClothes)
		{
			UseNewClass = class<ClothesInv>(CurrentClothes);
			p2weap.ChangeHandTexture(UseNewClass.default.HandsTexture, DefaultHandsTexture, 
				UseNewClass.default.FootTexture);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	if(Damage > 0
		|| Level.Game.bIsSinglePlayer)
	{
		Super.NotifyTakeHit(InstigatedBy, HitLocation, Damage, damageType, Momentum);

		// Stop peeing when you take any damage except gonrrhea damage
		// (in which case keep letting you pee)
		//mypawnfix
		if(Pawn.Weapon == P2Pawn(Pawn).MyUrethra
			&& Pawn.Weapon.IsFiring()
			&& damageType != class'GonorrheaDamage'
			&& !ClassIsChildOf(damageType, class'BurnedDamage')
			&& damageType != class'OnFireDamage')
		{
			// If you were peeing, and you got hurt, then stop peeing for a moment
			P2Weapon(Pawn.Weapon).ForceEndFire();
			P2Weapon(Pawn.Weapon).UseWaitTime = SayTime + Frand();
			Pawn.Weapon.GotoState('WaitAfterStopping');
		}
	}	
}

///////////////////////////////////////////////////////////////////////////////
// Check if we can use these clothes and they aren't the same as what we
// have on, if so, change them.
///////////////////////////////////////////////////////////////////////////////
function bool CheckForChangeClothes(class<Inventory> NewClothesClass)
{
	if(NewClothesClass != CurrentClothes)
	{
		NewClothes = NewClothesClass;
		return true;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// After a level change we have to re-clothe you with the clothes you left
// with (we don't save all the skin changes across a level transition--we just
// save what you were wearing when you left, so now we have to redo it)
// CurrentClothes is saved by the gamestate. Check it against default dude
// clothes, and if it's different, change them. (But with no screen fade
// and no level transition
///////////////////////////////////////////////////////////////////////////////
function SetClothes(class<Inventory> NewClothesClass)
{
	if(NewClothesClass != DefaultClothes)
	{
		NewClothes = NewClothesClass;
		ChangeToNewClothes();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Called after a saved game has been loaded
///////////////////////////////////////////////////////////////////////////////
event PostLoadGame()
{
	Super.PostLoadGame();
	SetClothes(CurrentClothes); // ensures the hud splash icons behind come up for each outfit
}

///////////////////////////////////////////////////////////////////////////////
// Change the dudes clothes from what they are now, to the this new clothing
// type, and if specified, keep the old clothes in his inventory
///////////////////////////////////////////////////////////////////////////////
function ChangeToNewClothes()
{
	local class<ClothesInv> UseNewClass;
	local class<ClothesInv> UseCurrClass;
	local Inventory inv;
	local P2Pawn CheckP;
	local PoliceController policec;
	local PersonController personc;
	local int count;

	UseNewClass = class<ClothesInv>(NewClothes);
	UseCurrClass= class<ClothesInv>(CurrentClothes);

	// Put our old clothes into our inventory, if we're supposed to
	if(UseNewClass.default.bAllowSwap
		&& UseCurrClass.default.bAllowKeep)
	{
		// Switch your inventory view to your old clothes, now in your inventory
		MyPawn.SelectedItem = Powerups(MyPawn.CreateInventoryByClass(UseCurrClass));
	}

	// Change third person texture and mesh
	MyPawn.SwitchToNewMesh(UseNewClass.default.BodyMesh,
										UseNewClass.default.BodySkin,
										UseNewClass.default.HeadMesh,
										UseNewClass.default.HeadSkin);

	// Change first person textures
	ChangeAllWeaponHandTextures(UseNewClass.default.HandsTexture, UseNewClass.default.FootTexture);

	// Change the hud backer splats
	P2Hud(MyHUD).ChangeHudSplats(UseNewClass.default.HudSplats);

	// If your changing into new clothes, check to see who saw you.. you might fool people
	if(CurrentClothes != NewClothes)
	{
		// Check if anyone sees/doesn't see us change our clothes. For most of our attackers
		// who don't see us change, we'll erase our record with them.
		// If we use a VisibleCollidingActors check, people behind walls won't be counted, 
		// and we want those people.
		foreach CollidingActors(class'P2Pawn', CheckP, WATCH_ME_CHANGE_RADIUS, MyPawn.Location)
		{
			personc = PersonController(CheckP.Controller);
			if(personc != None)
			{
				policec = PoliceController(CheckP.Controller);
				
				if(personc.CanSeePawn(CheckP, MyPawn))
				{
					if(policec != None)
					{
						// If our new clothes are cop clothes, check to see if any cops around
						// saw us changing into a cop uniform. If they did--have them arrest you
						// or attack you (if it's military)!
						if(NewClothes == class'CopClothesInv')
							policec.HandleNewImpersonator(MyPawn);
						count++;
					}
				}
				else if(policec == None)
				// If this person didn't see us, and it's not a cop, and they are attacking me
				// then make them forget they were attacking me (but they could remember if I do
				// something stupid, like keep my gun out when I'm the dude, etc.)
				{
					personc.LostAttackerToDisguise(MyPawn);
				}
			}
		}

		// Cops are handled seperately when losing the dude to a costume change because
		// they are of a 'hive' mind.
		// If nooooooooo cops see you changing into a different outfit--erase your police record!
		// Set the cop radio wanted status to 0, so cops don't arrest you
		if(count == 0)
		{
			P2GameInfoSingle(Level.Game).TheGameState.ResetCopRadioTime();
			// Also, (this slowness doesn't get noticed because the screen's black as we
			// change our clothes) go back through the cops that were chasing you, if there
			// were any, and make them paranoid, looking for their attacker
			foreach CollidingActors(class'P2Pawn', CheckP, WATCH_ME_CHANGE_RADIUS, MyPawn.Location)
			{
				policec = PoliceController(CheckP.Controller);
				if(policec != None)
				{
					// Get confused and start looking around for the attacker they just lost
					policec.LostAttackerToDisguise(MyPawn);
				}
			}
		}
	}
	// Save our new clothes
	CurrentClothes = NewClothes;
}

///////////////////////////////////////////////////////////////////////////////
// Just finished putting my clothes on, say something funny
///////////////////////////////////////////////////////////////////////////////
function FinishedPuttingOnClothes()
{
	if(CurrentClothes == class'CopClothesInv')
		NowIsCop();
	else if(CurrentClothes == class'DudeClothesInv')
		NowIsDude();
	else if(CurrentClothes == class'GimpClothesInv')
		NowIsGimp();
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed as boring old me...
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsDude()
{
	return (CurrentClothes == class'DudeClothesInv');
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed a cop! (for ai use)
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsCop()
{
	return (CurrentClothes == class'CopClothesInv');
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed the gimp! (for ai use)
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsGimp()
{
	return (ClassIsChildOf(CurrentClothes, class'GimpClothesInv'));
}

///////////////////////////////////////////////////////////////////////////////
// Player doesn't have the map selected, but wants to use it now anyway
///////////////////////////////////////////////////////////////////////////////
exec function QuickUseMap()
{
	local Inventory inv;

	if( Level.Pauser!=None)
		return;

	if(Pawn != None)
	{
		// Find the map in his inventory, then activate it manually, but *don't* switch
		// to it
		inv = Pawn.Inventory;

		while(inv != None
			&& MapInv(inv) == None)
		{
			inv = inv.Inventory;
		}

		// If we found it, activate it
		if(MapInv(inv) != None)
		{
			inv.GotoState('Activated');
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Switch directly to your hands weapon, or back to whatever
// weapon you had out before you toggled to your hands.
///////////////////////////////////////////////////////////////////////////////
exec function ToggleToHands(optional bool bForce)
{
	ClientToggleToHands(bForce);
}

///////////////////////////////////////////////////////////////////////////////
// Is simply just the body when called 
///////////////////////////////////////////////////////////////////////////////
function ClientToggleToHands(optional bool bForce)
{
	if( Level.Pauser!=None)
		return;

	// If you're not also pressing fire, then do this
	if(Pawn != None
		//mypawnfix
		&& (!Pawn.PressingFire()
			|| bForce))
	{
		// If we're not using our hands, then remember what weapon this is
		// and switch to it
		if(Pawn.Weapon == None
			|| Pawn.Weapon.InventoryGroup != MyPawn.HandsClass.default.InventoryGroup)
		{
//			// Don't remember that you were using your urethra, or your hands before
//			if(
			if(Pawn.Weapon != None)
			{
				if(Pawn.Weapon.InventoryGroup != MyPawn.HandsClass.default.InventoryGroup)
				{
					// Remember what weapon we we're using
					LastWeaponGroupHands = Pawn.Weapon.InventoryGroup;
					LastWeaponOffsetHands= Pawn.Weapon.GroupOffset;
				}
			}
			else
			{
				// If you didn't have one, say it's your hands
				LastWeaponGroupHands = MyPawn.HandsClass.default.InventoryGroup;
				LastWeaponOffsetHands = MyPawn.HandsClass.default.GroupOffset;
			}
			// Switch to the best version of the hands in this group (we might
			// need to use the clipboard as our hands for one day).
			SwitchToLastWeaponInGroup(MyPawn.HandsClass.default.InventoryGroup);
			return;
		}
		else // already using our hands
		{
			// If we're peeing, don't remember that we are, just stop peeing and switch
			// back to our hands, preserving the weapon we were using before
			if(Pawn.Weapon.GroupOffset == class'UrethraWeapon'.default.GroupOffset)
			{
				SwitchToLastWeaponInGroup(MyPawn.HandsClass.default.InventoryGroup);
				return;
			}
			// If we were using our hands, and the last weapon we remember is a legitimate
			// weapon (like a pistol) then switch to it.
			if(LastWeaponGroupHands != MyPawn.HandsClass.default.InventoryGroup)
			{
				// Switch to our old weapon, but if it fails, make our hands the one's
				// were switching too, and don't switch at all.
				if(!SwitchToThisWeapon(LastWeaponGroupHands, LastWeaponOffsetHands))
				{
					LastWeaponGroupHands = MyPawn.HandsClass.default.InventoryGroup;
					LastWeaponOffsetHands = MyPawn.HandsClass.default.GroupOffset;
				}
			}
			/*
			// Removed--We used to make your hands come out when you 'fired' the hands
			// but this confused people because they didn't know what they could do with them.
			//
			// If the last weapon we remember is also our hands, then just make them
			// stick out so the player can see this
			else if(LastWeaponOffsetHands == MyPawn.HandsClass.default.GroupOffset)
			{
				Fire();
			}
			*/
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Switch directly to your hands weapon
// If you force this, it will override anything in the hands that say don't
// currently show the hands (ex: the clipboard hands will override the normal
// hands, but sometimes (on suicide) you want the normal hands no matter what)
///////////////////////////////////////////////////////////////////////////////
exec function SwitchToHands(optional bool bForce)
{
	if( Level.Pauser!=None)
		return;

	// If you're not also pressing fire, then do this
	if(Pawn != None
		&& Pawn.Weapon.class != MyPawn.HandsClass
		//mypawnfix
		&& (!Pawn.PressingFire()
			|| bForce))
	{
		SwitchToThisWeapon(MyPawn.HandsClass.default.InventoryGroup, 
						MyPawn.HandsClass.default.GroupOffset, true);
	}
}

///////////////////////////////////////////////////////////////////////////////
// If we've gone through a level transition that takes our weapons/inventory
// use this to reset the toggle button
///////////////////////////////////////////////////////////////////////////////
function ResetHandsToggle()
{
	// If you didn't have one, say it's your hands
	LastWeaponGroupHands = MyPawn.HandsClass.default.InventoryGroup;
	LastWeaponOffsetHands = MyPawn.HandsClass.default.GroupOffset;
}

///////////////////////////////////////////////////////////////////////////////
// Do you have only your hands out?
///////////////////////////////////////////////////////////////////////////////
function bool HasHandsOut()
{
	local P2Weapon p2weap;

	p2weap = P2Weapon(Pawn.Weapon);

	if(p2weap != None
		&& p2weap.IsIdle()
		&& p2weap.class == MyPawn.HandsClass)
		return true;

	return false;
}

///////////////////////////////////////////////////////////////////////////////
//Throw out current weapon, and switch to a new weapon
// OR
// in special situations, when ordered by a cop, you can drop the
// last weapon you had, if you're on your hands weapon
//
//
//  Last part is the same as PlayerController version. Copying this over just to control
// the speed and direction. Called on client/single player game.
///////////////////////////////////////////////////////////////////////////////
exec function ThrowWeapon()
{
	if( Level.Pauser!=None)
		return;

	if(Pawn == None)
		return;

	//  if you're also pressing fire, then don't allow this
	if(Pawn.PressingFire())
		return;

	if( P2Weapon(Pawn.Weapon)==None)
		return;

    ServerThrowWeapon();
}

///////////////////////////////////////////////////////////////////////////////
// Server part of actually throwing out the weapon.
///////////////////////////////////////////////////////////////////////////////
function ServerThrowWeapon()
{
	local Inventory inv;
	local bool bFoundIt;
	local P2Weapon PossiblePendingWeapon;

	// If we're being told by a cop to drop the weapon we've concealed by
	// switching to our hands, then by pressing this button, during this time
	// we will automatically stay on our hands weapon, but drop the last weapon
	// we knew about
	// So if the hints are on, and we're on a hands type weapon, and the last
	// weapon we had wasn't a hands type, then to find it, and drop it.
	if(bShowWeaponHints
		&& P2Weapon(Pawn.Weapon).bArrestableWeapon
		&& LastWeaponSeen != None
		&& !LastWeaponSeen.default.bArrestableWeapon)
	{
		inv = Pawn.Inventory;

		// Find that inventory item
		while(inv != None
			&& !bFoundIt)
		{
			if(inv != None 
				&& inv.InventoryGroup == LastWeaponSeen.default.InventoryGroup 
				&& inv.GroupOffset == LastWeaponSeen.default.GroupOffset)
				bFoundIt=true;
			else
				inv = inv.Inventory;
		}

		if(bFoundIt)
		{
			// Find the inventory we're talking about
			if(MyPawn.TossThisInventory(GenTossVel(), inv))
			{
				// If it worked, say the cop noticed, so say you don't
				// have anything right now
				LastWeaponSeen=None;
				// Set it to your hands or whatever you have now, since the last
				// weapon we were set to, has just been thrown
				LastWeaponGroupHands = MyPawn.Weapon.InventoryGroup;
				LastWeaponOffsetHands= MyPawn.Weapon.GroupOffset;
			}
		}
	}
	else	// Otherwise, just try to drop the weapon we have
	{
		if(!Pawn.Weapon.bCanThrow)
			return;

		// Throw it out now
		Pawn.TossWeapon(GenTossVel());

		// If it worked
		if(Pawn.Weapon == None
			|| Pawn.Weapon.Instigator == None)
		{
			// If we're being told by a cop to drop our weapon, say we dropped it
			if(bShowWeaponHints)
			{
				LastWeaponSeen=None;
			}
			// Always switch to your hands after dropping a weapon
			ToggleToHands();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// The player unzips his pants, and prepares his urethra for peeing. 
// The Fire button makes him actually pee.
///////////////////////////////////////////////////////////////////////////////
exec function UseZipper( optional float F )
{
	if(P2Pawn(Pawn) == None
		//mypawnfix
		|| P2Pawn(Pawn).bPlayerStarting)
		return;

	// Don't allow this to unpause the game
	if ( Level.Pauser == PlayerReplicationInfo )
		return;

	//  if you're also pressing fire, then don't allow this
	if(Pawn.PressingFire())
	{
		return;
	}
	
	// Must have a urethra to go pee
	if(P2Pawn(Pawn).MyUrethra == None)
	{
		log("I'm a p2pawn and I have no urethra "$self);
		return;
	}

	//log(self$" my weapon "$MyPawn.Weapon$" urethra "$MyPawn.MyUrethra);
	// Unzip pants and prepare to pee
	if(Pawn.Weapon != P2Pawn(Pawn).MyUrethra)
	{
		if(Pawn.Weapon != None)
		{
			LastWeaponGroupPee = Pawn.Weapon.InventoryGroup;
			LastWeaponOffsetPee= Pawn.Weapon.GroupOffset;
		}
		else
		{
			LastWeaponGroupPee = 1;
			LastWeaponOffsetPee= 0;
		}

		SwitchToThisWeapon(class'UrethraWeapon'.default.InventoryGroup,
						class'UrethraWeapon'.default.GroupOffset);
	}
	// Pants are already down, so zip them back up
	else if(!P2Pawn(Pawn).MyUrethra.IsInState('NormalFire'))
	{
		bPee=0;
		// Head back to the weapon we had up before we started peeing
		SwitchToThisWeapon(LastWeaponGroupPee, LastWeaponOffsetPee);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Search through the players inventory and use the most powerful health he has.
///////////////////////////////////////////////////////////////////////////////
exec function QuickHealth()
{
	local Inventory inv;
	local P2PowerupInv pickme;
	local float healval, maxheal;

	if( Level.Pauser!=None)
		return;

	if(Pawn != None)
	{
		//mypawnfix
		inv = Pawn.Inventory;

		while(inv != None)
		{
			if(P2PowerupInv(inv) != None)
			{
				healval = P2PowerupInv(inv).RateHealingPower();
				if(maxheal < healval)
				{
					maxheal = healval;
					pickme = P2PowerupInv(inv);
				}
			}
			inv = inv.Inventory;
		}

		// Heal the player with this item
		if(pickme != None)
		{
			// Don't let him use food when he's over the max--only crack.
			if(Pawn.Health < P2Pawn(Pawn).HealthMax
				|| CrackInv(pickme) != None)
			{
				pickme.Activate();
				MyHUD.LocalizedMessage(class'PickupMessagePlus', ,,,,pickme.HealingString);
			}
		}
		else
		{
			MyHUD.LocalizedMessage(class'PickupMessagePlus', ,,,,NoMoreHealthItems);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Timers are used for talking and could interrupt our count. 
// We'll add up how long it's been since we used crack in the state code
// of PlayerMoving and PlayerClimbing and such.
///////////////////////////////////////////////////////////////////////////////
function CheckForCrackUse(float TimePassed)
{
	local float OldTime;
	local int i;

	// if we have a 0 time, we're not addicted
	//mypawnfix
	if(P2Pawn(Pawn).CrackAddictionTime <= 0)
		return;

	OldTime = P2Pawn(Pawn).CrackAddictionTime;

	P2Pawn(Pawn).CrackAddictionTime-=TimePassed;

	if(OldTime >= CrackHintTimes[0])
	{
		for(i=0; i<MAX_CRACK_HINTS; i++)
		{
			if(P2Pawn(Pawn).CrackAddictionTime <= CrackHintTimes[i]
				&& OldTime > CrackHintTimes[i])
			{
				// Say How you need more crack
				P2Pawn(Pawn).Say(P2Pawn(Pawn).myDialog.lDude_NeedMoreCrackHealth);
				// Swap to crack in your inventory if you have it
				SwitchToThisPowerup(class'CrackInv'.default.InventoryGroup,
									class'CrackInv'.default.GroupOffset);
			}
		}
	}
	else	// You didn't find crack in time, so you get hurt badly by it
	{
		if(P2Pawn(Pawn).CrackAddictionTime <= 0)
		{
			P2Pawn(Pawn).CrackAddictionTime = 0;
			P2Pawn(Pawn).TakeDamage(CrackDamagePercentage*Pawn.Health, MyPawn, Pawn.Location,
						vect(0,0,0), class'CrackSmokingDamage');
			// reset the heart after you've been hurt by it
			ResetHeart();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check to turn on/off this weapon
///////////////////////////////////////////////////////////////////////////////
function SetWeaponUseability(bool bUseable, class<P2Weapon> weapclass)
{
	local Inventory inv;

	//mypawnfix
	inv = Pawn.Inventory;

	while(inv != None)
	{
		if(inv.class == weapclass
			&& P2Weapon(inv) != None)
		{
			P2Weapon(inv).SetReadyForUse(bUseable);
			return;
		}
		inv = inv.Inventory;
	}
}

///////////////////////////////////////////////////////////////////////////////
// You're ready to take down signatures, only if you have your clipboard out
///////////////////////////////////////////////////////////////////////////////
function bool ClipboardReady()
{
	if(ClipboardWeapon(MyPawn.Weapon) != None
		&& (MyPawn.Weapon.IsInState('NormalFire')
			|| MyPawn.Weapon.IsInState('Idle')))
		return true;

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Dude is asking for money to be donated to him or a charity
///////////////////////////////////////////////////////////////////////////////
function DudeAskForMoney(vector AskPoint, float AskRadius, 
						 actor HitActor,		// actor we hit with our test forward.. dude's aiming at this guy
						 bool bIsForCharity)
{
	local FPSPawn CheckP, KeepP;
	local float keepdist, checkdist, usedot;
	local byte StateChange;
	local int useline;
	local LambController lambc;
	local PersonController personc;

	// Don't even try this if you're already talking to someone
	if(InterestPawn != None
		|| bDealingWithCashier)
		return;

	keepdist = 2*AskRadius;

	// Check if we were aiming at someone in particular
	CheckP = FPSPawn(HitActor);
	if(CheckP != None)
	{
		if(CheckP != MyPawn									// not me
			&& CheckP.Health > 0)							// live people are listening
			KeepP = FPSPawn(HitActor);
	}

	if(KeepP == None)	// we weren't aiming at anyone in particular so look for someone
	{
		// Do a collision test in this area, where you would have stopped the trace
		ForEach VisibleCollidingActors(class'FPSPawn', CheckP, AskRadius, AskPoint)
		{
			if(CheckP != MyPawn									// not me
				&& CheckP.Health > 0							// live people are listening
				&& FastTrace(MyPawn.Location, CheckP.Location)  // not on the other side of a wall
				&& ((Normal(CheckP.Location - MyPawn.Location) Dot vector(MyPawn.Rotation)) > PETITION_FOV))
				// and generally in front of the dude
			{
				checkdist = VSize(CheckP.Location - AskPoint);

				if(keepdist > checkdist)
				{
					keepdist = checkdist;
					KeepP = CheckP;
				}
			}
		}
	}

	if(KeepP != None)
	{
		personc = PersonController(KeepP.controller);
		if(personc != None)
			useline = personc.DonatedBotherCount;
	}

	// Say to give me money
	switch(useline)
	{
		case -2:
			// Person's dealing with me so leave early
			return; 
		case -1:
		case 0:
			log("-----------------------dude dialogue: please sign this");
			SayTime = MyPawn.Say(MyPawn.myDialog.lDude_Petition1);
		break;
		case 1:
			log("-----------------------dude dialogue: sign it now!");
			SayTime = MyPawn.Say(MyPawn.myDialog.lDude_Petition2);
		break;
		case 2:
			log("-----------------------dude dialogue: sign it or i kill you");
			SayTime = MyPawn.Say(MyPawn.myDialog.lDude_Petition3);
		break;
	}
	SetTimer(SayTime + 1.0, false);
	bStillTalking=true;


	// Tell them who's talking to me
	if(KeepP != None)
	{
		lambc = LambController(KeepP.Controller);
	}

	if(lambc != None)
	{
		lambc.RespondToTalker(MyPawn, None, TALK_askformoney, StateChange);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Make the dude reach out and grab money
///////////////////////////////////////////////////////////////////////////////
function GrabMoneyPutInCan(int MoneyToGet)
{
	local ClipboardWeapon canweap;

	canweap = ClipboardWeapon(Pawn.Weapon);

	if(canweap != None)
	{
		// play anim on clipboard to get signature
		canweap.CauseAltFire();
		// set how many sigs to give the dude, probably just 1
		canweap.PendingMoney = MoneyToGet;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Get a certain amount of money to be given to us
///////////////////////////////////////////////////////////////////////////////
function DudeTakeDonationMoney(int MoneyToGet, bool bIsForCharity)
{
	local ClipboardWeapon canweap;
	local P2GameInfoSingle checkg;

	canweap = ClipboardWeapon(Pawn.Weapon);

	if(bIsForCharity)
	{
		if(canweap != None)
		{
			// grant us the money in the can
			if(!canweap.AmmoType.AddAmmo(MoneyToGet))
			{
				checkg = P2GameInfoSingle(Level.Game);
				if(checkg != None)
				{
					// Now that the errand is complete, after the idle plays on the clipboard
					// it will determine when it's okay to remove the clipboard and use the
					// normal hands again
					checkg.CheckForErrandCompletion(canweap, None, None, self, false);
				}
			}
		}
	}

	// say thanks
	InterestPawn = None;
	SayTime = MyPawn.Say(MyPawn.myDialog.lThanks);
	SetTimer(SayTime + 1.0, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// Returns the number of dollars the player has right now.
///////////////////////////////////////////////////////////////////////////////
function float CashPlayerHas()
{
	return MyPawn.HowMuchInventory(class'MoneyInv');
}

///////////////////////////////////////////////////////////////////////////////
// Setup textures for prizes player won
///////////////////////////////////////////////////////////////////////////////
function SetupTargetPrizeTextures()
{
	local int kills;
	local Material gettex;
	local class<Powerups> pclass;
	local P2PowerupInv p2inv;
	local byte CreatedNow;

	if(P2Hud(MyHUD).TargetPrizes.Length > 0)
		P2Hud(MyHUD).TargetPrizes.Remove(0, P2Hud(MyHUD).TargetPrizes.Length);
	kills = RadarTargetKills;
	// Allocate the ones we've one
	while(kills > 0)
	{
		pclass = None;

		// Various prizes for each kill level
		switch(kills)
		{
			case 1:
				pclass = class<Powerups>(DynamicLoadObject("Inventory.DonutInv", class'Class'));break;
			case 2:
				pclass = class<Powerups>(DynamicLoadObject("Inventory.PizzaInv", class'Class'));break;
			case 3:
				pclass = class<Powerups>(DynamicLoadObject("Inventory.FastFoodInv", class'Class'));break;
			case 5: // nothing for 4
				pclass = class<Powerups>(DynamicLoadObject("Inventory.KevlarInv", class'Class'));break;
			case 8:// nothing for 6-7
				pclass = class<Powerups>(DynamicLoadObject("Inventory.CrackInv", class'Class'));break;
			case 12:// nothing for 9-11
				pclass = class<Powerups>(DynamicLoadObject("Inventory.CatNipInv", class'Class'));break;
				// nothing else past this
		}

		if(pclass != None)
		{
			gettex = pclass.default.Icon;

			// put in the texture list
			P2Hud(MyHUD).TargetPrizes.Insert(P2Hud(MyHUD).TargetPrizes.Length, 1);
			P2Hud(MyHUD).TargetPrizes[P2Hud(MyHUD).TargetPrizes.Length-1] = gettex;
			// give it to the player
			CreatedNow=0;
			p2inv = P2PowerupInv(MyPawn.CreateInventoryByClass(pclass,CreatedNow));
			if(p2inv != None
				&& CreatedNow == 0)
				p2inv.AddAmount(class<P2PowerupPickup>(p2inv.PickupClass).default.AmountToAdd);
		}

		kills--;
	}
}

/*
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ViewShake(float DeltaTime)
{
	local float VelDampen, AccMag;
	local vector checkdiff, checkvel;

	Super.ViewShake(DeltaTime);

	if(!bSniperSettled
		&& bSniperStartToSettle
		&& DesiredFOV != DefaultFOV)
	{
		checkdiff = SniperVect - OldShakeOffset;

		VelDampen = VSize(checkdiff);
		if(SniperDampen > VelDampen)
			SniperDampen = VelDampen;

//		if(abs(checkdiff.x) < SNIPER_MIN_VECT
//			&& abs(checkdiff.y) < SNIPER_MIN_VECT
//			&& abs(checkdiff.z) < SNIPER_MIN_VECT)
		if(SniperDampen < SNIPER_DAMPEN_MIN)
		{
			log(self$" end swing "$SniperVect);
			bSniperSettled=true;
			SniperVect = vect(0, 0, 0);
			SniperVect = vect(0, 0, 0);
		}
		else
		{
			SniperVel = (DeltaTime*(-checkdiff)) + SniperDampen*SniperVel;
			SniperVect += DeltaTime*SniperVel;
			log(self$" vect "$checkdiff$" vel "$SniperVel$" acc "$SniperAcc$" time "$DeltaTime);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// We calculate things that need to take over the player's view here, like the
// sniper rifle movement, or throwing up in first-person
///////////////////////////////////////////////////////////////////////////////
function UpdateRotation(float DeltaTime, float maxPitch)
{
	local vector rotdiff;
	local float swingmag;

	Super.UpdateRotation(DeltaTime, maxPitch);

	rotdiff = (vector(Rotation) - vector(OldRotation));

	if(rotdiff.x == 0
		&& rotdiff.y == 0
		&& rotdiff.z == 0)
	{
		if(!bSniperStartToSettle
			&& RifleWeapon(Pawn.Weapon) != None
			&& DesiredFOV != DefaultFOV)
		{
			SniperDampen = 0.95;
			bSniperStartToSettle=true;
			bSniperSettled=false;
			swingmag = VSize(SwingDir);
			swingmag += 0.1;
			SniperVect = 500*swingmag*Normal(SwingDir);
			SniperVel = SniperVect;
			log(self$" start swing "$SniperVect$" swing dir "$SwingDir$" swing dir mag "$swingmag);
		}
	}
	else
	{
		bSniperSettled=false;
		bSniperStartToSettle=false;
		SwingDir = (rotdiff + SwingDir)/2;
	}

	OldRotation = Rotation;
}
*/

///////////////////////////////////////////////////////////////////////////////
// Turns every current non-player, bystander pawns into Gary Colemans
// It's easy to debug in a player controller (hard in a cheat manager)
///////////////////////////////////////////////////////////////////////////////
function GarySize()
{
	local FPSPawn checkpawn;
	local Gary newgary;
	local vector useloc;
	local rotator userot;

	if(!CheatsAllowed())
		return;

	log(self$" CHEAT: Whatchutalkinbout");
	ClientMessage("Gary-sizing your bystanders--please wait.");

	foreach DynamicActors(class'FPSPawn', checkpawn)
	{
		if(!checkpawn.bPlayer
			&& !checkpawn.bSliderStasis
			&& BystanderController(checkpawn.Controller) != None
			&& CashierController(checkpawn.Controller) == None
			&& RWSController(checkpawn.Controller) == None
			&& Gary(checkpawn) == None)
		{
			useloc = checkpawn.Location;
			userot = checkpawn.Rotation;
			checkpawn.Destroy();
			newgary = spawn(class'Gary',,,useloc,userot,GarySkins[Rand(GarySkins.Length)]);
			if (newgary != None 
				&& newgary.Controller == None
				&& newgary.Health > 0 )
			{
				// Don't put the real gary controller on these... you'l have the right
				// dialog, and the real one has a cashier controller and needs other things.
				newgary.Controller = spawn(class'BystanderController');
				if ( newgary.Controller != None )
				{
					newgary.Controller.Possess(newgary);
					newgary.CheckForAIScript();
				}
				else
					newgary.Destroy();
			}
		}
	}

	MyPawn.PlaySound(GaryTalking);
}

///////////////////////////////////////////////////////////////////////////////
// Turns every current non-player, bystander pawns into this class
// Newclass should be higher level than Bystander.
///////////////////////////////////////////////////////////////////////////////
function ConvertNonImportants(class<P2Pawn> newclass, optional class<AIController> contclass,
							optional bool bHatesPlayer, optional bool bGunCrazy,
							optional bool bNoMales, optional bool bNoFemales)
{
	local FPSPawn checkpawn;
	local FPSPawn newpawn;
	local vector useloc;
	local rotator userot;

	if(contclass == None)
		contclass = newclass.default.ControllerClass;

	foreach DynamicActors(class'FPSPawn', checkpawn)
	{
		if(!checkpawn.bPlayer
			&& !checkpawn.bSliderStasis
			&& (!bNoMales
				|| checkpawn.bIsFemale)
			&& (!bNoFemales
				|| !checkpawn.bIsFemale)
			&& BystanderController(checkpawn.Controller) != None
			&& CashierController(checkpawn.Controller) == None
			&& RWSController(checkpawn.Controller) == None
			&& !ClassIsChildOf(checkpawn.class, newclass))
		{
			useloc = checkpawn.Location;
			userot = checkpawn.Rotation;
			checkpawn.Destroy();
			newpawn = spawn(newclass,,,useloc,userot);
			if (newpawn != None 
				&& newpawn.Controller == None
				&& newpawn.Health > 0 )
			{
				// Don't put the real gary controller on these... you'l have the right
				// dialog, and the real one has a cashier controller and needs other things.
				if ( (contclass != None))
					newpawn.Controller = spawn(contclass);
				if ( newpawn.Controller != None )
				{
					newpawn.Controller.Possess(newpawn);
					newpawn.CheckForAIScript();
					if(bHatesPlayer)
						newpawn.bPlayerIsEnemy = bHatesPlayer;
					if(bGunCrazy
						&& P2Pawn(newpawn) != None)
						P2Pawn(newpawn).bGunCrazy = bGunCrazy;
				}
				else
					newpawn.Destroy();
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Blow smoke for smoking health pipe and catnip.
///////////////////////////////////////////////////////////////////////////////
simulated function BlowSmoke(vector smokecolor)
{
	local PipeSmokeFPS smokeff;
	local float useoffset;
	local vector useloc;
	local rotator userot;

	// generate smoke effect
	if(bBehindView)
	{
		//mypawnfix
		useloc = P2MocapPawn(Pawn).MyHead.Location;
		userot = P2MocapPawn(Pawn).MyHead.Rotation;
		useoffset = Pawn.EyeHeight-8;
	}
	else
	{
		useloc = ViewTarget.Location;
		userot = ViewTarget.Rotation;
		useoffset = 0;
		CalcFirstPersonView(useloc, userot);
	}

	smokeff = spawn(class'PipeSmokeFPS',Pawn,,useloc, userot);
	smokeff.SetDirection(Pawn.Velocity, useoffset);
	smokeff.TintIt(smokecolor);
}

///////////////////////////////////////////////////////////////////////////////
// Generate food crumb effect only in MP so you can see
// when someone is eating to make it feel more fair
///////////////////////////////////////////////////////////////////////////////
function EatingFood()
{
	local vector useloc;
	local rotator userot;
	local coords checkc;

	const FOOD_DIST = 25;

	if(Level.Game == None
		|| !FPSGameInfo(Level.Game).bIsSinglePlayer)
	{
		//mypawnfix
		checkc = Pawn.GetBoneCoords(BONE_HEAD);

		// hacking use of rotation to store velocity
		userot.Pitch = Pawn.Velocity.x;
		userot.Yaw   = Pawn.Velocity.y;
		userot.Roll  = Pawn.Velocity.z;
		useloc = checkc.origin + FOOD_DIST*vector(Pawn.Rotation) + FOOD_DIST*Normal(Pawn.Velocity);
		spawn(class'FoodCrumbMaker',MyPawn,,useloc, userot);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Show a flash of color for when you're hurt by chem infection clouds
///////////////////////////////////////////////////////////////////////////////
function FlashChemHurt()
{
	local ChemHurtEmitter cheme;
	local float useoffset;
	local vector useloc;
	local rotator userot;

	// Generate flashy effect
	if(!bBehindView)
	{
		useloc = ViewTarget.Location;
		userot = ViewTarget.Rotation;
		useoffset = 0;
		CalcFirstPersonView(useloc, userot);
		cheme = spawn(class'ChemHurtEmitter',MyPawn,,useloc, userot);
		cheme.SetDirection(Pawn.Velocity,0);
	}
}

///////////////////////////////////////////////////////////////////////////////
// If he's essentially someone you'd meet out on the street and kill, he's okay.
// Bystanders and cops/military are included, but protestors/osamas/etc aren't
// because in the linear play situations, you'd run into so many streams in a row
// it'd be way too easy to get.
///////////////////////////////////////////////////////////////////////////////
function bool ValidQuickKill(P2Pawn DeadGuy)
{
	return (PoliceController(DeadGuy.Controller) != None || DeadGuy.bInnocent);
}

defaultproperties
	{
	CurrentClothes=class'DudeClothesInv'
	DefaultClothes=class'DudeClothesInv'
	CheatClass=class'P2CheatManager'
	GaryTalking=Sound'GaryDialog.gary_whatchutalkin'
	GarySkins[0]=Texture'ChameleonSkins.Special.Gary'
	GarySkins[1]=Texture'MPSkins.MB__136__Mini_M_Jacket_Pants'
	GarySkins[2]=Texture'MPSkins.MB__137__Mini_M_Jacket_Pants'
	}
