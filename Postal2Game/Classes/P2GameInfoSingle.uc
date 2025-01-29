///////////////////////////////////////////////////////////////////////////////
// P2GameInfoSingle.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for single player games
//
// History:
//	02/19/03 JMI	Moved save slot ownership here from ShellInfo which seems
//					to have simplified things nicely.
//
//	09/16/02 MJR	Started by pulling stuff out of P2GameInfo.
//
///////////////////////////////////////////////////////////////////////////////
class P2GameInfoSingle extends P2GameInfo;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var GameState	TheGameState;					// The one-and-only GameState which stores persistent game info

var() export editinline array<DayBase> Days;	// All the days and their errands

var() String	IntroURL;						// URL for intro
var() String	StartFirstDayURL;				// URL for starting the first day
var() String	StartNextDayURL;				// URL for starting the next day
var() String	FinishedDayURL;					// URL for when you finish the day
var() String	JailURL;						// URL for jail (include "#cell" but no number)

var() name		ApocalypseTex;					// Newspaper texture for the Apocalypse (independent of day)
var() name		ApocalypseComment;				// Dude comment for the Apocalypse (independent of day)

var bool		bQuitting;						// True if quitting the game (to differentiate from other loads)
var bool		bLoadedSavedGame;				// True if loaded a saved game (useful before PostLoadGame() is called)
var bool		bTesting;						// True if this is not a real game, we're just playing a map directly

var bool		bShowErrandsDuringLoad;			// Whether to show new errands during load process
var bool		bShowStatsDuringLoad;			// Whether to show stats during load -- only at end of game
var bool		bShowHatersDuringLoad;			// Whether to show new haters during load process
var bool		bShowDayDuringLoad;

var int			DayToShowDuringLoad;

var localized string EasySaveMessageString;
var localized string AutoSaveMessageString;
var localized string ForcedSaveMessageString;
var localized string NormalSaveMessageString;

var globalconfig bool	bAllowCManager;			// If set to true, cheats in P2CheatManager can be used.

var globalconfig bool	bUseAutoSave;			// Enables auto-save after each level transition
var bool		bSafeToSave;					// Whether it is safe to save the game
var bool		bDoAutoSave;					// Whether autosave should occur after level starts
var bool		bForcedAutoSave;				// whether this was a forced autosave
var int			AutoSaveSlot;					// Which slot to autosave to
var int			MostRecentGameSlot;				// The most recently used game slot
var SlotInfoMgr	MySlotInfoMgr;					// Manages extraneous info about the slots

var globalconfig int	InfoSeqTime;			// Info on sequence of game

var array<Material>	SpawnerMaterials;			// Preloaded textures for any spawners in the level
var array<Mesh>		SpawnerMeshes;				// Preloaded meshes for any spawners in the level

var float		CheckReviveTime;				// Cumulative time of sleeping until something clears us. Used
												// with REVIVE_CHECK_TIME below. When this is greater than that const
												// the pawns are checked to be removed from pawn slider stasis.
var name		RunningStateName;				// State name that the game normal runs in. (Differs for full game
												// versus demo game. Don't change this when switching over to the
												// apocalypse at the end of the game--this is special.)

var localized string DifficultyNames[13];		// These used to be held in the menu files, but now it's here
												// so both the menu and the slot mgr can get to it.
var globalconfig int CoolStart, EndCool;
var globalconfig int FOver;
var globalconfig int TimesBeatenGame;			// Number of times you've beaten the game


const QUICKSAVE_SLOT			= 9;
const AUTOSAVE_SLOT				= 10;

const LOADGAME_URL				= "?load=";

const RUNNING_LOOP_TIME			= 1.0;

const REVIVE_CHECK_TIME			= 12.0;			// How often to check about reviving pawns
												// if we're below our SliderPawnGoal limit.
const SLIDER_PAWN_DIST			= 800;			// Closest distance a pawn can be before he
												// can be pulled out of bSliderStasis.
const VIEW_CONE_SLIDER_PAWN		= 0.1;			// Dot product value from view of player to pawn
												// possibly to be brought of out slider stasis. We want
												// this to be so he's not seeing them come out.
const REF_STARTUP				= 5000;
const FOVER_SUM					= 5323;

const COOL_FACTOR				= 1000;

const SLEEP_TIME_INC			= 1.0;			// For a complex sleep loop. We sleep this time and check
												// some functions more often than others.

// The following are groups as specified by the unreal editor. Generally a group can only be
// created when an object is selected. It is suggested that one select the playerstart, 
// then add all groups necessary for the game. In our immediate single-player case
// we would want
// DAY_A, DAY_B, DAY_C, DAY_D, DAY_E, GOODGUY, BADGUY
// The day's are used to allow things only for certain days in the game. Goodguy allows
// things only for when the player has picked to play as the 'good' dude. Badguy is
// for things when the player has picked the normal dude.
// Day specification code
const DAY_STR					=	"DAY_";
const DAY_STR_LEN				=	4;
const DAY_START_ASCII			=	65;
//const W
// Good/evil dude
const GOOD_GUY_GROUP			=	"GOODGUY";
const BAD_GUY_GROUP				=	"BADGUY";
// Hard/easy difficulty
const EASY_GROUP				=	"EASY_";
const HARD_GROUP				=	"HARD_";

const SEQ_ADD					=	100;

//ini paths
const InfoSeqPath				=	"Postal2Game.P2GameInfoSingle InfoSeqTime"; // ini path
const RefPath					=	"Postal2Game.P2GameInfo GameRefVal"; // keep in super's ini spot
const EGamePath					=	"Postal2Game.P2GameInfoSingle bEGameStart";
const EndCoolPath				=	"Postal2Game.P2GameInfoSingle EndCool";
const CoolStartPath				=	"Postal2Game.P2GameInfoSingle CoolStart";
const FOverPath					=	"Postal2Game.P2GameInfoSingle Fover";
const TimesBeatenGamePath		=	"Postal2Game.P2GameInfoSingle TimesBeatenGame";
const DifficultyPath			=	"Postal2Game.P2GameInfo GameDifficulty";


///////////////////////////////////////////////////////////////////////////////
// This function is called before any other scripts (including PreBeginPlay().
///////////////////////////////////////////////////////////////////////////////
event InitGame(out string Options, out string Error)
	{
	local string InName, InClass, InTeam;

	// RWS CHANGE: For Singleplayer, Modify URL options to use the default Name, Class and Team
	
	// Use same name that the PlayerReplicationInfo.PlayerName gets set to (in Controller.InitPlayerReplicationInfo())
	Options = SetURLOption(Options, "Name",  class'GameInfo'.Default.DefaultPlayerName);

	Options = SetURLOption(Options, "Class", Default.DefaultPlayerClassName);

	//Options = SetURLOption(Options, "Team",  "255");

	Super.InitGame(Options, Error);
	MySlotInfoMgr = spawn(class'SlotInfoMgr');
	}


//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Start/Quit/Load/Save/etc
//
//=================================================================================================
//=================================================================================================
//=================================================================================================

