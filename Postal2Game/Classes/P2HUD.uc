///////////////////////////////////////////////////////////////////////////////
// Postal 2 HUD
///////////////////////////////////////////////////////////////////////////////
class P2HUD extends FPSHUD;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var P2Player OurPlayer;			// player controller that owns this
var P2Pawn   PawnOwner;			// pawn that owns this (may be viewtarget of owner rather than owner)

var float AspectRatio;			// ratio for height over width for display
var float Scale;				// Scale for rendering the canvas.

var color WhiteColor;			// white for resetting the background
var Color DefaultIconColor;		// Using 255,255,255 seems too bright, make it a little less
var color YellowColor;
var color RedColor;
var color BlueColor;

var float HeartPumpSizeX;
var float HeartPumpSizeY;
var Material HeartIcon;
var Material WantedIcon;		// texture for cops wanting the player (cop radio) texture
var Material WantedBar;			// bar to fill in over above texture
var array<Material> SectionBackground;	// Background texture for various sections
var Texture RadarBackground;
var Texture RadarPlayer;
var Texture RadarNPC;
var Texture RadarGlow;
var Texture RadarTarget[2];
var Texture RadarCopHat;
var Texture RadarGun;
var Texture BlackBox;
var Material TopHurtBar;
var Material SideHurtBar;
var Material SkullHurtBar;
var transient array<Material> TargetPrizes;

struct HudPos
	{
	var()	float	X;
	var()	float	Y;
	};

var array<HudPos> IconPos;
var array<HudPos> InvTextPos;
var array<HudPos> WeapTextPos;
var array<HudPos> WantedTextPos;
var int WeapIndex;
var int InvIndex;
var int HealthIndex;
var int WantedIndex;

// Display strings for hints (not the localized strings, just vars)
var string InvHint1;
var string InvHint2;
var string InvHint3;
var float InvHintDeathTime;	// Abs game time when hint goes away
var string WeapHint1;
var string WeapHint2;
var string WeapHint3;
var float WeapHintDeathTime;	// Abs game time when hint goes away

// Actual localized text for hints
var localized string RadarHint0;
var localized string RadarHint1;
var localized string RadarHint2;
var localized string RadarHint3;
var localized string RadarHint4;
var localized string RadarHint5;
var localized string RadarHint6;
var localized string RadarKillHint0;
var localized string RadarKillHint1;
var localized string RadarKillHint2;
var localized string RadarStatsHint0;
var localized string RadarStatsHint1;
var localized string RadarStatsHint2;
var localized string RadarStatsHint3;
var localized string RadarStatsHint4;
var localized string RadarDeadHint;
var localized string RadarMouseHint;
var localized string RocketHint1;
var localized string RocketHint2;
var localized string RocketHint3;

const HUD_INVENTORY		= 0;
const HUD_HEALTH		= 1;
const HUD_AMMO			= 2;

var localized string SuicideHintMajor;	// Hint written for commiting suicide
var localized string SuicideHintMinor;
var localized string SuicideHintMajorAlt;

var localized string DeadMessage1;		// What to do after you're dead
var localized string DeadMessage2;
var localized string DeadDemoMessage1;
var localized string DeadDemoMessage2;

var localized string QuittingMessage;
var float LoadingMessageY;
var localized string EasySavingMessage;
var localized string AutoSavingMessage;
var localized string RestartingMessage;
var localized string ForcedSavingMessage;

var String IssuedTo;

// Matinee messages
// WARNING: This struct is also used by at least one ScriptedAction so it
// can't contain any Actor references or the ScriptedAction will crash.
struct S_HudMsg
	{
	var() localized string	Msg;
	var() int				FontSize;
	var() bool				bPlain;
	var() float				X;
	var() float				Y;
	var() FontInfo.EJustify	JustifyFromX;
	};
var array<S_HudMsg>			HudMsgs;
var float					HudMsgsEndTime;

var Material TopSniperBar;		// Similar to hurt bars, these sniper bars show the direction
var Material SideSniperBar;		// of the sniper looking at you
var float SniperBarTime;	// Cummulative time for sniper bars. All bars will use this if they
								// should be shown

// This is the 'expected" canvas width.  At this width everything is displayed
// without shrinking or stretching.  At lower or higher resolutions everything
// is shrunk or stretched so the relative size on screen remains the same.
const EXPECTED_START_RES_WIDTH	= 1024;

// Positions of the centers of each HUD section
const HUD_WANTED_BAR_OFF_X		= -0.0205;
const HUD_WANTED_BAR_OFF_Y		= 0.0305;
const HUD_WANTED_BAR_SCALE_WIDTH= 0.701;
const HUD_RADAR_X				= 0.88;//0.975;
const HUD_RADAR_Y				= 0.78;//0.96;
const HUD_RADAR_Y_OFFSET		= 0.039;

const INV_HINT_LIFETIME			= 5.0;
const WEAP_HINT_LIFETIME		= 6.0;
const INFINITE_HINT_TIME		= -1.0;

// Numbers for radar
const RADAR_IMAGE_SCALE			= 1.5;
const RADAR_WARMUP_BASE			= 100;
const RADAR_NORMAL_BASE			= 60;
const RADAR_WARMUP_RAND			= 40;
const RADAR_NORMAL_RAND			= 10;
const RADAR_Y_SPEED				= 0.6;
const HUD_START_RADAR_Y			= 1.25;
const BACKGROUND_TARGET_ALPHA	= 100;
const RADAR_TARGET_HINTS		= 0.3;
const RADAR_TARGET_KILL_HINTS	= 0.05;
const RADAR_TARGET_MOUSE_HINT	= 0.9;
const RADAR_TARGET_STATS		= 0.4;
const TARGET_KILL_RADIUS		= 9.0;
const COP_OFFSET_X				= -0.002;
const COP_OFFSET_Y				= -0.01;
const GUN_OFFSET_X				= -0.0055;
const GUN_OFFSET_Y				= 0.0065;
const MP_RADAR_RADIUS			= 88;
const MP_RADAR_SCALE			= 0.016;

// Relative positions of section backgrounds
const HUD_BACKGROUND_X_OFFSET	= -0.065;
const HUD_BACKGROUND_Y_OFFSET	= -0.061;

// Relative positions of section numbers
const HUD_NUMBERS_OFFSET_X			= +0.005;
const HUD_NUMBERS_MAX_AMMO_OFFSET_X	= +0.025;
const HUD_NUMBERS_OFFSET_Y			= +0.040;

// Relative positions of armor stuff
const HUD_ARMOR_NUMBERS_OFFSET_X	= -0.050;
const HUD_ARMOR_NUMBERS_OFFSET_Y	= +0.050;
const HUD_ARMOR_ICON_OFFSET_X		= -0.050;
const HUD_ARMOR_ICON_OFFSET_Y		= -0.000;
const HUD_ARMOR_ICON_SCALE			= 0.6;

// Position of "issued to" text
const HUD_ISSUED_TEXT_X			= 0.98;	// right justified 
const HUD_ISSUED_TEXT_Y			= 0.96;

// Position of suicide hint text
const HUD_SUICIDE_TEXT_X		= 0.5;	// center justified 
const HUD_SUICIDE_TEXT_Y1		= 0.85;
const HUD_SUICIDE_TEXT_Y3		= 0.89;
const HUD_SUICIDE_TEXT_Y2		= 0.93;

// Positions for hints and messages for when dead
const HUD_DEAD_TEXT_Y2			= 0.89;
const DEAD_HINT_X				= 0.5;
const DEAD_HINT_Y				= 0.05;
const DEAD_HINT_Y_INC			= 0.035;

// Alpha darkness (255 would be black) for background behind hint text
const BACKTEXT_ALPHA			= 180;
// Part of darker message background that extends below bottom of text
const BOTTOM_FADE_BUFFER			= 0.01;

// Position of suicide hint text
const HUD_ROCKET_TEXT_X			= 0.5;	// center justified 
const HUD_ROCKET_TEXT_Y1		= 0.05;
const HUD_ROCKET_TEXT_Y2		= 0.08;

// Hurt bar values
const HURT_SIDE_X_INC			= 3;
const HURT_SIDE_Y_INC			= 25;
const HURT_TOP_X_INC			= 3;
const HURT_TOP_Y_INC			= 50;
const HURT_BAR_HEALTH_MOD		= 8;
const SKULL_SIZE_RATIO			= 0.2;
const SKULL_ALPHA				= 100;
const DEFAULT_HURT_ALPHA		= 160;

const SNIPER_BAR_MAX_TIME		= 0.6;	// time it takes sniper bars to warm up
const SNIPER_BAR_INCREASE_SIDE	= 20.0;
const SNIPER_BAR_INCREASE_TOP	= 4.0;
const SNIPER_BAR_ALPHA			= 255;
const SNIPER_SIDE_X_INC			= 12;
const SNIPER_SIDE_Y_INC			= 50;
const SNIPER_TOP_X_INC			= 3;
const SNIPER_TOP_Y_INC			= 65;


