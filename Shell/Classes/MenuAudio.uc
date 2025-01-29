///////////////////////////////////////////////////////////////////////////////
// MenuAudio.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The audio menu.
//
///////////////////////////////////////////////////////////////////////////////
class MenuAudio extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string AudioTitleText;

var UWindowHSliderControl MusicSlider;
var localized string MusicText;
var localized string MusicHelp;
const MusicPath						= "ini:Engine.Engine.AudioDevice MusicVolume";

var UWindowHSliderControl EffectsSlider;
var localized string EffectsText;
var localized string EffectsHelp;
const EffectsPath					= "ini:Engine.Engine.AudioDevice SoundVolume";

const AUDIO_MODE_SOFTWARE			= 0;
const AUDIO_MODE_HARDWARE			= 1;
//const AUDIO_MODE_HARDWARE_EAX		= 2;
const AUDIO_MODE_SAFE				= 2; // renumbered to fill in gap left by EAX
const AUDIO_MODES					= 3; // renumbered (dropped EAX)
const AUDIO_MODE_DEFAULT			= 0;

var UWindowComboControl AudioModeCombo;
var localized string AudioModeText;
var localized string AudioModeHelp;
var localized string AudioModes[AUDIO_MODES];
const AudioModeCompatibilityPath	= "ini:Engine.Engine.AudioDevice CompatibilityMode";
const AudioModeEAXPath				= "ini:Engine.Engine.AudioDevice UseEAX";
const AudioMode3DSoundPath			= "ini:Engine.Engine.AudioDevice Use3DSound";

var UWindowHSliderControl AudioMemSlider;
var localized string AudioMemText;
var localized string AudioMemHelp;
const AudioMemPath = "Postal2Game.P2Dialog MemUsage";

//var UWindowCheckbox FilterExplicitCheckbox;
var localized string FilterExplicitText;
var localized string FilterExplicitHelp;
const FilterExplicitPath			= "Postal2Game.P2Dialog FilterFoulLanguage";

//var UWindowCheckbox BleepExplicitCheckbox;
var localized string BleepExplicitText;
var localized string BleepExplicitHelp;
const BleepExplicitPath				= "Postal2Game.P2Dialog BleepFoulLanguage";

var UWindowCheckbox ReverseStereoCheckbox;
var localized string ReverseStereoText;
var localized string ReverseStereoHelp;
const ReverseStereoPath				= "ini:Engine.Engine.AudioDevice ReverseStereo";

const c_strMessageBeepPath = "FPSGame.FPSHUD bMessageBeep";
var UWindowCheckbox MessageBeepCheckbox;
var localized string MessageBeepText;
var localized string MessageBeepHelp;

var UWindowHSliderControl AnnouncerSlider;
var localized string AnnouncerText;
var localized string AnnouncerHelp;
var localized array<string> AnnouncerSettingsText;
const AnnouncerPath = "MultiBase.MpPlayer AnnouncerLevel";

var UWindowComboControl AnnouncerVoiceCombo;
var localized string AnnouncerVoiceText;
var localized string AnnouncerVoiceHelp;

var localized string NoMemUseageTitle;
var localized string NoMemUseageText;

var bool bUpdate;
var bool bAsk;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	local String str;
	
	Super.CreateMenuContents();
	AddTitle(AudioTitleText, TitleFont, TitleAlign);

	MusicSlider = AddSlider(MusicText, MusicHelp, ItemFont, 0, 10);
	EffectsSlider = AddSlider(EffectsText, EffectsHelp, ItemFont, 0, 10);
//	FilterExplicitCheckbox = AddCheckbox(FilterExplicitText, FilterExplicitHelp, ItemFont);
//	BleepExplicitCheckbox = AddCheckbox(BleepExplicitText, BleepExplicitHelp, ItemFont);
	
	if (bInDemo)
		str = OptionUnavailableInDemoHelpText;
	else
		str = AudioMemHelp;
	AudioMemSlider = AddSlider(AudioMemText, str, ItemFont, 0, 2);
	AudioModeCombo = AddComboBox(AudioModeText, AudioModeHelp, ItemFont);
	ReverseStereoCheckbox = AddCheckbox(ReverseStereoText, ReverseStereoHelp, ItemFont);
	MessageBeepCheckbox     = AddCheckbox(MessageBeepText, MessageBeepHelp, ItemFont);
	AnnouncerSlider = AddSlider(AnnouncerText, AnnouncerHelp, ItemFont, 0, 2);
	AnnouncerSlider.SetVals(AnnouncerSettingsText);
	AnnouncerVoiceCombo = AddComboBox(AnnouncerVoiceText, AnnouncerVoiceHelp, ItemFont);

	RestoreChoice = AddChoice(RestoreText,	RestoreHelp, ItemFont, ItemAlign);
	BackChoice = AddChoice(BackText,		"", ItemFont, ItemAlign, true);

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

	// Restore the previous saved default values.
	RestoreDefaultValues();

	bAsk = true;

	// Now that we've restored the values, update the UI.
	LoadValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Load all values from ini files
