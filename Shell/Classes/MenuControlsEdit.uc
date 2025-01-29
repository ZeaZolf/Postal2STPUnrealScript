///////////////////////////////////////////////////////////////////////////////
// MenuControlsEdit.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// The controls editing menu work class.
//
///////////////////////////////////////////////////////////////////////////////
//
// This is the base class for the input editing classes.  This class performs
// the editing interaction based on the set of inputs provided by the derived
// class.
//
// It's tempting to create a single class that has n arrays of inputs.  When
// creating the class, one would specify which set of inputs to edit; however,
// in the spirit of Unreal, I'll try to stick with the program.
//
// TODO:
//		Looks ugly as Hell.
//			- Edit fields not tall enough.
//			- Edit fields not wide enough.
//		Accepts infinite bindings per input.
//		Restore Defaults restores original settings (not Defaults).
//
///////////////////////////////////////////////////////////////////////////////
class MenuControlsEdit extends ShellMenuCW
	config(user);	// 01/15/03 JMI Indicates that this class' config values are
					//				store in DefUser/User.ini (as opposed to 
					//				Default/Postal2.ini).


///////////////////////////////////////////////////////////////////////////////
// Typedefs.
///////////////////////////////////////////////////////////////////////////////

// This is the type returned from the derived classes indicating the controls
// to be edited on this menu instance.
struct Control
{
	var string				strAlias;	// The alias used to invoke the input.
	var localized string	strLabel;	// The label for the user to reference the input in
										// the menu system.
};

// Type for initialization of default keys from INI.
struct Default
{
	var string				alias;	// The alias used to invoke the input.
	var string				key;	// The name of the key that is the default.  Mapped back to input value at runtime.
	var string				cat;	// The category the key belongs to (e.g., "WADS", "Mouse", "Joystick").
};


// This is where the type binding info is stored in while editing bindings.
struct Binding
{
	var	Control				ctrl;		// The control alias and label (e.g., MoveLeft & Move Left)
	var	array<int>			aiKeys;		// The keys mapped to this control (parallel with astrKeys).
	var	array<string>		astrKeys;	// The names of the keys mapped to this control (parallel with aiKeys).
	var ShellInputControl	win;		// The window corresponding to this binding info.
};

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

const c_NumKeys = 255;
const c_strActivelyAcquiringText = "? ? ?";

var array<Binding>		aBindings;	// The binding info with controls and key names.
var array<string>		aBaselines;	// Indexed by key.  Values for keys that this instance
									// of the menu does not understand and therefore must
									// be maintained.  For example, bWantsToSkip isn't on
									// any menu and would, otherwise, get clobbered by any 
									// menu if someone used the space key for another input.
var ShellInputControl	winFocused;	// Widget, if any, receiving key input.

var config array<Default>	Defaults;		// Array of default keys to be initialized from INI.
var config array<string>	Categories;		// Array of categories for default keys to be initialized from INI.


// 11/28/02 JMI Made help prefix text for inputs localizable.
var localized string InputHelpPrefix;
var localized string InputHelpPostfix;

// 02/01/03 JMI Changed to actually having all these arrays available in the base
//				class.  GetControls still returns the one we're working on in the
//				current menu, though.  Having them all here is mostly just so we
//				can identify all mappable controls.
var array<Control>	aActionControls;
var array<Control>	aDisplayControls;
var array<Control>	aInvControls;
var array<Control>	aMiscControls;
var array<Control>	aMovementControls;
var array<Control>	aWeaponControls;


///////////////////////////////////////////////////////////////////////////////
// Functions.
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// Add an keypress widget to the menu
///////////////////////////////////////////////////////////////////////////////
function ShellInputControl AddKeyWidget(String strText, String strHelp, int Font, int iBindIndex)
	{
	local ShellInputControl ctl;

	ctl = ShellInputControl(CreateControl(class'ShellInputControl', GetNextItemPosX(), GetNextItemPosY(), ItemMaxWidth, ItemHeight));
	ctl.SetFont(Font);
	ctl.SetInputFont(-1, Font);	// 11/17/02 JMI Override so we can fit many keys.
	ctl.SetTextColor(ShellLookAndFeel(LookAndFeel).NormalTextColor);
	ctl.SetInputTextColor(-1, ShellLookAndFeel(LookAndFeel).NormalTextColor);
	ctl.SetInputTextAlign(-1, TA_Center);	// 02/02/03 JMI Added ability to center text in editboxes.
	ctl.SetText(strText);
	ctl.SetHelpText(strHelp);
	ctl.Align = TA_Left;
	ctl.iBindIndex = iBindIndex;
	AddItem(ctl, ItemHeight + ItemSpacingY);
	return ctl;
	}

