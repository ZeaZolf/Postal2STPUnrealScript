///////////////////////////////////////////////////////////////////////////////
// MenuPerformanceAdvanced.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The Advanced Performance menu.
//
///////////////////////////////////////////////////////////////////////////////
//
// This menu allows one to fine tune all exposed details of performance.
//
// Might want to let user know that smoke and fire changes will only affect
// new fire.
//
///////////////////////////////////////////////////////////////////////////////
class MenuPerformanceAdvanced extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized String PerformanceTitleText;

const c_fUnitsPerMeter		= 80.0;	// Our dude is 160 units tall so that's 80 units per meter.
const c_fMinFogMeters		= 40.0;
const c_fMaxFogMeters		= 200.0;
const c_fFogStepMeters		= 5.0;
const c_fFogOffValue		= 50000.0;
const c_fDefaultFogValue	= 8000.0;
const c_fMinSnipeFogValue   = 8000.0;

var UWindowHSliderControl GenEndSlider;
var localized string GenEndText;
var localized string GenEndHelp;
const GenFogStartPath		= "Postal2Game.P2GameInfo GeneralFogStart";
const GenFogEndPath			= "Postal2Game.P2GameInfo GeneralFogEnd";
const GenFogStartRatio		= 0.15;

const SnipeToGenRatio		= 2.0;	// Ratio of sniper end to general end.
const SnipeFogStartPath		= "Postal2Game.P2GameInfo SniperFogStart";
const SnipeFogEndPath		= "Postal2Game.P2GameInfo SniperFogEnd";
const SnipeFogStartRatio	= 0.15;

var UWindowCheckbox  InfiniteViewCheckbox;
var localized string InfiniteViewText;
var localized string InfiniteViewHelp;

var UWindowHSliderControl SmokeSlider;
var localized string SmokeText;
var localized string SmokeHelp;
const SmokeSliderPath = "Postal2Game.P2GameInfo SmokeDetail";

var UWindowHSliderControl FireSlider;
var localized string FireText;
var localized string FireHelp;
const FireSliderPath = "Postal2Game.P2GameInfo FireDetail";

// Shadows cause crashes so they are temporarily disabled
//var UWindowHSliderControl ShadowSlider;
var localized string ShadowText;
var localized string ShadowHelp;
const ShadowSliderPath = "Postal2Game.P2GameInfo ShadowDetail";

var UWindowCheckbox BloodSpoutCheckbox;
var localized string BloodSpoutText;
var localized string BloodSpoutHelp;
const BloodSpoutCheckboxPath = "Postal2Game.P2GameInfo BloodSpouts";

// This doesn't do anything! It's used in the game code!
//var UWindowHSliderControl WorldDetailSlider;
var localized string WorldDetailSliderText;
var localized string WorldDetailSliderHelp;
const WorldDetailSliderPath = "Postal2Game.P2GameInfo WorldDetail";

var localized array<string> astrDetailVals3;
var localized array<string> astrDetailVals4;

var UWindowHSliderControl TextureDetailWorldSlider;
var localized string TextureDetailWorldText;
var localized string TextureDetailWorldHelp;
const TextureDetailWorldSliderPath = "ini:Engine.Engine.ViewportManager TextureDetailWorld";
const TextureDetailWorldSliderPath2 = "ini:Engine.Engine.ViewportManager TextureDetailTerrain";

var UWindowHSliderControl TextureDetailSkinSlider;
var localized string TextureDetailSkinText;
var localized string TextureDetailSkinHelp;
const TextureDetailSkinSliderPath = "ini:Engine.Engine.ViewportManager TextureDetailSkin";
const TextureDetailSkinSliderPath2 = "ini:Engine.Engine.ViewportManager TextureDetailWeapon";

var UWindowHSliderControl TextureDetailLightmapSlider;
var localized string TextureDetailLightmapText;
var localized string TextureDetailLightmapHelp;
const TextureDetailLightmapSliderPath = "ini:Engine.Engine.ViewportManager TextureDetailLightmap";

