///////////////////////////////////////////////////////////////////////////////
// CatPawn for Postal 2
//
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Weird part is this pawn defaults to bBlockPlayer and Actors to false. 
// This is so he can 'squeeze' through peoples legs. But he needs
// to use Touch instead of Bump to receive these messages.
//
///////////////////////////////////////////////////////////////////////////////
class CatPawn extends AnimalPawn
	placeable;

///////////////////////////////////////////////////////////////////////////////
// VARS
///////////////////////////////////////////////////////////////////////////////
var Sound Purr;		// played when it's lying down
var Sound Meow1;	// played as it's walking around
var Sound Meow2;	// played as it's walking around
var Sound Meow3;	// played as it's walking around
var Sound Thrown;	// Screams when you throw it
var Sound Scared;	// Plays as it runs away
var Sound Hiss;		// Plays when hissing
var Sound Sniff;	// Plays when sniffing a cat butt

///////////////////////////////////////////////////////////////////////////////
// consts
///////////////////////////////////////////////////////////////////////////////

const BONE_PELVIS	= 'Bip01 pelvis';

///////////////////////////////////////////////////////////////////////////////
//	PostBeginPlay
///////////////////////////////////////////////////////////////////////////////
function PreBeginPlay()
{
	Super.PreBeginPlay();
}

///////////////////////////////////////////////////////////////////////////////
// Record pawn dead, if player killed them
///////////////////////////////////////////////////////////////////////////////
function Died(Controller Killer, class<DamageType> damageType, vector HitLocation)
{
	if(P2GameInfoSingle(Level.Game) != None
		&& P2GameInfoSingle(Level.Game).TheGameState != None
		&& Killer != None
		&& Killer.bIsPlayer)
	{
		P2GameInfoSingle(Level.Game).TheGameState.CatsKilled++;
	}

	Super.Died(Killer, damageType, HitLocation);
}

