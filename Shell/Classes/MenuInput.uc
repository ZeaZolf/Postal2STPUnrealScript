///////////////////////////////////////////////////////////////////////////////
// MenuInput.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The input menu.
//
// History:
//	01/13/03 JMI	Added strHelp parameter to AddChoice() allowing us to pass
//					in many help strings that had been created but were not 
//					being used for standard menu choices.  Added generic 
//					RestoreHelp for menus sporting a Restore option.
//
//	01/12/03 JMI	Changed bDontAsk to bAsk.
//
//	01/08/03 JMI	bDontUpdate's usage was backward from the name of the
//					var and the associated comment.  Renamed the var and changed
//					the comment rather than risking changing the code.
//
//	12/14/02 JMI	Added constants to easily adjust slider and value ranges
//					for mouse sensitivity.  Changed maximum for mouse 
//					sensitivity from 1.0 to 10.0.
//					Changed paths for in-game mouse sensitivity, invert, and
//					smoothing values.
//					Discovered we can also use SetSensitivity console command
//					for in-game sensitivity but there's no GetSensitivity.
//					Commented out item for in-menu sensitivity b/c I found no
//					way to set this--save this for final tuning--not critical.
//					Changed method invert, snap, and joy are read from INI..has 
//					to be as boolean--reading as int always comes up 0 since 
//					true or false strings come up 0.
//
//	12/12/02 JMI	Used a smaller font than was set by the base class so
//					mouse sensitivity labels would fit.
//
//	11/13/02 NPF	Started it.
//
///////////////////////////////////////////////////////////////////////////////
class MenuInput extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string InputTitleText;

// 12/14/02 JMI Added sensitivity max to make this easier to adjust--don't have
// to change it in 4 spots.
const c_fMaxSensitivity = 10.0;
const c_fMaxSlider		= 10.0;

const c_strInGameSensePath = "Engine.PlayerInput MouseSensitivity";
var UWindowHSliderControl SenseInGameSlider;
var localized string SenseInGameText;
var localized string SenseInGameHelp;

//var UWindowHSliderControl SenseInMenuSlider;
var localized string SenseInMenuText;
var localized string SenseInMenuHelp;

const c_strSnapToLevelPath = "Engine.PlayerController bSnapToLevel";
var UWindowCheckbox AutoSlopeCheckbox;
var localized string AutoSlopeText;
var localized string AutoSlopeHelp;

const c_strInvertMousePath = "Engine.PlayerInput bInvertMouse";
var UWindowCheckbox InvertMouseCheckbox;
var localized string InvertMouseText;
var localized string InvertMouseHelp;

const c_strMouseSmoothingPath = "Engine.PlayerInput MouseSmoothingMode";
var UWindowCheckbox MouseSmoothCheckbox;
var localized string MouseSmoothText;
var localized string MouseSmoothHelp;

const c_strUseJoyStickPath = "ini:Engine.Engine.ViewportManager UseJoystick";
var UWindowCheckbox EnableJoystickCheckbox;
var localized string EnableJoystickText;
var localized string EnableJoystickHelp;

var bool bUpdate;
var bool bAsk;

var string SaveRes;
var string SaveDepth;

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	AddTitle(InputTitleText, TitleFont, TitleAlign);

	// 12/12/02 JMI Use a smaller font than was set by the base class.
	ItemFont	= F_FancyM;

	SenseInGameSlider = AddSlider(SenseInGameText, SenseInGameHelp, ItemFont, 0, c_fMaxSlider);
//	SenseInMenuSlider = AddSlider(SenseInMenuText, SenseInMenuHelp, ItemFont, 0, c_fMaxSlider);
	AutoSlopeCheckbox = AddCheckbox(AutoSlopeText, AutoSlopeHelp, ItemFont);
	InvertMouseCheckbox = AddCheckbox(InvertMouseText, InvertMouseHelp, ItemFont);
	MouseSmoothCheckbox = AddCheckbox(MouseSmoothText, MouseSmoothHelp, ItemFont);
	EnableJoystickCheckbox = AddCheckbox(EnableJoystickText, EnableJoystickHelp, ItemFont);

	RestoreChoice	= AddChoice(RestoreText,	RestoreHelp,	ItemFont, ItemAlign);
	BackChoice		= AddChoice(BackText,		"",				ItemFont, ItemAlign, true);

	LoadValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Set all values to defaults
///////////////////////////////////////////////////////////////////////////////
function SetDefaultValues()
	{
	local float val;
	local String detail;

	bAsk = false;

	SenseInGameSlider.SetValue(5);
//	SenseInMenuSlider.SetValue(5);
	AutoSlopeCheckbox.SetValue(false);
	InvertMouseCheckbox.SetValue(false);
	MouseSmoothCheckbox.SetValue(true);
	EnableJoystickCheckbox.SetValue(false);

	bAsk = true;
	}