var UWindowCheckbox WorldDetailObjsCheckbox;
var localized string WorldDetailObjsText;
var localized string WorldDetailObjsHelp;
const WorldDetailObjsPath = "Engine.GameInfo bGameHighDetail";
var localized string WorldDetailObjsWarningTitle;
var localized string WorldDetailObjsWarningText;

//var UWindowCheckbox GameDetailCheckbox;
var localized string GameDetailText;
var localized string GameDetailHelp;
const GameDetailPath = "Postal2Game.P2GameInfo HighDetail";

// Dynamic lights on guns has some bugs and hasn't been fully tested so it's been temporarily removed
//var UWindowCheckbox DynamicLightsCheckbox;
var localized string DynamicLightsText;
var localized string DynamicLightsHelp;
const DynamicLightsCheckPath = "Postal2Game.P2GameInfo DynamicWeaponLights";

var UWindowHSliderControl DecalSlider;
var localized string DecalText;
var localized string DecalHelp;
const DecalSliderPath = "Postal2Game.P2GameInfo SplatDetail";

// Turn off all projectors all together
var UWindowCheckbox ProjectorsCheckbox;
var localized string ProjectorsText;
var localized string ProjectorsHelp;
const ProjectorsCheckboxPath = "Engine.Projectors bUseProjectors";

var UWindowHSliderControl BodiesSlider;
var localized string BodiesSliderText;
var localized string BodiesSliderHelp;
const BodiesSliderPath = "Postal2Game.P2GameInfo BodiesSliderMax";

var UWindowHSliderControl PawnSlider;
var localized string PawnText;
var localized string PawnHelp;
const PawnSliderPath = "Postal2Game.P2GameInfo SliderPawnGoal";

var UWindowHSliderControl RagdollSlider;
var localized string RagdollText;
var localized string RagdollHelp;
const RagdollSliderPath = "Postal2Game.P2Player RagdollMax";

var localized string	PerformanceWarningTitle;
var localized string	PerformanceWarningText;

var localized string LimitTexturesTitle;
var localized string LimitTexturesText;

var bool bUpdate;
var bool bAsk;

const	FOG_SPREAD = 1000;

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();

	TitleAlign = TA_Center;
	AddTitle(PerformanceTitleText, TitleFont, TitleAlign);

	// 12/17/02 NPF Use a smaller font than was set by the base class.
	ItemFont	= F_FancyM;

	GenEndSlider   = AddSlider(GenEndText,   GenEndHelp,   ItemFont, 0, 1);
	GenEndSlider  .SetRange(c_fMinFogMeters, c_fMaxFogMeters, c_fFogStepMeters);	// Have to reset range to set step.  Can reach in to Step field but this function makes sure the value is set to a step.
	InfiniteViewCheckbox = AddCheckbox(InfiniteViewText, InfiniteViewHelp, ItemFont);	// 01/19/03 JMI Added to disable fog.
	TextureDetailWorldSlider = AddSlider(TextureDetailWorldText, TextureDetailWorldHelp, ItemFont, 1, 3);	// Don't allow lower than 1 or engine will crash
	TextureDetailWorldSlider.SetVals(astrDetailVals4);
	TextureDetailSkinSlider = AddSlider(TextureDetailSkinText, TextureDetailSkinHelp, ItemFont, 1, 3);	// Don't allow lower than 1 or engine will crash
	TextureDetailSkinSlider.SetVals(astrDetailVals4);
	TextureDetailLightmapSlider = AddSlider(TextureDetailLightmapText, TextureDetailLightmapHelp, ItemFont, 1, 3);	// Don't allow lower than 1 or engine will crash
	TextureDetailLightmapSlider.SetVals(astrDetailVals4);
	//GameDetailCheckbox = AddCheckbox(GameDetailText, GameDetailHelp, ItemFont);
	//WorldDetailSlider = AddSlider(WorldDetailSliderText, WorldDetailSliderHelp, ItemFont, 0, 1);
	//ShadowSlider = AddSlider(ShadowText, ShadowHelp, ItemFont, 0, 2);
	//ShadowSlider.SetVals(astrDetailVals3);
	//DynamicLightsCheckbox = AddCheckbox(DynamicLightsText, DynamicLightsHelp, ItemFont);
	FireSlider = AddSlider(FireText, FireHelp, ItemFont, 0, 10);
	SmokeSlider = AddSlider(SmokeText, SmokeHelp, ItemFont, 0, 10);
	BloodSpoutCheckbox = AddCheckbox(BloodSpoutText, BloodSpoutHelp, ItemFont);
	DecalSlider = AddSlider(DecalText, DecalHelp, ItemFont, 0, 10);
	ProjectorsCheckbox = AddCheckbox(ProjectorsText, ProjectorsHelp, ItemFont);
	PawnSlider = AddSlider(PawnText, PawnHelp, ItemFont, 0, 50);
	BodiesSlider = AddSlider(BodiesSliderText, BodiesSliderHelp, ItemFont, 0, 200);
	RagdollSlider = AddSlider(RagdollText, RagdollHelp, ItemFont, 0, 10);
	// 02/16/03 JMI Moved to bottom--this is where the other quantitative values are and this is one
	//				we prefer they don't turn off so it's last.
	WorldDetailObjsCheckbox = AddCheckbox(WorldDetailObjsText, WorldDetailObjsHelp, ItemFont);
	
	RestoreChoice	= AddChoice(RestoreText,	RestoreHelp,	ItemFont, ItemAlign);
	BackChoice		= AddChoice(BackText,		"",				ItemFont, ItemAlign, true);

	LoadValues();
	}

