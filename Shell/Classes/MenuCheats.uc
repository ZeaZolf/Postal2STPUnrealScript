///////////////////////////////////////////////////////////////////////////////
// MenuCheats.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The Cheats menu.
//
///////////////////////////////////////////////////////////////////////////////
class MenuCheats extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string CheatsTitleText;
var localized string CheatsExplainText;
var localized string CheatsExplainText2;
var ShellMenuChoice	 CheatsExplainChoice;
var ShellMenuChoice	 CheatsExplainChoice2;

var ShellMenuChoice	 NextChoice;

const CHEATS_MAX	    		  =10;	//MAKE THIS match the numbers below please!
var ShellMenuChoice	  CheatsChoice[10]; // Don't change this without changing the above
var localized string  CheatsText[10]; // Don't change this without changing the above
var localized string  CheatsHelp[10]; // Don't change this without changing the above

var int				  CustomMapWidth;
var int				  CustomMapHeight;

///////////////////////////////////////////////////////////////////////////////
// Create menu contents
///////////////////////////////////////////////////////////////////////////////
function CreateMenuContents()
	{
	local int i;

	Super.CreateMenuContents();
	
	ItemFont	= F_FancyM;
	ItemAlign = TA_Center;
	AddTitle(CheatsTitleText, TitleFont, TitleAlign);
	CheatsExplainChoice=AddChoice(CheatsExplainText, "", ItemFont, TitleAlign);
	CheatsExplainChoice.bActive=false;
	CheatsExplainChoice2=AddChoice(CheatsExplainText2, "", ItemFont, TitleAlign);
	CheatsExplainChoice2.bActive=false;

	for(i=0; i<CHEATS_MAX; i++)
	{
		CheatsChoice[i]		= AddChoice(CheatsText[i],	CheatsHelp[i],	ItemFont, ItemAlign);
	}

	NextChoice			= AddChoice(NextText, "", ItemFont, TitleAlign);
	BackChoice			= AddChoice(BackText, "", ItemFont, TitleAlign, true);

	// If you start up this menu, make sure to enable cheats for you
	GetPlayerOwner().ConsoleCommand("ForceSissy");
	}

///////////////////////////////////////////////////////////////////////////////
// Handle notifications from controls
///////////////////////////////////////////////////////////////////////////////
function Notify(UWindowDialogControl C, byte E)
	{
	Super.Notify(C, E);
	switch(E)
		{
		case DE_Click:
			if (C != None)
				switch (C)
					{
					case NextChoice:
						GotoMenu(class'MenuCheatsMore');
						break;
					case BackChoice:
						GoBack();
						break;
					case CheatsChoice[0]:
						GetPlayerOwner().ConsoleCommand(CheatsText[0]);
						break;
					case CheatsChoice[1]:
						GetPlayerOwner().ConsoleCommand(CheatsText[1]);
						break;
					case CheatsChoice[2]:
						GetPlayerOwner().ConsoleCommand(CheatsText[2]);
						break;
					case CheatsChoice[3]:
						GetPlayerOwner().ConsoleCommand(CheatsText[3]);
						break;
					case CheatsChoice[4]:
						GetPlayerOwner().ConsoleCommand(CheatsText[4]);
						break;
					case CheatsChoice[5]:
						GetPlayerOwner().ConsoleCommand(CheatsText[5]);
						break;
					case CheatsChoice[6]:
						GetPlayerOwner().ConsoleCommand(CheatsText[6]);
						break;
					case CheatsChoice[7]:
						GetPlayerOwner().ConsoleCommand(CheatsText[7]);
						break;
					case CheatsChoice[8]:
						GetPlayerOwner().ConsoleCommand(CheatsText[8]);
						break;
					case CheatsChoice[9]:
						GetPlayerOwner().ConsoleCommand(CheatsText[9]);
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
	ItemHeight	 = 25;
	MenuWidth	= 500
	HintLines	= 2
					
	CheatsTitleText = "Cheats"
	CheatsExplainText= "Click below to get the cheat,"
	CheatsExplainText2= "then resume the game to use it."

	CheatsText[0]	=	"PacknHeat"
	CheatsHelp[0]	=	"Gives you all weapons"

	CheatsText[1]	=	"Payload"
	CheatsHelp[1]	=	"Gives you lots of ammo"

	CheatsText[2]	=	"PiggyTreats"
	CheatsHelp[2]	=	"Gives you lots of doughnuts"

	CheatsText[3]	=	"JewsForJesus"
	CheatsHelp[3]	=	"Lots of money"

	CheatsText[4]	=	"BoyAndHisDog"
	CheatsHelp[4]	=	"Grants you lots of doggie treats"

	CheatsText[5]	=	"Jones"
	CheatsHelp[5]	=	"Lots of health pipes for you!"

	CheatsText[6]	=	"SwimWithFishes"
	CheatsHelp[6]	=	"Loads you up with Radar and thingies"

	CheatsText[7]	=	"FireInYourHole"
	CheatsHelp[7]	=	"Holy crap--a camera for my rockets! (Toggles)"

	CheatsText[8]	=	"IAmTheOne"
	CheatsHelp[8]	=	"Gives you lots of catnip"

	CheatsText[9]	=	"LotsaPussy"
	CheatsHelp[9]	=	"Cats, that is."
}