///////////////////////////////////////////////////////////////////////////////
function LoadValues()
	{
	local float val;
	local int	iVal;
	local bool	flag;
	local String detail;
	local int    iDef;
	local string CurrentAnnouncer;
	local string PackageName;
	local string Description;

	// Store the values that need to be restored when the restore choice is chosen.
	// Note that we initialize the array here b/c the defaultproperties doesn't support
	// constants which is ridiculous.
	aDefaultPaths[iDef++] = MusicPath;
	aDefaultPaths[iDef++] = EffectsPath;
	aDefaultPaths[iDef++] = AudioModeCompatibilityPath;
	aDefaultPaths[iDef++] = AudioModeEAXPath;
	aDefaultPaths[iDef++] = AudioMode3DSoundPath;
	aDefaultPaths[iDef++] = AudioMemPath;
	//aDefaultPaths[iDef++] = FilterExplicitPath;
	//aDefaultPaths[iDef++] = BleepExplicitPath;
	aDefaultPaths[iDef++] = ReverseStereoPath;
	StoreDefaultValues();

	bUpdate = False;

	// Value 0.0 to 1.0, change to 0-10 for control
	val = float(GetPlayerOwner().ConsoleCommand("get" @ MusicPath));
	MusicSlider.SetValue(val*10.0);

	// Value 0.0 to 1.0, change to 0-10 for control
	val = float(GetPlayerOwner().ConsoleCommand("get" @ EffectsPath));
	EffectsSlider.SetValue(val*10.0);

	// Value 1 to 3, change to 0 to 2 for control
	val = float(GetPlayerOwner().ConsoleCommand("get" @ AudioMemPath));
	AudioMemSlider.SetValue(val-1);

	// Value 0 or 1
//	flag = bool(GetPlayerOwner().ConsoleCommand("get" @ FilterExplicitPath));
//	FilterExplicitCheckbox.SetValue(flag);

	// Value 0 or 1
//	flag = bool(GetPlayerOwner().ConsoleCommand("get" @ BleepExplicitPath));
//	BleepExplicitCheckbox.SetValue(flag);

	// Fill in all possible audio modes, then select the current mode based on several ini flags
	AudioModeCombo.Clear();
	for (iVal = 0; iVal < ArrayCount(AudioModes); iVal++)
		AudioModeCombo.AddItem(AudioModes[iVal]);
	if(bool(GetPlayerOwner().ConsoleCommand("get" @ AudioModeCompatibilityPath)))
	    AudioModeCombo.SetValue(AudioModes[AUDIO_MODE_SAFE]);
//	else if(bool(GetPlayerOwner().ConsoleCommand("get" @ AudioModeEAXPath)))
//		AudioModeCombo.SetValue(AudioModes[AUDIO_MODE_HARDWARE_EAX]);
	else if(bool(GetPlayerOwner().ConsoleCommand("get" @ AudioMode3dSoundPath)))
		AudioModeCombo.SetValue(AudioModes[AUDIO_MODE_HARDWARE]);
	else
		AudioModeCombo.SetValue(AudioModes[AUDIO_MODE_SOFTWARE]);

	// Value 0 or 1
	flag = bool(GetPlayerOwner().ConsoleCommand("get" @ ReverseStereoPath));
	ReverseStereoCheckbox.SetValue(flag);

	// Value true or false
	flag = bool(GetPlayerOwner().ConsoleCommand("get" @ c_strMessageBeepPath));
	MessageBeepCheckbox.SetValue(flag);

	// Value 0 to 2
	val = float(GetPlayerOwner().ConsoleCommand("get" @ AnnouncerPath));
	AnnouncerSlider.SetValue(val);

	// Fill in announcer voice types
    CurrentAnnouncer = class'MpPlayer'.default.CustomizedAnnouncerPack;
	if (CurrentAnnouncer == "")
		CurrentAnnouncer = "MpAnnouncer";
	for (iVal = 0; iVal < 10; iVal++)
	{
		// Announcer sound packages all use the same name with a single digit at the end (except for 0, which we leave off)
		PackageName = "MpAnnouncer";
		if (iVal > 0)
			PackageName = PackageName$iVal;

		// We only use packages that have localized descriptions.  This makes it easier to change
		// the number of announcers for different countries (just change the localization file, nothing else)
		Description = Localize("AnnouncerVoiceDescriptions", PackageName, "MultiAnnouncerInfo");
		if (Description != "" && InStr(Description, PackageName) == -1)
		{
			AnnouncerVoiceCombo.AddItem(Description, PackageName);
			if (PackageName ~= CurrentAnnouncer)
				AnnouncerVoiceCombo.SetValue(Description);
		}
	}

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
				case MusicSlider:
					MusicSliderChanged();
					break;
				case EffectsSlider:
					EffectsSliderChanged();
					break;
				case AudioMemSlider:
					AudioMemSliderChanged();
					break;
//				case FilterExplicitCheckbox:
//					FilterExplicitCheckboxChanged();
//					break;
//				case BleepExplicitCheckbox:
//					BleepExplicitCheckboxChanged();
//					break;
				case AudioModeCombo:
					AudioModeChanged();
					break;
				case ReverseStereoCheckbox:
					ReverseStereoCheckboxChanged();
					break;
				case MessageBeepCheckbox:
					MessageBeepCheckboxChanged();
					break;
				case AnnouncerSlider:
					AnnouncerSliderChanged();
					break;
				case AnnouncerVoiceCombo:
					AnnouncerVoiceComboChanged();
					break;
				}
			break;

		case DE_Click:
			switch (C)
				{
				case RestoreChoice:
					SetDefaultValues();
					break;
				case BackChoice:
					GoBack();
				}
			break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Update values when controls have changed.