///////////////////////////////////////////////////////////////////////////////
// Display performance warning.
// 01/25/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function ShowWarning(string strTitle, string strMsg)
{
	if (bAsk)
	{
		MessageBox(strTitle, strMsg, MB_OK, MR_OK, MR_OK);
	}
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
	local bool flag;
	local String detail;
	local int    iDef;

	// Store the values that need to be restored when the restore choice is chosen.
	// Note that we initialize the array here b/c the defaultproperties doesn't support
	// constants which is ridiculous.
	aDefaultPaths[iDef++] = GenFogStartPath;
	aDefaultPaths[iDef++] = GenFogEndPath;
	aDefaultPaths[iDef++] = SnipeFogStartPath;
	aDefaultPaths[iDef++] = SnipeFogEndPath;
	aDefaultPaths[iDef++] = SmokeSliderPath;
	aDefaultPaths[iDef++] = FireSliderPath;
	//aDefaultPaths[iDef++] = ShadowSliderPath;
	//aDefaultPaths[iDef++] = WorldDetailSliderPath;
	aDefaultPaths[iDef++] = BloodSpoutCheckboxPath;
	aDefaultPaths[iDef++] = TextureDetailWorldSliderPath ;
	aDefaultPaths[iDef++] = TextureDetailWorldSliderPath2;
	aDefaultPaths[iDef++] = TextureDetailSkinSliderPath;
	aDefaultPaths[iDef++] = TextureDetailSkinSliderPath2;
	aDefaultPaths[iDef++] = TextureDetailLightmapSliderPath;
	aDefaultPaths[iDef++] = WorldDetailObjsPath;
	//aDefaultPaths[iDef++] = GameDetailPath;
	//aDefaultPaths[iDef++] = DynamicLightsCheckPath;
	aDefaultPaths[iDef++] = DecalSliderPath;
	aDefaultPaths[iDef++] = ProjectorsCheckboxPath;
	aDefaultPaths[iDef++] = BodiesSliderPath;
	aDefaultPaths[iDef++] = PawnSliderPath;
	aDefaultPaths[iDef++] = RagdollSliderPath;
	StoreDefaultValues();

	bUpdate = False;
	bAsk = false;

	val = float(GetPlayerOwner().ConsoleCommand("get" @ GenFogEndPath));
	GenEndSlider.SetValue(Units2Meters(val) );
	
	InfiniteViewCheckbox.SetValue(val == c_fFogOffValue);

	// Value 0 to 10
	val = float(GetPlayerOwner().ConsoleCommand("get" @ SmokeSliderPath));
	SmokeSlider.SetValue(val);

	// Value 0 to 10
	val = float(GetPlayerOwner().ConsoleCommand("get" @ FireSliderPath));
	FireSlider.SetValue(val);

	// Value 0/1/2
	//val = float(GetPlayerOwner().ConsoleCommand("get" @ ShadowSliderPath));
	//ShadowSlider.SetValue(val);

	// Value 0 or 1
	val = float(GetPlayerOwner().ConsoleCommand("get" @ BloodSpoutCheckboxPath));
	BloodSpoutCheckbox.SetValue(val != 0);

	// Value 0/1
	//val = float(GetPlayerOwner().ConsoleCommand("get" @ WorldDetailSliderPath));
	//WorldDetailSlider.SetValue(val);

	// Value is detail string
	detail = GetPlayerOwner().ConsoleCommand("get" @ TextureDetailWorldSliderPath);
	val = DetailNameToVal(detail);
	TextureDetailWorldSlider.SetValue(val);

	// Value is detail string
	detail = GetPlayerOwner().ConsoleCommand("get" @ TextureDetailSkinSliderPath);
	val = DetailNameToVal(detail);
	TextureDetailSkinSlider.SetValue(val);

	// Value is detail string
	detail = GetPlayerOwner().ConsoleCommand("get" @ TextureDetailLightmapSliderPath);
	val = DetailNameToVal(detail);
	TextureDetailLightmapSlider.SetValue(val);

	// Value is a boolean
	//flag = bool(GetPlayerOwner().ConsoleCommand("get" @ GameDetailPath) );
	//GameDetailCheckbox.SetValue(flag);

	// Value 0 or 1
	//val = int(GetPlayerOwner().ConsoleCommand("get" @ DynamicLightsCheckboxPath));
	//DynamicLightsCheckbox.SetValue(val != 0);

	// Value is boolean.
	WorldDetailObjsCheckbox.SetValue(bool(GetPlayerOwner().ConsoleCommand("get" @ WorldDetailObjsPath) ) );

	// Value 0-10
	val = float(GetPlayerOwner().ConsoleCommand("get" @ DecalSliderPath));
	DecalSlider.SetValue(val);

	// Value 0 or 1
	flag = bool(GetPlayerOwner().ConsoleCommand("get" @ ProjectorsCheckboxPath));
	ProjectorsCheckbox.SetValue(flag);

	// Value 0-50
	val = float(GetPlayerOwner().ConsoleCommand("get" @ PawnSliderPath));
	PawnSlider.SetValue(val);

	// Value 0-10
	val = float(GetPlayerOwner().ConsoleCommand("get" @ RagdollSliderPath));
	RagdollSlider.SetValue(val);

	// Value 0 or 200
	val = float(GetPlayerOwner().ConsoleCommand("get" @ BodiesSliderPath));
	BodiesSlider.SetValue(val);

	bUpdate = True;
	bAsk    = true;
	}

