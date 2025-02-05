///////////////////////////////////////////////////////////////////////////////
// GameState.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Special inventory item that stores persistent game information.
//
// History:
//	07/09/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
//
// GOALS
//
// We want our game to seem like one large world that just happens to be made
// up of many levels that are linked together.  In order to make that happen,
// we need some key new features:
//
//	1. Keep track of overall game state
//	2. Make certain objects persistent
//	3. Make nearby pawns teleport with the player
//
// Underlying all of these is the need for a way to persist information from
// one level to the next.
//
//
// BACKGROUND
//
// The Unreal Engine is entirely level-based.  Nothing persists from one level
// to the next.  One might think the GameInfo object would persist throughout
// an entire game, but one would be wrong.  Each time you load a new level all
// the objects are created from scratch.  The only exception is the player
// pawn and it's inventory items (see below for details).
//
// So if you pick up an object and drop it somewhere else in the same level,
// it will, of course, stay there until someone moves it again.  But if you
// go to another level and then come back, the object will have moved back to
// it's original location because the engine simply reloads the original map
// whenever you go to a level.
//
// The engine is severely limited when it comes to moving objects from one
// level to another.  It looks for all PlayerControllers in the old level and
// for each one it takes only the pawn and its inventory items and brings them
// to the new level.  Nothing else, not even the PlayerControllers themselves,
// are brought to the new level.
//
// Note: We considered modifying the engine so it could travel more types of
// actors but after looking at the code and talking to epic about it, we
// determined it was too complicated and dropped the idea.
//
// So that's what we have to work with.
//
//
// SOLUTION
//
// Since the only thing that persists from level to level is the player pawn
// and its inventory items, we created a special inventory item called
// GameState to hold all the information we want to preserve across levels.
//
// P2GameInfoSingle is the keeper of the GameState.  All queries and changes
// to it are done through P2GameInfoSingle.
//
// P2GameInfoSingle.SendPlayerTo() is called just before the player travels
// and P2GameInfoSingle.PostTravel() is called after he has traveled to a new
// level.  PostTravel() is also called when a new game starts because the
// engine handles it as if the player teleported into the level.
//
// In P2GameInfoSingle.PostTravel() we check whether the player has a GameState
// in his inventory.  If he does, we take it out of his inventory and use it
// since it contains whatever was persisted in it from the last level.  If he
// doesn't, it means this is a new game and we spawn a new GameState.
//
// When the player is about to travel, P2GameInfoSingle.SendPlayerTo() gets a
// chance to add the GameState to the player's inventory so it will travel to
// the next level, where a new P2GameInfoSingle will pull it out, as described
// above.
//
// So that's the foundation on which we build the features listed earlier.
//
///////////////////////////////////////////////////////////////////////////////
class GameState extends FPSGameState;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////


//////////////
// Game statistics start
//////////////
var travel int PeopleKilled;		// total people player killed in game
var travel int CopsKilled;			// total cops player killed in game
var travel int ElephantsKilled;		// total elephants player killed in game
var travel int DogsKilled;			// total dogs player killed in game
var travel int CatsKilled;			// total cats player killed in game (includes ones used on guns)
var travel int PistolHeadShot;		// people that you snuck up behind to get a silent pistol head shot on
var travel int ShotgunHeadShot;		// people you shotgunned in the face, blowing up their heads
var travel int RifleHeadShot;		// people you got a one-shot rifle kill on
var travel int CatsUsed;			// cats you violated with your gun
var travel int MoneySpent;			// money the player spent
var travel int PeeTotal;			// 'gallons' of piss you peed. (divide by 10-ish)
var travel int DoorsKicked;			// number of times you kicked a door in a game
var travel int TimesArrested;		// number of times you've been arrested
var travel int DressedAsCop;		// number of times you impersonated a cop (dressed like him)
var travel int DogsTrained;			// number of dogs (non-unique) you trained
var travel int PeopleRoasted;		// number of people killed by fire
var travel int CopsLuredByDonuts;	// Number of cops you've lured by dropping donuts

//Ranking! either a name or a summary, Jesus..pansy.. murderer... Satan

//////////////
// Game statistics end
//////////////

// Data for persistent pawns
var array<PersistentPawnInfo> PawnsArr;

// Data for persistent weapons (P2WeaponPickups)
var array<PersistentWeaponInfo>	WeaponsArr;

// Data for persistent pickups (P2PowerupPickups)
var array<PersistentPowerupInfo>	PowerupsArr;

// Data for teleporting pawns with player
var travel array<TeleportedPawnInfo> TeleportedPawns;

// Simple struct for specifying an errand
struct SErrand
	{
	var int Day;
	var int Errand;
	};

// Data regarding completed errands
var travel array<SErrand> CompletedErrands;

// Data regarding activated errands (activated during gameplay, not by default)
var travel array<SErrand> ActivatedErrands;

// Data regarding revealed errands
var travel array<SErrand> RevealedErrands;

// Data regarding revealed hate groups
struct SHater
	{
	var name ClassName;
	var name DesTex;
	var name PicTex;
	var name Comment;
	var byte Revealed;	// bools don't work in arrays, use byte instead
	};
var travel array<SHater> CurrentHaters;

// Flag indicates that new haters have been added to the CurrentHaters list.
// This is currently used to indicate that the map should be shown so the
// player can see the new haters.
var travel bool bAddedNewHaters;

// Current day index
var travel int CurrentDay;

// When this is true we'll change CurrentDay to NextDay as soon as the
// player finishes traveling.  If the day is being changed for debugging
// purposes then the bChangeDayForDebug should be true, too.
var travel bool bChangeDayPostTravel;
var travel bool bChangeDayForDebug;
var travel int NextDay;

// Number of errands completed this day
var travel int ErrandsCompletedToday;

// When this is true it means we're on the first level of a new game.  It
// will remain true until the player changes levels and then it will be
// false for the rest of the game.
var travel bool bFirstLevelOfGame;