///////////////////////////////////////////////////////////////////////////////
// Create the actual menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	local array<Control>			aControls;
	local int						iIter;
	local ShellInputControl			ctl;
	local ShellMenuChoice			chHeader;
	
	Super.CreateMenuContents();

	TitleAlign = TA_Center;

	// 01/19/03 JMI Set the font even smaller b/c the Weapons menu has too many 
	//				items and some descriptions are wide.
	// 11/24/02 JMI This menu could be huge..use a smaller font than was set by
	//				the base class.
	ItemFont	= F_FancyS;

	// Be sure we start clean.
	aBindings.Length = 0;

	aControls = GetControls();
	for (iIter = 0; iIter < aControls.Length; iIter++)
	{
		// Note that eventually we'll have another array or member that indicates
		// the type of control each input control needs to be edited with.
		// For now, a simple edit field will do.  This will probably be a ctrl
		// dervied from an edit field in the long run that can grab a key and,
		// perhaps even, list and store up to two key names.
		aBindings.Length		= aBindings.Length + 1;
		aBindings[iIter].win	= AddKeyWidget(aControls[iIter].strLabel, InputHelpPrefix$aControls[iIter].strLabel$InputHelpPostfix, F_FancyS, iIter);
//		Log("Iter:"@iIter@"Control:"@aControls[iIter].strAlias@aControls[iIter].strLabel);
	}

	// 02/02/03 JMI Add column headers.  Now that we solved the editbox height problem, we have more vertical room.
	if (aControls.Length > 0 && aBindings[0].win != none)
	{
		for (iIter = 0; iIter < aBindings[0].win.aInputs.Length; iIter++)
		{
			chHeader = ShellMenuChoice(CreateWindow(
				class'ShellMenuChoice', 
				aBindings[0].win.WinLeft + aBindings[0].win.aInputs[iIter].WinLeft,	
				aBindings[0].win.WinTop  + aBindings[0].win.aInputs[iIter].WinTop - (ItemHeight + ItemSpacingY), 
				aBindings[0].win.aInputs[iIter].WinWidth,	aBindings[0].win.aInputs[iIter].WinHeight) );
			
			chHeader.Align = TA_Center;
			chHeader.SetFont(ItemFont);
			chHeader.SetTextColor(ShellLookAndFeel(LookAndFeel).NormalTextColor);
			chHeader.SetText("Input"@(iIter + 1) );
			chHeader.bActive = false;
		}
	}

	// Load the values into the menu items.
	LoadValues();

	RestoreChoice	= AddChoice(RestoreText,	RestoreHelp,	ItemFont, ItemAlign);
	BackChoice		= AddChoice(BackText,		"",				ItemFont, ItemAlign, true);
	}

///////////////////////////////////////////////////////////////////////////////
// Trim the specified character from the ends of the string.
///////////////////////////////////////////////////////////////////////////////
function string Trim(string strSrc, string strRemove)
{
	local int iPos;
	local int iRemLen;

	iRemLen = Len(strRemove);

	// Pull occurences at beginning.
	while (Left(strSrc, iRemLen) == strRemove)
	{
		// Trim.
		strSrc = Right(strSrc, Len(strSrc) - iRemLen);
	}
	
	// Pull occurences at end.
	while (Right(strSrc, iRemLen) == strRemove)
	{
		// Trim.
		strSrc = Left(strSrc, Len(strSrc) - iRemLen);
	}

	return strSrc;
}

///////////////////////////////////////////////////////////////////////////////
// Split a string at a particular delimiter.
///////////////////////////////////////////////////////////////////////////////
function array<string> Split(string strSplit, string strDelimiter)
{
	local int iNext;
	local int iLen;
	local int iIter;
	local int iDelimLen;
	local array<string> astr;

	iNext = 0;
	iIter = 0;
	iDelimLen = Len(strDelimiter);
	do 
	{
		// Find next delimiter.
		iNext = InStr(strSplit, strDelimiter);
		if (iNext > -1) 
			iLen = iNext;
		else
			iLen = Len(strSplit);
		// Copy up to that spot into a new entry in the array.
		astr.Length = iIter + 1;
		astr[iIter] = Trim(Left(strSplit, iLen), " ");
		iIter = astr.Length;
		// Pull out that string + the delim.
		strSplit = Right(strSplit, Len(strSplit) - iLen - iDelimLen);
	} until (iNext == -1);

	return astr;
}

