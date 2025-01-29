//=============================================================================
// PersonPawn
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// High-level person stuff.
//
//	History:
//		05/08/02:	NPF	Created. Took most from P2MocapPawn.
//
//=============================================================================
class PersonPawn extends MpPawn
	abstract;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////
// external
var (PawnAttributes)byte	CloseWeaponIndex;	// These two indices determine where to look in BaseEquipment
var (PawnAttributes)byte	FarWeaponIndex;		// for the two weapons to use when determining close and far
												// weapons chosen by WeapChangeDist; Defaults to 0 and 1, but
												// Police override this (to accomodate handcuffs and batons)


// internal
var UrinePourFeeder			FluidSpout;				// Blood(or puke) squirting in heavy volumes from something important

var bool					bGotDefaultInventory;	// Whether this pawn already got its default inventory
var Sound RicHit[2];								// Ricochet noises.
var class<PartDrip>	PeeBody;	// Body effect for pee dripping from me
var class<PartDrip>	GasBody;	// Same for gas

const HEAD_MOVE_Z_UP_BIG_TEMP_VARIABLE	=	5;
const EASY_HEAD_HIT						=	2.5;
const ADJUST_RELATIVE_HEAD_Z			=	-0.8;	// -1.0

// These index into BaseEquipment for the distance-based weapon changing code for NPC's
const CLOSE_WEAPON_INDEX	= 0;
const FAR_WEAPON_INDEX		= 1;

const COP_RUN_MOD			= 0.92;
const NPC_RUN_MOD			= 0.9;

const PEE_BONE				= 'p_bone';

const GLARE_FORWARD			= 70;
const GLARE_UP				= 40;


///////////////////////////////////////////////////////////////////////////////
// Clean up
///////////////////////////////////////////////////////////////////////////////
event Destroyed()
{
	if(FluidSpout != None)
	{
		RemoveFluidSpout();
		FluidSpout.Destroy();
		FluidSpout=None;
	}

	StopPuking();

	Super.Destroyed();
}

///////////////////////////////////////////////////////////////////////////////
// Pawn is possessed by Controller
///////////////////////////////////////////////////////////////////////////////
function PossessedBy(Controller C)
{
	if(C != None)
	{
		if(C.bIsPlayer)
		{
			GroundSpeed = default.GroundSpeed;
			BaseMovementRate = default.BaseMovementRate;
			//log(self$" setting player to default run speeds "$GroundSpeed);
		}
		else if(bAuthorityFigure)
		{
			GroundSpeed = COP_RUN_MOD*default.GroundSpeed;
			BaseMovementRate = COP_RUN_MOD*default.BaseMovementRate;
			//log(self$" setting COP to slower run speeds "$GroundSpeed);
		}
		else
		{
			GroundSpeed = NPC_RUN_MOD*default.GroundSpeed;
			BaseMovementRate = NPC_RUN_MOD*default.BaseMovementRate;
			//log(self$" setting NPC to slower run speeds "$GroundSpeed);
		}
	}

	Super.PossessedBy(C);
}