// - if bUpdate is true then update the real value
// - if bAsk is false then skip any user confirmations
///////////////////////////////////////////////////////////////////////////////
function MusicSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ MusicPath @ MusicSlider.GetValue() / 10.0);
		RebootAudio();
		}
	}

function EffectsSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ EffectsPath @ EffectsSlider.GetValue() / 10.0);
		RebootAudio();
		}
	}

function AudioMemSliderChanged()
	{
	if (bUpdate)
		{
		if(bInDemo)
			{
			MessageBox(NoMemUseageTitle, NoMemUseageText, MB_OK, MR_OK, MR_OK);
			// Force it to 0.
			AudioMemSlider.SetValue(0);
			}
		else
			{
			GetPlayerOwner().ConsoleCommand("set" @ AudioMemPath @ AudioMemSlider.GetValue()+1);
			P2GameInfo(GetPlayerOwner().Level.Game).SetDialogMemUsage();
			}
		}
	}
/*
function FilterExplicitCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ FilterExplicitPath @ FilterExplicitCheckbox.bChecked);
		P2GameInfo(GetPlayerOwner().Level.Game).SetDialogFilterFoulLanguage();
		}
	}

function BleepExplicitCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ BleepExplicitPath @ BleepExplicitCheckbox.bChecked);
		P2GameInfo(GetPlayerOwner().Level.Game).SetDialogBleepFoulLanguage();
		}
	}
*/
function AudioModeChanged()
	{
	local String NewAudioMode;

	if (bUpdate)
		{
		NewAudioMode = AudioModeCombo.GetValue();
		if (NewAudioMode == AudioModes[AUDIO_MODE_SAFE])
			{
			// Safe mode
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeEAXPath @ "false");
            GetPlayerOwner().ConsoleCommand("set" @ AudioMode3DSoundPath @ "false");
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeCompatibilityPath @ "true");
			}
		else if (NewAudioMode == AudioModes[AUDIO_MODE_SOFTWARE])
			{
			// Software 3D Audio
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeEAXPath @ "false");
            GetPlayerOwner().ConsoleCommand("set" @ AudioMode3DSoundPath @ "false");
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeCompatibilityPath @ "false");
			}
		else if (NewAudioMode == AudioModes[AUDIO_MODE_HARDWARE])
			{
			// Hardware 3D Audio
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeEAXPath @ "false");
            GetPlayerOwner().ConsoleCommand("set" @ AudioMode3DSoundPath @ "true");
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeCompatibilityPath @ "false");
			ShowPerformanceWarning();
			}
