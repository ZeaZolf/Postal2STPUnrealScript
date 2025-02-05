///////////////////////////////////////////////////////////////////////////////
// HabibController
// Copyright 2002 RWS, Inc.  All Rights Reserved.
//
// Is a cashier but can attack and get mad.
//
///////////////////////////////////////////////////////////////////////////////
class HabibController extends CashierController;

///////////////////////////////////////////////////////////////////////////////
// Vars
///////////////////////////////////////////////////////////////////////////////
// User set vars

// Internal vars
//var bool bHasYelledWarCry;			// has already yelled his war cry.
///////////////////////////////////////////////////////////////////////////////
// Const
///////////////////////////////////////////////////////////////////////////////
const NEAR_REGISTER				=	1024;
const ACCOST_PEOPLE_LIKEIHOOD	=	0.4;


///////////////////////////////////////////////////////////////////////////////
// A person has stolen an item of this type, go get them
///////////////////////////////////////////////////////////////////////////////
function PersonStoleSomething(P2Pawn CheckP, OwnedInv owninv)
{
	SetAttacker(CheckP);
	MakeMoreAlert();

	bStolenFrom=true;

	// Attack the shop lifter!
	GotoStateSave('AssessAttacker');
}

///////////////////////////////////////////////////////////////////////////////
// Say various things during a fight
///////////////////////////////////////////////////////////////////////////////
function FightTalk()
{
	if(FRand() <= MyPawn.TalkWhileFighting)
	{
		if(bStolenFrom)
		{
			SayTime = Say(MyPawn.myDialog.lGettingRobbed, bImportantDialog);
		}
		else
		{
			SayTime = Say(MyPawn.myDialog.lWhileFighting, bImportantDialog);
		}
	}
	else
		SayTime=0;
}

/*
///////////////////////////////////////////////////////////////////////////////
// You've been attacked by the cops, but you have a compelling reason as
// to why they should attack someone else (like he stole from you)
///////////////////////////////////////////////////////////////////////////////
function ConvertCopsToHelp()
{
	local P2Pawn CheckP;
	local float dist;

	// Check all the pawns around me, and get authority figures to 
	// fight the 'bad guy'
	ForEach VisibleCollidingActors(class'P2Pawn', CheckP, VISUALLY_FIND_RADIUS, MyPawn.Location)
	{
		if(CheckP != MyPawn 
			&& CheckP != Attacker
			&& CheckP.Health > 0
			&& CheckP.Weapon != None
			&& CheckP.bAuthorityFigure
			&& PersonController(CheckP))
		{
			PersonController(CheckP).SetAttacker(Attacker);
			PersonController(CheckP).GotoStateSave('AssessAttacker');
		}
	}
}

///////////////////////////////////////////////////////////////////////////
// This is a seperate function so various states (like ProtestToTarget)
// can call this within the same class, and not call down to a super
// like in PersonController. 
///////////////////////////////////////////////////////////////////////////
function BystanderDamageAttitudeTo(pawn Other, float Damage)
{
	// Check if we get hit by cops or not. If so, tell them to fight
	// the postal dude
	Super.B
}
*/
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

	// cashier asks how to help you
	PrintDialogue("Is this everything?");
	TalkSome(MyPawn.myDialog.lIsThisEverything);
	Sleep(SayTime);
/*
	// dude says hi
	PrintDialogue(InterestPawn$" dude yes");
	SayTime = InterestPawn.Say(CustomerPawn.myDialog.lYes);
	Sleep(SayTime+FRand());
*/

	// cashier states how much it will be
	statecount = GetTotalCostOfYourProducts(CustomerPawn, MyPawn);
	// if there's no money then something's wrong, he doesn't have his item any more
	if(statecount == 0)
		GotoState('DudeHasNoItem');

	PrintDialogue("that'll be...");
	SayTime = Say(MyPawn.myDialog.lNumbers_Thatllbe, bImportantDialog);
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
	TalkSome(CustomerPawn.myDialog.lDude_GottaBeKidding, CustomerPawn);
	Sleep(SayTime);

	// Wait on dude to pay you for the thing
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
	// Wait for how naturally slow they react, plus how rebellious they are
	// Also, look to see who shouted it InterestPawn and decide to believe 
	// them or not
	Sleep(2.0);

	// now react to their looks
	ActOnPawnLooks(FPSPawn(Focus));

ScrewYou:
	PrintDialogue("Stop bothering me!");

	MyPawn.PlayTellOffAnim();
	
	// say something mean
	SayTime = Say(MyPawn.myDialog.lTrashTalk);
	Sleep(SayTime);

	if(Attacker != None)
		GotoStateSave('AssessAttacker');
	else
		GotoStateSave('Thinking');
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// AccostFocus
// This assumes the focus has been set to something good
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state AccostFocus
{
	ignores RespondToQuestionNegatively, TryToGreetPasserby, PerformInterestAction;
Begin:
	MyPawn.StopAcc();
	// wait for a second to face the focus
	Sleep(0.5);

	PrintDialogue("screw you!");
	// say something mean
	SayTime = Say(MyPawn.myDialog.lWhileFighting);
	Sleep(SayTime);

	// continue on your way
	GotoNextState();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// AssessAttacker
// Let out war cry/yell about stealing
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state AssessAttacker
{
	///////////////////////////////////////////////////////////////////////////////
	// Yell things before we attack
	///////////////////////////////////////////////////////////////////////////////
	function YellBeforeAttack()
	{
		if(FRand() <= MyPawn.TalkBeforeFighting)
		{
			if(bStolenFrom)
				Say(MyPawn.myDialog.lGettingRobbed, bImportantDialog);
			else
				Say(MyPawn.myDialog.lDecideToFight, bImportantDialog);
			// If we set the saytime, he'll sleep for that much time afterwards
			// making him stand still. We don't want that here, because habib
			// has to be on the move, busting out of his shack.
			SayTime=0;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// ShootAtAttacker
// Talk smack/yell about stealing
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state ShootAtAttacker
{
	///////////////////////////////////////////////////////////////////////////////
	// Say various things during a fight
	///////////////////////////////////////////////////////////////////////////////
	function FightTalk()
	{
		if(FRand() <= MyPawn.TalkWhileFighting)
		{
			if(bStolenFrom)
			{
				Say(MyPawn.myDialog.lGettingRobbed);
			}
			else
			{
				Say(MyPawn.myDialog.lWhileFighting);
			}
			// If we set the saytime, he'll sleep for that much time afterwards
			// making him stand still. We don't want that here, because habib
			// has to be on the move, busting out of his shack.
			SayTime=0;
		}
	}
}

defaultproperties
{
	HowAreYouFreq=0.0
}