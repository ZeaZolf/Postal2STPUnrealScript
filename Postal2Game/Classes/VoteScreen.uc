///////////////////////////////////////////////////////////////////////////////
// VoteScreen.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The voting screen.
//
//	History:
//		07/12/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class VoteScreen extends P2Screen;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

struct SHole
	{
	var() float x;
	var() float y;
	};
var() editinline array<SHole> Holes;

struct SPunch
	{
	var() int hole;
	var() Texture tex;
	var() Sound snd;
	};
var() editinline array<SPunch> Punches;
var int PunchCount;

var() name CursorName;
var Texture Cursor;

var() name PunchSoundName;
var Sound PunchSound;

var bool bButtonPressed;
var bool bPunchedBallot;
var bool bAllowNextPunch;


///////////////////////////////////////////////////////////////////////////////
// Call this to bring up the screen
///////////////////////////////////////////////////////////////////////////////
function Show()
	{
	PunchCount = -1;
	bButtonPressed = false;
	bPunchedBallot = false;
	bAllowNextPunch = false;

	bWantInputEvents = true;

	if (PunchSound == None && PunchSoundName != 'None')
		PunchSound = Sound(DynamicLoadObject(String(PunchSoundName), class'Sound'));
	if (Cursor == None && CursorName != 'None')
		Cursor = Texture(DynamicLoadObject(String(CursorName), class'Texture'));

	// Set our first state and start it up
	AfterFadeInScreen = 'WaitForPunch';
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
	}

///////////////////////////////////////////////////////////////////////////////
// Render the screen
///////////////////////////////////////////////////////////////////////////////
function RenderScreen(canvas Canvas)
	{
	local int i;

	// Let super draw background texture
	Super.RenderScreen(Canvas);

	// Draw punched holes
	for (i = 0; i <= PunchCount; i++)
		DrawScaled(Canvas, Punches[i].tex, Holes[Punches[i].hole].x, Holes[Punches[i].hole].y);

	// Draw cursor
	DrawScaled(canvas, Punches[0].tex, ViewportOwner.WindowsMouseX/ScaleX, ViewportOwner.WindowsMouseY/ScaleY, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Handle input events
///////////////////////////////////////////////////////////////////////////////
function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
	{
	local bool bHandled;

	if (Action == IST_Press && !bButtonPressed)
		{
		if (bAllowNextPunch)
			{
			if (Key == IK_RightMouse || Key == IK_LeftMouse)
				{
				bButtonPressed = true;
				bPunchedBallot = true;
				bAllowNextPunch = false;
				PunchCount++;
				GotoState('GotPunch');
				bHandled = true;
				}
			}
		}
	else if (Action == IST_Release && bButtonPressed)
		{
		if (Key == IK_RightMouse || Key == IK_LeftMouse)
			{
			bButtonPressed = false;
			bHandled = true;
			}
		}

	return bHandled;
	}

///////////////////////////////////////////////////////////////////////////////
// Default tick function.
///////////////////////////////////////////////////////////////////////////////
function Tick(float DeltaTime)
	{
	Super.Tick(DeltaTime);

	if (bEndNow)
		GotoState('Shutdown');
	}

///////////////////////////////////////////////////////////////////////////////
// Wait for player to punch the ballot
///////////////////////////////////////////////////////////////////////////////
state WaitForPunch extends ShowScreen
	{
	function BeginState()
		{
		bAllowNextPunch = true;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Got a punch so have the dude say something funny
///////////////////////////////////////////////////////////////////////////////
state GotPunch extends ShowScreen
	{
	function BeginState()
		{
		local float Duration;

		GetSoundActor().PlaySound(PunchSound, SLOT_Misc);

		Duration = GetSoundDuration(Punches[PunchCount].snd) + 0.5;
		GetSoundActor().PlaySound(Punches[PunchCount].snd, SLOT_Talk);

		if (PunchCount < Punches.Length - 1)
			DelayedGotoState(Duration, 'WaitForPunch');
		else
			DelayedGotoState(Duration, 'FadeOutScreen');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	BackgroundName="p2misc_full.ballot"
	CursorName="P2Misc.Reticle.Reticle_CrosshairOpenLg"
	PunchSoundName="MiscSounds.KickingDoor"
	FadeInScreenSound=Sound'DudeDialog.dude_vote_whatmoron'
	Holes(0)=(x=481,y=292)
	Holes(1)=(x=481,y=345)
	Holes(2)=(x=481,y=500)
	Holes(3)=(x=481,y=554)
	Holes(4)=(x=481,y=703)
	Holes(5)=(x=481,y=756)
	Holes(6)=(x=481,y=897)
	Punches(0)=(hole=0,tex=Texture'p2misc.vote.hole_punched',snd=Sound'DudeDialog.dude_vote_canttell')
	Punches(1)=(hole=3,tex=Texture'p2misc.vote.hole_hanging',snd=Sound'DudeDialog.dude_vote_hangingchad')
	Punches(2)=(hole=5,tex=Texture'p2misc.vote.hole_dimpled',snd=Sound'DudeDialog.dude_vote_dimple')
	}
