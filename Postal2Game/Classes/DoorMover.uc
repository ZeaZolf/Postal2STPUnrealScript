///////////////////////////////////////////////////////////////////////////////
// Extension of movers to allow double-hinged doors. Use a normal mover for 
// a normal door
///////////////////////////////////////////////////////////////////////////////
class DoorMover extends SplitMover
	placeable;

//-----------------------------------------------------------------------------
// External
var() bool		LockedFront;
var() bool		LockedBack;
var() bool		HasTopBoard;
var() bool		HasMiddleBoard;
var() bool		HasBottomBoard;
var() bool		BoardsOnBack;
var() bool		StaysLocked;
var() Sound		BreakBoardSound;
var() Sound		CantOpenSound;
var() bool		bMakeBuffer;		// Make a buffer point to determine how many people can at max use this
									// door
//var() bool		bFlipFlopPath;

// Internal.
var doorboard	Boards[3];
var byte		HasBoard[3];
var byte		BoardNum;
// say its okay to try to open this (like if it has boards on it)
var bool		AllowOpenTry;
var float		WaitTime;
var DoorBufferPoint Bufferpoint;		// buffer point to help determine if people should go through or not
var vector		FrontPoint, BackPoint;	// front and back of door as looking through it when open
var vector		FrontPointHinge, BackPointHinge;	// front and back of door, from pivot point, as looking through it when open
var Door		DoorPathNode;		// pathnode for this door
var Pawn		CurrentStuckPawn;	// Occassionally (esp. in MP games) players can get stuck in doors 'vibrating'
var float		CurrentStuckTime;	// This calls the unsticking code in p2player a player gets stuck too often.
var int			CurrentStuckCount;	// How many times in a row they've been stuck/bumped


const KNOCK_OFF_SPEED		=	-50;
const TOP_					=	0;
const MIDDLE_				=	1;
const BOTTOM_				=	2;
const BOARD_MAX				=	3;
const KICK_WAIT_TIME		=	1;
const CHECK_LOCK_WAIT_TIME	=	2;
const DOOR_HEIGHT			=	208;
const DOOR_WIDTH			=	112;
const DOOR_THICKNESS		=	16;
const SEND_ONE_TIME			=	2.0;		// how often to try to send people through the door
const EXPLODE_DAMAGE		=	150;
const STUCK_COUNT_MAX		=	5;

