///////////////////////////////////////////////////////////////////////////////
// MenuError.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The error window for handling multiplayer errors.
//
// History:
//  10/02/03 CRK	Changed to a Windowed Box for errors.
//	08/20/03 CRK	Started it.
//
///////////////////////////////////////////////////////////////////////////////
class MenuError extends ShellMenuCW;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var string Msg1, Msg2;

var UWindowMessageBox ErrorMessageBox;
var bool bDontClose;					// when closing, dont let GoBack or Close get executed again
var bool bLocked;						// when true, dont make any other error boxes or change the error message until closed

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	Super.CreateMenuContents();

	GetPlayerOwner().ClearProgressMessages();
	ShellRootWindow(Root).bLaunchedMultiplayer = true;
	}

function SetupMessageBox(string Title, string Message)
{
	Msg1 = Title;
	Msg2 = Message;

	if(ErrorMessageBox != None)
	{
		bDontClose = true;
		ErrorMessageBox.Close();
		bDontClose = false;
	}

	if(Message ~= "")
	{
		Message = Title;
		Title = ErrorText;
	}

	ErrorMessageBox = MessageBox(Title, Message, MB_OK, MR_OK);
}

///////////////////////////////////////////////////////////////////////////////
// Callback for when error message box is done
///////////////////////////////////////////////////////////////////////////////
function MessageBoxDone(UWindowMessageBox W, MessageBoxResult Result)
{
	GoBack();
}

function HideWindow()
{
	Super.HideWindow();
	if(ErrorMessageBox != None && ErrorMessageBox.WindowIsVisible())
		ErrorMessagebox.HideWindow();
}

// Take user back to startup level, if not still in a game
function GoBack()
{
	local string CurrentLevel, GamePath;

	if(bDontClose)
		return;
	bDontClose = true;

	Log(Self $ " Closing and Cancelling");
	GetPlayerOwner().ConsoleCommand("MenuCancel");

	CurrentLevel = ShellRootWindow(Root).ParseLevelName(Root.GetLevel().GetLocalURL());
	if(Right(CurrentLevel, 4) ~= ".fuk")
		CurrentLevel = Left(CurrentLevel, Len(CurrentLevel) - 4);

	if(GetGameSingle() != None && Caps(CurrentLevel) != Caps("Startup"))	// SINGLEPLAYER
		GetGameSingle().QuitGame();
	else																	// MULTIPLAYER
		{
		if(CurrentLevel ~= "Entry" || CurrentLevel ~= "Index")
			{
			GetPlayerOwner().ConsoleCommand("disconnect");
			P2RootWindow(Root).HideMenu();
			// RWS FIXME: Read the game type value from ini
			GamePath = "GameTypes.GameSinglePlayer";
			GetPlayerOwner().ClientTravel("Startup.fuk?Game=" $ GamePath, TRAVEL_Absolute, false);
			}
		}
	P2RootWindow(Root).EnableMenu();
	Super.GoBack();
	bDontClose = false;
	Close();
}

function Close(optional bool bByParent)
{
	if(bDontClose)
		return;
	bDontClose = true;
	if(ErrorMessageBox != None)
	{
		ErrorMessageBox.Close(bByParent);
		ErrorMessageBox = None;
	}
	Super.Close(bByParent);
}