///////////////////////////////////////////////////////////////////////////////
// Callback for when control has changed
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	Super.Notify(C, E);
	
	switch (E)
		{
		case DE_Change:
			switch (C)
				{
				case InfiniteViewCheckbox:
					InfiniteViewCheckboxChanged();
					break;
				case GenEndSlider:
					GenEndSliderChanged();
					break;

				case SmokeSlider:
					SmokeSliderChanged();
					break;
				case FireSlider:
					FireSliderChanged();
					break;
				//case ShadowSlider:
				//	ShadowSliderChanged();
				//	break;
				case BloodSpoutCheckbox:
					BloodSpoutCheckboxChanged();
					break;
				//case WorldDetailSlider:
				//	WorldDetailSliderChanged();
				//	break;
				case TextureDetailWorldSlider:
					TextureDetailWorldSliderChanged();
					break;
				case TextureDetailSkinSlider:
					TextureDetailSkinSliderChanged();
					break;
				case TextureDetailLightmapSlider:
					TextureDetailLightmapSliderChanged();
					break;
				//case GameDetailCheckbox:
				//	GameDetailCheckboxChanged();
				//	break;
				//case DynamicLightsCheckbox:
				//	DynamicLightsCheckboxChanged();
				//	break;
				case WorldDetailObjsCheckbox:
					WorldDetailObjsCheckboxChanged();
					break;
				case DecalSlider:
					DecalSliderChanged();
					break;
				case ProjectorsCheckbox:
					ProjectorsCheckboxChanged();
					break;
				case PawnSlider:
					PawnSliderChanged();
					break;
				case BodiesSlider:
					BodiesSliderChanged();
					break;
				case RagdollSlider:
					RagdollSliderChanged();
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
// Convert a fog value in units to meters.
// 01/19/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function float Units2Meters(float fFogVal)
{
	// How about 40 meters (3,200 units) as the min and 200 meters (16,000 units) as the max.  5 meter (400 unit) increments seem nice, but that's 32 increments total.  That sounds like too many tick marks?  If it doesn't work, maybe use 16 tick marks but they can still increment it to the in-between values (that works now, I just don't know if anyone will know it).  Ick, this is the only bad part.
	return fFogVal / c_fUnitsPerMeter;
}

///////////////////////////////////////////////////////////////////////////////
// Convert a distance in meters to a fog value in units.
// 01/19/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function float Meters2Units(float fFogMeters)
{
	return fFogMeters * c_fUnitsPerMeter;
}

///////////////////////////////////////////////////////////////////////////////
// Update values when controls have changed.
// - only update the real value if bUpdate is true
// - only ask for user confirmation if bAsk is true
///////////////////////////////////////////////////////////////////////////////
function InfiniteViewCheckboxChanged()
{
	if (bUpdate)
	{
		if (InfiniteViewCheckbox.bChecked)
		{
			GetPlayerOwner().ConsoleCommand("set" @ GenFogEndPath @ c_fFogOffValue);
			GetPlayerOwner().ConsoleCommand("set" @ GenFogStartPath @ c_fFogOffValue);
			GetPlayerOwner().ConsoleCommand("set" @ SnipeFogEndPath @ c_fFogOffValue);
			GetPlayerOwner().ConsoleCommand("set" @ SnipeFogStartPath @ c_fFogOffValue);
	
			ShowWarning(PerformanceWarningTitle, PerformanceWarningText);

			// Update the fog now, in the level the player is in
			P2GameInfo(GetPlayerOwner().Level.Game).SetZoneFogPlanes();
			P2GameInfo(GetPlayerOwner().Level.Game).SetSniperZoneFog(GetPlayerOwner());
		}
		else
		{
			// Set to defaults when enabled.
			GenEndSlider.SetValue(Units2Meters(c_fDefaultFogValue) );
		}
	}
}

function GenEndSliderChanged()
{
	local float fUnits;
	if (bUpdate)
	{
		fUnits = Meters2Units(GenEndSlider.GetValue() );
		
		GetPlayerOwner().ConsoleCommand("set" @ GenFogEndPath @ fUnits);
		GetPlayerOwner().ConsoleCommand("set" @ GenFogStartPath @ fUnits * GenFogStartRatio);

		fUnits = FClamp(fUnits * SnipeToGenRatio, c_fMinSnipeFogValue, Meters2Units(c_fMaxFogMeters) );	// 02/16/03 JMI Calculate sniper value from general value.
		GetPlayerOwner().ConsoleCommand("set" @ SnipeFogEndPath @ fUnits);
		GetPlayerOwner().ConsoleCommand("set" @ SnipeFogStartPath @ fUnits * SnipeFogStartRatio);

		// Update the fog now, in the level the player is in
		P2GameInfo(GetPlayerOwner().Level.Game).SetZoneFogPlanes();
		P2GameInfo(GetPlayerOwner().Level.Game).SetSniperZoneFog(GetPlayerOwner());

		// If the slider was changed, enable the fog checkbox.
		bUpdate = false;
		InfiniteViewCheckbox.SetValue(false);
		bUpdate = true;
	}
}

function SmokeSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ SmokeSliderPath @ SmokeSlider.GetValue());
	}

function FireSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ FireSliderPath @ FireSlider.GetValue());
	}

/*
function ShadowSliderChanged()
{
	if (bUpdate)
	{
		GetPlayerOwner().ConsoleCommand("set" @ ShadowSliderPath @ ShadowSlider.GetValue());
		ShowWarning(PerformanceWarningTitle, PerformanceWarningText);	// 02/02/03 JMI Added.
	}
}
*/
function BloodSpoutCheckboxChanged()
	{
	local int val;

	if (bUpdate)
		{
		if (BloodSpoutCheckbox.bChecked)
			val = 1;
		GetPlayerOwner().ConsoleCommand("set" @ BloodSpoutCheckboxPath @ val);
		}
	}
/*
function WorldDetailSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ WorldDetailSliderPath @ WorldDetailSlider.GetValue());
	}
*/
function TextureDetailWorldSliderChanged()
	{
	local bool bDontSet;
	if (bUpdate)
		{
		if(bInDemo)
			{
			if(TextureDetailWorldSlider.GetValue() > 2)
				{
				MessageBox(LimitTexturesTitle, LimitTexturesText, MB_OK, MR_OK, MR_OK);
				TextureDetailWorldSlider.SetValue(2);
				bDontSet=true;
				}
			}

		if(!bDontSet)
			{
			GetPlayerOwner().ConsoleCommand("set" @ TextureDetailWorldSliderPath @ DetailValToName(TextureDetailWorldSlider.GetValue()));
			GetPlayerOwner().ConsoleCommand("set" @ TextureDetailWorldSliderPath2 @ DetailValToName(TextureDetailWorldSlider.GetValue()));
			GetPlayerOwner().ConsoleCommand("flush");
			}
		}
	}