///////////////////////////////////////////////////////////////////////////////
// Remove all known inputs from the specified string.  This allows us to keep
// a base line set of unknown inputs that we can be sure to maintain while
// changing key mappings.
///////////////////////////////////////////////////////////////////////////////
function string RemoveKnownInputs(string strInputs, out array<Control> aControls)
{
	local int			iInput;
	local int			iCtrl;
	local bool			bFound;
	local array<string> astrInputs;

	astrInputs = Split(strInputs, "|");

	strInputs = "";	// Reset the string.

	// Reconstruct the string with only the ones we do -not- recognize.
	for (iInput = 0; iInput < astrInputs.Length; iInput++)
	{
		bFound = false;
		for (iCtrl = 0; iCtrl < aControls.Length && !bFound; iCtrl++)
		{
			bFound = (astrInputs[iInput] ~= aControls[iCtrl].strAlias);
		}

		// If not found, keep it.
		if (!bFound)
		{
			// If there's already something there, use a delimiter.
			if (Len(strInputs) > 0)
				strInputs = strInputs $ " | ";
			strInputs = strInputs $ astrInputs[iInput];
		}
	}

	return strInputs;
}

///////////////////////////////////////////////////////////////////////////////
// Add/Set a key to the specified binding.
///////////////////////////////////////////////////////////////////////////////
function SetKey(out Binding bind, int iKey, int iColumn)	// iColumn = -1 to add
{
	local int iCur;

	if (iColumn == -1)
	{
		// Get current number of elements.
		iCur					= bind.aiKeys.Length;
		// 01/15/03 JMI It seems that indexing an array with a value greater than
		//				its Length as a lhs automagically increases the size and,
		//				therefore, it seems the below length adjustments are not
		//				necessary.
		// Adjust arrays' lengths.
		// bind.aiKeys.Length	= iCur + 1;
		// bind.astrKeys.Length	= bind.aiKeys.Length;
	}
	else
		iCur					= iColumn;

	// Store bindings.
	bind.aiKeys[iCur]		= iKey;
	bind.astrKeys[iCur]		= GetKeyName(iKey);
}

///////////////////////////////////////////////////////////////////////////////
// Unload value.
///////////////////////////////////////////////////////////////////////////////
function UnloadValue(out Binding bind)
{
	bind.aiKeys.Length = 0;
	bind.astrKeys.Length = 0;
}

///////////////////////////////////////////////////////////////////////////////
// Unload all values.
///////////////////////////////////////////////////////////////////////////////
function UnloadValues()
{
	local int iIter;
	for (iIter = 0; iIter < aBindings.Length; iIter++)
	{
		UnloadValue(aBindings[iIter] );
	}
}

///////////////////////////////////////////////////////////////////////////////
// Load a value from ini file
///////////////////////////////////////////////////////////////////////////////
function LoadValue(Control ctrl, out Binding bind)
{
	local int		iIter;
	local int		iKey;
	
	// Start each element clean.
	UnloadValue(bind);

	// Store the control alias.
	bind.ctrl = ctrl;
	
	// For each command, we ask for the key mapped to the command passing an enumerator
	// until the function returns 0.
	iIter = 0;
	//while( GetCommandKey( ctrl.strAlias, key, strKey, iIter ) ) 
	do
	{
		iKey = int(GetPlayerOwner().ConsoleCommand("BINDING2KEYVAL \""$ctrl.strAlias$"\""@iIter) );
		if (iKey != 0)
		{
			SetKey(bind, iKey, -1);
		}
		
		iIter++;
	} until (iKey == 0);
}

///////////////////////////////////////////////////////////////////////////////
// Load the binding info into existing menu items.
///////////////////////////////////////////////////////////////////////////////
function LoadValues()
{
	local array<Control>			aControls;
	local int						iIter;
	local int						iKey;
	
	aControls = GetControls();
	
	aBaselines.Length = c_NumKeys;
	// Remember input values that we do not understand for each key they are mapped to.
	for (iIter = 0; iIter < aBaselines.Length; iIter++)
	{
		aBaselines[iIter] = GetPlayerOwner().ConsoleCommand("KEYBINDING"@GetKeyName(iIter) );
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aActionControls  );
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aDisplayControls );
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aInvControls     );
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aMiscControls    );
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aMovementControls);
		aBaselines[iIter] = RemoveKnownInputs(aBaselines[iIter], aWeaponControls  );
	}

	for (iIter = 0; iIter < aControls.Length; iIter++)
	{
		LoadValue(aControls[iIter], aBindings[iIter] );
		// 01/22/03 JMI Sort keys in order by defaults so they appear in a more
		//				intelligible order with respect to other keys in the
		//				same variation (they'll be aligned in columns).
		SortKeysByDefaults(aBindings[iIter] );

		ShowKeyStrs(aBindings[iIter] );
	}
}