///////////////////////////////////////////////////////////////////////////////
// Tell your enemy where you are, so they can attack you
///////////////////////////////////////////////////////////////////////////////
function AlertPredator()
{
	local AnimalController acont;
	local DogPawn CheckP;

	foreach VisibleCollidingActors(class'DogPawn', CheckP, PREDATOR_ALERT_RADIUS, Location)
	{
		acont = AnimalController(CheckP.Controller);
		if(acont != None)
			acont.InvestigatePrey(self);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Check to chunk up from some attacks/attackers
///////////////////////////////////////////////////////////////////////////////
function bool TryToChunk(Pawn instigatedBy, class<DamageType> damageType)
{
	// Dogs always gib cats
	if(damageType == class'ShotgunDamage'
		|| damageType == class'SmashDamage'
		|| damageType == class'DogBiteDamage'
		|| ClassIsChildOf(damageType, class'ExplodedDamage'))
	{
		ChunkUp(Health);
		return true;
	}
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// make blood explosion
///////////////////////////////////////////////////////////////////////////////
simulated function ChunkUp(int Damage)
{
	local CatExplosion exp;

	bChunkedUp=true;

	if(class'P2Player'.static.BloodMode())
	{
		// Should make this inside ChunkUp, but we needs special distance stuff
		// so we do it out here
		exp = spawn(class'CatExplosion',,,Location);
		if(exp != None)
		{
			exp.ReduceMagBasedOnProx(Location, 1.0);//hitmag);
			exp.PlaySound(ExplodeSound,,,,,GetRandPitch());
		}
	}
	else
		spawn(class'RocketSmokePuff',,,Location);	// gotta give the lame no-blood mode something!

	Super.ChunkUp(Damage);

	Destroy();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Extends Pawn.Dying
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
state Dying
{

	///////////////////////////////////////////////////////////////////////////////
	// Be able to still see blood as something dies
	///////////////////////////////////////////////////////////////////////////////
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
							Vector momentum, class<DamageType> damageType)
	{
		// If you're infected, be infected even in death
		if(damageType == class'ChemDamage')
			SetInfected(FPSPawn(instigatedBy));

		// If fire hit you, even dead, catch on fire for sure
		if(ClassIsChildOf(damageType, class'BurnedDamage'))
			SetOnFire(FPSPawn(instigatedBy), (damageType==class'NapalmDamage'));

		// If fire has killed me,
		// or we're on fire and we died,
		// then swap to my burn victim mesh
		if(damageType == class'OnFireDamage'
			|| ClassIsChildOf(damageType, class'BurnedDamage')
			|| MyBodyFire != None)
			SwapToBurnVictim();

		if(!(Damage > 0
			&& TryToChunk(Instigator, DamageType)))
		{
			if(Physics == PHYS_Walking
				&& momentum.z != 0)
				momentum.z=0;
			AddVelocity( momentum ); 

			PlayHit(Damage, hitLocation, damageType, Momentum);
		}
	}
}

/*
///////////////////////////////////////////////////////////////////////////////
// Take half on fire damage
///////////////////////////////////////////////////////////////////////////////
function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation, 
						Vector momentum, class<DamageType> damageType)
{
	local vector Rot, Diff, dmom;
	local float dot1, dot2;

	// Take half on all fire damage
	if(damageType == class'BurnedDamage'
		|| damageType == class'OnFireDamage')
		Damage/=2;

	// Check for if this really hit me or not
	Rot = vector(Rotation);
	dmom = Momentum;
	dmom.z=0;
	dmom = Normal(dmom);
	dot1 = Rot Dot dmom;

//	log("rot "$Rot$" mom "$dmom$" dot1 "$dot1);

	if(abs(dot1) > BODY_SIDE_DOT)
	{
		Diff = Normal(Location - HitLocation);
		dot2 = Rot Dot Diff;
		//log(" diff "$Diff$" dot2 "$dot2);

		if(abs(dot2) > BODY_INLINE_DOT)
		{
			Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
		}
		else
			// no hit, so return without taking damage
			return;
	}
	else
	{
		Super.TakeDamage(Damage, instigatedBy, hitlocation, momentum, damageType);
	}

}
*/
///////////////////////////////////////////////////////////////////////////////
//
// Private animation functions for this animal in particular.
//
// These functions take all the common character attributes into account to
// determine which animations to use.  Derived classes can certainly extend
// these functions, but it shouldn't be necessary for most cases.
//
// The SetAnimXXXXX functions set up the character to start playing the
// appropriate animation.
//
// The GetAnimXXXXX functions simply return the name of the appropriate
// animation, which is useful when several areas of the code need to refer to
// the same animation.
//
// sneak
// pounce
// jump
// walk
// run
// stand
// lay_in
// lay_on
// lay_out
// sit_in
// sit_on
// sit_out
// sniff
// cover
// piss
// hiss
// fall
//
///////////////////////////////////////////////////////////////////////////////


simulated function name GetAnimSneak()
{
	return 'sneak';
}

simulated function name GetAnimPounce()
{
	return 'pounce';
}

simulated function name GetAnimPiss()
{
	return 'piss';
}

simulated function name GetAnimCover()
{
	return 'cover';
}

simulated function name GetAnimHiss()
{
	return 'hiss';
}

simulated function name GetAnimSniff()
{
	return 'sniff';
}

simulated function name GetAnimJump()
{
	return 'jump';
}

simulated function name GetAnimStanding()
{
	return 'stand';
}

simulated function name GetAnimSitDown()
{
	return 'sit_in';
}

simulated function name GetAnimSitting()
{
	return 'sit_on';
}

simulated function name GetAnimStandUp()
{
	return 'sit_out';
}

simulated function name GetAnimLayDown()
{
	return 'lay_in';
}

simulated function name GetAnimLaying()
{
	return 'lay_on';
}

simulated function name GetAnimDruggedOut()
{
	return 'cheech';
}

simulated function name GetAnimGetBackUp()
{
	return 'lay_out';
}

simulated function name GetAnimFalling()
{
	return 'fall';
}

simulated function name GetAnimDeath()
{
	return 'death';
}

simulated function SetupAnims()
{
	// Make sure to blend all this channel in, ie, always play all of this channel when not 
	// playing something else, because this is the main movement channel
	AnimBlendParams(MOVEMENTCHANNEL,1.0);
	// Turn on this channel too
	LoopAnim('stand',1.0,0.2);
}

simulated function SetAnimStanding()
{
	//AnimBlendParams(MOVEMENTCHANNEL,1.0);
	LoopAnim(GetAnimStanding(), 1.0, 0.2);//, MOVEMENTCHANNEL);
}

simulated function SetAnimWalking()
{
	AnimBlendParams(MOVEMENTCHANNEL,1.0);
	LoopAnim('walk', 1.0, 0.2, MOVEMENTCHANNEL);// + FRand()*0.4);
}

simulated function SetAnimRunning()
{
	AnimBlendParams(MOVEMENTCHANNEL,1.0);
	LoopAnim('run', 2.5, 0.2, MOVEMENTCHANNEL);
}

simulated function SetAnimTrotting()
{
	AnimBlendParams(MOVEMENTCHANNEL,1.0);
	LoopAnim('walk', 4.0, 0.2, MOVEMENTCHANNEL);// + FRand()*0.4);
}


simulated function PlayDyingAnim(class<DamageType> DamageType, vector HitLoc)
	{
	PlayAnim(GetAnimDeath(), 1.5, 0.15);
	}

function PlayTakeHit(vector HitLoc, int Damage, class<DamageType> damageType)
{
	local float BlendAlpha, BlendTime;

	// Don't do anything with these damages
	if(ClassIsChildOf(damageType, class'BurnedDamage')
		|| damageType == class'OnFireDamage')
		return;

	// blend in a hit
	BlendAlpha = 1;
	BlendTime=0.2;

	AnimBlendParams(TAKEHITCHANNEL,BlendAlpha);
	TweenAnim('stand',0.1,TAKEHITCHANNEL);

//	PlaySound(Meow1,
//		SLOT_Talk,,,,GenPitch);

	Super.PlayTakeHit(HitLoc,Damage,damageType);
}


// PLAY THESE on the default channel
function PlayAnimStanding()
{
	// turn off 
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimStanding(), 1.0, 0.2);
}

function PlayHappySound()
{
	local float randtype;

	randtype = FRand();
	if(randtype < 0.3)
		PlaySound(Meow1,
			SLOT_Talk,,,,GenPitch());
	else if(randtype < 0.6)
		PlaySound(Meow2,
			SLOT_Talk,,,,GenPitch());
	else
		PlaySound(Meow3,
			SLOT_Talk,,,,GenPitch());
}

function PlayContentSound()
{
	PlaySound(Purr,
		SLOT_Talk,,,1.0,GenPitch());
}

function PlayScaredSound()
{
	PlaySound(Scared);
}

function PlayThrownSound()
{
	PlaySound(Thrown,
			SLOT_Talk,,,,GenPitch());
}

function PlayGetScared()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimHiss(), 1.0, 0.2);
	PlaySound(Hiss,
			SLOT_Talk,,,,GenPitch());
}