// When this is true it means we're on the first level of a new day.  It
// will remain true until the player changes levels and then it will be
// false until the next day starts.
var travel bool bFirstLevelOfDay;

// Keep track of which jail cell the player should go to when he's arrested.
// Note that this starts with 1 so we don't hurt the level designers' heads.
var travel int JailCellNumber;
var travel int LastJailCellNumber;

// Whether the last level exit was real (going to a "real" level as opposed
// to going to a "interior-of-building" level)
var travel bool bLastLevelExitWasReal;

// Whether to show game state info on screen (for debugging)
var travel bool bShowGameInfo;

// Cops in the game can 'communicate' with radios This allows them to all 
// psychically hate the player for a given amount of time. If they hate
// him, they'll probably try to arrest him first then attack if that goes bad. But the
// point is, for as long as this time is above 0, they will probably recoginize
// him on sight.
// This time is in game seconds. This time is always addressed at the player.
var travel float CopRadioTime;

// How much each consecutive encounter with the dude will raise the hate player time
var float CopRadioInc;

// Time in seconds that SetTimer is set for, before CopRadioDec is again removed from
// the CopRadioTime
var float CopRadioTimerInterval;

// How much each Timer reduction of the radio time takes off.
var float CopRadioDec;

// If the radio just started up (was 0), default it to this much time
var float CopRadioBase;

// How high the timer can go
var float CopRadioMax;

// Player has escaped jail or running around in jail. 
// This doesn't travel. It says, within the jail level
// the people in their should hate him if they see him.
// This is for if the player goes breaks out of his cell and the cops see
// him, they should arrest him. Also, if he's in the police department/jail lobby
// and then crosses over into the back of it, this should be set so they'll arrest
// him then too.
var bool bArrestPlayerInJail;

// If the player is (or will be when he arrives in the next level) in a jail cell.
// This should be set when going to jail when you're arrested and cleared when
// the evil player has left that jail level completely. This simply gets cleared
// each time the player is *not* being sent to jail (in a cell). This is only used
// for cops monitoring the player, to know he's in a cell so they handle him acting
// badly differently (like ignoring him having his pants down). bArrestPlayerInJail
// overrides this behavior when he's actually out of the jail cell. Then bust him 
// for doing anything--including just being out of his cell.
var travel bool bPlayerInCell;
// This is set each time the SendPlayerToJail function is called, which in turn
// sets the above bool to travel. If this isn't true, on a level transition, then
// bPlayerInCell is set to false.
var bool bSendingPlayerToJail;

// If this is true, then on the next level startup, most inventory items (except
// things like hands and all) will be taken from the player. Then the powerups and
// weapons with bForTransferOnly will be the pickups that represent the inventory
// items removed from the player. If this is false, then the level is checked
// for any pickups with bForTransferOnly set to true. If they are found, they 
// are destroyed.
// bTakePlayerInventory is then set to false, so this only happens once when set.
var travel bool bTakePlayerInventory;

// True if the player chooses the "nice" version of the dude.  Otherwise,
// he's the "evil bastard" version.
var travel bool bNiceDude;

// There are two seperate groups to remember the last weapon before you peed and used your hands
// because you could theoretically be using the pistol, fast switch to the hands, then decide to
// pee. So it needs to be able to go back to your hands when you unzip your pants, then go back to
// the pistol when you untoggle the 'switch to hands' button.
var travel int LastWeaponGroupPee;		// Last weapon group we had before changing to the urethra.
var travel int LastWeaponOffsetPee;		// specific weapon in the LastWeaponGroupPee we were using
var travel int LastWeaponGroupHands;		// Last weapon group we had before swapping to the hands.
var travel int LastWeaponOffsetHands;		// specific weapon in the LastWeaponGroupHands we were using

// This are the group and offset of the inventory we had last selected before we teleported
var travel int LastSelectedInventoryGroup;
var travel int LastSelectedInventoryOffset;

// How long we still have to keep our cat-speed effects
var travel float CatnipUseTime;

// Type of armor the player had on as he travelled (use it to setup the texture he uses
// for the armor icon in the hud, for the player
var travel class<Inventory> HudArmorClass;

// Keep track of god cheat
var travel bool bCheatGod;
// Enhanced game started
var travel bool bEGameStart;

// When this is true it indicates the game has not yet officially started.  This will be
// true throughout the intro and any other such maps.  Once the game starts, it will be false.
var travel bool bPreGameMode;

// Inventory class of clothes we're wearing.
var travel class<Inventory> CurrentClothes;

// For each day, record all the pickups taken from any level on that day. When each level
// restarts, remove those pickups from that level.
var array<RecordedPickupInfo> GottenPickups;
const MAX_PICKUP_PACKET	=	25;	// Max number of entires into the packet sent with a PickupTravelInv. This can't
// get too big or the array (inside PickupTravelInv) won't travel properly.. 50 is probably too high

// Array of cops that currently have you as their attacker, or are planning on attacking
// you. As long as this array is greater than 0, the cop radio can't go
// away.
var array<FPSPawn> CopsAfterPlayer;

var travel array<int> InactiveInvHints;	// Numbers in here represent the inventory ranking
							// of items that have their hud hints turned off. To be preserved throughout the
							// entire game.

var travel float TimeSinceErrandCheck;// Stored in P2Player--This is how long since the last time the player did something
									// to do with the errands--either he checked the map or went into
									// a place that has to do with errands, or something like that
									// --gets reset after he checks it.
var travel int	 MapReminderCount;	// Stored in P2Player--Number of times you've had to tell him about checking the map
									// before he finally checks--gets reset after he checks it.
var travel bool  bIsApocalypse;		// It's the Apocalypse! If this is set that is.. happens after last errand
									// of Friday. Occurs after next level transition (instead of going home) player
									// must make it all the way back to his house with people in riot mode. Gets
									// set by an Apocalypse trigger.

