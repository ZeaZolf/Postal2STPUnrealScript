///////////////////////////////////////////////////////////////////////////////
// MenuVideo.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The video menu.
//
///////////////////////////////////////////////////////////////////////////////
class MenuVideo extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string VideoTitleText;

struct DisplayMode
	{
	var int	Width;
	var int Height;
	};

var UWindowComboControl ResCombo;
var localized string ResText;
var localized string ResHelp;
var DisplayMode DisplayModes[8];

var localized string LowResWarningTitle;
var localized string LowResWarningText;

var UWindowMessageBox ConfirmRes;
var localized string ConfirmResTitle;
var localized string ConfirmResText;

var UWindowComboControl ColorCombo;
var localized string ColorText;
var localized string ColorHelp;
var localized string ColorSettings[2];
const ColorPath = "ini:Engine.Engine.RenderDevice Use16bit";

var localized string BadDepthTitle;
var localized string BadDepthText;

var localized string DesktopDepthTitle;
var localized string DesktopDepthText;

var localized string NoMirrorsText;

var UWindowMessageBox ConfirmDepth;
var UWindowMessageBox Confirm16bit;
var localized string ConfirmDepthTitle;
var localized string ConfirmDepthText;

var UWindowMessageBox ConfirmRestart16bit;	// FIXME -- eventually won't need this
var localized string Restart16bitTitle;
var localized string Restart16bitText;

const BrightnessPath	= "ini:Engine.Engine.ViewportManager Brightness";
var UWindowHSliderControl BrightnessSlider;
var localized string BrightnessText;
var localized string BrightnessHelp;

const ContrastPath		= "ini:Engine.Engine.ViewportManager Contrast";
var UWindowHSliderControl ContrastSlider;
var localized string ContrastText;
var localized string ContrastHelp;

const GammaPath			= "ini:Engine.Engine.ViewportManager Gamma";
var UWindowHSliderControl GammaSlider;
var localized string GammaText;
var localized string GammaHelp;

//const StartupFullScreenPath = "ini:Engine.Engine.ViewportManager StartupFullscreen";
var UWindowCheckbox FullScreenCheckbox;
var localized string FullScreenText;
var localized string FullScreenHelp;

var localized string FullScreenOnlyTitle;
var localized string FullScreenOnlyText;

var bool bUpdate;
var bool bAsk;

var string SafeRes;
var string SafeDepth;
var string NewDepth;

var config string strDefaultRes;	// Res we originally ran with for Restore Defaults.

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	AddTitle(VideoTitleText, TitleFont, TitleAlign);

	ResCombo = AddComboBox(ResText, ResHelp, ItemFont);
	ColorCombo = AddComboBox(ColorText, ColorHelp, ItemFont);
	FullScreenCheckbox = AddCheckbox(FullScreenText, FullScreenHelp, ItemFont);
	BrightnessSlider = AddSlider(BrightnessText, BrightnessHelp, ItemFont, 2, 10);
	ContrastSlider = AddSlider(ContrastText, ContrastHelp, ItemFont, 0, 20);
	GammaSlider = AddSlider(GammaText, GammaHelp, ItemFont, 5, 25);

	RestoreChoice	= AddChoice(RestoreText,	RestoreHelp,	ItemFont, ItemAlign);
	BackChoice		= AddChoice(BackText,		"",				ItemFont, ItemAlign, true);

	LoadValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Set all values to defaults
///////////////////////////////////////////////////////////////////////////////
function SetDefaultValues()
	{
	bAsk = false;

	// Restore the previous saved default values.
	RestoreDefaultValues();

	bAsk = true;

	// Now that we've restored the values, update the UI.
	LoadValues();

	bAsk = false;
	
	// Some values are not a simple INI read/update.
	ResCombo.SetValue(strDefaultRes);

	bAsk = true;
	}