function PlayAttack1()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimSniff(), 1.0, 0.2);
}

function PlayAttack2()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimSniff(), 1.0, 0.2);
}

function PlayInvestigate()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimSniff(), 1.0, 0.2);
	PlaySound(Sniff,
			SLOT_Talk,,,,GenPitch());
}

function PlaySitDown()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimSitDown(), 1.0, 0.2);
}

function PlaySitting()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimSitting(), 1.0, 0.2);
}

function PlayStandUp()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimStandUp(), 1.0, 0.2);
}

function PlayLayDown()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimLayDown(), 1.0, 0.2);
}

function PlayLaying()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimLaying(), 1.0, 0.2);
	PlaySound(Purr);
}

function PlayDruggedOut()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimDruggedOut(), 1.0, 0.2);
	PlaySound(Purr);
}

function PlayPissing(float AnimSpeed)
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimPiss(), AnimSpeed, 0.2);
//	PlaySound(Purr);
}

function SetToTrot(bool bSet)
{
	if(bTrotting != bSet)
	{
		bTrotting=bSet;
		ChangeAnimation();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Start your urine feeder
///////////////////////////////////////////////////////////////////////////////
simulated function Notify_PissStart()
{
	local UrinePourFeeder checkurine;

	if(UrineStream == None)
	{
		checkurine = spawn(class'UrinePourFeeder',self,,Location);
		if(AnimalController(Controller) == None
			|| AnimalController(Controller).PissingValid())
		{
			UrineStream = checkurine;
			UrinePourFeeder(UrineStream).MyOwner = self;
			// Trim the arcing z height of this bad boy
			UrinePourFeeder(UrineStream).InitialSpeedZPlus/=4;
			AttachToBone(UrineStream, BONE_PELVIS);
			SnapStream();
		}
		else
			checkurine.Destroy();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Stop your urine feeder
///////////////////////////////////////////////////////////////////////////////
simulated function Notify_PissStop()
{
	if(UrineStream != None)
	{
		DetachFromBone(UrineStream);
		UrineStream.Destroy();
		UrineStream=None;
	}
}

///////////////////////////////////////////////////////////////////////////////
// redetermine the direction of the stream
///////////////////////////////////////////////////////////////////////////////
function SnapStream()
{
	local vector startpos, X,Y,Z;
	local vector forward;
	local coords checkcoords;

	checkcoords = GetBoneCoords(BONE_PELVIS);
	UrinePourFeeder(UrineStream).SetLocation(checkcoords.Origin);
	UrinePourFeeder(UrineStream).SetDir(checkcoords.Origin, -checkcoords.XAxis);
}

function PlayCovering()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimCover(), 1.0, 0.2);
//	PlaySound(Purr);
}

function PlayGetBackUp()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	PlayAnim(GetAnimGetBackUp(), 1.0, 0.2);
}

function PlayFalling()
{
	AnimBlendParams(MOVEMENTCHANNEL,1.0);
	LoopAnim(GetAnimFalling(), , , MOVEMENTCHANNEL);
}

simulated function PlayShockedAnim()
{
	AnimBlendParams(MOVEMENTCHANNEL,0.0);
	LoopAnim(GetAnimFalling(), 10.0, 0.15);
	PlaySound(Hiss,
			SLOT_Talk,,,,GenPitch());
}

defaultproperties
{
	Mesh=SkeletalMesh'Animals.meshCat'
	Skins[0]=Texture'AnimalSkins.Cat_Orange'
	CollisionHeight=25
	CollisionRadius=18
    ControllerClass=class'CatController'
	WalkingPct=0.065
	GroundSpeed=480
	HealthMax=15
	Purr=Sound'AnimalSounds.Cat.CatPurr'
	Meow1=Sound'AnimalSounds.Cat.CatMeow'
	Meow2=Sound'AnimalSounds.Cat.CatMeow2'
	Meow3=Sound'AnimalSounds.Cat.CatCry'
	Thrown=Sound'AnimalSounds.Cat.CatVicious'
	Scared=Sound'AnimalSounds.Cat.CatScream'
	Hiss=Sound'AnimalSounds.Cat.CatHiss'
	Sniff=Sound'AnimalSounds.Cat.CatSniff'
	TrottingPct=0.4
    CarcassCollisionHeight=15.00000
	TorsoFireClass=class'FireCatEmitter'
    bBlockActors=false
    bBlockPlayers=false
}
