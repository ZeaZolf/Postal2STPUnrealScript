///////////////////////////////////////////////////////////////////////////////
// DaveController
// Copyright 2002 RWS, Inc.  All Rights Reserved.
//
// High-level RWS AI Controllers for Dave in a confession booth
//
///////////////////////////////////////////////////////////////////////////////
class DaveController extends BankTellerController;

///////////////////////////////////////////////////////////////////////////////
// Vars
///////////////////////////////////////////////////////////////////////////////
var bool bGotGift;

///////////////////////////////////////////////////////////////////////////////
// Const
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Don't worry about cutters
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state HandleCutter
{
Begin:
	// Set it back to our interest because we can't help him
	Focus = InterestPawn;
	GotoState(MyOldState);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// I've asked someone to walk over to me, so I'm waiting on them
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state NextCustomerWalkingToMe
{
Begin:
	if(CheckForCustomerStandTouch(InterestPawn))
		HandleThisPerson(P2Pawn(InterestPawn));

	// Gesture for them to come forward
	MyPawn.PlayHelloGesture(1.0);

	Sleep(10);
	PrintDialogue("I can help you over here "$Focus);

	GotoStateSave('WaitForCustomers', 'WaitForNextPerson');

	Goto('Begin');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Get someone to come to me
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state AskForNextCustomer
{
Begin:

SameCustomer:

OneCustomer:

ManyCustomers:
	bResetInterests=true;
	Sleep(10 + FRand()*10);
	GotoStateSave('WaitForCustomers', 'WaitForNextPerson');
}
/*
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// ExchangeWithDude
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state ExchangeWithDude
{
WatchForCustomerReturn:
	// assigns statecount, we can't change states in a function that returns a variable
	CheckForCustomerProx();
	if(statecount == 2)
		Goto('Begin'); // he's ready to buy things again
	else if(statecount == 1)
	{
		Cleanup();
		GotoStateSave('WaitForCustomers');// he's too far away, so just wait on other customers
	}
	Sleep(1.0);
	Goto('WatchForCustomerReturn');

Begin:
	SetupCustomer();

	// With these cashiers, you don't have to bring the product to them, you go to them
	// and ask for it. They give the product and you give them the money.
	bResetInterests=false;
	// Just talk to the dude, like normal
	GotoState('TakePaymentFromDude');
}
*/

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// DudeHasNoItem
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state DudeHasNoItem
{
Begin:
	if(!bGotGift)
	{
		if(CheckToGiggle())
			Sleep(SayTime);

		// dude says hi
		PrintDialogue(InterestPawn$" greeting ");
		TalkSome(CustomerPawn.myDialog.lGreeting, CustomerPawn,true);
		Sleep(SayTime);

		// Dave says hi
		TalkSome(MyPawn.myDialog.lGreeting,,true);
		PrintDialogue("Greeting");
		Sleep(SayTime);
	}
	else
		Sleep(0.0);

	// return to handling the cash register
	GotoState('WaitForCustomers');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// WaitOnDudeToPay
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state WaitOnDudeToPay
{
Begin:
	// dude says hi
	PrintDialogue(InterestPawn$" greeting ");
	TalkSome(CustomerPawn.myDialog.lGreeting, CustomerPawn,true);
	Sleep(SayTime);

	if(CheckToGiggle())
		Sleep(SayTime);

	// Dave says hi
	TalkSome(MyPawn.myDialog.lGreeting,,true);
	PrintDialogue("Greeting");
	Sleep(SayTime);

	// dude says here's your gift dave
	PrintDialogue(InterestPawn$" here's your gift dave");
	TalkSome(CustomerPawn.myDialog.lDude_GiveToUncleDave, CustomerPawn);
	Sleep(SayTime);

	// Wait on dude to pay you for the thing
	log("waiting on gift");
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// TakePaymentFromDude
// Dave is grateful for the gift
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state TakePaymentFromDude
{
Begin:
	// Dave says thanks
	PrintDialogue("Thanks!");
	TalkSome(MyPawn.myDialog.lThanks);
	Sleep(SayTime);

	FinishTransaction();

	// return to handling the cash register
	GotoState('WaitForCustomers');
}

defaultproperties
{
	InterestInventoryClass=class'GiftInv'
//	GameHint=""
}