///////////////////////////////////////////////////////////////////////////////
// Load all values from ini files
///////////////////////////////////////////////////////////////////////////////
function LoadValues()
	{
	local float val;
	local bool flag;
	local String detail;

	bUpdate = False;

	// Value 0.0 to c_fMaxSensitivity
	val = Sense2Slider(float(GetPlayerOwner().ConsoleCommand("get"@c_strInGameSensePath) ) );
	SenseInGameSlider.SetValue(val);

	// Value 0.0 to 2.0
	//val = Sense2Slider(float(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.ViewportManager SenseInMenu") ) );
	//SenseInMenuSlider.SetValue(val);
	
	// Value true or false
	flag = bool(GetPlayerOwner().ConsoleCommand("get"@c_strSnapToLevelPath));
	AutoSlopeCheckbox.SetValue(flag);

	// Value true or false
	flag = bool(GetPlayerOwner().ConsoleCommand("get"@c_strInvertMousePath) );
	InvertMouseCheckbox.SetValue(flag);

	// Value 0 or 1
	val = int(GetPlayerOwner().ConsoleCommand("get"@c_strMouseSmoothingPath) );
	MouseSmoothCheckbox.SetValue(val != 0);

	// Value true or false
	flag = bool(GetPlayerOwner().ConsoleCommand("get"@c_strUseJoyStickPath));
	EnableJoystickCheckbox.SetValue(flag);

	bUpdate = True;
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
				case SenseInGameSlider:
					SenseInGameSliderChanged();
					break;
//				case SenseInMenuSlider:
//					SenseInMenuSliderChanged();
//					break;
				case AutoSlopeCheckbox:
					AutoSlopeCheckboxChanged();
					break;
				case InvertMouseCheckbox:
					InvertMouseCheckboxChanged();
					break;
				case MouseSmoothCheckbox:
					MouseSmoothCheckboxChanged();
					break;
				case EnableJoystickCheckbox:
					EnableJoystickCheckboxChanged();
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
// 12/13/02 JMI Started to convert from sensitivity value to slider value.
///////////////////////////////////////////////////////////////////////////////
function float Sense2Slider(float fSense)
{
	return fSense * c_fMaxSlider / c_fMaxSensitivity;
}

///////////////////////////////////////////////////////////////////////////////
// 12/13/02 JMI Started to convert from slider value to sensitivity value.
///////////////////////////////////////////////////////////////////////////////
function float Slider2Sense(float fSlider)
{
	return fSlider * c_fMaxSensitivity / c_fMaxSlider;
}

///////////////////////////////////////////////////////////////////////////////
// Update values when controls have changed.
// - if bUpdate is false then don't update the real value
// - if bAsk is false then skip any user confirmations
///////////////////////////////////////////////////////////////////////////////
function SenseInGameSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set"@c_strInGameSensePath@Slider2Sense(SenseInGameSlider.GetValue() ) );
//		GetPlayerOwner().ConsoleCommand("SenseInGame "$Slider2Sense(SenseInGameSlider.GetValue() ) );
		GetPlayerOwner().ConsoleCommand("FLUSH");
		}
	}

function SenseInMenuSliderChanged()
	{
	if (bUpdate)
		{
		//GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.ViewportManager SenseInMenu "$Slider2Sense(SenseInMenuSlider.GetValue() ) );
		//GetPlayerOwner().ConsoleCommand("SenseInMenu "$Slider2Sense(SenseInMenuSlider.Value) );
		//GetPlayerOwner().ConsoleCommand("FLUSH");
		}
	}

function AutoSlopeCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().bSnapToLevel=AutoSlopeCheckbox.bChecked;
		GetPlayerOwner().ConsoleCommand("set"@c_strSnapToLevelPath@AutoSlopeCheckbox.bChecked);
		}
	}
function InvertMouseCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set"@c_strInvertMousePath@InvertMouseCheckbox.bChecked);
		}
	}
function MouseSmoothCheckboxChanged()
	{
	local int val;

	if (bUpdate)
		{
		if (MouseSmoothCheckbox.bChecked)
			val = 1;

		GetPlayerOwner().ConsoleCommand("set"@c_strMouseSmoothingPath@val);
		}
	}
function EnableJoystickCheckboxChanged()
	{
	local int val;

	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set"@c_strUseJoyStickPath@EnableJoystickCheckbox.bChecked);
		log(self$" writing "$EnableJoystickCheckbox.bChecked);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	MenuWidth = 600	// 11/28/02 JMI MenuWidth Default -> 600.

	InputTitleText = "Input Config"

	SenseInGameText = "Game Mouse Sensitivity"
	SenseInGameHelp = "Controls mouse sensitivity during gameplay"
	
	SenseInMenuText = "Menu Mouse Sensitivity"
	SenseInMenuHelp = "Controls mouse sensitivity in the menus"
	
	AutoSlopeText = "Auto slope"
	AutoSlopeHelp = "View automatically pitches up/down when on a slope"
	
	EnableJoystickText = "Enable Joystick"
	EnableJoystickHelp = "Enables joystick support"
	
	InvertMouseText = "Invert Mouse"
	InvertMouseHelp = "Y axis of your mouse will be inverted"
	
	MouseSmoothText = "Mouse Smoothing"
	MouseSmoothHelp = "Automatically smooth out movements in your mouse"
	}
