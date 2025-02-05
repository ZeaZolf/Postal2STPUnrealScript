///////////////////////////////////////////////////////////////////////////////
// LibraryController
// Copyright 2002 RWS, Inc.  All Rights Reserved.
//
// Is a cashier but doesn't care as much when you attack people.
//
// Same as cashier, that you pay for a thing, but here you also give it to her
// with the money, instead of giving money, and leaving with an item.
//
///////////////////////////////////////////////////////////////////////////////
class LibraryController extends CitationController;

///////////////////////////////////////////////////////////////////////////////
// Vars
///////////////////////////////////////////////////////////////////////////////
// User set vars

// Internal vars

///////////////////////////////////////////////////////////////////////////////
// Const
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// Use this in the cinema to trigger her getting scared after you deal with her
///////////////////////////////////////////////////////////////////////////////
function Trigger( actor Other, Pawn EventInstigator )
{
	// make her run
	SetToPanic();	
	GotoNextState();
}

///////////////////////////////////////////////////////////////////////////////
// Ignores most everything she sees
///////////////////////////////////////////////////////////////////////////////
function ActOnPawnLooks(FPSPawn LookAtMe, optional out byte StateChange)
{
	return;
}

///////////////////////////////////////////////////////////////////////////////
// Decide what to do about this danger
///////////////////////////////////////////////////////////////////////////////
function GetReadyToReactToDanger(class<TimedMarker> dangerhere, 
								FPSPawn CreatorPawn, 
								Actor OriginActor,
								vector blipLoc,
								optional out byte StateChange)
{
	if(!MyPawn.bIgnoresSenses
		&& !MyPawn.bIgnoresHearing)
	{
		// Tell the danger maker to be quiet
		if(CreatorPawn != None)
		{
			InterestPawn = CreatorPawn;
			GotoStateSave('QuietYourInterest');
			StateChange=1;
			return;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Turn to your interest and tell them to be quiet
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state QuietYourInterest extends TalkingWithSomeoneMaster
{
Begin:
	Focus = InterestPawn;

	Sleep(FRand());

	// Tell them to be quiet
	PrintDialogue("ssshh");
	SayTime = Say(MyPawn.myDialog.lLibrarian_Quiet);
	Sleep(SayTime+FRand());
	GotoStateSave('Thinking');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// DecideToGetDown
// Doesn't put up with much crap
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state DecideToGetDown
{
Begin:
	GotoStateSave('QuietYourInterest');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// DudeHasInsufficientFunds
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state DudeHasNoFunds
{
	ignores CheckObservePawnLooks, MarkerIsHere;
Begin:
	if(CheckToGiggle())
		Sleep(SayTime);

	// cashier says hi
	TalkSome(MyPawn.myDialog.lGreeting,,true);
	PrintDialogue("Greeting");
	Sleep(SayTime);

	// dude says hi
	PrintDialogue(InterestPawn$" greeting ");
	TalkSome(CustomerPawn.myDialog.lGreeting, CustomerPawn,true);
	Sleep(SayTime);

	// lib says there's a late fee and how much it is
	statecount = GetTotalCostOfYourProducts(CustomerPawn, MyPawn);
	SayTime = Say(MyPawn.myDialog.lLibrarian_LateFee, bImportantDialog);
	PrintDialogue("the late fee is");
	Sleep(SayTime);
	SayTime = SayThisNumber(statecount,,bImportantDialog);
	PrintDialogue(statecount$" bucks");
	Sleep(SayTime + 0.1);
	if(statecount > 1)
		SayTime = Say(MyPawn.myDialog.lNumbers_Dollars, bImportantDialog);
	else

		SayTime = Say(MyPawn.myDialog.lNumbers_SingleDollar, bImportantDialog);
	Sleep(SayTime + FRand());

	// dude says something negative
	PrintDialogue(InterestPawn$" something negative ");
	TalkSome(CustomerPawn.myDialog.lNegativeResponseCashier, CustomerPawn);
	Sleep(SayTime);

	// she apologizes
	TalkSome(MyPawn.myDialog.lApologize);
	PrintDialogue("i'm sorry");
	Sleep(SayTime);

	// cashier ays hmmm
	PrintDialogue("hmmm");
	TalkSome(MyPawn.myDialog.lHmm);
	Sleep(SayTime);

	// say something mean
	TalkSome(MyPawn.myDialog.lLackOfMoney);
	Sleep(SayTime);
	PrintDialogue("Insufficient funds, buy something!");

	//lLackOfMoney

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
	ignores CheckObservePawnLooks, MarkerIsHere;
Begin:
	// lib says hi
	PrintDialogue("Greeting");
	TalkSome(MyPawn.myDialog.lGreeting,,true);
	Sleep(SayTime);

	// dude says hi
	PrintDialogue(InterestPawn$"Greeting");
	TalkSome(CustomerPawn.myDialog.lGreeting, CustomerPawn,true);
	Sleep(SayTime);

	// lib says there's a late fee and how much it is
	statecount = GetTotalCostOfYourProducts(CustomerPawn, MyPawn);
	SayTime = Say(MyPawn.myDialog.lLibrarian_LateFee, bImportantDialog);
	PrintDialogue("the late fee is");
	Sleep(SayTime);
	SayTime = SayThisNumber(statecount,,bImportantDialog);
	PrintDialogue(statecount$" bucks");
	Sleep(SayTime + 0.1);
	if(statecount > 1)
		SayTime = Say(MyPawn.myDialog.lNumbers_Dollars, bImportantDialog);
	else

		SayTime = Say(MyPawn.myDialog.lNumbers_SingleDollar, bImportantDialog);
	Sleep(SayTime + FRand());

	// dude says something negative
	PrintDialogue(InterestPawn$" something negative ");
	TalkSome(CustomerPawn.myDialog.lNegativeResponseCashier, CustomerPawn);
	Sleep(SayTime);

	// she apologizes
	TalkSome(MyPawn.myDialog.lApologize);
	PrintDialogue("i'm sorry");
	Sleep(SayTime);

	log("waiting on the book");
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// TakePaymentFromDude
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state TakePaymentFromDude
{
	ignores CheckObservePawnLooks, MarkerIsHere;

Begin:

	TalkSome(MyPawn.myDialog.lThanks);
	PrintDialogue("Thanks for the book and the money");
	Sleep(SayTime);

	// dude sort of says you're welcome
	if(FRand() <= 0.5)
	{
		PrintDialogue(InterestPawn$"dude you're welcome");
		TalkSome(CustomerPawn.myDialog.lPositiveResponse, CustomerPawn);
		Sleep(SayTime);
	}

	FinishTransaction();

	// return to handling the cash register
	GotoState('WaitForCustomers');
}



defaultproperties
{
	InterestInventoryClass=class'LibraryBookInv';
	CustomerDoesntBuy=0.0
}