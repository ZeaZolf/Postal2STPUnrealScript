///////////////////////////////////////////////////////////////////////////////
// StatsScreen.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Screen of game statistics.
// This screen can load a URL, but waits till the player is done, and has
// pressed spacebar to do it.
//
//	History:
//		11/08/02 NPF	Started.
//
///////////////////////////////////////////////////////////////////////////////
class StatsScreen extends P2Screen;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////
var localized string PeopleKilled;
var localized string CopsKilled;		
var localized string PeopleRoasted;
var localized string ElephantsKilled;	
var localized string DogsKilled;		
var localized string CatsKilled;		
var localized string PistolHeadShot;	
var localized string ShotgunHeadShot;	
var localized string RifleHeadShot;	
var localized string CatsUsed;		
var localized string MoneySpent;		
var localized string PeeTotal;		
var localized string DoorsKicked;		
var localized string TimesArrested;	
var localized string DressedAsCop;	
var localized string DogsTrained;		
var localized string CopsLuredByDonuts;		
var localized string Ranking;
var string PlayerRank;

var int StatNum;
var int StatMax;				// This must include all the localized strings above

var String URL;

var GameState gamest;

var localized string CheatsNow;


const	LEFT_START_X	=	0.20; 
const	RIGHT_START_X	=	0.7; 
const	START_Y			=	0.06; 
const	INC_Y			=	0.04;
const	REVEAL_TIME		=	0.1;
const   FINAL_WAIT_TIME	=	2.0;

///////////////////////////////////////////////////////////////////////////////
// Call this to bring up the screen
///////////////////////////////////////////////////////////////////////////////
function Show(String URLin)
	{
	URL = URLin;
	
	gamest = GetGameSingle().TheGameState;
	PlayerRank = gamest.GetPlayerRanking();

	// Set our first state and start it up
	AfterFadeInScreen = 'RevealScreen1';
	StatNum=0;
	Super.Start();
	}

///////////////////////////////////////////////////////////////////////////////
// Called before player travels to a new level
///////////////////////////////////////////////////////////////////////////////
function PreTravel()
	{
	Super.PreTravel();

	// Get rid of all actors because they'll be invalid in the new level (not
	// doing this will lead to intermittent crashes!)
	gamest = None;
	}

///////////////////////////////////////////////////////////////////////////////
// Default tick function.
///////////////////////////////////////////////////////////////////////////////
function Tick(float DeltaTime)
	{
	Super.Tick(DeltaTime);

	if (bPlayerWantsToEnd)
		{
		// Clear flag (it may get set again)
		bPlayerWantsToEnd = false;
		ChangeExistingDelay(0.1);
		End();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Render the screen
///////////////////////////////////////////////////////////////////////////////
function RenderScreen(canvas Canvas)
	{
	local int i;
	local float sxl, sxr, sy;
	local string ustr;

	if(!bEnableRender
		|| gamest == None) return;

	// Let super draw background texture
	Super.RenderScreen(Canvas);

	// Show our stats
	sxl = LEFT_START_X;
	sxr = RIGHT_START_X;
	sy = START_Y;
	if(StatNum == 0) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, PeopleKilled, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.PeopleKilled, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 1) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, CopsKilled, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.CopsKilled, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 2) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, PeopleRoasted, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.PeopleRoasted, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 3) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, ElephantsKilled, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.ElephantsKilled, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 4) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, DogsKilled, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.DogsKilled, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 5) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, CatsKilled, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.CatsKilled, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 6) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, PistolHeadShot, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.PistolHeadShot, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 7) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, ShotgunHeadShot, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.ShotgunHeadShot, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 8) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, RifleHeadShot, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.RifleHeadShot, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 9) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, CatsUsed, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.CatsUsed, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 10) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, MoneySpent, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.MoneySpent, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 11) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, PeeTotal, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$(0.1*float(gamest.PeeTotal)), 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 12) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, DoorsKicked, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.DoorsKicked, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 13) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, TimesArrested, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.TimesArrested, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 14) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, DressedAsCop, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.DressedAsCop, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 15) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, DogsTrained, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.DogsTrained, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 16) return;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxl * Canvas.ClipX, sy * Canvas.ClipY, CopsLuredByDonuts, 0, false, EJ_Left);
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, sxr * Canvas.ClipX, sy * Canvas.ClipY, ustr$gamest.CopsLuredByDonuts, 0, false, EJ_Left);
	sy += INC_Y;
	if(StatNum == 17) return;

	// Final summary
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, 0.5 * Canvas.ClipX, sy * Canvas.ClipY, Ranking, 2, false, EJ_Center);
	sy += INC_Y;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, 0.5 * Canvas.ClipX, sy * Canvas.ClipY, ustr$PlayerRank, 3, false, EJ_Center);
	sy += INC_Y;
	sy += INC_Y;
	MyFont.DrawTextEx(Canvas, Canvas.ClipX, 0.5 * Canvas.ClipX, sy * Canvas.ClipY, CheatsNow, 1, false, EJ_Center);
	if(StatNum == 18) return;
	}

