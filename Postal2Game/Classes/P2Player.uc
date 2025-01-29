///////////////////////////////////////////////////////////////////////////////
// P2PlayerController.
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Postal 2 player controller
//
///////////////////////////////////////////////////////////////////////////////
class P2Player extends FPSPlayer;


///////////////////////////////////////////////////////////////////////////////
// CONST
///////////////////////////////////////////////////////////////////////////////
const DUDE_SHOUT_GET_DOWN_RADIUS	=	1800;
const GRAB_TELEPORTER_RADIUS		=	512;

const REPORT_LOOKS_SLEEP_TIME		=	1.0;

const AFTER_SPITTING_WAIT_TIME		=	1.5;

const TOSS_STUFF_VEL				=	800;

const FREEZE_TIME_AFTER_DYING		=	0.5;	// Number of seconds to freeze player after he dies
const FREEZE_TIME_AFTER_DYING_MP	=	2.0;

const RADAR_TARGET_MOVE_MOD			=	0.02;
const RADAR_TARGET_START_TIME		=	10.;
const TARGET_FRAME_TIME				=	0.5;
const TARGET_FRAME_MAX				=	2;
const TARGET_ATTACK_TIME			=	1.5;
const TARGET_WAIT_TIME				=	3.0;
const RADAR_TARGET_MAX_RADIUS		=	55;
const TARGET_RAND_WATCHX			=	0.1;
const TARGET_RAND_WATCHY			=	0.3;

const AUTO_SAVE_WAIT				=	1.0;

// map states
const MS_NO_STATE					=	0;
const MS_FADE_OUT_OF_GAME			=	1;
const MS_FADE_IN_MAP				=	2;
const MS_VIEW_MAP					=	3;
const MS_FADE_OUT_OF_MAP			=	4;
const MS_FADE_IN_GAME				=	5;

const FADE_OUT_GAME_TIME			=	0.3;
const FADE_IN_MAP_TIME				=	0.7;
const FADE_OUT_MAP_TIME				=	0.7;
const FADE_IN_GAME_TIME				=	0.3;

const FIRE_NOTHING					=	0;
const FIRE_WAITING					=	1;
const FIRE_ENDED					=	2;

const MAX_CRACK_HINTS				=	3;
const HEART_SCALE_CRACK_ADD			=	0.5;

const PLAYER_HEAD_LOD_BIAS			=	1.5;	// This is so when the camera is in 3rd person (suicide for instance)
												// the head doesn't get bad polys dropped from it.

const HURT_BAR_FADE_TIME			=	1.0;
const SKULL_FADE_TIME				=	2.0;
const DIRECTIONAL_HURT_BAR_COUNT	=	4;
const HURT_DIR_UP					=	0;
const HURT_DIR_RIGHT				=	1;
const HURT_DIR_DOWN					=	2;
const HURT_DIR_LEFT					=	3;
const HURT_DIR_SKULL				=	4;
const CENTER_DOT_HIT				=	0.8;
const MIN_DIR						=	0.35;
const SKULL_HEALTH_PERC				=   0.35;

const CATNIP_SPEED					=	5.0;
const CATNIP_START_TIME				=	60.0;

const CAMERA_MAX_DIST				=	10.0;// Max and min values for CameraDist. Controllable through Next/PrevWeapon
const CAMERA_MIN_DIST				=	3.0;
const CAMERA_DEAD_MAX_DIST			=	40.0;	// Uses for when he's dead and for when he's suiciding
const CAMERA_DEAD_MIN_DIST			=	3.0;
const CAMERA_ZOOM_CHANGE			=	0.5;
const CAMERA_DEAD_ZOOM_CHANGE		=	2.0;
const CAMERA_TARGET_BONE			=	'MALE01 head';
const CAMERA_MAX_LOW_SUICIDE_PITCH	=	10500;
const CAMERA_MIN_HIGH_SUICIDE_PITCH	=	45000;

const CAMERA_ROCKET_OFFSET_Z		=	10.0;
const CAMERA_ROCKET_OFFSET_X		=	-20.0;
const CAMERA_VICTIM_OFFSET_Z		=	5.0;
const CAMERA_VICTIM_OFFSET_X		=	5.0;
const WATCH_ROCKET_RESULTS_TIME		=   3.0;
const VICTIM_CAMERA_VIEW_DIST		=   15.0;

const STUCK_TIME_HINT				=	0.3;
const MAX_STUCK_TIME				=	2.0;
const STUCK_RADIUS					=	2048;

const WAIT_FOR_DEATH_COMMENT_GUN	=	0.8;
const WAIT_FOR_DEATH_COMMENT_MELEE	=	0.8;
const WAIT_FOR_DEATH_COMMENT_PROJ	=	1.5;
const COMMENT_ON_RACE				=	0.4;

const CHECKMAP_HINT1_TIME			=	5;
const CHECKMAP_HINT2_TIME			=	10;
const CHECKMAP_HINT3_TIME			=	15;
const MIN_MAP_REMINDER_REFRESH		=	9.0;
const MIN_MAP_REMINDER_DEC			=	0.5;
const MAP_REMINDER_HINT_TIME		=	7.0;

const QUICK_KILL_FREQ				=	0.07;
const QUICK_KILL_TIME				=	16;
const QUICK_KILL_MAX				=	7;

const LAST_AI_DAMAGE_TIME			=   10.0;
const LOW_AI_DAMAGE_RATE			=   5.0;
const LOW_AI_DAMAGE_TOTAL			=	30;
const MIN_DAMAGE_RATE_TO_SHOW_HINT	=	18.0;
const DEATH_MESSAGE_MAX				=	3;
const DeathMessagePath				=   "Postal2Game.P2GameInfo DeathMessageUseNum"; // ini path
const PissedMeOutPath				=   "Postal2Game.P2GameInfo bPlayerPissedHimselfOut"; // ini path
const CheatsPath					=	"Postal2Game.P2GameInfoSingle bAllowCManager"; // ini path

const SNIPER_BAR_FADE				=   1.1;	// factor by which they fade out (they fade faster than they grow in)

///////////////////////////////////////////////////////////////////////////////
// VARS
///////////////////////////////////////////////////////////////////////////////

// Internal vars
var input byte
	bDeathCrawl, bCower;

var globalconfig bool	bAutoSwitchOnEmpty;		// true means it goes to the next strongest weapon on empty, false means it goes
												// back to your hands when the current weapon is empty.

var P2MocapPawn	MyPawn;				// P2MocapPawn version of Pawn inside Controller.

var input byte	bPee;				// Pee button has been pressed
var input byte	bShoutGetDown;		// GetDown button has been pressed.
var input byte  btemp;


var bool bStillTalking;				// This sound is still playing
var bool bStillYelling;				// Getting hurt sounds, urgent sounds
var bool bWaitingToTalk;			// When Timer gets called, instead of turning off bStillTalking
									// leave it on, and say your thing, then SetTimer again.
var P2Dialog.SLine DelayedSayLine;	// bWaitingToTalk will trigger this line to be said next when
									// Timer gets called next.

// These next four values are duplicated in gamestate, in order to travel them (don't
// put them in pawn, because only the player needs to use them)
// There are two seperate groups to remember the last weapon before you peed and used your hands
// because you could theoretically be using the pistol, fast switch to the hands, then decide to
// pee. So it needs to be able to go back to your hands when you unzip your pants, then go back to
// the pistol when you untoggle the 'switch to hands' button.
var int LastWeaponGroupPee;			// Last weapon group we had before changing to the urethra.
var int LastWeaponOffsetPee;		// specific weapon in the LastWeaponGroupPee we were using
var int LastWeaponGroupHands;		// Last weapon group we had before swapping to the hands.
var int LastWeaponOffsetHands;		// specific weapon in the LastWeaponGroupHands we were using

var name MyOldState;				// Next state to be in

// These next few variables are for the disguises the dude wears. Because the effects of
// each outfit is so specific, each disguise has its own entry function (like ChangeToCopClothes)
var class<Inventory> CurrentClothes;	// Inventory class of clothes we're wearing.
var class<Inventory> NewClothes;		// Clothes we're about to put on
var class<Inventory> DefaultClothes;	// Our default dude clothes class
var Texture DefaultHandsTexture;// Texture for normal dude hands

var int WeaponFirstTimeFireInstance;	// If you've shot your weapon for the first time or not, sometimes comment on it

var float SayTime;					// how long a dialogue file plays for
var float SayThingsOnGuyDeathFreq;	// how often you mouth off during a death
var float SayThingsOnGuyBurningDeathFreq;	// how often you mouth off during a death from someone you torched
var float SayThingsOnWeaponFire;	// how often you mouth off while shooting for particular weapons

var FPSPawn InterestPawn;			// who I'm currently dealing with
var bool bDealingWithCashier;		// If my interest pawn is a cashier and I can pay them

var int CrackHintTimes[MAX_CRACK_HINTS];	// Array of times to tell the player that he needs more crack
									// Oth time is considered the lowest with the MAX_CRACK_HINTS-1 the highest
var float CrackDamagePercentage;	// How much the crack hurts us by, if we didn't get more in time
var float CrackStartTime;			// Time we start with till we get hurt by the crack addiction

var float CatnipUseTime;			// How long we still have to keep our cat-speed effects

var float TimeSinceErrandCheck;		// This is how long since the last time the player did something
									// to do with the errands--either he checked the map or went into
									// a place that has to do with errands, or something like that
									// --gets reset after he checks it.
var float TimeForMapReminder;		// This is then number of seconds that have to pass before
									// the player will be reminded to check the map to figure out what
									// errands he should do.
var float MapReminderRefresh;		// While he still waiting to check the map, wait this time
									// before you bother him again
var int	  MapReminderCount;			// Number of times you've had to tell him about checking the map
									// before he finally checks--gets reset after he checks it.

var float BodySpeed;				// Modifier for how fast you move and work your weapons (defaults to 1)

var array<AnimalPawn> AnimalFriends;// Animal who has us as our their hero

var FPSPawn.EPawnInitialState SightReaction;	// Type of reaction you inspire in NPCs when they see you. InterestVolume
									// controls this.

var bool	bCommitedSuicide;		// You intentionally died.

var float StuckTime;				// How long the player has been 'stuck'. Determined below. If they are not
									// moving in Z for too long (MAX_STUCK_TIME), 
									// then warp them to the nearest good pathnode.
var float StuckCheckRadius;			// Size around which you check for pathnodes to warp to
var localized String StuckText1;	// Tells player what's happening
var localized String StuckText2;
var localized string MuggerHint1;	// Details of how to handle a mugger
var localized string MuggerHint2;
var localized string MuggerHint3;
var localized string MuggerHint4;

var localized string CheckMapText1;	// Hints that tell the player to check the map so he can start
var localized string CheckMapText2; // doing some errands.
var localized string CheckMapText3;
var localized string CheckMapText4;

var localized string NoMoreHealthItems;	// Tells you after you do a quickhealth that you don't have anymore health
									// items to automatically use.

// The following are hints for the player that died too quickly. These are tied to the DamageTotal variables.
// The damage is calculated. If he died very quickly, then one of these groups of hints are picked to 
// help him out next time.
var array<localized string>DeathHints1;
var array<localized string>DeathHints2;
var array<localized string>DeathHints3;
var array<localized string>FireDeathHints1;

// Hud code
var float HeartBeatSpeed;			// How fast your heart is beating
									// The default of this value is how fast your heart beats when you're perfectly fine
var float HeartBeatSpeedAdd;		// Gets added to the base and multiplied by a ratio with your health to 
									// make it beat faster the more hurt you are
var float HeartTime;				// Time used to pump the heart
var float HeartScale;				// Scale used for drawing heart (can be modified by crack)
var float HeartScaleDelta;			// Change in scale, after you start commenting on how you're addicted to crack

var bool  bShowWeaponHints;			// When the dude is getting told by a cop to drop his weapon, this is
									// set so various hints pop up in the hud to instruct the player.
var class<P2Weapon> LastWeaponSeen;// Last weapon a cop saw when they were trying to arrest me. We'll use this
								// to know if he's still hiding that same weapon or not

var bool bMuggerGoingToShoot;		// At first, use hints MuggerHint1-2, then use MuggerHint3-4 if this is true.

var Texture HudArmorIcon;			// Icon texture for type of armor we have currently.
var class<Inventory> HudArmorClass;		// Class of armor type we have on

var bool bRadarShowGuns;			// True when your radar can recognize fish with concealed weapons
var bool bRadarShowCops;			// True when your radar can recognize fish who are authority figures
var bool bUseRocketCameras;			// True means the player can view rockets he shoots

var float PlayerMoveX, PlayerMoveY;	// Used to control the rocket through the rocket camera.
									// Saves directions the player is inputting.

var rotator OldViewRotation;		// Rotation we had before the rocket took the view

var PathNode LastUnstuckPoint;		// Save the last point we warped to, after being unstuck. Don't use it
									// the very next time, to keep us from infinite unsticking--still stuck
									// scenarios.

var const localized string	HintsOnText;// Hints for how to toggle inv hints
var const localized string	HintsOffText;
// Cheats on/off
var const localized string	CheatsOnText;
var const localized string	CheatsOffText;

// These damage values are only for calculating how fast the AI is hurting the player. They eventually
// are put together to decide to give hints to the player. They might not be consecutive damage across
// his whole life. They can stop and start sequences if they last time he got hit was too far
// from this current time he's being hit. 
var float DamageTotal;				// Total amount of damage taken from AI in this sequence
var float DamageThisHitTime;		// Level time of this current damage.
var float DamageFirstHitTime;		// Level time of first damage to start this sequence
var float DamageRate;				// damage amount over time gives rate at which AI is hurting us

// Radar for nearby people (on the hud)
enum ERadarState
{
	ERadarOff,
	ERadarBringUp,
	ERadarWarmUp,
	ERadarOn,
	ERadarCoolDown,
	ERadarDropDown
};
enum ERadarTargetState
{
	ERTargetOff,
	ERTargetWaiting,
	ERTargetPaused,
	ERTargetOn,
	ERTargetKilling1,
	ERTargetKilling2,
	ERTargetKilling3,
	ERTargetKilling4,
	ERTargetDead,
	ERTargetStatsWait,
	ERTargetStats
};
var ERadarState RadarState;			// Do a simple state system here for the radar
var float RadarSize;				// radius of radar
var float RadarShowRadius;			// radius inside which pawns are shown on radar
var float RadarScale;				// scale of pawn check radius to draw on radar radius
var float RadarMaxZ;				// farthest in z a pawn can be and still be put on radar
var float RadarBackY;				// Position of background image for radar
var array<P2Pawn> RadarPawns;		// Array of pawns picked up on radar
var byte  RadarInDoors;				// A quick, faulty test (a straight above you line check) says 1 if we're "in doors"
var float RadarTargetX;				// reticle on radar coords
var float RadarTargetY;
var float RadarTargetTimer;			// How long you have to target things
var float RadarTargetAnimTime;		// frame timer for animating the target
var int	  RadarTargetKills;			// Number of kills time around
var Sound RadarTargetMusic;			// Sound played as you target in radar.
var ERadarTargetState RadarTargetState;// What radar targetting is doing
var class<PawnShotMarker> RadarTargetHitMarker;	 // Marker tells people around the target was hit
var float HurtBarTime[5];			// If this is 0, things are up to date, if not, then the hud will show 
									// a hurt bars corresponding to the HURT_DIR const'd above. This time
									// will be faded in the hud. 0 through 3 are for actual directional hurt
									// while the 4th one is for the big death skull telling you that you are
									// about dead.

var class<PawnShotMarker> SuicideStartMarker;// Tells people to freak out when you start to kill yourself
var Sound RadarClickSound;
var Sound RadarBuzzSound;
var Sound TargetAttackSounds[2];

// Screens
var transient MapScreen MyMapScreen;	// Map screen
var transient NewsScreen MyNewsScreen;	// Newspaper screen
var transient VoteScreen MyVoteScreen;	// Voting screen
var transient PickScreen MyPickScreen;	// Pick-a-dude screen
var transient LoadScreen MyLoadScreen;	// Load screen
var transient ClothesScreen MyClothesScreen;	// screen i change my clothes in
var transient StatsScreen MyStatsScreen;	// game stats
var transient P2Screen CurrentScreen;	// The currently running screen

// Map/errand code
var bool bErrandCompleted;			// Whether an errand was completed
var Name CompletionTrigger;			// Event to trigger after errand completion

var float LastQuickSaveTime;		// Time of last quicksave
var bool bDidPrepForSave;

var bool bQuickKilling;				// You're killing bystanders quickly in succession
var float QuickKillLastTime;		// Last time since you quick killed. Must be in small time span to continue 'combo'
var int   QuickKillSoundIndex;		// Sound index we just played for when killing the last person
var P2Dialog.SLine QuickKillLine; // The array of sounds we use for quick kill lines
var Sound QuickKillGoodEndSound;	// Sound he makes when he's successfully finished quick killing
var Sound QuickKillBadEndSound;		// Sound he makes when he's unsuccessfully finished quick killing

var P2Pawn SniperAfterMe;			// Sniper that is currently aiming at me. 
									// This causes black bars to indicate his direction.
var float SniperBarTime[4];			// Set each time to determine from what direction the sniper is coming
var bool bSniperBarsClear;			// If it's false, draw the bars in the hud. Can exist independent of
									// SniperAfterMe, in order to have them fade nicely
var float PulseGlow;				// How much extra, if at all, the glow on the radar shines
var float PulseGlowChange;

const RAGDOLL_FRICTION		=	0.8;
const RAGDOLL_IMPACT_MAX	=	500;
// List of karma ragdoll params that are allowed in a given game. Pawns
// who want to ragdoll must query the gameinfo for an available skeleton--they
// are not allowed to start with a skeleton themself.
var transient array<KarmaParamsSkel> RagdollSkels;
// Pawns that are using the corresponding array of skeletons
var array<FPSPawn> RagdollPawns;
var globalconfig int   RagdollMax;	// Maximum number of simulatenous ragdolls allow in the game. Though
									// it may look like a hundred dead, ragdoll bodies before you, only this
									// many can have the physics applied them at once.. this gets shifted around
									// among them as needed.

// Moved over from P2GameInfo for MP games (because no level.game exists on clients)
var() Texture			Reticles[5];			// Reticle icons for weapons
var Color				ReticleColor;			// Reticle color
var globalconfig bool	bEnableReticle;			// Used to enable/disable reticles
var globalconfig int	ReticleNum;				// Current reticle number
var globalconfig int	ReticleAlpha;			// Reticle alpha value
var globalconfig bool	ShowBlood;				// true means you get blood, false means dust--bahahahahaa
var globalconfig int    HurtBarAlpha;// Alpha level for glowy, red hurt bars that show at the
									// sides of the screen when you get hurt.
var globalconfig int    HudViewState;// If Inventory, Weapon, and health icons are visible or not	
									// 0 is all is hidden, HUD_VIEW_MAX is all is present
var globalconfig bool   bWeaponBob;	// True means the view will bob as you walk
var globalconfig bool	bMpHints; // true means it shows multiplayer hints before/after a match

const HUD_VIEW_MAX				= 3;
const HudViewStatePath			= "Postal2Game.P2Player HudViewState"; // ini path

///////////////////////////////////////////////////////////////////////////////
// Replication
///////////////////////////////////////////////////////////////////////////////
replication
{
	// Variables the server should send to the client.
	reliable if( bNetDirty && (Role==ROLE_Authority) && bNetOwner )
		HudArmorIcon;

	reliable if( bNetDirty && Role==ROLE_Authority)
		MyPawn;

	// server sends this to client
	reliable if(Role == ROLE_Authority)
		ClientHurtBars, ClientShakeView;

	// Client sends this to server
	reliable if(Role < ROLE_Authority)
		ServerPerformSuicide, ServerCancelSuicide, HandleStuckPlayer, NextInvItem,
		QuickHealth, ServerThrowPowerup,
		ServerGetDown, ServerAneurism;
}

///////////////////////////////////////////////////////////////////////////////
// Possess a pawn
///////////////////////////////////////////////////////////////////////////////
function Possess(Pawn aPawn)
{
	Super.Possess(aPawn);

	log(self$" P2Player.Possess(): possessed pawn "$aPawn$" current mypawn "$MyPawn);

	MyPawn = P2MocapPawn(Pawn);
	if(MyPawn == None)
		Warn("P2Player.Possess(): Error! MyPawn is None");
	else
		SetHeartBeatBasedOnHealth();	// get the beating correct

	// Make sure player characters never try for a stasis
	MyPawn.TimeTillStasis=0;
	MyPawn.StartTimeTillStasis=0;
	MyPawn.bAllowStasis=false;
	MyPawn.bPlayer=true;
	MyPawn.bKeepForMovie=true;
	//mypawnfix
	Pawn.SetCollision(true, true, true);
	MyPawn.MyHead.LODBias=PLAYER_HEAD_LOD_BIAS;

	// If we already have a weapon and it's not doing anything, make it idle
	if(Pawn.Weapon != None
		&& !Pawn.Weapon.bDeleteMe
		&& Pawn.Weapon.GetStateName() == Pawn.Weapon.Tag)
		Pawn.Weapon.GotoState('Idle');

	StuckCheckRadius = STUCK_RADIUS;

	// Restore any time dilation effects
	SetupCatnipUseage(CatnipUseTime);

	SetupScreens();

	// If server, it will set up the pawns after they login. So instead of
	// travel post accept doing it, let's finish up the pawn here.
	if(Role == ROLE_Authority
		&& (Level.Game == None
			|| !FPSGameInfo(Level.Game).bIsSinglePlayer))
	{
		P2Pawn(Pawn).PlayerStartingFinished();
		log(self$" Possess, server finished setting up pawn");
	}
}

