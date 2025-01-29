///////////////////////////////////////////////////////////////////////////////
// FontInfo
// Copyright 2002 Running With Scissors.  All Rights Reserved.
//
// Centralized font info intended to be used by everything in the game that
// needs to use fonts.
//
///////////////////////////////////////////////////////////////////////////////
//
// Notes to self in future
//
// One of the primary goals of this class is to allow text to be drawn at a
// consistent size for any screen resolution.  The engine does not support
// font scaling (to be fair, scaled fonts don't tend to look very good).
// Instead, this class automatically uses smaller fonts at lower resolutions
// and larger fonts at higher resolutions.
//
// By carefully choosing the font sizes this class will use, it is possible
// to keep text very consistent across all resolutions.
//
// These are the standard display resolutions:
//
//							Aspect Ratio	% increase from previous resolution
//		320x240					1.33				
//		400x300					1.33				125%
//		512x384					1.33				128%
//		640x480					1.33				125%
//		800x600					1.33				125%
//		1024x768				1.33				128%
//		1280x960 & 1280x1024	1.33/1.25			125%
//		1600x1200				1.33				125%
//
// Note that the percentage increase is very similar for each step up in
// resolution.  We can average this out to 125.86%.
//
// Imagine we only wanted a single font size for all the text in the game
// and we were working at 320x240.  To keep text the same size at the other
// resolutions we'd need one additional font per resolution, each 125.86%
// larger than the previous font.  When the app wants to draw text, we would
// simply look up the font associated with the current resolution.
//
// That's basically how we do it, except we allow multiple font sizes per
// resolution, which is almost free because we already have a range of font
// sizes (one per resolution).  So for each additional size we want to support,
// we only need to add one additional font.
//
// We decided on 1024x768 as our "standard" resolution, which merely means that
// we do everything relative to that resolution.
//
// NOTE: 400x300 is not supported by the engine but is included to fill in
// the "gap" between 320x240 and 512x384, which helps simplify the code.
//
// NOTE: 1280x1024 has a unique aspect ratio.  We simply treat it like 1280x960
// which means text will appear slightly shorter compared to other resolutions.
//
// NOTE: An Excel spreadsheet exists to help calculate all the required
// font sizes.  See \Postal2\Docs\FontSizes.xls.
//
//
// Font styles
//
// Try to choose a plain font that is similar in spacing to the fancy font.
// The fancy font will presumably be used more often and the plain font will
// be used as a fallback.  If that's the case, then the plain font should
// be somewhat narrower (and never wider) than the fancy font.
//
///////////////////////////////////////////////////////////////////////////////
class FontInfo extends Info;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

const RESOLUTIONS			= 8;					// Number of resolutions (see explanation above)
const FONT_SIZES			= 4;					// Number of sizes (smallest=0, largest=FONT_SIZES-1)
const FONT_TYPES			= 2;					// Number of styles (plain and fancy)

const FONT_INCREMENTS		= 11;					// RESOLUTIONS + FONT_SIZES - 1
const TOTAL_FONTS			= 22;					// FONT_INCREMENTS * FONT_TYPES


enum EJustify
	{
	EJ_Left,		// Text is drawn to the right of the specified x position
	EJ_Right,		// Text is drawn to the left of the specified x position
	EJ_Center,		// Text is drawn centered around the specified x position
	};

var Color					TextColor;				
var Color					ShadowColor;

var name					FontNames[TOTAL_FONTS];
var vector					ShadowOffsets[TOTAL_FONTS];
var Font					CachedFonts[TOTAL_FONTS];

var private float			ResWidth;
var private float			ResAdjustment;
var private int				LatestFontIndex;