function TextureDetailSkinSliderChanged()
	{
	if (bUpdate)
		{
		// Allow the full range of character skin settings in demo
		GetPlayerOwner().ConsoleCommand("set" @ TextureDetailSkinSliderPath @ DetailValToName(TextureDetailSkinSlider.GetValue()));
		GetPlayerOwner().ConsoleCommand("set" @ TextureDetailSkinSliderPath2 @ DetailValToName(TextureDetailSkinSlider.GetValue()));
		GetPlayerOwner().ConsoleCommand("flush");
		}
	}

function TextureDetailLightmapSliderChanged()
	{
	local bool bDontSet;

	if (bUpdate)
		{
		if(bInDemo)
			{
			if(TextureDetailLightmapSlider.GetValue() > 2)
				{
				MessageBox(LimitTexturesTitle, LimitTexturesText, MB_OK, MR_OK, MR_OK);
				TextureDetailLightmapSlider.SetValue(2);
				bDontSet=true;
				}
			}

		if(!bDontSet)
			{
			GetPlayerOwner().ConsoleCommand("set" @ TextureDetailLightmapSliderPath @ DetailValToName(TextureDetailLightmapSlider.GetValue()));
			GetPlayerOwner().ConsoleCommand("flush");
			}
		}
	}
/*
function GameDetailCheckboxChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ GameDetailPath @ GameDetailCheckbox.bChecked);
	}
*/
/*
function DynamicLightsCheckboxChanged()
	{
	local int val;

	if (bUpdate)
		{
		if (DynamicLightsCheckbox.bChecked)
			val = 1;
		GetPlayerOwner().ConsoleCommand("set" @ DynamicLightsCheckboxPath @ val);
		}
	}
*/
function WorldDetailObjsCheckboxChanged()
	{
	if (bUpdate)
		{
		GetPlayerOwner().ConsoleCommand("set" @ WorldDetailObjsPath @ WorldDetailObjsCheckbox.bChecked);
		// Warn about looking like crap--so they know exactly what they did that made everything look bad.
		if (WorldDetailObjsCheckbox.bChecked == false)
			ShowWarning(WorldDetailObjsWarningTitle, WorldDetailObjsWarningText);
		}
	}
function DecalSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ DecalSliderPath @ DecalSlider.GetValue());
	}
function ProjectorsCheckboxChanged()
	{
	local int val;

	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ ProjectorsCheckboxPath @ ProjectorsCheckbox.bChecked);
	}
function PawnSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ PawnSliderPath @ PawnSlider.GetValue());
	}
function BodiesSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ BodiesSliderPath @ BodiesSlider.GetValue());
	}