///////////////////////////////////////////////////////////////////////////////
// Set dialog class
///////////////////////////////////////////////////////////////////////////////
function SetDialogClass()
	{
	// This must be checked for None here. The default properties on Gary or Habib
	// set his voice, then we want to preserve that and not reset it here to a white male.
	if(DialogClass == None)
		{
		if (bIsFemale)
			DialogClass=class'BasePeople.DialogFemale';
		else
			DialogClass=class'BasePeople.DialogMale';
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Setup and destroy head
///////////////////////////////////////////////////////////////////////////////
function SetupHead()
{
	local rotator rot;
	local vector v;

	Super.SetupHead();

	// Create head and attach to body
	if (HeadClass != None)
	{
		if (myHead == None)
		{
			myHead = spawn(HeadClass, self,,Location);
			if (myHead != None)
			{
				// Attach to body
				AttachToBone(myHead, BONE_HEAD);
			}
		}

		if (myHead != None)
		{
			// Setup the head
			myHead.Setup(HeadMesh, HeadSkin, HeadScale, AmbientGlow);

			// Rotate head so it looks right (this is temporary until the editor's
			// animation browser supports attachment sockets)
			rot.Pitch = 0;
			rot.Yaw = -16384;	// -18000 looks better but leaves a gap at back of neck!
			rot.Roll = 16384;
			myHead.SetRelativeRotation(rot);

			// Push the heads down a hair to hide the seam
			v.x = ADJUST_RELATIVE_HEAD_Z;
			v.y = 0;
			v.z = 0;
			myHead.SetRelativeLocation(v);
		}
	}
	else
		Warn("No HeadClass defined for "$self);
}

///////////////////////////////////////////////////////////////////////////////
// Head goes into stasis
///////////////////////////////////////////////////////////////////////////////
function PrepBeforeStasis()
{
	Super.PrepBeforeStasis();
	if(MyHead != None)
		MyHead.bStasis=true;
}
///////////////////////////////////////////////////////////////////////////////
// Head comes out of stasis
///////////////////////////////////////////////////////////////////////////////
function PrepAfterStasis()
{
	Super.PrepAfterStasis();
	if(MyHead != None)
		MyHead.bStasis=false;
}

///////////////////////////////////////////////////////////////////////////////
// If you have a melee/trace-based weapon, set that first as your main weapon
// and then find any distance-based thrown or shot weapons (like a grenade
// or rocket launcher). Then, take the AIRating and set it just under your
// lowest melee/trace-based weapon. Then the AI will pick the melee-trace
// most of the time, and 
///////////////////////////////////////////////////////////////////////////////
function FindSecondaryRangeWeapon()
{
}

///////////////////////////////////////////////////////////////////////////////
// Set to false bGotDefaultInventory in personpawn
///////////////////////////////////////////////////////////////////////////////
function ResetGotDefaultInventory( )
{
	bGotDefaultInventory=false;
}

///////////////////////////////////////////////////////////////////////////////
// Adds all the required equipment and picks out the urethra.
// Do this here so we access to the inventory package for specific things
// like HandsWeapon and UrethraWeapon.
///////////////////////////////////////////////////////////////////////////////
function AddDefaultInventory()
{
	local int i, randpick;
	local Inventory thisinv;
	local P2PowerupInv pinv;
	local P2Weapon p2weap;
	local class<P2Weapon> p2weapclass;
	local int usedam;
	local int Count;

	// Only let this be called once
	if (!bGotDefaultInventory)
	{
		//Log(self$" PersonPawn.AddDefaultInventory() is adding inventory");
		// Everyone gets hands, so add that explicitly here
		thisinv = CreateInventoryByClass(class'Inventory.HandsWeapon');

		// Handle money seperately
		if(MaxMoneyToStart > 0)
		{
			pinv = P2PowerupInv(CreateInventoryByClass(class'Inventory.MoneyInv'));
			pinv.SetAmount(MaxMoneyToStart);
		}

		// Add in the extra stuff now
		for ( i=0; i<BaseEquipment.Length; i++ )
		{
			if (BaseEquipment[i].weaponclass != None)
			{
				//log(self$" base equipment "$i$" weap "$BaseEquipment[i].weaponclass);
				p2weapclass = class<P2Weapon>(BaseEquipment[i].weaponclass);

				// If you're in Liebermode and this is a violent weapon, change
				// it to a weak one (but don't bother the player)
				if(p2weapclass != None
					&& P2GameInfo(Level.Game).InLiebermode()
					&& p2weapclass.default.ViolenceRank >= class'PistolWeapon'.default.ViolenceRank
					&& !bPlayer)
				{
					// If you're a cop, don't let them have their pistols/machine guns
					// (leave them with batons)
					if(class == class'Police')
						BaseEquipment[i].weaponclass = None;
					else // Other people get random melee weapons in their inventories
					{
						randpick = Rand(3);
						switch(randpick)
						{
							case 0:
								BaseEquipment[i].weaponclass = class'BatonWeapon';
								break;
							case 1:
								BaseEquipment[i].weaponclass = class'ShovelWeapon';
								break;
							case 2:
								BaseEquipment[i].weaponclass = class'ShockerWeapon';
								break;
						}
					}
				}
				
				// If you have anything at all
				if(BaseEquipment[i].weaponclass != None)
				{
					// Create the weapon from this base equipment index
					thisinv = CreateInventoryByClass(BaseEquipment[i].weaponclass);

					// Special weapon handling:
					// Keep track of the foot now, because we can't do it below (like the urethra)
					// --it's not added to the inventory list
					// Link up your foot
					if(FootWeapon(thisinv) != None)
					{
						MyFoot = P2Weapon(thisinv);
						MyFoot.GotoState('Idle');
						MyFoot.bJustMade=false;
						if(Controller != None)
							Controller.NotifyAddInventory(MyFoot);
						ClientSetFoot(P2Weapon(thisinv));
					}
				}
			}
		}

		// If you're in heston mode, no matter what, always give them some more random guns
		// (unless you're the player)
		if(P2GameInfo(Level.Game).InHestonMode()
			&& !bPlayer)
		{
			randpick = Rand(3);
			switch(randpick)
			{
				case 0:
					CreateInventoryByClass(class'PistolWeapon');
					break;
				case 1:
					CreateInventoryByClass(class'ShotgunWeapon');
					break;
				case 2:
					CreateInventoryByClass(class'MachinegunWeapon');
					break;
			}
			// And bump them up to be ready to fight
			if(PainThreshold < 1.0)
				PainThreshold = 1.0;
			if(Cajones < 1.0)
				Cajones = 1.0;
		}

		// If you're in Insane-o mode, no matter what, always give them some more random guns
		// (unless you're the player) (but give them more than heston)
		if(P2GameInfo(Level.Game).InInsaneMode()
			&& !bPlayer)
		{
			randpick = Rand(6);
			switch(randpick)
			{
				case 0:
					CreateInventoryByClass(class'PistolWeapon');
					break;
				case 1:
					CreateInventoryByClass(class'ShotgunWeapon');
					break;
				case 2:
					CreateInventoryByClass(class'MachinegunWeapon');
					break;
				case 3:
					CreateInventoryByClass(class'GrenadeWeapon');
					break;
				case 4:
					CreateInventoryByClass(class'MolotovWeapon');
					break;
				case 5:
					CreateInventoryByClass(class'ScissorsWeapon');
					break;
				case 6:
					CreateInventoryByClass(class'LauncherWeapon');
					break;
				case 7:
					CreateInventoryByClass(class'NapalmWeapon');
					break;
			}
			// And bump them up to be ready to fight
			if(PainThreshold < 1.0)
				PainThreshold = 1.0;
			if(Cajones < 1.0)
				Cajones = 1.0;
		}

		// tell the weapons they've been made now
		thisinv = Inventory;
		while(thisinv != None)
		{
			if(P2Weapon(thisinv) != None)
			{
				// After the creation of the weapon, while  normal weapons link up their ammo, 
				// we wait and finally link up the urethra. Don't do it above, during the creation
				// of the weapon, it must wait till here.
				if(UrethraWeapon(thisinv) != None)
				{
					MyUrethra = Weapon(thisinv);
					MyUrethra.GiveAmmo(self);
					ClientSetUrethra(P2Weapon(thisinv));
				}

				P2Weapon(thisinv).bJustMade=false;
			}
			thisinv = thisinv.inventory;
			Count++;
			if (Count > 5000)
				break;
		}

		// Switch them as a default, to use their hands
		if(PersonController(Controller) != None)
			PersonController(Controller).SwitchToThisWeapon(StartWeapon_Group, StartWeapon_Offset);

		// If you're using distance-based weapon changing, then save the weapons to use
		if(WeapChangeDist > 0)
		{
			if(BaseEquipment.Length >= 2)
			{
				if(BaseEquipment[CloseWeaponIndex].weaponclass != None)
					CloseWeap = class<P2Weapon>(BaseEquipment[CloseWeaponIndex].weaponclass);
				if(CloseWeap == None)
					log(self$" ERROR: WeapChangeDist and Close weapon is invalid!");

				if(BaseEquipment[FarWeaponIndex].weaponclass != None)
					FarWeap = class<P2Weapon>(BaseEquipment[FarWeaponIndex].weaponclass);
				if(FarWeap == None)
					log(self$" ERROR: WeapChangeDist and Far weapon is invalid!");
			}
			else
			{
				log(self$" ERROR: WeapChangeDist set with only 1 weapon!");
				WeapChangeDist = 0;
			}
		}

		// Note that we got our default inventory
		bGotDefaultInventory = true;

		//log(self$" in they hate me: "$P2GameInfo(Level.Game).TheyHateMeMode()$" game diff "$P2GameInfo(Level.Game).GameDifficulty);
		// If you're in They Hate Me mode, make everyone hate the player.
		// Do this at the end, so we don't retry to do this whole function again in
		// the new Possess, should redo our controller (below)
		if(P2GameInfo(Level.Game).TheyHateMeMode()
			&& !bPlayer)
		{
			// Leave innocents and cashiers alone. Hostiles get
			// made more hostile.
			if(bHasViolentWeapon)
			{
				bPlayerIsEnemy=true;
				bPlayerIsFriend=false;
				// And bump them up to be ready to fight, if they have a weapon
				if(PainThreshold < 1.0)
					PainThreshold = 1.0;
				if(Cajones < 1.0)
					Cajones = 1.0;

				if(CashierController(Controller) == None)
				{
					// If you were a Cop/Military, then turn into a cop-like bystander
					// so you don't try arrests or anything like that.
					if(Controller.IsA('PoliceController')
						|| Controller.IsA('RWSController')
						|| Controller.IsA('RedneckController')
						|| Controller.IsA('KumquatController'))
					{
						Controller.Destroy();
						Controller = None;
						Controller = spawn(class'BystanderController');
						if(Controller != None )
						{
							Controller.Possess(self);
							AIController(Controller).Skill += SkillModifier;
							CheckForAIScript();
						}
					}
				}
			}
		}

		// Make sure *un-armed* bystanders take one pistol bullet if you hit them exactly in the middle
		if(!bHasViolentWeapon
			&& bInnocent)
		{
			// Calculate pistol damage for one hit kills.
			usedam = class'PistolBulletAmmoInv'.default.DamageAmount*class'Dude'.default.DamageMult - 1;
			//log(self$" new health "$usedam);
			HealthMax = usedam;
			Health = HealthMax;
		}
		//log(self$" initting for new level, game info diff "$P2GameInfoSingle(Level.Game).GameDifficulty$" game state diff "$P2GameInfoSingle(Level.Game).TheGameState.GameDifficulty$" GET game state diff "$P2GameInfoSingle(Level.Game).GetGameDifficulty());
	}
	//else
	//{
	//	Log(self$" PersonPawn.AddDefaultInventory() is being bypassed because inventory was added already");
	//}
}

///////////////////////////////////////////////////////////////////////////////
// Allocate spawner money here, because we have access to the class
///////////////////////////////////////////////////////////////////////////////
function InitBySpawner(PawnSpawner initsp)
{
	local P2PowerupInv pinv;

	Super.InitBySpawner(initsp);

	// Handle money seperately
	if(MaxMoneyToStart > 0)
	{
		pinv = P2PowerupInv(CreateInventoryByClass(class'Inventory.MoneyInv'));
		pinv.SetAmount(MaxMoneyToStart);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Set the mood, which determines how various actions are performed.
//
// The amount is between 0.0 to 1.0 and is used by some of the mood-based
// to further refine the responses.  Most functionality is based purely on
// the specified mood, completely ignoring the amount.
///////////////////////////////////////////////////////////////////////////////
function SetMood(EMood moodNew, float amount)
{
	Super.SetMood(moodNew, amount);

	if(MyHead != None)
		Head(MyHead).SetMood(moodNew, amount);
}

///////////////////////////////////////////////////////////////////////////////
//	You will now puke
// More complicated than a normal play animation, it triggers the animation
// but also creates the puking effect. This function is usually called by the
// controller.
///////////////////////////////////////////////////////////////////////////////
function StartPuking(int newpuketype)
{
	Super.StartPuking(newpuketype);
	PlayAnim(GetAnimPuke(), 1.0);
}

///////////////////////////////////////////////////////////////////////////////
// For the love of all that's good and holy, please just stop puking...
// Tells the head to stop the puking.
///////////////////////////////////////////////////////////////////////////////
function StopPuking()
{
	if(MyHead != None)
	{
		Head(MyHead).StopPuking();
	}
}

simulated function Notify_StartPuking()
{
	if(MyHead != None)
	{
		Head(MyHead).StartPuking(PukeType);

		// tell controller you started actually spewing chunks
		if(PersonController(Controller) != None)
			PersonController(Controller).ActuallyPuking();
	}
}
simulated function Notify_StopPuking()
{
	StopPuking();
}

///////////////////////////////////////////////////////////////////////////////
// GetGonorrhea
// You've contracted gonorrhea
///////////////////////////////////////////////////////////////////////////////
function bool ContractGonorrhea()
{
	local UrethraWeapon myu;

	myu = UrethraWeapon(MyUrethra);

	if(myu!= None)
	{
		//myu.MakeInfected();
		return true;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// CureGonorrhea
// You've fixed your gonorrhea
///////////////////////////////////////////////////////////////////////////////
function bool CureGonorrhea()
{
	local UrethraWeapon myu;
	local P2Player p2p;

	myu = UrethraWeapon(MyUrethra);

	if(myu!= None)
	{
		p2p = P2Player(Controller);
		if(p2p != None)
			// probably say he feels better
			p2p.NotifyCuredGonorrhea();

		// actually fix it
		myu.MakeCured();
		return true;
	}
	// we didn't need to be fixed.
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// You've got a vd if true
///////////////////////////////////////////////////////////////////////////////
function bool UrethraIsInfected()
{
	if(MyUrethra != None)
	{
		return (GonorrheaAmmoInv(MyUrethra.AmmoType) != None);
	}
	return false;
}


///////////////////////////////////////////////////////////////////////////////
// My head says I'm still talking
///////////////////////////////////////////////////////////////////////////////
function bool IsTalking()
{
	if(MyHead != None
		&& Head(MyHead).bKillTalk)
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Say the specified line of dialog and animate face appropriately.
// Returns the duration of the specified line.
///////////////////////////////////////////////////////////////////////////////
function float Say(out P2Dialog.SLine line, optional bool bImportant,
				   optional bool bIndexValid, optional int SpecIndex)
	{
	local float duration;
	// Let super class handle audio
	duration = Super.Say(line, bImportant, bIndexValid, SpecIndex);

	// Tell head to talk (no lip sync for now)
	if(MyHead != None)
	{
		if(Mood == MOOD_Combat
			|| Mood == MOOD_Angry)
			Head(myHead).Yell(duration);
		else
			Head(myHead).Talk(duration);
	}

	return duration;
	}

///////////////////////////////////////////////////////////////////////////////
// Decide on a prize for a quick kill
///////////////////////////////////////////////////////////////////////////////
function PickQuickKillPrize(int KillIndex)
{
	local class<Inventory> invclass;
	local Inventory newone;

	switch(KillIndex)
	{
		case 0:
			invclass = class'MoneyInv';
		break;
		case 1:
			invclass = class'DonutInv';
		break;
		case 2:
			invclass = class'PizzaInv';
		break;
		case 3:
			invclass = class'FastFoodInv';
		break;
		case 4:
			invclass = class'KevlarInv';
		break;
		case 5:
			invclass = class'CrackInv';
		break;
		case 6:
			invclass = class'CatnipInv';
		break;
	}
	newone = spawn(invclass, self);
	TossThisInventory(vector(Rotation), newone);
}	

///////////////////////////////////////////////////////////////////////////////
// Spit and make a sound
///////////////////////////////////////////////////////////////////////////////
function float DisgustedSpitting(out P2Dialog.SLine line)
{
	local float duration;

	// Let super class handle audio
	duration = Super.DisgustedSpitting(line);

	// Tell head to talk (no lip sync for now)
	if(MyHead != None)
		Head(myHead).DisgustedSpitting(duration);

	return duration;
}

///////////////////////////////////////////////////////////////////////////////
// Perform protesting motion
///////////////////////////////////////////////////////////////////////////////
function SetProtesting(bool bSet)
{
	if(bProtesting != bSet)
	{
		Super.SetProtesting(bSet);
		// If we're starting to protest, turn on the talking
		if(bSet)
				// Sending in -1 here so we can have manual control over when 
				// to call Timer to stop the talking.
			Head(MyHead).SetChant(true);//Talk(-1);
		else	// If we're stopping talking, then turn off the talking
			Head(MyHead).SetChant(false);//Timer();
	}
}

///////////////////////////////////////////////////////////////////////////////
// called externally by the blood spout
///////////////////////////////////////////////////////////////////////////////
function RemoveFluidSpout()
{
	FluidSpout.ToggleFlow(0, false);
	//DetachFromBone(FluidSpout);
}

///////////////////////////////////////////////////////////////////////////////
// Make body drip with a given fluid effect
///////////////////////////////////////////////////////////////////////////////
function MakeDrip(Fluid.FluidTypeEnum ftype, vector HitLocation)
{
	local float ZDist;
	local class<PartDrip> useclass;

	// Only do this if you're not crouching or deathcrawling
	if(!bIsCrouched
		&& !bIsDeathCrawling
		&& !bIsCowering)
	{
		// Figure out if we're doing the body with this or the head
		if(MyHead != None
			&& CheckHeadForHit(HitLocation, ZDist))
		{
			// Find what fluid hit you
			if(ftype == FLUID_TYPE_Urine)
				useclass = class'UrineHeadDrip';
			else if(ftype == FLUID_TYPE_Gas)
					useclass = class'GasHeadDrip';

			// Only allow those fluids from above
			if(useclass != None)
			{
				Head(MyHead).MakeDrip(useclass);
			}
		}
		else
		{
			// Find what fluid hit you
			if(ftype == FLUID_TYPE_Urine)
				useclass = PeeBody;
			else if(ftype == FLUID_TYPE_Gas)
					useclass = GasBody;

			// Only allow those fluids from above
			if(useclass != None)
			{
				if(BodyDrips != None)
				{
					if(BodyDrips.LifeSpan == 0
						|| BodyDrips.bDeleteMe)
					{
						BodyDrips=None;
					}
					else if(BodyDrips.class != useclass)
					{
						// get rid of the previous emitter slowly
						BodyDrips.SlowlyDestroy();
						BodyDrips=None;
					}
				}

				if(BodyDrips == None)
				{
					BodyDrips = spawn(useclass,self,,Location);
					if(BodyDrips != None)
						BodyDrips.SetBase(self);
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// You're head has fluids dripping of it
///////////////////////////////////////////////////////////////////////////////
function bool HeadIsDripping()
{
	if(Head(MyHead).HeadDrips != None
		&& Head(MyHead).HeadDrips.LifeSpan > 0)
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Stop the dripping
///////////////////////////////////////////////////////////////////////////////
function WipeHead()
{
	Head(MyHead).StopDripping();
}

///////////////////////////////////////////////////////////////////////////////
// Something's happening (like a crouch our puke) where we need to stop all the
// dripping (body and head)
///////////////////////////////////////////////////////////////////////////////
simulated function StopAllDripping()
{
	if(MyHead != None)
		Head(MyHead).StopDripping();

	if(BodyDrips != None)
	{
		// get rid of the previous emitter slowly
		BodyDrips.SlowlyDestroy();
		BodyDrips=None;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Controller is requesting that pawn crouch
///////////////////////////////////////////////////////////////////////////////
function ShouldCrouch(bool Crouch)
{
	Super.ShouldCrouch(Crouch);
	// Make sure when you crouch you make you're head and body dripping stop
	if(bWantsToCrouch)
	{
		StopAllDripping();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Perform death crawl
///////////////////////////////////////////////////////////////////////////////
event StartDeathCrawl(float HeightAdjust)
{
	Super.StartDeathCrawl(HeightAdjust);

	// Make sure when you're down you make you're head and body dripping stop
	if(bIsDeathCrawling)
		StopAllDripping();
}

///////////////////////////////////////////////////////////////////////////////
// Start crouching
///////////////////////////////////////////////////////////////////////////////
event StartCrouch(float HeightAdjust)
	{
	Super.StartCrouch(HeightAdjust);
	// Make sure when you're down you make you're head and body dripping stop
	if(bIsCowering)
		StopAllDripping();
	}

///////////////////////////////////////////////////////////////////////////////
// Simply remove it, but don't destroy it
///////////////////////////////////////////////////////////////////////////////
simulated function DissociateHead(bool bDestroyHead)
{
	if(myHead != None)
	{
		DestroyHeadBoltons();
		Head(myHead).myBody = None;
		// Set in P2Pawn that you've lost your head
		bHasHead=false;

		if (bDestroyHead)
			myHead.Destroy();
		myHead = None;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Detonate head
///////////////////////////////////////////////////////////////////////////////
function ExplodeHead(vector HitLocation, vector Momentum)
{
	local int i, BloodDrips;

	Super.ExplodeHead(HitLocation, Momentum);

	Head(MyHead).PinataStyleExplodeEffects(HitLocation, Momentum);

	BloodDrips = FRand()*4;
	for(i=0; i<BloodDrips; i++)
		DripBloodOnGround(Momentum);

	// Simply don't put spouts in MP.
	if(FluidSpout == None
		&& Level.Game != None
		&& Level.Game.bIsSinglePlayer)
	{
		// If we're puking at the time our head goes away, then
		// keep puke going out the neckhole
		if(Head(MyHead).PukeStream != None)
		{
			FluidSpout = spawn(class'PukePourFeeder',self,,Location);
			// Make it the same type of puke
			FluidSpout.SetFluidType(Head(MyHead).PukeStream.MyType);
		}
		else if(P2GameInfo(Level.Game).AllowBloodSpouts())
			// If our head is removed while not puking, then make blood squirt out
		{
			FluidSpout = spawn(class'BloodSpoutFeeder',self,,Location);
		}

		if(FluidSpout != None)
		{
			FluidSpout.MyOwner = self;
			FluidSpout.SetStartSpeeds(100, 10.0);
			AttachToBone(FluidSpout, BONE_NECK);
			SnapSpout(true);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//	Check the head for collision here
//	Use bEasyHit for a bigger area to collide with the heads, resulting in a
//  more likely hit.
///////////////////////////////////////////////////////////////////////////////
function bool CheckHeadForHit(vector HitLocation, out float ZDist, optional bool bEasyHit)
{
	local float userad;

	// No head, no hit
	if(MyHead == None)
		return false;

	if(bEasyHit)
		userad = EASY_HEAD_HIT*MyHead.CollisionHeight;
	else
		userad = MyHead.CollisionHeight;

	// The goofy constant on the end compensates for the fact that the heads
	// center at the base of the neck, so the collision cylinder is weird on them,
	// it's too low.
	ZDist = HitLocation.z - (MyHead.Location.z + HEAD_MOVE_Z_UP_BIG_TEMP_VARIABLE);
	if(ZDist > -userad)
		return true;
	else
		return false;
}

///////////////////////////////////////////////////////////////////////////////
// Dust like effects for a hit impact
///////////////////////////////////////////////////////////////////////////////
function DustHit(vector HitLocation, vector Momentum)
{
	if(!bReceivedHeadShot)
		spawn(class'DustHitPuff',self,,HitLocation);
	else// Do a special effect if you hit them in the head so they
		// can see they did well
		spawn(class'DustHeadShotPuff',self,,HitLocation);
}

///////////////////////////////////////////////////////////////////////////////
// Spark effects for a hit impact
///////////////////////////////////////////////////////////////////////////////
function SparkHit(vector HitLocation, vector Momentum, byte PlayRicochet)
{
	local SparkHitMachineGun spark1;

	spark1 = Spawn(class'Fx.SparkHitMachineGun',,,HitLocation);
	spark1.FitToNormal(-Normal(Momentum));
	if(PlayRicochet > 0)
		spark1.PlaySound(RicHit[Rand(ArrayCount(RicHit))],,,,,GetRandPitch());
}

///////////////////////////////////////////////////////////////////////////////
// Electrical effects--only in MP (handled differently in SP)
///////////////////////////////////////////////////////////////////////////////
function ElectricalHit()
{
	spawn(class'ShockerPawnLightningMP',self,,Location);
}

///////////////////////////////////////////////////////////////////////////////
//	poke a whole in the head
///////////////////////////////////////////////////////////////////////////////
function PunctureHead(vector HitLocation, vector Momentum)
{
	local PuncturedHeadEffects headeffects;
	local vector startoff;

	Super.PunctureHead(HitLocation, Momentum);

	// Sometimes just puff blood mist
	if(FRand() <= 0.5)
	{
		// Make some blood mist where it hit
		headeffects = spawn(class'PuncturedHeadEffects',,,HitLocation);
		headeffects.SetRelativeMotion(Momentum, Velocity);
	}
	else	// sometimes shoot out gouts of blood
	{
		if(FluidSpout == None
			&& P2GameInfo(Level.Game).AllowBloodSpouts())
		{
			FluidSpout = spawn(class'BloodSpoutFeeder',self,,Location);
			FluidSpout.MyOwner = self;
			// Try to factor in some extra rotation based on hit speed
			startoff.x = -FRand()*Momentum.x;
			startoff.y = -FRand()*Momentum.y;
			FluidSpout.SetStartSpeeds(100, 10.0, startoff);
			AttachToBone(FluidSpout, BONE_HEAD);
			SnapSpout(true);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//	Decapitate the head and send it flying.
///////////////////////////////////////////////////////////////////////////////
function PopOffHead(vector HitLocation, vector Momentum)
{
	local PoppedHeadEffects headeffects;
	local P2Emitter HeadBloodTrail;			// Blood trail I drip if I'm detached.

	Super.PopOffHead(HitLocation, Momentum);

	// Create blood from neck hole
	if(FluidSpout == None
		&& P2GameInfo(Level.Game).AllowBloodSpouts())
	{
		// If we're puking at the time our head goes away, then
		// keep puke going out the neckhole
		if(Head(MyHead).PukeStream != None)
		{
			FluidSpout = spawn(class'PukePourFeeder',self,,Location);
			// Make it the same type of puke
			FluidSpout.SetFluidType(Head(MyHead).PukeStream.MyType);
		}
		else// If our head is removed while not puking, then make blood squirt out
			FluidSpout = spawn(class'BloodSpoutFeeder',self,,Location);

		FluidSpout.MyOwner = self;
		FluidSpout.SetStartSpeeds(100, 10.0);
		AttachToBone(FluidSpout, BONE_HEAD);
		SnapSpout(true);
	}

	// Pop off the head
	DetachFromBone(MyHead);

	// Get it ready to fly
	Head(MyHead).StopPuking();
	Head(MyHead).StopDripping();
	MyHead.SetupAfterDetach();
	// Make a blood drip effect come out of the head
	HeadBloodTrail = Spawn(class'BloodChunksDripping ',self);
	HeadBloodTrail.Emitters[0].RespawnDeadParticles=false;
	HeadBloodTrail.SetBase(self);

	MyHead.GotoState('Dead');

	// Send it flying
	MyHead.GiveMomentum(Momentum);

	// Make some blood mist where it hit
	headeffects = spawn(class'PoppedHeadEffects',,,HitLocation);
	headeffects.SetRelativeMotion(Momentum, Velocity);

	//Remove connection to head but don't destroy it
	DissociateHead(false);
}

///////////////////////////////////////////////////////////////////////////////
// Flick the eyes left or right
///////////////////////////////////////////////////////////////////////////////
simulated function PlayEyesLookLeftAnim(float fRate, float BlendFactor)
{
	if(MyHead != None)
		Head(MyHead).PlayLookLeft(fRate, BlendFactor);
}
simulated function PlayEyesLookRightAnim(float fRate, float BlendFactor)
{
	if(MyHead != None)
		Head(MyHead).PlayLookRight(fRate, BlendFactor);
}

///////////////////////////////////////////////////////////////////////////////
// Make it pour out the correct direction
///////////////////////////////////////////////////////////////////////////////
function SnapSpout(optional bool bInitArc)
{
	local vector startpos, X,Y,Z;
	local vector forward;
	local coords checkcoords;

	checkcoords = GetBoneCoords(BONE_NECK);
	FluidSpout.SetLocation(checkcoords.Origin);
	FluidSpout.SetDir(checkcoords.Origin, checkcoords.XAxis,,bInitArc);
}

///////////////////////////////////////////////////////////////////////////////
// Update the blood spout
///////////////////////////////////////////////////////////////////////////////
simulated function Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);

	// continuously update the stream if we have one
	if(FluidSpout != None)
		SnapSpout();
}
///////////////////////////////////////////////////////////////////////////////
// Make some glare from my sniper rifle
/////////////////////////////////////////////////////////////////////////////// 
//simulated 
function MakeSniperGlare()
{
	local vector useloc;

	useloc = Location;
	useloc += GLARE_FORWARD*vector(Rotation);
	useloc.z += GLARE_UP;
	// try to attach it to the weapon in third person because in MP nothing
	// sticks to anything very well
	spawn(class'RifleScopeGlare',Weapon.ThirdPersonActor,,useloc);
}
///////////////////////////////////////////////////////////////////////////////
// Move blood pool to where you are, attach, when this is called
///////////////////////////////////////////////////////////////////////////////
function AttachBloodEffectsWhenDead()
{
	// Check to make blood pool below us.
	// See if we already have blood squrting out of us in some other spot first
	// --if so, don't make this
	if(ClassIsChildOf(DyingDamageType, class'BloodMakingDamage')
		&& bloodpool == None
		&& FluidSpout == None
		&& (P2GameInfo(Level.Game) == None
			|| (class'P2Player'.static.BloodMode()
				&& P2GameInfo(Level.Game).AllowBloodSpouts())))
	{
//		bloodpool = spawn(class'Fx.BloodBodyFeeder',self,,Location);
		bloodpool =  spawn(class'BloodBodyFeeder',self,,Location);
		AttachToBone(bloodpool, BONE_PELVIS);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Pee pants, no visible stream, but pee forms below you
///////////////////////////////////////////////////////////////////////////////
function PeePants()
{
	if(PeePool == None
		&& !bHasPeed)
	{
		PeePool =  spawn(class'UrineBodyFeeder',self,,Location);
		AttachToBone(PeePool, BONE_PELVIS);
		bHasPeed=true;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Stop peeing your pants--turn off the feeder
///////////////////////////////////////////////////////////////////////////////
function StopPeeingPants()
{
	if(PeePool != None)
	{
		DetachFromBone(PeePool);
		PeePool.Destroy();
		PeePool = None;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Record pawn dead, if player killed them
///////////////////////////////////////////////////////////////////////////////
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if(P2GameInfoSingle(Level.Game) != None
		&& P2GameInfoSingle(Level.Game).TheGameState != None
		&& Killer != None
		&& Killer.bIsPlayer)
	{
		// Record him as a person dying.
		P2GameInfoSingle(Level.Game).TheGameState.PeopleKilled++;

		if(Police(self) != None)
		{
			// If he was a cop, record that too
			P2GameInfoSingle(Level.Game).TheGameState.CopsKilled++;
		}
		// If you killed him with fire, record that too
		if(ClassIsChildOf(damageType, class'BurnedDamage')
			|| ClassIsChildOf(damageType, class'OnFireDamage'))
		{
			P2GameInfoSingle(Level.Game).TheGameState.PeopleRoasted++;
		}
	}

	Super.Died(Killer, damageType, HitLocation);
}

///////////////////////////////////////////////////////////////////////////////
// Destroy the ragdoll
///////////////////////////////////////////////////////////////////////////////
event KExcessiveJointError()
{
	ChunkUp(0);
}

///////////////////////////////////////////////////////////////////////////////
// blow up into little pieces (implemented in subclass)		
///////////////////////////////////////////////////////////////////////////////
simulated function ChunkUp(int Damage)
{
	local PawnExplosion exp;

	bChunkedUp=true;

	if ( Controller != None )
	{
		if ( Controller.bIsPlayer )
			Controller.PawnDied(self);
		else
		{
			Controller.Destroy();
			Controller = None;
		}
	}

	// Make big blood splat if we can
	if(class'P2Player'.static.BloodMode())
	{
		exp = spawn(class'PawnExplosion',,,Location);
		exp.FitToNormal(vect(0, 0, 1));
	}
	else // dust if we're lame
		DustHit(Location, Velocity);

	// Get rid of me nicely
	Destroy();
}

///////////////////////////////////////////////////////////////////////////////
// Take damage (pawn call) but also save who attacked me
///////////////////////////////////////////////////////////////////////////////
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType)
{
	if(!ClassIsChildOf(damageType, class'BurnedDamage')
		&& !ClassIsChildOf(damageType, class'ExplodedDamage')
		&& damageType != class'CrackSmokingDamage'
		&& damageType != class'GonorrheaDamage')
		bCrotchHit = WasCrotchHit(HitLocation, Momentum);
	else
		bCrotchHit=false;

	// Check for a hurt urethra
	if(Damage > 0
		&& UrethraWeapon(Weapon) != None
		&& ClassIsChildOf(DamageType, class'BloodMakingDamage')
		&& bCrotchHit)
			UrethraWeapon(Weapon).MakeBloodied();

	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);
}

///////////////////////////////////////////////////////////////////////////////
// Make sure the censored bar for the 
///////////////////////////////////////////////////////////////////////////////
function name GetWeaponBoneFor(Inventory I)
	{
	if(UrethraWeapon(I) != None)
		return PEE_BONE;
	else
		return Super.GetWeaponBoneFor(I);
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function ClientStartRocketBeeping(Projectile ThisRocket)
{
	if(Level.NetMode != NM_DedicatedServer)
		spawn(class'RocketBeeper',Owner);
}

///////////////////////////////////////////////////////////////////////////////
// ReduceArmor
// Take away some armor
///////////////////////////////////////////////////////////////////////////////
function ReduceArmor(float ArmorDamage, Vector HitLocation)
{
	Super.ReduceArmor(ArmorDamage, HitLocation);

	if(ArmorDamage > 0
		&& P2Player(Controller) != None
		&& (Level.Game == None
			|| !Level.Game.bIsSinglePlayer))
	{
		//  Make some effects to show the kevlar being eaten away
		spawn(class<KevlarInv>(P2Player(Controller).HudArmorClass).default.EffectClass,self,,HitLocation);
	}
}

///////////////////////////////////////////////////////////////////////////////
// When you're dead, check to quickly add kevlar to your inventory, to
// have it dropped by you
///////////////////////////////////////////////////////////////////////////////
function DropArmorDead()
{
	local KevlarInv kinv;

	// Add in armor to be dropped, if you have it
	if(Armor > 0)
	{
		if(P2Player(Controller) != None)
			kinv = KevlarInv(CreateInventoryByClass(P2Player(Controller).HudArmorClass));
		else
			kinv = KevlarInv(CreateInventory("Inventory.KevlarInv"));
		kinv.ArmorAmount = Armor;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	HeadClass=class'Head'
	CloseWeaponIndex=0
	FarWeaponIndex=1
	RicHit[0]=Sound'WeaponSounds.bullet_ricochet1'
	RicHit[1]=Sound'WeaponSounds.bullet_ricochet2'
	PeeBody=class'UrineBodyDrip'
	GasBody=class'GasBodyDrip'
	HandsClass=class'Inventory.HandsWeapon'
	}
