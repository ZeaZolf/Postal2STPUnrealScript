///////////////////////////////////////////////////////////////////////////////
// LoadScreen.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The load screen.
//
//	History:
//		07/19/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class LoadScreen extends P2Screen;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var String URL;


///////////////////////////////////////////////////////////////////////////////
// Call this to bring up the screen
///////////////////////////////////////////////////////////////////////////////
function Show(DayBase day, String URLin)
	{
	// Get texture based on specified day (which should be the NEXT day)
	BackgroundTex = day.GetLoadTexture();

	URL = URLin;
	
	// Set our first state and start it up
	AfterFadeInScreen = 'ViewScreen';
	Super.Start();
	}

///////////////////////////////////////////////////////////////////////////////
// Send the player to wherever he's going
///////////////////////////////////////////////////////////////////////////////
state ViewScreen extends ShowScreen
	{
	function BeginState()
		{
		SendThePlayerTo(URL, 'FadeOutAll');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Fade out screen and then resume the game
///////////////////////////////////////////////////////////////////////////////
state FadeOutAll extends ShowScreen
	{
	function BeginState()
		{
		// Pause the game so no action occurs while we fade out
		ViewportOwner.Actor.SetPause(true);
		MaybeLog("LoadScreen.FadeOutAll.BeginState(): pausing game");
		SetFadeOut(FadeOutScreenTime, true);
		DelayedGotoState(FadeOutScreenTime, 'CoverUpFlash');
		}
	}

state CoverUpFlash extends ShowScreen
	{
	function BeginState()
		{
		// We assume that a matinee scene will immediately follow this loading
		// screen.  We don't fade in the game screen after fading out this
		// screen because we assume the matinee scene will do the fade in.
		// We also add a brief delay after unpausing the game here to cover up
		// the flash that occurs at the start of a level when the camera is
		// being tossed around between the player and the scene manager
		ViewportOwner.Actor.SetPause(false);
		MaybeLog("LoadScreen.CoverUpFlash.BeginState(): unpausing game");
		DelayedGotoState(0.2, 'Shutdown');
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bFadeGameInOut=false
	FadeInGameTime=0.0
	FadeOutGameTime=0.0
	FadeInScreenTime=1.0
	FadeOutScreenTime=1.0
	}
