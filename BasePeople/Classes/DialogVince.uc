///////////////////////////////////////////////////////////////////////////////
// DialogVince
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Dialog for Vince
//
//	History:
//		05/21/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class DialogVince extends DialogMale;


///////////////////////////////////////////////////////////////////////////////
// Fill in this character's lines
///////////////////////////////////////////////////////////////////////////////
function FillInLines()
	{
	// Let super go first
	Super.FillInLines();

	clear(lVince_Greeting);
	Addto(lVince_Greeting, 					"VinceDialog.vince_ayyy", 1);
	Addto(lVince_Greeting, 					"VinceDialog.vince_whatsup", 1);

	clear(lVince_GreetingResponse);
	Addto(lVince_GreetingResponse, 			"VinceDialog.vince_hey", 1);
	Addto(lVince_GreetingResponse, 			"VinceDialog.vince_heyman", 1);

	clear(lPositiveResponse);
	Addto(lPositiveResponse, 				"VinceDialog.vince_sure", 1);

	clear(lNegativeResponse);
	Addto(lNegativeResponse, 				"VinceDialog.vince_nah", 1);
	Addto(lNegativeResponse, 				"VinceDialog.vince_idontthinkso", 1);

	clear(lThanks);
	Addto(lThanks, 							"VinceDialog.vince_positive1", 1);
	Addto(lThanks, 							"VinceDialog.vince_positive2", 1);

	Clear(lGetDownMP);
	Addto(lGetDownMP, 						"VinceDialog.vince_stillaposition", 1);
	Addto(lGetDownMP, 						"VinceDialog.vince_somebodystole", 1);
	Addto(lGetDownMP, 						"VinceDialog.vince_youstillhere", 1);

	clear(lVince_Fired);
	Addto(lVince_Fired, 					"VinceDialog.vince_nothingpersonal", 1);
	
	clear(lVince_GetCheck);
	Addto(lVince_GetCheck, 					"VinceDialog.vince_getcheck", 1);
	
	Clear(lvince_insults);
	Addto(lvince_insults, 					"VinceDialog.vince_stillaposition", 1);
	Addto(lvince_insults, 					"VinceDialog.vince_somebodystole", 1);
	Addto(lvince_insults, 					"VinceDialog.vince_youstillhere", 1);

	Clear(lGotHealth);
	Addto(lGotHealth, 						"VinceDialog.vince_positive2", 1);

	Clear(lGotHealthFood);
	Addto(lGotHealthFood, 					"VinceDialog.vince_positive1", 1);

	Clear(lGotCrackHealth);
	Addto(lGotCrackHealth, 					"AmbientSounds.vinceAhuh", 1);

	Clear(lPissing);
	Addto(lPissing, 						"AmbientSounds.vinceAhuh", 1);

	Clear(lfollowme);
	Addto(lfollowme,						"VinceDialog.vince_ayyy", 1);

	Clear(lStayHere);
	Addto(lStayHere,						"VinceDialog.vince_heyman", 1);
	}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	}