///////////////////////////////////////////////////////////////////////////////
// Start the game
///////////////////////////////////////////////////////////////////////////////
function StartGame(optional bool bEnhancedMode)
	{
	local P2Player p2p;

	P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).StartingGame();

	// Stop any active SceneManager so player will have a pawn
	StopSceneManagers();

	// No longer used, make sure it's always off
	TheGameState.bNiceDude = false;

	PrepIniStartVals();

	TheGameState.bEGameStart = bEnhancedMode;


	// Get the difficulty ready for this game state.
	SetupDifficultyOnce();

	// Get rid of any things in his inventory before a new game starts
	p2p = GetPlayer();
	P2Pawn(p2p.pawn).DestroyAllInventory();

	// Game doesn't actually start until player is sent to first day,
	// which *should* happen at the end of the intro sequence.
	if(!bIsDemo)
		SendPlayerTo(GetPlayer(), IntroURL);
	else	// Unless of course it's the demo, then it *does* actaully just start.
		{
		TheGameState.bChangeDayPostTravel = true;
		TheGameState.NextDay = 0;
		SendPlayerTo(GetPlayer(), StartFirstDayURL);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Make sure these are done at StartGame and every time you load, in case,
// in between, someone deletes their ini, but uses an old load
///////////////////////////////////////////////////////////////////////////////
function PrepIniStartVals()
{
	GameRefVal = int(ConsoleCommand("get "@RefPath));
	if(GameRefVal == START_GAME_REF)
	{
		// Setup the reference value
		GameRefVal=(Rand(REF_STARTUP)/2);
		GameRefVal=2*GameRefVal;
		ConsoleCommand("set "@RefPath@GameRefVal);
		log(self$" NEW made up gameref "$GameRefVal);
	}
	else
		log(self$" CURRENT gameref "$GameRefVal);
	if(CoolStart == 0)
	{
		CoolStart = Rand(COOL_FACTOR);
		ConsoleCommand("set "@CoolStartPath@CoolStart);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Quit the game.
// NOTE: Player may not have a pawn if he's dead or a cinematic is playing.
///////////////////////////////////////////////////////////////////////////////
function QuitGame()
	{
	P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).EndingGame();

	bQuitting = true;

	// Send player to main menu (set flag to indicate that pawn might be none)
	SendPlayerTo(GetPlayer(), MainMenuURL, true);
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function RecordEnding()
	{
	FOver = FOVER_SUM - GameRefVal;
	TimesBeatenGame++;
	ConsoleCommand("set "@FOverPath@FOver);
	ConsoleCommand("set "@TimesBeatenGamePath@TimesBeatenGame);
	}	

///////////////////////////////////////////////////////////////////////////////
// The player has watched the last movie in the game and successfully beaten
// the game! Put up the stats screen as we load the main menu.
///////////////////////////////////////////////////////////////////////////////
function EndOfGame(P2Player player)
	{
	P2RootWindow(player.Player.InteractionMaster.BaseMenu).EndingGame();

	// Set that you want the stats
	bShowStatsDuringLoad=true;

	// Only save sequence 'time' if beaten at average difficulty or higher
	// (Or if we've already unlocked it, give it to them again)
	if(GetDifficultyOffset() >= 0
		|| TheGameState.bEGameStart)
		InfoSeqTime = GetSeqTime();
	ConsoleCommand("set "@InfoSeqPath@InfoSeqTime);
	RecordEnding();
	log(self$" GameRefVal new InfoSeqTime "$InfoSeqTime$" GameRefVal "$GameRefVal$" fover "$FOver);

	// Send player to main menu
	SendPlayerTo(player, MainMenuURL);
	}

///////////////////////////////////////////////////////////////////////////////
// Load custom map
///////////////////////////////////////////////////////////////////////////////
function LoadCustomMap(string URL)
	{
	local P2Player p2p;

	Log(self$" LoadCustomMap(): URL="$URL);

	P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).StartingGame();
	GetPlayer().MyHUD.bHideHud = true;

	// Get rid of any things in his inventory before a new game starts
	p2p = GetPlayer();
	if (p2p.pawn != None)
		P2Pawn(p2p.pawn).DestroyAllInventory();

	// The perverted engine technique for loading a level is to travel to
	// the loaded game.  (Set flag to indicate pawn might be none)
	SendPlayerTo(p2p, URL, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Load game from the specified slot
///////////////////////////////////////////////////////////////////////////////
function LoadGame(int Slot, bool bShowScreen)
	{
	Log(self$" LoadGame(): Slot="$Slot);

	P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).StartingGame();
	GetPlayer().MyHUD.bHideHud = true;

	if (bShowScreen)
		{
		// Show the day (monday, tuesday,...) associated with the game during the load
		bShowDayDuringLoad = true;
		DayToShowDuringLoad = MySlotInfoMgr.GetInfo(Slot).Day;
		}

	// The perverted engine technique for loading a level is to travel to
	// the loaded game.  (Set flag to indicate pawn might be none)
	SendPlayerTo(GetPlayer(), LOADGAME_URL$Slot, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Restore your errands
///////////////////////////////////////////////////////////////////////////////
event PostLoadGame()
	{
	Super.PostLoadGame();

	// Restore day and errands
	RestoreDayAndErrands();

	PrepIniStartVals();

	// Always clear the pause after a game is loaded (in case the game was
	// saved in a paused state)
	GetPlayer().SetPause(false);

	log(self$" game difficulty ***************** "$TheGameState.GameDifficulty);
	// If the game state's difficulty was not initialized properly, then it was from
	// and old save. So offer the person a chance to set their difficulty once again
	// for this save.
	if(TheGameState.GameDifficulty < 0)
		{
		//log(self$" allowing them to set new game diff ");
		GetPlayer().GotoState('PlayerDiffPatch');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Save game to the specified slot
///////////////////////////////////////////////////////////////////////////////
function SaveGame(int Slot, bool bShowMessage)
	{
	Log(self$" SaveGame(): Slot="$Slot$" bAutoSave="$bDoAutoSave$" bForcedAutoSave="$bForcedAutoSave$" the game state difficulty "$TheGameState.GameDifficulty);

	if (bShowMessage)
		{
		if (Slot == QUICKSAVE_SLOT)
			GetPlayer().ClientMessage(EasySaveMessageString);
		else if (Slot == AUTOSAVE_SLOT && bForcedAutoSave)
			GetPlayer().ClientMessage(ForcedSaveMessageString);
		else if (Slot == AUTOSAVE_SLOT)
			GetPlayer().ClientMessage(AutoSaveMessageString);
		else
			GetPlayer().ClientMessage(NormalSaveMessageString);
		}

	// This slot is now the most recently used slot.  We update this BEFORE the
	// actual save so that if this game is loaded, it will refer to itself as
	// the most recently used.  In other words, whenever a game is loaded, the
	// slot it loaded from becomes the most recently used slot.
	MostRecentGameSlot = Slot;

	// Do the actual save
	ConsoleCommand("SaveGame "$Slot);

	// Save info about this slot
	MySlotInfoMgr.SetInfo(
		Slot,
		GetCurrentDayBase().Description@"-"@Level.Title@"-"@GetDiffName(TheGameState.GameDifficulty),
		GetCurrentDay(),
		Level.Year$"-"$Val2Str(level.Month, 2)$"-"$Val2Str(Level.Day, 2)@":"@Val2Str(Level.Hour, 2)$":"$Val2Str(Level.Minute, 2),
		int(ConsoleCommand("GETGMTIME")));
	}

///////////////////////////////////////////////////////////////////////////////
// Try to return the true, GameState difficulty
///////////////////////////////////////////////////////////////////////////////
function float GetGameDifficulty()
{
	if(TheGameState != None)
		return TheGameState.GameDifficulty;
	else
		return GameDifficulty;
}

///////////////////////////////////////////////////////////////////////////////
// Get the phrase for our difficulty level (override in p2gameinfosingle)
///////////////////////////////////////////////////////////////////////////////
function string GetDiffName(int DiffIndex)
{
	if(DiffIndex < 0)
		DiffIndex = 0;
	else if(DiffIndex > ArrayCount(DifficultyNames))
			DiffIndex = ArrayCount(DifficultyNames);
	return DifficultyNames[DiffIndex];
}

///////////////////////////////////////////////////////////////////////////////
// Try to do a quick save.
// Return value indicates whether it was actually done or not.
///////////////////////////////////////////////////////////////////////////////
function bool TryQuickSave(P2Player player)
	{
	local bool bDidSave;

	if (IsSaveAllowed(player) &&	// only if conditions are right
		(Level.Pauser == None))		// only if not paused
		{
		SaveGame(QUICKSAVE_SLOT, true);
		bDidSave = true;
		}
	return bDidSave;
	}

///////////////////////////////////////////////////////////////////////////////
// Try to do a quick load.
///////////////////////////////////////////////////////////////////////////////
function TryQuickLoad(P2Player player)
	{
	if (IsLoadAllowed(player) &&	// only if conditions are right
		!IsPreGame() &&				// only during actual game
		(player.Pawn != None) &&	// only if player has pawn (aka not during cinematics)
		(Level.Pauser == None))		// only if not paused
		{
		// Load the most recent game
		LoadMostRecentGame();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Player calls this when it's ready for a save.  It will call this repeatedly
// until it returns true, which means we agree.
///////////////////////////////////////////////////////////////////////////////
function bool ReadyForSave(P2Player player)
	{
	// Set the all-critical flag, then make sure all the other conditions
	// are right.  If it works, then we're good to go.  Otherwise, we clear
	// the flag and wait for the next call.
	bSafeToSave = true;
	if (IsSaveAllowed(player))
		{
		// If an auto save is desired, now is the perfect time to do it
		if (bDoAutoSave)
			{
			SaveGame(AutoSaveSlot, true);
			// Only clear flags after the save is done
			bDoAutoSave = false;
			bForcedAutoSave = false;
			}
		}
	else
		bSafeToSave = false;

	return bSafeToSave;
	}

///////////////////////////////////////////////////////////////////////////////
// Called when the player would have tried to autosave (even if he has it
// turned off. This brings up a menu for the player to pick the new difficulty
// for that save. 
///////////////////////////////////////////////////////////////////////////////
function bool ReadyForSaveFix(P2Player player)
	{
	// Set the all-critical flag, then make sure all the other conditions
	// are right.  If it works, then we're good to go.  Otherwise, we clear
	// the flag and wait for the next call.
	bSafeToSave = true;
	if (IsSaveAllowed(player))
		{
		bDoAutoSave = false;
		P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).DifficultyPatch();
		}
	else
		bSafeToSave = false;

	return bSafeToSave;
	}

///////////////////////////////////////////////////////////////////////////////
// Load the most-recent game
///////////////////////////////////////////////////////////////////////////////
function LoadMostRecentGame()
	{
	Log(self$" LoadMostRecentGame(): Slot="$MostRecentGameSlot);

	if (MostRecentGameSlot != -1)
		{
		P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).StartingGame();
		LoadGame(MostRecentGameSlot, false);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Check whether save is allowed
///////////////////////////////////////////////////////////////////////////////
function bool IsSaveAllowed(P2Player player)
	{
	if (bSafeToSave &&				// only if it's safe
		!bIsDemo &&					// not in demo
		!IsPreGame() &&				// only during actual game
		!IsFinishedDayMap()	&&		// not on finishedday map
		player != None &&			// only if there's a player
		player.IsSaveAllowed())		// only if player agrees
		return true;
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Check whether load is allowed
///////////////////////////////////////////////////////////////////////////////
function bool IsLoadAllowed(P2Player player)
	{
	if (!bIsDemo)					// not in demo
		return true;
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Convert the specified integer to a string with the given width by preceding
// with 0's as necessary.
// This is utilized by SaveSlotInfo.
///////////////////////////////////////////////////////////////////////////////
static function string Val2Str(int iVal, int iWidth)
{
	local int		iCurDigitWeight;
	local string	strVal;

	strVal = ""$iVal;

	iCurDigitWeight = 1;
	while (iWidth > 1)
	{
		iCurDigitWeight *= 10;
		if (iVal < iCurDigitWeight)
			strVal = "0"$strVal;
		iWidth--;
	}

	return strVal;
}

///////////////////////////////////////////////////////////////////////////////
// Check last code
///////////////////////////////////////////////////////////////////////////////
function bool VerifySeqTime(optional bool bUpdate)
{
	local bool bEStartCheck;
	local bool bverified;

	if(bUpdate)
		InfoSeqTime = int(ConsoleCommand("get "@InfoSeqPath));
	else
		bEStartCheck=true;

	//log(self$" gameref VerifySeqTime estart "$bEStartCheck$" game start "$TheGameState.bEGameStart);
	if(!bEStartCheck
		|| (TheGameState != None
			&& TheGameState.bEGameStart))
	{
		//log(self$" GameRefVal check "$(2*(InfoSeqTime - SEQ_ADD))$" ref "$GameRefVal$" time "$InfoSeqTime$" start "$bEStartCheck);
		bverified = (GameRefVal == (2*(InfoSeqTime - SEQ_ADD)));

		// If you already beaten the game but it's not been recorded, then record it here.
		if(bverified
			&& !FinallyOver())
			RecordEnding();

		return bverified;
	}
	else
		return false;
}

///////////////////////////////////////////////////////////////////////////////
// Calc last code
///////////////////////////////////////////////////////////////////////////////
function int GetSeqTime()
{
	return (GameRefVal/2 + SEQ_ADD);
}

///////////////////////////////////////////////////////////////////////////////
// Decide how many to drop at the start, goes with DiscardInventory
// For the player in a singleplayer game, we can fail to drop all our stuff
// and it's okay
///////////////////////////////////////////////////////////////////////////////
function DiscardPowerupStart(out int checkamount, P2PowerupInv powerupcheck, P2Pawn pawncheck)
{
	if(pawncheck.bPlayer
		&& powerupcheck.bThrowIndividually)
	{
		checkamount = POWERUP_DROP_RATIO*powerupcheck.Amount;
		if(checkamount == 0)
			checkamount = 1;
	}
	else
		checkamount = powerupcheck.Amount;
}
///////////////////////////////////////////////////////////////////////////////
// Make sure what you dropped came out, goes with DiscardInventory
// For the player in a singleplayer game, we can fail to drop all our stuff
// and it's okay
///////////////////////////////////////////////////////////////////////////////
function DiscardPowerupVerify(out int checkamount, P2PowerupInv powerupcheck, P2Pawn pawncheck)
{
	if(pawncheck.bPlayer)
	{
		if(powerupcheck.bThrowIndividually)
			checkamount--;
		else
			checkamount = 0;
	}
	else
		Super.DiscardPowerupVerify(checkamount, powerupcheck, pawncheck);
}

///////////////////////////////////////////////////////////////////////////////
// Check how cool the player is.
///////////////////////////////////////////////////////////////////////////////
function bool CheckCoolness()
{
	return (CoolStart + EndCool == COOL_FACTOR);
}
exec function WriteCoolness()
{
	if(EndCool == 0)
	{
		EndCool = COOL_FACTOR - CoolStart;
		ConsoleCommand("set "@EndCoolPath@EndCool);
	}
}
function bool FinallyOver()
{
	return (FOVER_SUM == (FOver + GameRefVal));
}

///////////////////////////////////////////////////////////////////////////////
// When a new game is started, the game state is given this game difficulty
// from the game info (which is the ini val that the player sets). This should
// only happen then, so this value will be saved from now and forced back into
// the game info difficulty when the game is actually running.
///////////////////////////////////////////////////////////////////////////////
function SetupDifficultyOnce()
{
	TheGameState.GameDifficulty = GameDifficulty;
	log(self$" SetupDifficultyOnce game diff "$GameDifficulty);
}

///////////////////////////////////////////////////////////////////////////////
// Only to be used when fixing a saved game's difficulty. If we had a liebermode game
// and now the person is about to patch their save with a new difficulty, say average,
// we need to undo all the baton/shovel/taser things and give them their normal weapons.
// But not for the player. Leave him alone.
///////////////////////////////////////////////////////////////////////////////
function FixDifficultyInventories()
{
	local P2Pawn checkpawn;
	log(self$" FixDifficultyInventories");
	foreach DynamicActors(class'P2Pawn', checkpawn)
	{
		if(checkpawn.Health > 0
			&& checkpawn.Controller != None
			&& P2Player(checkpawn.Controller) == None)
		{
			//log(self$" checking "$checkpawn);
			// Remove everything they had
			checkpawn.DestroyAllInventory();
			// Reset them
			checkpawn.ResetGotDefaultInventory();
			// Add in all in again, but have the new difficulty (naturally) set everything
			checkpawn.AddDefaultInventory();
			// If they are in the apocalypse, make sure to get them ready for that.
			if(TheGameState.bIsApocalypse
				&& PersonController(checkpawn.Controller) != None)
				PersonController(checkpawn.Controller).ConvertToRiotMode();
		}
	}
}

//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Traveling between levels
//
//=================================================================================================
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// Called from P2Player.TravelPostAccept(), which is after the player pawn
// has traveled to (or been created in) a new level.
//
// This ultimately gets called in three basic situations, shown here along
// with how to differentiate them:
//
//  Loaded game: TheGameState != None
//	New game:    TheGameState == None and player's inventory does NOT contain GameState
//  New level:   TheGameState == None and player's inventory contains GameState
//
///////////////////////////////////////////////////////////////////////////////
event PostTravel(P2Pawn PlayerPawn)
	{
	if (TheGameState != None)
		{
		// We loaded a saved game
		bLoadedSavedGame = true;
		Log(self$" PostTravel(): Loaded a saved game (using the loaded GameState)");
		}
	else
		{
		// Try to get GameState from player's inventory
		TheGameState = GameState(PlayerPawn.FindInventoryType(class'GameState'));
		if (TheGameState != None)
			{
			PlayerPawn.DeleteInventory(TheGameState);
			Log(self$" PostTravel(): Continuing existing game (got GameState from player inventory)");
			}
		else
			{
			Log(self$" PostTravel(): Starting new game (creating new GameState)");
			TheGameState = spawn(class'GameState');

			// We just created a new GameState, so if we're NOT on one of the
			// "pre game" maps then we must be testing a map by loading it directly.
			if (IsMainMenuMap() || IsIntroMap())
				{
				TheGameState.bPreGameMode = true;
				SetupDifficultyOnce();
				}
			else
				{
				// Start new game for testing
				bTesting = true;
				TheGameState.bChangeDayPostTravel = true;
				TheGameState.NextDay = 0;
				P2RootWindow(GetPlayer().Player.InteractionMaster.BaseMenu).StartingGame();
				MostRecentGameSlot = -1; // This is unknown when testing
				SetupDifficultyOnce();
				}
			}

		// Check if we need to change the day (includes starting a new game)
		if (TheGameState.bChangeDayPostTravel)
			{
			// Check if starting a new game
			if (NextDay() == 0)
				{
				TheGameState.bFirstLevelOfGame = true;
				TheGameState.bPreGameMode = false;

				// Check for valid errand goals (only done once, reports errors to log)
				CheckForValidErrandGoals();
				}
			else
				{
				TheGameState.bFirstLevelOfGame = false;

				// Remove inventory player can't leave the current day with
				Days[TheGameState.CurrentDay].TakeInventoryFromPlayer(PlayerPawn);
				}

			// Change the day
			TheGameState.CurrentDay = NextDay();
			TheGameState.bFirstLevelOfDay = true;
			TheGameState.ErrandsCompletedToday = 0;
			TheGameState.bChangeDayPostTravel = false;
			TheGameState.bChangeDayForDebug = false;
			}
		else
			{
			// Same day, so clear flag
			TheGameState.bFirstLevelOfDay = false;
			}

		// GameInfo is now valid
		GameInfoIsNowValid();

		// Tell GameState the level has changed
		TheGameState.PostLevelChange(PlayerPawn, ParseLevelName(Level.GetLocalURL()));
		
		// Get most recent slot
		MostRecentGameSlot = TheGameState.MostRecentGameSlot;

		// Restore day and its errands
		RestoreDayAndErrands();
		
		// Restore pawns that teleported with the player
		TheGameState.RestoreAllTeleportedPawns(PlayerPawn);

		// Handle changing things because we're going to the first level of a new day
		if (TheGameState.bFirstLevelOfDay)
			// Check if we need to give the player the starting inventory for this day
			Days[TheGameState.CurrentDay].AddInStartingInventory(PlayerPawn);

		// Decide whether auto-save should be done (although it's not actually
		// done here).  We force an autosave at the start of the game's first level
		// even if autosave is disabled because we need something to go back to
		// when the player dies and wants to to restart (we can't assume he'll save
		// on his own).  We also force an autosave at the start of each day because
		// most players won't realize they'd have to go back to a previous day if
		// they don't manually save on a new day.
		bDoAutoSave = false;
		if (!bIsDemo && !IsFinishedDayMap())
			{
			if ((bUseAutoSave && !IsPreGame()) || TheGameState.bFirstLevelOfDay)
				{
				bDoAutoSave = true;
				AutoSaveSlot = AUTOSAVE_SLOT;
				if (TheGameState.bFirstLevelOfDay)
					bForcedAutoSave = true;
				}
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Our lowest-level function for sending a player to a URL.
// You should normally call SendPlayerTo() instead of this.
///////////////////////////////////////////////////////////////////////////////
function SendPlayerEx(
	PlayerController player,
	String URL,
	optional ETravelType TravelType,
	optional ETravelItems TravelItems)
	{
	// If we're loading a game then it implies certain options
	if (InStr(URL, LOADGAME_URL) >= 0)
		{
		TravelType = TRAVEL_Absolute;
		TravelItems = TRAV_WithoutItems;
		};

	// Clear references to day/errand objects so they will be garbage collected.
	// NOTE: Turns out there are other references to these objects so this
	// didn't have any effect.  Instead of trying to delete them, we learned to
	// accept the idea that they never go away.  See RestoreDayAndErrands().
//	for (i = 0; i < Days.Length; i++)
//		Days[i].Errands.Remove(0, Days[i].Errands.Length);
//	Days.Remove(0, Days.Length);

	Super.SendPlayerEx(player, URL, TravelType, TravelItems);
	}

///////////////////////////////////////////////////////////////////////////////
// Called to send the player to a new level.
///////////////////////////////////////////////////////////////////////////////
function SendPlayerTo(
	PlayerController player,
	String URL,
	optional bool bMaybePawnless)
	{
	if(TheGameState == None)
		Warn("TheGameState=none");
	if (player == None)
		Warn("player=none");
	if (player.pawn == none && !bMaybePawnless)
		Warn("player.pawn=none");

	// Let player prepare to travel
	P2Player(Player).PreTravel();

	// Add GameState (and related items) to player's inventory to travel to next level
	// (unless we're heading to the main menu, in which case the game is over)
	if (!(MainMenuURL ~= URL) && (Player.Pawn != None))
	{
		// Remember the most recent slot
		TheGameState.MostRecentGameSlot = MostRecentGameSlot;

		// Let GameState prepare itself and then add it to the player's inventory
		TheGameState.PreLevelChange(P2Player(Player).MyPawn, ParseLevelName(Level.GetLocalURL()));
		if (player.pawn.AddInventory(TheGameState))
			Log(self @ "SendPlayerTo(): added GameState to player's inventory");
		else
			Warn("failed to add GameState to player inventory");
	}

	player.MyHUD.bHideHud = true;

	// Check if a screen will be displayed during the transition or if it's a seamless
	// transition.  If a screen is used, it will ultimataly call SendPlayerEx(), too.
	if (bShowErrandsDuringLoad)
		P2Player(player).DisplayMapErrands(URL);
	else if(bShowHatersDuringLoad)
		P2Player(player).DisplayMapHaters(URL);
	else if (bShowDayDuringLoad)
		P2Player(player).DisplayLoad(Days[DayToShowDuringLoad], URL);
	else if (TheGameState.bPreGameMode)
		P2Player(player).DisplayLoad(Days[0], URL);
	else if (TheGameState.bChangeDayPostTravel)
		P2Player(player).DisplayLoad(Days[NextDay()], URL);
	else if (bShowStatsDuringLoad)
		P2Player(player).DisplayStats(URL);
	else
		SendPlayerEx(player, URL);

	TheGameState = None;
	Log(self @ "SendPlayerTo(): discarded TheGameState");
	}

///////////////////////////////////////////////////////////////////////////////
// Send player across level transition.
// Player may be diverted home if the conditions are right.
///////////////////////////////////////////////////////////////////////////////
function SendPlayerLevelTransition(PlayerController player, String URL, bool bRealLevelExit)
{
	// If this is a real level exit and we recently added new haters, then mark that 
	// we want to show them during the next load, and clear the addednewhaters flag.
	if(bRealLevelExit
		&& TheGameState.bAddedNewHaters)
	{
		bShowHatersDuringLoad=true;
		TheGameState.bAddedNewHaters=false;
	}

	TheGameState.bLastLevelExitWasReal = bRealLevelExit;

	if (WillPlayerBeDivertedHome(URL, bRealLevelExit))
		URL = FinishedDayURL;

	SendPlayerTo(player, URL);
}

///////////////////////////////////////////////////////////////////////////////
// Send player to the first day
///////////////////////////////////////////////////////////////////////////////
function SendPlayerToFirstDay(PlayerController player, optional bool bDontShowMap)
	{
	// Only do special movie in full game
	if(!bIsDemo)
		{
		if (!bDontShowMap)
			bShowErrandsDuringLoad = true;

		// If player doesn't have a pawn, it's probably because a scene is running
		if (player.pawn == None)
			StopSceneManagers();
		}

	TheGameState.bChangeDayPostTravel = true;
	TheGameState.NextDay = 0;
	SendPlayerTo(player, StartFirstDayURL);
	}

///////////////////////////////////////////////////////////////////////////////
// Send player to the next day
///////////////////////////////////////////////////////////////////////////////
function SendPlayerToNextDay(PlayerController player)
	{
	// See if there's any more days
	if (TheGameState.CurrentDay + 1 < Days.length)
		{
		TheGameState.bChangeDayPostTravel = true;
		TheGameState.NextDay = TheGameState.CurrentDay + 1;
		SendPlayerTo(player, StartNextDayURL);
		}
	else
		{
		// This shouldn't happen because the end-of-game movie
		// should end up calling EndOfGame() instead.  If it does
		// happen we'll treat it like a quit.
		QuitGame();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Send player to jail.  Each time the player goes to jail, he's put in a
// different cell.  The jail map must contain a series of Telepads named
// "cell1" through "celln" where 'n' is LAST_JAIL_CELL_NUMBER.
///////////////////////////////////////////////////////////////////////////////
function SendPlayerToJail(PlayerController player)
	{
	local P2Pawn ppawn;

	// Keep using a higher jail cell number until we reach the last one
	if (TheGameState.JailCellNumber < TheGameState.LastJailCellNumber)
		TheGameState.JailCellNumber++;

	// This doesn't travel, but just say that the player is going to jail
	// for the SendPlayer function
	TheGameState.bSendingPlayerToJail=true;

	// Record that we were sent to jail
	TheGameState.TimesArrested++;

	// Mark his inventory to be taken on entry to the jail level
	TheGameState.bTakePlayerInventory=true;

	// Give him up to full health (not if he's already over 100%)
	ppawn = P2Pawn(Player.Pawn);
	if(ppawn != None
		&& ppawn.Health < ppawn.HealthMax)
		ppawn.Health = ppawn.HealthMax;

	// Reset the cop radio--you're not wanted anymore
	TheGameState.ResetCopRadioTime();

	//log(self$" cop radio time "$TheGameState.CopRadioTime);
	// Send player to the appropriate jail cell
	SendPlayerTo(player, JailURL $ TheGameState.JailCellNumber $ "?peer");
	}

///////////////////////////////////////////////////////////////////////////////
// Figure out what the next day would be
///////////////////////////////////////////////////////////////////////////////
function int NextDay()
	{
	if (TheGameState.bChangeDayPostTravel)
		return TheGameState.NextDay;
	return TheGameState.CurrentDay;
	}

///////////////////////////////////////////////////////////////////////////////
// Returns true if player will be diverted home given the specified URL and
// telepad flag.  Other conditions are also taken into account when making
// this decision.
///////////////////////////////////////////////////////////////////////////////
function bool WillPlayerBeDivertedHome(String URL, bool bRealLevelExit)
	{

	return IsPlayerReadyForHome() &&	// Only if he's ready to go home
			bRealLevelExit &&			// Only if it's a real level transition
			!bIsDemo					// Never do this for the demo version
			&& !AfterFinalErrand();		// It's Day 5, we're done with the last errand, so
										// don't send him straight home--make him walk there
	}

///////////////////////////////////////////////////////////////////////////////
// The player is back at his trailer and checking to see if he's ready to go
// something different. He can beat the game, beat the demo
///////////////////////////////////////////////////////////////////////////////
function AtPlayerHouse(P2Player p2p)
{
	if(AfterFinalErrand())
	{
		if(bIsDemo)
		{
			// You beat the demo, so go to the end demo screen
			// FIXME: This works but it's a pretty clunky way to handle this.
			// Maybe we should change the demo so you are taken home-at-night
			// when you're done, and then we'll show this screen afterwards.
			// Or something like that.
			P2RootWindow(p2p.Player.InteractionMaster.BaseMenu).BeatDemo();
		}
		else 
		{
			// End the apocalypse now that you made it to your house.. shew!
			// Also keeps it from raining cats during the ending movie.
			TheGameState.bIsApocalypse=false;
			// You beat the game! Now go to home at night. The home at 
			// night map will have a different move to play for the end of game sequence,
			// will then show you stat screen, and will then spit you out to the credit menu
			// at which point you'll be back to the normal menu and have been through the whole game.
			SendPlayerTo(p2p, FinishedDayURL);
		}
	}
	else if(IsPlayerReadyForHome())	// If we're at your house and you're ready for home, then send you there.
	{
		SendPlayerTo(p2p, FinishedDayURL);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check if we're in the "pre-game" mode (main menu, intro, etc.)
///////////////////////////////////////////////////////////////////////////////
function bool IsPreGame()
	{
	if (TheGameState != None)
		return TheGameState.bPreGameMode;
	// There should always be a gamestate during the game, so the lack thereof
	// would indicate a non-game mode, which we'll treat as "pre-game".
	return true;
	}

///////////////////////////////////////////////////////////////////////////////
// Check if the current map is the "intro" map
///////////////////////////////////////////////////////////////////////////////
function bool IsIntroMap()
	{
	return ParseLevelName(Level.GetLocalURL()) ~= ParseLevelName(IntroURL);
	}

///////////////////////////////////////////////////////////////////////////////
// Check if the current map is the "finished day" map
///////////////////////////////////////////////////////////////////////////////
function bool IsFinishedDayMap()
	{
	return ParseLevelName(Level.GetLocalURL()) ~= ParseLevelName(FinishedDayURL);
	}


//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Days and errands
//
//=================================================================================================
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// Returns true if player is ready to go home.  In other words, have all the
// day's errands been completed?
///////////////////////////////////////////////////////////////////////////////
function bool IsPlayerReadyForHome()
	{
	// If todays errands are completed then he's ready to go home
	// Using >= instead of == for testing/debugging where we set all
	// errands complete, regardless of whether they are active or not.
	return TheGameState.ErrandsCompletedToday >= Days[TheGameState.CurrentDay].NumActiveErrands();
	}

///////////////////////////////////////////////////////////////////////////////
// This is *THE* function for checking whether an errand has been completed.
//
// Is is called by various locations in the code where an errand could possibly
// be completed due to a particular action or pickup or whatever else might
// complete an errand.
//
// If an errand is completed by the action/pickup/whatever, then the errand
// is marked as completed and the map screen is brought up to cross it off.
///////////////////////////////////////////////////////////////////////////////
function bool CheckForErrandCompletion(
	Actor Other,
	Actor Another,
	Pawn ActionPawn,
	P2Player ThisPlayer,
	bool bPremature)
	{
	local bool bCompleted;
	local int Errand;
	local name CompletionTrigger;
	local name HateClass;
	local name HateDesTex;
	local name HatePicTex;
	
	if(TheGameState == None)
		return false;

	// Check if the specified stuff has completed an errand.  Note that
	// this function will actually mark the errand as completed, so it's
	// a one-shot thing (it will return "true" once and then will return
	// "false" if called again with the same parameters).
	bCompleted = Days[TheGameState.CurrentDay].CheckForErrandCompletion(
		Other,
		Another,
		ActionPawn,
		bPremature,
		TheGameState,
		Errand,				// OUT: which errand was completed
		CompletionTrigger);	// OUT: name of trigger that must occur
	
	if(bCompleted)
		{
		TheGameState.ErrandsCompletedToday++;
		SaveCompletedErrand(TheGameState.CurrentDay, Errand);

		// Make sure to have a player when bringing up the map.
		if(ThisPlayer == None)
			ThisPlayer = GetPlayer();

		// Display the map to cross out the errand
		ThisPlayer.DisplayMapCrossOut(Errand, CompletionTrigger);
		}
	
	return bCompleted;
	}

 ///////////////////////////////////////////////////////////////////////////////
// Add all of our haters (usually only one) for this day. This only adds them
// and makes them start hating you. It doesn't force the map to come up and tell
// the player about them. This happens at the next level transition.
///////////////////////////////////////////////////////////////////////////////
function AddTodaysHaters()
{
	local int i;
	local P2Player ThisPlayer;
	
	ThisPlayer = GetPlayer();

	if(Days.Length > TheGameState.CurrentDay)
		Days[TheGameState.CurrentDay].AddMyHaters(TheGameState, ThisPlayer);
}


///////////////////////////////////////////////////////////////////////////////
// Go through all the errands and see if they care about this actor, as
// marked by the errand ignoretag.
///////////////////////////////////////////////////////////////////////////////
function bool ErrandIgnoreThisTag(Actor Other)
	{
	local int i;
	
	for(i = 0; i < Days.Length; i++)
		{
		if(Days[i] != None)
			{
			if(Days[i].IgnoreThisTag(Other))
				return true;
			}
		}
	
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Check if the specified errand is complete.
///////////////////////////////////////////////////////////////////////////////
function bool IsErrandCompleted(String UniqueName)
	{
	local int Day;
	local int Errand;

	if (FindErrand(UniqueName, Day, Errand))
		{
		if (Days[Day].IsErrandComplete(Errand))
			return true;
		}
	else
		Warn("P2GameInfoSingle.IsErrandCompleted(): Couldn't find errand with UniqueName="$UniqueName);
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Make sure the day we're on even has this errand
///////////////////////////////////////////////////////////////////////////////
function bool CorrectDayForErrand(String UniqueName, String DayName, bool bCheckForCompletion)
{
	local int Day;
	local int Errand;

	for(Day = 0; Day < Days.Length; Day++)
	{
		if(Days[Day].UniqueName == DayName)
		{
			Errand = Days[Day].FindErrand(UniqueName);
			if (Errand >= 0)
			{
				// We've found it (the errand exists on this day) now either say yes now
				// or check if they also want completion
				if(bCheckForCompletion)
				{
					return (Days[Day].IsErrandComplete(Errand));
				}
				else
					return true;
			}
		}
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Activate the specified errand.
///////////////////////////////////////////////////////////////////////////////
function ActivateErrand(String UniqueName)
	{
	local int Day;
	local int Errand;
	local int i;

	if (!TheGameState.bIsApocalypse &&
		FindErrand(UniqueName, Day, Errand))
		{
		Days[Day].ActivateErrand(Errand);
		// Add activated errand to list
		i = TheGameState.ActivatedErrands.Length;
		TheGameState.ActivatedErrands.Insert(i, 1);
		TheGameState.ActivatedErrands[i].Day = Day;
		TheGameState.ActivatedErrands[i].Errand = Errand;
		}
	else
		Warn("P2GameInfoSingle.ActiveErrand(): ERROR: Couldn't find errand with UniqueName="$UniqueName);
	}

///////////////////////////////////////////////////////////////////////////////
// Check if the specified errand is active.
///////////////////////////////////////////////////////////////////////////////
function bool IsErrandActivate(String UniqueName)
	{
	local int Day;
	local int Errand;

	if (FindErrand(UniqueName, Day, Errand))
		{
		if (Days[Day].IsErrandActive(Errand))
			return true;
		}
	else
		Warn("P2GameInfoSingle.IsErrandCompleted(): Couldn't find errand with UniqueName="$UniqueName);
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Find errand using its unique name.  The function returns true if the errand
// was found, in which case the Day and Errand indices are valid.  Otherwise
// it returns false and those values should not be used.
///////////////////////////////////////////////////////////////////////////////
function bool FindErrand(String UniqueName, out int Day, out int Errand)
	{
	for(Day = 0; Day < Days.Length; Day++)
		{
		Errand = Days[Day].FindErrand(UniqueName);
		if (Errand >= 0)
			return true;
		}
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Get current day index
///////////////////////////////////////////////////////////////////////////////
function int GetCurrentDay()
	{
	return TheGameState.CurrentDay;
	}

///////////////////////////////////////////////////////////////////////////////
// Get current day
///////////////////////////////////////////////////////////////////////////////
function DayBase GetCurrentDayBase()
	{
	return Days[TheGameState.CurrentDay];
	}

///////////////////////////////////////////////////////////////////////////////
// Check whether the current day matches the specified name
///////////////////////////////////////////////////////////////////////////////
function bool IsDay(String UniqueName)
	{
	return GetCurrentDayBase().UniqueName ~= UniqueName;
	}

///////////////////////////////////////////////////////////////////////////////
// Make sure it's the final day and all of our errands are done.
// *Doesn't* check to make sure it's not the demo.
///////////////////////////////////////////////////////////////////////////////
function bool AfterFinalErrand()
{
	// Last day of the real game and you're done with your errands
	return ((TheGameState.CurrentDay == Days.Length - 1)
			&& TheGameState.ErrandsCompletedToday >= Days[TheGameState.CurrentDay].NumActiveErrands());
}

///////////////////////////////////////////////////////////////////////////////
// Check to make sure at least every errand has one goal
// Only to be called in an init.
///////////////////////////////////////////////////////////////////////////////
function CheckForValidErrandGoals()
	{
	local int i;
	
	for(i = 0; i < Days.Length; i++)
		{
		if(Days[i] != None)
			Days[i].CheckForValidErrandGoals();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Save errand in the GameState so it will persist
///////////////////////////////////////////////////////////////////////////////
function SaveCompletedErrand(int Day, int Errand)
	{
	local int i;
	
	// Add completed errand to list
	i = TheGameState.CompletedErrands.Length;
	TheGameState.CompletedErrands.Insert(i, 1);
	TheGameState.CompletedErrands[i].Day = Day;
	TheGameState.CompletedErrands[i].Errand = Errand;
	}

///////////////////////////////////////////////////////////////////////////////
// Restore day and its errands using the info stored in the GameState.
//
// DayBase and ErrandBase are Objects (not Actors) so they are not destroyed
// or affected in any way by traveling between levels or by loading saved
// games.  This leads to situations where the information in those objects
// does not match the information in the GameState.  For instance, you save
// just before you complete an errand.  Then you complete the errand, so it's
// marked "complete" in the ErrandBase and it's also recorded in the GmeState.
// Now you load the game you saved just before completing the errand.  The
// GameState will say the errand is NOT complete (which is correct) while the
// ErrandBase will still say the errand is complete (which is incorrect).  A
// similar situation can occur when traveling between levels.
//
// Calling this function updates the current DayBase and all of it's
// ErrandBase objects to match the information in the GameState.
///////////////////////////////////////////////////////////////////////////////
function RestoreDayAndErrands()
	{
	local int i;

	// Reset day (day objects are not destroyed by traveling)
	Days[TheGameState.CurrentDay].PostTravelReset();

	// Reset errands (errand objects are not destroyed by traveling)
	for (i = 0; i < Days[TheGameState.CurrentDay].Errands.Length; i++)
		Days[TheGameState.CurrentDay].Errands[i].PostTravelReset();

	// Complete each errand in the completed list and update the count to ensure it's correct
	TheGameState.ErrandsCompletedToday = 0;
	for (i = 0; i < TheGameState.CompletedErrands.Length; i++)
		{
		Days[TheGameState.CompletedErrands[i].Day].Errands[TheGameState.CompletedErrands[i].Errand].PostTravelSetComplete();
		if (TheGameState.CompletedErrands[i].Day == TheGameState.CurrentDay)
			TheGameState.ErrandsCompletedToday++;
		}

	// Activate each errand in the activated list.
	for (i = 0; i < TheGameState.ActivatedErrands.Length; i++)
		Days[TheGameState.ActivatedErrands[i].Day].ActivateErrand(TheGameState.ActivatedErrands[i].Errand);
	}


//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Apocolypse stuff
//
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// Begin end sequence for single player game.
// * Set Gamestate to know Apocalypse is soooooo on!
// * Grant dude new Apocalypse newspaper and make him view it (to understand
// what's happening.
// * Go through level and make everyone guncrazy, give them a weapon and start
// the fun!
///////////////////////////////////////////////////////////////////////////////
function StartApocalypse()
{
	local Inventory thisinv;
	local P2PowerupInv pinv;
	local byte CreatedNow;
	local P2Player p2p;

	if(!TheGameState.bIsApocalypse
		&& !bIsDemo	// Never do this for the demo version
		&& AfterFinalErrand())
	{
		p2p = GetPlayer();
		// Set it
		TheGameState.bIsApocalypse = true;
		// Give him a newspaper in case he doesn't have one
		thisinv = p2p.MyPawn.CreateInventory("Inventory.NewspaperInv", CreatedNow);
		if(CreatedNow == 0)
			// Request that it comes up if we already had a newspaper (so we always see it)
			// otherwise, just giving it to him will make it come up
			p2p.RequestNews();
		// Set everyone into riot mode
		ConvertAllPawnsToRiotMode();
		// Change the sky to scary fire clouds
		ChangeSkyByDay();
		// Put into run mode for the apocalypse
		GotoState('RunningApocalypse');
	}
}

///////////////////////////////////////////////////////////////////////////////
// Goes through the level and changes all NPCs to riot mode (done by controllers)
///////////////////////////////////////////////////////////////////////////////
function ConvertAllPawnsToRiotMode()
{
	local P2Pawn ppawn;
	local PersonController pcont;

	log(self$" ConvertAllPawnsToRiotMode	00000000000000000000000000");
	// Find everyone in the level and zap them
	foreach DynamicActors(class'P2Pawn', ppawn)
	{
		pcont = PersonController(ppawn.Controller);
		if(pcont != None)
		{
			pcont.ConvertToRiotMode();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Get the appropriate texture for the newspaper to fly to the screen for the 
// appropriate day. Except for the apocalypse paper which takes a special
// one regardless of the day.
///////////////////////////////////////////////////////////////////////////////
function Texture GetNewsTexture()
{
	if(TheGameState.bIsApocalypse)
	{
		return Texture(DynamicLoadObject(String(ApocalypseTex), class'Texture'));
	}
	else
		return GetCurrentDayBase().GetNewsTexture();
}

///////////////////////////////////////////////////////////////////////////////
// Get the dude comment on this day's newspaper or the Apocalypse. Like above
// the texture.
///////////////////////////////////////////////////////////////////////////////
function Sound GetDudeNewsComment()
{
	if(TheGameState.bIsApocalypse)
	{
		return Sound(DynamicLoadObject(String(ApocalypseComment), class'Sound'));
	}
	else
		return GetCurrentDayBase().GetDudeNewsComment();
}


//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Cheats
//
//=================================================================================================
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// For testing, reset cops so you aren't wanted any more
///////////////////////////////////////////////////////////////////////////////
exec function ResetCops()
	{
	Log("CHEAT: ResetCops()");

	// Reset the cop radio so you aren't wanted any more
	TheGameState.ResetCopRadioTime();
	}

///////////////////////////////////////////////////////////////////////////////
// Change player to opposite of his current morality
///////////////////////////////////////////////////////////////////////////////
exec function ChangeDude()
	{
	TheGameState.bNiceDude = !TheGameState.bNiceDude;

	Log("CHEAT: ChangeDude(): bNiceDude is now "$TheGameState.bNiceDude);

	// Send player to the same level he's already on, but when he gets there
	// he will be opposite to the morality he started with.
	SendPlayerTo(GetPlayer(), ParseLevelName(Level.GetLocalURL()));
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, go to the specified map.  This should ALWAYS be used instead
// of unreal's built-in "open" command.
///////////////////////////////////////////////////////////////////////////////
exec function Goto(String LevelName)
	{
	Log("CHEAT: Goto() LevelName="$LevelName);

	SendPlayerTo(GetPlayer(), LevelName);
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set the day you want to test and the current level will be
// "reloaded" for that day.
///////////////////////////////////////////////////////////////////////////////
exec function WarpToDay(int day)
	{
	Log("CHEAT: WarpToDay() day="$day);

	TheGameState.NextDay = day - 1;
	TheGameState.NextDay = Min(TheGameState.NextDay, Days.Length - 1);
	TheGameState.NextDay = Max(TheGameState.NextDay, 0);
	TheGameState.bChangeDayPostTravel = true;
	TheGameState.bChangeDayForDebug = true;

	// Send player to the same level he's already on, but when he gets there
	// it will be the specified day.
	SendPlayerTo(GetPlayer(), ParseLevelName(Level.GetLocalURL()));
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set the day you want to warp to. All errands before that day
// will be completed, along with anything you're supposed to retain
///////////////////////////////////////////////////////////////////////////////
exec function SetDay(int day)
	{
	local P2Player p2p;
	local int startday, i;
	local Inventory inv, oldinv;

	Log("CHEAT: SetDay() day="$day);

	p2p = GetPlayer();

	TheGameState.NextDay = day - 1;
	TheGameState.NextDay = Min(TheGameState.NextDay, Days.Length - 1);
	TheGameState.NextDay = Max(TheGameState.NextDay, 0);
	TheGameState.bChangeDayPostTravel = true;
	TheGameState.bChangeDayForDebug = true;

	log(self$" Current day "$TheGameState.CurrentDay$" new day "$day - 1);
	// If you're going back in time, then remove all your inventory and start from
	// monday forward to your new day.
	if(TheGameState.CurrentDay > day - 1)
	{
		log(self$" going back ");
		inv = p2p.MyPawn.Inventory;
		while(inv != None)
		{
			oldinv = inv.Inventory;
			p2p.MyPawn.DeleteInventory(inv);
			inv = inv.Inventory;
		}
		p2p.MyPawn.Inventory = None;
		startday = -1;	// This is -1 instead of 0, so the code below will first
		// remove the items the for current day, then take us back to Monday(0). To 
		// handle this case and the normal case of going forward through time, the 
		// loop before needs to be one past the start day. 
		
		// Also, reset all the errands that have been completed.
		SetAllErrandsUnComplete();
	}
	else if(TheGameState.CurrentDay < day - 1)
	{
		log(self$" going forward ");
		startday = TheGameState.CurrentDay;
		// Set this day's errands complete
		SetTodaysErrandsComplete();
	}
	else// Resetting the same day
	{
		log(self$" same day ");
		startday = TheGameState.CurrentDay;
		// Also, reset all the errands that have been completed.
		SetAllErrandsUnComplete();
	}

	// Go through your inventory, and give all things needed for each
	// day, then remove all things to be removed for that day. Do this between
	// the day you're on and the day you've picked.

	// You've already been given everything for this day, so just remove things for this day
	Days[TheGameState.CurrentDay].TakeInventoryFromPlayer(p2p.MyPawn);
	for(i=startday+1; i < day - 1; i++)
	{
		log(self$" intermediate day "$i);
		// Give him all things for that day
		Days[i].AddInStartingInventory(p2p.MyPawn);
		// Take away all necessary things
		Days[i].TakeInventoryFromPlayer(p2p.MyPawn);
		// Set those errands complete
		SetThisDaysErrandsComplete(i);
	}

	// Send player to the same level he's already on, but when he gets there
	// it will be the specified day.
	SendPlayerTo(p2p, ParseLevelName(Level.GetLocalURL()));
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set all errands as complete
// Turns on hate-player-groups too--Apocalypse!
///////////////////////////////////////////////////////////////////////////////
exec function SetAllErrandsComplete()
	{
	local int i,j;

	Log("CHEAT: SetAllErrandsComplete()");

	for (i = 0; i < Days.Length; i++)
		SetThisDaysErrandsComplete(i);
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, reset all the errands and make hate groups not hate you anymore
//
// Warning!!
// May not work for 'write-in' errands!
//
///////////////////////////////////////////////////////////////////////////////
exec function SetAllErrandsUnComplete()
	{
	local int i,j;

	Log("CHEAT: SetAllErrandsUnComplete()");

	for (i = 0; i < Days.Length; i++)
		for (j = 0; j < Days[i].Errands.Length; j++)
			Days[i].Errands[j].ForceUnCompletion(TheGameState);

	// Remove all items from list
	TheGameState.CompletedErrands.Remove(0, TheGameState.CompletedErrands.Length);
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set all of today's errands as complete
// Turns on hate-player-groups too
///////////////////////////////////////////////////////////////////////////////
exec function SetTodaysErrandsComplete()
	{
	Log("CHEAT: SetTodaysErrandsComplete() TheGameState.CurrentDay="$TheGameState.CurrentDay);

	SetThisDaysErrandsComplete(TheGameState.CurrentDay);
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set all of the specified day's errands as complete
// Turns on hate-player-groups too
///////////////////////////////////////////////////////////////////////////////
function SetThisDaysErrandsComplete(int DayI)
	{
	local int j;

	for (j = 0; j < Days[DayI].Errands.Length; j++)
		SetThisErrandComplete(Days[DayI].Errands[j].UniqueName);
	}

///////////////////////////////////////////////////////////////////////////////
// For testing, set this unique errand complete
// Turns on hate-player-groups too
///////////////////////////////////////////////////////////////////////////////
exec function SetThisErrandComplete(String UniqueName)
	{
	local int DayI, ErrandI;

	Log("CHEAT: SetThisErrandComplete() UniqueName="$UniqueName);

	FindErrand(UniqueName, DayI, ErrandI);
	if(DayI >= 0 && ErrandI >= 0)
		{
		if (!Days[DayI].IsErrandComplete(ErrandI))
			{
			Days[DayI].Errands[ErrandI].ForceCompletion(TheGameState, GetPlayer());
			SaveCompletedErrand(DayI, ErrandI);
			if (DayI == TheGameState.CurrentDay)
				TheGameState.ErrandsCompletedToday++;
			}
		else
			Log("SetThisErrandComplete(): errand already complete -- ignored");
		}
	else
		Log("SetThisErrandComplete(): errand not found -- ignored");
	}

///////////////////////////////////////////////////////////////////////////////
// Reach into gamestate to do this.
// Reset any hints for inventory/weapons, so that they will show up again
///////////////////////////////////////////////////////////////////////////////
function ClearInventoryHints()
{
	if(TheGameState != None)
		TheGameState.ClearInventoryHints();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function PreloadSpawnerSkinAndMesh(Actor CheckA)
{
	local int i;
	if(CheckA != None)
	{
		if(CheckA.Skins.Length > 0
			&& CheckA.Skins[0] != None)
		{
			i = SpawnerMaterials.Length;
			SpawnerMaterials.Insert(i, 1);
			SpawnerMaterials[i] = CheckA.Skins[0];
			//log(self$" preloaded tex "$SpawnerMaterials[i]);
		}
		if(CheckA.Mesh != None)
		{
			i = SpawnerMeshes.Length;
			SpawnerMeshes.Insert(i, 1);
			SpawnerMeshes[i] = CheckA.Mesh;
			//log(self$" preloaded mesh "$SpawnerMeshes[i]);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Possibly preload the models/textures to prevent a framehitch when the spawner
// spawns for the first time in a level.
///////////////////////////////////////////////////////////////////////////////
function PreloadSpawnerAssets(Spawner CheckS)
{
	local P2MocapPawn p2m;

	if(PawnSpawner(CheckS) != None)
	{
		//log(self$" class "$CheckS.SpawnClass);
		if(ClassIsChildOf(CheckS.SpawnClass, class'P2MocapPawn'))
		{
			// Force it to spawn now, so we can have it get all the proper skins/meshes for us
			p2m = P2MocapPawn(spawn(CheckS.SpawnClass,,,CheckS.Location,,CheckS.SpawnSkin));

			//log(self$" spawned "$p2m$" skin "$p2m.Skins[0]$" mesh "$p2m.Mesh);

			if(p2m != None)
			{
				// Save the body skin and mesh
				PreloadSpawnerSkinAndMesh(p2m);
				//log(self$" head "$p2m.MyHead);
				// Save the head skin, mesh
				PreloadSpawnerSkinAndMesh(p2m.MyHead);
				// Get rid of the temp pawn
				p2m.Destroy();
				p2m = None;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Go through all the actors in the level and decide if they belong in the
// level or not.
// If they have no day specified in their group, it means they want to 
// be used in all the days. This is true for most actors in a level.
//
// Make sure the objects to be removed here are marked bNoDelete==false
// Also, no static objects will be allowed to take advantage of this. They will
// automatically remain in every day.
//
// DayBlockers and single paths from pathnodes should be used to make
// dynamically changing paths.
//
// Handle also, anything particular to the type of dude the player picked.
// Handle difficulty based items placed only for certain difficulties (more
// weapons on lower diffs, more enemies on higher, etc.)
//
// Connect all the pawns in the level to each other, so that each pawn will wake
// a different one up when they die. (Wake them up from stasis)
//
///////////////////////////////////////////////////////////////////////////////
function PrepActorsByGroup()
{
	local Actor CheckA;
	local FPSPawn LastPawn, FirstPawn;
	local byte Needed, NeededForDude, NeededForDay, NeededForDifficulty, NeededForDetail, SpecifiedDay;
	local bool bEnhanced;
	
	bEnhanced=VerifySeqTime();

	// Go through all the actors and check what days they need to be in
	foreach AllActors(class'Actor', CheckA)
	{
		// Modify any static meshes as necessary
		CheckStaticMesh(StaticMeshActor(CheckA));

		// Check if we want it for this day
		NeededForThisDay(CheckA, NeededForDay, SpecifiedDay);

		// Dude check
		NeededForThisStringBool(CheckA, TheGameState.bNiceDude, GOOD_GUY_GROUP, BAD_GUY_GROUP, NeededForDude);

		// Difficulty check
		NeededForThisStringBool(CheckA, InEasyMode(), EASY_GROUP, HARD_GROUP, NeededForDifficulty);

		// Check if we want it for this detail setting.
		NeededForThisDetail(CheckA, NeededForDetail);

		// Allow this thing only if we're playing the right dude on the right day.
		Needed = NeededForDay & NeededForDude & NeededForDifficulty & NeededForDetail;

		if(Needed == 0)
		{
			// Don't let the player start be deleted. It's the only thing that should have all the days in it
			// if it has monday-friday, plus demo, it will want to be deleted. But we check here to make specifically
			// sure it's not
			//log(self$" not needed "$CheckA);
			if(PlayerStart(CheckA) == None)
			{
				//log(CheckA$" not needed for day "$TheGameState.CurrentDay$" check group "$CheckA.Group$" static for me "$CheckA.bStatic$" bnodelete "$CheckA.bNoDelete);
				
				if(Telepad(CheckA) != None)
				{
					CheckA.SetCollision(false, false, false);
				}
				else if(PathNode(CheckA) != None)
				{
					// if it was a path node, don't delete these, just block them
					PathNode(CheckA).bBlocked=true;
					//log(CheckA$" set to block as "$PathNode(CheckA).bBlocked);
				}
				// Delete weapons per day in normal mode
				else if(P2WeaponPickup(CheckA) != None)
				{
					if(!bEnhanced)
						// Now delete the actual actor
						CheckA.Destroy();
				}
				// Delete all other objects
				else
				{
					// if it's actually a pawn, check to destroy it's controller first
					if(Pawn(CheckA) != None)
					{
						//log(CheckA$" destroyed my controller too "$Pawn(CheckA).Controller);
						if(Pawn(CheckA).Controller != None)
							Pawn(CheckA).Controller.Destroy();
					}
				
					// Now delete the actual actor
					CheckA.Destroy();
				}
			}
			else
			{
				PlayerStart(CheckA).SetCollision(false, false, false);
			}
		}
		else// We're going to keep these objects (they are Needed for this day)
		{
			// Make sure paths aren't blocked when used
			if(PathNode(CheckA) != None)
			{
				PathNode(CheckA).bBlocked=false;
			}
			// Enforce collision on dayblockers. They are used specifically for keeping
			// people from going past things.
			else if(DayBlocker(CheckA) != None)
			{
				CheckA.bBlockNonZeroExtentTraces=true;
				CheckA.bBlockZeroExtentTraces=true;
			}				
			else if(FPSPawn(CheckA) != None)
			{
				// If we're keeping this pawn, get him ready for this difficulty
				FPSPawn(CheckA).SetForDifficulty(GameDifficulty);

				if(!FPSPawn(CheckA).bPlayer)
				{
					if(FirstPawn == None)
						FirstPawn = FPSPawn(CheckA);

					FPSPawn(CheckA).StasisPartner = LastPawn;
					LastPawn = FPSPawn(CheckA);
				}
			}
			// If we're a spawner, check to preload our assets to fix the framehitch
			else if(Spawner(CheckA) != None)
			{
				PreloadSpawnerAssets(Spawner(CheckA));
			}
		}

	}

	// Link the stasis pawns
	if(FirstPawn != None)
	{
		FirstPawn.StasisPartner = LastPawn;
	}
}

///////////////////////////////////////////////////////////////////////////////
// For the pawns on this day, in this level, for any with bUsePawnSlider set to
// true if the total number of them active is above the goal, it puts them in
// SliderStasis. It does this for as long as their are more pawns that are active
// than the goal says. It tries to randomly find them, and may go through the
// entire list of pawns more than once. It does this to get a better distribution
// of pawns to have active in a level. Simply going through the pawns in the level
// and allowing the first X pawns to be active would result in very lopsided distribution.
///////////////////////////////////////////////////////////////////////////////
function PrepSliderPawns()
{
	local FPSPawn fpawn;
	local int loopcount, userand, userange, rangehalf, hitcount;

	log(self$" PrepSliderPawns pawns active "$PawnsActive$" slider pawns to start with "$SliderPawnsActive);
	log(self$" This has the '1000000 iteration' bug fix vr 2.0");

	userange = SliderPawnsActive - SliderPawnGoal;
	rangehalf = userange/2;
	while(SliderPawnsActive > SliderPawnGoal)
	{
		//log(self$" PrepSliderPawns--loop count "$loopcount);
		foreach DynamicActors(class'FPSPawn', fpawn)
		{
			if(SliderPawnsActive > SliderPawnGoal)
			{
				userand = Rand(userange);
				//log(self$" userand is "$userand$" range "$userange$" half "$rangehalf);
				if(fpawn.bUsePawnSlider
					&& !fpawn.bPersistent
					&& !fpawn.bSliderStasis
					&& LambController(fpawn.Controller) != None
					&& userand >= rangehalf)
				{
					//log(self$" turning off "$fpawn);
					LambController(fpawn.Controller).GoIntoSliderStasis();
					userange = SliderPawnsActive - SliderPawnGoal;
					rangehalf = userange/2;
				}
				//else
				//{
				//	log(self$" leaving "$fpawn$" at "$fpawn.Location$" SliderPawnsActive "$SliderPawnsActive);
				//}
				hitcount++;
				//log(self$" Hit Count: "$hitcount);
			}
			else
				break;	// get out of loop now

			if(hitcount > 5000)
			{
				log(self$" HIT COUNT BREAKING.... INFINITE LOOP STOPPED");
				return; // quick break for testing.
			}
		}
		loopcount++;
	}
	log(self$" PrepSliderPawns DONE!");
}

///////////////////////////////////////////////////////////////////////////////
// Check to remove this pickup from the GottenPickups list.
///////////////////////////////////////////////////////////////////////////////
function FindInPickupList(Pickup DelMe, String Lname)
{
	local int i;

	for(i=0; i<TheGameState.GottenPickups.Length; i++)
	{
		//log(self$" RemoveGottenPickups, GottenPickups "$TheGameState.GottenPickups[i].PickupName);
		//log(self$" for level "$TheGameState.GottenPickups[i].LevelName$" checking... "$TheGameState.GottenPickups[i].PickupName$" against "$DelMe.name);
		if(TheGameState.GottenPickups[i].PickupName == DelMe.name
			&& TheGameState.GottenPickups[i].LevelName == Lname)
		{
			//log(self$"												Removing "$DelMe);
			DelMe.Destroy();
			DelMe = None;
			break;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//
// Go through all the pickups in the level, and remove any that have been
// previously taken by the dude.
//
///////////////////////////////////////////////////////////////////////////////
function RemoveGottenPickups()
{
	local Pickup CheckP, DelMe;
	local String Lname;

	Lname = ParseLevelName(Level.GetLocalURL());

	log(self$" RemoveGottenPickups, gottenpickups length "$TheGameState.GottenPickups.Length);

	foreach AllActors(class'Pickup', CheckP)
	{
		DelMe = CheckP;
		//log(self$" RemoveGottenPickups "$DelMe);
		// If you're not allowed to be recorded, you're not allowed to be restored
		if((P2WeaponPickup(DelMe) != None
				&& P2WeaponPickup(DelMe).bRecordAfterPickup)
			|| (P2PowerupPickup(DelMe) != None
					&& P2PowerupPickup(DelMe).bRecordAfterPickup)
			|| (P2AmmoPickup(DelMe) != None
					&& P2AmmoPickup(DelMe).bRecordAfterPickup))
		{
			FindInPickupList(DelMe, Lname);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
function NeededForThisDay(Actor CheckA, out byte Needed, out byte SpecifiedDay)
	{
	local int i, dayI;
	local string GroupString;
	local bool bExcluded;

	Needed=0;
	SpecifiedDay=0;
	GroupString = Caps(CheckA.Group);

	// If your name in your group list was specifically mentioned in the following
	// then it will not be needed for this day
	if(Days.Length > 0)
	{
		dayI=0;
		while(dayI < Days[TheGameState.CurrentDay].ExcludeDays.Length)
		{
			i = InStr(GroupString, Days[TheGameState.CurrentDay].ExcludeDays[dayI]);
			if(i >= 0)
			{
				bExcluded=true;	// Record that it was excluded
			}
			dayI++;
		}
	}

	// Now go through and check to see if this object is needed
	// for this day, or has a specified day
	dayI=0;
	while(dayI < Days.Length)
	{
		i = InStr(GroupString, Days[dayI].UniqueName);

		if(i >= 0)
		{
			SpecifiedDay = 1;
			if(TheGameState.CurrentDay == dayI)
			{
				Needed = 1;
			}
		}
		dayI++;
	}

	// If they didn't specify a day, and you we're specifically excluded
	// then it means they're wanted for all days.
	if(SpecifiedDay == 0
		&& !bExcluded)
		Needed=1;

	//log(CheckA$" needed "$Needed$" SpecifiedDay "$SpecifiedDay$" dayI "$dayI$" GroupString "$GroupString);

	/*
	// Old method:
// This checks the group variable for string listings of the various days
// this object is in. If no days are listed, it's assumed to be needed
// for all days.
// Days are listed in the following format:
// DAY_$
// where $ is a letter. So DAY_A means the first day. DAY_C means the third day.
// The days can go from A to Z, and currently no further. So the max days is 26
// from the letters in the alphabet. Sorry, if you want a month in the dude's life
// you gotta code it yourself.
	GroupString = Caps(CheckA.Group);
	tlen = Len(GroupString);
	
	Needed=1;	// default it to needed
	SpecifiedDay=0;
	
	//	log(CheckA$" check my groups");
	while(i >= 0)
		{
		//		log(CheckA$"using this string "$GroupString);
		i = InStr(GroupString, DAY_STR);
		if(i < 0)	// no days were in this string
			{
			//			log(CheckA$" stopping check "$i);
			}
		else	// at some point, a day was specified
			{
			// Now that a day was specified, say it's not needed, 
			// until the specific day is found
			SpecifiedDay=1;
			Needed=0;
			
			//log(CheckA$" asc: "$Asc(Mid(GroupString, i+DAY_STR_LEN, 1)));
			//log(CheckA$" number for day "$Asc(Mid(GroupString, i+DAY_STR_LEN, 1)) - DAY_START_ASCII);
			
			// This day is specified, so say this is needed and quit
			if(CurrentDay == Asc(Mid(GroupString, i+DAY_STR_LEN, 1)) - DAY_START_ASCII)
				{
				Needed=1;
				i=-1;	// quit
				}
			else
				GroupString = Mid(GroupString, i+DAY_STR_LEN, tlen);
			}
		}
		*/
	}

///////////////////////////////////////////////////////////////////////////////
// Checks if the dude playing is opposite the one specified in the object.
// If so, it sets Needed to 0. Otherwise, it sets it to 1.
///////////////////////////////////////////////////////////////////////////////
function NeededForThisDude(Actor CheckA, bool bNiceDude, out byte Needed)
{
	local int i;
	local string GroupString;

	GroupString = Caps(CheckA.Group);

	//log(CheckA$"using this string "$GroupString);
	i = InStr(GroupString, GOOD_GUY_GROUP);
	// Nice dude listed in group, but we're playing the bad dude, so don't use it.
	if(i >= 0
		&& !bNiceDude)
	{
		//log(self$" good guy place "$i);
		Needed=0;
		return;
	}
	// Evil dude listed in group, but we're playing the nice dude, so don't use it.
	i = InStr(GroupString, BAD_GUY_GROUP);
	if(i >= 0
		&& bNiceDude)
	{
		//log(self$" bad guy place "$i);
		Needed=0;
		return;
	}
	// everything else is needed
	Needed=1;
}

///////////////////////////////////////////////////////////////////////////////
// Check if this actor is need for either of these group, StrTrue or StrFalse.
///////////////////////////////////////////////////////////////////////////////
function NeededForThisStringBool(Actor CheckA, bool bCheck, 
								 string StrTrue, string StrFalse, out byte Needed)
{
	local int i;
	local string GroupString;

	GroupString = Caps(CheckA.Group);

	i = InStr(GroupString, StrTrue);
	// Needed for true set, and we're set to false, so don't accept
	if(i >= 0
		&& !bCheck)
	{
		Needed=0;
		return;
	}

	i = InStr(GroupString, StrFalse);
	// Needed for true, but we're checking false, so don't accept.
	if(i >= 0
		&& bCheck)
	{
		Needed=0;
		return;
	}
	// everything else is needed
	Needed=1;
}

///////////////////////////////////////////////////////////////////////////////
// Check the detail level of things, if it's high, then remove certain items
///////////////////////////////////////////////////////////////////////////////
function NeededForThisDetail(Actor CheckA, out byte Needed)
{
	local int i;
	local string GroupString;

	// If this thing is for high detail only, and the game is not in high detail 
	// mode then remove it.
	if(CheckA.bHighDetail
		&& !bGameHighDetail)
		Needed = 0;
	else
		// everything else is needed
		Needed=1;
}

///////////////////////////////////////////////////////////////////////////////
// Go through all the items in this level and set appropriate ones
// to be checked for errand completion. Saves level designers having to remember
///////////////////////////////////////////////////////////////////////////////
function PrepPickupsForErrands()
	{
	local P2PowerupPickup powerpick;
//	local P2Player p2p;
	
	//log(self$" PrepPickupsForErrands");
	// Check off errands for all players
//	foreach DynamicActors(class'P2Player', p2p)
//		{
		foreach DynamicActors(class'P2PowerupPickup', powerpick)
			{
			//log("checking "$powerpick$" tag "$powerpick.tag);
			if(Days[TheGameState.CurrentDay].CheckForErrandUse(powerpick))
				{
				//log(self$" this is used for an errand "$powerpick);
				// Mark this powerup as necessary for an errand
				powerpick.bUseForErrands=true;
				}
			}
//		}
	}

///////////////////////////////////////////////////////////////////////////////
// If the gamestate's bTakePlayerInventory is set to true, take all the
// dude's inventory items. Then, go through all the weapon and powerup pickups 
// in the level, and for the matching classes with bForTransferOnly set to true,
// leave those be. For ones with bForTransferOnly set to true, but there is
// no matching item from the dude's inventory, destroy them now. Also,
// if gamestate's bTakePlayerInventory is set to false, then destroy all
// pickups with bForTransferOnly set to true.
///////////////////////////////////////////////////////////////////////////////
function CheckToTransferPlayerInventory()
{
	local P2PowerupPickup powerpick;
	local P2WeaponPickup weappick;
	local P2PowerupInv powerinv;
	local P2Weapon weapinv;
	local P2Player p2p;
	local P2Pawn usepawn, temppawn;

	// Get the dude controller
	p2p = GetPlayer();

	// Get the pawn out of that controller
	usepawn = p2p.MyPawn;

	// If a movie starting up on level load or something has prevented getting the player controller
	// at least get
	if(usepawn == None)
	{
		foreach AllActors(class'P2Pawn', temppawn)
		{
			//log(self$" pawn "$temppawn$" player "$temppawn.bPlayer);
			if(temppawn.bPlayer)
			{
				p2p = P2Player(temppawn.Controller);
				break;
			}
		}
	}
	
	// If we're not transferring, just destroy all marked powerups
	if(!TheGameState.bTakePlayerInventory)
	{
		foreach DynamicActors(class'P2PowerupPickup', powerpick)
		{
			if(powerpick.bForTransferOnly)
				powerpick.Destroy();
		}
		foreach DynamicActors(class'P2WeaponPickup', weappick)
		{
			if(weappick.bForTransferOnly)
				weappick.Destroy();
		}
	}
	else
	{
		// Go through all the powerups
		foreach DynamicActors(class'P2PowerupPickup', powerpick)
		{
			// If you are to remove them, check if the dude has the powerup
			if(powerpick.bForTransferOnly)
			{
				powerinv = P2PowerupInv(usepawn.FindInventoryType(powerpick.InventoryType));

				//log(self$" checking for "$powerpick.InventoryType$" has this "$powerinv);
				// He has it, so leave it, but transfer the count over.
				if(powerinv != None)
				{
					// Force it to drop them all
					powerinv.bThrowIndividually=false;

					// Transfer info from the inv to the pickup
					powerpick.InitDroppedPickupFor(powerinv);
					// Make sure it's persistent
					powerpick.bPersistent = true;

					// destroy the inventory for the dude
					powerinv.DetachFromPawn(powerinv.Instigator);	
					usepawn.DeleteInventory(powerinv);

					// If the powerup was marked to steal it from him, do so. This
					// means that for things like donuts or money, the cops will take
					// them from your inventory and you'll never get them back
					if(powerpick.bDestroyAfterTransfer)
						powerpick.Destroy();
				}
				else	// he doesn't so destroy it
					powerpick.Destroy();
			}
		}
		// Go through all the weapons
		foreach DynamicActors(class'P2WeaponPickup', weappick)
		{
			// If you are to remove them, check if the dude has the weapon
			if(weappick.bForTransferOnly)
			{
				weapinv = P2Weapon(usepawn.FindInventoryType(weappick.InventoryType));

				//log(self$" checking for "$weappick.InventoryType$" has this "$weapinv);
				// He has it, so leave it, but transfer the count over.
				if(weapinv != None)
				{
					// transfer info from the inv to the pickup
					weappick.InitDroppedPickupFor(weapinv);
					// Make sure it's persistent
					weappick.bPersistent = true;

					// First remove the ammo for this weapon from the dude
					weapinv.AmmoType.DetachFromPawn(weapinv.Instigator);	
					weapinv.AmmoType.Instigator.DeleteInventory(weapinv.AmmoType);
					// Then destroy the inventory for the dude
					weapinv.DetachFromPawn(weapinv.Instigator);	
					usepawn.DeleteInventory(weapinv);

					// If the powerup was marked to steal it from him, do so. This
					// means that for things like donuts or money, the cops will take
					// them from your inventory and you'll never get them back
					if(weappick.bDestroyAfterTransfer)
						weappick.Destroy();
				}
				else	// he doesn't so destroy it
					weappick.Destroy();
			}
		}

		// Do anything special you need to, after your inventory and weapons have
		// been taken from you.
		p2p.CheckInventoryAfterItsTaken();

		// Kevlar is special because armor is in the usepawn, so strip any armor 
		// from him too. And don't give any back
		usepawn.Armor = 0;

		// If you had a weapon you were currently using, it could have screwed up things
		// so just default to switching your hands (like if you're clipboard was taken and
		// was currently being used)
		if(p2p != None)
		{
			p2p.ResetHandsToggle();

			if(p2p.MyPawn != None)
				p2p.SwitchToHands(true);
		}

		// Make sure to reset this
		TheGameState.bTakePlayerInventory=false;
	}
}


//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Misc
//
//=================================================================================================
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// Set gameplay speed but don't save it to the config file
// Like Engine SetGameSpeed.
///////////////////////////////////////////////////////////////////////////////
function SetGameSpeedNoSave( Float T )
{
	local float OldSpeed;

	OldSpeed = GameSpeed;
	GameSpeed = FMax(T, 0.1);
	Level.TimeDilation = GameSpeed;
	//if ( GameSpeed != OldSpeed )
	//	SaveConfig();
	SetTimer(Level.TimeDilation, true);
}

///////////////////////////////////////////////////////////////////////////////
// True means if the player screws around too much on the first
// day, he'll get reminders to check the map for errands to do.
//
// This checks to only show the reminder hints if it's the first day.
// The assumption is that if the player has played to the second day, then
// he must understand the errand and game structure enough to not have to be
// reminded to check the map.
// It also stops telling you about it on day one, once you've finished
// all your errands
///////////////////////////////////////////////////////////////////////////////
function bool AllowReminderHints()
{
	if(TheGameState != None
		&& TheGameState.CurrentDay == 0
		&& !IsPlayerReadyForHome())
		return Super.AllowReminderHints();
	else
		return false;
}

///////////////////////////////////////////////////////////////////////////////
// Change the sky based on the day, using a material trigger
///////////////////////////////////////////////////////////////////////////////
function ChangeSkyByDay()
{
	local MaterialTrigger mattrig;
	local int i;

	// Find the skybox trigger, and trigger it to the correct day
	foreach AllActors(class'MaterialTrigger', mattrig, SKY_BOX_TRIGGER)
		break;
	
	if(mattrig != None)
	{
		// If your in the normal week, just set the skybox by the day number
		if(!TheGameState.bIsApocalypse)
			mattrig.SetCurrentMaterialSwitch(TheGameState.CurrentDay);
		else// Apocalypse is expected to be one past the last day.
			mattrig.SetCurrentMaterialSwitch(TheGameState.CurrentDay+1);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Get the first player you come across in the controller list
///////////////////////////////////////////////////////////////////////////////
function P2Player GetPlayer()
{
	local controller con;

	for(con = Level.ControllerList; con != None; con = con.NextController)
		if(P2Player(con) != None)
			return P2Player(con);

	return None;
}

///////////////////////////////////////////////////////////////////////////////
// If we have fewer pawns in action than the goal, then bring the ones in
// sliderstasis out of it, until there are enough active.
// Only bring them in if they can't be seen and if they are further than SLIDER_PAWN_DIST.
///////////////////////////////////////////////////////////////////////////////
function CheckToRevivePawns()
{
	local FPSPawn fpawn, pplayer;
	local float usedist, usedot;
	local P2Player p2p;

	//log(self$" CheckToRevivePawns, active "$SliderPawnsActive$" goal "$SliderPawnGoal$" total "$SliderPawnsTotal);
	
	if(SliderPawnsActive < SliderPawnGoal
		&& SliderPawnsActive < SliderPawnsTotal)
	{
		//log(self$" trying to bring some back ");

		// Find the player to compare distance to.
		foreach DynamicActors(class'P2Player', p2p)
			break;

		pplayer = p2p.MyPawn;
		
		foreach DynamicActors(class'FPSPawn', fpawn)
		{
			//log(self$" checking "$fpawn);

			if(fpawn.bSliderStasis
				&& LambController(fpawn.Controller) != None)
			{
				usedist = VSize(fpawn.Location - pplayer.Location);

				usedot = Normal(fpawn.Location - pplayer.Location) Dot vector(pplayer.Rotation);
				//log(self$" use dot "$usedot);
				// See if he's far enough away, and outside of your view
				if(usedist > SLIDER_PAWN_DIST
					&& (usedot) < VIEW_CONE_SLIDER_PAWN)
				{
					LambController(fpawn.Controller).ComeOutOfSliderStasis();
					// If we've met our quota, then quit early
					if(SliderPawnsActive >= SliderPawnGoal
						|| SliderPawnsActive == SliderPawnsTotal)
					{
						//log(self$" STOPPING!");
						break;
					}
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check to rain cats during the apocalypse
///////////////////////////////////////////////////////////////////////////////
function CheckCatRain(float DeltaTime)
{
	// STUB--found in gamesingleplayer
}

///////////////////////////////////////////////////////////////////////////////
// Cheat that says the player can kill anyone in one shot to the head from the
// pistol or machinegun.
///////////////////////////////////////////////////////////////////////////////
function bool PlayerGetsHeadShots()
{
	if(TheGameState != None)
		return TheGameState.bGetsHeadShots;

	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Reach into entry and put a new reference to every chameleon texture/mesh in this
// level.
///////////////////////////////////////////////////////////////////////////////
function StoreChams()
{
	// STUB -- done in GameSinglePlayer
}

//=================================================================================================
//=================================================================================================
//=================================================================================================
//
// Display debug info
//
//=================================================================================================
//=================================================================================================
//=================================================================================================


///////////////////////////////////////////////////////////////////////////////
// Type function name at the console to toggle the display of debug info.
///////////////////////////////////////////////////////////////////////////////
exec function ShowGameInfo()
	{
	TheGameState.bShowGameInfo = !TheGameState.bShowGameInfo;
	}

///////////////////////////////////////////////////////////////////////////////
// Display debug info
///////////////////////////////////////////////////////////////////////////////
event RenderOverlays(Canvas Canvas)
	{
	local string str;
	local int i, j;
	local int count;

	if (TheGameState != None && TheGameState.bShowGameInfo)
		{
		Super.RenderOverlays(Canvas);

		DrawTextDebug(Canvas, "P2GameInfoSingle (class = "$String(Class)$")");

		DrawTextDebug(Canvas, "StartFirstDayURL = "$StartFirstDayURL, 1);
		DrawTextDebug(Canvas, "StartNextDayURL = "$StartNextDayURL, 1);
		DrawTextDebug(Canvas, "FinishedDayURL = "$FinishedDayURL, 1);
		DrawTextDebug(Canvas, "JailURL = "$JailURL, 1);
		DrawTextDebug(Canvas, "MainMenuURL = "$MainMenuURL, 1);
		DrawTextDebug(Canvas, "");
		DrawTextDebug(Canvas, "bNiceDude = "$TheGameState.bNiceDude, 1);
		DrawTextDebug(Canvas, "CurrentDay = "$TheGameState.CurrentDay$" ("$Days[TheGameState.CurrentDay].UniqueName$")", 1);
		DrawTextDebug(Canvas, "Current level = "$ParseLevelName(Level.GetLocalURL()), 1);
		DrawTextDebug(Canvas, "bFirstLevelOfGame = "$TheGameState.bFirstLevelOfGame, 1);
		DrawTextDebug(Canvas, "bFirstLevelOfDay = "$TheGameState.bFirstLevelOfDay, 1);
		DrawTextDebug(Canvas, "bPreGameMode = "$TheGameState.bPreGameMode, 1);
		DrawTextDebug(Canvas, "ErrandsCompletedToday = "$TheGameState.ErrandsCompletedToday, 1);
		DrawTextDebug(Canvas, "JailCellNumber = "$TheGameState.JailCellNumber, 1);
		DrawTextDebug(Canvas, "MostRecentGameSlot = "$MostRecentGameSlot, 1);
		DrawTextDebug(Canvas, "");

		str = "";
		DrawTextDebug(Canvas, "Errands Still To Do Today:", 1);
		for (j = 0; j < Days[TheGameState.CurrentDay].Errands.Length; j++)
			{
			if (!Days[TheGameState.CurrentDay].IsErrandComplete(j))
				{
				if (j > 0)
					str = str $ ", ";
				str = str $ Days[TheGameState.CurrentDay].Errands[j].UniqueName;
				}
			}
		if (str == "")
			str = "(none)";
		DrawTextDebug(Canvas, str, 2);

		DrawTextDebug(Canvas, "Completed Errands (all days)", 1);
		count = 0;
		str = "";
		for (i = 0; i < Days.Length; i++)
			{
			for (j = 0; j < Days[i].Errands.Length; j++)
				{
				if (Days[i].IsErrandComplete(j))
					{
					str = str $ Days[i].Errands[j].UniqueName $ ", ";
					count++;
					}
				if (count == 10)
					{
					DrawTextDebug(Canvas, str, 2);
					str = "";
					count = 0;
					}
				}
			}
		if (count > 0)
			DrawTextDebug(Canvas, str, 2);
		else
			DrawTextDebug(Canvas, "(none)", 2);

		DrawTextDebug(Canvas, "Persistent PawnsArr ("$TheGameState.PawnsArr.Length$")", 1);
		for (i = 0; i < TheGameState.PawnsArr.Length; i++)
			DrawTextDebug(Canvas, TheGameState.PawnsArr[i].Tag$" in "$TheGameState.PawnsArr[i].LevelName, 2);

		DrawTextDebug(Canvas, "Persistent WeaponsArr ("$TheGameState.WeaponsArr.Length$")", 1);
		for (i = 0; i < TheGameState.WeaponsArr.Length; i++)
			DrawTextDebug(Canvas, TheGameState.WeaponsArr[i].ClassName$"(tag="$TheGameState.WeaponsArr[i].Tag$") in "$TheGameState.WeaponsArr[i].LevelName, 2);

		DrawTextDebug(Canvas, "Persistent PowerupsArr ("$TheGameState.PowerupsArr.Length$")", 1);
		for (i = 0; i < TheGameState.PowerupsArr.Length; i++)
			DrawTextDebug(Canvas, TheGameState.PowerupsArr[i].ClassName$"(tag="$TheGameState.PowerupsArr[i].Tag$") in "$TheGameState.PowerupsArr[i].LevelName, 2);

		DrawTextDebug(Canvas, "CurrentHaters ("$TheGameState.CurrentHaters.Length$")", 1);
		str = "";
		for (i = 0; i < TheGameState.CurrentHaters.Length; i++)
			{
			if (i > 0)
				str = str $ ", ";
			str = str $ GetItemName(String(TheGameState.CurrentHaters[i].ClassName));
			}
		if (str == "")
			str = "(none)";
		DrawTextDebug(Canvas, str, 2);

		DrawTextDebug(Canvas, "CopRadioTime ("$TheGameState.CopRadioTime$"/"$TheGameState.CopRadioMax$")", 1);
		DrawTextDebug(Canvas, "bArrestPlayerInJail = "$TheGameState.bArrestPlayerInJail, 1);
		DrawTextDebug(Canvas, "bPlayerInCell = "$TheGameState.bPlayerInCell, 1);
		DrawTextDebug(Canvas, "bIsApocalypse = "$TheGameState.bIsApocalypse, 1);
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// StartUp
// Do things at the absolute last moment before the game starts
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
auto state StartUp
{
	///////////////////////////////////////////////////////////////////////////////
	// The gameinfo has everything ready so now we tell the player controller
	// to prepare itself for a save. Make sure though, that it's allowed--demo versions can't save.	
	// Instead, the demo version forces the map to come up, since the Intro movie isn't there
	// to have the map come up. Only do this though, on the start of the first day
	// in the first level.
	///////////////////////////////////////////////////////////////////////////////
	function PrepPlayerStartup()
	{
		local P2Player p2p;

		p2p = GetPlayer();
		// Don't ever allow saving in the demo
		if(!bIsDemo)
			p2p.PrepForSave();
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function PrepDifficulty()
	{
		if(TheGameState != None)
		{
			log(self$" Synchronizing and writing new difficulty to ini, was "$GameDifficulty$" is now "$TheGameState.GameDifficulty);
			// Use the game difficulty from the game state (this was the saved diff)
			GameDifficulty = TheGameState.GameDifficulty;
			// Make sure to write the difficulty to the ini, or it won't be carried to the next
			// level correctly.
			ConsoleCommand("set "@DifficultyPath@GameDifficulty);
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function bool StartingUp()
	{
		return true;
	}
Begin:
Log(self @ "Startup state: !TimeBeg!");
	PrepDifficulty();
	SetZoneFogPlanes();
	ChangeSkyByDay();	// Change the skies based on the day number
	PrepActorsByGroup();
	PrepSliderPawns();
	PrepPickupsForErrands();
	RemoveGottenPickups();
	CheckToTransferPlayerInventory();
	StoreChams();
	// Only if we're in the Apocalypse, after a new level starts, set all NPC's into riot mode
	if(TheGameState.bIsApocalypse)
		ConvertAllPawnsToRiotMode();
Log(self @ "Startup state: !TimeEnd!");

	// The gameinfo has everything ready so now we tell the player controller
	// to prepare itself for a save. Make sure though, that it's allowed--demo versions can't save.	
	// Instead, the demo version forces the map to come up, since the Intro movie isn't there
	// to have the map come up. Only do this though, on the start of the first day
	// in the first level.
	PrepPlayerStartup();

	// Show map title
	if (!IsMainMenuMap() && !IsIntroMap() && !IsFinishedDayMap())
		if (Level.Title != "" && Level.Title != "Untitled")
			GetPlayer().ClientMessage(Level.Title);

	if(!TheGameState.bIsApocalypse)
		GotoState(RunningStateName);
	else
		GotoState('RunningApocalypse');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Running
// Monitor things in the game as it runs
// This is for the *full* version of the game. The running state for the 
// demo is defined in the game info for the demo
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state Running
{
Begin:
	Sleep(REVIVE_CHECK_TIME);
	CheckToRevivePawns();
	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Monitor things in the game, and rain cats
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state RunningApocalypse
{
Begin:
	Sleep(SLEEP_TIME_INC);
	CheckReviveTime += SLEEP_TIME_INC;
	// Update only when this is equal
	if(CheckReviveTime >= REVIVE_CHECK_TIME)
	{
		CheckToRevivePawns();
		CheckReviveTime=0;
	}
	// We need this updatted each second.
	CheckCatRain(SLEEP_TIME_INC);
	Goto('Begin');
}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bWaitingToStartMatch=true
	bDelayedStart=false
	DefaultPlayerClassName="People.PostalDude"
    ApocalypseTex="p2misc_full.newspaper_day_5a"
	ApocalypseComment="DudeDialog.dude_news_Apocalypse"
	EasySaveMessageString="Easy Saving"
	AutoSaveMessageString="Auto Saving (can be disabled in Options menu)"
	ForcedSaveMessageString="Saving start of new day"
	NormalSaveMessageString="Saving"
	RunningStateName="Running"
	bIsValid=false
	bAllowBehindView=true

	DifficultyNames[0]="Liebermode"
	DifficultyNames[1]="Too Easy"
	DifficultyNames[2]="Very Easy"
	DifficultyNames[3]="Easy"
	DifficultyNames[4]="Remedial"
	DifficultyNames[5]="Average"
	DifficultyNames[6]="Aggressive"
	DifficultyNames[7]="Hard"
	DifficultyNames[8]="Very Hard"
	DifficultyNames[9]="Manic"
	DifficultyNames[10]="Hestonworld"
	DifficultyNames[11]="Insane-o"
	DifficultyNames[12]="They Hate Me"
	}