///////////////////////////////////////////////////////////////////////////////
// Set all values to defaults.
// NOTE: aBaselines should already be setup.  Cannot see how that could not 
// happen but just in case.
///////////////////////////////////////////////////////////////////////////////
function SetDefaultValues()
{
	local int iIter;
	local int iDef;
	for (iIter = 0; iIter < aBindings.Length; iIter++)
	{
		// Clear the existing values.
		ClearValue(aBindings[iIter] );
		// Unload them.
		UnloadValue(aBindings[iIter] );

		// Load new ones from defaults.
		for (iDef = 0; iDef < Defaults.Length; iDef++)
		{
			// If this matches this binding, add it.
			if (Defaults[iDef].alias == aBindings[iIter].ctrl.strAlias)
				SetKey(aBindings[iIter], GetKey(Defaults[iDef].key), -1);
		}

		// Set these values as they're otherwise never reflected in the INI since there's
		// no final OK or Done.
		SetValue(aBindings[iIter] );
		// 01/22/03 JMI Sort keys in order by defaults so they appear in a more
		//				intelligible order with respect to other keys in the
		//				same variation (they'll be aligned in columns).
		SortKeysByDefaults(aBindings[iIter] );

		ShowKeyStrs(aBindings[iIter] );
	}

	// Play big sound when done so we know it finished.
	LookAndFeel.PlayBigSound(self);
}

///////////////////////////////////////////////////////////////////////////////
// Find the specified key in the given array.
///////////////////////////////////////////////////////////////////////////////
function int FindStr(out array<string> astrs, string str)
{
	local int iIter;
	for (iIter = 0; iIter < astrs.Length; iIter++)
	{
		if (astrs[iIter] == str)
			return iIter;
	}
	return -1;
}

///////////////////////////////////////////////////////////////////////////////
// Sort the key strings in the order the defaults are presented.  This helps
// to show the various schemes in common columns making them more recognizable.
// 01/22/03 JMI Started.
///////////////////////////////////////////////////////////////////////////////
function SortKeysByDefaults(out Binding bind)
{
	local int iCatPos;
	local int iDef;
	local int iKeyPos;
	local int iKeyTemp;

	// If there are no categories, this would probably be pointless.
	if (Categories.Length > 0)
	{
		// First, find the defaults for this input.
		for (iDef = 0; iDef < Defaults.Length; iDef++)
		{
			// If this matches this binding . . .
			if (Defaults[iDef].alias == bind.ctrl.strAlias)
			{
				// If we have this key mapped . . .
				iKeyPos = FindStr(bind.astrKeys, Defaults[iDef].key);
				if (iKeyPos >= 0)
				{
					// 02/05/03 JMI Now find the position of the category for this key.
					iCatPos = FindStr(Categories, Defaults[iDef].cat);
					if (iCatPos >= 0)
					{
						// Move the key from its current position to the position of this default relative to
						// other deafults for this same alias.
						iKeyTemp	= bind.aiKeys[iKeyPos];

						// Note that we already know that iKeyPos is less than the array length b/c we found
						// this key in that array.
						if (bind.astrKeys.Length <= iCatPos)
						{
							// No swapping necessary but let's keep it simple and just increase the size
							// and perform the normal code.
							bind.astrKeys.Length = iCatPos + 1;
							bind.aiKeys.Length   = iCatPos + 1;
						}
						
						bind.astrKeys[iKeyPos]	= bind.astrKeys[iCatPos];
						bind.aiKeys[iKeyPos]	= bind.aiKeys[iCatPos];
						
						bind.astrKeys[iCatPos]	= Defaults[iDef].key;
						bind.aiKeys[iCatPos]	= iKeyTemp;
					}
					else
						Log(self@"discovered default whose category, \""$Defaults[iDef].cat$"\", is not in the array of categories.");
				}
			}
		}
	}
//	else
//		Log(self@"discovered there are no entries in the array of categories.");
}

///////////////////////////////////////////////////////////////////////////////
// Set key string into the corresponding control. 
// 01/14/03 JMI Changed to set the value in the specified input control.
///////////////////////////////////////////////////////////////////////////////
function ShowKeyStr(Binding bind, int iInput)
{
	local string strKey;
	if (iInput >= 0 && iInput < bind.astrKeys.Length)
		strKey = bind.astrKeys[iInput];

	bind.win.SetValue(iInput, strKey);
}