///////////////////////////////////////////////////////////////////////////////
// Slowly reveal all the stats
///////////////////////////////////////////////////////////////////////////////
state RevealScreen1 extends ShowScreen
	{
	///////////////////////////////////////////////////////////////////////////////
	// Don't let them skip
	///////////////////////////////////////////////////////////////////////////////
	function Tick(float DeltaTime)
		{
		Super.Tick(DeltaTime);
		}
	function BeginState()
		{
		StatNum++;
		DelayedGotoState(REVEAL_TIME, 'RevealScreen2');
		}
	}
state RevealScreen2 extends ShowScreen
	{
	///////////////////////////////////////////////////////////////////////////////
	// Don't let them skip
	///////////////////////////////////////////////////////////////////////////////
	function Tick(float DeltaTime)
		{
		Super.Tick(DeltaTime);
		}
	function BeginState()
		{
		if(StatNum == StatMax)
			{
			// Finished
			DelayedGotoState(0.0, 'WaitMore');
			}
		else
			{
			// Go back
			DelayedGotoState(0.0, 'RevealScreen1');
			}
		}
	}
state WaitMore extends ShowScreen
	{
	///////////////////////////////////////////////////////////////////////////////
	// Don't let them skip
	///////////////////////////////////////////////////////////////////////////////
	function Tick(float DeltaTime)
		{
		Super.Tick(DeltaTime);
		}
	function BeginState()
		{
		//ViewportOwner.Actor.bWantsToSkip=0;	// Clear key entries
		//bPlayerWantsToEnd=false;
		//bEndNow = false;
		DelayedGotoState(FINAL_WAIT_TIME, 'HoldScreen');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// View screen until player decides to stop
///////////////////////////////////////////////////////////////////////////////
state HoldScreen extends ShowScreen
	{
	function BeginState()
		{
		ShowMsg();
		if (URL != "")
			WaitForEndThenGotoState('LoadingScreen');
		else
			WaitForEndThenGotoState('FadeOutScreen');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// View the screen while the main menu loads
///////////////////////////////////////////////////////////////////////////////
state LoadingScreen extends ShowScreen
{
	function BeginState()
	{
		SendThePlayerTo(URL, 'FadeOutScreen');
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	Song = "map_muzak.ogg"
	bFadeGameInOut = true
	FadeInGameTime = 0.3
	FadeOutGameTime = 0.3
	bFadeScreenInOut = true
	FadeInScreenTime = 0.5
	FadeOutScreenTime = 0.5
	BackgroundName		="P2Misc_full.InkyBlackness"
	PeopleKilled		="Total people murdered:"
	CopsKilled			="Cops killed:"
	PeopleRoasted		="People roasted:"
	ElephantsKilled		="Elephants slaughtered:"
	DogsKilled			="Dogs eliminated:"
	CatsKilled			="Cats destroyed:"
	PistolHeadShot		="Instant kill, pistol head shots:"
	ShotgunHeadShot		="Heads exploded by shotgun:"
	RifleHeadShot		="Total rifle head shots:"
	CatsUsed			="Cats violated with a weapon:"
	MoneySpent			="Total money spent:"
	PeeTotal			="Gallons of piss pissed:"
	DoorsKicked			="Doors kicked in:"
	TimesArrested		="Times arrested:"
	DressedAsCop		="Number of times dressed up as a cop:"
	DogsTrained			="Times a dog was befriended:"	
	CopsLuredByDonuts   ="Number of cops you lured with donuts:"	
	Ranking				="Summary:  "
	CheatsNow			="Cheats now accessible with in-game menu (press Esc)!"
	StatMax				= 18
	}