const SHOW_DEBUG_LINES			= 0;

///////////////////////////////////////////////////////////////////////////////
// PostBeginPlay
///////////////////////////////////////////////////////////////////////////////
simulated function PostBeginPlay()
	{
	Super.PostBeginPlay();

	OurPlayer = P2Player(Owner);

	if (P2GameInfo(Level.Game) != None)
		IssuedTo = P2GameInfo(Level.Game).GetIssuedTo();
	}

///////////////////////////////////////////////////////////////////////////////
// Show or hide various parts of the HUD
///////////////////////////////////////////////////////////////////////////////
simulated function float GetRadarYOffset()
{
	return (HUD_RADAR_Y + HUD_RADAR_Y_OFFSET);
}
simulated function float GetStartRadarY()
{
	return HUD_START_RADAR_Y;
}

///////////////////////////////////////////////////////////////////////////////
// Tick
///////////////////////////////////////////////////////////////////////////////
function Tick(float DeltaTime)
{
	local int i;
	local float HeartSizeBase;
	local float FadeTime;

	if(OurPlayer == None)
		return;

	// Pump the heart
	OurPlayer.HeartTime+=(OurPlayer.HeartBeatSpeed*DeltaTime);

	// Do funky things to the heart time, if necessary
	OurPlayer.ModifyHeartTime(DeltaTime);

	// calc sizes
	if(OurPlayer.HeartTime > pi)
		OurPlayer.HeartTime-=pi;

	HeartSizeBase = (2*OurPlayer.HeartScale);
	HeartPumpSizeX = HeartSizeBase-sin(OurPlayer.HeartTime)*OurPlayer.HeartScale;
	HeartPumpSizeY = (HeartSizeBase-sin(OurPlayer.HeartTime-pi/4)*OurPlayer.HeartScale)/4;

	// Handle fading 'hurt bars' around your view
	for(i=0; i<ArrayCount(OurPlayer.HurtBarTime); i++)
	{
		if(OurPlayer.HurtBarTime[i] > 0)
		{
			OurPlayer.HurtBarTime[i] -= DeltaTime;
			if(OurPlayer.HurtBarTime[i] < 0)
				OurPlayer.HurtBarTime[i]=0;
		}
	}

	// Handle sniper bars around our view
	OurPlayer.CalcSniperBars(DeltaTime, SNIPER_BAR_MAX_TIME);

	// Handle radar
	if(OurPlayer.RadarState != 0)
	{
		if(OurPlayer.ShowRadarBringingUp())
		{
			if(OurPlayer.RadarBackY > (HUD_RADAR_Y + HUD_RADAR_Y_OFFSET))
			{
				OurPlayer.RadarBackY -= (RADAR_Y_SPEED*DeltaTime);
				if(OurPlayer.RadarBackY < (HUD_RADAR_Y + HUD_RADAR_Y_OFFSET))
					OurPlayer.RadarBackY = (HUD_RADAR_Y + HUD_RADAR_Y_OFFSET);
			}
		}
		else if(OurPlayer.ShowRadarDroppingDown())
		{
			if(OurPlayer.RadarBackY < HUD_START_RADAR_Y)
			{
				OurPlayer.RadarBackY += (RADAR_Y_SPEED*DeltaTime);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Change the hud splats that are the backing for each category like health, weapons, inventory
///////////////////////////////////////////////////////////////////////////////
function ChangeHudSplats(array<Material> NewSplats)
{
	local int i;
	for(i=0; i<SectionBackground.Length; i++)
	{
		if(i<NewSplats.Length)
			SectionBackground[i] = NewSplats[i];
	}
}

///////////////////////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////////////////////////
simulated event PostRender(canvas Canvas)
	{
	// If there's an active screen, check to see if it wants the hud
	// If there's a root window running then never show the hud
	if ((OurPlayer.CurrentScreen == None || OurPlayer.CurrentScreen.ShouldDrawHUD()) && !AreAnyRootWindowsRunning())
		{
		if ( !PlayerOwner.bBehindView )
			{
			// Draw your foot in now
			if ( (PawnOwner != None) && (PawnOwner.MyFoot != None) )
				PawnOwner.MyFoot.RenderOverlays(Canvas);
			}

		// Do rest of weapons and hud
		Super.PostRender(Canvas);

		// Give game info a chance to show debug stuff
		if (P2GameInfoSingle(Level.Game) != None)
			P2GameInfoSingle(Level.Game).RenderOverlays(Canvas);
		}
	// Display text saying who this version was issued to
	DrawIssuedToText(Canvas);
	}

///////////////////////////////////////////////////////////////////////////////
// Setup stuff
///////////////////////////////////////////////////////////////////////////////
simulated function HUDSetup(canvas canvas)
{
	Super.HUDSetup(Canvas);

	if (OurPlayer == None)
		PawnOwner = None;
	else if (OurPlayer.ViewTarget == OurPlayer)
		PawnOwner = P2Pawn(OurPlayer.Pawn);
	else if (OurPlayer.ViewTarget.IsA('Pawn') && Pawn(OurPlayer.ViewTarget).Controller != None)
		PawnOwner = P2Pawn(OurPlayer.ViewTarget);
	else if (OurPlayer.Pawn != None)
		PawnOwner = P2Pawn(OurPlayer.Pawn);
	else
		PawnOwner = None;
	
	// Setup defaults
	Canvas.Reset();
	Canvas.SpaceX = 0;
	Canvas.bNoSmooth = True;
	Style = ERenderStyle.STY_Translucent;
	Canvas.Style = Style;
	Canvas.DrawColor = WhiteColor;
	Scale = CanvasWidth / EXPECTED_START_RES_WIDTH;
	AspectRatio = CanvasHeight / CanvasWidth;
	Canvas.Font = MyFont.GetFont(2, false, CanvasWidth );
}

///////////////////////////////////////////////////////////////////////////////
// Master HUD render function.
///////////////////////////////////////////////////////////////////////////////
simulated function DrawHUD( canvas Canvas )
	{
	local Emitter checkem;

	HUDSetup(Canvas);

	// Draw special hud messages regardless of whether hud is hidden
	DrawHudMsgs(Canvas);

	if (!bHideHUD && (Level.LevelAction == LEVACT_None))
		{
		// Draw player death stuff if necessary, return indicates whether we should draw other stuff
		if (DrawPlayerDeath(Canvas))
			{
			// Draw player status, return indicates whether we should draw other stuff
			if (DrawPlayerStatus(Canvas))
				{
				// Draw local messages
				DrawLocalMessages(Canvas);

				// Debug lines
				if(SHOW_DEBUG_LINES == 1)
					{
					ForEach AllActors(class'Emitter', checkem)
						checkem.RenderOverlays(Canvas);
					}
				}
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Draw player death stuff if needed and return a flag indicated whether other
// hud elements should be displayed (true means they should be displayed)
///////////////////////////////////////////////////////////////////////////////
simulated function bool DrawPlayerDeath(canvas Canvas)
	{
	local bool bDisplayOtherStuff;
	
	if (PawnOwner != None)
		{
		// Indicate that other hud stuff should be displayed
		bDisplayOtherStuff = true;
		}
	else
		{
		// Put up messages if the player is dead
		if(OurPlayer.IsDead()
			&& !OurPlayer.bFrozen)
			{
			// Display a message as to how to play again if you're dead. Also
			// give helpful hints here, if you died too quickly
			DrawDeadMessage(canvas);
			}
		}

	return bDisplayOtherStuff;
	}

///////////////////////////////////////////////////////////////////////////////
// Draw all the player status stuff and return a flag indicating whether other
// hud elements should be displayed (true means they should be displayed).
//
// ONLY call this if player has already been determined not to be dead!
///////////////////////////////////////////////////////////////////////////////
simulated function bool DrawPlayerStatus(canvas Canvas, optional bool bCriticalInfoOnly)
	{
	local bool bDisplayOtherStuff;
	local P2GameInfo p2g;
	local int viewstate;

	// If we're getting ready to commit suicide, display this helpful hint
	// and don't show any of the other hud stuff
	if(OurPlayer.IsReadyToCommitSuicide())
		DrawSuicideHints(canvas);
	else
		{
		// Make sure there's a pawn
		if(PawnOwner != None
			&& (OurPlayer.ViewTarget != OurPlayer.Pawn || !OurPlayer.bBehindView))
			{
			p2g = P2GameInfo(Level.Game);

			//if (p2g != None)
			DrawHurtBars(Canvas, Scale);
			DrawSniperBars(Canvas, Scale);

			if (!bCriticalInfoOnly)
				{
				// If we're focussed on the player, provide his full hud
				if(OurPlayer.ViewTarget == OurPlayer.Pawn)
					{
					viewstate = OurPlayer.HudViewState;

					if (P2GameInfoSingle(Level.Game) != None)
						DrawPlayerWantedStatus(Canvas, Scale);
					if(viewstate > 0)
						DrawHealthAndArmor(Canvas, Scale);
					if (viewstate > 1)
						DrawWeapon(Canvas, Scale);
					if (viewstate > 2)
						DrawInventory(Canvas, Scale);
					}

				// Put up helpful hints about viewing a rocket as it travels
				// if we're watching the rocket
				if(OurPlayer.IsInState('PlayerWatchRocket'))
					{
					DrawRocketHints(canvas);
					}
				else// Give the radar chance only if we're not driving a rocket
					{
					// Give the radar a chance to draw, it will decide
					// whether or not to draw the full image
					if(OurPlayer.ShowRadarAny())
						DrawRadar(Canvas, Scale);
					}
				}

			// Indicate that other hud stuff should be displayed
			bDisplayOtherStuff = true;
			}
		}

	return bDisplayOtherStuff;
	}

///////////////////////////////////////////////////////////////////////////////
// Draw text indicating who this version was issued to
///////////////////////////////////////////////////////////////////////////////
simulated function DrawIssuedToText(canvas Canvas)
	{
	if (IssuedTo != "")
		{
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_ISSUED_TEXT_X * CanvasWidth,
			HUD_ISSUED_TEXT_Y * CanvasHeight,
			"Issued to "$IssuedTo,
			0, true, EJ_Right);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// If we're about to commit suicide (we've pressed the suicide key, now the dude
// is just waiting there, ready to kill himself) we should display a hint that
// says to press fire in order to continue.
///////////////////////////////////////////////////////////////////////////////
simulated function DrawSuicideHints(canvas Canvas)
{
	MyFont.DrawTextEx(
		Canvas,
		CanvasWidth,
		HUD_SUICIDE_TEXT_X * CanvasWidth,
		HUD_SUICIDE_TEXT_Y1 * CanvasHeight,
		SuicideHintMajor,
		3, false, EJ_Center);
	if(Level.Game == None
		|| !Level.Game.bIsSinglePlayer)
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_SUICIDE_TEXT_Y3 * CanvasHeight,
			SuicideHintMajorAlt,
			3, false, EJ_Center);
	MyFont.DrawTextEx(
		Canvas,
		CanvasWidth,
		HUD_SUICIDE_TEXT_X * CanvasWidth,
		HUD_SUICIDE_TEXT_Y2 * CanvasHeight,
		SuicideHintMinor,
		2, false, EJ_Center);
}

///////////////////////////////////////////////////////////////////////////////
// You died, so tell you how to restart and any hints if you died
// too quickly
///////////////////////////////////////////////////////////////////////////////
simulated function DrawDeadMessage(canvas Canvas)
{
	local float usey;
	local string str1, str2, str3, str4, str5;
	local int usestrcount, i;
	local array<string> strs;

	if(P2GameInfo(Level.Game) != None
		&& P2GameInfo(Level.Game).bIsDemo)
	{
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_SUICIDE_TEXT_Y1 * CanvasHeight,
			DeadDemoMessage1,
			2, false, EJ_Center);
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_DEAD_TEXT_Y2 * CanvasHeight,
			DeadDemoMessage2,
			2, false, EJ_Center);
	}
	else
	{
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_SUICIDE_TEXT_Y1 * CanvasHeight,
			DeadMessage1,
			2, false, EJ_Center);
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_DEAD_TEXT_Y2 * CanvasHeight,
			DeadMessage2,
			2, false, EJ_Center);
	}

	// Check to give the player a hint about how to not die so quickly next time.
	if(P2GameInfoSingle(Level.Game) != None
		&& OurPlayer.GetDeathHints(strs))
	{
		canvas.SetPos(0, 0);
		canvas.Style = ERenderStyle.STY_Alpha;
		canvas.SetDrawColor(255, 255, 255, BACKTEXT_ALPHA);
		canvas.DrawTile(BlackBox, Canvas.SizeX, Canvas.SizeY*(DEAD_HINT_Y +DEAD_HINT_Y_INC*strs.Length + BOTTOM_FADE_BUFFER), 
						0, 0, BlackBox.USize, BlackBox.VSize);

		usey = DEAD_HINT_Y;
		// draw hints
		for(i=0;i<strs.Length;i++)
		{
			MyFont.DrawTextEx(Canvas, CanvasWidth, DEAD_HINT_X * CanvasWidth, usey * CanvasHeight, 
									strs[i], 1, false, EJ_Center);
			usey+= DEAD_HINT_Y_INC;
		}
		/*
		for(i=0;i<usestrcount;i++)
		{
			MyFont.DrawTextEx(Canvas, CanvasWidth, DEAD_HINT_X * CanvasWidth, usey * CanvasHeight, 
									str2, 1, false, EJ_Center);
			usey+= DEAD_HINT_Y_INC;
		}
		*/
			/*
		canvas.SetPos(0, 0);
		canvas.Style = GetPlayer().MyHud.ERenderStyle.STY_Alpha;
		canvas.SetDrawColor(255, 255, 255, BACKTEXT_ALPHA);
		canvas.DrawTile(BlackBox, Canvas.SizeX, Canvas.SizeY*(ReminderMsgY + ReminderYInc*5 + BOTTOM_FADE_BUFFER), 
						0, 0, BlackBox.USize, BlackBox.VSize);

		usey = ReminderMsgY;
		MyFont.DrawTextEx(Canvas, CanvasWidth, ReminderMsgX * CanvasWidth, usey * CanvasHeight, 
								ReminderMessage1, 1, false, EJ_Center);
		usey+= ReminderYInc;
		MyFont.DrawTextEx(Canvas, CanvasWidth, ReminderMsgX * CanvasWidth, usey * CanvasHeight, 
								ReminderMessage2, 1, false, EJ_Center);
		usey+= ReminderYInc;
		MyFont.DrawTextEx(Canvas, CanvasWidth, ReminderMsgX * CanvasWidth, usey * CanvasHeight, 
								ReminderMessage3, 1, false, EJ_Center);
		usey+= ReminderYInc;
		MyFont.DrawTextEx(Canvas, CanvasWidth, ReminderMsgX * CanvasWidth, usey * CanvasHeight, 
								ReminderMessage4, 1, false, EJ_Center);
		usey+= ReminderYInc;
		MyFont.DrawTextEx(Canvas, CanvasWidth, ReminderMsgX * CanvasWidth, usey * CanvasHeight, 
								ReminderMessage5, 1, false, EJ_Center);
		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth,
			HUD_SUICIDE_TEXT_X * CanvasWidth,
			HUD_SUICIDE_TEXT_Y2 * CanvasHeight,
			SuicideHintMinor,
			2, false, EJ_Center);
			*/
	}
}

///////////////////////////////////////////////////////////////////////////////
// The view is currently focussed on a flying rocket. Tell the player
// how to stop viewing it and return to normal play.
///////////////////////////////////////////////////////////////////////////////
simulated function DrawRocketHints(canvas Canvas)
{
	local string UseHint;

	MyFont.DrawTextEx(
		Canvas,
		CanvasWidth,
		HUD_ROCKET_TEXT_X * CanvasWidth,
		HUD_ROCKET_TEXT_Y1 * CanvasHeight,
		RocketHint1,
		2, true, EJ_Center);
	// Only put up the rocket movement hints when you're watching a rocket
	if(P2Projectile(OurPlayer.ViewTarget) != None)
	{
		if(OurPlayer.RocketHasGas())
			UseHint=RocketHint2;
		else
			UseHint=RocketHint3;

		MyFont.DrawTextEx(
			Canvas,
			CanvasWidth, 
			HUD_ROCKET_TEXT_X * CanvasWidth,
			HUD_ROCKET_TEXT_Y2 * CanvasHeight,
			UseHint,
			2, true, EJ_Center);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Draw cop radio/wanted section
///////////////////////////////////////////////////////////////////////////////
simulated function DrawPlayerWantedStatus(canvas Canvas, float Scale)
{
	local Texture usetex;
	local float radiopct;
	local float BarH, BarW;
	local String str1, str2;
	local P2Weapon myweap;

	if(P2GameInfoSingle(Level.Game).TheGameState != None)
	{
		// Get a number from 0 to 1.0 for how much the cops want the player
		radiopct = P2GameInfoSingle(Level.Game).TheGameState.CopsWantPlayer();

		if(radiopct > 0)
		{
			// Draw background wanted symbol
			Canvas.Style = ERenderStyle.STY_Masked;
			Canvas.DrawColor = DefaultIconColor;
			usetex = Texture(WantedIcon);
			Canvas.SetPos(
				IconPos[WantedIndex].X*CanvasWidth - Scale*(usetex.USize/2),
				IconPos[WantedIndex].Y*CanvasHeight - Scale*(usetex.VSize/2));
			Canvas.DrawIcon(usetex, Scale);

			// Draw the bar showing how much he's still wanted
			Canvas.Style = ERenderStyle.STY_Masked;
			usetex = Texture(WantedBar);
			BarH = usetex.VSize;
			//BarW = usetex.USize;
			BarW = (radiopct*HUD_WANTED_BAR_SCALE_WIDTH*Texture(WantedIcon).USize);
			Canvas.SetPos(
				(IconPos[WantedIndex].X + HUD_WANTED_BAR_OFF_X)*CanvasWidth,
				(IconPos[WantedIndex].Y + HUD_WANTED_BAR_OFF_Y)*CanvasHeight);
			Canvas.DrawTile(usetex,
				Scale*BarW,
				Scale*BarH,
				0, 0, usetex.USize, usetex.VSize);
		}

		myweap = P2Weapon(PawnOwner.Weapon);
		// Hints from cops about dropping your weapon
		if(myweap != None
			&& myweap.GetCopHints(str1, str2))
		{
			if (str1 != "")
				MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[WantedIndex].X+WantedTextPos[0].X) * CanvasWidth, 
										(IconPos[WantedIndex].Y+WantedTextPos[0].Y) * CanvasHeight, str1, 0, true, EJ_Right);
			if (str2 != "")
				MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[WantedIndex].X+WantedTextPos[1].X) * CanvasWidth, 
										(IconPos[WantedIndex].Y+WantedTextPos[1].Y) * CanvasHeight, str2, 0, true, EJ_Right);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Draw health section
///////////////////////////////////////////////////////////////////////////////
simulated function DrawHealthAndArmor(canvas Canvas, float Scale)
	{
	local Texture usetex;
	local float HeartW, HeartH;
	local int UseHealth, UseArmor, HealthColor;

	UseHealth = PawnOwner.GetHealthPercent();
	UseArmor = PawnOwner.GetArmorPercent();

	// Draw background
	Canvas.Style = ERenderStyle.STY_Masked;
	Canvas.DrawColor = DefaultIconColor;
	Canvas.SetPos(
		(IconPos[HealthIndex].X + HUD_BACKGROUND_X_OFFSET)*CanvasWidth, 
		(IconPos[HealthIndex].Y + HUD_BACKGROUND_Y_OFFSET)*CanvasHeight);
	Canvas.DrawIcon(Texture(SectionBackground[HUD_HEALTH]), Scale);

	// Draw the beating heart
	Canvas.Style = ERenderStyle.STY_Masked;
	if(UseHealth > 100)
		HealthColor = 100;
	else
		HealthColor = UseHealth;
	// Make sure the health isn't zero and shouldn't be. If so, make it one.
	if(UseHealth == 0
		&& PawnOwner.Health > 0)
		UseHealth = 1;

	// Make the heart yellow when you're using the catnip, but it still gets redder
	// the more hurt you are.
	if(OurPlayer.CatnipUseTime > 0)
		Canvas.SetDrawColor(155+HealthColor,55+HealthColor*2,0);
	else	// Make it normal-colored, but the more you get hurt, the redder it gets
		Canvas.SetDrawColor(155+HealthColor,55+HealthColor*2,55+HealthColor*2);

	usetex = Texture(HeartIcon);
	HeartW = usetex.USize + (HeartPumpSizeX*usetex.USize - usetex.USize/4);
	HeartH = usetex.VSize + (HeartPumpSizeY*usetex.VSize - usetex.VSize/4);
	Canvas.SetPos(
		IconPos[HealthIndex].X*CanvasWidth - Scale*(HeartW/2),
		IconPos[HealthIndex].Y*CanvasHeight - Scale*(HeartH/2));
	Canvas.DrawTile(usetex,
		Scale*HeartW,
		Scale*HeartH,
		0, 0, usetex.USize, usetex.VSize);
	
	// Draw health in text number form
	MyFont.DrawTextEx(Canvas, CanvasWidth, 
		(IconPos[HealthIndex].X + HUD_NUMBERS_OFFSET_X) * CanvasWidth,
		(IconPos[HealthIndex].Y + HUD_NUMBERS_OFFSET_Y) * CanvasHeight,
		""$UseHealth, 2);

	// Draw armor stuff if it's being used
		if(UseArmor > 0)
			{
			// Draw icon
			Canvas.Style = ERenderStyle.STY_Masked;
			Canvas.DrawColor = DefaultIconColor;
			Canvas.SetPos(
				(IconPos[HealthIndex].X + HUD_ARMOR_ICON_OFFSET_X) * CanvasWidth,
				(IconPos[HealthIndex].Y + HUD_ARMOR_ICON_OFFSET_Y) * CanvasHeight);

			Canvas.DrawIcon(OurPlayer.HudArmorIcon, Scale * HUD_ARMOR_ICON_SCALE);

			// Draw numbers
			MyFont.DrawTextEx(Canvas, CanvasWidth, 
				(IconPos[HealthIndex].X + HUD_ARMOR_NUMBERS_OFFSET_X) * CanvasWidth,
				(IconPos[HealthIndex].Y + HUD_ARMOR_NUMBERS_OFFSET_Y) * CanvasHeight,
				""$UseArmor, 1);
			}
	}

///////////////////////////////////////////////////////////////////////////////
// Draw weapon section
///////////////////////////////////////////////////////////////////////////////
simulated function DrawWeapon(canvas Canvas, float Scale)
	{
	local Texture usetex;
	local P2Weapon myweap;
	local String str1, str2;

	//log(self$" draw weapon, "$PawnOwner.Weapon);
	//if(PawnOwner.Weapon != None)
	//	log(self$" ammo "$P2AmmoInv(PawnOwner.Weapon.AmmoType));
	if(PawnOwner.Weapon != None && P2AmmoInv(PawnOwner.Weapon.AmmoType) != None)
		{
		// Draw background
		Canvas.Style = ERenderStyle.STY_Masked;
		Canvas.DrawColor = DefaultIconColor;
		Canvas.SetPos(
			(IconPos[WeapIndex].X + HUD_BACKGROUND_X_OFFSET)*CanvasWidth,
			(IconPos[WeapIndex].Y + HUD_BACKGROUND_Y_OFFSET)*CanvasHeight);
		Canvas.DrawIcon(Texture(SectionBackground[HUD_AMMO]), Scale);
		
		// Draw ammo icon
		Canvas.Style = ERenderStyle.STY_Masked;
		Canvas.DrawColor = DefaultIconColor;
		usetex = Texture(PawnOwner.Weapon.AmmoType.Texture);
		if(usetex != None)
			{
			Canvas.SetPos(
				IconPos[WeapIndex].X*CanvasWidth - Scale*(usetex.USize/2),
				IconPos[WeapIndex].Y*CanvasHeight - Scale*(usetex.VSize/2));
			Canvas.DrawIcon(usetex, Scale);
			}
		
		// Draw ammo count in text number form
		if(P2AmmoInv(PawnOwner.Weapon.AmmoType).bShowAmmoOnHud)
			{
			MyFont.DrawTextEx(Canvas, CanvasWidth, 
				(IconPos[WeapIndex].X+HUD_NUMBERS_OFFSET_X)*CanvasWidth,
				(IconPos[WeapIndex].Y+HUD_NUMBERS_OFFSET_Y)*CanvasHeight,
				""$PawnOwner.Weapon.AmmoType.AmmoAmount, 2);

			if(P2AmmoInv(PawnOwner.Weapon.AmmoType).bShowMaxAmmoOnHud)
				{
				MyFont.DrawTextEx(Canvas, CanvasWidth, 
					(IconPos[WeapIndex].X+HUD_NUMBERS_MAX_AMMO_OFFSET_X)*CanvasWidth,
					(IconPos[WeapIndex].Y+HUD_NUMBERS_OFFSET_Y)*CanvasHeight,
					"/"$PawnOwner.Weapon.AmmoType.MaxAmmo, 2);
				}
			}

		// Draw text hints
		myweap = P2Weapon(PawnOwner.Weapon);
		if(myweap != None
			&& P2GameInfoSingle(Level.Game) != None
			&& P2GameInfo(Level.Game).AllowInventoryHints())
			{
			// Weapon hints (how to use them)
			if(WeapHintDeathTime > Level.TimeSeconds
				|| WeapHintDeathTime == INFINITE_HINT_TIME)
				{
				if (WeapHint1 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[WeapIndex].X+WeapTextPos[0].X) * CanvasWidth, 
											(IconPos[WeapIndex].Y+WeapTextPos[0].Y) * CanvasHeight, WeapHint1, 0, true, EJ_Right);
				if (WeapHint2 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[WeapIndex].X+WeapTextPos[1].X) * CanvasWidth, 
											(IconPos[WeapIndex].Y+WeapTextPos[1].Y) * CanvasHeight, WeapHint2, 0, true, EJ_Right);
				if (WeapHint3 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[WeapIndex].X+WeapTextPos[2].X) * CanvasWidth, 
											(IconPos[WeapIndex].Y+WeapTextPos[2].Y) * CanvasHeight, WeapHint3, 0, true, EJ_Right);
				}
			}
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Draw inventory section
///////////////////////////////////////////////////////////////////////////////
simulated function DrawInventory(canvas Canvas, float Scale)
{
	local Texture usetex;
	local String str;
	local OwnedInv OwnedOne;
	local P2PowerupInv CurrentItem;
	local String str1, str2;

	// Draw background
	Canvas.Style = ERenderStyle.STY_Masked;
	Canvas.DrawColor = DefaultIconColor;
	Canvas.SetPos(
		(IconPos[InvIndex].X + HUD_BACKGROUND_X_OFFSET)*CanvasWidth, 
		(IconPos[InvIndex].Y + HUD_BACKGROUND_Y_OFFSET)*CanvasHeight);
	Canvas.DrawIcon(Texture(SectionBackground[HUD_INVENTORY]), Scale);
	
	CurrentItem = P2PowerupInv(PawnOwner.SelectedItem);
	if(CurrentItem  != None)
	{
		// Draw inventory icon
		Canvas.Style = ERenderStyle.STY_Masked;
		Canvas.DrawColor = DefaultIconColor;
		usetex = Texture(CurrentItem.Icon);
		Canvas.SetPos(
			IconPos[InvIndex].X*CanvasWidth - Scale*(usetex.USize/2),
			IconPos[InvIndex].Y*CanvasHeight - Scale*(usetex.VSize/2));
		Canvas.DrawIcon(usetex, Scale);

		// Draw inventory count in text form (only if desired and if more than 1)
		if(CurrentItem.bDisplayAmount && CurrentItem.Amount > 1)
		{
			if(!CurrentItem.bDisplayAsFloat)
				str = ""$(int(CurrentItem.Amount));
			else
				str = ""$CurrentItem.Amount;
			MyFont.DrawTextEx(Canvas, CanvasWidth, 
				(IconPos[InvIndex].X+HUD_NUMBERS_OFFSET_X)*CanvasWidth,
				(IconPos[InvIndex].Y+HUD_NUMBERS_OFFSET_Y)*CanvasHeight,
				str, 2);
		}

		if(P2GameInfoSingle(Level.Game) != None
			&& P2GameInfo(Level.Game).AllowInventoryHints())
		{
			// If you're getting mugged, give hints on what to do--override cop hints
			if(OurPlayer.GetMuggerHints(str1, str2))
			{
				if (str1 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[InvIndex].X+InvTextPos[0].X)* CanvasWidth, 
											(IconPos[InvIndex].Y+InvTextPos[0].Y) * CanvasHeight, str1, 0, true, EJ_Right);
				if (str2 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[InvIndex].X+InvTextPos[1].X) * CanvasWidth, 
											(IconPos[InvIndex].Y+InvTextPos[1].Y) * CanvasHeight, str2, 0, true, EJ_Right);
			}
			// Draw text hints if we allow them and if the timer for them
			// is still good (or if we need to draw them forever)
			else if(InvHintDeathTime > Level.TimeSeconds
					|| InvHintDeathTime == INFINITE_HINT_TIME)
				{
				//CurrentItem.GetHints(PawnOwner, InvHint1, str2, str3);
				if (InvHint1 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[InvIndex].X+InvTextPos[0].X)* CanvasWidth, 
										(IconPos[InvIndex].Y+InvTextPos[0].Y) * CanvasHeight, InvHint1, 0, true, EJ_Right);
				if (InvHint2 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[InvIndex].X+InvTextPos[1].X) * CanvasWidth, 
										(IconPos[InvIndex].Y+InvTextPos[1].Y) * CanvasHeight, InvHint2, 0, true, EJ_Right);
				if (InvHint3 != "")
					MyFont.DrawTextEx(Canvas, CanvasWidth, (IconPos[InvIndex].X+InvTextPos[2].X) * CanvasWidth, 
										(IconPos[InvIndex].Y+InvTextPos[2].Y) * CanvasHeight, InvHint3, 0, true, EJ_Right);
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function CalcRadarDists(bool bIsMP,
								  out vector dir,
								  out float dist)
{
	dir.z=0;
	dist = VSize(dir);
	if(bIsMP)
		dist = dist*MP_RADAR_SCALE;
	else
		dist = dist*OurPlayer.RadarScale;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function RadarFindFishLoc(float dist,
									   float Scale,
									   float pheight,
									   bool bIsMP,
									    out vector dir,
									    out float fishx, out float fishy,
										out float iconsize)
{
	local float ang;

	// Scale heights only if your in MP games
	if(bIsMP)
	{
		if(pheight > 0)
		{
			if(pheight > OurPlayer.RadarMaxZ)
				iconsize = OurPlayer.RadarMaxZ;
			else
				iconsize = pheight;
		}
		else
		{
			if(pheight < -OurPlayer.RadarMaxZ)
				iconsize = -OurPlayer.RadarMaxZ;
			else
				iconsize = pheight;
		}
		iconsize/=2;
		iconsize = (Scale + Scale*(iconsize/OurPlayer.RadarMaxZ));
	}
	else // SP does no scaling like this
		iconsize = Scale;

	dir = Normal(dir);
	if(dir.y != 0)
		ang = atan(dir.x/dir.y);
	if(dir.y < 0)
		ang+=Pi;
	//log(PawnOwner$" dir "$dir$" angle "$ang$" acos "$acos(1.0/dir.x));
	ang = (PawnOwner.Rotation.Yaw*0.0000959) + ang;
	if(ang > 2*Pi)
		ang-=2*Pi;

	fishx = dist*Scale*(cos(ang)) - iconsize*(RadarPlayer.USize/2);
	fishy = -(AspectRatio*dist*Scale*(sin(ang))) - iconsize*(RadarPlayer.VSize/2);
}


///////////////////////////////////////////////////////////////////////////////
// Draw flags for ctf game
///////////////////////////////////////////////////////////////////////////////
simulated function DrawRadarFlags(canvas Canvas, float radarx, float radary)
{
//	STUB
}

///////////////////////////////////////////////////////////////////////////////
// Draw bags for gb game
///////////////////////////////////////////////////////////////////////////////
simulated function DrawRadarBags(canvas Canvas, float radarx, float radary)
{
//	STUB
}

///////////////////////////////////////////////////////////////////////////////
// Draw radar showing other people around you
///////////////////////////////////////////////////////////////////////////////
simulated function DrawRadar(canvas Canvas, float Scale)
{
	local float UseSize, dist, radarx, radary, targetx, targety, RadarTimer;
	local float pheight, iconsize, glowalpha, sy, fishx, fishy;
	local P2Pawn radarp;
	local vector radarf;
	local int i;
	local bool bShowMouseHint, bIsMP;
	local vector dir;
	local GameReplicationInfo gri;
	//local Texture usetex;

	if(OurPlayer.RadarTargetStats())
	{
		// Dim the background
		Canvas.SetPos(0, 0);
		Canvas.Style = ERenderStyle.STY_Alpha;
		Canvas.SetDrawColor(255, 255, 255, BACKGROUND_TARGET_ALPHA);
		Canvas.DrawTile(BlackBox, Canvas.SizeX, Canvas.SizeY, 0, 0, BlackBox.USize, BlackBox.VSize);
		// Draw stats
		sy = RADAR_TARGET_STATS;
		if(OurPlayer.RadarTargetKills > 0)
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarStatsHint1, 2, false, EJ_Center);
		else
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarStatsHint0, 2, false, EJ_Center);
		sy+=0.05;
		MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarStatsHint2$OurPlayer.RadarTargetKills, 2, false, EJ_Center);
		if(TargetPrizes.Length > 0)
		{
			sy=0.7;
			// List prizes
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarStatsHint3, 2, false, EJ_Center);
		}
		// Draw hint to continue on
		if(OurPlayer.RadarTargetStatsGetInput())
		{
			sy=0.9;
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarStatsHint4, 1, false, EJ_Center);
		}
		// draw targetter
		Canvas.DrawColor = RedColor;
		targetx = 0.5; targety = 0.6;
		Canvas.SetPos(targetx*CanvasWidth - Scale*(RadarPlayer.USize/2),
						targety*CanvasHeight - Scale*(RadarPlayer.VSize/2));
		Canvas.Style = ERenderStyle.STY_Masked;
		Canvas.DrawIcon(RadarTarget[OurPlayer.GetRadarTargetFrame()], Scale);
		// draw prizes
		targetx = 0.2; targety = 0.8;
		Canvas.DrawColor = WhiteColor;
		for(i=0; i<TargetPrizes.Length; i++)
		{
			Canvas.SetPos(targetx*CanvasWidth - Scale*(RadarPlayer.USize/2),
							targety*CanvasHeight - Scale*(RadarPlayer.VSize/2));
			Canvas.DrawIcon(Texture(TargetPrizes[i]), Scale);
			targetx+=0.1;
		}
	}
	else if(OurPlayer.RadarTargetKilling())
	{
		sy = RADAR_TARGET_KILL_HINTS;
		switch(OurPlayer.RadarTargetKillHint())
		{
			case 0:
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarKillHint0, 2, false, EJ_Center);
				bShowMouseHint=true;
				break;
			case 1:
			case 2:	// hold on to this hint a little.
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarKillHint1, 2, false, EJ_Center);
				bShowMouseHint=true;
				break;
			case 3:
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarKillHint2, 2, false, EJ_Center);
				bShowMouseHint=true;
				break;
			case 4:
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarDeadHint, 2, false, EJ_Center);
				break;
		}
		sy = RADAR_TARGET_MOUSE_HINT;
		MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarMouseHint, 1, false, EJ_Center);
		// draw targetter as person dies
		Canvas.DrawColor = RedColor;
		Canvas.SetPos(OurPlayer.RadarTargetX*CanvasWidth - Scale*(RadarPlayer.USize/2),
						OurPlayer.RadarTargetY*CanvasHeight - Scale*(RadarPlayer.VSize/2));
		Canvas.Style = ERenderStyle.STY_Masked;
		Canvas.DrawIcon(RadarTarget[OurPlayer.GetRadarTargetFrame()], Scale);
	}
	else
	{
		// When in targetting mode
		if(OurPlayer.RadarTargetReady())
		{
			// Dim the background
			Canvas.SetPos(0, 0);
			Canvas.Style = ERenderStyle.STY_Alpha;
			Canvas.SetDrawColor(255, 255, 255, BACKGROUND_TARGET_ALPHA);
			Canvas.DrawTile(BlackBox, Canvas.SizeX, Canvas.SizeY, 0, 0, BlackBox.USize, BlackBox.VSize);
			// Put up some hints
			sy = RADAR_TARGET_HINTS;
			// Title
			if(OurPlayer.RadarTargetNotStartedYet())
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint0, 2, false, EJ_Center);
			else
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint6, 2, false, EJ_Center);
			sy+=0.05;
			// If we're still waiting, tell them how to start
			if(OurPlayer.RadarTargetWaiting())
				MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint1, 2, false, EJ_Center);
			sy+=0.1;
			// Timer
			RadarTimer = OurPlayer.GetRadarTargetTimer();
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint2$RadarTimer, 2, false, EJ_Center);
			sy+=0.05;
			// Gameplay hints
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint3, 1, false, EJ_Center);
			sy+=0.05;
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint4, 1, false, EJ_Center);
			sy+=0.05;
			MyFont.DrawTextEx(Canvas, CanvasWidth, 0.5 * CanvasWidth, sy * CanvasHeight, RadarHint5, 1, false, EJ_Center);
			targetx = (OurPlayer.RadarTargetX)*CanvasWidth;
			targety = (OurPlayer.RadarTargetY)*CanvasHeight;
		}

		Canvas.Style = ERenderStyle.STY_Normal;
		Canvas.DrawColor = DefaultIconColor;
		UseSize = OurPlayer.RadarSize*Scale;
		// Draw main background image for radar (this part slides into place)
		Canvas.SetPos(HUD_RADAR_X*CanvasWidth - (UseSize*RADAR_IMAGE_SCALE/2),
						OurPlayer.RadarBackY*CanvasHeight - (UseSize*RADAR_IMAGE_SCALE/2));
		Canvas.DrawTile(RadarBackground, 
						UseSize*RADAR_IMAGE_SCALE,
						UseSize*RADAR_IMAGE_SCALE,
						0, 0, RadarBackground.USize, RadarBackground.VSize);

		if(Level.Game == None
			|| !Level.Game.bIsSinglePlayer)
			bIsMP=true;

		// See if you should show anything more than just the background
		if(!OurPlayer.ShowRadarBackOnly())
		{
			// Only draw the icons if the radar is completely On.
			if(OurPlayer.ShowRadarFull())
			{		
				radarx=HUD_RADAR_X*CanvasWidth;// - UseSize/2 - Scale*(RadarPlayer.USize/8);
				radary=HUD_RADAR_Y*CanvasHeight;// - UseSize/2 - Scale*(RadarPlayer.VSize/8);
				
				// Draw all the pawns within radar
				for(i = 0; i<OurPlayer.RadarPawns.Length; i++)
				{
					// convert 3d world coords to around the player in the radar coords
					radarp = OurPlayer.RadarPawns[i];
					if(radarp != None)
					{
						dir = radarp.Location - PawnOwner.Location;
						pheight = dir.z;

						// If you're within the immediate height of the dude, be drawn
						// (or if it's MP, always show others)
						if(abs(pheight) < OurPlayer.RadarMaxZ
							|| OurPlayer.RadarInDoors==0
							|| bIsMP)
						{
							CalcRadarDists(bIsMP, dir, dist);

							// If you're within the appropriate radius from the player, be drawn
							if((bIsMP 
									&& dist < MP_RADAR_RADIUS)
								|| dist < OurPlayer.RadarShowRadius)
							{

								RadarFindFishLoc(dist, Scale, pheight, bIsMP, dir, fishx, fishy, iconsize);
								Canvas.SetPos(radarx + fishx, radary + fishy);

								// Special colors based on fish attitude
								if(PersonController(radarp.Controller) != None)
								{
									// Violent attackers (or distracted attackers) show up red
									if((PersonController(radarp.Controller).Attacker == PawnOwner
										|| PersonController(radarp.Controller).PlayerAttackedMe == PawnOwner)
										&& radarp.bHasViolentWeapon)
										Canvas.DrawColor = RedColor;
									// Everyone else--scared of dude, or just interested, show up yellow
									else if(PersonController(radarp.Controller).InterestPawn == PawnOwner)
										Canvas.DrawColor = YellowColor;
									// Neutrals show up white (or people interested in other people)
									else 
										Canvas.DrawColor = WhiteColor;
								}
								else // default is a white fish
									Canvas.DrawColor = WhiteColor;

								// Draw the fish
								Canvas.DrawIcon(RadarNPC, iconsize);

								Canvas.Style = ERenderStyle.STY_Alpha;
								Canvas.DrawColor = WhiteColor;
								// Draw in a cop hat, if the player has that plug-in and this is
								// an Authority figure.
								if(radarp.bAuthorityFigure)
								{
									if(OurPlayer.bRadarShowCops)
									{
										Canvas.SetPos(radarx + fishx + COP_OFFSET_X*CanvasWidth, 
													radary + fishy + COP_OFFSET_Y*CanvasHeight);
										Canvas.DrawIcon(RadarCopHat, iconsize);
									}
								}
								// Draw a little gun over the fish, if the player has the
								// plug-in to detect hidden weapons
								// Don't draw cops with guns also
								else if(OurPlayer.bRadarShowGuns
									&& radarp.bHasViolentWeapon)
								{
									Canvas.SetPos(radarx + fishx + GUN_OFFSET_X*CanvasWidth, 
												radary + fishy + GUN_OFFSET_Y*CanvasHeight);
									Canvas.DrawIcon(RadarGun, iconsize);
								}
								Canvas.Style = ERenderStyle.STY_Normal;

								if(OurPlayer.RadarTargetIsOn()
									&& radarp.Health > 0)
								{
									// Targetting is going, so kill people, when it hits them
									if(abs(targetx - fishx) < (TARGET_KILL_RADIUS/AspectRatio)
										&& abs(targety - fishy) < TARGET_KILL_RADIUS)
									{
										OurPlayer.TargetKillsPawn(radarp);
										// If you're killing someone, don't let this go any further
										return;
									}
								}
							}
						}
					}
				}

				DrawRadarFlags(Canvas, radarx, radary);

				DrawRadarBags(Canvas, radarx, radary);

				// Draw in targetter
				if(OurPlayer.RadarTargetReady())
				{
					Canvas.DrawColor = RedColor;
					targetx = (OurPlayer.RadarTargetX) + HUD_RADAR_X;
					targety = (OurPlayer.RadarTargetY) + HUD_RADAR_Y;
					Canvas.SetPos(targetx*CanvasWidth - Scale*(RadarPlayer.USize/2),
									targety*CanvasHeight - Scale*(RadarPlayer.VSize/2));

					Canvas.Style = ERenderStyle.STY_Masked;

					Canvas.DrawIcon(RadarTarget[OurPlayer.GetRadarTargetFrame()], Scale);
				}
				else
				{
					// Reset color
					Canvas.DrawColor = WhiteColor;
					// Draw center (player boat image)
					Canvas.SetPos(HUD_RADAR_X*CanvasWidth - Scale*(RadarPlayer.USize/2),// - UseSize/2 - (Texture(HeartIcon).USize*(Scale/8)),
									HUD_RADAR_Y*CanvasHeight - Scale*(RadarPlayer.VSize/2));// - UseSize/2 - (Texture(HeartIcon).VSize*(Scale/8)));

					Canvas.Style = ERenderStyle.STY_Normal;//ERenderStyle.STY_Translucent;

					Canvas.DrawIcon(RadarPlayer, Scale);
				}
			} // show icons

			Canvas.Style = ERenderStyle.STY_Translucent;
			// Make the glow flicker if it's not fully on yet.
			if(OurPlayer.ShowRadarFlicker())
				glowalpha = RADAR_WARMUP_BASE - Rand(RADAR_WARMUP_RAND);
			else
				glowalpha = RADAR_NORMAL_BASE - Rand(RADAR_NORMAL_RAND) + OurPlayer.PulseGlow;
			Canvas.SetDrawColor(glowalpha, glowalpha, glowalpha);
			Canvas.SetPos(HUD_RADAR_X*CanvasWidth - (UseSize*RADAR_IMAGE_SCALE/2),
							(HUD_RADAR_Y)*CanvasHeight - (UseSize*RADAR_IMAGE_SCALE/2));
			Canvas.DrawTile(RadarGlow, 
							UseSize*RADAR_IMAGE_SCALE,
							UseSize*RADAR_IMAGE_SCALE,
							0, 0, RadarGlow.USize, RadarGlow.VSize);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Draw the hurt bars around the edges to show direction of the attacker.
///////////////////////////////////////////////////////////////////////////////
simulated function DrawHurtBars(canvas Canvas, float Scale)
{
	local int i;
	local float HealthRatio;
	local float xpos, ypos, useh, usew, fadeamount;
	local Texture usetex;

	HealthRatio = (1.0 - PawnOwner.Health/PawnOwner.HealthMax);
	if(HealthRatio < 0.0)
		HealthRatio = 0.0;
	else
		HealthRatio = HURT_BAR_HEALTH_MOD*HealthRatio;
	// Handle fading 'hurt bars' around your view
	for(i=0; i<ArrayCount(OurPlayer.HurtBarTime); i++)
	{
		if(OurPlayer.HurtBarTime[i] > 0)
		{
			Canvas.Style = ERenderStyle.STY_Translucent;
			
			fadeamount = (OurPlayer.HurtBarTime[i])*OurPlayer.HurtBarAlpha;

			Canvas.SetDrawColor(fadeamount,0,0); // shows bars in red
			switch(i)
			{
				case 0:	// top
					usetex = Texture(TopHurtBar);

					usew = usetex.USize*HURT_TOP_Y_INC;
					useh = usetex.VSize*(HURT_TOP_X_INC + HealthRatio);
					xpos = 0.5;
					ypos = 0.0;
				break;
				case 1:	// right
					usetex = Texture(SideHurtBar);

					usew = usetex.USize*(HURT_SIDE_X_INC + HealthRatio);
					useh = usetex.VSize*HURT_SIDE_Y_INC;
					xpos = 1.0;
					ypos = 0.5;
				break;
				case 2:	// down
					usetex = Texture(TopHurtBar);

					usew = usetex.USize*HURT_TOP_Y_INC;
					useh = usetex.VSize*(HURT_TOP_X_INC + HealthRatio);
					xpos = 0.5;
					ypos = 1.0;
				break;
				case 3:	// left
					usetex = Texture(SideHurtBar);

					usew = usetex.USize*(HURT_SIDE_X_INC + HealthRatio);
					useh = usetex.VSize*HURT_SIDE_Y_INC;
					xpos = 0.0;
					ypos = 0.5;
				break;
				case 4:	// SKULL
					fadeamount = (OurPlayer.HurtBarTime[i])*SKULL_ALPHA;
					// less alphaed, but red like hurt bars
					Canvas.SetDrawColor(fadeamount/2,0,0);
						//fadeamount/2,fadeamount/2);
					usetex = Texture(SkullHurtBar);

					usew = usetex.USize*(HealthRatio)*SKULL_SIZE_RATIO;
					useh = usetex.VSize*(HealthRatio)*SKULL_SIZE_RATIO;
					xpos = 0.5;
					ypos = 0.5;
				break;
			}
			Canvas.SetPos(
				xpos*CanvasWidth - Scale*(usew/2),
				ypos*CanvasHeight - Scale*(useh/2));
			Canvas.DrawTile(usetex,
				Scale*usew,
				Scale*useh,
				0, 0, usetex.USize, usetex.VSize);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Draw the sniper bars around the edges to show direction of the guy
// who has you in his sights (with his sniper rifle)
///////////////////////////////////////////////////////////////////////////////
simulated function DrawSniperBars(canvas Canvas, float Scale)
{
	local int i;
	local float xpos, ypos, useh, usew, fadeamount;
	local Texture usetex;

	// Figure out the direction of the sniper aiming at me
	if(!OurPlayer.bSniperBarsClear
		&& PawnOwner != None)
	{
		// Handle fading 'sniper bars' around your view
		for(i=0; i<ArrayCount(OurPlayer.SniperBarTime); i++)
		{
			if(OurPlayer.SniperBarTime[i] > 0)
			{
				Canvas.Style = ERenderStyle.STY_Alpha;
				
				fadeamount = ((OurPlayer.SniperBarTime[i]/SNIPER_BAR_MAX_TIME)*SNIPER_BAR_ALPHA);
				if(int(fadeamount) > 0)
				{
					// Alpha the bars in, in order to draw them in black
					Canvas.SetDrawColor(255, 255, 255, fadeamount);
					switch(i)
					{
						case 0:	// top
							usetex = Texture(TopSniperBar);

							usew = usetex.USize*SNIPER_TOP_Y_INC;
							useh = usetex.VSize*(SNIPER_TOP_X_INC + SNIPER_BAR_INCREASE_TOP);
							xpos = 0.5;
							ypos = 0.0;
						break;
						case 1:	// right
							usetex = Texture(SideSniperBar);

							usew = usetex.USize*(SNIPER_SIDE_X_INC + SNIPER_BAR_INCREASE_SIDE);
							useh = usetex.VSize*SNIPER_SIDE_Y_INC;
							xpos = 1.0;
							ypos = 0.5;
						break;
						case 2:	// down
							usetex = Texture(TopSniperBar);

							usew = usetex.USize*SNIPER_TOP_Y_INC;
							useh = usetex.VSize*(SNIPER_TOP_X_INC + SNIPER_BAR_INCREASE_TOP);
							xpos = 0.5;
							ypos = 1.0;
						break;
						case 3:	// left
							usetex = Texture(SideSniperBar);

							usew = usetex.USize*(SNIPER_SIDE_X_INC + SNIPER_BAR_INCREASE_SIDE);
							useh = usetex.VSize*SNIPER_SIDE_Y_INC;
							xpos = 0.0;
							ypos = 0.5;
						break;
					}
					Canvas.SetPos(
						xpos*CanvasWidth - Scale*(usew/2),
						ypos*CanvasHeight - Scale*(useh/2));
					Canvas.DrawTile(usetex,
						Scale*usew,
						Scale*useh,
						0, 0, usetex.USize, usetex.VSize);
				}
			}
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Draw the Level Action
// Called by base class.  Return value says whether or not to hide player
// progress messages, which are displayed in the same area of the screen.
///////////////////////////////////////////////////////////////////////////////
function bool DrawLevelAction( canvas C )
	{
	local string BigMessage;
	local float y;

	y = 0.5;
	BigMessage = "";

	if (Level.LevelAction == LEVACT_None )
		{
		// Check if we're paused (note the use of another magical epic number here)
		if ((Level.Pauser != None) && (Level.TimeSeconds > Level.PauseDelay + 0.2))
			{
			// Make sure no screens or root windows are running (somewhat time-consuming
			// but it's okay because if we get here we know the game is already paused)
			if ((OurPlayer.CurrentScreen == None) && !AreAnyRootWindowsRunning())
				{
				// Display paused message
				BigMessage = PausedMessage;
				}
			}
		}
	else if (Level.LevelAction == LEVACT_Loading)
		{
/*	This message was flashing, apparently because it was only drawn on one
	backbuffer.  We'll have to figure out a better way to get this to show
	up.  It wasn't working when done in P2Screen, either, apparently because
	font may not have been valid at that point.
	if (P2GameInfoSingle(Level.Game) != None &&
			P2GameInfoSingle(Level.Game).bQuitting)
			BigMessage = QuittingMessage;
		else
			BigMessage = LoadingMessage;
		y = LoadingMessageY;
*/
		}
// Until we're sure these messages won't flicker
//	else if (Level.LevelAction == LEVACT_Quitting)
//		BigMessage = QuittingMessage;
	else if (Level.LevelAction == LEVACT_Saving)
		BigMessage = SavingMessage;
	else if (Level.LevelAction == LEVACT_EasySaving)
		BigMessage = EasySavingMessage;
	else if (Level.LevelAction == LEVACT_AutoSaving)
		BigMessage = AutoSavingMessage;
	else if (Level.LevelAction == LEVACT_ForcedSaving)
		BigMessage = ForcedSavingMessage;
// Until we're sure these messages won't flicker
//	else if (Level.LevelAction == LEVACT_Restarting)
//		BigMessage = RestartingMessage;
	else if (Level.LevelAction == LEVACT_Precaching)
		BigMessage = PrecachingMessage;
	
	if (BigMessage != "")
		{
		MyFont.DrawTextEx(C, CanvasWidth, CanvasWidth/2, CanvasHeight * y, BigMessage, 3, false, EJ_Center);
		return true;
		}
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Check if root window is running
///////////////////////////////////////////////////////////////////////////////
function bool AreAnyRootWindowsRunning()
	{
	local P2RootWindow root;

	root = P2RootWindow(OurPlayer.Player.InteractionMaster.BaseMenu);
	if (root != None)
		return root.IsMenuShowing();
	return false;
	}

///////////////////////////////////////////////////////////////////////////////
// Add hud messages
///////////////////////////////////////////////////////////////////////////////
function AddHudMsgs(array<S_HudMsg> msgs, float Lifetime)
	{
	local int i;

	DeleteHudMsgs();

	// Add new messages
	for (i = 0; i < msgs.Length; i++)
		HudMsgs[i] = msgs[i];

	HudMsgsEndTime = Level.TimeSeconds + Lifetime;
	}

///////////////////////////////////////////////////////////////////////////////
// Delete hud messages
///////////////////////////////////////////////////////////////////////////////
function DeleteHudMsgs()
	{
	if (HudMsgs.Length > 0)
		HudMsgs.remove(0, HudMsgs.Length);
	}

///////////////////////////////////////////////////////////////////////////////
// Draw hud messages
///////////////////////////////////////////////////////////////////////////////
function DrawHudMsgs(Canvas Canvas)
	{
	local int i;

	if (HudMsgs.Length > 0)
		{
		if (HudMsgsEndTime > Level.TimeSeconds)
			{
			for (i = 0; i < HudMsgs.Length; i++)
				{
				if (HudMsgs[i].Msg != "")
					{
					MyFont.DrawTextEx(
						Canvas,
						CanvasWidth, 
						HudMsgs[i].X * CanvasWidth,
						HudMsgs[i].Y * CanvasHeight,
						HudMsgs[i].Msg,
						HudMsgs[i].FontSize,
						HudMsgs[i].bPlain,
						HudMsgs[i].JustifyFromX);
					}
				}
			}
		else
			DeleteHudMsgs();
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Each time a new inventory item  comes up, the hints get updatted.
///////////////////////////////////////////////////////////////////////////////
function SetInvHints(string str1, string str2, string str3, byte InfiniteTime)
{
	InvHint1 = str1;
	InvHint2 = str2;
	InvHint3 = str3;
	if(InfiniteTime == 0)
		InvHintDeathTime = Level.TimeSeconds + INV_HINT_LIFETIME;
	else
		InvHintDeathTime = INFINITE_HINT_TIME;
}

///////////////////////////////////////////////////////////////////////////////
// Each time a new weapon item  comes up, the hints get updatted.
///////////////////////////////////////////////////////////////////////////////
function SetWeapHints(string str1, string str2, string str3, byte InfiniteTime)
{
	WeapHint1 = str1;
	WeapHint2 = str2;
	WeapHint3 = str3;
	if(InfiniteTime == 0)
		WeapHintDeathTime = Level.TimeSeconds + WEAP_HINT_LIFETIME;
	else
		WeapHintDeathTime = INFINITE_HINT_TIME;
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////

defaultproperties
	{
	WhiteColor=(R=255,G=255,B=255,A=255)
	RedColor=(R=255,G=0,B=0,A=255)
	YellowColor=(R=255,G=255,B=0,A=255)
	BlueColor=(R=0,G=0,B=255,A=255)
	DefaultIconColor=(R=220,G=220,B=220,A=255)
	SectionBackground[0]=Texture'nathans.Inventory.bloodsplat-1'
	SectionBackground[1]=Texture'nathans.Inventory.bloodsplat-2'
	SectionBackground[2]=Texture'nathans.Inventory.bloodsplat-3'
	HeartIcon=Texture'nathans.Inventory.HeartInv'
	WantedIcon=Texture'HUDPack.Icons.icon_inv_badge'
	WantedBar=Texture'HUDPack.Icons.icon_inv_badge_slider'
	RadarBackground=Texture'P2Misc.fish_radar.Bass_Sniffer'
	RadarPlayer=Texture'P2Misc.fish_radar.boat'
	RadarNPC=Texture'P2Misc.fish_radar.fish'
	RadarGlow=Texture'P2Misc.fish_radar.Bass_Sniffer_Lens'
	RadarTarget[0]=Texture'nathans.Chompy.Chompy1'
	RadarTarget[1]=Texture'nathans.Chompy.Chompy2'
	RadarCopHat=Texture'nathans.RadarPlugIns.cophat'
	RadarGun=Texture'nathans.RadarPlugIns.fishgun'
	RadarHint0="Hey kids! It's Chompy, the Voodoo Fish!"
	RadarHint1="Press the movement keys to start!"
	RadarHint2="TimeLeft: "
	RadarHint3="Steer Chompy towards other fish to gobble them up!"
	RadarHint4="Don't worry about getting hurt..."
	RadarHint5="Chompy's mystical energy will protect you!"
	RadarHint6="Go Chompy, Go!"
	RadarKillHint0="Okay kids... here comes Chompy!"
	RadarKillHint1="Oooh! That's gotta hurt..."
	RadarKillHint2="Just let his dark Voodoo powers do the work..."
	RadarStatsHint0="Chompy's hungry! Eat more next time."
	RadarStatsHint1="Way to go Chompy!"
	RadarStatsHint2="Fish eaten: "
	RadarStatsHint3="Prizes granted:"
	RadarStatsHint4="Press the movement keys to return to normal gameplay."
	RadarDeadHint="Way to go Chompy!"
	RadarMouseHint="Move the Mouse to watch the show."
	RocketHint1="Press Jump (Spacebar) to return to the Dude."
	RocketHint2="Press Movement keys (W,A,S,D) to control the rocket."
	RocketHint3="Your rocket is out of gas! Enjoy the ride down."
	TopHurtBar=Texture'MPfx.softwhitedotbig'
	SideHurtBar=Texture'MPfx.softwhitedotbig'
	SkullHurtBar=Texture'Hudpack.icons.YourDead'
	SuicideHintMajor="Press Fire to end it all."
	SuicideHintMinor="Use Mouse Wheel to zoom in and out."
	SuicideHintMajorAlt="Press Secondary Fire to wuss out."
	DeadMessage1="Press the 'Restart' key (Spacebar)"
	DeadMessage2="to load your most recent game."
	DeadDemoMessage1="Press the Spacebar key"
	DeadDemoMessage2="return to the Main Menu."
	BlackBox=Texture'nathans.Inventory.BlackBox64'
	LoadingMessageY=0.81
	
	WeapIndex=0
	InvIndex=1
	HealthIndex=2
	WantedIndex=3
	
	IconPos[0]=(X=0.935,Y=0.12)
	IconPos[1]=(X=0.935,Y=0.27)
	IconPos[2]=(X=0.935,Y=0.42)
	IconPos[3]=(X=0.935,Y=0.57)
	
	InvTextPos[0]=(X=-0.055,Y=-0.035)
	InvTextPos[1]=(X=-0.055,Y=-0.010)
	InvTextPos[2]=(X=-0.055,Y=+0.015)

	WeapTextPos[0]=(X=-0.055,Y=+0.015)
	WeapTextPos[1]=(X=-0.055,Y=+0.040)
	WeapTextPos[2]=(X=-0.055,Y=+0.065)

	WantedTextPos[0]=(X=-0.055,Y=-0.03)
	WantedTextPos[1]=(X=-0.055,Y=-0.0)
	
	QuittingMessage="Quitting Game"
	EasySavingMessage="Easy Saving"
	AutoSavingMessage="Auto Saving"
	RestartingMessage = "Restarting"
	ForcedSavingMessage="Saving"

	// Console messages -- top left corner
	CategoryFormats(0)=(XP=0.02,YP=0.02,HAlign=THA_Left,VAlign=TVA_Top,Stack=TS_Down,FontSize=1,bPlainFont=false)
	// Default messages -- not expected in singleplayer but define just in case
	CategoryFormats(1)=(XP=0.02,YP=0.90,HAlign=THA_Left,VAlign=TVA_Bottom,Stack=TS_None,FontSize=1,bPlainFont=false);
	// Pickup messages -- bottom left corner
	CategoryFormats(2)=(XP=0.02,YP=0.95,HAlign=THA_Left,VAlign=TVA_Bottom,Stack=TS_None,FontSize=0,bPlainFont=false);
	// Critical messages -- not expected in singleplayer but define just in case
	CategoryFormats(3)=(XP=0.02,YP=0.85,HAlign=THA_Left,VAlign=TVA_Bottom,Stack=TS_None,FontSize=0,bPlainFont=false);
	// Game messages -- not expected in singleplayer but define just in case
	CategoryFormats(4)=(XP=0.02,YP=0.80,HAlign=THA_Left,VAlign=TVA_Bottom,Stack=TS_None,FontSize=0,bPlainFont=false);

	TopSniperBar=Texture'MPfx.softblackdot'
	SideSniperBar=Texture'MPfx.softblackdot'
	}
