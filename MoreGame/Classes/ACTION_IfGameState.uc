///////////////////////////////////////////////////////////////////////////////
// ACTION_IfGameState.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Executes a section of actions only if the specified errand status is met.
//
//	History:
//		05/14/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class ACTION_IfGameState extends P2ScriptedAction;

enum ETest
	{
	ET_FirstLevelOfGame,
	ET_FirstLevelOfDay,
	ET_PlayerPickedNiceDude,
	ET_CurrentDay_Number,
	ET_ErrandCompleted_Name,
	ET_CurrentDay_Name,
	ET_ErrandActivated_Name,
	ET_CopsWantPlayer,
	ET_Apocalypse
	};

var(Action) ETest Test;
var(Action) bool Is;
var(Action) int Number;
var(Action) String Name;

function ProceedToNextAction(ScriptedController C)
	{
	local bool bResult;
	local P2GameInfoSingle game;

	game = P2GameInfoSingle(C.Level.Game);
	if(game != None)
		{
		switch (Test)
			{
			case ET_FirstLevelOfGame:
				bResult = (game.TheGameState.bFirstLevelOfGame == Is);
				break;

			case ET_FirstLevelOfDay:
				bResult = (game.TheGameState.bFirstLevelOfDay == Is);
				break;

			case ET_PlayerPickedNiceDude:
				bResult = (game.TheGameState.bNiceDude == Is);
				break;

			case ET_CurrentDay_Number:
				bResult = ((game.GetCurrentDay() == Number-1) == Is);
				break;

			case ET_CurrentDay_Name:
				bResult = (game.IsDay(Name) == Is);
				break;

			case ET_ErrandCompleted_Name:
				bResult = (game.IsErrandCompleted(Name) == Is);
				break;

			case ET_ErrandActivated_Name:
				bResult = (game.IsErrandActivate(Name) == Is);
				break;

			case ET_CopsWantPlayer:
				bResult = ((game.TheGameState.CopsWantPlayer() > 0) == Is);
				break;

			case ET_Apocalypse:
				bResult = (game.TheGameState.bIsApocalypse == Is);
				break;

			default:
				break;
			}
		}

	C.ActionNum += 1;
	if (!bResult)
		ProceedToSectionEnd(C);
	}

function bool StartsSection()
	{
	return true;
	}

function string GetActionString()
	{
	switch (Test)
		{
		case ET_FirstLevelOfGame:
			return ActionString@"check if bFirstLevelOfGame is "$Is;
			break;

		case ET_FirstLevelOfDay:
			return ActionString@"check if bFirstLevelOfDay is "$Is;
			break;

		case ET_PlayerPickedNiceDude:
			return ActionString@"check if bDudeIsGood is "$Is;
			break;

		case ET_CurrentDay_Number:
			return ActionString@"check if CurrentDay is "$Number;
			break;

		case ET_CurrentDay_Name:
			return ActionString@"check if CurrentDay is "$Name;
			break;

		case ET_ErrandCompleted_Name:
			return ActionString@"check if errand "$Name$" completed is "$Is;
			break;

		case ET_ErrandActivated_Name:
			return ActionString@"check if errand "$Name$" activated is "$Is;
			break;

		case ET_CopsWantPlayer:
			return ActionString@"check if cops wanting player is "$Is;
			break;

		case ET_Apocalypse:
			return ActionString@"check if bApocalypse is "$Is;
			break;

		default:
			break;
		}
	return ActionString@"unknown";
	}

defaultproperties
	{
	Is=true
	ActionString="If GameState: "
	bRequiresValidGameInfo=true
	}