function RagdollSliderChanged()
	{
	if (bUpdate)
		GetPlayerOwner().ConsoleCommand("set" @ RagdollSliderPath @ RagdollSlider.GetValue());
	}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	MenuWidth = 620
	// Need more room
	TitleSpacingY = 5
	ItemHeight	 = 22;
	ItemSpacingY = 0;
	BorderLeft  = 15;	// 01/19/03 JMI More room for fog.
	BorderRight = 15;	// 01/19/03 JMI More room for fog.
	HintLines = 3

	PerformanceTitleText = "Performance"

	InfiniteViewText = "Infinite Visibility"
	InfiniteViewHelp = "Lets you see everything no matter how far away.  Turn off for greatly improved performance."

	GenEndText = "Max fog visibility (meters)"
	GenEndHelp = "Fog hides everything past this distance.  Lower values give better performance."

	// 01/19/03 JMI Added detail value strings.
	astrDetailVals3[0] = "off";
	astrDetailVals3[1] = "low";
	astrDetailVals3[2] = "high";

	SmokeText = "Smoke Effects Density"
	SmokeHelp = "Controls density of smoke effects.  Lower values improve performance."

	FireText = "Fire Effects Density"
	FireHelp = "Controls density of fire effects.  Lower values improve performance."
	
	ShadowText = "Character Shadows"
	ShadowHelp = "Controls character shadows, which require very fast hardware.  Turn off to grealy improve performance."
	
	BloodSpoutText = "Blood Spout Effects"
	BloodSpoutHelp = "Controls whether blood squirts out.  Turn off to slightly improve performance."
	
	WorldDetailSliderText = "World detail"
	WorldDetailSliderHelp = "Controls number of objects in world.  Lower values improve performance."

	// 01/19/03 JMI Added detail value strings.
	astrDetailVals4[0] = "very low";
	astrDetailVals4[1] = "low";
	astrDetailVals4[2] = "medium";
	astrDetailVals4[3] = "high";

	TextureDetailWorldText = "World Texture Detail"
	TextureDetailWorldHelp = "Controls detail level of world textures.  Lower values improve performance."
	
	TextureDetailSkinText = "Character Texture Detail"
	TextureDetailSkinHelp = "Controls detail level of character skins.  Lower values improve performance."

	TextureDetailLightmapText = "Lightmap Texture Detail"
	TextureDetailLightmapHelp = "Controls detail level of lightmaps.  Lower values improve performance."

	GameDetailText = "High Game Detail"
	GameDetailHelp = "Controls high-end effects/visuals/people.  Turn off to improve performance."

	DynamicLightsText = "Dynamic Weapon Lights"
	DynamicLightsHelp = "Guns use dynamic lighting when shooting"

	WorldDetailObjsText = "World Detail Objects"
	WorldDetailObjsHelp = "Controls non-essential objects like plants, trees, and furniture that make the world look good"

	DecalText = "Decal Lifetime"
	DecalHelp = "Controls how long blood splats and bullet holes last.  Lower values improve performance."

	ProjectorsText = "Allow Projectors"
	ProjectorsHelp = "Controls all projectors (grafitti, etc.) in game"	// 01/23/03 JMI Changed "Turn off" to "Controls".

	PawnText = "Bystander Population"
	PawnHelp = "Controls number of bystanders.  Lower values improve performance."

	BodiesSliderText = "Corpse Population"
	BodiesSliderHelp = "Controls max number of corpses before older ones are removed.  Lower values improve performance."

	RagdollText = "Ragdolls"
	RagdollHelp = "Controls max number of simultaneous ragdoll physics. Lower values improve performance."

	PerformanceWarningTitle = "Warning";
	PerformanceWarningText  = "Enabling this option could seriously impact performance"; 

	WorldDetailObjsWarningTitle = "Warning"
	WorldDetailObjsWarningText  = "The game will look totally barren without these objects.  Only turn this off as a last resort."

	LimitTexturesTitle = "Limited Texture Detail"
	LimitTexturesText  = "To reduce demo memory size, the highest texture detail quality is not allowed in the demo version. The full version of the game allows this highest detail setting."
	}
