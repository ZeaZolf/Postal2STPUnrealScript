///////////////////////////////////////////////////////////////////////////////
// ShellMenuChoice.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// A typical choice on the menu (text).
//
//	History:
//	09/02/02 MJR	Moved visual and audio effects to ShellLookAndFeel.
//
//	08/31/02 MJR	Renamed.
//
//	06/29/02 MJR	Adjusted shadow positions.
//
//	06/08/02 JMI	Added OnHighlightChoice() and OnUnhighlightChoice() to
//					facilitate menu sounds.
//
//	05/21/02 JMI	Made static darker and hover just an octave above that.
//
//	05/19/02 JMI	Changed hover color to be a shade of red.
//
//	05/19/02 JMI	Started from ShellMenuStart.
//
///////////////////////////////////////////////////////////////////////////////
// This class represents the individual menu items on a menu.
///////////////////////////////////////////////////////////////////////////////
class ShellMenuChoice extends UWindowDialogControl;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var bool	bActive;				// Whether item is active
var bool	bCancel;				// Whether item responds to the "cancel" key


///////////////////////////////////////////////////////////////////////////////
// Mouse entered our area...say...
///////////////////////////////////////////////////////////////////////////////
function MouseEnter()
	{
	Super.MouseEnter();
	if (bActive)
		LookAndFeel.Control_MouseEnter(self);
	}

///////////////////////////////////////////////////////////////////////////////
// Mouse left our area.
///////////////////////////////////////////////////////////////////////////////
function MouseLeave()
	{
	Super.MouseLeave();
	if (bActive)
		LookAndFeel.Control_MouseLeave(self);
	}

///////////////////////////////////////////////////////////////////////////////
// Mouse released in our area.
///////////////////////////////////////////////////////////////////////////////
function Click(float X, float Y)
	{
	if (bActive)
		{
		LookAndFeel.Control_Click(self);
		Notify(DE_Click);
		}

	Super.Click(X,Y);
	}

///////////////////////////////////////////////////////////////////////////////
// Prepare for paint
///////////////////////////////////////////////////////////////////////////////
function BeforePaint(Canvas C, float X, float Y)
	{
	local float TW, TH;

	Super.BeforePaint(C, X, Y);
	
	TextSize(C, Text, TW, TH);
	
	switch(Align)
		{
		case TA_Left:
			TextX = 0;
			break;
		case TA_Right:
			TextX = WinWidth - TW;
			break;
		case TA_Center:
			TextX = (WinWidth - TW) / 2;
			break;
		}

	TextY = (WinHeight - TH) / 2;
	}

///////////////////////////////////////////////////////////////////////////////
// Paint
///////////////////////////////////////////////////////////////////////////////
function Paint( Canvas C, float X, float Y )
	{
	LookAndFeel.Control_DrawText(self, C);
	Super.Paint(C, X, Y);
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bActive = true;
	}