/*		else if (NewAudioMode == AudioModes[AUDIO_MODE_HARDWARE_EAX])
			{
			// Hardware 3D Audio + EAX
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeEAXPath @ "true");
            GetPlayerOwner().ConsoleCommand("set" @ AudioMode3DSoundPath @ "true");
            GetPlayerOwner().ConsoleCommand("set" @ AudioModeCompatibilityPath @ "false");
			ShowPerformanceWarning();
			}
*/		RebootAudio();
		}
	}

function ReverseStereoCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ ReverseStereoPath @ ReverseStereoCheckbox.bChecked);
		RebootAudio();
		}
	}

function MessageBeepCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ c_strMessageBeepPath @ MessageBeepCheckbox.bChecked);
		}
	}

function AnnouncerSliderChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ AnnouncerPath @ AnnouncerSlider.GetValue());
		}
	}

function AnnouncerVoiceComboChanged()
	{
	local sound TestSound;

	if (bUpdate)
		{
        class'MpPlayer'.default.CustomizedAnnouncerPack = AnnouncerVoiceCombo.GetValue2();
        class'MpPlayer'.static.StaticSaveConfig();

        if (MpPlayer(GetPlayerOwner()) != None)
	    	MpPlayer(GetPlayerOwner()).CustomizedAnnouncerPack = AnnouncerVoiceCombo.GetValue2();

		TestSound = sound(DynamicLoadObject(AnnouncerVoiceCombo.GetValue2()$"."$"Announcer30sec", class'Sound'));
		if (TestSound != None)
			LookAndFeel.PlayThisLocalSound(self, TestSound, 1.0);
		}
	}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function RebootAudio()
	{
	// Reboot audio system
	GetPlayerOwner().ConsoleCommand("SOUND_REBOOT");

	// Restore any music that was playing
	FPSGameInfo(GetPlayerOwner().Level.Game).RestoreMusicAfterAudioReboot();

	// We don't use this for our game, but I'm going to restore it just in
	// case the MOD guys want to make use of it
	if( GetPlayerOwner().Level.Song != "" && GetPlayerOwner().Level.Song != "None" )
		GetPlayerOwner().ClientSetMusic( GetPlayerOwner().Level.Song, MTRAN_Instant );
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	MenuWidth = 550
	fCommonCtlArea = 0.40

	AudioTitleText = "Audio"

	MusicText = "Music Volume"
	MusicHelp = "Controls music volume"

	EffectsText = "Sound Volume"
	EffectsHelp = "Controls sound volume"

	AudioMemText = "Dialog Variety"
	AudioMemHelp = "Allows for more dialog but uses more memory"

	FilterExplicitText = "Reduce Explicit Language"
	FilterExplicitHelp = "Reduces the amount of explicit language"

	BleepExplicitText = "Bleep Explicit Words"
	BleepExplicitHelp = "Bleeps out all explicit words"

	AudioModeText = "Audio Mode"
	AudioModeHelp = "Determines what audio mode sounds will play in"
	// Can't use consts here so be careful to match these with the AUDIO_MODE_* consts
	AudioModes[0] = "Software 3D"
	AudioModes[1] = "Hardware 3D"
//	AudioModes[x] = "Hardware 3D+EAX"	// dropped EAX
	AudioModes[2] = "Safe Mode"			// renumbered to fill in gap left by EAX

	ReverseStereoText = "Reverse Stereo"
	ReverseStereoHelp = "Reverses the left and right audio channels."

	MessageBeepText = "Message Beep"
	MessageBeepHelp = "Turn on to beep when certain messages are displayed"

	AnnouncerText = "Announcer"
	AnnouncerHelp = "Determines how much the announcer will talk during multiplayer games"
	AnnouncerSettingsText(0)="None"
	AnnouncerSettingsText(1)="Some"
	AnnouncerSettingsText(2)="All"

	AnnouncerVoiceText = "Announcer Voice"
	AnnouncerVoiceHelp = "Chooses the announcer voice"

	NoMemUseageTitle = "Limited Dialog Variety"
	NoMemUseageText  = "To reduce demo memory size, there is one dialog variety setting for the demo. The full version of the game has several settings for added variety of the character dialog."
	}
