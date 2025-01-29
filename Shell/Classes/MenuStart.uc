///////////////////////////////////////////////////////////////////////////////
// MenuStart.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// Menu to force difficulty choice and to drive home the fact that it cannot be
// changed after a game is started--aren't all games this way?
//
///////////////////////////////////////////////////////////////////////////////
class MenuStart extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string	TitleText;

var ShellMenuChoice		StartChoice;

var bool bUpdate;


///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();
	
	AddTitle(TitleText, F_FancyXL, TA_Left);
	
	ItemFont = F_FancyL;
	DifficultyCombo = AddComboBox(DifficultyText, DifficultyHelp, ItemFont);
	DifficultyCombo.List.MaxVisible = ArrayCount(P2GameInfoSingle(GetPlayerOwner().Level.Game).DifficultyNames);
	StartChoice	= AddChoice(StartText,	"", ItemFont, TA_Left);
	BackChoice  = AddChoice(BackText,   "", ItemFont, TA_Left, true);
	
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
	local int i;
	local P2GameInfoSingle psg;

	psg = P2GameInfoSingle(GetPlayerOwner().Level.Game);
	
	// Controls will generate Notify() events when their values are updated, so we
	// use this flag to block the events from actually doing anything.  In other
	// words, we're only setting the initial values of the controls and we don't
	// want that to count as a change.
	bUpdate = False;
	
	if (DifficultyCombo != none)
		{
		DifficultyCombo.Clear();

		for(i=0; i<ArrayCount(psg.DifficultyNames); i++)
			DifficultyCombo.AddItem(psg.DifficultyNames[i]);

		val = int(GetPlayerOwner().ConsoleCommand("get"@c_strDifficultyPath));

		if(val > 0)
			DifficultyCombo.SetValue(psg.DifficultyNames[int(val)]);
		
		// Seems too wide on the text side.
		DifficultyCombo.EditBoxWidth = DifficultyCombo.WinWidth * 0.50;
		}
	bUpdate = True;
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	local int val;

	Super.Notify(C, E);
	switch(E)
		{
		case DE_Change:
			switch (C)
				{
				case DifficultyCombo:
					DiffChanged(bUpdate);
					break;
				}
			break;
		case DE_Click:
			switch (C)
				{
				case BackChoice:
					GoBack();
					break;
				case StartChoice:
					// No special explanation, get ready to play
					if(!P2GameInfo(GetPlayerOwner().Level.Game).TheyHateMeMode())
					{
						// Normal game start
						if(!ShellRootWindow(Root).bFixSave)
						{
							// Start new (enhanced) game (they already know about the keys)
							if(ShellRootWindow(Root).bVerified
								&& ShellRootWindow(Root).bVerifiedPicked)
								GetGameSingle().StartGame(true);
							else  // Normal game, tell them about the keys
								GotoMenu(class'MenuImageKeys');
						}
						else // Just return back to the game you were dealing with
							// But save the difficulty and the game first
						{
							ResumeGameSaveDifficulty();
						}
					}
					else
						GotoMenu(class'MenuTheyHateMe');

					ShellRootWindow(Root).bLaunchedMultiplayer = false;
					break;
				}
			break;
		}
	}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	TitleSpacingY = 30

	MenuWidth  = 375
	MenuHeight = 325
	ItemSpacingY = 15

	TitleText	= "Select Difficulty"
	}