///////////////////////////////////////////////////////////////////////////////
// Set key strings into each corresponding control. 
// 01/14/03 JMI Changed to update a set number of fields rather than just the
// number of inputs.
///////////////////////////////////////////////////////////////////////////////
function ShowKeyStrs(out Binding bind)
{
	local int iIter;

	for (iIter = 0; iIter < bind.win.c_iNumInputsPerControl; iIter++)
	{
		ShowKeyStr(bind, iIter);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Make a group of bound keys into a string.
///////////////////////////////////////////////////////////////////////////////
function string MakeKeyStr(Binding bind)
{
	local int iIter;
	local string str;
	for (iIter = 0; iIter < bind.astrKeys.Length; iIter++)
	{
		if (iIter > 0)
		{
			if (iIter < bind.astrKeys.Length - 1)
				str = str $ ", ";
			else
				str = str $ " or ";
		}

		str = str $ bind.astrKeys[iIter];
		// 12/05/02 JMI If there's another mapping outside this menu, show it.  
		// This might be weird.  Added it for debugging and thought it was a nice
		// thing for the user to be aware of--it's just not obvious what this 
		// means so it might be confusing to the user.
		if (Len(aBaseLines[bind.aiKeys[iIter] ] ) > 0)
			str = str@"("$aBaselines[bind.aiKeys[iIter] ]$")";
	}
	return str;
} 

///////////////////////////////////////////////////////////////////////////////
// Set the stored value.
///////////////////////////////////////////////////////////////////////////////
function SetValue(out Binding bind)
{
	local string strAliases;
	local int	 iIter;
	for (iIter = 0; iIter < bind.astrKeys.Length; iIter++)
	{
		if (Len(bind.astrKeys[iIter] ) > 0)
		{
			// Start with baseline (keys we don't know about in this menu), if any.
			strAliases = aBaselines[bind.aiKeys[iIter] ];
			// If there's anything so far, use a delimiter.
			if (Len(strAliases) > 0)
				strAliases = strAliases $ " | ";
			strAliases = strAliases $ bind.ctrl.strAlias;

			GetPlayerOwner().ConsoleCommand("SET Input"@bind.astrKeys[iIter]@strAliases);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Clear the stored value for this key.
///////////////////////////////////////////////////////////////////////////////
function ClearKey(string strKey, int iKey)
{
	// 01/15/03 JMI Addition of use of -1 to indicate a no-key state (instead
	//				removing entries) was causing an array-out-of-bounds here.
	//				Added check.
	if (iKey >= 0)
		GetPlayerOwner().ConsoleCommand("SET Input"@strKey@aBaseLines[iKey] );
}

///////////////////////////////////////////////////////////////////////////////
// Clear the stored keys for this input.
///////////////////////////////////////////////////////////////////////////////
function ClearValue(out Binding bind)
{
	local int iIter;
	for (iIter = 0; iIter < bind.astrKeys.Length; iIter++)
	{
		ClearKey(bind.astrKeys[iIter], bind.aiKeys[iIter] );
	}
}

///////////////////////////////////////////////////////////////////////////////
// Set the stored values.
///////////////////////////////////////////////////////////////////////////////
function SetValues()
{
	local int						iIter;
	for (iIter = 0; iIter < aBindings.Length; iIter++)
	{
		SetValue(aBindings[iIter]);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Remove the key from the specified binding.
// 01/14/03 JMI Changed to simply replace the specified key with nothing rather
//				than reduce the size of the array.
///////////////////////////////////////////////////////////////////////////////
function RemoveBinding(out Binding bind, EInputKey key)
{
	local int			iKey;
	local bool			bChanged;

	bChanged = false;
	for (iKey = 0; iKey < bind.aiKeys.Length; iKey++)
	{
		// If this is the key we want to remove, blank it out.
		if (bind.aiKeys[iKey] == key)
		{
			// Clear the corresponding key.
			ClearKey(bind.astrKeys[iKey], bind.aiKeys[iKey] );
			SetKey(bind, -1, iKey);
			bChanged = true;
		}
	}

	// If we made any changes, update the UI.
	if (bChanged)
		// Update UI.
		ShowKeyStrs(bind);
}

///////////////////////////////////////////////////////////////////////////////
// Remove the key from all existing bindings.
///////////////////////////////////////////////////////////////////////////////
function RemoveBindings(EInputKey key)
{
	local int		iBinding;
	// Check for existing instances of this value.
	for (iBinding = 0; iBinding < aBindings.Length; iBinding++)
	{
		RemoveBinding(aBindings[iBinding], key);
	}

}

///////////////////////////////////////////////////////////////////////////////
// Get the name of the specified key.
///////////////////////////////////////////////////////////////////////////////
function string GetKeyName(int iKey)
{
	return GetPlayerOwner().ConsoleCommand("KEYNAME"@iKey);
}

///////////////////////////////////////////////////////////////////////////////
// Find a key from a name.  This is not fast but is only done for the number
// of inputs on this menu and when "Restore" is chosen.
///////////////////////////////////////////////////////////////////////////////
function int GetKey(string strKey)
{
	local int iKey;

	for (iKey = 0; iKey < 255; iKey++)
	{
		if (GetKeyName(iKey) == strKey)
			return iKey;
	}

	return -1;
}

///////////////////////////////////////////////////////////////////////////////
// Add a key to the specified binding.
///////////////////////////////////////////////////////////////////////////////
function SetBinding(int iBindIndex, EInputKey key, int iColumn)	// iColumn = -1 to add
{
	local Binding	bind;
	local int		iIter;
	if (iBindIndex >= aBindings.Length)
		return ;
	
	// Alias for convenience.
	bind	     = aBindings[iBindIndex];
	
	// Check for existing instance of this value.
	for (iIter = 0; iIter < bind.aiKeys.Length; iIter++)
	{
		// This key is already there.
		if (bind.aiKeys[iIter] == key)
			return ;
	}

	// Remove this key from all its existing bindings.
	RemoveBindings(key);

	// Clear the existing key in this slot.
	if (iColumn >= 0 && iColumn < bind.astrKeys.Length)	// -1 indicates an add so we aren't overwriting any keys.
	{
		// 02/01/03 JMI Added clearing of existing key.  Although, we were removing it from our structures
		//				we were not actually clearing the value in the Engine/INI so the key would remain.
		//				We are doing this in RemoveBindingForWidget so not sure why I missed this case.
		ClearKey(bind.astrKeys[iColumn], bind.aiKeys[iColumn] );
	}

	// Set the key.
	SetKey(bind, key, iColumn);

	// Update UI.
	ShowKeyStrs(bind);

	// Update global.  Yeah, this is ridiculous.
	aBindings[iBindIndex] = bind;

	// Update binding right away.  Normally, we'd wait until the menu exits 
	// but I cannot see how we hook that--we used to have an OnChoice but I
	// cannot find that.  This could be fine but it means no canceling.
	SetValue(bind);
}

///////////////////////////////////////////////////////////////////////////////
// Activate a control to scan for input.
///////////////////////////////////////////////////////////////////////////////
function SetNewBindingTarget(ShellInputControl ctrl)
{
	// If there's an existing ctrl, tell it to exit the mode.
	if (winFocused != none)
	{
		winFocused.SetTargetStatus(winFocused.iCurCtrl, false);
		winFocused.Select(winFocused.iCurCtrl, false);
		// Take the focus away.
		BackChoice.FocusWindow();
		// Make sure to show the key.
		ShowKeyStrs(aBindings[winFocused.iBindIndex] );
	}

	// Set new target, if any.
	winFocused = ctrl;
	
	// If there's a new ctrl, tell it to enter the mode.
	if (winFocused != none)
	{
		winFocused.SetTargetStatus(winFocused.iCurCtrl, true);
		winFocused.SetValue(ctrl.iCurCtrl, c_strActivelyAcquiringText);
		// 12/03/02 JMI Changed to using bAllSelected directly (instead of SelectAll() )
		//				b/c we changed the fields to non-editable.
		winFocused.Select(ctrl.iCurCtrl, true);	
	}

}

///////////////////////////////////////////////////////////////////////////////
// Remove all bindings from the input controlled by the specified
// binding/control index.
///////////////////////////////////////////////////////////////////////////////
function RemoveAllBindingsForInput(int iBindIndex)
{
	if (iBindIndex >= aBindings.Length)
		return;

	// Clear the stored value.
	ClearValue(aBindings[iBindIndex] );

	// Just empty the arrays and update the fields.
	aBindings[iBindIndex].aiKeys.Length		= 0;
	aBindings[iBindIndex].astrKeys.Length	= 0;
	
	// Update UI.
	ShowKeyStrs(aBindings[iBindIndex] );
}

///////////////////////////////////////////////////////////////////////////////
// Remove all bindings from the input referred to by the specified widget.
///////////////////////////////////////////////////////////////////////////////
function RemoveAllBindingsForWidget(ShellInputControl ctrl)
{
	if (ctrl == none)
		return;

	RemoveAllBindingsForInput(ctrl.iBindIndex);
}

function RemoveBindingForWidget(ShellInputControl ctrl)
{
	local int iBindIndex;
	local int iCurCtrl;
	if (ctrl == none)
		return;

	iBindIndex	= ctrl.iBindIndex;
	iCurCtrl	= ctrl.iCurCtrl;
	if (iCurCtrl >= 0 && iCurCtrl < aBindings[iBindIndex].aiKeys.Length )
	{
		// Clear the corresponding key.
		ClearKey(aBindings[iBindIndex].astrKeys[iCurCtrl], aBindings[iBindIndex].aiKeys[iCurCtrl] );
		// Clear the corresponding entries in our arrays.
		// An alternative here would be to clear the values but keep them in the array so we could
		// have an empty entry that might be more intuitive to the user.
		// 01/14/03 JMI Changed to simply change the key to an empty value.
		aBindings[iBindIndex].aiKeys[iCurCtrl]		= -1;
		aBindings[iBindIndex].astrKeys[iCurCtrl]	= "";
		
		// Update UI.
		ShowKeyStrs(aBindings[iBindIndex] );

		// Audible feedback.
		LookAndFeel.PlaySmallSound(self);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Handle a key event
///////////////////////////////////////////////////////////////////////////////
function bool KeyEvent( out EInputKey Key, out EInputAction Action, FLOAT Delta )
{
	local bool bRes;
	local string strKey;
	
	bRes = false;

	if (Action == IST_Release 
	// NPF--terrible hack to make joysticks work. I hate,hate,hate joysticks for use with
	// an FPS, so I figured it was a good fit. If someone else wants to dress this up all nice--be my guest.
	// Basically buttons don't say 'release'--they only say 'press'. That's what this does.
		|| (Action == IST_Press 
			&& ((Key >=IK_Joy1 && Key <=IK_Joy16)
				|| (Key >=IK_JoyU && Key <=IK_JoySlider2)
				|| (Key >=IK_JoyX && Key <=IK_JoyR))))
	{
		if (winFocused != none)
		{
			switch (Key)
			{
			case IK_Escape:
				// Just cancel the mode and play a sound.
				LookAndFeel.PlaySmallSound(self);
				break;
			default:
				LookAndFeel.PlayBigSound(self);
				SetBinding(winFocused.iBindIndex, Key, winFocused.iCurCtrl);
				break;
			}

			bRes = true;				// Absorb key.
			SetNewBindingTarget(none);	// End this mode.

//			Log("MenuEditControl:KeyEvent(): Got key"@Key@"named"@strKey@"on action"@Action);
		}
	}

	// If we don't want the key, our Super might.
	if (bRes == false)
		bRes = Super.KeyEvent(Key, Action, Delta);

	return bRes;
}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	Super.Notify(C, E);
	switch (E)
		{
		case DE_Click:
			switch (C)
				{
				case BackChoice:
					GoBack();
					break;
				case RestoreChoice:
					SetDefaultValues();
					break;
				default:
					SetNewBindingTarget(ShellInputControl(C) );
					break;
				}
			break;
		case DE_RClick:
			// 11/27/02 JMI Remove the binding with a right click.
			if (winFocused == none)
			{
				// Note that here we set the new target and relinquish it in
				// one swoop for both feedback and functionality.  There's
				// focus handling in here that gets us free management and
				// I was hoping the text would select and appear to flash
				// before going away to help the user see what happened.
				SetNewBindingTarget(ShellInputControl(C) );
				SetNewBindingTarget(none);
				// Actually remove the binding.
				RemoveBindingForWidget(ShellInputControl(C) );
			}
			break;
		case DE_MouseLeave:
			switch (C)
				{
				case BackChoice:
				case RestoreChoice:
					break;
				default:
					// 11/27/02 JMI I noticed that The Army Game ends the input acquistion
					//				mode if the mouse leaves the area.  Not sure if I think
					//				that's useful.
					SetNewBindingTarget(none);	// End this mode.
					break;
				}
			break;
		case DE_MouseEnter:
			// 12/03/02 JMI Guess we should consider entering another GUI the same as exiting.
			if (C != winFocused)
				SetNewBindingTarget(none);	// End this mode.
			break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Get the controls to be edited.  Defined by derived class.
///////////////////////////////////////////////////////////////////////////////
function array<Control> GetControls();

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	// Need more room given the edit control.
	ItemHeight	 = 20;
	ItemSpacingY = 1;
	// Need more width for items.
	MenuWidth	= 640;	// 01/15/03 JMI Increased to try to make 3 inputs fit.
	HintLines	= 3;
	BorderLeft	= 5;	// 01/19/03 JMI Override for more room.
	BorderRight = 5;	// 01/19/03 JMI Override for more room.
	// 02/02/03 JMI More room between the title and the text for col headers.
	TitleSpacingY = 21;	// The size of the col headers plus spacing.

	bBlockConsole=true

	InputHelpPrefix = "Inputs mapped to ";
	InputHelpPostfix = ".  Left mouse click to add an input; Right mouse click to clear";

	// Action Controls //
	aActionControls[0] = (strLabel="Empty Hands",strAlias="ToggleToHands")
    aActionControls[1] = (strLabel="Crouch",strAlias="Duck")
    aActionControls[2] = (strLabel="Jump",strAlias="Jump")
	aActionControls[3] = (strLabel="Kick",strAlias="DoKick")	// 01/15/03 JMI Changed Kick to DoKick.
	aActionControls[4] = (strLabel="Unzip/Zip Pants",strAlias="UseZipper")
	aActionControls[5] = (strLabel="Commit Suicide",strAlias="Suicide")
	aActionControls[6] = (strLabel="Yell 'Get Down'",strAlias="GetDown")

	// Display Controls //
	aDisplayControls[0] = (strLabel="Gamma",strAlias="GammaUp")			// 01/15/03 JMI Changed "GammaChange" to "GammaUp".
	aDisplayControls[1] = (strLabel="Brightness",strAlias="BrightnessUp")	// 01/15/03 JMI Changed "BrightnessChange" to "BrightnessUp".
	aDisplayControls[2] = (strLabel="More HUD",strAlias="GrowHUD")			// 01/15/03 JMI Capitalized "HUD".
	aDisplayControls[3] = (strLabel="Less HUD",strAlias="ShrinkHUD")		// 01/15/03 JMI Capitalized "HUD".
	aDisplayControls[4] = (strLabel="Toggle Weapon/Inv Hints",strAlias="ToggleInvHints")

	// Inventory Controls //
	aInvControls[0] = (strLabel="Use Item",strAlias="InventoryActivate")
	aInvControls[1] = (strLabel="Drop Item",strAlias="ThrowPowerup")
	aInvControls[2] = (strLabel="Next Item",strAlias="InventoryNext")
	aInvControls[3] = (strLabel="Previous Item",strAlias="InventoryPrevious")
	aInvControls[4] = (strLabel="Show Map",strAlias="QuickUseMap")
	aInvControls[5] = (strLabel="Quick Health",strAlias="QuickHealth")

	// Misc Controls //
	aMiscControls[0] = (strLabel="Screenshot",strAlias="shot")
	aMiscControls[1] = (strLabel="Shrink HUD",strAlias="ShrinkHUD")
	aMiscControls[2] = (strLabel="Grow HUD",strAlias="GrowHUD")
	aMiscControls[3] = (strLabel="Type",strAlias="Type")
	aMiscControls[4] = (strLabel="Console",strAlias="ConsoleToggle")
	aMiscControls[5] = (strLabel="Talk (Say)",strAlias="Talk")
	aMiscControls[6] = (strLabel="Team Talk (Team Say)",strAlias="TeamTalk")
	aMiscControls[7] = (strLabel="Scoreboard",strAlias="ShowScores")
	aMiscControls[8] = (strLabel="Scoreboard toggle",strAlias="ScoreToggle")

	// Movement Controls //
    aMovementControls[0]  = (strLabel="Forward",strAlias="MoveForward")
    aMovementControls[1]  = (strLabel="Backward",strAlias="MoveBackward")
    aMovementControls[2]  = (strLabel="Strafe Left",strAlias="StrafeLeft")
    aMovementControls[3]  = (strLabel="Strafe Right",strAlias="StrafeRight")
    aMovementControls[4]  = (strLabel="Walk",strAlias="Walking")
    aMovementControls[5]  = (strLabel="Strafe Toggle",strAlias="Strafe")
    aMovementControls[6]  = (strLabel="Turn Right",strAlias="TurnLeft")
    aMovementControls[7]  = (strLabel="Turn Left",strAlias="TurnRight")
    aMovementControls[8]  = (strLabel="Look Up",strAlias="LookUp")
    aMovementControls[9]  = (strLabel="Look Down",strAlias="LookDown")
    aMovementControls[10] = (strLabel="Center View",strAlias="CenterView")
	
	// Weapon Controls //
	aWeaponControls[0] = (strLabel="Primary Fire",strAlias="Fire")
	aWeaponControls[1] = (strLabel="Secondary Fire",strAlias="AltFire")
	aWeaponControls[2] = (strLabel="Shocker,Baton,Shovel",strAlias="SwitchWeapon 1")
	aWeaponControls[3] = (strLabel="Pistol",strAlias="SwitchWeapon 2")
	aWeaponControls[4] = (strLabel="Shotgun",strAlias="SwitchWeapon 3")
	aWeaponControls[5] = (strLabel="Machine Gun",strAlias="SwitchWeapon 4")
	aWeaponControls[6] = (strLabel="Gas Can,Matches",strAlias="SwitchWeapon 5")
	aWeaponControls[7] = (strLabel="Grenade,Molotov,Scissors",strAlias="SwitchWeapon 6")
	aWeaponControls[8] = (strLabel="Cow Head",strAlias="SwitchWeapon 7")
	aWeaponControls[9] = (strLabel="Hunting Rifle",strAlias="SwitchWeapon 8")
	aWeaponControls[10] = (strLabel="Rocket Launcher",strAlias="SwitchWeapon 9")
	aWeaponControls[11] = (strLabel="Napalm Launcher",strAlias="SwitchWeapon 10")
	aWeaponControls[12] = (strLabel="Previous Weapon",strAlias="PrevWeapon")
	aWeaponControls[13] = (strLabel="Next Weapon",strAlias="NextWeapon")
	aWeaponControls[14] = (strLabel="Drop Weapon",strAlias="ThrowWeapon")
	}