var travel int	MostRecentGameSlot;	// Remembers the most recent slot

var travel float DemoTime;			// How much longer the demo can be played for (this play session)

var travel bool bGetsHeadShots;		// If true, bullets from the player pistol or machinegun will instantly kill people
									// if they are hit in the head.

var travel int  GameDifficulty;		// New Game difficulty. To be saved with each saved game seperately. Added in the 
									// first patch.

// Names of player after he finishes the game, based on what he did.
var localized string Killed0Ranking;
var localized string Killed1Ranking;
var localized string Killed2Ranking;
var localized string Killed3Ranking;
var localized string Killed4Ranking;
var localized string Killed5Ranking;
var localized string Killed6Ranking;
var localized string Killed7Ranking;
var localized string Killed8Ranking;
var localized string Killed9Ranking;
var localized string Killed10Ranking;
var localized string Killed11Ranking;
var localized string CopKillerRanking;
var localized string AnimalKillerRanking;
var localized string RifleKillerRanking;
var localized string FireKillerRanking;
var localized string PeeRanking;
var localized string CatSexRanking;
var localized string HestonRanking;


const MAX_SPAWN_TRY	=	5;	// Number of times you can fail when trying to spawn a pawn after bringing him
							// through to a new level.

// Ranking of number of people killed in the game, 1 being least people killed, 10 highest
const KILLED_1				=	5;
const KILLED_2				=	50;
const KILLED_3				=	100;
const KILLED_4				=	300;
const KILLED_5				=	600;
const KILLED_6				=	800;
const KILLED_7				=	1000;
const KILLED_8				=	1500;
const KILLED_9				=	2000;
const KILLED_10				=	4000;
const CAT_USED_TOTAL		=	80;


const DifficultyPath		=	"Postal2Game.P2GameInfo GameDifficulty";