///////////////////////////////////////////////////////////////////////////////
// Store default values.
///////////////////////////////////////////////////////////////////////////////
function StoreDefaultValues()
	{
	if (bDefaultsStored == false)
		{
		// Store the non-INI oriented defaults.
		strDefaultRes = ShellRootWindow(Root).GetLowGameRes();
		if (strDefaultRes == "")
			strDefaultRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes");
		}

	super.StoreDefaultValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Load all values from ini files
///////////////////////////////////////////////////////////////////////////////
function LoadValues()
	{
	local float val;
	local bool flag;
	local String str;
	local int    iDef;

	// Store the values that need to be restored when the restore choice is chosen.
	// Note that we initialize the array here b/c the defaultproperties doesn't support
	// constants which is ridiculous.
	aDefaultPaths[iDef++] = BrightnessPath;
	aDefaultPaths[iDef++] = ContrastPath;
	aDefaultPaths[iDef++] = GammaPath;
	aDefaultPaths[iDef++] = ColorPath;
//	aDefaultPaths[iDef++] = StartupFullScreenPath;
	StoreDefaultValues();

	bUpdate = false;
	bAsk	= false;

	// 16/32 bit
	ColorCombo.Clear();
	ColorCombo.AddItem(ColorSettings[0]);
	ColorCombo.AddItem(ColorSettings[1]);
	if (GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth") == "16")
		ColorCombo.SetValue(ColorSettings[0]);
	else
		ColorCombo.SetValue(ColorSettings[1]);

	// This gets the current fullscreen status instead of getting the value from the ini.
	// This was done because when users press <Alt+Enter> to toggle full screen mode, we
	// couldn't tell that the mode changed and this checkbox would be "wrong".  So now
	// we always get the current status and then if the checkbox is changed then we
	// toggle fullscreen and write the new value to the ini file.  The next time the game
	// starts it will be in whatever mode it was when it last exited.
	flag = bool(GetPlayerOwner().ConsoleCommand("GetFullScreen"));
	FullScreenCheckbox.SetValue(flag);

	// Set available resolutions
	// MUST be after color and fullscreen controls are updated!
	ResCombo.Clear();
	UpdateAvailableResolutions();

	// If there's a low game res then show it, otherwise show the current res
	str = ShellRootWindow(Root).GetLowGameRes();
	if (str == "")
		str = GetPlayerOwner().ConsoleCommand("GetCurrentRes");
	ResCombo.SetValue(str);

	// Value 0.0 to 1.0
	val = int(float(GetPlayerOwner().ConsoleCommand("get"@BrightnessPath)) * 10);
	BrightnessSlider.SetValue(val);

	// Value 0.0 to 2.0
	val = int(float(GetPlayerOwner().ConsoleCommand("get"@ContrastPath)) * 10);
	ContrastSlider.SetValue(val);
	
	// Value 0.5 to 2.5
	val = int(float(GetPlayerOwner().ConsoleCommand("get"@GammaPath)) * 10);
	GammaSlider.SetValue(val);

	bUpdate = true;
	bAsk	= true;
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	Super.Notify(C, E);
	
	switch (E)
		{
		case DE_Change:
			switch (C)
				{
				case ResCombo:
					ResComboChanged();
					break;
				case ColorCombo:
					ColorComboChanged();
					break;
				case BrightnessSlider:
					BrightnessSliderChanged();
					break;
				case ContrastSlider:
					ContrastSliderChanged();
					break;
				case GammaSlider:
					GammaSliderChanged();
					break;
				case FullScreenCheckbox:
					FullScreenCheckboxChanged();
					break;
				}
			break;
		case DE_Click:
			switch (C)
				{
				case BackChoice:
					GoBack();
					break;
				case RestoreChoice:
					SetDefaultValues();
					break;
				}
			break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Update values when controls have changed.
// - only update the real value if bUpdate is true
// - only ask for user confirmation if bAsk is true
///////////////////////////////////////////////////////////////////////////////
function BrightnessSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Brightness "$(BrightnessSlider.GetValue() / 10));
		GetPlayerOwner().ConsoleCommand("Brightness "$(BrightnessSlider.GetValue() / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
		}
	}

function ContrastSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Contrast "$(ContrastSlider.GetValue() / 10));
		GetPlayerOwner().ConsoleCommand("Contrast "$(ContrastSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
		}
	}

function GammaSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager Gamma "$(GammaSlider.GetValue() / 10));
		GetPlayerOwner().ConsoleCommand("Gamma "$(GammaSlider.Value / 10));
		GetPlayerOwner().ConsoleCommand("FLUSH");
		}
	}

function ResComboChanged()
	{
	local String NewRes;

	if (bUpdate)
		{
		// Check if new res is below the minimum menu res
		NewRes = ResCombo.GetValue();
		if (ShellRootWindow(Root).IsBelowMinRes(NewRes))
			{
			// The new res will not take affect until the user returns to the game.
			// Put up a dialog explaining this to the user.
			ShellRootWindow(Root).SetLowGameRes(NewRes);
			MessageBox(LowResWarningTitle, LowResWarningText, MB_OK, MR_OK, MR_OK);
			}
		else
			{
			// The new resolution is NOT below the minimum.  In order to reduce the
			// complexity of what would have to happen if the user didn't confirm this
			// new resolution, I decided to throw out the possibility of returning to
			// a low game resolution by clearing it here.  This is a minor inconvenience
			// for the user and a major time-saver for me.
			ShellRootWindow(Root).ClearLowGameRes();

			// Check if the new res is different from the current one
			SafeRes = GetPlayerOwner().ConsoleCommand("GetCurrentRes");
			if(NewRes != SafeRes)
				{
				// Switch to the new res
				GetPlayerOwner().ConsoleCommand("SetRes "$NewRes);

				// Display messagebox with a time-out in case the new res is not valid
				// for the current monitor.  If the user doesn't click or clicks "no"
				// then we'll revert to the previous res.
				if (bAsk)
					ConfirmRes = MessageBox(ConfirmResTitle, ConfirmResText, MB_YESNO, MR_NO, MR_YES, 10);
				}
			}
		}
	}

function ColorComboChanged()
	{
	if (bUpdate)
		{
		SafeDepth = GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth");
		if (ColorCombo.GetValue() == ColorSettings[0])
			NewDepth = "16";
		else
			NewDepth = "32";
		if(NewDepth != SafeDepth)
			{
			// If switching to 16-bit mode, warn about lack of mirrors
			if (NewDepth == "16" && bAsk)
				Confirm16bit = MessageBox(BadDepthTitle, NoMirrorsText, MB_YESNO, MR_NO, MR_YES);
			else
				TryColorDepth(NewDepth);
			}
		}
	}

function FullScreenCheckboxChanged()
	{
	local bool bIsFullScreen;
	if (bUpdate)
		{
		// The user can toggle fullscreen mode at any time by hitting <Alt+Enter> and we won't
		// know that it changed.  Furthermore, it's possible the user will do this while this
		// particular menu is running, in which case this checkbox will be "wrong".  So we look
		// for that situation here.  The reason we got here is that the checkbox has been
		// toggled.  So if the new value of the checkbox agrees with the current mode then we
		// don't want to toggle fullscreen.  If they don't agree, then we do toggle it.
		bIsFullScreen = bool(GetPlayerOwner().ConsoleCommand("GetFullScreen"));
		if (bIsFullScreen != FullScreenCheckbox.bChecked)
			{
//			GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager StartupFullscreen"@FullScreenCheckbox.bChecked);
			GetPlayerOwner().ConsoleCommand("ToggleFullScreen");

			// Now check to see if we were able to go to non-fullscreen mode.  If the
			// user's desktop is not 32-bit (or 16-bit?) then it won't work, in which case
			// we'll put up a message telling them about it.
			bIsFullScreen = bool(GetPlayerOwner().ConsoleCommand("GetFullScreen"));
			if (bIsFullScreen && !FullScreenCheckbox.bChecked)
				{
				MessageBox(FullScreenOnlyTitle, FullScreenOnlyText, MB_OK, MR_OK, MR_OK);
				FullScreenCheckbox.SetValue(bIsFullScreen);
				UpdateAvailableResolutions();
				}
			}
		else
			{
			FullScreenCheckbox.SetValue(bIsFullScreen);
			UpdateAvailableResolutions();
			}
		}
	}


///////////////////////////////////////////////////////////////////////////////
// Callback for when message box is done
///////////////////////////////////////////////////////////////////////////////
function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
	{
	if (W == ConfirmRes)
		{
		ConfirmRes = None;
		if (Result != MR_Yes)
			{
			// Restore previous resolution
			GetPlayerOwner().ConsoleCommand("SetRes "$SafeRes);
			LoadValues();
			}
		}
	else if (W == Confirm16bit)
		{
		Confirm16bit = None;
		if (Result == MR_Yes)
			{
			// FIXME Couldn't switch to 16bit at runtime, so this hack asks player to restart game
			//TryColorDepth("16");
			ConfirmRestart16bit = MessageBox(Restart16bitTitle, Restart16bitText, MB_YESNO, MR_NO, MR_YES);
			}
		else
			{
			LoadValues();
			}
		}
	// FIXME Couldn't switch to 16bit at runtime, so this hack asks player to restart game
	else if (W == ConfirmRestart16bit)
		{
		if (Result == MR_Yes)
			{
			// Update ini value and then exit the game so 16-bit will take affect next time game starts
			UpdateColorPath("16");
			ShellRootWindow(root).ExitApp();
			}
		else
			{
			LoadValues();
			}
		}
	else if (W == ConfirmDepth)
		{
		ConfirmDepth = None;
		if (Result != MR_Yes)
			{
			// Restore previous depth
			UpdateColorPath(SafeDepth);
			GetPlayerOwner().ConsoleCommand("SetRes "$SafeRes);
			LoadValues();
			}
		else
			{
			LoadValues();
			}
		}
	}


///////////////////////////////////////////////////////////////////////////////
// Try specified color depth
///////////////////////////////////////////////////////////////////////////////
function TryColorDepth(String NewDepth)
	{
	local String CurrentRes;

	// Save the resolution and depth we'll return to if user clicks "no"
	CurrentRes = ResCombo.GetValue();
	SafeRes = CurrentRes$"x"$SafeDepth;

	// Switch to specified color depth.  The ini is only updated if user clicks "yes"
	UpdateColorPath(NewDepth);
	GetPlayerOwner().ConsoleCommand("SetRes" @ CurrentRes$"x"$NewDepth);
	if (bAsk)
		{
		// Check if the new color depth worked.  If so, put up a message asking
		// if user wants to keep it or not.  If not, put up message message explaining
		// that it isn't supported.
		if (GetPlayerOwner().ConsoleCommand("GetCurrentColorDepth") == NewDepth)
			ConfirmDepth = MessageBox(ConfirmDepthTitle, ConfirmDepthText, MB_YESNO, MR_NO, MR_YES, 10);
		else
			{
			if (bool(GetPlayerOwner().ConsoleCommand("GetFullScreen")))
				MessageBox(BadDepthTitle, BadDepthText, MB_OK, MR_OK, MR_OK);
			else
				MessageBox(DesktopDepthTitle, DesktopDepthText, MB_OK, MR_OK, MR_OK);
			// Reload the color combo.  This is only safe because we're inside
			// the "bAsk" condition, otherwise we'd have an infinite loop.
			LoadValues();
			}
		}
	}

function UpdateColorPath(string Depth)
	{
	local String Set;

	// Update ini to use specified depth
	if (Depth == "16")
		{
		Set = "set" @ ColorPath @ "true";
		Log(self @ "UpdateColorPath(): doing "$Set);
		GetPlayerOwner().ConsoleCommand(Set);
		}
	else
		{
		Set = "set" @ ColorPath @ "false";
		Log(self @ "UpdateColorPath(): doing "$Set);
		GetPlayerOwner().ConsoleCommand(Set);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// This is called when the resolution (and/or fullscreen mode) has changed.
///////////////////////////////////////////////////////////////////////////////
function ResolutionChanged(float W, float H)
	{
	Super.ResolutionChanged(W, H);

	// This gets called for two basic reasons: (1) we changed the display settings
	// via code, or (2) the user pressed <alt-tab> to toggle fullscreen mode, which
	// may also involve a resolution change.  In the case of #2, by changing the
	// display mode the user has taken things into his own hands, so we drop
	// any low-game res that might have existed.  This helps remove another
	// potential layer of complexity from things.
	ShellRootwindow(Root).ClearLowGameRes();

	LoadValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Update available resolutions
///////////////////////////////////////////////////////////////////////////////
function UpdateAvailableResolutions()
	{
	local int		Index;
	local int		BitDepth;
	local string	CurrentRes;

	CurrentRes = ResCombo.GetValue();
	ResCombo.Clear();
	
	if(ColorCombo.GetValue() == ColorSettings[0])
		BitDepth = 16;
	else
		BitDepth = 32;
	
	for(Index = 0; Index < ArrayCount(DisplayModes); Index++)
		{
		if(!FullScreenCheckbox.bChecked ||
			GetPlayerOwner().ConsoleCommand("SupportedResolution"$" WIDTH="$DisplayModes[Index].Width$" HEIGHT="$DisplayModes[Index].Height$" BITDEPTH="$BitDepth) == "1")
			{
			ResCombo.AddItem(DisplayModes[Index].Width$"x"$DisplayModes[Index].Height);
			}
		}
	
	ResCombo.SetValue(CurrentRes);
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	MenuWidth = 500
	fCommonCtlArea = 0.4

	VideoTitleText = "Video"

	ResText = "Game Resolution"
	ResHelp = "Controls the resolution at which the game is played"

	LowResWarningTitle = "Low Resolution";
	LowResWarningText = "You have chosen a very low resolution.  This resolution will take effect during actual gameplay but not while the menu is displayed.  It may be difficult to read text in the game at this resolution.";

	ConfirmResTitle="Confirm Resolution Change"
	ConfirmResText="Are you sure you wish to keep this new resolution?"

	ColorText = "Color Quality"
	ColorHelp = "Controls the color quality at which the game is played"
	ColorSettings[0] = "Medium (16-bit)"
	ColorSettings[1] = "Highest (32-bit)"

	ConfirmDepthTitle="Confirm Color Quality"
	ConfirmDepthText="Are you sure you wish to keep this new color quality?"

	BrightnessText = "Brightness"
	BrightnessHelp = "Controls display brightness"
	
	ContrastText = "Contrast"
	ContrastHelp = "Controls display contrast"
	
	GammaText = "Gamma"
	GammaHelp = "Controls display gamma"

	FullScreenText = "Full Screen"
	FullScreenHelp = "Change from windowed to full screen mode"

	FullScreenOnlyTitle = "Full Screen Only"
	FullScreenOnlyText = "Unable to switch out of full screen mode.  Try changing your desktop color to 32-bit.  Some video cards/drivers may prevent this from working."

	BadDepthTitle = "Color Quality"
	BadDepthText = "Unable to change color quality.  The requested color quality is not supported by the current video card/driver."

	DesktopDepthTitle = "Color Quality"
	DesktopDepthText = "Unable to change color quality.  In window mode the color quality must match your desktop settings."

	NoMirrorsText="16-bit mode may be faster on older video cards.  However, mirrors will not show reflections in 16-bit mode.\\n\\nAre you sure you want to try 16-bit mode?"

	Restart16bitTitle="Restart Game for 16-bit Mode"
	Restart16bitText="To switch to 16-bit quality you must exit the game and start again. Click YES to exit now or NO to cancel."

	DisplayModes(0)=(Width=320,Height=240)
	DisplayModes(1)=(Width=512,Height=384)
	DisplayModes(2)=(Width=640,Height=480)
	DisplayModes(3)=(Width=800,Height=600)
	DisplayModes(4)=(Width=1024,Height=768)
	DisplayModes(5)=(Width=1280,Height=960)
	DisplayModes(6)=(Width=1280,Height=1024)
	DisplayModes(7)=(Width=1600,Height=1200)
	}