///////////////////////////////////////////////////////////////////////////////
// Draw text using all the specified atributes.
///////////////////////////////////////////////////////////////////////////////
function DrawTextEx(Canvas Canvas, float CanvasWidth, float x, float y, String str, int FontSize, optional bool bPlainFont, optional EJustify justify)
	{
	local float XL, YL;

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.Font = GetFont(FontSize, bPlainFont, CanvasWidth);

	if (justify == EJ_Right)
		{
		Canvas.StrLen(str, XL, YL);
		x -= XL;
		}
	else if (justify == EJ_Center)
		{
		Canvas.StrLen(str, XL, YL);
		x -= (XL / 2);
		}

	Canvas.bCenter = false;
	Canvas.SetPos(x, y);
	Canvas.DrawColor = TextColor;
	DrawText(Canvas, str, 1.0);
	}

///////////////////////////////////////////////////////////////////////////////
// Draw text with a shadow behind it.
//
// This is intended as a simple substitute for Canvas.DrawText().  It assumes
// the position, font, color and style have all been set already and it returns
// with all those values unchanged.
//
// The shadow offsets are calculated based on the most recent call to GetFont().
//
// ShadowAlpha ranges from 255 (full) to 0 (none).  We take advantage of a
// brilliant Epic design feature whereby an alpha of 0 is interpreted as 255,
// so if the ShadowAlpha is not specified, the shadow will be drawn at 255.
///////////////////////////////////////////////////////////////////////////////
function DrawText(Canvas canvas, coerce String str,  optional float Fade)
	{
	local float SaveX, SaveY;
	local Color SaveColor;
	local float x, y, x2, y2;
	local byte SaveStyle;

	if (Canvas.Font != None)
		{
		SaveX = Canvas.CurX;
		SaveY = Canvas.CurY;

		// Canvas.DrawText() truncates x and y prior to drawing.  So in order for shadows
		// to be consistently offset from the text, we need to truncate x and y.  That will
		// tell us the actual position at which the text will be drawn, and then we can
		// calculate the actual position for the shadows.
		x = int(SaveX);
		y = int(SaveY);
		x2 = x + ShadowOffsets[LatestFontIndex].X;
		y2 = y + ShadowOffsets[LatestFontIndex].Y;
		if (x2 != x || y2 != y)
			{
			SaveColor = Canvas.DrawColor;
			SaveStyle = Canvas.Style;
			Canvas.SetPos(x2, y2);
			Canvas.Style = ERenderStyle.STY_Alpha;
			Canvas.DrawColor = ShadowColor;
			if (Fade == 0.0)
				Fade = 255.0;
			Canvas.DrawColor.A = float(ShadowColor.A) * Fade;
			Canvas.DrawText(str);
			Canvas.DrawColor = SaveColor;
			Canvas.SetPos(SaveX, SaveY);
			Canvas.Style = SaveStyle;
			}

		Canvas.DrawText(str);
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Get font of specified size and style
///////////////////////////////////////////////////////////////////////////////
function Font GetFont(int FontSize, bool bPlainFont, float CanvasWidth)
	{
	local int FontIndex;

	if (ResWidth != CanvasWidth)
		UpdateRes(CanvasWidth);

	FontIndex = FontSize + ResAdjustment;
	if (bPlainFont)
		FontIndex += FONT_INCREMENTS;

	LatestFontIndex = FontIndex;
	return CachedFonts[FontIndex];
	}

///////////////////////////////////////////////////////////////////////////////
// Update cached font info using specified resolution
///////////////////////////////////////////////////////////////////////////////
private function UpdateRes(float CanvasWidth)
	{
	local int FontSize;
	local int FontIndex;

	// Specified resolution determines how much to increase or reduce font size
	if (CanvasWidth <= 320)
		ResAdjustment = 0;
//	else if (CanvasWidth <= 400)	// unsupported resolution
//		ResAdjustment = 1;
	else if (CanvasWidth <= 512)
		ResAdjustment = 2;
	else if (CanvasWidth <= 640)
		ResAdjustment = 3;
	else if (CanvasWidth <= 800)
		ResAdjustment = 4;
	else if (CanvasWidth <= 1024)
		ResAdjustment = 5;
	else if (CanvasWidth >= 1280)
		ResAdjustment = 6;
	else if (CanvasWidth >= 1600)
		ResAdjustment = 7;

	// Cache all the font sizes for this resolution
	for (FontSize = 0; FontSize < FONT_SIZES; FontSize++)
		{
		FontIndex = FontSize + ResAdjustment;

		if (CachedFonts[FontIndex] == None)
			CachedFonts[FontIndex] = Font(DynamicLoadObject(String(FontNames[FontIndex]), class'Font'));
		FontIndex += FONT_INCREMENTS;
		if (CachedFonts[FontIndex] == None)
			CachedFonts[FontIndex] = Font(DynamicLoadObject(String(FontNames[FontIndex]), class'Font'));
		}

	if (CanvasWidth < 320)
		Warn("Stupid canvas width specified:"$CanvasWidth);

	ResWidth = CanvasWidth;
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	// Fancy fonts
	FontNames[0]  = "P2Fonts.Plain5"
	FontNames[1]  = "P2Fonts.Plain6"
	FontNames[2]  = "P2Fonts.Plain8"
	FontNames[3]  = "P2Fonts.Plain10"
	FontNames[4]  = "P2Fonts.Fancy12"
	FontNames[5]  = "P2Fonts.Fancy15"
	FontNames[6]  = "P2Fonts.Fancy19"
	FontNames[7]  = "P2Fonts.Fancy24"
	FontNames[8]  = "P2Fonts.Fancy30"
	FontNames[9]  = "P2Fonts.Fancy38"
	FontNames[10] = "P2Fonts.Fancy48"
	// Plain fonts
	FontNames[11] = "P2Fonts.Plain5"
	FontNames[12] = "P2Fonts.Plain6"
	FontNames[13] = "P2Fonts.Plain8"
	FontNames[14] = "P2Fonts.Plain10"
	FontNames[15] = "P2Fonts.Plain12"
	FontNames[16] = "P2Fonts.Plain15"
	FontNames[17] = "P2Fonts.Plain19"
	FontNames[18] = "P2Fonts.Plain24"
	FontNames[19] = "P2Fonts.Plain30"
	FontNames[20] = "P2Fonts.Plain38"
	FontNames[21] = "P2Fonts.Plain48"

	// Fancy shadows
	ShadowOffsets[0]  = (X=0,Y=0)
	ShadowOffsets[1]  = (X=0,Y=0)
	ShadowOffsets[2]  = (X=0,Y=0)
	ShadowOffsets[3]  = (X=1,Y=0)
	ShadowOffsets[4]  = (X=1,Y=1)
	ShadowOffsets[5]  = (X=1,Y=1)
	ShadowOffsets[6]  = (X=1,Y=1)
	ShadowOffsets[7]  = (X=1,Y=1)
	ShadowOffsets[8]  = (X=2,Y=2)
	ShadowOffsets[9]  = (X=2,Y=2)
	ShadowOffsets[10] = (X=2,Y=2)
	// Plain shadows
	ShadowOffsets[11] = (X=0,Y=0)
	ShadowOffsets[12] = (X=0,Y=0)
	ShadowOffsets[13] = (X=0,Y=0)
	ShadowOffsets[14] = (X=1,Y=0)
	ShadowOffsets[15] = (X=1,Y=1)
	ShadowOffsets[16] = (X=1,Y=1)
	ShadowOffsets[17] = (X=1,Y=1)
	ShadowOffsets[18] = (X=1,Y=1)
	ShadowOffsets[19] = (X=2,Y=2)
	ShadowOffsets[20] = (X=2,Y=2)
	ShadowOffsets[21] = (X=2,Y=2)

	TextColor=(R=180,G=10,B=10,A=255)
	ShadowColor=(R=25,G=25,B=25,A=180)
	}
