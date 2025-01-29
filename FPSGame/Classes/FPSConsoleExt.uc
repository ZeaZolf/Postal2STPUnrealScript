///////////////////////////////////////////////////////////////////////////////
// FPSConsoleExt.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// Multi-line console.
//
///////////////////////////////////////////////////////////////////////////////
class FPSConsoleExt extends FPSConsole;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var globalconfig int			MaxScrollbackSize;

var array<string>				Scrollback;
var int							SBHead;
var int							SBPos;
var bool						bCtrl;
var bool						bConsoleKey;


///////////////////////////////////////////////////////////////////////////////
// Open, close and toggle the console
///////////////////////////////////////////////////////////////////////////////
exec function ConsoleOpen()
{
	if (IsConsoleAllowed())
	{
		TypedStr = "";
		GotoState('ConsoleVisible');
	}
}

exec function ConsoleClose()
{
	TypedStr="";
	if( GetStateName() == 'ConsoleVisible' )
		GotoState( '' );
}

exec function ConsoleToggle()
{
	if( GetStateName() == 'ConsoleVisible' )
		ConsoleClose();
	else
		ConsoleOpen();
}

///////////////////////////////////////////////////////////////////////////////
// Clear the screen (console)
///////////////////////////////////////////////////////////////////////////////
exec function CLS()
{
	SBHead = 0;
	ScrollBack.Remove(0,ScrollBack.Length);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function PostRender( canvas Canvas );	// Subclassed in state

///////////////////////////////////////////////////////////////////////////////
// Add messages to buffer
///////////////////////////////////////////////////////////////////////////////
event Message( coerce string Msg, float MsgLife)
{
	if (ScrollBack.Length==MaxScrollBackSize)	// if full, Remove Entry 0
	{
		ScrollBack.Remove(0,1);
		SBHead = MaxScrollBackSize-1;
	}
	else
		SBHead++;
	
	ScrollBack.Length = ScrollBack.Length + 1;
	
	Scrollback[SBHead] = Msg;
	Super.Message(Msg,MsgLife);
}

///////////////////////////////////////////////////////////////////////////////
// State for when console is visible
///////////////////////////////////////////////////////////////////////////////
state ConsoleVisible
{
	function bool KeyType( EInputKey Key, optional string Unicode )
	{
		local PlayerController PC;
		
		if (bIgnoreKeys || bConsoleKey)
			return true;
		
		if (ViewportOwner != none)
			PC = ViewportOwner.Actor;
		
		if (bCtrl && PC != none)
		{
			if (Key == 3) //copy
			{
				PC.CopyToClipboard(TypedStr);
				return true;
			}
			else if (Key == 22) //paste
			{
				TypedStr = TypedStr$PC.PasteFromClipboard();
				return true;
			}
			else if (Key == 24) // cut
			{
				PC.CopyToClipboard(TypedStr);
				TypedStr="";
				return true;
			}
		}
		
		if( Key>=0x20 )
		{
			if( Unicode != "" )
				TypedStr = TypedStr $ Unicode;
			else
				TypedStr = TypedStr $ Chr(Key);
			return( true );
		}
		
		return( true );
	}
	
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;
		
		if (!bGotKeyBindings)
			UpdateKeyBinding();

		if( Key==IK_Ctrl )
		{
			if (Action == IST_Press)
				bCtrl = true;
			else if (Action == IST_Release)
				bCtrl = false;
		}
		
		if (Action== IST_PRess)
		{
			bIgnoreKeys = false;
		}
		
		if(Key == ConsoleKey)
		{
			if(Action == IST_Press)
				bConsoleKey = true;
			else if(Action == IST_Release && bConsoleKey)
				ConsoleClose();
			return true;
		}
		else if (Key==IK_Escape)
		{
			if (Action==IST_Release)
			{
				if (TypedStr!="")
				{
					TypedStr="";
					HistoryCur = HistoryTop;
				}
				else
				{
					ConsoleClose();
					return true;
				}
			}
			return true;
		}
		else if( Action != IST_Press )
			return( true );
		
		else if( Key==IK_Enter )
		{
			if( TypedStr!="" )
			{
				// Print to console.
				
				History[HistoryTop] = TypedStr;
				HistoryTop = (HistoryTop+1) % ArrayCount(History);
				
				if ( ( HistoryBot == -1) || ( HistoryBot == HistoryTop ) )
					HistoryBot = (HistoryBot+1) % ArrayCount(History);
				
				HistoryCur = HistoryTop;
				
				// Make a local copy of the string.
				Temp=TypedStr;
				TypedStr="";
				
				if( !ConsoleCommand( Temp ) )
					Message( Localize("Errors","Exec","Core"), 6.0 );
				
				Message( "", 6.0 );
			}
			
			return( true );
		}
		else if( Key==IK_Up )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryBot)
					HistoryCur = HistoryTop;
				else
				{
					HistoryCur--;
					if (HistoryCur<0)
						HistoryCur = ArrayCount(History)-1;
				}
				
				TypedStr = History[HistoryCur];
			}
			return( true );
		}
		else if( Key==IK_Down )
		{
			if ( HistoryBot >= 0 )
			{
				if (HistoryCur == HistoryTop)
					HistoryCur = HistoryBot;
				else
					HistoryCur = (HistoryCur+1) % ArrayCount(History);
				
				TypedStr = History[HistoryCur];
			}
			
		}
		else if( Key==IK_Backspace || Key==IK_Left )
		{
			if( Len(TypedStr)>0 )
				TypedStr = Left(TypedStr,Len(TypedStr)-1);
			return( true );
		}
		
		else if ( Key==IK_PageUp || key==IK_MouseWheelUp )
		{
			if (SBPos<ScrollBack.Length-1)
			{
				if (bCtrl)
					SBPos+=5;
				else
					SBPos++;
				
				if (SBPos>=ScrollBack.Length)
					SBPos = ScrollBack.Length-1;
			}
			
			return true;
		}
		else if ( Key==IK_PageDown || key==IK_MouseWheelDown)
		{
			if (SBPos>0)
			{
				if (bCtrl)
					SBPos-=5;
				else
					SBPos--;
				
				if (SBPos<0)
					SBPos = 0;
			}
		}
		
		return( true );
	}

	function BeginState()
	{
		SBPos = 0;
		bVisible= true;
		bIgnoreKeys = true;
		bConsoleKey = false;
		HistoryCur = HistoryTop;
		bCtrl = false;
	}
	function EndState()
	{
		bVisible = false;
		bCtrl = false;
		bConsoleKey = false;
	}

	function PostRender( canvas Canvas )
	{
		
		local float fw,fh;
		local float yclip,y;
		local int idx;
		
		Canvas.Style = 5;	// STY_Alpha
		Canvas.Font	 = font'ConsoleFont';
		Canvas.bCenter = False;
		yclip = canvas.ClipY*0.5;
		Canvas.StrLen("X",fw,fh);
		
		Canvas.SetPos(0,0);
		Canvas.SetDrawColor(255,255,255,100);
		Canvas.DrawTile(texture 'ConsoleBk',Canvas.ClipX,yClip,0,0,32,32);
		
		Canvas.SetPos(0,yclip-1);
		Canvas.SetDrawColor(220,0,0,100);
		Canvas.DrawTile(texture 'ConsoleBdr',Canvas.ClipX,1,0,0,32,32);
		
		Canvas.Style = 1;	// STY_Normal
		Canvas.SetPos(0,yclip-5-fh);
		Canvas.SetDrawColor(255,255,255,255);
		Canvas.DrawText(">"@TypedStr$"_");
		
		idx = SBHead - SBPos;
		y = yClip-y-5-(fh*2);
		
		if (ScrollBack.Length==0)
			return;
		
		while (y>fh && idx>=0)
		{
			Canvas.SetPos(0,y);
			Canvas.DrawText(Scrollback[idx],false);
			idx--;
			y-=fh;
		}
	}
}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
{
	MaxScrollbackSize=128
}