///////////////////////////////////////////////////////////////////////////////
// Add persitent pawn to list to remember of who's dead or gone from
// which level
///////////////////////////////////////////////////////////////////////////////
function AddPersistentPawn(FPSPawn newpawn)
{
	local int i;
	local bool bDontAdd;
	
	// Assign this as our original level, if we don't have one already
	if(newpawn.OrigLevelName == "")
		newpawn.OrigLevelName = P2GameInfo(Level.Game).ParseLevelName(Level.GetLocalURL());

	//log(self$" AddPersistentPawn "$newpawn$" in lev "$newpawn.OrigLevelName$" with tag "$newpawn.Tag);
	// If they're already travelling with me, don't add them to this list
	if(newpawn.bTravelledWithPlayer)
		bDontAdd=true;

	if(!bDontAdd)
	{
		// Make sure he's not already in the list
		for(i=0; i<PawnsArr.Length; i++)
		{
			if(PawnsArr[i].Tag == newpawn.Tag
				&& PawnsArr[i].LevelName == newpawn.OrigLevelName)
			{
				bDontAdd=true;
			}
		}
	}

	if(!bDontAdd)
	{
		// Add them to the list to be travel with the player's inventory
		i = PawnsArr.Length;
		PawnsArr.Insert(i, 1);
		PawnsArr[i].LevelName = newpawn.OrigLevelName;
		PawnsArr[i].Tag = newpawn.Tag;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Remove a pawn from the persistent list so he'll show up again in his default
// level. This is for when a dog gets tired of you and you leave him in another
// level, but don't kill him. He should show up again in the original level 
// he was placed in.
///////////////////////////////////////////////////////////////////////////////
function RemovePersistentPawn(FPSPawn newpawn)
{
	local int i;
	local bool bDontAdd;
	
	// Assign this as our original level, if we don't have one already
	if(newpawn.OrigLevelName == "")
		newpawn.OrigLevelName = P2GameInfo(Level.Game).ParseLevelName(Level.GetLocalURL());

	//log(self$" RemovePersistentPawn "$newpawn$" in lev "$newpawn.OrigLevelName$" with tag "$newpawn.Tag$" length "$PawnsArr.Length);
	// Make sure he's there to be removed
	for(i=0; i<PawnsArr.Length; i++)
	{
		if(PawnsArr[i].Tag == newpawn.Tag
			&& PawnsArr[i].LevelName == newpawn.OrigLevelName)
		{
			PawnsArr.Remove(i, 1);
			newpawn.bTravelledWithPlayer=false;	// Undo this because we're almost like we started
												// in this level--just don't reset our original level name.
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Starting a new day should forget several of the persistent lists
// and forget things like crack addiction, catnip time, etc.
///////////////////////////////////////////////////////////////////////////////
function RemovePersistanceForNewDay(P2Pawn PlayerPawn)
{
	// Forget some lists
	GottenPickups.Remove(0, GottenPickups.Length);
	//PowerupsArr.Remove(0,PowerupsArr.Length);
	//WeaponsArr.Remove(0,WeaponsArr.Length);
	PawnsArr.Remove(0,PawnsArr.Length);

	// Forget various values

	// Reset cop radio when you start a new day
	ResetCopRadioTime();	
	// Reset catnip time
	CatnipUseTime=0;
	// Reset crack addiction
	PlayerPawn.CrackAddictionTime=0;

	//log(Self$" resetting heart with this controller "$P2Player(PlayerPawn.Controller));
	if(P2Player(PlayerPawn.Controller) != None)
		P2Player(PlayerPawn.Controller).ResetHeart();
}

///////////////////////////////////////////////////////////////////////////////
// Save objects before a level change
///////////////////////////////////////////////////////////////////////////////
function PreLevelChange(P2Pawn PlayerPawn, String LevelName)
	{
	local int i, j;
	local FPSPawn p;
	local P2WeaponPickup wp;
	local P2PowerupPickup pp;
	local PawnTravelInv pawninv;
	local WeaponTravelInv weaponinv;
	local PowerupTravelInv powerupinv;
	local PickupTravelInv pickupinv;
	local Inventory inv;
	local P2Player p2p;

	// If we're sending him to jail, set that he'll be in a cell
	if(bSendingPlayerToJail)
		bPlayerInCell=true;
	else // If not, then clear that he'll be in a cell
		bPlayerInCell=false;

	// Grab some state info out of the dude and set it in the gamestate
	p2p = P2Player(PlayerPawn.Controller);
	if(p2p != None)
	{
		// Save our toggle weapons
		LastWeaponGroupPee = p2p.LastWeaponGroupPee;
		LastWeaponOffsetPee = p2p.LastWeaponOffsetPee;
		LastWeaponGroupHands = p2p.LastWeaponGroupHands;
		LastWeaponOffsetHands = p2p.LastWeaponOffsetHands;

		// Save the inventory item we have selected now
		if(PlayerPawn.SelectedItem != None)
		{
			LastSelectedInventoryGroup = PlayerPawn.SelectedItem.InventoryGroup;
			LastSelectedInventoryOffset = PlayerPawn.SelectedItem.GroupOffset;
		}
		else
		{
			LastSelectedInventoryGroup = -1;
		}

		// Save our current clothes if we're not going to jail.
		// If we are, just set our clothes to the defaults, so we arrive in jail in our
		// normal clothes, even if we were arrested in cop clothes.
		if(!bPlayerInCell)
			CurrentClothes = p2p.CurrentClothes;
		else
			CurrentClothes = p2p.DefaultClothes;

		// Save the status of your map reminders for the player
		TimeSinceErrandCheck = p2p.TimeSinceErrandCheck;
		MapReminderCount = p2p.MapReminderCount;

		// Remember god mode
		bCheatGod = p2p.bGodMode;

		// Save our catnip time
		CatnipUseTime = p2p.CatnipUseTime;

		// Save our armor class type
		HudArmorClass = p2p.HudArmorClass;
	}

	// Find all persistent dead pawns and save them
	foreach DynamicActors(class 'FPSPawn', p)
		{
		if (p.bPersistent 
			&& p.Health <= 0
			&& p.Tag != 'None')
			{
			// Add them to the player's inventory
			i = PawnsArr.Length;
			PawnsArr.Insert(i, 1);
			// If we have an original name, use it
			if(p.OrigLevelName != "")
				PawnsArr[i].LevelName = p.OrigLevelName;
			else
				PawnsArr[i].LevelName = LevelName;
			PawnsArr[i].Tag = p.Tag;
			}
		}

	// Find all persistent weapon pickups and save them
	foreach DynamicActors(class 'P2WeaponPickup', wp)
		{
		if (wp.bPersistent)
			{
			i = WeaponsArr.Length;
			WeaponsArr.Insert(i, 1);
			WeaponsArr[i].LevelName = LevelName;
			wp.PersistentSave(WeaponsArr[i]);
			}
		}

	// Find all persistent powerup pickups and save them
	foreach DynamicActors(class 'P2PowerupPickup', pp)
		{
		if (pp.bPersistent)
			{
			i = PowerupsArr.Length;
			PowerupsArr.Insert(i, 1);
			PowerupsArr[i].LevelName = LevelName;
			pp.PersistentSave(PowerupsArr[i]);
			}
		}

	// This array is added to level during the game so it doesn't need to be created like above.
	// Move all the info about pickups that have been gotten during a day in the game (in any level)
	// and move it for transfer to the players inventory
	// To just slightly limit the number of inventory items sent with this, each inventory of this
	// type can actually count up a certain number of these pickups and record them in an array.
	// This can't be too long though, because travel only supports a certain amount of data
	// per variables (arrays included)
	if(!bChangeDayPostTravel)
		{
		for(i=0; i< GottenPickups.Length; i++)
			{
			if(pickupinv == None)
				{
				pickupinv = spawn(class'PickupTravelInv');
				j=0;	// reset internal array count
				}
			pickupinv.info.Insert(j, 1);
			pickupinv.info[j]= GottenPickups[i];
			j++;
			// Enough in array packet.. send it to the inventory
			if(j == MAX_PICKUP_PACKET)
				{
				PlayerPawn.AddInventory(pickupinv);
				pickupinv=None;
				}
			}
			// Add any residual pickups that didn't fill an entire packet
			if(pickupinv != None)
				{
				PlayerPawn.AddInventory(pickupinv);
				pickupinv=None;
				}
		}
	else //if(bFirstLevelOfDay)
		// If we're on our way to a new day, then don't readd things, just
		// wipe the array clean.
		{
		log(self$" Prechange Forgetting Persistence");
		RemovePersistanceForNewDay(PlayerPawn);
		}

	// Go through the dynamic arrays in GameState that keep persistent values
	// and transfer those to the player's inventory--for travelling between levels.
	for(i=0; i< PawnsArr.Length; i++)
		{
		pawninv = spawn(class'PawnTravelInv');
		pawninv.info = PawnsArr[i];
		PlayerPawn.AddInventory(pawninv);
		}
	for(i=0; i< WeaponsArr.Length; i++)
		{
		weaponinv = spawn(class'WeaponTravelInv');
		weaponinv.info = WeaponsArr[i];
		PlayerPawn.AddInventory(weaponinv);
		}
	for(i=0; i< PowerupsArr.Length; i++)
		{
		powerupinv = spawn(class'PowerupTravelInv');
		powerupinv.info = PowerupsArr[i];
		PlayerPawn.AddInventory(powerupinv);
		}

		log(self$" Synchronizing and writing new difficulty to ini, was "$P2GameInfo(Level.Game).GameDifficulty$" is now "$GameDifficulty);
		// Use the game difficulty from the game state (this was the saved diff)
		P2GameInfo(Level.Game).GameDifficulty = GameDifficulty;
		// Make sure to write the difficulty to the ini, or it won't be carried to the next
		// level correctly.
		ConsoleCommand("set "@DifficultyPath@P2GameInfo(Level.Game).GameDifficulty);
	}

///////////////////////////////////////////////////////////////////////////////
// Restore objects after a level change
///////////////////////////////////////////////////////////////////////////////
function PostLevelChange(P2Pawn PlayerPawn, String LevelName)
	{
	local int i, j;
	local P2Pawn ppawn;
	local FPSPawn fpawn;
	local Inventory inv, oldinv;
	local P2Player p2p;
	local PickupTravelInv ptinv;

	log(self$" PostLevelChange");
	// Go back through the inventory of the player, and for each inventory
	// item that stored info about persistant objects, remove it
	// and give it back to the gamestate.
	inv = PlayerPawn.Inventory;
	while(inv != None)
	{
		oldinv = inv.Inventory;
		if(PawnTravelInv(inv) != None)
		{
			// Remember the guy we travelled
			i = PawnsArr.Length;
			PawnsArr.Insert(i, 1);
			PawnsArr[i] = PawnTravelInv(inv).info;
			// Now, delete him from our inventory
			PlayerPawn.DeleteInventory(inv);
			inv = PlayerPawn.Inventory;
		}
		else if(WeaponTravelInv(inv) != None)
		{
			i = WeaponsArr.Length;
			WeaponsArr.Insert(i, 1);
			WeaponsArr[i] = WeaponTravelInv(inv).info;
			PlayerPawn.DeleteInventory(inv);
			inv = PlayerPawn.Inventory;
		}
		else if(PowerupTravelInv(inv) != None)
		{
			i = PowerupsArr.Length;
			PowerupsArr.Insert(i, 1);
			PowerupsArr[i] = PowerupTravelInv(inv).info;
			PlayerPawn.DeleteInventory(inv);
			inv = PlayerPawn.Inventory;
		}
		else if(PickupTravelInv(inv) != None)
		{
			ptinv = PickupTravelInv(inv);
			for(j=0; j< ptinv.info.Length; j++)
			{
				i = GottenPickups.Length;
				GottenPickups.Insert(i, 1);
				GottenPickups[i] = ptinv.info[j];
			}
			PlayerPawn.DeleteInventory(inv);
			inv = PlayerPawn.Inventory;
		}
		else
			inv = inv.Inventory;
	}

	// Go through you're current inventory and mark any powerups or weapons mentioned
	// in the Inactive lists as not wanting to show their hints anymore.
	inv = PlayerPawn.Inventory;
	while(inv != None)
	{
		if(P2Weapon(inv) != None)
		{
			if(FoundInvHintInactive(P2Weapon(inv).GetRank()))
				P2Weapon(inv).bAllowHints=false;
		}
		else if(P2PowerupInv(inv) != None)
		{
			if(FoundInvHintInactive(P2PowerupInv(inv).GetRank()))
				P2PowerupInv(inv).bAllowHints=false;
		}

		inv = inv.Inventory;
	}

	// If we're starting a new day, yet somehow gottenpickups magically got filled (through some
	// odd debug level changing) wipe it away
	if(bFirstLevelOfDay)
	{
		log(self$" Postchange Forgetting Persistence");
		RemovePersistanceForNewDay(PlayerPawn);
	}

	// Kill any pawns that are supposed to be dead on this level.
	// Note that we never remove the pawns from the list because they should
	// remain dead for the duration of the game.
	for (i = 0; i < PawnsArr.Length; i++)
		{
		if (PawnsArr[i].LevelName ~= LevelName)
			{
			foreach DynamicActors(class'FPSPawn', fpawn, PawnsArr[i].Tag)
				{
				// Post-release fix: Fixes the terrible 1000000 iteration preppawnslider
				// crash bug. Seems to be because the default pawn code doesn't correctly
				// clean up the controller when it's destroyed. So we explicitly 
				// destroy it now here.
				if(fpawn.Controller != None)
					fpawn.Controller.Destroy();
				// End

				fpawn.Destroy();
				}
			}
		}

	// Restore all persistent weapon pickups that belong on this level.
	// Start at end of array and work towards front to make removals easier/faster.
	for (i = WeaponsArr.Length - 1; i >= 0; i--)
		{
		if (WeaponsArr[i].LevelName ~= LevelName)
			{
			class'P2WeaponPickup'.Static.PersistentRestore(WeaponsArr[i], PlayerPawn.Level);
			WeaponsArr.remove(i, 1);
			}
		}

	// Restore all persistent powerup paickups that belong on this level.
	// Start at end of array and work towards front to make removals easier/faster.
	for (i = PowerupsArr.Length - 1; i >= 0; i--)
		{
		if (PowerupsArr[i].LevelName ~= LevelName)
			{
			class'P2PowerupPickup'.Static.PersistentRestore(PowerupsArr[i], PlayerPawn.Level);
			PowerupsArr.remove(i, 1);
			}
		}

	// Find all the pawns in the level and set any that are supposed to now hate
	// the player to hating him.
	for (i = 0; i < CurrentHaters.Length; i++)
		{
			foreach DynamicActors(class'P2Pawn', ppawn)
			{
				if(ppawn.IsA(CurrentHaters[i].ClassName))
				{
					ppawn.bPlayerIsEnemy = true;
					ppawn.bPlayerHater = true;
				}
			}
		}

	// Now that we're back in our level, start decrementing our timer again
	SetRadioTimer();

	// Get the dude specific stuff back out of gamestate
	p2p = P2Player(PlayerPawn.Controller);
	if(p2p != None)
		{
		p2p.LastWeaponGroupPee = LastWeaponGroupPee;
		p2p.LastWeaponOffsetPee = LastWeaponOffsetPee;
		p2p.LastWeaponGroupHands = LastWeaponGroupHands;
		p2p.LastWeaponOffsetHands = LastWeaponOffsetHands;

		// Restore our clothes
		if(!bPreGameMode && !bFirstLevelOfDay)
			{
			p2p.CurrentClothes = CurrentClothes;
			p2p.SetClothes(p2p.CurrentClothes);
			}

		// Save the status of your map reminders for the player
		p2p.TimeSinceErrandCheck = TimeSinceErrandCheck;
		p2p.MapReminderCount = MapReminderCount;

		// Restore god mode if necessary
		if (bCheatGod)
			p2p.bGodMode = true;

		// Re-init cat useage
		p2p.SetupCatnipUseage(CatnipUseTime);

		// Re-init hud armor type (inventory classes not defined yet -- hence this ugly code)
		p2p.HudArmorClass = HudArmorClass;
		if(HudArmorClass != None)
			{
			inv = spawn(HudArmorClass);
			p2p.HudArmorIcon = Texture(inv.Icon);
			inv.Destroy();
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Get the name of the way the player has been playing based on the game stats.
///////////////////////////////////////////////////////////////////////////////
function string GetPlayerRanking()
{
	// If you beat the game in heston mode, it says it wasn't even possible
	if(P2GameInfo(Level.Game).InHestonmode())
	{
		return HestonRanking;
	}
	// If 3/4 the people you kill were cops, make you a cop killer		
	else if(CopsKilled > PeopleKilled*0.75)
	{
		return CopKillerRanking;
	}
	// If you killed more animals than people
	else if((ElephantsKilled + DogsKilled + CatsKilled) > PeopleKilled)
	{
		return AnimalKillerRanking;
	}
	// If the number of rifle head shots over half the people you killed in the game
	else if(RifleHeadShot > PeopleKilled*0.5)
	{
		return RifleKillerRanking;
	}
	// If the number of people killed by fire is over half the people you killed in the game
	else if(PeopleRoasted > PeopleKilled*0.5)
	{
		return FireKillerRanking;
	}
	// If you pissed more in 'gallons' that killed people in numbers
	else if(float(PeeTotal)*0.1 > PeopleKilled
		// Make sure you killed a few people too though, so you can get the Jesus ranking easier.
		&& PeopleKilled >= KILLED_2)
	{
		return PeeRanking;
	}
	// If you stick guns up waaay too many cats butts (most of the cats in the game)
	else if(CatsUsed > CAT_USED_TOTAL)
	{
		return CatSexRanking;
	}
	// rankings for number of people killed
	else
	{
		if(PeopleKilled + CatsKilled + ElephantsKilled + DogsKilled == 0)
			return Killed0Ranking;
		else if(PeopleKilled <= KILLED_1)
			return Killed1Ranking;
		else if(PeopleKilled <= KILLED_2)
			return Killed2Ranking;
		else if(PeopleKilled <= KILLED_3)
			return Killed3Ranking;
		else if(PeopleKilled <= KILLED_4)
			return Killed4Ranking;
		else if(PeopleKilled <= KILLED_5)
			return Killed5Ranking;
		else if(PeopleKilled <= KILLED_6)
			return Killed6Ranking;
		else if(PeopleKilled <= KILLED_7)
			return Killed7Ranking;
		else if(PeopleKilled <= KILLED_8)
			return Killed8Ranking;
		else if(PeopleKilled <= KILLED_9)
			return Killed9Ranking;
		else if(PeopleKilled <= KILLED_10)
			return Killed10Ranking;
		else if(PeopleKilled > KILLED_10)
			return Killed11Ranking;
	}
}

///////////////////////////////////////////////////////////////////////////////
// By simply putting the ranking of an inventory item, it means this item
// won't display hints anymore.
///////////////////////////////////////////////////////////////////////////////
function RegisterInventoryHint(int Ranking)
{
	InactiveInvHints.Insert(InactiveInvHints.Length, 1);
	InactiveInvHints[InactiveInvHints.Length-1] = Ranking;
}

///////////////////////////////////////////////////////////////////////////////
// Reset any hints for inventory/weapons, so that they will show up again
///////////////////////////////////////////////////////////////////////////////
function ClearInventoryHints()
{
	InactiveInvHints.Remove(0, InactiveInvHints.Length);
}

///////////////////////////////////////////////////////////////////////////////
// True of this inventory ranking is in the list
///////////////////////////////////////////////////////////////////////////////
function bool FoundInvHintInactive(int ranking)
{
	local int i;

	//log(self$" FoundInvHintInactive with rank "$ranking);

	for(i=0; i<InactiveInvHints.Length; i++)
	{
		//log(self$" looking for this inv ranking "$InactiveInvHints[i]);
		if(InactiveInvHints[i] == ranking)
		{
			//log(self$" found it ");
			return true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Record a pickup for this level, so it won't be remade when you come back
// to this level
///////////////////////////////////////////////////////////////////////////////
function RecordPickup(name Pname)
{
	local int i;

	i = GottenPickups.Length;
	GottenPickups.Insert(i, 1);
	GottenPickups[i].PickupName = Pname;
	GottenPickups[i].LevelName = P2GameInfo(Level.Game).ParseLevelName(Level.GetLocalURL());
	//log(self$" recording "$pname$", for level "$GottenPickups[i].LevelName$" num now "$i+1);
}

///////////////////////////////////////////////////////////////////////////////
// Add haters.  Pawns of specified class will hate the player.
// DO NOT make all current haters in the level hate me. That's for when the player
// is at a real level transition, and the map comes up. Then it will mark them off
// and they will really start to hate him. Intermediate hatred is covered by bPlayerIsEnemy.
///////////////////////////////////////////////////////////////////////////////
function AddHaters(name HateClass, name HateDesTex, name HatePicTex, name HateComment)
{
	local FPSPawn p;
	local int i;

	// Only allows haters when playing as evil dude
	if(!bNiceDude && HateClass != '')
	{
		// Avoid adding duplicate haters to list.  This is only required because
		// we use cheats for testing and the cheats don't perfectly emulate a
		// real game.  In a real game you'd never get the same haters twice.
		for (i = 0; i < CurrentHaters.length; i++)
		{
			if (CurrentHaters[i].ClassName == HateClass)
				break;
		}
		
		if (i == CurrentHaters.length)
		{
			// Add info for new haters
			CurrentHaters.Insert(i, 1);
			CurrentHaters[i].ClassName = HateClass;
			CurrentHaters[i].DesTex = HateDesTex;
			CurrentHaters[i].PicTex = HatePicTex;
			CurrentHaters[i].Comment = HateComment;
			// We added a new hater to the list
			bAddedNewHaters=true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Remove haters.  Pawns of specified class will no longer hate the player.
///////////////////////////////////////////////////////////////////////////////
function RemoveHaters(name HateClass)
{
	local int i;
	local FPSPawn p;

	if (HateClass != '')
	{
		// Remove from hate list
		for (i = 0; i < CurrentHaters.length; i++)
		{
			if (CurrentHaters[i].ClassName == HateClass)
				CurrentHaters.remove(i, 1);
		}

		// Find all pawns of class and make them NOT hate the player.
		foreach DynamicActors(class'FPSPawn', p)
		{
			if(p.IsA(HateClass))
				p.bPlayerIsEnemy = false;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Save info so specified pawn will be teleported with the player
///////////////////////////////////////////////////////////////////////////////
function SavePawnForTeleport(FPSPawn ThePawn, P2Pawn PlayerPawn)
	{
	local int i;
	local LambController cont;

	i = TeleportedPawns.Length;
	TeleportedPawns.Insert(i, 1);

	// Give controller a chance to preserve info about the pawn
	cont = LambController(ThePawn.Controller);
	if(cont != None)
		cont.PreTeleportWithPlayer(TeleportedPawns[i], PlayerPawn);
	}

///////////////////////////////////////////////////////////////////////////////
// Restore all teleported pawns
///////////////////////////////////////////////////////////////////////////////
function RestoreAllTeleportedPawns(P2Pawn PlayerPawn)
	{
	local int i, j;
	local vector Loc, LinkpadPos, vcheck;
	local LevelInfo Lev;
	local class<Actor> aclass;
	local AIScript ais;
	local FPSPawn NearbyPawn, OrigPawn;
	local LambController cont;
	local float fcheck;

	// Use the LevelInfo as the owner for spawning (this is a static function so
	// there is no "self".  Probably could use any actor, but Epic did it this
	// way in some sample code so might as well go along with it.
	Lev = PlayerPawn.Level;

	log(self$" RestoreAllTeleportedPawns ");
	for(i = 0; i < TeleportedPawns.Length; i++)
		{
		// New location will be at player's current loction plus the saved offset
		// FIX ME: This could screw up if we ever have pawns that are taller than
		// the player pawn since we're using the player pawn's collision height!!!
		Loc = PlayerPawn.FindBestLocAfterTeleport(
			PlayerPawn.Location,
			PlayerPawn.Location + TeleportedPawns[i].Offset,
			PlayerPawn.CollisionHeight);

		// Spawn the pawn
		aclass = class<Actor>(DynamicLoadObject(TeleportedPawns[i].ClassName, class'Class'));

		j=0;
		NearbyPawn = None;
		while( j < MAX_SPAWN_TRY
				&& NearbyPawn == None)
			{
			NearbyPawn = FPSPawn(Lev.Spawn(aclass, Lev, TeleportedPawns[i].Tag, Loc));
			//log(self$" newly spawned "$NearbyPawn$" tag "$TeleportedPawns[i].Tag$" j "$j$" tried  at "$Loc);
			// As long as he doesn't spawn, try moving him forward some, hopefully until he spawns
			if(NearbyPawn != None)
				{
				// Add the controller to the pawn
				if ( (NearbyPawn.ControllerClass != None) && (NearbyPawn.Controller == None) )
					NearbyPawn.Controller = spawn(NearbyPawn.ControllerClass);
				if ( NearbyPawn.Controller != None )
					{
					NearbyPawn.Controller.Possess(NearbyPawn);

					// Give controller a chance to restore the pawn
					cont = LambController(NearbyPawn.Controller);
					if(cont != None)
						cont.PostTeleportWithPlayer(TeleportedPawns[i], PlayerPawn);
					}
				// Check for AI Script
				NearbyPawn.CheckForAIScript();
				}
			else	// Failed, so try moving him just as an offset from the player
				{
				// Spawn them in a range around the player, since the player will definitely make
				// it, group them around him, so they hopefully make it
				fcheck = ((MAX_SPAWN_TRY*FRand() + 1)*PlayerPawn.CollisionRadius);
				vcheck = fcheck * VRand();
				if(vcheck.z < 0)
					vcheck.z = -vcheck.z;

				Loc = PlayerPawn.Location + vcheck;
				}
			j++;
			}
		}

	// Clear the array
	if (TeleportedPawns.Length > 0)
		TeleportedPawns.Remove(0, TeleportedPawns.Length);
	}

///////////////////////////////////////////////////////////////////////////////
// The cops are still looking for the player. This carries through to each
// level. Each time he's spotted by a cop, the time he's wanted increases
// to a cap. It slowly goes down if he's not spotted. Eventually, they
// don't care anymore.
// This provides a ratio from 0--not wanted at all, to 1--totally wanted and
// really deadly.
///////////////////////////////////////////////////////////////////////////////
function float CopsWantPlayer()
{
	return CopRadioTime / CopRadioMax;
}

///////////////////////////////////////////////////////////////////////////////
// The cops are still looking for the player and he's not being
// sought in jail.
///////////////////////////////////////////////////////////////////////////////
function bool PlayCopRadio()
{
	if(CopsWantPlayer() > 0)
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Cops have trouble with the player and want to start up the 'cops want him'
// timer. This can also be used for if they already want him, and he's
// been spotted. 
///////////////////////////////////////////////////////////////////////////////
function IncreaseCopRadioTime()
{
	//log(self$" increasing cop time");
	if(CopRadioTime == 0)
		CopRadioTime = CopRadioBase;
	else
		CopRadioTime+=CopRadioInc;

	if(CopRadioTime > CopRadioMax)
		CopRadioTime = CopRadioMax;

	// Now immediately set the timer to start reducing this number, by increments
	// of what we increased in
	SetTimer((CopRadioTimerInterval/(Level.Game.GameDifficulty)), false);
}

///////////////////////////////////////////////////////////////////////////////
// The dude has been cleared of all accounts.
// To be used after he's dead. 
///////////////////////////////////////////////////////////////////////////////
function bool CopRadioBelowBase()
{
	if(CopRadioTime < CopRadioBase)
		return true;

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// The timer is below the base, set it to the base, if not, leave it alone
///////////////////////////////////////////////////////////////////////////////
function CopRadioFloorBase()
{
	if(CopRadioTime < CopRadioBase)
		CopRadioTime = CopRadioBase;
}

///////////////////////////////////////////////////////////////////////////////
// Set it to the base time
///////////////////////////////////////////////////////////////////////////////
function ResetCopRadioTime()
{
	local P2Player p2p;

	CopRadioTime = 0;
	// Make sure there's no cops after us.
	CopsAfterPlayer.Remove(0, CopsAfterPlayer.Length);
	// Force any weapon hints off too, for the player
	p2p = P2GameInfoSingle(Level.Game).GetPlayer();
	if(p2p != None)
		p2p.bShowWeaponHints=false;
}

///////////////////////////////////////////////////////////////////////////////
// Begin the radio ticking down again
///////////////////////////////////////////////////////////////////////////////
function SetRadioTimer()
{
	// Check if we're under our minimum time.. if so, then check if there
	// are any cops looking for the player. if so, then bump the radio back
	// past the minimum
	//log(self$" cop after player length "$CopsAfterPlayer.Length$" radio time "$CopRadioTime);
	if(CopRadioTime < CopRadioBase
		&& CopsAfterPlayer.Length > 0)
		CopRadioFloorBase();

	// if we're done, then don't reset the timer	
	if(CopRadioTime <= 0)
		ResetCopRadioTime();
	else
	{
		// if we have less time left than our decrement
		if(CopRadioTime < (CopRadioTimerInterval/(Level.Game.GameDifficulty)))
			SetTimer(CopRadioTime, false);
		else
			SetTimer((CopRadioTimerInterval/(Level.Game.GameDifficulty)), false);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Each time your called you'll reduce the cops hate player timer a little more
///////////////////////////////////////////////////////////////////////////////
function Timer()
{
	CopRadioTime -= CopRadioDec;

	SetRadioTimer();
}

///////////////////////////////////////////////////////////////////////////////
// See about adding this cop to the list of cops that are trying to attack the 
// player
///////////////////////////////////////////////////////////////////////////////
function AddCopAfterPlayer(FPSPawn NewCop)
{
	CopsAfterPlayer.Insert(CopsAfterPlayer.Length, 1);
	CopsAfterPlayer[CopsAfterPlayer.Length-1] = NewCop;
	//log(self$" AddCopAfterPlayer "$NewCop);
}

///////////////////////////////////////////////////////////////////////////////
// See about removing this cop to the list of cops that are trying to attack the 
// player. Make sure he is in no way thinking about attacking the player before
// calling this
///////////////////////////////////////////////////////////////////////////////
function RemoveCopAfterPlayer(FPSPawn NewCop)
{
	local PersonController pcont;
	local int i;

	// Find it
	i=0;
	while(i < CopsAfterPlayer.Length)
	{
		//log(self$" checking "$CopsAfterPlayer[i]$" against "$NewCop);
		if(CopsAfterPlayer[i] == NewCop)
		{
			//log(self$" RemoveCopAfterPlayer "$NewCop$" at "$i);
			CopsAfterPlayer.Remove(i, 1);
			return;
		}
		i++;
	}
	//log(self$" COULD NOT remove "$NewCop);
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	JailCellNumber = 0
	LastJailCellNumber = 5;
	DemoTime=419
	CopRadioInc=20
	CopRadioBase=50
	CopRadioDec=1
	CopRadioTimerInterval=2.5
	CopRadioMax=200

	Killed0Ranking		=	"Thank you for playing, JESUS."
	Killed1Ranking		=	"Gun-shy Murderer"
	Killed2Ranking		=	"Underachieving Thug"
	Killed3Ranking		=	"Wanna-be Gangsta"
	Killed4Ranking		=	"Soccer Mom"
	Killed5Ranking		=	"Office Drone Pushed over the Edge"
	Killed6Ranking		=	"Prozac-Powered Gun Nut"
	Killed7Ranking		=	"Serial Killer on Steroids"
	Killed8Ranking		=	"Society-Shunning, Grade-A Psycho"
	Killed9Ranking		=	"Ex-Military Killing Machine"
	Killed10Ranking		=	"Hitler would be proud."
	Killed11Ranking		=	"Congratulations, SATAN."
	CopKillerRanking	=	"Cop Killer"
	AnimalKillerRanking	=	"PETA-Hating, Animal Murderer"
	RifleKillerRanking	=	"Teen Sniper"
	FireKillerRanking	=	"Arsonist"
	PeeRanking			=	"Water Sports Enthusiast"
	CatSexRanking		=	"Cat Rapist"
	HestonRanking		=	"Congratulations! We didn't think this was even possible!"

	LastSelectedInventoryGroup=-1
	LastSelectedInventoryOffset=-1

	GameDifficulty		=	-1
	}