///////////////////////////////////////////////////////////////////////////////
// Unpossess the pawn
///////////////////////////////////////////////////////////////////////////////
function UnPossess()
{
	Super.UnPossess();

	log(self$" P2Player.UnPossess(): unpossessed pawn, current mypawn"$MyPawn);
	
	// Set normal time, if you're leaving the player (in case a movie)
	// is playing now.
	P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1.0);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function PostBeginPlay()
{
	Super.PostBeginPlay();

	// Make your ragdolls here 
	if(Level.NetMode != NM_DedicatedServer)
	{
		InitRagdollSkels(RagdollMax);
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function Destroyed()
{
	MyPawn = None;
	Super.Destroyed();
}

///////////////////////////////////////////////////////////////////////////////
// For each group of karma ragdoll skeletons we'll use for the different groups,
// allocate the space for them, and fill in initial values.
///////////////////////////////////////////////////////////////////////////////
simulated function InitRagdollSkels(int max)
{
	local int i;

	log(self$" InitRagdollSkels "$max);
	// Clear out any possible old params (shouldn't be any)
	if(RagdollSkels.Length > 0)
		RagdollSkels.Remove(0, RagdollSkels.Length);
	if(RagdollPawns.Length > 0)
		RagdollPawns.Remove(0, RagdollPawns.Length);

	// allocate skeletons and pawn slots
	RagdollSkels.Insert(0, max);
	RagdollPawns.Insert(0, max);

	// Fill in karma information
	for(i=0; i<RagdollSkels.Length; i++)
	{
		RagdollSkels[i] = new(None) class'KarmaParamsSkel';
		//log(self$" getting skel "$i$" after "$RagdollSkels[i]);
		if(RagdollSkels[i] == None)
			warn(self$" ERROR::InitRagdollSkels, KarmaParamsSkel not allocated!");
		RagdollSkels[i].KFriction=RAGDOLL_FRICTION;
		RagdollSkels[i].KImpactThreshold=RAGDOLL_IMPACT_MAX;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Given a skel group, 
///////////////////////////////////////////////////////////////////////////////
simulated function KarmaParamsSkel GetNewRagdollSkel(FPSPawn NewPawn, name skelname)
{
	local int i;
	local bool bEmpty;

	log(self$" GetNewRagdollSkel called by "$NewPawn$" length "$RagdollPawns.Length);
	for(i=0; i<RagdollPawns.Length; i++)
	{
		if(RagdollPawns[i] == None)
			bEmpty=true;

		if(bEmpty
			|| RagdollPawns[i].FinishedWithRagdoll())
		{
			// Freeze the ragdoll in it's last position
			if(!bEmpty)
			{
				RagdollPawns[i].UnhookRagdoll();
			}
			// Save the new pawn
			RagdollPawns[i] = NewPawn;
			// Record the time we started using the ragdoll
			RagdollPawns[i].RagDollStartTime = Level.TimeSeconds;
			RagdollSkels[i].KSkeleton = skelname;
			//log(self$" success with "$RagdollSkels[i]);
			// Return his new ragdoll skeleton
			return RagdollSkels[i];
		}

	}
	return None;
}

///////////////////////////////////////////////////////////////////////////////
// Have pawn undo his karma, if he's destroyed instantly.
///////////////////////////////////////////////////////////////////////////////
simulated function GiveBackRagdollSkel(FPSPawn CheckPawn)
{
	local int i;

	//log(self$" GiveBackRagdollSkel called by "$CheckPawn);
	for(i=0; i<RagdollPawns.Length; i++)
	{
		if(RagdollPawns[i] == CheckPawn)
		{
			//log(self$" unhooking from "$CheckPawn$" at "$i);
			RagdollPawns[i]=None;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Get current reticle index
///////////////////////////////////////////////////////////////////////////////
simulated function Texture GetReticleTexture()
	{
	if (bEnableReticle)
		return Reticles[ReticleNum];
	return None;
	}

simulated function Color GetReticleColor()
	{
	ReticleColor.A = ReticleAlpha;
	return ReticleColor;
	}

///////////////////////////////////////////////////////////////////////////////
// True, you get blood, false, you suck
///////////////////////////////////////////////////////////////////////////////
static function bool BloodMode()
{
	//log(" checking blood mode ");
	if(default.ShowBlood)
		return true;
	else
		return false;
}

///////////////////////////////////////////////////////////////////////////////
// Add a friend
///////////////////////////////////////////////////////////////////////////////
function AddAnimalFriend(AnimalPawn newfriend)
{
	local int i;
	local bool bDontAdd;

	//log(self$" AddAnimalFriend "$newfriend);
	// Make sure he's not already in the list
	for(i=0; i<AnimalFriends.Length; i++)
	{
		if(AnimalFriends[i] == newfriend)
		{
			//log(self$" already here ");
			bDontAdd=true;
		}
	}

	if(!bDontAdd)
	{
		i = AnimalFriends.Length;
		AnimalFriends.Insert(i, 1);
		AnimalFriends[i] = newfriend;
		//log(self$" new animal friend! "$newfriend$" at "$i);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Remove a friend
///////////////////////////////////////////////////////////////////////////////
function RemoveAnimalFriend(AnimalPawn newfriend)
{
	local int i;
	local bool bDontAdd;

	//log(self$" RemoveAnimalFriend "$newfriend);
	// Make sure he's there to be removed
	for(i=0; i<AnimalFriends.Length; i++)
	{
		if(AnimalFriends[i] == newfriend)
		{
			//log(self$" found him.. removing ");
			AnimalFriends.Remove(i, 1);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check if this pawn is a player animal friend
///////////////////////////////////////////////////////////////////////////////
function bool IsAnimalFriend(FPSPawn cfriend)
{
	local int i;

	// Make sure he's not already in the list
	for(i=0; i<AnimalFriends.Length; i++)
	{
		if(AnimalFriends[i] == cfriend)
			return true;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Check if we should prepare for a save
///////////////////////////////////////////////////////////////////////////////
function CheckPrepForSave()
{
	// For single-player game, if we haven't done this already, prepare to save asap
	if(P2GameInfoSingle(Level.Game) != None
		// Don't ever allow saving in the demo
		&& !P2GameInfoSingle(Level.Game).bIsDemo
		&& !bDidPrepForSave)
	{
		PrepForSave();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Usually only used by the demo to make sure the map comes up to explain
// things at the start (since the intro movie didn't here).
///////////////////////////////////////////////////////////////////////////////
function ForceMapUp()
{
	GotoState('PlayerDemoMapFirst');
}

///////////////////////////////////////////////////////////////////////////////
// Called after a saved game has been loaded
///////////////////////////////////////////////////////////////////////////////
event PostLoadGame()
	{
	Super.PostLoadGame();

	InitRagdollSkels(RagdollMax);

	// Screens aren't saved so they need to be setup after a load
	SetupScreens();
	}

///////////////////////////////////////////////////////////////////////////////
// Prepare for a save
///////////////////////////////////////////////////////////////////////////////
function PrepForSave()
{
	// STUB! Don't allow it here
}

///////////////////////////////////////////////////////////////////////////////
// Give us the right state
///////////////////////////////////////////////////////////////////////////////
function ExitPrepToSave()
{
	GotoState('PlayerWalking');
}

///////////////////////////////////////////////////////////////////////////////
// Check whether save is allowed
///////////////////////////////////////////////////////////////////////////////
function bool IsSaveAllowed()
	{
	//log(self$" IsSaveAllowed "$Pawn$" my pawn "$MyPawn$" health "$Pawn.Health);
	if (Pawn != None &&			// only if player has pawn (aka not during cinematics)
		Pawn.Health > 0)		// only if player is alive
		return true;
	return false;
	}

/*
// Dump player inventory and ammo types to log
function DumpInv()
	{
	local Inventory inv;
	local P2Weapon weap;

	Log("DumpInv(): Player inventory:");
	inv = Pawn.Inventory;
	while (inv != None)
		{
		Log("   "$inv);
		weap = P2Weapon(inv);
		if (weap != None)
			Log("      "$weap.AmmoType);
		inv = inv.inventory;
		}
	
	Log("   MyPawn.MyFoot"$MyPawn.MyFoot);
	Log("   MyPawn.MyUrethra"$MyPawn.MyUrethra);
	}
*/

///////////////////////////////////////////////////////////////////////////////
// P2CheatManager cheats are ready to be used if this is a single player
// game with bAllowCManager true or it's just a multiplayer.
// Make sure he has a pawn too.
///////////////////////////////////////////////////////////////////////////////
function bool CheatsAllowed()
{
	if(P2GameInfoSingle(Level.Game) == None
		|| (P2GameInfoSingle(Level.Game).bAllowCManager
			&& Pawn != None
			&& Pawn.Health > 0))
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Change hud icon show amount
///////////////////////////////////////////////////////////////////////////////
exec function GrowHud()
	{
	if(HudViewState < HUD_VIEW_MAX)
		{
		HudViewState++;
		ConsoleCommand("set "@HudViewStatePath@HudViewState);
		}
	}
exec function ShrinkHud()
	{
	if(HudViewState > 0)
		{
		HudViewState--;
		ConsoleCommand("set "@HudViewStatePath@HudViewState);
		}
	}
///////////////////////////////////////////////////////////////////////////////
// Override engine functionality for quick save/load
///////////////////////////////////////////////////////////////////////////////
exec function QuickSave()
	{
	local float CurTime;

	// Try the quick save (may not occur if conditions aren't right)
	if (P2GameInfoSingle(Level.Game) != None
		&& P2GameInfoSingle(Level.Game).TryQuickSave(self))
		{
		// Taunt player if he's saving too often
		CurTime = Level.TimeSeconds;
		if (LastQuickSaveTime != 0 && CurTime - LastQuickSaveTime < 60)
			MyPawn.Say(MyPawn.myDialog.lDude_SaveTooMuch);
		LastQuickSaveTime = CurTime;
		}
	}

exec function QuickLoad()
	{
	if(P2GameInfoSingle(Level.Game) != None)
		// Try the quick load (may not occur if contions aren't right)
		P2GameInfoSingle(Level.Game).TryQuickLoad(self);
	}

///////////////////////////////////////////////////////////////////////////////
// Only allow this for debugging -- leads to bad things when actually
// trying to play the game.
///////////////////////////////////////////////////////////////////////////////
exec function RestartLevel()
	{
	// Only allow this in debug mode
	if (DebugEnabled())
		{
		Log("CHEAT: RestartLevel");
		Super.RestartLevel();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Toggle the cheats for single player game
///////////////////////////////////////////////////////////////////////////////
exec function Sissy()
{
	local P2GameInfoSingle psg;

	psg = P2GameInfoSingle(Level.Game);

	if(psg != None)
	{
		psg.bAllowCManager=!psg.bAllowCManager;
		ConsoleCommand("set "@CheatsPath@(psg.bAllowCManager));
		if(psg.bAllowCManager)
		{
			// Say he's a sissy
			SayTime = MyPawn.Say(MyPawn.myDialog.lDude_PlayerSissy) + 0.5;
			SetTimer(SayTime, false);
			bStillTalking=true;
			ClientMessage(CheatsOnText);
		}
		else
			ClientMessage(CheatsOffText);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Turn cheats on for single player game. Not a toggle
///////////////////////////////////////////////////////////////////////////////
exec function ForceSissy()
{
	local P2GameInfoSingle psg;

	psg = P2GameInfoSingle(Level.Game);

	if(psg != None)
	{
		if(!psg.bAllowCManager)
		{
			// Say he's a sissy
			SayTime = MyPawn.Say(MyPawn.myDialog.lDude_PlayerSissy) + 0.5;
			SetTimer(SayTime, false);
			bStillTalking=true;
			ClientMessage(CheatsOnText);
		}

		psg.bAllowCManager=true;
		ConsoleCommand("set "@CheatsPath@(psg.bAllowCManager));
	}
}

///////////////////////////////////////////////////////////////////////////////
// Pressing Fire in the pawn. Make sure the controller says it's okay
// first
///////////////////////////////////////////////////////////////////////////////
simulated function bool PressingFire()
{
	return ( bFire != 0 );
}
simulated function bool PressingAltFire()
{
	return ( bAltFire != 0 );
}

///////////////////////////////////////////////////////////////////////////////
// Same as Engine::PlayerController--blocking pawn checks for when you're in a movie now
// The player wants to fire.
///////////////////////////////////////////////////////////////////////////////
exec function Fire( optional float F )
{
	if ( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(false);
		return;
	}
	if( Pawn != None
		&& Pawn.Weapon!=None )
		Pawn.Weapon.Fire(F);
}

///////////////////////////////////////////////////////////////////////////////
// Same as Engine::PlayerController--blocking pawn checks for when you're in a movie now
// The player wants to alternate-fire.
///////////////////////////////////////////////////////////////////////////////
exec function AltFire( optional float F )
{
	if ( Level.Pauser == PlayerReplicationInfo )
	{
		SetPause(false);
		return;
	}
	if( Pawn != None
		&& Pawn.Weapon!=None )
		Pawn.Weapon.AltFire(F);
}

///////////////////////////////////////////////////////////////////////////////
// Do anything special you need to, after your inventory and weapons have
// been taken from you.
///////////////////////////////////////////////////////////////////////////////
function CheckInventoryAfterItsTaken()
{
	local Inventory Inv;

	Inv = MyPawn.Inventory;
	// Tell any remaining inventory and weapon items that they should have been
	// stolen.. things like Radar we definitely want to stay, but others may need to do things
	while(Inv != None)
	{
		if(P2Weapon(Inv) != None)
			P2Weapon(Inv).AfterItsTaken(MyPawn);
		else if(P2PowerupInv(Inv) != None)
			P2PowerupInv(Inv).AfterItsTaken(MyPawn);

		Inv = Inv.Inventory;
	}


	// Kevlar is special because armor is in the usepawn, so strip any armor 
	// from him too. And don't give any back
	MyPawn.Armor = 0;

	// If you had a weapon you were currently using, it could have screwed up things
	// so just default to switching your hands (like if you're clipboard was taken and
	// was currently being used)
	ResetHandsToggle();

	if(MyPawn != None)
		SwitchToHands(true);
}

///////////////////////////////////////////////////////////////////////////////
// Used only for AIScripts, make sure the MyPawn gets cleared too
///////////////////////////////////////////////////////////////////////////////
function PendingStasis()
{
	Super.PendingStasis();
	MyPawn = None;
}

///////////////////////////////////////////////////////////////////////////////
// Determines how much a threat to the player this pawn is
///////////////////////////////////////////////////////////////////////////////
function float DetermineThreat()
{
	return 0.0;
}

///////////////////////////////////////////////////////////////////////////////
// Setup various screens.  Screens aren't saved because they're objects (and
// are markred transient).  Once they are created, the screens will exist
// throughout the game, so we always look for existing screens first, and if
// they don't exist then we create them.
///////////////////////////////////////////////////////////////////////////////
function SetupScreens()
	{
	local int i;
	local MapScreen map;
	local NewsScreen news;
	local VoteScreen vote;
	local PickScreen pick;
	local LoadScreen load;
	local ClothesScreen clothes;
	local StatsScreen stats;

	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		// Search for existing screens
		for (i = 0; i < Player.LocalInteractions.Length; i++)
			{
			map = MapScreen(Player.LocalInteractions[i]);
			if (map != None)
				MyMapScreen = map;

			news = NewsScreen(Player.LocalInteractions[i]);
			if (news != None)
				MyNewsScreen = news;
			
			vote = VoteScreen(Player.LocalInteractions[i]);
			if (vote != None)
				MyVoteScreen = vote;

			pick = PickScreen(Player.LocalInteractions[i]);
			if (pick != None)
				MyPickScreen = pick;

			load = LoadScreen(Player.LocalInteractions[i]);
			if (load != None)
				MyLoadScreen = load;

			clothes = ClothesScreen(Player.LocalInteractions[i]);
			if (clothes != None)
				MyClothesScreen = clothes;

			stats = StatsScreen(Player.LocalInteractions[i]);
			if (stats != None)
				MyStatsScreen = stats;
			}

		// If screens weren't found, create new ones
		if (MyMapScreen == None)
			MyMapScreen = MapScreen(Player.InteractionMaster.AddInteraction("Postal2Game.MapScreen", Player));
		
		if (MyNewsScreen == None)
			MyNewsScreen = NewsScreen(Player.InteractionMaster.AddInteraction("Postal2Game.NewsScreen", Player));
		
		if (MyVoteScreen == None)
			MyVoteScreen = VoteScreen(Player.InteractionMaster.AddInteraction("Postal2Game.VoteScreen", Player));

		if (MyPickScreen == None)
			MyPickScreen = PickScreen(Player.InteractionMaster.AddInteraction("Postal2Game.PickScreen", Player));

		if (MyLoadScreen == None)
			MyLoadScreen = LoadScreen(Player.InteractionMaster.AddInteraction("Postal2Game.LoadScreen", Player));

		if (MyClothesScreen == None)
			MyClothesScreen = ClothesScreen(Player.InteractionMaster.AddInteraction("Postal2Game.ClothesScreen", Player));

		if (MyStatsScreen == None)
			MyStatsScreen = StatsScreen(Player.InteractionMaster.AddInteraction("Postal2Game.StatsScreen", Player));
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Clean up our screens.
///////////////////////////////////////////////////////////////////////////////
function DetachScreens()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (MyMapScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyMapScreen);
			MyMapScreen = None;
			}
		
		if (MyNewsScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyNewsScreen);
			MyNewsScreen = None;
			}
		
		if (MyVoteScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyVoteScreen);
			MyVoteScreen = None;
			}
		
		if (MyPickScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyPickScreen);
			MyPickScreen = None;
			}
		
		if (MyLoadScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyLoadScreen);
			MyLoadScreen = None;
			}
		
		if (MyClothesScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyClothesScreen);
			MyClothesScreen = None;
			}

		if (MyStatsScreen != None)
			{
			Player.InteractionMaster.RemoveInteraction(MyStatsScreen);
			MyStatsScreen = None;
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function SendHintText(coerce string Msg, float MsgLife)
{
	P2Hud(myHUD).AddTextMessageEx(Msg, MsgLife, class'StringMessagePlus');
}

///////////////////////////////////////////////////////////////////////////////
// Record the old state
///////////////////////////////////////////////////////////////////////////////
function SetMyOldState()
{
	MyOldState = GetStateName();
}

///////////////////////////////////////////////////////////////////////////////
// Something bad has happened and sometimes the dude likes to hear about it
///////////////////////////////////////////////////////////////////////////////
function MarkerIsHere(class<TimedMarker> bliphere,
					  FPSPawn CreatorPawn, 
					  Actor OriginActor,
					  vector blipLoc)
{
	if(bliphere == class'HeadExplodeMarker')
	{
		//WatchHeadExplode(bliphere.OriginPawn);
	}
	else if(bliphere == class'DeadBodyMarker')
	{
		//CheckDeadBody(bliphere.OriginPawn);
	}
	else if(ClassIsChildOf(bliphere, class'DesiredThingMarker'))
	{
		//CheckDesiredThing(bliphere.OriginPawn);
	}
	else if(bliphere == class'DeadCatHitGuyMarker')
	{
	}
	else if(bliphere == class'PanicMarker')
	{
		// Say something about the carnage wrought by you for the first time
		CheckForFirstTimeWeaponSeen(None);//bliphere);
	}
	else if(bliphere == class'GunfireMarker')
	{
	}
	/*
	else if(bliphere == class'PawnShotMarker'
		&& FPSPawn(OriginActor) != None
		&& FPSPawn(OriginActor).Health > 0)
	{
		// Say something about the carnage wrought by you for the first time
		CheckForFirstTimeWeaponUse(CreatorPawn);
	}
	*/
}

/*
///////////////////////////////////////////////////////////////////////////////
// Say something about the carnage wrought by you for the first time
///////////////////////////////////////////////////////////////////////////////
function CheckForFirstTimeWeaponUse(FPSPawn CreatorPawn)
{
	if(WeaponFirstTimeFireInstance == FIRE_WAITING
		&& CreatorPawn == MyPawn)
	{
		if(FRand() <= 0.5)
			MyPawn.Say(MyPawn.myDialog.lDude_WeaponFirstTime);
		WeaponFirstTimeFireInstance=FIRE_ENDED;
	}
}
*/

///////////////////////////////////////////////////////////////////////////////
// Set the type of reaction NPC's have to seeing the player now
///////////////////////////////////////////////////////////////////////////////
function SetSightReaction(FPSPawn.EPawnInitialState NewSightReaction)
{
	SightReaction = NewSightReaction;
	// Always update everyone around you, as you move to a different interest
	MyPawn.ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
}

///////////////////////////////////////////////////////////////////////////////
// Clear the type of reaction NPC's have to seeing the player now
///////////////////////////////////////////////////////////////////////////////
function ClearSightReaction()
{
	SightReaction = MyPawn.EPawnInitialState.EP_Think;
}

///////////////////////////////////////////////////////////////////////////////
// Set speed based on current health
///////////////////////////////////////////////////////////////////////////////
function SetHeartBeatBasedOnHealth()
{
	local float pct;

	pct = 1.0 - (MyPawn.Health/MyPawn.HealthMax);
	// cap percentage
	if(pct < 0.0)
		pct=0.0;
	// heart stuff
	HeartBeatSpeed = HeartBeatSpeedAdd*pct + default.HeartBeatSpeed;
}

///////////////////////////////////////////////////////////////////////////////
// Tell dude he got some health
///////////////////////////////////////////////////////////////////////////////
function NotifyGotHealth(int howmuch)
{
//	MyPawn.Say(MyPawn.myDialog.lDude_GotHealth);
}

///////////////////////////////////////////////////////////////////////////////
// Tell dude he got his vd fixed
///////////////////////////////////////////////////////////////////////////////
function NotifyCuredGonorrhea()
{
	MyPawn.Say(MyPawn.myDialog.lDude_CuredGonorrhea);
}

///////////////////////////////////////////////////////////////////////////////
// Make sure client puts up red bars showing direction of pain and intensity
///////////////////////////////////////////////////////////////////////////////
function ClientHurtBars(pawn InstigatedBy)
{
	local int i;
	local float hitdot, dist, useunit;
	local vector usevec, usevec2, hitcross, disttopawn;
	local bool bCenter, bUpDown;

	//log(self$" rot "$Rotation$" Pawn.Rot "$Pawn.Rotation);

	// Register the hurt so the hud can show the hurt bars to indicate the direction
	// of the attacker
	// First find the direction from the pawn to the attacker.
	if(InstigatedBy != None
		&& InstigatedBy != Pawn)
	{
		disttopawn = InstigatedBy.Location - Pawn.Location;
		usevec = Normal(disttopawn);
	}
	else
		usevec = vector(Pawn.Rotation);
	// Now get the direction of the player
	usevec2 = vector(Rotation);

	// Find the angle of the attacker relative to the player
	hitdot = usevec dot usevec2;
	hitcross = usevec cross usevec2;

	//log(self$" hit dot "$hitdot$" cross "$hitcross$" player "$vector(Rotation));
/*
	// If it's within a certain center range, light up all the hurt, 
	// if it's heavy to a given direction, then light that way up.
	if(hitdot > CENTER_DOT_HIT)
	{
		for(i=0; i<DIRECTIONAL_HURT_BAR_COUNT; i++)
			HurtBarTime[i]=HURT_BAR_FADE_TIME;
	}
	else	// It has a specific direction to the hurt, so calculate it
	{
		dist = abs(0.5*VSize(disttopawn));
		// If differing Z by more than 45 degrees, show up/down
		//if(abs(disttopawn.z) > dist)
		if(abs(hitcross.y) > 0.4)
		{
			// he's below you
			if(hitcross.y < -0.4)
				HurtBarTime[HURT_DIR_DOWN]=HURT_BAR_FADE_TIME;
			else	// above you
				HurtBarTime[HURT_DIR_UP]=HURT_BAR_FADE_TIME;
		}

		// If outside of normal dot range, always show a left or right
		if(hitcross.z < 0)
			HurtBarTime[HURT_DIR_RIGHT]=HURT_BAR_FADE_TIME;
		else
			HurtBarTime[HURT_DIR_LEFT]=HURT_BAR_FADE_TIME;
	}
	*/
	useunit = (abs(hitcross.x) + abs(hitcross.y))/2;
	if(useunit > MIN_DIR
		&& hitdot >= 0)
	{
		// he's above you
		if(usevec2.z > 0)
			HurtBarTime[HURT_DIR_DOWN]=HURT_BAR_FADE_TIME;
		else	// below you
			HurtBarTime[HURT_DIR_UP]=HURT_BAR_FADE_TIME;
		bUpDown=true;
	}
	// draw all forward (all four bars)
	if(hitdot > CENTER_DOT_HIT)
	{
		for(i=0; i<DIRECTIONAL_HURT_BAR_COUNT; i++)
			HurtBarTime[i]=HURT_BAR_FADE_TIME;
		bCenter=true;
	}
	// Tell you left or right, if all else fails
	if((!bUpDown
			&& !bCenter)
		|| abs(hitcross.z) > MIN_DIR)
	{
		// he's to your right
		if(hitcross.z < 0)
			HurtBarTime[HURT_DIR_RIGHT]=HURT_BAR_FADE_TIME;
		else	// he's to your left
			HurtBarTime[HURT_DIR_LEFT]=HURT_BAR_FADE_TIME;
	}
	// Check if we're close to death. If so, show a skull to push the point
	// that you're almost dead.
	if(MyPawn.Health < MyPawn.HealthMax*SKULL_HEALTH_PERC)
	{
		HurtBarTime[HURT_DIR_SKULL]=HURT_BAR_FADE_TIME;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Make sure client puts up black bars showing direction of sniper who
// has got them in his sights
///////////////////////////////////////////////////////////////////////////////
function StartSniperBars(P2Pawn InstigatedBy)
{
	SniperAfterMe = InstigatedBy;
	bSniperBarsClear=false;
}
function EndSniperBars()
{
	SniperAfterMe = None;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function CalcSniperBars(float DeltaTime, float UseMax)
{
	local int i, BarsClear;
	local float hitdot, dist, useunit, FadeTime;
	local vector usevec, usevec2, hitcross, disttopawn;
	local bool bCenter, bUpDown;
	local byte SniperNew[4];

	if(SniperAfterMe != None)
	{
		disttopawn = SniperAfterMe.Location - Pawn.Location;
		usevec = Normal(disttopawn);
		// Now get the direction of the player
		usevec2 = vector(Rotation);

		// Find the angle of the attacker relative to the player
		hitdot = usevec dot usevec2;
		hitcross = usevec cross usevec2;

		useunit = (abs(hitcross.x) + abs(hitcross.y))/2;
		if(useunit > MIN_DIR
			&& hitdot >= 0)
		{
			// he's above you
			if(usevec2.z > 0)
			{
				SniperBarTime[HURT_DIR_DOWN]+=DeltaTime;
				SniperNew[HURT_DIR_DOWN]=1;
			}
			else	// below you
			{
				SniperBarTime[HURT_DIR_UP]+=DeltaTime;
				SniperNew[HURT_DIR_UP]=1;
			}
			bUpDown=true;
		}
		// draw all forward (all four bars)
		if(hitdot > CENTER_DOT_HIT)
		{
			for(i=0; i<DIRECTIONAL_HURT_BAR_COUNT; i++)
			{
				SniperBarTime[i]+=DeltaTime;
				SniperNew[i]=1;
			}
			bCenter=true;
		}
		// Tell you left or right, if all else fails
		if((!bUpDown
				&& !bCenter)
			|| abs(hitcross.z) > MIN_DIR)
		{
			// he's to your right
			if(hitcross.z < 0)
			{
				SniperBarTime[HURT_DIR_RIGHT]+=DeltaTime;
				SniperNew[HURT_DIR_RIGHT]=1;
			}
			else	// he's to your left
			{
				SniperBarTime[HURT_DIR_LEFT]+=DeltaTime;
				SniperNew[HURT_DIR_LEFT]=1;
			}
		}
		/*
		disttopawn = SniperAfterMe.Location - Pawn.Location;
		usevec = Normal(disttopawn);
		// Now get the direction of the player
		usevec2 = vector(Pawn.Rotation);

		// Find the angle of the attacker relative to the player
		hitdot = usevec dot usevec2;
		hitcross = usevec cross usevec2;

		// If it's within a certain center range, light up all the hurt, 
		// if it's heavy to a given direction, then light that way up.
		if(hitdot > CENTER_DOT_HIT)
		{
			for(i=0; i<DIRECTIONAL_HURT_BAR_COUNT; i++)
			{
				SniperBarTime[i]+=DeltaTime;
				SniperNew[i]=1;
			}
		}
		else	// It has a specific direction to the hurt, so calculate it
		{
			dist = abs(0.5*VSize(disttopawn));
			// If differing Z by more than 45 degrees, show up/down
			if(abs(disttopawn.z) > dist)
			{
				// he's below you
				if(disttopawn.z < 0)
				{
					SniperBarTime[HURT_DIR_DOWN]+=DeltaTime;
					SniperNew[HURT_DIR_DOWN]=1;
				}
				else	// above you
				{
					SniperBarTime[HURT_DIR_UP]+=DeltaTime;
					SniperNew[HURT_DIR_UP]=1;
				}
			}

			// If outside of normal dot range, always show a left or right
			if(hitcross.z < 0)
			{
				SniperBarTime[HURT_DIR_RIGHT]+=DeltaTime;
				SniperNew[HURT_DIR_RIGHT]=1;
			}
			else
			{
				SniperBarTime[HURT_DIR_LEFT]+=DeltaTime;
				SniperNew[HURT_DIR_LEFT]=1;
			}
		}
		*/
	}

	// Fade out any of them you didn't at to
	FadeTime = (SNIPER_BAR_FADE*DeltaTime);
	for(i=0; i<ArrayCount(SniperNew); i++)
	{
		// Check to cap times at max
		if(SniperBarTime[i] > UseMax)
			SniperBarTime[i] = UseMax;
		// Any times that didn't increase, should fade out
		if(SniperNew[i] == 0)
		{
			SniperBarTime[i] -= FadeTime;
			if(SniperBarTime[i] < 0)
				SniperBarTime[i]=0;
		}
		if(SniperBarTime[i] == 0)
			BarsClear++;
	}
	if(BarsClear == ArrayCount(SniperNew))
		bSniperBarsClear=true;
}

///////////////////////////////////////////////////////////////////////////////
// Yell when hurt, set up flashy hurt bars, etc.
///////////////////////////////////////////////////////////////////////////////
function NotifyTakeHit(pawn InstigatedBy, vector HitLocation, int Damage, class<DamageType> damageType, vector Momentum)
{
	local float randcheck;
	local bool bExitNow;

	// Getting hurt dialogue for dude
	// Say various things when you get hit.
	// We do things here so we have access to damagetype
	SayTime=0;
	randcheck = FRand();
	if(damageType == class'CrackSmokingDamage')
	{
		SayTime=MyPawn.Say(MyPawn.myDialog.lDude_GotHurtByCrack);
	}
	else if(!bStillYelling)
	{
		if(ClassIsChildOf(damageType, class'BurnedDamage')
			|| damageType == class'OnFireDamage')
		{
			if(MyPawn.TakesOnFireDamage > 0)
				SayTime=MyPawn.Say(MyPawn.myDialog.lGrunt);
			else	// Don't respond when your magically fire resistant.
				bExitNow=true;
		}
		else if(MyPawn.bCrotchHit)
			SayTime=MyPawn.Say(MyPawn.myDialog.lGotHitInCrotch);
		else if(randcheck < 0.85)
			SayTime=MyPawn.Say(MyPawn.myDialog.lGrunt);
		else if(randcheck < 0.9)
			SayTime=MyPawn.Say(MyPawn.myDialog.lGotHit);
		else 
			SayTime=MyPawn.Say(MyPawn.myDialog.lCussing);
	}

	if(SayTime > 0)
	{
		bStillYelling=true;
		SetTimer(SayTime, false);
	}

	if(!bExitNow)
	{
		// Flash bars when hurt (red flashes)
		ClientHurtBars(InstigatedBy);

		// Handle damage rate. Keeps track of how often you've been hurt by the AI
		// or burned by yourself
		if(InstigatedBy != None
			&& ((!FPSPawn(InstigatedBy).bPlayer
					&& ClassIsChildof(damageType, class'BulletDamage'))
				|| ClassIsChildof(damageType, class'OnFireDamage')))
		{
			DamageThisHitTime = Level.TimeSeconds;

			// Check if the last time we were hurt is too far from this current time
			if(DamageFirstHitTime != 0)
			{
				if(DamageThisHitTime - DamageFirstHitTime > LAST_AI_DAMAGE_TIME
					&& (Damage + DamageTotal) > 0
					&& ((Damage + DamageTotal)/(DamageThisHitTime - DamageFirstHitTime)) < LOW_AI_DAMAGE_RATE)
				// Reset the damage counters
				{
					DamageTotal = 0;
					//log(self$" resetting ");
				}
			}

			// First time hurt
			if(DamageTotal == 0)
			{
				DamageTotal = Damage;
				DamageFirstHitTime = Level.TimeSeconds;
				DamageRate = 0;
			}
			else
			{
				DamageTotal += Damage;
				if(DamageThisHitTime - DamageFirstHitTime > 0)
					DamageRate = DamageTotal/(DamageThisHitTime - DamageFirstHitTime);
			}
			//log(self$" new damage rate "$DamageRate$" total "$DamageTotal$" first "$DamageFirstHitTime$" this "$DamageThisHitTime);
		}

		// Show a special flash if it's chem hurt
		if(ClassIsChildof(damageType, class'ChemDamage'))
			FlashChemHurt();

		// set our heartbeat and other things
		damageAttitudeTo(instigatedBy, Damage);
	}
} 

///////////////////////////////////////////////////////////////////////////////
// Speed up heart
///////////////////////////////////////////////////////////////////////////////
function damageAttitudeTo(pawn Other, float Damage)
{
	Super.DamageAttitudeTo(Other, Damage);

	SetHeartBeatBasedOnHealth();
}

///////////////////////////////////////////////////////////////////////////////
// Timers are used for talking and could interrupt our count. 
// We'll add up how long it's been since we used crack in the state code
// of PlayerMoving and PlayerClimbing and such.
///////////////////////////////////////////////////////////////////////////////
function CheckForCrackUse(float TimePassed)
{
	// Filled out in DudePlayer becuase it needs some access to inventory classes.
}

///////////////////////////////////////////////////////////////////////////////
// Return heart time and scale to defaults
///////////////////////////////////////////////////////////////////////////////
function ResetHeart()
{
	HeartTime = 0;
	HeartScale = default.HeartScale;
}

///////////////////////////////////////////////////////////////////////////////
// Setup our crack addiciton
///////////////////////////////////////////////////////////////////////////////
function InitCrackAddiction()
{
	MyPawn.CrackAddictionTime = CrackStartTime;
	//log(MyPawn$" initting crack addiction");
	
	// Calc the final scale size of your heart will be by the end of the crack addiction
	// You will do this over the time from the first time you commented on it, *not*
	// from the entire start time of your addiction
	HeartScaleDelta = HEART_SCALE_CRACK_ADD/CrackHintTimes[MAX_CRACK_HINTS-1];

	// Reset your heart
	ResetHeart();
}

///////////////////////////////////////////////////////////////////////////////
// If the player 'uses' the catnip, he'll smoke it to gain cat-like speed.
///////////////////////////////////////////////////////////////////////////////
function SmokeCatnip()
{
	SetupCatnipUseage(CATNIP_START_TIME);
	MyPawn.Say(MyPawn.myDialog.lDude_SmokedCatnip);
}

///////////////////////////////////////////////////////////////////////////////
// Setup the catnip with this time
///////////////////////////////////////////////////////////////////////////////
function SetupCatnipUseage(float starttime)
{
	if(starttime > 0)
	{
		CatnipUseTime = starttime;
		// Leave a log here just so we know when this was used.
		//log(self$" Setting catnip time--slomo: "$starttime);
		if(P2GameInfoSingle(Level.Game) != None)
			P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1/CATNIP_SPEED);
	}
	else // reset things
	{
		CatnipUseTime = 0;
		//log(self$" Resetting catnip time: "$starttime);
		// Reset effects
		if(P2GameInfoSingle(Level.Game) != None)
			P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1.0);
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function FollowCatnipUse(float TimePassed)
{
	if(CatnipUseTime == 0)
		return;

	CatnipUseTime-=TimePassed;

	if(CatnipUseTime <= 0)
	{
		CatnipUseTime = 0;
		// Reset effects
		P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1.0);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Blow smoke for smoking health pipe and catnip.
///////////////////////////////////////////////////////////////////////////////
simulated function BlowSmoke(vector smokecolor)
{
	// STUB, dudeplayer
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function EatingFood()
{
	// STUB, dudeplayer
}
///////////////////////////////////////////////////////////////////////////////
// Show a flash of color for when you're hurt by chem infection clouds
///////////////////////////////////////////////////////////////////////////////
function FlashChemHurt()
{
}

///////////////////////////////////////////////////////////////////////////////
// Do various things to the heart, mostly used for crack addiction
///////////////////////////////////////////////////////////////////////////////
function ModifyHeartTime(float DeltaTime)
{
	local float AddictionLevel;

	if (MyPawn != None)
	{
		// If we're addicted to crack and you've already commented on how
		// you don't feel so good, give yourself a fake murmur
		if(MyPawn.CrackAddictionTime > 0
			&& MyPawn.CrackAddictionTime <= CrackHintTimes[MAX_CRACK_HINTS-1])
		{
			AddictionLevel = (CrackHintTimes[MAX_CRACK_HINTS-1] - MyPawn.CrackAddictionTime)/MyPawn.CrackAddictionTime;

			// Change heart beat
			if(FRand() <= AddictionLevel)
				HeartTime+=(FRand()*AddictionLevel);

			// Change scale of heart
			HeartScale += (DeltaTime*HeartScaleDelta);
		}
		// Make it beat faster, but in an even fashion (not a jerky fashion)
		// Add in more time to the heart
		else if(CatnipUseTime > 0)
		{
			HeartTime += ((CATNIP_SPEED - 1)*HeartBeatSpeed*DeltaTime);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Slow heart down
///////////////////////////////////////////////////////////////////////////////
function AddedHealth(float HealthAdded, bool bIsAddictive, int Tainted, bool bIsFood)
{
	SetHeartBeatBasedOnHealth();

	// If you got bad health, say so
	if(Tainted == 1)
	{
		MyPawn.Say(MyPawn.myDialog.lPissOnSelf);
		//log(MyPawn$" don't pee on me!");
	}
	// Say something about the nice health
	else if(!bIsAddictive)
	{
		if(bIsFood)
		{
			MyPawn.Say(MyPawn.myDialog.lGotHealthFood);
			//log(MyPawn$" i love food!");
		}
		else
		{
			MyPawn.Say(MyPawn.myDialog.lGotHealth);
			//log(MyPawn$" i love medkits!");
		}
	}
	else
	{
		InitCrackAddiction();
		// Don't make comment about how good it is here.. make crackinv do that later
		// after you exhale.
	}
}

///////////////////////////////////////////////////////////////////////////////
// Say something the first time someone sees your gun out.
///////////////////////////////////////////////////////////////////////////////
function CheckForFirstTimeWeaponSeen(FPSPawn CreatorPawn)
{
	if(WeaponFirstTimeFireInstance == FIRE_NOTHING
		&& CreatorPawn == MyPawn)
	{
		if(FRand() <= 0.5
			&& P2Weapon(CreatorPawn.Weapon) != None
			&& P2Weapon(CreatorPawn.Weapon).ViolenceRank > 1
			&& AllowTalking())
			MyPawn.Say(MyPawn.myDialog.lDude_FirstSeenWithWeapon);
		WeaponFirstTimeFireInstance=FIRE_ENDED;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Most of the time you allow talking. This is usually only checked by NPC's talking
// to you. Sniper mode won't allow talking--you're in the zone.
///////////////////////////////////////////////////////////////////////////////
function bool AllowTalking()
{
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// Say something about the evil health
///////////////////////////////////////////////////////////////////////////////
function CommentOnCrackUse()
{
	MyPawn.Say(MyPawn.myDialog.lGotCrackHealth);
	//log(MyPawn$" crack feels good...");
}

///////////////////////////////////////////////////////////////////////////////
// Say something funny as you fire the weapon, not just as people die
///////////////////////////////////////////////////////////////////////////////
function CommentOnWeaponThrow()
{
	if(FRand() <= SayThingsOnWeaponFire)
	{
		if(MyPawn != None)
			MyPawn.Say(MyPawn.myDialog.lDude_ThrowGrenade);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Talk back while getting arrested
///////////////////////////////////////////////////////////////////////////////
function float CommentOnGettingArrested()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_Arrested) + 0.5;
	SetTimer(SayTime, false);
	bStillTalking=true;
	return SayTime;
}

///////////////////////////////////////////////////////////////////////////////
// Make fun of player for cheating
///////////////////////////////////////////////////////////////////////////////
function CommentOnCheating()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_PlayerCheating) + 0.5;
	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// Say you need to pee badly
///////////////////////////////////////////////////////////////////////////////
function CommentOnNeedingToPee()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_HaveToPee) + 0.5;
	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// Apologize for farting
///////////////////////////////////////////////////////////////////////////////
function float CommentOnFarting()
{
	if(!bStillTalking)
		return MyPawn.Say(MyPawn.myDialog.lApologize);
	return 0.0;
}

///////////////////////////////////////////////////////////////////////////////
// Breath while zoomed in
///////////////////////////////////////////////////////////////////////////////
function float SniperBreathing()
{
	if(!bStillTalking
		&& !bStillYelling)
		return MyPawn.Say(MyPawn.myDialog.lDude_SniperBreathing);
	return 0.0;
}

///////////////////////////////////////////////////////////////////////////////
// Got fired
///////////////////////////////////////////////////////////////////////////////
function GotFired()
{
	MyPawn.Say(MyPawn.myDialog.lDude_GetFired);
}

///////////////////////////////////////////////////////////////////////////////
// If he's essentially someone you'd meet out on the street and kill, he's okay.
// Bystanders and cops/military are included, but protestors/osamas/etc aren't
// because in the linear play situations, you'd run into so many streams in a row
// it'd be way too easy to get. Override this in dudeplayer to include cops/military
///////////////////////////////////////////////////////////////////////////////
function bool ValidQuickKill(P2Pawn DeadGuy)
{
	return DeadGuy.bInnocent;
}

///////////////////////////////////////////////////////////////////////////////
// Say something funny when someone dies (if you're not already talking)
// Only in single player
///////////////////////////////////////////////////////////////////////////////
function SomeoneDied(P2Pawn DeadGuy, P2Pawn Killer, class<DamageType> DeadDamageType)
{
	local bool bValidQuickKilling;
	if(Killer == MyPawn
		&& Level.Game != None
		&& FPSGameInfo(Level.Game).bIsSinglePlayer)
	{
		// You're killing people in quick succession. If you kill the next person
		// within QUICK_KILL_TIME of killing the last one, he'll say something
		// else and give you something.

		// Only check real bystanders for this--innocents. (they may have weapons though).
		bValidQuickKilling = (ValidQuickKill(DeadGuy) && bQuickKilling);
		if(bValidQuickKilling)
		{
			//log(self$" just killed "$DeadGuy$" time "$Level.TimeSeconds$" time section "$(Level.TimeSeconds - QuickKillLastTime));
			if((Level.TimeSeconds - QuickKillLastTime) < (QUICK_KILL_TIME - QuickKillSoundIndex))
			{
				QuickKillLastTime=Level.TimeSeconds;
				DelayedSayLine = QuickKillLine;
				bWaitingToTalk=true;
				SayTime = WAIT_FOR_DEATH_COMMENT_GUN;
				DeadGuy.PickQuickKillPrize(QuickKillSoundIndex);
			}
			else	// You've waited too long... not into the 
			{
				//Pawn.PlaySound(QuickKillBadEndSound, SLOT_Misc);
				bQuickKilling=false;
			}
			if(SayTime > 0
				|| bWaitingToTalk)
			{
				SetTimer(SayTime, false);
				bStillTalking=true;
			}
		}

		if(!bStillTalking
			&& !bValidQuickKilling)
		{
			SayTime = 0;
			if(DeadDamageType == class'OnFireDamage'
				|| ClassIsChildOf(DeadDamageType, class'BurnedDamage'))
			{
				if(FRand() <= SayThingsOnGuyBurningDeathFreq)
					SayTime = MyPawn.Say(MyPawn.myDialog.lDude_BurningPeople) + 0.5;
			}
			else if(DudeIsCop())
			{	
				if(FRand() <= SayThingsOnGuyDeathFreq)
					SayTime = MyPawn.Say(MyPawn.myDialog.lDude_AttackAsCop) + 0.5;
			}
			else if(FRand() <= SayThingsOnGuyDeathFreq)
			{
				if(ClassIsChildOf(DeadDamageType , class'BulletDamage'))
				{
					// Randomly (not very often) start allowing the player to kill people
					// in quick succession (only with guns). Doesn't count sniper rifle
					// head shot kills in this.
					if(!bQuickKilling
						&& FRand() < QUICK_KILL_FREQ
						&& ValidQuickKill(DeadGuy))
					{
						bQuickKilling=true;
						QuickKillSoundIndex=0;
						QuickKillLine = MyPawn.myDialog.lDude_QuickKills;
						QuickKillLastTime=Level.TimeSeconds;
					}
					else // Otherwise, make general comments about killing them with a gun
					{
						if(FRand() < COMMENT_ON_RACE
							&& (P2MocapPawn(DeadGuy).bIsBlack
								|| P2MocapPawn(DeadGuy).bIsMexican
								|| P2MocapPawn(DeadGuy).bIsHindu
								|| P2MocapPawn(DeadGuy).bIsAsian))
							DelayedSayLine = MyPawn.myDialog.lDude_ShootMinorities;
						else
							DelayedSayLine = MyPawn.myDialog.lDude_KillWithGun;
						bWaitingToTalk=true;
						SayTime = WAIT_FOR_DEATH_COMMENT_GUN;
					}
				}
				else if(ClassIsChildOf(DeadDamageType , class'BludgeonDamage'))
				{
					DelayedSayLine = MyPawn.myDialog.lDude_KillWithMelee;
					bWaitingToTalk=true;
					SayTime = WAIT_FOR_DEATH_COMMENT_MELEE;
				}
				else if(ClassIsChildOf(DeadDamageType , class'ExplodedDamage'))
				{
					DelayedSayLine = MyPawn.myDialog.lDude_KillWithProjectile;
					bWaitingToTalk=true;
					SayTime = WAIT_FOR_DEATH_COMMENT_PROJ;
				}
			}

			if(SayTime > 0
				|| bWaitingToTalk)
			{
				SetTimer(SayTime, false);
				bStillTalking=true;
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check to turn on/off the hands
///////////////////////////////////////////////////////////////////////////////
function SetWeaponUseability(bool bUseable, class<P2Weapon> weapclass)
{
	// STUB--defined in dudeplayer
}

///////////////////////////////////////////////////////////////////////////////
// Find the next-highest-ranked weapon (wraps around to lowest-ranked weapon
// if necessary).
///////////////////////////////////////////////////////////////////////////////
simulated function FindNextWeapon(P2Weapon CurrentWeapon, out P2Weapon NewWeap, optional out byte Abort, 
								  optional bool bForce)
{
	local P2Weapon pickweap, checkweap, lowestweap;
	local int pickrank, checkrank, currank, lowestrank;
	local Inventory inv;
	local int Count;

	if(CurrentWeapon == None
		|| CurrentWeapon.AllowNextWeapon() 
		|| bForce)
	{
		// Find the next-highest-ranked weapon after the current weapon.  If there isn't
		// one, then find the lowest-ranked weapon (in other words, wrap around).  We
		// must go through the full list anyway, so we look for both at the same time.
		if(CurrentWeapon != None)
			currank = CurrentWeapon.GetRank();
		else
			warn(self$" NO CurrentWeapon");
		pickrank = 100000;
		lowestrank = 100000;
		// Mypawnfix
		inv = Pawn.Inventory;
		while (inv != None)
		{
			checkweap = P2Weapon(inv);
			//if (checkweap != None)
			//	log(checkweap$" FindNextWeapon, has ammo "$checkweap.AmmoType.AmmoAmount);
			if (checkweap != None
				&& checkweap != pickweap
				&& checkweap.AmmoType.HasAmmo())
			{
				checkrank = checkweap.GetRank();
				if (checkrank > currank && checkrank < pickrank)
				{
					pickrank = checkrank;
					pickweap = checkweap;
				}
				if (checkrank < lowestrank)
				{
					lowestrank = checkrank;
					lowestweap = checkweap;
				}
			}

			if ( Level.NetMode == NM_Client )
			{
				Count++;
				if ( Count > 5000 )
				break;
			}

			inv = inv.Inventory;
		}

		if (pickweap == None)
			pickweap = lowestweap;

		NewWeap = pickweap;
	}
	else
	{
		Abort=1;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Find the next-lowest-ranked weapon (wraps around to highest-ranked weapon
// if necessary).
///////////////////////////////////////////////////////////////////////////////
simulated function FindPrevWeapon(P2Weapon CurrentWeapon, out P2Weapon NewWeap, out byte Abort,
								 optional bool bForce)
{
	local P2Weapon pickweap, checkweap, highestweap;
	local int pickrank, checkrank, currank, highestrank;
	local Inventory inv;
	local int Count;

	if(CurrentWeapon == None
		|| CurrentWeapon.AllowPrevWeapon()
		|| bForce)
	{
		// Find the next-highest-ranked weapon after the current weapon.  If there isn't
		// one, then find the lowest-ranked weapon (in other words, wrap around).  We
		// must go through the full list anyway, so we look for both at the same time.
		if(CurrentWeapon != None)
			currank = CurrentWeapon.GetRank();
		else
			warn(self$" NO CurrentWeapon");
		pickrank = -1;
		highestrank = -1;
		// Mypawnfix
		inv = Pawn.Inventory;
		while (inv != None)
		{
			checkweap = P2Weapon(inv);
			//if (checkweap != None)
			//	log(checkweap$" FindPrevWeapon, has ammo "$checkweap.AmmoType.AmmoAmount);
			if (checkweap != None
				&& checkweap != pickweap
				&& checkweap.AmmoType.HasAmmo())
			{
				checkrank = checkweap.GetRank();
				if (checkrank < currank && checkrank > pickrank)
				{
					pickrank = checkrank;
					pickweap = checkweap;
				}
				if (checkrank > highestrank)
				{
					highestrank = checkrank;
					highestweap = checkweap;
				}
			}

			if ( Level.NetMode == NM_Client )
			{
				Count++;
				if ( Count > 5000 )
				break;
			}

			inv = inv.Inventory;
		}

		if (pickweap == None)
			pickweap = highestweap;

		NewWeap = pickweap;
	}
	else
	{
		Abort=1;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Find a weapon in a specific group, and remember the last weapon you were
// using in this group as the first one to pick
///////////////////////////////////////////////////////////////////////////////
simulated function FindGroupWeapon(byte FindGroup, out P2Weapon NewWeap, out byte Abort)
{
	local P2Weapon pickweap, checkweap, curweap, lowestweap;
	local int pickrank, checkrank, currank, lowestrank;
	local Inventory inv;
	local int Count;

	curweap = P2Weapon(Pawn.Weapon);
	if(curweap != None)
		currank = curweap.GetRank();
	pickrank = 100000;
	lowestrank = 100000;

	// Mypawnfix
	inv = Pawn.Inventory;

	while (inv != None)
	{
		checkweap = P2Weapon(inv);
		if(checkweap != None)
		{
			//log(checkweap$" FindGroupWeapon, has ammo "$checkweap.AmmoType.AmmoAmount);
			if(FindGroup == checkweap.InventoryGroup
				&& checkweap.AmmoType.HasAmmo())
			{
				checkrank = checkweap.GetRank();
				// We disregard the last selected thing because I'm already in the right group
				// and we just look for the next one in the group
				if(curweap != None
					&& curweap.InventoryGroup == FindGroup)
				{
					if (checkrank > currank && checkrank < pickrank)
					{
						pickrank = checkrank;
						pickweap = checkweap;
					}
					if (checkrank < lowestrank)
					{
						lowestrank = checkrank;
						lowestweap = checkweap;
					}
				}
				else // In this version we were on a different group and are coming back to this one
					// so we want to either find the first in the group, or find the one that 
				{
					if(checkweap.bLastSelected)
					{
						pickweap = checkweap;
						pickrank = checkrank;
					}
					if (checkrank > currank 
						&& checkrank < pickrank
						&& (pickweap == None
							|| !pickweap.bLastSelected))
					{
						pickrank = checkrank;
						pickweap = checkweap;
					}
					if(checkrank < lowestrank)
					{
						lowestrank = checkrank;
						lowestweap = checkweap;
					}
				}
			}
		}

		if ( Level.NetMode == NM_Client )
		{
			Count++;
			if ( Count > 5000 )
			break;
		}

		inv = inv.Inventory;
	}

	if(pickweap == None)
		pickweap = lowestweap;


	NewWeap = pickweap;
}

///////////////////////////////////////////////////////////////////////////////
// PrevWeapon()
// switch to previous inventory group weapon
///////////////////////////////////////////////////////////////////////////////
exec function PrevWeapon()
{
	local P2Weapon CWeap, NWeap;
	local byte Abort;

	if( Level.Pauser!=None || Pawn == None )
		return;

	if ( Pawn.Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	if ( Pawn.PendingWeapon != None )
		CWeap = P2Weapon(Pawn.PendingWeapon);
	else
		CWeap = P2Weapon(Pawn.Weapon);

	FindPrevWeapon(CWeap, NWeap, Abort);

	if(Abort == 0)
	{
		Pawn.PendingWeapon = NWeap;

		if ( Pawn.PendingWeapon != None )
		{
			Pawn.Weapon.PutDown();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// NextWeapon()
// switch to next inventory group weapon
//
///////////////////////////////////////////////////////////////////////////////
exec function NextWeapon()
{
	local P2Weapon CWeap, NWeap;
	local byte Abort;

	if( Level.Pauser!=None || Pawn == None )
		return;

	if ( Pawn.Weapon == None )
	{
		SwitchToBestWeapon();
		return;
	}
	if ( Pawn.PendingWeapon != None )
		CWeap = P2Weapon(Pawn.PendingWeapon);
	else
		CWeap = P2Weapon(Pawn.Weapon);

	FindNextWeapon(CWeap, NWeap, Abort);

	if(Abort == 0)
	{
		Pawn.PendingWeapon = NWeap;

		if ( Pawn.PendingWeapon != None )
		{
			Pawn.Weapon.PutDown();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// The player wants to switch to weapon group number F.
///////////////////////////////////////////////////////////////////////////////
exec function SwitchWeapon (byte F )
{
	local P2Weapon NWeap;
	local byte Abort;

	if ( (Level.Pauser!=None) || (Pawn == None) || (Pawn.Inventory == None) )
		return;
	if ( (Pawn.Weapon != None) && (Pawn.Weapon.Inventory != None) )
		FindGroupWeapon(F, NWeap, Abort);
		//newWeapon = Pawn.Weapon.Inventory.WeaponChange(F);
	else
		NWeap = None;	
	if ( NWeap == None )
		FindGroupWeapon(F, NWeap, Abort);
		//newWeapon = Pawn.Inventory.WeaponChange(F);

	if ( NWeap == None )
		return;

	if ( Pawn.Weapon == None
		|| Pawn.Weapon.bDeleteMe)
	{
		Pawn.PendingWeapon = NWeap;
		Pawn.ChangedWeapon();
	}
	else if ( Pawn.Weapon != NWeap || Pawn.PendingWeapon != None )
	{
		Pawn.PendingWeapon = NWeap;
		if ( !Pawn.Weapon.PutDown() )
		{
			Pawn.PendingWeapon = None;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
exec function SwitchToBestWeapon()
{
	local float rating;

	log(self$" switch to best "$Pawn.Weapon);
	if( Level.Pauser!=None)
		return;

	if ( Pawn == None || Pawn.Inventory == None )
		return;

	StopFiring();
	Pawn.PendingWeapon = Pawn.Inventory.RecommendWeapon(rating);
	if ( Pawn.PendingWeapon == Pawn.Weapon )
		Pawn.PendingWeapon = None;
	if ( Pawn.PendingWeapon == None )
		return;

	if ( Pawn.Weapon == None
		|| Pawn.Weapon.bDeleteMe)
		Pawn.ChangedWeapon();

	if ( Pawn.Weapon != Pawn.PendingWeapon 
		&& Pawn.PendingWeapon != None)
		Pawn.Weapon.PutDown();
}

///////////////////////////////////////////////////////////////////////////////
// Different than 'find best weapon', this skips certain weapons that
// aren't good to switch to in the heat of combat.
///////////////////////////////////////////////////////////////////////////////
function bool SwitchAfterOutOfAmmo()
{
	local Inventory inv, pickinv;
	local float currat, newrat;
	local int Count;

	// Mypawnfix
	if ( Pawn.Inventory == None )
		return false;

	StopFiring();
	inv = Pawn.Inventory;

	// Combat rating
	if(P2Weapon(Pawn.Weapon) != None)
		currat = P2Weapon(Pawn.Weapon).CombatRating;
	newrat = -1;

	while(inv != None)
	{
		if(P2Weapon(inv) != None
			// Make sure it has ammo
			&& P2AmmoInv(Weapon(inv).AmmoType).HasAmmo()
			&& P2Weapon(inv).CombatRating > newrat)
		{
			newrat = P2Weapon(inv).CombatRating;
			pickinv = inv;
		}

		if ( Level.NetMode == NM_Client )
		{
			Count++;
			if ( Count > 5000 )
			break;
		}

		inv = inv.Inventory;
	}

	if(pickinv != None)
	{
		// Mypawnfix
		Pawn.PendingWeapon = Weapon(pickinv);
	}
	else
	{
		ToggleToHands();
		return false;
	}
	
	if ( Pawn.PendingWeapon == Pawn.Weapon )
		Pawn.PendingWeapon = None;
	if ( Pawn.PendingWeapon == None )
		return true;

	if ( Pawn.Weapon == None 
		|| Pawn.Weapon.bDeleteMe)
		Pawn.ChangedWeapon();

	if ( Pawn.Weapon != Pawn.PendingWeapon 
		&& Pawn.PendingWeapon != None)
		Pawn.Weapon.PutDown();

	return true;
}

///////////////////////////////////////////////////////////////////////////////
// We've stated a weapon we want to switch to
///////////////////////////////////////////////////////////////////////////////
function bool SwitchToThisWeapon(int GroupNum, int OffsetNum, optional bool bForceReady)
{
	local Inventory inv;
	local bool bFoundIt;
	local int Count;

	// Mypawnfix
	if ( Pawn.Inventory == None )
		return false;

	StopFiring();
	inv = Pawn.Inventory;

	//log("Group num"$GroupNum);
	//log("Offset num "$OffsetNum);

	while(inv != None
		&& !bFoundIt)
	{
		//log("inv "$inv);
		//log("inv group "$inv.InventoryGroup);
		//log("inv offset "$inv.GroupOffset);
		if(Weapon(inv) != None 
			&& inv.InventoryGroup == GroupNum 
			&& inv.GroupOffset == OffsetNum)
			bFoundIt=true;
		else
			inv = inv.Inventory;

		if ( Level.NetMode == NM_Client )
		{
			Count++;
			if ( Count > 5000 )
			break;
		}

	}

	if(bFoundIt)
	{
		// Make sure our pending weapon has some ammo
		// Don't use HasAmmo--it checks ammo readiness. We need to simply see if it's either
		// infinite or has any ammo at all-we don't care about weapon readiness here. 
		if(!P2AmmoInv(Weapon(inv).AmmoType).HasAmmoStrict())
		{
			return false;
		}
		else
			Pawn.PendingWeapon = Weapon(inv);
	}
	else
		return bFoundIt;
	
	//log("success "$Pawn.PendingWeapon);
	//log("w group "$Pawn.PendingWeapon.InventoryGroup);
	//log("w offset "$Pawn.PendingWeapon.GroupOffset);
	//log("pending level "$Pawn.PendingWeapon.InventoryGroup);

	// If force ready, then make sure this weapon is set to useable (like the clipboard
	// may have turned the hands off, but we want to definitely use it so turn them
	// back on.)
	if(bForceReady
		&& P2Weapon(Pawn.PendingWeapon) != None)
		P2Weapon(Pawn.PendingWeapon).SetReadyForUse(true);
	
	if ( Pawn.PendingWeapon == Pawn.Weapon )
		Pawn.PendingWeapon = None;
	if ( Pawn.PendingWeapon == None )
		return bFoundIt;

	if ( Pawn.Weapon == None 
		|| Pawn.Weapon.bDeleteMe)
		Pawn.ChangedWeapon();

	if ( Pawn.Weapon != Pawn.PendingWeapon 
		&& Pawn.PendingWeapon != None)
		Pawn.Weapon.PutDown();

	return bFoundIt;
}

///////////////////////////////////////////////////////////////////////////////
// Given the group, find the weapon that's furtherst down in the offsets. 
// For instance, group 0, should be Urethra, Hands, Clipboard. So given
// the dude always has the first two, this will switch to the hands. But on a
// day he has the clipboard, he'll pick that has his 'hands'.
///////////////////////////////////////////////////////////////////////////////
exec function SwitchToLastWeaponInGroup(int GroupNum)
{
	local Inventory inv, last;
	local int lastoffset;
	local int Count;

	if( Level.Pauser!=None)
		return;

	if ( Pawn == None || Pawn.Inventory == None )
		return;

	StopFiring();
	inv = Pawn.Inventory;
	lastoffset = -1;

	while(inv != None)
	{
		if(Weapon(inv) != None)
		{
			//log(self$" checking "$inv$" my ammo "$Weapon(inv).AmmoType$" is ready? "$P2AmmoInv(Weapon(inv).AmmoType).bReadyForUse);
			if(Weapon(inv).AmmoType.HasAmmo())
			{
				//log(self$" has ammo "$inv);
				if(inv.InventoryGroup == GroupNum
					&& inv.GroupOffset > lastoffset)
				{
					last = inv;
					lastoffset = inv.GroupOffset;
				//log(self$" picking "$lastoffset);
				}
			}
		}

		if ( Level.NetMode == NM_Client )
		{
			Count++;
			if ( Count > 5000 )
			break;
		}

		inv = inv.Inventory;
	}

	if(last != None)
		Pawn.PendingWeapon = Weapon(last);
	else
		return;

	//log(self$" REALLY picking "$last$" pending "$Pawn.PendingWeapon$" my weap "$Pawn.Weapon$" delete me "$Pawn.Weapon.bDeleteMe);

	if ( Pawn.PendingWeapon == Pawn.Weapon )
		Pawn.PendingWeapon = None;
	if ( Pawn.PendingWeapon == None )
		return;

	if ( Pawn.Weapon == None 
		|| Pawn.Weapon.bDeleteMe)
		Pawn.ChangedWeapon();

	if ( Pawn.Weapon != Pawn.PendingWeapon 
		&& Pawn.PendingWeapon != None)
		Pawn.Weapon.PutDown();
}

///////////////////////////////////////////////////////////////////////////////
// We've stated an item we want to switch to
///////////////////////////////////////////////////////////////////////////////
function bool SwitchToThisPowerup(int GroupNum, int OffsetNum)
{
	local Inventory inv;
	local int Count;

	if( Level.Pauser!=None)
		return false;

	if ( Pawn.Inventory == None )
		return false;

	inv = Pawn.Inventory;

	//log("Group num"$GroupNum);
	//log("Offset num "$OffsetNum);

	while(inv != None
		&& !(inv.InventoryGroup == GroupNum
		&& inv.GroupOffset == OffsetNum))
	{
		//log("inv "$inv);
		//log("inv group "$inv.InventoryGroup);
		//log("inv offset "$inv.GroupOffset);
		inv = inv.Inventory;
		if ( Level.NetMode == NM_Client )
		{
			Count++;
			if ( Count > 5000 )
			break;
		}
	}

	if(inv != None 
		&& inv.InventoryGroup == GroupNum 
		&& inv.GroupOffset == OffsetNum)
	{
		if(Powerups(inv) != None)
		{
			if(Powerups(inv).bActivatable)
			{
				// Mypawnfix
				Pawn.SelectedItem = Powerups(inv);
				return true;
			}
		}
		else
			log(self$" ERROR: SwitchToThisPowerup, inv not a powerup "$inv$" Group offset probably bad");
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// The player wants to select previous item
///////////////////////////////////////////////////////////////////////////////
exec function PrevItem()
{
	if( Level.Pauser!=None)
		return;

	if(Pawn != None
		&& Pawn.Inventory != None)
	{
		Super.PrevItem();
		InvChanged();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Tell the hud about new inventory hints
///////////////////////////////////////////////////////////////////////////////
function InvChanged()
{
	UpdateHudInvHints();
}

///////////////////////////////////////////////////////////////////////////////
// Send the hud the current inventory item's hints
///////////////////////////////////////////////////////////////////////////////
function UpdateHudInvHints()
{
	local String str1, str2, str3;
	local byte InfiniteHintTime;

	if(P2PowerupInv(MyPawn.SelectedItem) != None)
	{
		P2PowerupInv(MyPawn.SelectedItem).GetHints(MyPawn, str1, str2, str3, InfiniteHintTime);
		if(P2Hud(MyHud) != None)
			P2Hud(MyHud).SetInvHints(str1, str2, str3, InfiniteHintTime);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Turn your inventory and weapon hints on or off. If you turn them on,
// go through, and turn back on any hints that the user turned off by using them.
///////////////////////////////////////////////////////////////////////////////
exec function ToggleInvHints()
{
	local Inventory inv;

	if(Pawn != None)
	{
		// Turning them off so clear all inv hints
		if(P2GameInfo(Level.Game).bInventoryHints)
		{
			P2GameInfo(Level.Game).ClearInventoryHints();
			// Go through all your inventory and weapons and reset their hints
			// Mypawnfix
			inv = Pawn.Inventory;
			while (inv != None)
			{
				if(P2PowerupInv(inv) != None)
					P2PowerupInv(inv).RefreshHints();
				else if(P2Weapon(inv) != None)
					P2Weapon(inv).RefreshHints();
				inv = inv.Inventory;
			}
		}

		P2GameInfo(Level.Game).bInventoryHints = !P2GameInfo(Level.Game).bInventoryHints;

		// Make sure to update the hud if we're coming back on
		if(P2GameInfo(Level.Game).bInventoryHints)
		{
			UpdateHudInvHints();
			if(P2Weapon(Pawn.Weapon) != None)
				P2Weapon(Pawn.Weapon).UpdateHudHints();
			ClientMessage(HintsOnText);
		}
		else
			ClientMessage(HintsOffText);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Decide if we're going to put up death hint messages and whether or not
// to increment them so the player will get a different one next time.
///////////////////////////////////////////////////////////////////////////////
function IncDeathMessageNum()
{
	if(DamageRate > MIN_DAMAGE_RATE_TO_SHOW_HINT
		&& DamageTotal > LOW_AI_DAMAGE_TOTAL
		&& !bCommitedSuicide
		&& MyPawn.DyingDamageType != class'OnFireDamage')
	{
		P2GameInfo(Level.Game).DeathMessageUseNum++;
		if(P2GameInfo(Level.Game).DeathMessageUseNum >= DEATH_MESSAGE_MAX)
			P2GameInfo(Level.Game).DeathMessageUseNum = 0;
		// Save which message we'll use next
		ConsoleCommand("set "@DeathMessagePath@P2GameInfo(Level.Game).DeathMessageUseNum);
	}
}

///////////////////////////////////////////////////////////////////////////////
// If you died in a manner that seems like you need help (you got shot up
// for a long time, just standing there) then return true and send out
// some helpful advice
///////////////////////////////////////////////////////////////////////////////
function bool GetDeathHints(out array<string> strs)
{
	if((DamageRate > MIN_DAMAGE_RATE_TO_SHOW_HINT
			|| (MyPawn.DyingDamageType == class'OnFireDamage'
				&& !P2GameInfo(Level.Game).bPlayerPissedHimselfOut))
		&& DamageTotal > LOW_AI_DAMAGE_TOTAL
		&& !bCommitedSuicide)
	{
		// If you burned to death and have never put yourself out, give a special
		// message of hints on how to do that
		if(MyPawn.DyingDamageType == class'OnFireDamage')
		{
			if(!P2GameInfo(Level.Game).bPlayerPissedHimselfOut)
			{
				strs = FireDeathHints1;
				return true;
			}
			else
				return false;
		}
		else
		{
			switch(P2GameInfo(Level.Game).DeathMessageUseNum)
			{
				case 0:
					strs = DeathHints1;
					break;
				case 1:
					strs = DeathHints2;
					break;
				case 2:
					strs = DeathHints3;
					break;
			}
			return true;
		}
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// You're getting mugged by someone
///////////////////////////////////////////////////////////////////////////////
function SetupGettingMugged(P2Pawn NewMugger)
{
	if(InterestPawn == None)
	{
		InterestPawn = NewMugger;
		GotoState('PlayerGettingMugged');
	}
}

///////////////////////////////////////////////////////////////////////////////
// Return true if it's okay to mug you now
// Make sure you're only dealing with the mugger no one, and
// that you have some cash to take
///////////////////////////////////////////////////////////////////////////////
function bool CanBeMugged(P2Pawn NewMugger)
{
	return ((InterestPawn == NewMugger
				|| InterestPawn == None)
				&& CashPlayerHas() > 0);
}

///////////////////////////////////////////////////////////////////////////////
// Only show these when you're in getting mugged mode
///////////////////////////////////////////////////////////////////////////////
function bool GetMuggerHints(out String str1, out String str2)
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// He really means it now!
///////////////////////////////////////////////////////////////////////////////
function EscalateMugging()
{
}

///////////////////////////////////////////////////////////////////////////////
// For when the mugger wants to end with the player
///////////////////////////////////////////////////////////////////////////////
function UnhookPlayerGetMugged()
{
}

///////////////////////////////////////////////////////////////////////////////
// Returns the number of dollars the player has right now.
///////////////////////////////////////////////////////////////////////////////
function float CashPlayerHas()
{
	return 0;
}

///////////////////////////////////////////////////////////////////////////////
// Pop up the radar in the hud
///////////////////////////////////////////////////////////////////////////////
exec function ShowRadar()
{
	if( Level.Pauser!=None)
		return;

	//MYpawnfix
	if(P2Pawn(Pawn) != None)
	{
		if(RadarState != ERadarOff)
			RadarState=ERadarOff;
		else
			RadarState=ERadarOn;
		if(RadarState != ERadarOff)
		{
			if(MyHud != None)
				RadarBackY=P2Hud(MyHud).GetRadarYOffset();
			P2Pawn(Pawn).ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Pop it in, ready to start warming
///////////////////////////////////////////////////////////////////////////////
simulated function BringupRadar()
{
	if(P2Hud(MyHud) != None)
	{
		Pawn.PlaySound(RadarClickSound, SLOT_Misc, 1.0,,TransientSoundRadius);
		RadarBackY=P2Hud(MyHud).GetStartRadarY();
	}
	RadarState = ERadarBringUp;
}

///////////////////////////////////////////////////////////////////////////////
// It's powered down, not it's sitting there, ready to blink away
///////////////////////////////////////////////////////////////////////////////
simulated function DropdownRadar()
{
	Pawn.PlaySound(RadarClickSound, SLOT_Misc, 1.0,,TransientSoundRadius);
	RadarState = ERadarDropDown;
}
///////////////////////////////////////////////////////////////////////////////
// Let it warm up, and eventually turn on. 
///////////////////////////////////////////////////////////////////////////////
simulated function WarmupRadar()
{
	if(P2Hud(MyHud) != None)
	{
		// Snap it up there
		RadarBackY=P2Hud(MyHud).GetRadarYOffset();
		Pawn.PlaySound(RadarBuzzSound, SLOT_Misc, 1.0,,TransientSoundRadius);
	}
	RadarState = ERadarWarmUp;
}
///////////////////////////////////////////////////////////////////////////////
// Let it cool down, ready to turn off
///////////////////////////////////////////////////////////////////////////////
simulated function CooldownRadar()
{
	RadarState = ERadarCoolDown;
}
///////////////////////////////////////////////////////////////////////////////
// Power it along more
// RadarAmount is how much energy left the radar has.
// If you are in targetting mode, it will
// simply report this to the radar, and it won't take any battery time from you.
///////////////////////////////////////////////////////////////////////////////
simulated function bool BoostRadar(int RadarAmount)
{
	if(RadarState != ERadarOn)
	{
		RadarState = ERadarOn;
		//Mypawnfix
		P2Pawn(Pawn).ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	}
	// Not using targetting, so take battery time
	if(RadarTargetState == 0)
		return true;
	else	// In targetting mode, so supspend battery time.
		return false;
}
///////////////////////////////////////////////////////////////////////////////
// Shut off immediately with no cool down. 
///////////////////////////////////////////////////////////////////////////////
simulated function ShutoffRadar()
{
	RadarState = ERadarOff;
	// Turn off RadarTarget too if you have it up
	EndRadarTarget();
}
///////////////////////////////////////////////////////////////////////////////
// These are for P2HUD to decide what/when to show things
///////////////////////////////////////////////////////////////////////////////
simulated function bool ShowRadarBackOnly()
{
	if(RadarState == ERadarBringUp
		|| RadarState == ERadarDropDown)
		return true;
	return false;
}
simulated function bool ShowRadarBringingUp()
{
	return (RadarState == ERadarBringUp);
}
simulated function bool ShowRadarDroppingDown()
{
	return (RadarState == ERadarDropDown);
}
simulated function bool ShowRadarFlicker()
{
	if(RadarState == ERadarWarmUp
		|| RadarState == ERadarCoolDown)
		return true;
	return false;
}
simulated function bool ShowRadarFull()
{
	if(RadarState == ERadarOn)
		return true;
	return false;
}
simulated function bool ShowRadarAny()
{
	if(RadarState != ERadarOff)
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Handles the radar's ability to recognize cops
///////////////////////////////////////////////////////////////////////////////
simulated function SetRadarShowCops(bool bNewState)
{
	bRadarShowCops=bNewState;
}
///////////////////////////////////////////////////////////////////////////////
// Handles the radar's ability to recognize concealed weapons
///////////////////////////////////////////////////////////////////////////////
simulated function SetRadarShowGuns(bool bNewState)
{
	bRadarShowGuns=bNewState;
}

///////////////////////////////////////////////////////////////////////////////
// Setup the camera on the rocket that's travelling now
///////////////////////////////////////////////////////////////////////////////
function StartViewingRocket(Actor NewRocket)
{
	SetViewTarget(NewRocket);
	ViewTarget.BecomeViewTarget();
	GotoState('PlayerWatchRocket');
}

///////////////////////////////////////////////////////////////////////////////
// Restore the player as the view target
///////////////////////////////////////////////////////////////////////////////
function StopViewingRocketOrTarget()
{
	// STUB
}

///////////////////////////////////////////////////////////////////////////////
// Tell rocket what input for movement the player is giving
///////////////////////////////////////////////////////////////////////////////
function ModifyRocketMotion(out float PlayerTurnX, out float PlayerTurnY)
{
	// STUB
}

///////////////////////////////////////////////////////////////////////////////
// The rocket blew up
///////////////////////////////////////////////////////////////////////////////
function RocketDetonated(Actor HitThing)
{
	// STUB
}

///////////////////////////////////////////////////////////////////////////////
// If our rocket is in the state without gas, we say so
///////////////////////////////////////////////////////////////////////////////
function bool RocketHasGas()
{
	if(P2Projectile(ViewTarget) != None)
		return P2Projectile(ViewTarget).AllowControl();
	return false;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function bool StartRadarTarget()
{
	//Mypawnfix
	if(Pawn.Health > 0
		&& Pawn.Physics == PHYS_Walking
		&& RadarState == ERadarOn
		&& RadarTargetState == ERTargetOff
		&& InterestPawn == None)
	{	
		// Reset target position
		RadarTargetX = 0;
		RadarTargetY = 0;
		RadarTargetState=ERTargetPaused;
		RadarTargetTimer = RADAR_TARGET_START_TIME;
		RadarTargetAnimTime=TARGET_FRAME_TIME;
		GotoState('PlayerRadarTargetting');
		return true;
	}
	return false;
}

function EndRadarTarget()
{
	if(RadarTargetState != ERTargetOff)
	{
		RadarTargetState=ERTargetOff;
		GotoState('PlayerWalking');
	}
}
// Radar targetting system is waiting for someone to play 
// or they are currently playing
function bool RadarTargetReady()
{
	if(RadarTargetState > ERTargetOff
		&& RadarTargetState <= ERTargetOn
		&& ViewTarget == MyPawn)
		return true;
	return false;
}
// We're focussed on someone else, killing them
function bool RadarTargetKilling()
{
	if(RadarTargetState > ERTargetOn
		&& ViewTarget != MyPawn)
		return true;
	return false;
}
// We're done targetting, showing stats now
function bool RadarTargetStats()
{
	if((RadarTargetState == ERTargetStats
			|| RadarTargetState == ERTargetStatsWait)
		&& ViewTarget == MyPawn)
		return true;
	return false;
}
// You're ready for input after stats
function bool RadarTargetStatsGetInput()
{
	if(RadarTargetState == ERTargetStats
		&& ViewTarget == MyPawn)
		return true;
	return false;
}

function int RadarTargetKillHint()
{
	return (RadarTargetState - ERTargetKilling1);
}

function bool RadarTargetWaiting()
{
	return (RadarTargetState == ERTargetWaiting);
}

function bool RadarTargetIsOn()
{
	return (RadarTargetState == ERTargetOn);
}

function float GetRadarTargetTimer()
{
	return RadarTargetTimer;
}

function bool RadarTargetNotStartedYet()
{
	return(RadarTargetTimer == RADAR_TARGET_START_TIME);
}

function int GetRadarTargetFrame()
{
	return RadarTargetAnimTime/TARGET_FRAME_TIME;
}
function TargetKillsPawn(FPSPawn KillMe)
{
	// STUB--defined in PlayerRadarTargetting
}
function SetupTargetPrizeTextures()
{
	// STUB--defined in DudePlayer
}

///////////////////////////////////////////////////////////////////////////////
// Return the inventory item, but don't switch to it
///////////////////////////////////////////////////////////////////////////////
function Inventory GetInv(int GroupNum, int OffsetNum)
{
	local Inventory inv;

	if ( Pawn.Inventory == None )
		return None;

	inv = Pawn.Inventory;

	while(inv != None
		&& !(inv.InventoryGroup == GroupNum
		&& inv.GroupOffset == OffsetNum))
	{
		//log("inv "$inv);
		//log("inv group "$inv.InventoryGroup);
		//log("inv offset "$inv.GroupOffset);
		inv = inv.Inventory;
	}

	return inv;
}

///////////////////////////////////////////////////////////////////////////////
// Like Controller HandlePickup, we can take a pickup class
///////////////////////////////////////////////////////////////////////////////
function HandlePickupClass(class<Pickup> pclass)
{
	ReceiveLocalizedMessage( pclass.default.MessageClass, 
							0, None, None, pclass );
}

///////////////////////////////////////////////////////////////////////////////
// Go through all your weapons and change out the hands texture for this new one
///////////////////////////////////////////////////////////////////////////////
function ChangeAllWeaponHandTextures(Texture NewHandsTexture, Texture NewFootTexture)
{
	local Inventory inv;

	//Mypawnfix
	inv = Pawn.Inventory;

	// Do all the weapons in your inventory
	while(inv != None)
	{
		if(P2Weapon(inv) != None)
		{
			P2Weapon(inv).ChangeHandTexture(NewHandsTexture, DefaultHandsTexture, NewFootTexture);
		}
		inv = inv.Inventory;
	}
	if(P2Pawn(Pawn) != None
		&& P2Pawn(Pawn).MyFoot != None)
	{
		// Now do your foot
		P2Pawn(Pawn).MyFoot.ChangeHandTexture(NewHandsTexture, DefaultHandsTexture, NewFootTexture);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Go through all your weapons and modify their speeds
///////////////////////////////////////////////////////////////////////////////
function ChangeAllWeaponSpeeds(float NewSpeed)
{
	local Inventory inv;

	//Mypawnfix
	inv = Pawn.Inventory;

	// Do all the weapons in your inventory
	while(inv != None)
	{
		if(P2Weapon(inv) != None)
		{
			P2Weapon(inv).ChangeSpeed(NewSpeed);
		}
		inv = inv.Inventory;
	}
	if(P2Pawn(Pawn) != None
		&& P2Pawn(Pawn).MyFoot != None)
	{
		// Now do your foot
		P2Pawn(Pawn).MyFoot.ChangeSpeed(NewSpeed);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check if we can use these clothes and they aren't the same as what we
// have on, if so, change them.
///////////////////////////////////////////////////////////////////////////////
function bool CheckForChangeClothes(class<Inventory> NewClothesClass)
{
	//	STUB--check dudeplayer
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
	//	STUB--check dudeplayer
}

///////////////////////////////////////////////////////////////////////////////
// Change the dudes clothes from what they are now, to the this new clothing
// type, and if specified, keep the old clothes in his inventory
///////////////////////////////////////////////////////////////////////////////
function ChangeToNewClothes()
{
	//	STUB--check dudeplayer
}

///////////////////////////////////////////////////////////////////////////////
// Just finished putting my clothes on, say something funny
///////////////////////////////////////////////////////////////////////////////
function FinishedPuttingOnClothes()
{
	//	STUB--check dudeplayer
}

///////////////////////////////////////////////////////////////////////////////
// I just finished dressing as the cop, so say something
///////////////////////////////////////////////////////////////////////////////
function BecomingCop()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_BecomingCop) + 0.5;

	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// I just finished dressing as the cop, so say something
///////////////////////////////////////////////////////////////////////////////
function NowIsCop()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_NowIsCop) + 0.5;

	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// I just finished dressing back as Dude, so say something
///////////////////////////////////////////////////////////////////////////////
function NowIsDude()
{
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_NowIsDude) + 0.5;

	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// I just finished dressing back as Gimp, so say something
///////////////////////////////////////////////////////////////////////////////
function NowIsGimp()
{
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed as boring old me...
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsDude()
{
	//	STUB--check dudeplayer
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed a cop! (for ai use)
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsCop()
{
	//	STUB--check dudeplayer
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// I'm dressed the gimp! (for ai use)
///////////////////////////////////////////////////////////////////////////////
function bool DudeIsGimp()
{
	//	STUB--check dudeplayer
	return false;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Errand Code start

///////////////////////////////////////////////////////////////////////////////
// You finished an errand early, not really doing it well
///////////////////////////////////////////////////////////////////////////////
function ErrandIsCloseEnough()
{
	// noise for the moment of getting gas on you
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_CloseEnough) + 0.5;

	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// You dropped something important
///////////////////////////////////////////////////////////////////////////////
function NeedThatForAnErrand()
{
	MyPawn.Say(MyPawn.myDialog.lDude_NeedsItem);
}

// Errand Code end
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Search around this spot, in limited fashion for the teleporter we just came from
// Find closest one!
///////////////////////////////////////////////////////////////////////////////
function Telepad TelepadWeCameFrom(vector TLoc)
{
	local Telepad closet, checkt;
	local float closer, checkr;

	closer = GRAB_TELEPORTER_RADIUS;

	foreach RadiusActors(class'Telepad', checkt, GRAB_TELEPORTER_RADIUS, TLoc)
	{
		checkr = VSize(checkt.Location - TLoc);
		if(checkr < closer)
		{
			closer = checkr;
			closet = checkt;
		}
	}

	return closet;
}

///////////////////////////////////////////////////////////////////////////////
// This gets called before the player is sent to another level
///////////////////////////////////////////////////////////////////////////////
function PreTravel()
{
	local int i;
	local P2Screen screen;
	local Inventory inv;

	// Tell screens
	for (i = 0; i < Player.LocalInteractions.Length; i++)
	{
		screen = P2Screen(Player.LocalInteractions[i]);
		if (screen != None)
			screen.PreTravel();
	}

	// This used to access none because of no Pawn check after a restart 
	// level load (spacebar on death)
	if(Pawn != None)
	{
		// Tell your weapons
		inv = Pawn.Inventory;
		while(inv != None)
		{
			if(P2Weapon(inv) != None)
				P2Weapon(inv).PreTravel();
			inv = inv.Inventory;
		}
	}
}

/*
///////////////////////////////////////////////////////////////////////////////
// If the player came in at a player start, make sure it's the right one for
// this day. We need the GameState to do this, that's why we wait
// till TravelPostAccept to check. It may be that the one he's at
// is only to be used for a demo day, or later day, so pick him up and move him
// if this is the case. We don't mess with teleporters/telepads/telemarketers--
// we assume those are correctly linked for the various days.
///////////////////////////////////////////////////////////////////////////////
function WarpPlayerToProperStart()
{
	local float BestRating, NewRating;
	local NavigationPoint np, BestStart;
	local byte Needed, SpecifiedDay;

	if(PlayerStart(StartSpot) != None)
	{
		P2GameInfoSingle(Level.Game).NeededForThisDay(StartSpot, Needed, SpecifiedDay);
		if(Needed == 0)
		{
			// The player start he's at is bad for this day.. move him
			for ( np=Level.NavigationPointList; np!=None; np=np.NextNavigationPoint )
			{
				// We don't know the InTeam var here, so we don't specify it
				NewRating = Level.Game.RatePlayerStart(np,0,self);
				P2GameInfoSingle(Level.Game).NeededForThisDay(np, Needed, SpecifiedDay);
				if(Needed==1)
					NewRating+=10000;
				if ( NewRating > BestRating )
				{
					BestRating = NewRating;
					BestStart = np;
				}
			}
			if(BestStart != None)
			{
				if(Pawn.SetLocation(BestStart.Location))
				{
					Pawn.SetRotation(BestStart.Rotation);
					StartSpot=BestStart;
				}
			}
			else
				warn("Playerstart was bad for this day, but we couldn't find a new/valid one");
		}

	// Trigger the event associated with the correct playerstart
	TriggerEvent( StartSpot.Event, StartSpot, Pawn);
	}
}
*/

///////////////////////////////////////////////////////////////////////////////
// Called after travel to a new level
///////////////////////////////////////////////////////////////////////////////
event TravelPostAccept()
{
	local vector Loc, UseLoc;
	local Telepad tpad;
	local int i;
	local P2Screen screen;

	if ( MyPawn.Health <= 0 )
		MyPawn.Health = MyPawn.Default.Health;

	// Reposition based on offset from teleporter before the level change
	tpad = TelepadWeCameFrom(MyPawn.Location);
	if(tpad != None && tpad.tmarker != None)
		UseLoc = tpad.tmarker.Location;
	else
		UseLoc = MyPawn.Location;

	// Now make sure he snaps to the ground nicely.
	Loc = MyPawn.FindBestLocAfterTeleport(UseLoc, UseLoc, MyPawn.CollisionHeight);
	MyPawn.SetLocation(Loc);

	// Give the game a chance to do some special stuff after a travel
	if (P2GameInfoSingle(Level.Game) != None)
		P2GameInfoSingle(Level.Game).PostTravel(MyPawn);

	// Add default inventory UNLESS we're loading a saved game, in which case
	// the player will already have everything he's supposed to have
	if (P2GameInfoSingle(Level.Game) == None || !P2GameInfoSingle(Level.Game).bLoadedSavedGame)
		{
		Log("TravelPostAccept(): Calling AddDefaultInventory");
		MyPawn.AddDefaultInventory();
		}
	else
		Log("TravelPostAccept(): Not calling AddDefaultInventory");

	// Tell screens about it (this must be after the game state is valid)
	for (i = 0; i < Player.LocalInteractions.Length; i++)
		{
		screen = P2Screen(Player.LocalInteractions[i]);
		if (screen != None)
			screen.PostTravel();
		}

	// If we we're preparing to save, get us out of that
	if(IsInState('PlayerPrepSave'))
	{
		ExitPrepToSave();
	}

	// Classic debug message that must never be removed for any reason.
	if(MyPawn.MyUrethra == None)
		log("I'm a p2pawn and I have no urethra "$self);
//	WarpPlayerToProperStart();
}

///////////////////////////////////////////////////////////////////////////////
// doused himself with gas
///////////////////////////////////////////////////////////////////////////////
function DousedHimselfInGas()
{
	if(!bStillTalking)
	{
		// noise for the moment of getting gas on you
		SayTime = MyPawn.Say(MyPawn.myDialog.lPissOnSelf) + 0.5;

		SetTimer(SayTime, false);
		bStillTalking=true;
		// only needs to be set once, really
		MyPawn.bExtraFlammable=true;
	}
}

///////////////////////////////////////////////////////////////////////////////
// pissed on himself
///////////////////////////////////////////////////////////////////////////////
function PissedOnHimself()
{
	if(!bStillTalking
		&& P2Pawn(Pawn) != None)
	{
		// You weren't on fire.. you were just stupid, pissing on yourself
		if(P2Pawn(Pawn).MyBodyFire == None)
		{
			// cough and spit, because hey, that's pretty gross
			SayTime = P2Pawn(Pawn).Say(P2Pawn(Pawn).myDialog.lPissOnSelf) + 0.5;

			// Wait a little longer than the dialogue time, so it won't come back in and terminate
			// the piss stream again if you just keep pissing straight up
			SetTimer(SayTime + AFTER_SPITTING_WAIT_TIME, false);
			bStillTalking=true;

			// Assume you're using your urethra here, since you peed on yourself
			P2Weapon(Pawn.Weapon).ForceEndFire();
			P2Weapon(Pawn.Weapon).UseWaitTime = SayTime;
			Pawn.Weapon.GotoState('WaitAfterStopping');
		}
		else
		{
			// The fluid soothes your burning body (at puts out the fire)
			SayTime = P2Pawn(Pawn).Say(P2Pawn(Pawn).myDialog.lPissOutFireOnSelf) + 0.5;
			SetTimer(2*SayTime, false);
			bStillTalking=true;
			bStillYelling=true;	// This ensures that he doesn't overwrite this 
				// with yells of pain (as he gets hurt by the fire he's putting out)
			// Record that you figured out how to piss yourself out
			P2GameInfo(Level.Game).bPlayerPissedHimselfOut=true;
			ConsoleCommand("set "@PissedMeOutPath@P2GameInfo(Level.Game).bPlayerPissedHimselfOut);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Player wants to kill himself but not hurt others. Happens instantly
// with no going back.
///////////////////////////////////////////////////////////////////////////////
exec function Aneurism()
{
	if( Level.Pauser!=None)
		return;

	log(self$" Aneurism ");

	// Mypawnfix
	if(P2Pawn(Pawn) != None
		&& !P2Pawn(Pawn).bPlayerStarting
		&& Pawn.Health > 0
		&& Pawn.Physics == PHYS_Walking
		&& (!(Level.Game != None
				&& Level.Game.bIsSinglePlayer)
			|| P2Player(MyPawn.Controller) == self))	// so you can't do this in a movie
	{
		ServerAneurism();
	}
}
function ServerAneurism()
{
	// Kill the pawn
	Pawn.Health = 0;
	Pawn.Died( None, class'Suicided', Pawn.Location );
}

///////////////////////////////////////////////////////////////////////////////
// Player wants to kill himself. Check to initiate suicide sequence
//
///////////////////////////////////////////////////////////////////////////////
exec function Suicide()
{
	if( Level.Pauser!=None)
		return;

	log(self$" suicide ");

	// Mypawnfix
	if(P2Pawn(Pawn) != None
		&& !P2Pawn(Pawn).bPlayerStarting
		&& Pawn.Health > 0
		&& Pawn.Physics == PHYS_Walking
		&& (!(Level.Game != None
				&& Level.Game.bIsSinglePlayer)
			|| P2Player(MyPawn.Controller) == self))	// so you can't do this in a movie
	{
		GotoState('PlayerSuicideByGrenade');
	}
}

///////////////////////////////////////////////////////////////////////////////
// Suicide call is done on the client, so make sure the server handles travelling
// to the next state.
///////////////////////////////////////////////////////////////////////////////
function ServerPerformSuicide()
{
	GotoState('PlayerSuicidingByGrenade');
}

///////////////////////////////////////////////////////////////////////////////
// Cancel suicide call is done on the client, so make sure the server handles travelling
// to the next state.
///////////////////////////////////////////////////////////////////////////////
function ServerCancelSuicide()
{
	GotoState('PlayerWalking');
}

///////////////////////////////////////////////////////////////////////////////
// Client must get back to normal also
///////////////////////////////////////////////////////////////////////////////
simulated function ClientCancelSuicide()
{
	GotoState('PlayerWalking');
	if(Level.Game == None
		|| !Level.Game.bIsSinglePlayer)
		ServerCancelSuicide();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
exec function WeaponZoom()
{
	if( Level.Pauser!=None)
		return;

	if ( (Pawn != None) && (Pawn.Weapon != None) )
		Pawn.Weapon.Zoom();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
exec function WeaponZoomIn()
{
	if( Level.Pauser!=None)
		return;

	if ( (Pawn != None) && (P2Weapon(Pawn.Weapon) != None) )
		P2Weapon(Pawn.Weapon).ZoomIn();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
exec function WeaponZoomOut()
{
	if( Level.Pauser!=None)
		return;

	if ( (Pawn != None) && (P2Weapon(Pawn.Weapon) != None) )
		P2Weapon(Pawn.Weapon).ZoomOut();
}

///////////////////////////////////////////////////////////////////////////////
// The player unzips his pants, and prepares his urethra for peeing. 
// The Fire button makes him actually pee.
///////////////////////////////////////////////////////////////////////////////
exec function UseZipper( optional float F )
{
	//STUB
	// Defined in DudePlayer where it has access to the urethra weapon type.
}

///////////////////////////////////////////////////////////////////////////////
// Search through the players inventory and use the most powerful health he has.
///////////////////////////////////////////////////////////////////////////////
exec function QuickHealth()
{
	// STUB
}

///////////////////////////////////////////////////////////////////////////////
// You're not talking anymore
///////////////////////////////////////////////////////////////////////////////
function Timer()
{
	local int soundindex;

	// We haven't said our thing yet
	if(bWaitingToTalk
		&& P2Pawn(Pawn) != None)
	{
		// Handle quick kills
		// We're about to do a line about 'and one for yer...'
		if(DelayedSayLine == QuickKillLine)
		{
			if(!bQuickKilling
				&& QuickKillSoundIndex >= QUICK_KILL_MAX)
			{
				//mypawnfix
				SayTime = P2Pawn(Pawn).Say(DelayedSayLine, , true, QUICK_KILL_MAX-1) + 0.5;
			}
			else
			{
				soundindex = QuickKillSoundIndex;
				//log(self$" quick kill index "$QuickKillSoundIndex);
				QuickKillSoundIndex++;
				if(QuickKillSoundIndex >= QUICK_KILL_MAX)
				{
					bQuickKilling=false;
					// Make a noise first, showing that it's over
					Pawn.PlaySound(QuickKillGoodEndSound, SLOT_Misc);
					// Then set up the timer for after the noise to make
					// him say the last thing.
					DelayedSayLine = QuickKillLine;
					SayTime = GetSoundDuration(QuickKillGoodEndSound);
					SetTimer(SayTime, false);
					bStillTalking=true;
					return; // don't keep going after this
				}
				else
					SayTime = P2Pawn(Pawn).Say(DelayedSayLine, , true, soundindex) + 0.5;
			}
		}
		else // Handle normal lines
			SayTime = P2Pawn(Pawn).Say(DelayedSayLine) + 0.5;

		bWaitingToTalk=false;	// Now that we've said it, reset
		DelayedSayLine = P2Pawn(Pawn).myDialog.lDude_KillWithGun; // 'reset' the line (to something typical)
		SetTimer(SayTime, false);
	}
	else
	{
		bStillTalking=false;
		bStillYelling=false;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Server get down for MP
///////////////////////////////////////////////////////////////////////////////
function ServerGetDown()
{
	local FPSPawn CheckP;
	local int peoplecount;
	local byte StateChange;

	//mypawnfix
	if(P2Pawn(Pawn) == None)
		return;

	// don't allow this to unpause the game
	if ( Level.Pauser == PlayerReplicationInfo )
		return;

	if(!bStillTalking
		&& P2Pawn(Pawn).myDialog != None)
	{
		// shout it!
		//log("-----------------------dude dialogue: Get Down!");
		// This is about how long it takes him to shout this. So 
		// don't let people shout it while he's already shouting it.
		if(Level.Game != None
			&& Level.Game.bIsSinglePlayer)
			SayTime = P2Pawn(Pawn).Say(P2Pawn(Pawn).myDialog.lGetDown) + 0.5;
		else
			SayTime = P2Pawn(Pawn).Say(P2Pawn(Pawn).myDialog.lGetDownMP) + 0.5;
		SetTimer(SayTime, false);
		bStillTalking=true;
		bShoutGetDown=0;
		// Now tell the people around you that it happened.

		// First send the message to people to get down. In the process,
		// count how many people heard me. 
		peoplecount=0;
		ForEach RadiusActors(class'FPSPawn', CheckP, DUDE_SHOUT_GET_DOWN_RADIUS, Pawn.Location)
		{
			if(CheckP != Pawn 
				&& LambController(CheckP.Controller) != None)
			{
				// Tell them who's shouting
				LambController(CheckP.Controller).RespondToTalker(MyPawn, P2Pawn(Enemy), TALK_getdown, StateChange);
				peoplecount++;
			}
		}
		// You could check peoplecount here and then say something
		// funny like "i'm talking to myself" if no one heard you.
	}
}

///////////////////////////////////////////////////////////////////////////////
// dude shouts out "Get Down"
///////////////////////////////////////////////////////////////////////////////
exec function DudeShoutGetDown( optional float F )
{
	ServerGetDown();
}

///////////////////////////////////////////////////////////////////////////////
// Record how long the player has been playing and decide if he's looked
// at the map enough. If he hasn't and it's the first day, we figure he doesn't
// know what he's doing, so we will eventually tell him to look at the map to 
// grasp the idea of completing errands in the game.
///////////////////////////////////////////////////////////////////////////////
function CheckMapReminder(float TimePassed)
{
	// Only allow this in SP
	if(P2GameInfoSingle(Level.Game) != None
		&& P2GameInfo(Level.Game).AllowReminderHints())
	{
		TimeSinceErrandCheck += TimePassed;
		//log(self$" non-map time "$TimeSinceErrandCheck$" count "$MapReminderCount);
		if(TimeSinceErrandCheck >= TimeForMapReminder)
		{
			MapReminderCount++;
			
			if(MapReminderCount < CHECKMAP_HINT1_TIME)
				SendHintText(CheckMapText1, MAP_REMINDER_HINT_TIME);
			else if(MapReminderCount < CHECKMAP_HINT2_TIME)
				SendHintText(CheckMapText2, MAP_REMINDER_HINT_TIME);
			else if(MapReminderCount < CHECKMAP_HINT3_TIME)
				SendHintText(CheckMapText3, MAP_REMINDER_HINT_TIME);
			else
				SendHintText(CheckMapText4, MAP_REMINDER_HINT_TIME);

			//log(self$" Player needs to check the map! "$TimeSinceErrandCheck);
			// Set the time back so it will pause the message, but then
			// show another again, after a short time (unless, of course, the
			// player does something to reset the reminders)
			TimeSinceErrandCheck= TimeForMapReminder - MapReminderRefresh;
			if(MapReminderRefresh > MIN_MAP_REMINDER_REFRESH)
				MapReminderRefresh-=MIN_MAP_REMINDER_DEC;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// The player has done something that could have vaguely reminded him that
// he has errands to complete (like he checked the map, completed and errand, etc)
///////////////////////////////////////////////////////////////////////////////
function ResetMapReminder(optional bool bTurnOffHints)
{
	TimeSinceErrandCheck=0;
	MapReminderCount=0;
	MapReminderRefresh = default.MapReminderRefresh;
	P2Hud(myHUD).ClearTextMessages();

	// Eventually, it seemed like the reminder during the demo came up too
	// much, so now we turn it off when you check it once.
	if(bTurnOffHints)
	{
		P2GameInfo(Level.Game).SetErrandReminder(false);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Forces the time forward to show a reminder now. Continues to show them
// like normal functionality, until the player checks the map
///////////////////////////////////////////////////////////////////////////////
function TriggerMapReminder()
{
	TimeSinceErrandCheck = TimeForMapReminder;
	CheckMapReminder(0.0);
}

///////////////////////////////////////////////////////////////////////////////
// If true, the player needs to be reminded of the errands he's to complete.
///////////////////////////////////////////////////////////////////////////////
function bool RemindPlayerOfErrands()
{
	return (MapReminderCount > 0);
}

///////////////////////////////////////////////////////////////////////////////
// You're ready to take down signatures
///////////////////////////////////////////////////////////////////////////////
function bool ClipboardReady()
{
	// STUB define in dudeplayer
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Dude is asking for money to be donated to him or a charity
///////////////////////////////////////////////////////////////////////////////
function DudeAskForMoney(vector AskPoint, float AskRadius, Actor HitActor, bool bIsForCharity)
{
	// STUB define in dudeplayer
}

///////////////////////////////////////////////////////////////////////////////
// Get a certain amount of money to be given to us
///////////////////////////////////////////////////////////////////////////////
function DudeTakeDonationMoney(int MoneyToGet, bool bIsForCharity)
{
	// STUB define in dudeplayer so we can access clipboard weapon
}

///////////////////////////////////////////////////////////////////////////////
// Make the dude reach out and grab money
///////////////////////////////////////////////////////////////////////////////
function GrabMoneyPutInCan(int MoneyToGet)
{
	// STUB define in dudeplayer so we can access clipboard weapon
}

///////////////////////////////////////////////////////////////////////////////
// Get mad because someone didn't donate to you
///////////////////////////////////////////////////////////////////////////////
function LostDonation()
{
	// ignore still talking and talk over it
	SayTime = MyPawn.Say(MyPawn.myDialog.lDude_CollectBalk) + 0.5;
	SetTimer(SayTime, false);
	bStillTalking=true;
}

///////////////////////////////////////////////////////////////////////////////
// set him on fire
///////////////////////////////////////////////////////////////////////////////
function CatchOnFire(FPSPawn Doer, optional bool bIsNapalm)
{
	log("i'm on fire");
}

///////////////////////////////////////////////////////////////////////////////
// Use this to update our trail on the map
///////////////////////////////////////////////////////////////////////////////
function PlayerTick(float DeltaTime)
	{
	local int Yaw;

	Super.PlayerTick(DeltaTime);

	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (MyMapScreen != None && Pawn != None)
			{
			// If pawn is moving then use direction it's moving in, otherwsie use direction it's facing
			if (VSize(Pawn.Velocity) > 0.0)
				Yaw = Rotator(Normal(Pawn.Velocity)).Yaw;
			else
				Yaw = Pawn.Rotation.Yaw;
			MyMapScreen.UpdateTrail(Pawn.Location, Yaw);
			}
		}
	}

// Map calls this to get player's location (where he is on the map)
function vector GetMapLocation()
	{
	// If pawn doesn't exist then use controller as a backup
	if (Pawn != None)
		return Pawn.Location;
	return Location;
	}

// Map calls this to get player's direction (which way he's facing on the map)
function int GetMapDirection()
	{
	// If pawn doesn't exist then use controller as a backup
	if (Pawn != None)
		return Pawn.Rotation.Yaw;
	return Rotation.Yaw;
	}

///////////////////////////////////////////////////////////////////////////////
// Player doesn't have the map selected, but wants to use it now anyway
///////////////////////////////////////////////////////////////////////////////
exec function QuickUseMap()
{
	// STUB--handled in dude player
}

///////////////////////////////////////////////////////////////////////////////
// Player wants to look at map, make sure it's okay to do it now.
///////////////////////////////////////////////////////////////////////////////
function RequestMap()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{

		// REMOVED: So you could do all these things while requesting the map
		// Don't allow while jumping or firing a weapon
		//if ((Pawn.Physics != PHYS_Falling) && !(Pawn.Weapon != None && !Pawn.Weapon.IsInState('Idle')))


			if (!MyMapScreen.IsRunning())
				DisplayMap();
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Player wants to look at newspaper, make sure it's okay to do it now.
///////////////////////////////////////////////////////////////////////////////
function RequestNews()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		// REMOVED: So you could do all these things while requesting the map... when
		// the newspaper auto-activates, we want to makes sure it works when you
		// walk over it.
		// Don't allow while jumping or firing a weapon
		//if ((Pawn.Physics != PHYS_Falling) && !(Pawn.Weapon != None && !Pawn.Weapon.IsInState('Idle')))

			if (!MyNewsScreen.IsRunning())
				DisplayNews();
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Player wants to change his clothes and has a valid set with which to change into
///////////////////////////////////////////////////////////////////////////////
function RequestClothes()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		// Don't allow while jumping or firing a weapon
		//if ((Pawn.Physics != PHYS_Falling) && !(Pawn.Weapon != None && !Pawn.Weapon.IsInState('Idle')))
			DisplayClothes();
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Player wants to look at newspaper, make sure it's okay to do it now.
///////////////////////////////////////////////////////////////////////////////
exec function RequestStats()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		// Don't allow while jumping or firing a weapon
		if ((Pawn.Physics != PHYS_Falling) && !(Pawn.Weapon != None && !Pawn.Weapon.IsInState('Idle')))
			DisplayStats(P2GameInfoSingle(Level.Game).MainMenuURL);
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the news screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayNews()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyNewsScreen.IsRunning())
			{
			// Apocalypse newspaper is the only one that doesn't let you skip
			MyNewsScreen.Show(P2GameInfoSingle(Level.Game).TheGameState.bIsApocalypse);
			CurrentScreen = MyNewsScreen;
			SetMyOldState();
			GotoState('WaitScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the vote screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayVote()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyVoteScreen.IsRunning())
			{
			MyVoteScreen.Show();
			CurrentScreen = MyVoteScreen;
			SetMyOldState();
			GotoState('WaitVoteScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the stats screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayStats(optional String URL)
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyStatsScreen.IsRunning())
			{
			MyStatsScreen.Show(URL);
			CurrentScreen = MyStatsScreen;
			SetMyOldState();
			GotoState('WaitScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the pick screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayPick()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyPickScreen.IsRunning())
			{
			MyPickScreen.Show();
			CurrentScreen = MyPickScreen;
			SetMyOldState();
			GotoState('WaitScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the load screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayLoad(DayBase day, String URL)
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyLoadScreen.IsRunning())
			{
			MyLoadScreen.Show(day, URL);
			CurrentScreen = MyLoadScreen;
			SetMyOldState();
			GotoState('WaitScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the clothes screen (called externally)
///////////////////////////////////////////////////////////////////////////////
function DisplayClothes()
	{
	// Only do this for single player games
	if (P2GameInfoSingle(Level.Game) != None)
		{
		if (!MyClothesScreen.IsRunning())
			{
			MyClothesScreen.Show();
			CurrentScreen = MyClothesScreen;
			SetMyOldState();
			GotoState('WaitClothesScreen');
			}
		}
	else
		Warn("DisplayLoad() should not be called in multiplayer game.");
	}

///////////////////////////////////////////////////////////////////////////////
// Display the map screen.  This is called both internally and externally.
//
// There are possible three modes (selected using the bool paremeters):
//		- reveal the errands at the start of a day
//		- mark an errand as completed
//		- just look at the the map
//
// The map screen is triggered and the player is put into a temporary
// 'WaitMapScreen' state until the map screen is done, at which point he goes
// back to his prior state.  The map screen pauses the game while it is
// running and unpauses it afterwards.  Note that there is a slight delay from
// when MapScreen.Show() is called to when the game actually pauses.
//
// The 'WaitMapScreen' state handles certain triggering and notification aspects
// of errand completion.  This is a bit ugly but it ensures those things will
// happen only after the map screen is finished and the game is running again.
///////////////////////////////////////////////////////////////////////////////
function DisplayMap()
	{
	MyMapScreen.Show();
	CurrentScreen = MyMapScreen;
	// For debugging, you can keep playing while map is running
	if (MyMapScreen.PLAY_GAME_WITH_MAP_RUNNING == 0)
		{
		SetMyOldState();
		GotoState('WaitMapScreen');
		}
	}

function DisplayMapErrands(optional String SendToURL, optional bool bWantFancyFadeIn)
	{
	MyMapScreen.ShowErrands(SendToURL, bWantFancyFadeIn);
	CurrentScreen = MyMapScreen;
	SetMyOldState();
	GotoState('WaitMapScreen');
	}

function DisplayMapHaters(optional String SendToURL)
	{
	MyMapScreen.ShowHaters(SendToURL);
	CurrentScreen = MyMapScreen;
	SetMyOldState();
	GotoState('WaitMapScreen');
	}

function DisplayMapCrossOut(int ErrandIndex, name CompletionTrigger_In)
	{
	// Set flag and save trigger for use after map screen ends
	bErrandCompleted = true;
	CompletionTrigger = CompletionTrigger_In;
	MyMapScreen.ShowCrossOut(ErrandIndex);
	CurrentScreen = MyMapScreen;
	SetMyOldState();
	GotoState('WaitMapScreen');
	}

///////////////////////////////////////////////////////////////////////////////
// Generate the toss velocity for something your throwing out of your inventory
///////////////////////////////////////////////////////////////////////////////
function vector GenTossVel(optional P2PowerupInv ppinv)
{
	local float usemag;

	if(ppinv != None)
		usemag = ppinv.GetTossMag();
	else
		usemag = TOSS_STUFF_VEL;
	//Mypawnfix
	return (vector(Pawn.GetViewRotation()) * usemag);
}

///////////////////////////////////////////////////////////////////////////////
// Throw/toss out current powerup, and switch to a new powerup
///////////////////////////////////////////////////////////////////////////////
exec function ThrowPowerup()
{
	if( Level.Pauser!=None)
		return;

	if(Pawn != None)
	{
		ServerThrowPowerup();
	}
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ServerThrowPowerup()
{
	local P2PowerupInv ppinv;

	//mypawnfix
	ppinv = P2PowerupInv(Pawn.SelectedItem);

	if( ppinv==None || !ppinv.bCanThrow )
		return;

	P2Pawn(Pawn).TossThisInventory(GenTossVel(), ppinv);
}

///////////////////////////////////////////////////////////////////////////////
// For consistancies sake, two new functions are used. Before NextItem was
// in Pawn and PrevItem was in playercontroller, so they're both now in
// here so different states can override them or ignore them.
///////////////////////////////////////////////////////////////////////////////
exec function PrevInvItem()
{
	PrevItem();
}
exec function NextInvItem()
{
	if( Level.Pauser!=None)
		return;

	//mypawnfix
	if(P2Pawn(Pawn) != None)
		P2Pawn(Pawn).NextItem();
}

///////////////////////////////////////////////////////////////////////////////
// Fire foot weapon
///////////////////////////////////////////////////////////////////////////////
exec function DoKick()
{
	if( Level.Pauser!=None)
		return;

	//mypawnfix
	if( P2Pawn(Pawn) != None
		&& P2Pawn(Pawn).MyFoot!=None )
	{
		P2Pawn(Pawn).StopAcc();
		P2Pawn(Pawn).MyFoot.Fire(1.0);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Switch directly to your hands weapon
///////////////////////////////////////////////////////////////////////////////
exec function SwitchToHands(optional bool bForce)
{
	// STUB.
	// Defined in dudeplayer where it has access to the hands weapon type
}

///////////////////////////////////////////////////////////////////////////////
// Switch directly to your hands weapon, or back to what you had before hands
///////////////////////////////////////////////////////////////////////////////
exec function ToggleToHands(optional bool bForce)
{
	// STUB.
	// Defined in dudeplayer where it has access to the hands weapon type
}

///////////////////////////////////////////////////////////////////////////////
// If we've gone through a level transition that takes our weapons/inventory
// use this to reset the toggle button
///////////////////////////////////////////////////////////////////////////////
function ResetHandsToggle()
{
	// STUB.
	// Defined in dudeplayer where it has access to the hands weapon type
}

///////////////////////////////////////////////////////////////////////////////
// Do you have only your hands out?
///////////////////////////////////////////////////////////////////////////////
function bool HasHandsOut()
{
	// STUB.
	// Defined in dudeplayer where it has access to the hands weapon type
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// This exec doesn't do anything unless player is dead
///////////////////////////////////////////////////////////////////////////////
exec function GameOverRestart(optional float F)
{
}

///////////////////////////////////////////////////////////////////////////////
// Most of the time (if you're not dead), you're ready to deal with a cashier
///////////////////////////////////////////////////////////////////////////////
function bool ReadyForCashier()
{
	if(Pawn == None
		|| Pawn.Health <= 0)
		return false;
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// Returns true if you are currently in range to give money to the cashier
///////////////////////////////////////////////////////////////////////////////
function bool DealingWithCashier()
{
	return bDealingWithCashier;
}

///////////////////////////////////////////////////////////////////////////////
// True if he's in the state just before actually killing himself
///////////////////////////////////////////////////////////////////////////////
function bool IsReadyToCommitSuicide()
{
	return (GetStateName() == 'PlayerSuicideByGrenade');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function EnterSnipingState()
{
	GotoState('PlayerSniping');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ExitSnipingState()
{
	GotoState('PlayerWalking');
}

///////////////////////////////////////////////////////////////////////////////
// These two zoom the camera in and out
///////////////////////////////////////////////////////////////////////////////
exec function DeadNextWeapon(float ZoomInc, int ZoomMin)
{
	if( Level.Pauser!=None)
		return;

	CameraDist -= CAMERA_ZOOM_CHANGE;
	if(CameraDist < ZoomMin)
		CameraDist = ZoomMin;
}
exec function DeadPrevWeapon(float ZoomInc, int ZoomMax)
{
	if( Level.Pauser!=None)
		return;

	CameraDist += CAMERA_ZOOM_CHANGE;
	if(CameraDist > ZoomMax)
		CameraDist = ZoomMax;
}
///////////////////////////////////////////////////////////////////////////////
// Same as Engine.PlayerController version except we
// pick the neck bone to stare at
///////////////////////////////////////////////////////////////////////////////
function SuicideCalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist;
	local coords checkcoords;

	if(Pawn != None)
	{
		//mypawnfix
		// Look at the dude's head while we're ready to kill him
		checkcoords = Pawn.GetBoneCoords(CAMERA_TARGET_BONE);
		// Set the location now to the head
		CameraLocation = checkcoords.Origin;

		// Now modify it based on your surroundings.
		CameraRotation = Rotation;
		if(CameraRotation.Pitch < CAMERA_MIN_HIGH_SUICIDE_PITCH
			&& CameraRotation.Pitch > CAMERA_MAX_LOW_SUICIDE_PITCH)
			CameraRotation.Pitch = CAMERA_MAX_LOW_SUICIDE_PITCH;
		View = vect(1,0,0) >> CameraRotation;
		if( Trace( HitLocation, HitNormal, CameraLocation - (Dist + 30) * vector(CameraRotation), CameraLocation ) != None )
			ViewDist = FMin( (CameraLocation - HitLocation) Dot View, Dist );
		else
			ViewDist = Dist;
		CameraLocation -= (ViewDist - 30) * View; 
	}
}
///////////////////////////////////////////////////////////////////////////////
// Same as Engine.PlayerController version except we
// use our own distance numbers for the camera
///////////////////////////////////////////////////////////////////////////////
function DeadCalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
{
	local vector View,HitLocation,HitNormal;
	local float ViewDist;
	local coords checkcoords;

	// We used to look at the dude's head, but now we just look at his center. It makes sure
	// the camera is less likely to be inside things
	//checkcoords = MyPawn.GetBoneCoords(CAMERA_TARGET_BONE);
	// Set the location now to the head
	//CameraLocation = checkcoords.Origin;
	CameraLocation = Pawn.Location;
	CameraLocation.z += Pawn.CollisionHeight;

	// Now modify it based on your surroundings.
	CameraRotation = Rotation;
	View = vect(1,0,0) >> CameraRotation;
	if( Trace( HitLocation, HitNormal, CameraLocation - (Dist + 30) * vector(CameraRotation), CameraLocation ) != None )
		ViewDist = FMin( (CameraLocation - HitLocation) Dot View, Dist );
	else
		ViewDist = Dist;
	CameraLocation -= (ViewDist - 30) * View; 
}

///////////////////////////////////////////////////////////////////////////////
// Quick cheat for MP testing anims
///////////////////////////////////////////////////////////////////////////////
exec function TCam()
{
	bFreeCamera = !bFreeCamera;
	bBehindView = !bBehindView;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function ClientShakeView(vector shRotMag,    vector shRotRate,    float shRotTime, 
                   vector shOffsetMag, vector shOffsetRate, float shOffsetTime)
{
	ShakeView(shRotMag, shRotRate, shRotTime, shOffsetMag, shOffsetRate, shOffsetTime);
}


///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function CalcFirstPersonView( out vector CameraLocation, out rotator CameraRotation )
{
	local vector eyepos;
	local float lowerheight;
	local vector x1, y1, z1;

	// First-person view.
	/*
	
	 This is head-moving-down code for when you look down. This is to make
	things not look so small when you look at them. We didn't go with this approach
	but it's kept in, in case we want to mess with it.

	God mode toggles it

	if(CameraRotation.Pitch <= 18000)
	{
	}
	else if(CameraRotation.Pitch >= 49152)
	{
		if(bGodMode)
		{
			lowerheight = (65536 - CameraRotation.Pitch)/400;
			eyepos.z-=lowerheight;
		}
	}
	*/
    GetAxes(Rotation, x1, y1, z1);

    // First-person view.
    CameraRotation = Normalize(Rotation + ShakeRot);
    CameraLocation = CameraLocation + Pawn.EyePosition() +// Pawn.WalkBob +
                     ShakeOffset.X * x1 +
                     ShakeOffset.Y * y1 +
                     ShakeOffset.Z * z1;
	//log(self$" CameraRotation "$CameraRotation$" shakerot "$ShakeRot$" rotation "$Rotation);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function FindGoodCameraView()
{
	local vector cameraLoc;
	local rotator cameraRot, ViewRotation;
	local int tries, besttry;
	local float bestdist, newdist;
	local int startYaw;
	local actor ViewActor;
	
	//log("FindGoodCameraView, p2player, pawn "$Pawn$" mypawn "$MyPawn$" view "$ViewTarget);
	ViewRotation.Roll = Rotation.Roll;
	ViewRotation.Yaw = (Rotation.Yaw + 32768) & 65535;
	ViewRotation.Pitch = 60000;
	tries = 0;
	besttry = 0;
	bestdist = 0.0;
	startYaw = ViewRotation.Yaw;
	
	for (tries=0; tries<16; tries++)
	{
		cameraLoc = ViewTarget.Location;
		PlayerCalcView(ViewActor, cameraLoc, cameraRot);
		newdist = VSize(cameraLoc - ViewTarget.Location);
		if (newdist > bestdist)
		{
			bestdist = newdist;	
			besttry = tries;
		}
		ViewRotation.Yaw += 4096;
	}
		
	ViewRotation.Yaw = startYaw + besttry * 4096;
	SetRotation(ViewRotation);
}

///////////////////////////////////////////////////////////////////////////////
// Decide if he's stuck or not
///////////////////////////////////////////////////////////////////////////////
function bool DetectStuckPlayer(float DeltaTime)
{
	// If you're falling and not moving for too long, you're stuck
	if(Pawn.Physics == PHYS_Falling
		&& !Pawn.bIsCrouched
		&& !bCheatFlying)
	{
		// If you're not moving in z for too long
		if(Pawn.Velocity.z == 0)
		{
			StuckTime += DeltaTime;

			// After we're pretty sure, put up a helpful message
			if(StuckTime - DeltaTime < STUCK_TIME_HINT
				&& StuckTime >= STUCK_TIME_HINT)
			{
				//mypawnfix
				Pawn.ClientMessage(StuckText1);
				Warn(self$" Player appears stuck "$Pawn.Location);
			}

			// Now that he's really stuck, move him
			if(StuckTime > MAX_STUCK_TIME)
			{
				StuckTime = 0;
				return true;
			}
		}
		else
			StuckTime = 0;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Find the nearest free pathnode to the stuck player, and put him there
// Warps him to each possible spot to make sure it will work. But it doesn't
// warp him back, it just uses the oldloc to test from. The last one you warped
// him to will have to be the closest to oldloc.
///////////////////////////////////////////////////////////////////////////////
function HandleStuckPlayer()
{
	local PathNode pn, savepn;
	local float closedist, usedist;
	local vector useloc, oldloc;

	Warn(self$" ERROR! PLAYER WAS STUCK here: "$Pawn.Location);

	oldloc = Pawn.Location;

	closedist = StuckCheckRadius;
	// Check pathnodes in a given radius
	foreach RadiusActors(class'Pathnode', pn, StuckCheckRadius, oldloc)
	{
		usedist = VSize(pn.Location - oldloc);
		if(LastUnstuckPoint	!= pn		// Not where we last unstuck ourself from
			&& usedist < closedist		// closest one
			&& !pn.bBlocked)			// not blocked
		{
			// Warp the player there now, to make sure the spot was
			// okay for him to be there. If this happens, it will only
			// work with the closest node, so this will also be the final move
			useloc = pn.Location;
			// Add just enough buffer to pathnode, to make sure he somehow doesn't
			// get warped to a point below the floor, and then fall through the floor.
			useloc.z += (Pawn.CollisionHeight/2);
			if(Pawn.SetLocation(useloc))
			{
				closedist = usedist;
				savepn = pn;
			}
		}
	}

	if(savepn != None)
	{
		//mypawnfix
		Pawn.ClientMessage(StuckText2);
		StuckCheckRadius = STUCK_RADIUS;
		LastUnstuckPoint = savepn;	// Save where we last unstuck from so as to not use it again, next time
		Warn(self$" UNsticking player--warping him to "$savepn);
	}
	else
	{
		Warn(self$" UNsticking warp failed");
		// You've failed, then increase you're check area
		StuckCheckRadius += STUCK_RADIUS;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Clean up in anyway (state stuff, for instance) after being
// sent to jail
///////////////////////////////////////////////////////////////////////////////
function GettingSentToJail()
{
	log(self$" basic GettingSentToJail");
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Wait for screen to finish running
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state WaitScreen
	{
	ignores Fire, Use, Jump, Pause, Speech, AltFire, DudeShoutGetDown, UseZipper,
		SetMyOldState, RequestMap, QuickUseMap, RequestNews, RequestStats, DisplayVote, 
		Suicide, DoKick, QuickSave, WeaponZoom, WeaponZoomIn, WeaponZoomOut, ThrowWeapon,
		ThrowPowerup, PrevInvItem, NextInvItem, CanBeMugged, SwitchWeapon, SwitchToHands, ToggleToHands,
		PressingFire, PressingAltFire;	
	function BeginState()
		{
		// Seems like a good idea to stop the pawn from moving
		MyPawn.StopAcc();
		// Undo any slomo effects before we start the map
		P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1.0);
		}

	function EndState()
		{
		CurrentScreen = None;
		// Restore any time dilation effects
		SetupCatnipUseage(CatnipUseTime);
		}
	
	// Wait until screen is no longer running, then goto prior state
Begin:
	if (CurrentScreen.IsRunning() == false)
	{
		log(self$" going back to "$MyOldState);
		GotoState(MyOldState);
	}
	Sleep(0.05);
	Goto('Begin');
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Wait for voting screen to finish, then do special stuff afterwards
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state WaitVoteScreen extends WaitScreen
	{
	function EndState()
		{
		Super.EndState();

		// The voting errand has been completed.  To indicate its completion,
		// we spawn a temporary actor with its tag set to the unique tag the
		// errand goal looks for and pass it to the completion process.
		P2GameInfoSingle(Level.Game).CheckForErrandCompletion(
			spawn(class'RawActor', ,'VoteScreen'),
			None,
			None,
			self,
			false);
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Wait for map screen to finish, then do special stuff afterwards
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state WaitMapScreen extends WaitScreen
	{
	function EndState()
		{
		local Actor TriggerMe;

		Super.EndState();

		// Reset the map hints now that we've looked at the map
		ResetMapReminder(true);

		// If errand was completed then there's some special things to do...
		if (bErrandCompleted)
			{
			// May need to trigger event associated with completed errand
			if(CompletionTrigger != 'None')
				{
				ForEach AllActors(class 'Actor', TriggerMe, CompletionTrigger)
					TriggerMe.Trigger(None, Pawn);
				}
			
			// May need to inform another character of errand completion
			if(InterestPawn != None && InterestPawn.Health > 0 && LambController(InterestPawn.Controller) != None)
				LambController(InterestPawn.Controller).DudeErrandComplete();
			
			bErrandCompleted = false;
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Say something after putting on your clothes
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state WaitClothesScreen extends WaitScreen
	{
	function EndState()
		{
		Super.EndState();
		FinishedPuttingOnClothes();
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Extend the original playerwalking from playercontroller. Add
// that you alert people of your weapon
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerWalking
{
	///////////////////////////////////////////////////////////////////////////////
	// Prepare for a save
	///////////////////////////////////////////////////////////////////////////////
	function PrepForSave()
	{
		GotoState('PlayerPrepSave');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Check for getting stuck (and do normal player move)
	///////////////////////////////////////////////////////////////////////////////
	function PlayerMove( float DeltaTime )
	{
		Super.PlayerMove(DeltaTime);

		if(DetectStuckPlayer(DeltaTime))
		{
			HandleStuckPlayer();
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// Process Move
	///////////////////////////////////////////////////////////////////////////////
	function ProcessMove(float DeltaTime, vector NewAccel, eDoubleClickDir DoubleClickMove, rotator DeltaRot)	
	{
		local vector OldAccel;
		local bool OldCrouch;

		OldAccel = Pawn.Acceleration;
		Pawn.Acceleration = NewAccel;
		if ( bPressedJump )
			Pawn.DoJump(bUpdating);

		// NPF 07/23/03 ViewPitch brought over from 2141 to do torso twisting
        Pawn.ViewPitch = Clamp(Rotation.Pitch / 256, 0, 255); 
        
		// NPF 2/26/02
		// Removed test that doesn't let you crouch if you're falling, to make crouch jumping work
		OldCrouch = Pawn.bWantsToCrouch;
		if (bDuck == 0)
			Pawn.ShouldCrouch(false);
		else if ( Pawn.bCanCrouch )
			Pawn.ShouldCrouch(true);
		/*
		if (bCower == 0)
			MyPawn.ShouldCower(false);
		else
			MyPawn.ShouldCower(true);

		if (bDeathCrawl == 0)
		{
			MyPawn.ShouldDeathCrawl(false);
		}
		else
			MyPawn.ShouldDeathCrawl(true);
		*/
		
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		Super.BeginState();

		// Check if we should prepare for a save.
		// We could be sent here first if a movie finished playing and repossessed us.
		CheckPrepForSave();
	}

Begin:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	//mypawnfix
	P2Pawn(Pawn).ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	CheckForCrackUse(REPORT_LOOKS_SLEEP_TIME);
	FollowCatnipUse(REPORT_LOOKS_SLEEP_TIME);
	CheckMapReminder(REPORT_LOOKS_SLEEP_TIME);
	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Player just got into the level or waiting after a movie. Don't let him
// do anything else so that it's safe to save the game.
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerPrepSave extends PlayerWalking
{
	ignores PrepForSave, CheckPrepForSave,SeePlayer, HearNoise, KilledBy, NotifyBump, 
		HitWall, ActivateInventoryItem, 
		Jump, ThrowWeapon, PlayerMove, ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, 
		NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, CheckMapReminder,
		DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleInvHints, ToggleToHands,
		QuickUseMap, DoKick, QuickSave, CanBeMugged, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
		NextWeapon, PrevWeapon, Fire, AltFire, PressingFire, PressingAltFire, Pause, ReadyForCashier;

	///////////////////////////////////////////////////////////////////////////////
	// Returns true if any screen is still running
	///////////////////////////////////////////////////////////////////////////////
	function bool ScreenStillRunning()
	{
		local int i;
		local P2Screen screen;
		local bool bScreenRunning;

		for (i = 0; i < Player.LocalInteractions.Length; i++)
		{
			screen = P2Screen(Player.LocalInteractions[i]);
			if (screen != None)
				bScreenRunning = bScreenRunning || screen.IsRunning();
		}

		return bScreenRunning;
	} 

	// Block begin/endstate, and then list logs
	function beginstate()
	{
		log(self$" begin state PlayerPrepSave ");
	}
	function endstate()
	{
		log(self$" end state PlayerPrepSave");
	}
Begin:
	Sleep(AUTO_SAVE_WAIT);

	if (ScreenStillRunning() ||
		!P2GameInfoSingle(Level.Game).ReadyForSave(self) )
		Goto('Begin');

	// We don't need to do this again
	bDidPrepForSave = true;

	// Go back to playing normally
	ExitPrepToSave();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Player just got into the level or waiting after a movie. Don't let him
// do anything else so that it's safe to save the game.
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerDiffPatch extends PlayerPrepSave
{
	ignores PrepForSave, CheckPrepForSave,SeePlayer, HearNoise, KilledBy, NotifyBump, 
		HitWall, ActivateInventoryItem, 
		Jump, ThrowWeapon, PlayerMove, ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, 
		NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, CheckMapReminder,
		DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleInvHints, ToggleToHands,
		QuickUseMap, DoKick, QuickSave, CanBeMugged, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
		NextWeapon, PrevWeapon, Fire, AltFire, PressingFire, PressingAltFire, Pause, ReadyForCashier;

	// Block begin/endstate, and then list logs
	function beginstate()
	{
		log(self$"patching saved file with Difficulty Fix");
	}
	function endstate()
	{
		log(self$" end state PlayerDiffPatch");
	}
Begin:

	Sleep(AUTO_SAVE_WAIT);
	log(self$" waiting in "$GetStateName());

	// Have them set the difficulty again
	if (ScreenStillRunning() ||
		!P2GameInfoSingle(Level.Game).ReadyForSaveFix(self) )
		Goto('Begin');

	// We don't need to do this again
	bDidPrepForSave = true;

	// Go back to playing normally
	ExitPrepToSave();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// PlayerDemoMapFirst 
// Wait for a second, with the game world shown, then bring up the map
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerDemoMapFirst extends PlayerWalking
{
	ignores PrepForSave, CheckPrepForSave,SeePlayer, HearNoise, KilledBy, NotifyBump, 
		HitWall, ActivateInventoryItem, 
		Jump, ThrowWeapon, PlayerMove, ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, 
		NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, CheckMapReminder,
		DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleInvHints, ToggleToHands,
		QuickUseMap, DoKick, QuickSave, CanBeMugged, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
		NextWeapon, PrevWeapon, Fire, AltFire, PressingFire, PressingAltFire, Pause, ReadyForCashier;
	///////////////////////////////////////////////////////////////////////////////
	// Force my old state to be PlayerWalking so he returns from the
	// map, ready to play the game.
	///////////////////////////////////////////////////////////////////////////////
	function SetMyOldState()
	{
		MyOldState = 'PlayerWalking';
	}

Begin:
	Sleep(1.5);
	DisplayMapErrands("", true);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// A guy is trying to mug you. If you exit this state early, the
// mugger will attack you. If you go out of a certain radius he'll attack you
// then too.
// Don't mess with crack or catnip timing here.
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerGettingMugged extends PlayerWalking
{
	ignores CanBeMugged, CheckMapReminder, ReadyForCashier;

	///////////////////////////////////////////////////////////////////////////////
	// He really means it now!
	///////////////////////////////////////////////////////////////////////////////
	function EscalateMugging()
	{
		bMuggerGoingToShoot=true;
	}
	///////////////////////////////////////////////////////////////////////////////
	// For when the mugger wants to end with the player
	///////////////////////////////////////////////////////////////////////////////
	function UnhookPlayerGetMugged()
	{
		GotoState('PlayerWalking');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Hints on how to hande over your money to a guy mugging you
	///////////////////////////////////////////////////////////////////////////////
	function bool GetMuggerHints(out String str1, out String str2)
	{
		if(!bMuggerGoingToShoot)
		{
			str1 = MuggerHint1;
			str2 = MuggerHint2;
		}
		else
		{
			str1 = MuggerHint3;
			str2 = MuggerHint4;
		}
		return true;
	}
	///////////////////////////////////////////////////////////////////////////////
	//  Check him to make sure he hasn't lost interest in you, if he has
	// then unhook yourself
	///////////////////////////////////////////////////////////////////////////////
	function CheckMugger()
	{
		if(InterestPawn == None
			|| PersonController(InterestPawn.Controller) == None
			|| !PersonController(InterestPawn.Controller).IsInState('DoPlayerMugging'))
			UnhookPlayerGetMugged();
	}

	///////////////////////////////////////////////////////////////////////////////
	// Clean up in anyway (state stuff, for instance) after being
	// sent to jail
	///////////////////////////////////////////////////////////////////////////////
	function GettingSentToJail()
	{
		log(self$" GettingSentToJail from "$GetStateName());
		// Exit this state
		GotoState('PlayerWalking');
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function EndState()
	{
		InterestPawn = None;
		bMuggerGoingToShoot=true;
	}
Begin:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	P2Pawn(Pawn).ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	CheckMugger();
	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// You've shot a rocket, and now the camera is racing around with the rocket.
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerWatchRocket extends PlayerWalking
{
	ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, ActivateInventoryItem, ThrowWeapon,
			ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, NotifyHeadVolumeChange, 
			NotifyPhysicsVolumeChange, Falling, CheckMapReminder, Fire, AltFire,
			DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleInvHints,
			QuickUseMap, DoKick, QuickSave, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
			IsSaveAllowed, SwitchWeapon, ProcessMove, ExitSnipingState, CanBeMugged, ReadyForCashier,
			PressingFire, PressingAltFire;

	///////////////////////////////////////////////////////////////////////////////
	// Jump takes you back to the player
	///////////////////////////////////////////////////////////////////////////////
	exec function Jump( optional float F )
	{
		if( Level.Pauser!=None)
			return;

		StopViewingRocketOrTarget();
	}
	///////////////////////////////////////////////////////////////////////////////
	// Tell rocket what input for movement the player is giving
	///////////////////////////////////////////////////////////////////////////////
	function ModifyRocketMotion(out float PlayerTurnX, out float PlayerTurnY)
	{
		PlayerTurnX = PlayerMoveX;
		PlayerTurnY = PlayerMoveY;
		PlayerMoveX=0.0;
		PlayerMoveY=0.0;
	}

	///////////////////////////////////////////////////////////////////////////////
	// Handle moving target instead of player
	///////////////////////////////////////////////////////////////////////////////
	function PlayerMove(float DeltaTime)
	{
		Super.PlayerMove(DeltaTime);

		if(aForward > 0)
			PlayerMoveY -= DeltaTime;
		else if(aForward < 0)
			PlayerMoveY += DeltaTime;
		if(aStrafe > 0)
			PlayerMoveX += DeltaTime;
		else if(aStrafe < 0)
			PlayerMoveX -= DeltaTime;
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function CalcFirstPersonView( out vector CameraLocation, out rotator CameraRotation )
	{
		local vector x1, y1, z1;

		GetAxes(ViewTarget.Rotation, x1, y1, z1);

		// First-person view.
		CameraRotation = ViewTarget.Rotation;
		// Viewing the rocket
		if(Projectile(ViewTarget) != None)
		{
			CameraLocation = CameraLocation + ShakeOffset 
						+ CAMERA_ROCKET_OFFSET_X*x1 + CAMERA_ROCKET_OFFSET_Z*z1;
			// Put some extra crazy shake it
			CameraLocation = CameraLocation + VRand();
		}
		else // viewing the carnage
		{
			CameraLocation = CameraLocation + ShakeOffset 
						+ CAMERA_VICTIM_OFFSET_X*x1 + CAMERA_VICTIM_OFFSET_Z*z1;
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// The rocket hit a pawn directly
	///////////////////////////////////////////////////////////////////////////////
	function RocketDetonated(Actor HitThing)
	{
		SetViewTarget(HitThing);
		bBehindView=true;
		ViewTarget.BecomeViewTarget();
		FindGoodCameraView();
		GotoState('PlayerWatchRocket', 'WatchResults');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Restore the player as the view target
	///////////////////////////////////////////////////////////////////////////////
	function StopViewingRocketOrTarget()
	{
		bBehindView=false;
		if ( (MyPawn != None) && !MyPawn.bDeleteMe )
		{
			SetViewTarget(MyPawn);
		}
		else
			SetViewTarget(self);
		// Restore rotation
		ViewTarget.SetRotation(OldViewRotation);
		GotoState('PlayerWalking');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Based off of PlayerController::PlayerCalcView.
	///////////////////////////////////////////////////////////////////////////////
	event PlayerCalcView(out actor ViewActor, out vector CameraLocation, out rotator CameraRotation )
	{
		local Pawn PTarget;

		// We now restore viewtarget more carefully when it's destroyed
		if ( (ViewTarget == None) || ViewTarget.bDeleteMe )
		{
			StopViewingRocketOrTarget();
		}

		ViewActor = ViewTarget;
		CameraLocation = ViewTarget.Location;
		CameraRotation = ViewTarget.Rotation;
		if ( bBehindView )
		{
			CameraLocation = CameraLocation + (ViewTarget.CollisionHeight) * vect(0,0,1);
			CalcBehindView(CameraLocation, CameraRotation, VICTIM_CAMERA_VIEW_DIST * ViewTarget.Default.CollisionRadius);
		}
		else
			CalcFirstPersonView( CameraLocation, CameraRotation );
	}

	///////////////////////////////////////////////////////////////////////////////
	// Clean up in anyway (state stuff, for instance) after being
	// sent to jail
	///////////////////////////////////////////////////////////////////////////////
	function GettingSentToJail()
	{
		log(self$" GettingSentToJail from "$GetStateName());
		// Exit this state
		GotoState('PlayerWalking');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Switch back to what you had before.
	///////////////////////////////////////////////////////////////////////////////
	function EndState()
	{
		ToggleToHands(true);
		Super.EndState();
	}

	///////////////////////////////////////////////////////////////////////////////
	// If you don't have your hands out when you start, then put away 
	// the weapon so you don't attract more attention than necessary
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		Super.BeginState();
		// stop running
		MyPawn.StopAcc();
		// reset movement vars
		PlayerMoveX=0.0;
		PlayerMoveY=0.0;
		// Put away you're rocket launcher
		if(P2Weapon(MyPawn.Weapon) == None
			|| P2Weapon(MyPawn.Weapon).ViolenceRank > 0)
			ToggleToHands(true);
	}

WatchResults:
	Sleep(WATCH_ROCKET_RESULTS_TIME);
	StopViewingRocketOrTarget();
Begin:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	MyPawn.ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	FollowCatnipUse(REPORT_LOOKS_SLEEP_TIME);
	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Player can't run or climb while sniping
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerSniping extends PlayerWalking
{
	ignores HandleWalking, Jump, CanBeMugged, Suicide, CheckMapReminder,
		SomeoneDied, AllowTalking, CommentOnCheating, ReadyForCashier;

	///////////////////////////////////////////////////////////////////////////////
	// Clean up in anyway (state stuff, for instance) after being
	// sent to jail
	///////////////////////////////////////////////////////////////////////////////
	function GettingSentToJail()
	{
		log(self$" GettingSentToJail from "$GetStateName());
		// Exit this state
		GotoState('PlayerWalking');
	}

	function EndState()
	{
		Super.EndState();
		//mypawnfix
		if(P2Pawn(Pawn) != None)
			P2Pawn(Pawn).bCanClimbLadders=P2Pawn(Pawn).default.bCanClimbLadders;
	}

	function BeginState()
	{
		Super.BeginState();
		//mypawnfix
		if(P2Pawn(Pawn) != None)
		{
			P2Pawn(Pawn).SetWalking(true);
			P2Pawn(Pawn).bCanClimbLadders=false;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// player is climbing ladder
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerClimbing
{
	ignores CanBeMugged, ReadyForCashier;

	///////////////////////////////////////////////////////////////////////////////
	// Prepare for a save
	///////////////////////////////////////////////////////////////////////////////
	function PrepForSave()
	{
		GotoState('PlayerPrepSave');
	}

Begin:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	//mypawnfix
	P2Pawn(Pawn).ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	CheckForCrackUse(REPORT_LOOKS_SLEEP_TIME);
	CheckMapReminder(REPORT_LOOKS_SLEEP_TIME);
	FollowCatnipUse(REPORT_LOOKS_SLEEP_TIME);
	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// PlayerRadarTargetting
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerRadarTargetting extends PlayerWalking
{
	ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, ActivateInventoryItem, Jump, ThrowWeapon,
			ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, NotifyHeadVolumeChange, 
			NotifyPhysicsVolumeChange, Falling, CheckMapReminder,
			DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleToHands, ToggleInvHints,
			QuickUseMap, DoKick, QuickSave, Fire, AltFire, PressingFire, PressingAltFire, 
			WeaponZoom, WeaponZoomIn, WeaponZoomOut,
			SwitchWeapon, ProcessMove, ExitSnipingState, CanBeMugged, ReadyForCashier,
			IsSaveAllowed, ExitPrepToSave, SetupGettingMugged;

	///////////////////////////////////////////////////////////////////////////////
	// These two zoom the camera in and out
	///////////////////////////////////////////////////////////////////////////////
	exec function NextWeapon()
	{
		if( Level.Pauser!=None)
			return;

		if(ViewTarget == MyPawn)
			DeadNextWeapon(CAMERA_ZOOM_CHANGE, CAMERA_MIN_DIST);
	}
	exec function PrevWeapon()
	{
		if( Level.Pauser!=None)
			return;

		if(ViewTarget == MyPawn)
			DeadPrevWeapon(CAMERA_ZOOM_CHANGE, CAMERA_MAX_DIST);
	}
	///////////////////////////////////////////////////////////////////////////////
	// Animate the targetter
	///////////////////////////////////////////////////////////////////////////////
	function AnimateTargetter(float DeltaTime)
	{
		RadarTargetAnimTime -= DeltaTime;
		if(RadarTargetAnimTime < 0)
			RadarTargetAnimTime+=(TARGET_FRAME_TIME*TARGET_FRAME_MAX);
	}
	///////////////////////////////////////////////////////////////////////////////
	// Handle moving target instead of player
	///////////////////////////////////////////////////////////////////////////////
	function PlayerMove(float DeltaTime)
	{
		local bool bMoved;
		local float tryX, tryY;

		Super.PlayerMove(DeltaTime);

		// Don't allow chompy movement till the radar isn't paused
		// and are focussed on the player
		if(ViewTarget == MyPawn
			&& RadarTargetState != ERTargetPaused)
		{
			tryY = RadarTargetY;
			tryX = RadarTargetX;
			if(aForward > 0)
			{
				tryY -= DeltaTime*RADAR_TARGET_MOVE_MOD;
				bMoved=true;
			}
			else if(aForward < 0)
			{
				tryY += DeltaTime*RADAR_TARGET_MOVE_MOD;
				bMoved=true;
			}
			if(aStrafe > 0)
			{
				tryX += DeltaTime*RADAR_TARGET_MOVE_MOD;
				bMoved=true;
			}
			else if(aStrafe < 0)
			{
				tryX -= DeltaTime*RADAR_TARGET_MOVE_MOD;
				bMoved=true;
			}

			// Make sure the target is within it's bounds
			if(((100*tryY)*(100*tryY) + (100*tryX)*(100*tryX)) < RADAR_TARGET_MAX_RADIUS)
			{
				RadarTargetY = tryY;
				RadarTargetX = tryX;
			}

			// Check to stop looking at stats screen and return to normal game
			if(RadarTargetState == ERTargetStatsWait)
				AnimateTargetter(DeltaTime);
			else if(RadarTargetState == ERTargetStats)
			{
				AnimateTargetter(DeltaTime);
				if(bMoved)
				{
					EndRadarTarget();
				}
			}
			else
			{
				// Check to stop waiting
				if(RadarTargetState == ERTargetWaiting
					&& bMoved)
					RadarTargetState = ERTargetOn;

				if(RadarTargetState == ERTargetOn)
				{
					AnimateTargetter(DeltaTime);
					// Decrement how long target-game time is
					RadarTargetTimer-=DeltaTime;
					if(RadarTargetTimer <= 0)
					{
						RadarTargetTimer = 0.0;
						RadarTargetState = ERTargetStatsWait;
						SetupTargettingMusic();
						SetupTargetPrizeTextures();
						GotoState('PlayerRadarTargetting', 'TargetStatsScreen');
					}
				}
			}
		}
		else if(RadarTargetState >= ERTargetKilling1
			&& RadarTargetState <= ERTargetDead)
		{
			AnimateTargetter(DeltaTime);
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// Snap the camera to who you're killing
	///////////////////////////////////////////////////////////////////////////////
	function TargetKillsPawn(FPSPawn KillMe)
	{
		SetViewTarget(KillMe);
		bBehindView = true;
		RadarTargetState = ERTargetKilling1;
		RadarTargetX = 0.5 + FRand()*TARGET_RAND_WATCHX - TARGET_RAND_WATCHX/2;
		RadarTargetY = 0.5 + FRand()*TARGET_RAND_WATCHY - TARGET_RAND_WATCHY/2;
		MyPawn.AmbientSound = None;
		GotoState('PlayerRadarTargetting', 'WatchPawnDie');
	}

	///////////////////////////////////////////////////////////////////////////////
	// Hurt the pawn that you see, till he dies
	///////////////////////////////////////////////////////////////////////////////
	function HurtTargetPawn()
	{
		local FPSPawn Viewpawn;
		local vector attackpos;

		Viewpawn = FPSPawn(ViewTarget);
		if(Viewpawn != None
			&& Viewpawn != MyPawn)
		{
			attackpos = Viewpawn.Location;
			attackpos += (VRand()*Viewpawn.CollisionRadius);
			// Play attack sound
			Viewpawn.PlaySound(TargetAttackSounds[Rand(ArrayCount(TargetAttackSounds))],SLOT_Misc,,,,0.5);
			// He's attacked
			Viewpawn.TakeDamage(Viewpawn.HealthMax/4, None, attackpos, VRand(), class'BloodMakingDamage');
			// Tell others he's been attacked
			RadarTargetHitMarker.static.NotifyControllersStatic(
				Level,
				RadarTargetHitMarker,
				Viewpawn,
				Viewpawn, 
				RadarTargetHitMarker.default.CollisionRadius,
				Viewpawn.Location);
			// Freak out
			if(PersonController(Viewpawn.Controller) != None)
				PersonController(Viewpawn.Controller).GotoState('AttackedByChompy');
			if(ViewPawn.Health > 0)
			{
				RadarTargetX = 0.5 + FRand()*TARGET_RAND_WATCHX - TARGET_RAND_WATCHX/2;
				RadarTargetY = 0.5 + FRand()*TARGET_RAND_WATCHY - TARGET_RAND_WATCHY/2;
				// Move through the killing stages
				if(RadarTargetState == ERTargetKilling1)
					RadarTargetState = ERTargetKilling2;
				else if(RadarTargetState == ERTargetKilling2)
					RadarTargetState = ERTargetKilling3;
				else if(RadarTargetState == ERTargetKilling3)
					RadarTargetState = ERTargetKilling4;	// holds on the last one
				GotoState('PlayerRadarTargetting', 'WatchPawnDie');
			}
			else
			{
				RadarTargetKills++;
				RadarTargetState = ERTargetDead;
			}
		}
	}
	///////////////////////////////////////////////////////////////////////////////
	// Put the camera back on the player
	///////////////////////////////////////////////////////////////////////////////
	function GoBackToPlayer()
	{
		SetViewTarget(MyPawn);
		bBehindView = false;
		RadarTargetState = ERTargetPaused;
		SetupTargettingMusic();
		// Reset target position
		RadarTargetX = 0;
		RadarTargetY = 0;
		// Reupdate radar
		MyPawn.ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	}

	///////////////////////////////////////////////////////////////////////////////
	// Music plays before you kill people
	///////////////////////////////////////////////////////////////////////////////
	function SetupTargettingMusic()
	{
		MyPawn.AmbientSound = RadarTargetMusic;
	}

	///////////////////////////////////////////////////////////////////////////////
	// Clean up in anyway (state stuff, for instance) after being
	// sent to jail
	///////////////////////////////////////////////////////////////////////////////
	function GettingSentToJail()
	{
		log(self$" GettingSentToJail from "$GetStateName());
		// Exit this state
		GotoState('PlayerWalking');
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		Super.BeginState();
		// Put away your weapons
		SwitchToHands();
		// stop running
		MyPawn.StopAcc();
		// start the crazy music
		SetupTargettingMusic();
		// Give him god mode, to not get hurt while targetting
		bGodMode=true;
		// reset kills
		RadarTargetKills=0;
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function EndState()
	{
		Super.EndState();
		// clear game music
		MyPawn.AmbientSound = None;
		// Setup player again
		SetViewTarget(MyPawn);
		bBehindView = false;
		// Take god mode away if necessary
		if(P2GameInfoSingle(Level.Game) == None
			|| P2GameInfoSingle(Level.Game).TheGameState == None
			|| !P2GameInfoSingle(Level.Game).TheGameState.bCheatGod)
			bGodMode=false;
	}

Begin:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	RadarTargetState = ERTargetWaiting;
Playing:
	Sleep(REPORT_LOOKS_SLEEP_TIME);
	MyPawn.ReportPlayerLooksToOthers(RadarPawns, (RadarState != ERadarOff), RadarInDoors);
	Goto('Playing');
WatchPawnDie:
	Sleep(TARGET_ATTACK_TIME);
	HurtTargetPawn();
	Sleep(TARGET_WAIT_TIME);
	GoBackToPlayer();
	Goto('Begin');
TargetStatsScreen:
	Sleep(2.0);
	RadarTargetState = ERTargetStats;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// PlayerSuicideByGrenade
// 
// Player getting ready to commit suicide
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerSuicideByGrenade
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, ActivateInventoryItem, Jump, ThrowWeapon,
		ThrowPowerup, PrevInvItem, NextInvItem, ActivateItem, NotifyHeadVolumeChange, 
		NotifyPhysicsVolumeChange, Falling, CheckMapReminder, SwitchWeapon,
		DamageAttitudeTo, Suicide, UseZipper, DudeShoutGetDown, ToggleInvHints, ToggleToHands,
		QuickUseMap, DoKick, QuickSave, CanBeMugged, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
		IsSaveAllowed, ReadyForCashier, ExitSnipingState, ExitPrepToSave, SetupGettingMugged;

	///////////////////////////////////////////////////////////////////////////////
	// Both fires kill you
	///////////////////////////////////////////////////////////////////////////////
	exec function Fire( optional float F )
	{
		if ( Level.Pauser == PlayerReplicationInfo )
		{
			SetPause(false);
			return;
		}
		// client side
		GotoState('PlayerSuicidingByGrenade');
		// server side
		ServerPerformSuicide();
	}
	exec function AltFire( optional float F )
	{
		if ( Level.Pauser == PlayerReplicationInfo )
		{
			SetPause(false);
			return;
		}
		// Single player can't cancel out
		// You're more likely to accidentally hit in MP than SP.
		if(Level.Game != None
			&& Level.Game.bIsSinglePlayer)
			ServerPerformSuicide();
		else // MP can cancel out
			ClientCancelSuicide();
	}

	///////////////////////////////////////////////////////////////////////////////
	// These two zoom the camera in and out
	///////////////////////////////////////////////////////////////////////////////
	exec function NextWeapon()
	{
		if( Level.Pauser!=None)
			return;
		DeadNextWeapon(CAMERA_DEAD_ZOOM_CHANGE, CAMERA_DEAD_MIN_DIST);
	}
	exec function PrevWeapon()
	{
		if( Level.Pauser!=None)
			return;
		DeadPrevWeapon(CAMERA_DEAD_ZOOM_CHANGE, CAMERA_DEAD_MAX_DIST);
	}
	///////////////////////////////////////////////////////////////////////////////
	// Pick the head to stare at
	///////////////////////////////////////////////////////////////////////////////
	function CalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
	{
		//log(self$" CalcBehindView, state "$GetStateName());
		SuicideCalcBehindView(CameraLocation, CameraRotation, Dist);
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function PlayerMove(float DeltaTime)
	{
		local vector X,Y,Z;
		local rotator ViewRotation;

		if ( bPressedJump )
		{
			Fire(0);
			bPressedJump = false;
		}
		GetAxes(Rotation,X,Y,Z);
		// Update view rotation.
		ViewRotation = Rotation;
		ViewRotation.Yaw += 32.0 * DeltaTime * aTurn;
		ViewRotation.Pitch += 32.0 * DeltaTime * aLookUp;
		ViewRotation.Pitch = ViewRotation.Pitch & 65535;
		If ((ViewRotation.Pitch > 18000) && (ViewRotation.Pitch < 49152))
		{
			If (aLookUp > 0) 
				ViewRotation.Pitch = 18000;
			else
				ViewRotation.Pitch = 49152;
		}
		SetRotation(ViewRotation);
		if ( Role < ROLE_Authority ) // then save this move and replicate it
			ReplicateMove(DeltaTime, vect(0,0,0), DCLICK_None, rot(0,0,0));
		ViewShake(DeltaTime);
		ViewFlash(DeltaTime);
	}

	simulated function BeginState()
	{
		local SavedMove Next;

		Enemy = None;
		bBehindView = true;
		bFrozen = false;
		bPressedJump = false;
		FindGoodCameraView();
		ResetFOV();
		// Make sure the proper fog is used on this zone
		if(P2GameInfo(Level.Game) != None)
			P2GameInfo(Level.Game).SetGeneralZoneFog(Pawn);

		// Turn off twisting
		Pawn.SetTwistLook(0, 0);
		Pawn.bDoTorsoTwist=false;

		// Put away your current weapon
		SwitchToHands(true);
			
		// Stop running
		//mypawnfix
		P2Pawn(Pawn).StopAcc();

		// clean out saved moves
		while ( SavedMoves != None )
		{
			Next = SavedMoves.NextMove;
			SavedMoves.Destroy();
			SavedMoves = Next;
		}
		if ( PendingMove != None )
		{
			PendingMove.Destroy();
			PendingMove = None;
		}
	}
	
	simulated function EndState()
	{
		CleanOutSavedMoves();
		Velocity = vect(0,0,0);
		Acceleration = vect(0,0,0);
		bPressedJump = false;

		bBehindView = false;
	}
Begin:
	Sleep(1.0);
	// Wait to make sure you're hands are all the way out
	if(!HasHandsOut())
		SwitchToHands(true);
	goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// PlayerSuicidingByGrenade
// 
// Player is actually pulling the pin and waiting for the explosion now
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state PlayerSuicidingByGrenade extends PlayerSuicideByGrenade
{
	ignores Fire, AltFire, EndState, TakeDamage, NotifyTakeHit, ServerPerformSuicide,
		PressingFire, PressingAltFire;

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function AlertOthers()
	{
		// Tell others something is wrong
		SuicideStartMarker.static.NotifyControllersStatic(
			Level,
			SuicideStartMarker,
			MyPawn,
			MyPawn, 
			SuicideStartMarker.default.CollisionRadius,
			Pawn.Location);
	}

	///////////////////////////////////////////////////////////////////////////////
	// Make yourself invincible once you start this state (but the grenade
	// in your mouth will still kill you)
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		bBehindView = true;
		bGodMode = true;
		bCommitedSuicide=true;
		//mypawnfix
		Pawn.GotoState('Suiciding');
	}
	function EndState()
	{
		// clean up
		bGodMode = false;
		Super.EndState();
	}
Begin:
	// Wait to make sure you're hands are all the way out
	if(!HasHandsOut())
	{
		SwitchToHands(true);
		Sleep(0.5);	// Give him time to put my gun away
		Goto('Begin');
	}

	//mypawnfix
	P2MocapPawn(Pawn).PlayGrenadeSuicideAnim();
	//SayTime = MyPawn.Say(MyPawn.myDialog.lDude_Suicide) + 0.5;
	PlaySound(P2Pawn(Pawn).DudeSuicideSound);

	//Sleep(SayTime + 0.5);
	// hacked time--make it a notify
	// You're saying your line
	Sleep(2.5);
	// And just before you tell others something is wrong
	AlertOthers();
	// Wait just a hair
	Sleep(1.0);
	// Then your head explodes
	P2Pawn(Pawn).GrenadeSuicide();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Dead
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state Dead
{
ignores SeePlayer, HearNoise, KilledBy, NotifyBump, HitWall, ActivateInventoryItem, ThrowPowerup,
		PrevInvItem, NextInvItem, CheckMapReminder,
		ThrowWeapon, ActivateItem, NotifyHeadVolumeChange, NotifyPhysicsVolumeChange, Falling, 
		TakeDamage, Suicide, UseZipper, DudeShoutGetDown, WeaponZoom, WeaponZoomIn, WeaponZoomOut,
		QuickUseMap, DoKick, QuickSave, SwitchToHands, ToggleToHands, CanBeMugged, ToggleInvHints,
		IsSaveAllowed, ReadyForCashier, SetupGettingMugged, ExitPrepToSave, ExitSnipingState;

	///////////////////////////////////////////////////////////////////////////////
	// These two zoom the camera in and out
	///////////////////////////////////////////////////////////////////////////////
	exec function NextWeapon()
	{
		if( Level.Pauser!=None)
			return;
		DeadNextWeapon(CAMERA_DEAD_ZOOM_CHANGE, CAMERA_DEAD_MIN_DIST);
	}
	exec function PrevWeapon()
	{
		if( Level.Pauser!=None)
			return;
		DeadPrevWeapon(CAMERA_DEAD_ZOOM_CHANGE, CAMERA_DEAD_MAX_DIST);
	}
	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function CalcBehindView(out vector CameraLocation, out rotator CameraRotation, float Dist)
	{
//		log(self$" p2player calcbehind view, pawn "$Pawn);
		if(Pawn != None)
			DeadCalcBehindView(CameraLocation, CameraRotation, Dist);
		else
			Super.CalcBehindView(CameraLocation, CameraRotation, Dist);
	}

	///////////////////////////////////////////////////////////////////////////////
	// Don't allow the camera to mess up things if you've suicided (because we've
	// already gotten a good camera view at that point)
	///////////////////////////////////////////////////////////////////////////////
	function FindGoodView()
	{
		//mypawnfix
		if(P2Pawn(Pawn) != None
			&& P2Pawn(Pawn).HitDamageType != class'Suicided')
		{
			Global.FindGoodCameraView();
		}
		else
			Super.FindGoodView();
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function EndState()
	{
		IncDeathMessageNum();
		Super.EndState();
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	function BeginState()
	{
		// Put a min cap on the camera dist
		if(CameraDist < CAMERA_DEAD_MIN_DIST)
			CameraDist = CAMERA_DEAD_MIN_DIST;

		// Let super do it's stuff
		Super.BeginState();

		ResetFOV();

		// Make sure we're not still in god mode at this point. If we don't,
		// then in MP, if we suicided, we could restart in god mode
		bGodMode=false;

		// Show the hud (for death messages)
		MyHud.bHideHud=false;

		// Force it back to normal game speed
		if(P2GameInfoSingle(Level.Game) != None)
			P2GameInfoSingle(Level.Game).SetGameSpeedNoSave(1.0);

		// Make you hang around longer staring at your dead body in MP
		if(Level.Game == None
			|| !FPSGameInfo(Level.Game).bIsSinglePlayer)
			SetTimer(FREEZE_TIME_AFTER_DYING_MP, true);
		else
			SetTimer(FREEZE_TIME_AFTER_DYING, true);
	}

	///////////////////////////////////////////////////////////////////////////////
	///////////////////////////////////////////////////////////////////////////////
	exec function GameOverRestart(optional float F)
	{
		if( Level.Pauser!=None)
			return;

		if ( !bFrozen 
			&& Level.Game != None)
		{
			if(P2GameInfoSingle(Level.Game).bIsDemo)
			{
				// Go back to main menu to restart demo
				Log("'Return to main menu' is happening while Dead in the demo.");
				P2GameInfoSingle(Level.Game).QuitGame();
			}
			else
			{
				// Load the most recent game
				Log("GameOverRestart is happening while Dead.");
				P2GameInfoSingle(Level.Game).LoadMostRecentGame();
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Spectating
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state Spectating
{
	ignores ThrowPowerup, Suicide, CheckMapReminder;
}

exec function StartMe()
{
	ConsoleCommand("Start 192.168.0.3");
}

defaultproperties
{
	bAutoSwitchOnEmpty=true
	LastWeaponGroupPee=1
	HeartBeatSpeed=5
	HeartBeatSpeedAdd=14
	HeartScale=0.5
	SayThingsOnGuyDeathFreq=0.22
	SayThingsOnGuyBurningDeathFreq=0.4
	SayThingsOnWeaponFire=0.2
	CrackDamagePercentage = 0.25;
	CrackHintTimes[0]=10
	CrackHintTimes[1]=30
	CrackHintTimes[2]=60
	CrackStartTime=400
//	DefaultHandsTexture=Texture'WeaponSkins.Dude_Hands'
	DefaultHandsTexture=Texture'MP_FPArms.LS_arms.LS_hands_dude'
	TimeForMapReminder=900
	MapReminderRefresh=20
	RadarSize=200
	RadarShowRadius=80
	RadarMaxZ=200
	RadarScale=0.04
	RadarBackY=1.0
	BodySpeed=1.0
	CameraDist=7.0
	RadarClickSound=Sound'MiscSounds.Radar.RadarClick'
	RadarBuzzSound=Sound'MiscSounds.Radar.RadarBuzz'
	TargetAttackSounds[0] = Sound'AnimalSounds.Dog.dog_biting2'
	TargetAttackSounds[1] = Sound'AnimalSounds.Dog.dog_biting3'
	RadarTargetMusic = Sound'MiscSounds.TargetMusic'
	RadarTargetHitMarker=class'PawnShotMarker'
	SuicideStartMarker=class'PawnShotMarker'
	StuckText1="You look like you're stuck."
	StuckText2="There you go... now stay outta that spot!"
	HintsOnText="Inventory and weapon hints on are On."
	HintsOffText="Inventory and weapon hints on are Off."
	MuggerHint1="They sound serious! Better drop your"
	MuggerHint2="money if you don't want to get hurt."
	MuggerHint3="Find the money in your inventory and"
	MuggerHint4="press ' to drop it before they shoot!"
	CheckMapText1="Press 'F' to check the map for errands to complete."
	CheckMapText2="HEY! Press 'F' to check the freakin' map for errands to do!"
	CheckMapText3="CHECK THE MAP AND LOOK AT YOUR ERRANDS!"
	CheckMapText4="THIS ANNOYING MESSAGE WILL GO AWAY IF YOU CHECK YOUR MAP!"
	DeathHints1[0]="Hmmm... looks like you're dying pretty quickly."
	DeathHints1[1]="Instead of just standing around enjoying the pain,"
	DeathHints1[2]="try running and hiding from your aggressors."
	DeathHints1[3]="Wait and hide from them and then attack them"
	DeathHints1[4]="when they come running around the corner to find you."
	DeathHints2[0]="Make sure to conserve your health powerups for the worst"
	DeathHints2[1]="fire-fights. Try to keep and eye on your health for the"
	DeathHints2[2]="best time for a health boost. Gather up lots of powerups"
	DeathHints2[3]="before going into a big battle."
	DeathHints3[0]="Take a slower pace when you get into fire-fights."
	DeathHints3[1]="If you rush through an area of people who are trying to"
	DeathHints3[2]="kill you, get ready for a lot of damage."
	DeathHints3[3]="Try moving along slowly, letting only a few of their"
	DeathHints3[4]="buddies know about you at once. They'll be easier to handle."
	FireDeathHints1[0]="That sure looks hot. I bet it hurts too."
	FireDeathHints1[1]="Did you know there's a way to put yourself out"
	FireDeathHints1[2]="when you're on fire? Yup... there sure is."
	FireDeathHints1[3]="Try thinking with you're lower half next time."
	NoMoreHealthItems="You're out of healing items."
	CheatsOnText="Cheats are enabled. Hope you're happy."
	CheatsOffText="Cheats are disabled."
	QuickSaveString="Saving" 	// Change engine's default message
	QuickKillGoodEndSound=Sound'LevelSounds.train_cross_bell_LP'
	QuickKillBadEndSound=Sound'AmbientSounds.FactoryBuzzer'
	RagdollMax=10
	TransientSoundRadius = 100
	ReticleNum=1
	ReticleAlpha=90
	Reticles[0]=Texture'P2Misc.Reticle.Reticle_Crosshair_Redline'
	Reticles[1]=Texture'P2Misc.Reticle.Reticle_Crosshair_Circular'
	Reticles[2]=Texture'P2Misc.Reticle.Reticle_Crosshair_Cross'
	Reticles[3]=Texture'P2Misc.Reticle.Reticle_Crosshair_WhiteLine'
	Reticles[4]=Texture'P2Misc.Reticle.Reticle_RedDot'
	ReticleColor=(R=255,G=255,B=255,A=90)	// Alpha gets overwritten by ReticleAlpha
	ShowBlood=true
	HurtBarAlpha=255
	HudViewState=3
	bWeaponBob=true
	bMpHints=true
}
