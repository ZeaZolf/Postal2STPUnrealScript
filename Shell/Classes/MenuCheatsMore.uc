///////////////////////////////////////////////////////////////////////////////
// MenuCheatsMore.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// The More Cheats menu.
//
///////////////////////////////////////////////////////////////////////////////
class MenuCheatsMore extends ShellMenuCW;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

var localized string CheatsTitleText;
var localized string CheatsExplainText;
var localized string CheatsExplainText2;
var ShellMenuChoice	 CheatsExplainChoice;
var ShellMenuChoice	 CheatsExplainChoice2;

const CHEATS_MAX	    		  =10;	//MAKE THIS match the numbers below please!
var ShellMenuChoice	  CheatsChoice[10]; // Don't change this without changing the above
var localized string	CheatsText[10]; // Don't change this without changing the above
var localized string	CheatsHelp[10]; // Don't change this without changing the above

var int					CustomMapWidth;
var int					CustomMapHeight;

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

	BackChoice			= AddChoice(BackText, "", ItemFont, TitleAlign, true);
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
					
	CheatsTitleText = "More Cheats"
	CheatsExplainText= "Click below to get the cheat,"
	CheatsExplainText2= "then resume the game to use it."

	CheatsText[0]	=	"BlockMyAss"
	CheatsHelp[0]	=	"Grants you body armor"

	CheatsText[1]	=	"SmackDatAss"
	CheatsHelp[1]	=	"Gives you a gimp suit"

	CheatsText[2]	=	"IAmTheLaw"
	CheatsHelp[2]	=	"Gives you a police uniform"

	CheatsText[3]	=	"Whatchutalkinbout"
	CheatsHelp[3]	=	"Turns all bystanders into Garys"

	CheatsText[4]	=	"Osama"
	CheatsHelp[4]	=	"Turns all bystanders into Taliban"

	CheatsText[5]	=	"RockinCats"
	CheatsHelp[5]	=	"Shoot cats from gun--turns ON"

	CheatsText[6]	=	"DokkinCats"
	CheatsHelp[6]	=	"Shoot cats from gun--turns OFF"

	CheatsText[7]	=	"BoppinCats"
	CheatsHelp[7]	=	"Flying cats bounce off walls--turns ON"

	CheatsText[8]	=	"SplodinCats"
	CheatsHelp[8]	=	"Flying cats bounce off walls--turns OFF"

	CheatsText[9]	=	"HeadShots"
	CheatsHelp[9]	=	"People die with one bullet to the head (Toggles)"
}