///////////////////////////////////////////////////////////////////////////////
// Functions
// Don't call super
///////////////////////////////////////////////////////////////////////////////
function PostBeginPlay()
{
	local vector Loc;
	local Rotator Rot;
	local vector RotDir;
	local int i, BoardDir;
	local float usez, usewidth, usethick;
	local Door NewNode;

	// spawn and link boards in, if there are any
	Rot = Rotation;
	Rot.Yaw += 16384;				// makes this goes from the hinge to the knob, as a vector
	Rot.Yaw = Rot.Yaw & 65535;
	RotDir = Normal(vector(Rot));
	Rot = Rotation;	//reset it and use true door rotation
	BoardNum=0;

	if(BoardsOnBack)
	{
		BoardDir = 1;
		Rot.Yaw +=32668;
		Rot.Yaw = Rot.Yaw & 65535;
	}
	else 
		BoardDir = -1;

	// record which boards we're using
	if(HasTopBoard)
		HasBoard[TOP_]=1;
	if(HasMiddleBoard)
		HasBoard[MIDDLE_]=1;
	if(HasBottomBoard)
		HasBoard[BOTTOM_]=1;
	// Find positions and spawn boards appropriately
	usewidth = CollisionRadius;
	usethick = DOOR_THICKNESS;
	usez = CollisionHeight/2;
	Loc = Location;
//	log("start location "$Loc);
	Loc.x += (usewidth*RotDir.x - BoardDir*usethick*RotDir.y);
	Loc.y += (usewidth*RotDir.y + BoardDir*usethick*RotDir.x);
	Loc.z += usez;
	Loc.z+=CollisionHeight;
	
//	log("board loc "$Loc);
//	log("d rotation "$Rotation);
//	log("d rot vec"$RotDir);

	for(i=0; i<BOARD_MAX; i++)
	{
		if(HasBoard[i]==1 && Boards[i] == None )
		{
			Rot.roll = Rotation.roll + Rand(4000)-2000;
			Boards[i] = spawn(class'DoorBoard',,,Loc, Rot);
			BoardNum++;
		}
		Loc.z -= usez;
	}

	if(BoardNum > 0)
	{
		// will always remain open once you get it open
		StaysLocked=false;
		// The opposite side of the door is always locked
		if(BoardsOnBack)
			LockedFront=true;
		else
			LockedBack=true;
	}
	// say its okay to try to open this (like if it has boards on it)
	AllowOpenTry=true;

	// Make the buffer that determines how many people can use this door at once
	if(bMakeBuffer)
		Bufferpoint = spawn(class'DoorBufferPoint',self,,Location);

	// Calc front and back (through door hole)
	RotDir = vector(Rotation);
	BackPoint = Location;
	FrontPoint = Location;
	BackPointHinge = Location;
	FrontPointHinge = Location;
	BackPoint.x += (2*RotDir.x*CollisionRadius - RotDir.y*CollisionRadius);
	BackPoint.y += (2*RotDir.y*CollisionRadius - RotDir.x*CollisionRadius);
	FrontPoint.x += (-2*RotDir.x*CollisionRadius - RotDir.y*CollisionRadius);
	FrontPoint.y += (-2*RotDir.y*CollisionRadius - RotDir.x*CollisionRadius);
	BackPointHinge.x += (2*RotDir.x*CollisionRadius);
	BackPointHinge.y += (2*RotDir.y*CollisionRadius);
	BackPointHinge.z += CollisionHeight;
	FrontPointHinge.x += (-2*RotDir.x*CollisionRadius);
	FrontPointHinge.y += (-2*RotDir.y*CollisionRadius);
	FrontPointHinge.z += CollisionHeight;

	// Go through all door nodes and link me up to them too.
	foreach AllActors(class'Door', NewNode)
	{
		if(NewNode.DoorTag == Tag)
		{
			DoorPathNode = NewNode;
			break;
		}
	}
	// Check to block or unblock path
	if(DoorPathNode != None)
	{
		if(LockedFront
			|| LockedBack)
			DoorPathNode.bBlocked=true;
		else
			DoorPathNode.bBlocked=false;
	}
}

