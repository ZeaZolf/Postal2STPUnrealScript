///////////////////////////////////////////////////////////////////////////////
// ShellComboControl.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// A control that adds the ability to display the value of the slider in the
// text area.
//
// History:
//	01/09/03 JMI	Started.
//
///////////////////////////////////////////////////////////////////////////////
// This class is simply to allow us to alter the way fonts are handled in the
// combo box.
//
// Future enhancements:
//
///////////////////////////////////////////////////////////////////////////////
class ShellComboControl extends UWindowComboControl;

///////////////////////////////////////////////////////////////////////////////
// Set the font for the edit and listboxes.
///////////////////////////////////////////////////////////////////////////////
function SetControlsFont(int NewFont)
{
	EditBox.SetFont(NewFont);
	List.SetFont(NewFont);
	// Have to customize EditBox height in look and feel and attempts thus far have
	// been messy.
}