///////////////////////////////////////////////////////////////////////////////
// If there is at least one open view to the door, not occluded by static things
// then return true.
///////////////////////////////////////////////////////////////////////////////
function bool ClearShotToDoor(vector PLoc)
{
	if(FastTrace(PLoc, FrontPoint)
		|| FastTrace(PLoc, BackPoint))
		return true;
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// See if there's anything in my way (people wise)
///////////////////////////////////////////////////////////////////////////////
function bool WayIsClear()
{
	local vector HitNormal, HitLocation;
	local Actor HitActor;

	HitActor = Trace(HitLocation, HitNormal, BackPoint, FrontPoint, true);

	//log("hit actor "$HitActor);
	if(P2Pawn(HitActor) == None
		|| P2Pawn(HitActor).Health <= 0)
		return true;
	else
		return false;
}
///////////////////////////////////////////////////////////////////////////////
// Explosions blow open unlocked doors by default
///////////////////////////////////////////////////////////////////////////////
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType)
{
	local vector userot;

	if(ClassIsChildOf(damageType, class'ExplodedDamage')
		&& damage >= DamageThreshold)
	{
		userot = (Location - HitLocation);
		// If it can close from that direction, if not locked, and if it the way is
		// clear of people, then open/close the door from the explosion
		if(PickMoverPathAndCheckLock(None, HitLocation, userot) == true
			&& BufferPoint != None
			&& WayIsClear())
		{
			// Knock open door speed is based on damage
			if(Damage < EXPLODE_DAMAGE)
			{
				MoveTime = default.MoveTime/2;
				MoveTime = (Damage/EXPLODE_DAMAGE)*(MoveTime) + MoveTime;
			}
			else
				MoveTime = default.MoveTime/2;
			Bump(None);
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// When bumped by something.
///////////////////////////////////////////////////////////////////////////////
function Bump( actor Other )
{
	// Wake up
	//bStasis=false;

	// Don't react to dead bodies.
	if(FPSPawn(Other) != None
		&& FPSPawn(Other).Health <= 0)
		return;

	Super.Bump(Other);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function Tick(Float DeltaTime)
{
	if(!AllowOpenTry)
	{
		WaitTime-=DeltaTime;
		if(WaitTime <= 0)
			AllowOpenTry=true;
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function bool KnockOffBoard(int bindex,
							Actor Other)
{
	local vector Rot;
	local P2Pawn p2p;

	// Say your not allowed to try to open the door again for 
	// a period of time
	WaitTime=KICK_WAIT_TIME;
	AllowOpenTry=false;
	// Shake the screen some because you kicked it hard and 
	// jostled your whole body in the process (plus it masks
	// that the door doesn't move.
	p2p = P2Pawn(Other);
	if(p2p != None)
	{
		if(p2p.Controller.bIsPlayer)
			//p2p.Controller.ShakeView(4, 2000, vect(1,1,8), 120000, vect(1,1,1), 1);
			p2p.Controller.ShakeView( 10 * vect(30,0,0), 
						   120000 * vect(1,0,0), 
						   0.15 + 0.005 * 10, 
						   10 * vect(0,0,0.03), 
						   vect(1,1,1), 
						   0.2);
	}
	// Also play a noisy song for the door getting shook
	PlaySound(BreakBoardSound,, 1.5,,1200, 0.5+FRand());		
	// Now, knock the board off
	Boards[bindex].SetPhysics(PHYS_FALLING);
	Rot = Normal(vector(Rotation));
//	if(BoardsOnBack)
//		Boards[bindex].Velocity = Rand(KNOCK_OFF_SPEED)*Rot;
//	else
//		Boards[bindex].Velocity = (-Rand(KNOCK_OFF_SPEED)*Rot);
	Boards[bindex].Velocity.z=-2*KNOCK_OFF_SPEED;
//	Boards[bindex].RotationRate.roll=100000;
//	Boards[bindex].RotationRate.pitch=100000;
//	Boards[bindex].RotationRate.yaw=100000;
	Boards[bindex].LifeSpan=6;
	Boards[bindex] = None;
	HasBoard[bindex] = 0;
	BoardNum--;
	// check to see if the door has been opened
	if(BoardNum <=0)
	{
		LockedFront=false;
		LockedBack=false;
		// Check to block or unblock path
		if(DoorPathNode != None)
		{
			if(LockedFront
				|| LockedBack)
				DoorPathNode.bBlocked=true;
			else
				DoorPathNode.bBlocked=false;
		}
		return true;
	}
	else	// not open yet
		return false;
}

///////////////////////////////////////////////////////////////////////////////
// Tries to open the door, dealing with boards on the door,
// and checks locks.
// Returns true if it opened, and false if it stayed closed
///////////////////////////////////////////////////////////////////////////////
function bool TryDoorThisSide(bool LockedThisSide, out byte LockedOtherSide, bool BackSide,
							  Actor Other)
{
	local int i;

	if(BoardNum > 0 && BoardsOnBack == BackSide)
	{
		i=0;
		// pick the board to knock off
		while(HasBoard[i]==0 && i<BOARD_MAX)
			i++;
		if(i < BOARD_MAX)		
			return KnockOffBoard(i, Other);
	}
	else
	{
		if(LockedThisSide)
		{
			// can't open this way
			PlaySound(CantOpenSound,, 1.5,,1200, 0.5+FRand());		
			WaitTime=CHECK_LOCK_WAIT_TIME;
			AllowOpenTry=false;
			return false;
		}
		else // the door was opened
		{ 
			// If it doesn't stay locked when opened,
			// then this is now unlocked from both sides
			if(StaysLocked==false)
				LockedOtherSide=0;
			// Regardless, you were able to make it through
			return true;
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check if locked in the direction your coming
// If it's locked your way, you can't go through. 
// If it's unlocked your way, then unlock it both
// ways, unless it's supposed to stay locked.
// Return bool says if you can open it that way (thedot) or not
///////////////////////////////////////////////////////////////////////////////
function bool OperateLock(float thedot, Actor Other)
{
	local byte LockedThisSide;
	local bool ret;

	// return immediately if this thing isn't even allowed to be tried
	if(!AllowOpenTry)
		return false;

	// Checking if locked/boarded
	// Facing back
	if(thedot > 0)
	{
		LockedThisSide = byte(LockedFront);
		// Bools can't be out vars and i liked having the Locked fields be
		// bools for the level designers
		ret=TryDoorThisSide(LockedBack, LockedThisSide, true, Other);
		if(LockedFront)
			LockedFront = bool(LockedThisSide);
	}
	// facing front
	else
	{
		LockedThisSide = byte(LockedBack);
		ret=TryDoorThisSide(LockedFront, LockedThisSide, false, Other);
		if(LockedBack)
			LockedBack = bool(LockedThisSide);
	}
	// Check to block or unblock path
	if(DoorPathNode != None)
	{
		if(LockedFront
			|| LockedBack)
			DoorPathNode.bBlocked=true;
		else
			DoorPathNode.bBlocked=false;
	}
	return ret;
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ResetStuck(optional Pawn P)
{
	CurrentStuckPawn = P;
	CurrentStuckTime = Level.TimeSeconds;
	CurrentStuckCount = 0;
}

/*
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Open when bumped and already closed. Close when bumped and already open
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state SendPawnsThrough
{
	function Bump(Actor Other)
	{
		GotoState(InitialState);
	}
}

function FinishedOpening()
{
	Super.FinishedOpening();
	GotoState('SendPawnsThrough');
}

function FinishedClosing()
{
	Super.FinishedClosing();
	GotoState('SendPawnsThrough');
}
*/
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Open when bumped and already closed. Close when bumped and already open
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state() BumpPlayerStandOpenTimedPawn
{

	///////////////////////////////////////////////////////////////////////////////
	// Return true to abort, false to continue.
	// *Close to Engine.Mover.EncroachingOn* but we have a callback for when the door
	// hits a pawn so the NPC can get out of the way
	///////////////////////////////////////////////////////////////////////////////
	function bool EncroachingOn( actor Other )
	{
		local Pawn P;
		local LambController lambc;
		local bool bStopOpen, bForceOpen;
		local Actor HitActorFront, HitActorBack;
		local vector HitNormal, HitLocation;

		// This 'stuck' code handles players in MP getting stuck in doors (and SP,it just
		// happens alot in MP with the lag)
		// If it's within one second of the last time he bumped the door, he's probably stuck
		if(CurrentStuckPawn == Other
			|| Level.TimeSeconds - CurrentStuckTime < 1.0f)
		{
			CurrentStuckCount++;
			// This many times in a row, and he's surely stuck--remove him
			if(CurrentStuckCount >= STUCK_COUNT_MAX)
			{
				if(P2Player(CurrentStuckPawn.Controller) != None)
					P2Player(CurrentStuckPawn.Controller).HandleStuckPlayer();
				ResetStuck();
			}
		}
		else
		{
			// Reset stuck code just in case for the new touching guy
			if(Pawn(Other) != None)
				ResetStuck(Pawn(Other));
		}

		// Don't do anything to projectiles
		if(Other.IsA('Projectile'))
			return false;
			
		if ( ((Pawn(Other) != None) && (Pawn(Other).Controller == None)) || Other.IsA('Decoration') )
		{
			Other.TakeDamage(10000, None, Other.Location, vect(0,0,0), class'Crushed');
			return false;
		}
		if ( Other.IsA('Pickup') )
		{
			if ( !Other.bAlwaysRelevant && (Other.Owner == None) )
				Other.Destroy();
			return false;
		}
		if ( Other.IsA('Fragment') )
		{
			Other.Destroy();
			return false;
		}

		// Damage the encroached actor.
		if( EncroachDamage != 0 )
			Other.TakeDamage( EncroachDamage, Instigator, Other.Location, vect(0,0,0), class'Crushed' );

		// If we have a bump-player event, and Other is a pawn, do the bump thing.
		P = Pawn(Other);
		if( P!=None && (P.Controller != None))
		{
			if( P.IsPlayerPawn() )
			{
				if ( PlayerBumpEvent!='' )
					Bump( Other );
				if ( (P.Base != self) && (P.Controller.PendingMover == self) )
					P.Controller.UnderLift(self);	// pawn is under lift - tell him to move
			}
			else	// make npc's back from the door if they can
			{
				lambc = LambController(P.Controller);
				if(lambc != None)
					lambc.MoveAwayFromDoor(self);
				// If it's opening up, snap the door open
				if(!bOpen
					&& bOpening
					&& MoveTime != 0)
				{
					// Test from hinge forward/backwards and see if you're
					// hitting someone or not.
					HitActorFront = Trace(HitLocation, HitNormal, FrontPointHinge, Location, true);
					HitActorBack = Trace(HitLocation, HitNormal, BackPointHinge, Location, true);

					//log(self$" hit actor front "$HitActorFront$" hit actor back "$HitActorBack$" key num "$KeyUseMin);
					// Could be mess up with front/back hinge position getting weird after a rotation
					if(KeyUseMin == 0)
					{
						if(HitActorBack == None
							|| HitActorBack.bStatic)
						{
							bForceOpen=true;
						}
						else if(HitActorFront == None
								|| HitActorFront.bStatic)
						{
							// Reverse the keys
							KeyUseMin = SecondPathKeyNum;
							KeyUseMax = NumKeys;

							bForceOpen=true;
						}
					}
					else
					{
						if(HitActorFront == None
							|| HitActorFront.bStatic)
						{
							bForceOpen=true;
						}
						else if(HitActorBack == None
								|| HitActorBack.bStatic)
						{
							// Reverse the keys
							KeyUseMin = 0;
							KeyUseMax = SecondPathKeyNum;

							bForceOpen=true;
						}
					}

					if(bForceOpen)
					{
						MoveTime = 0.0;
						DoOpen();
						bStopOpen=true;
					}
				}
			}
		}

		// Stop, return, or whatever.
		if( MoverEncroachType == ME_StopWhenEncroach )
		{
			Leader.MakeGroupStop();
			return true;
		}
		else if( MoverEncroachType == ME_ReturnWhenEncroach )
		{
			if(!bStopOpen)
			{
				Leader.MakeGroupReturn();
				if ( Other.IsA('Pawn') )
					Pawn(Other).PlayMoverHitSound();
				return true;
			}
			return false;
		}
		else if( MoverEncroachType == ME_CrushWhenEncroach )
		{
			// Kill it.
			Other.KilledBy( Instigator );
			return false;
		}
		else if( MoverEncroachType == ME_IgnoreWhenEncroach )
		{
			// Ignore it.
			return false;
		}
	}

	///////////////////////////////////////////////////////////////////////////////
	// Toggle locks when triggered
	///////////////////////////////////////////////////////////////////////////////
	function Trigger( actor Other, pawn EventInstigator )
	{
		LockedFront=!LockedFront;
		LockedBack=!LockedBack;
		if(DoorPathNode != None)
			DoorPathNode.bBlocked=false;
	}

Open:
	// Wake  up
	//bStasis=false;

	bClosed = false;
	Disable( 'Bump' );
	if ( DelayTime > 0 )
	{
		bDelaying = true;
		Sleep(DelayTime);
	}
	DoOpen();
	FinishInterpolation();
	FinishedOpening();

HangingOpen:

	//Sleep( UseStayOpenTime );
	Sleep(SEND_ONE_TIME);

	if(BufferPoint != None)
	{
		if(WayIsClear())
		{
			if(BufferPoint.TellNextPersonToGo())
				Goto('HangingOpen');
		}
		else
		{
			Goto('HangingOpen');
		}
	}

	Sleep(SEND_ONE_TIME);

	if( bTriggerOnceOnly )
		GotoState('');

	if( bSlave )
		Stop;
Close:
	DoClose();
	FinishInterpolation();
	FinishedClosing();

	Enable( 'Bump' );

SendPeopleToMe:

	if(BufferPoint != None)
	{
		// If the person fails to go when you tell them,
		// then check if you still have people waiting.. if so
		// keep waiting.
		if(BufferPoint.TellNextPersonToGo()
			|| BufferPoint.StillHavePeopleWaiting())
		{
			Sleep(SEND_ONE_TIME);
			Goto('SendPeopleToMe');
		}
	}
	// Go to sleep
	//bStasis=true;
}

defaultproperties
{
	InitialState=BumpPlayerStandOpenTimedPawn
	BumpType=BT_PawnBump
	SecondPathKeyNum=2
	NumKeys=4
	bAutoDoor=true
	CollisionHeight=104
	CollisionRadius=56
	bMakeBuffer=true
	ClosingSound=Sound'MiscSounds.Doors.DoorClose'
	OpeningSound=Sound'MiscSounds.Doors.DoorOpen'
	BreakBoardSound=None
	CantOpenSound=Sound'MiscSounds.Doors.KickingDoor'
	DamageThreshold=30
//	bStasis=true
}