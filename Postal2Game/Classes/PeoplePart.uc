///////////////////////////////////////////////////////////////////////////////
// PeoplePart
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Anything that attaches to a person.
//
///////////////////////////////////////////////////////////////////////////////
class PeoplePart extends Actor;

///////////////////////////////////////////////////////////////////////////////
// VARS
///////////////////////////////////////////////////////////////////////////////
var float SpinStartRate;
var FireEmitter MyPartFire;
var P2Emitter	MyPartChem;

///////////////////////////////////////////////////////////////////////////////
// CONSTS
///////////////////////////////////////////////////////////////////////////////
const PART_GRAVITY		= -1000;
const POP_UP_VEL		= 200;	// send it up some more than normal

///////////////////////////////////////////////////////////////////////////////
// Prep the collision because it's flying off his body
// But we just want it to default to fall through the ground
///////////////////////////////////////////////////////////////////////////////
function bool SetupAfterDetach()
{
	bCollideWorld=false;
	SetCollision(false, false, false);
	return true;
}

///////////////////////////////////////////////////////////////////////////////
// Check if we have valid stuff for it to steam
///////////////////////////////////////////////////////////////////////////////
function bool WillSteam()
{
	return false;
}

///////////////////////////////////////////////////////////////////////////////
// Gas is splashing on us
///////////////////////////////////////////////////////////////////////////////
function HitByGas()
{
}

///////////////////////////////////////////////////////////////////////////////
// A lit match hit us
///////////////////////////////////////////////////////////////////////////////
function HitByMatch(FPSPawn Doer)
{
}

///////////////////////////////////////////////////////////////////////////////
// Switch to a burned texture
///////////////////////////////////////////////////////////////////////////////
simulated function SwapToBurnVictim()
{
}

///////////////////////////////////////////////////////////////////////////////
// Set the starting physics for this flying off
///////////////////////////////////////////////////////////////////////////////
function GiveMomentum(vector momentum)
{
	SetPhysics(PHYS_PROJECTILE);
	Velocity = Momentum;
	// Make sure it always satisfying pops up in the air some
	Velocity.z+=FRand()*POP_UP_VEL + POP_UP_VEL;
	Acceleration.z=PART_GRAVITY;

	bFixedRotationDir=True;
	RotationRate.Pitch =	2*SpinStartRate*FRand() - SpinStartRate;
	RotationRate.Yaw =		2*SpinStartRate*FRand() - SpinStartRate;
	RotationRate.Roll =		2*SpinStartRate*FRand() - SpinStartRate;
}

defaultproperties
	{
	DrawType=DT_Mesh
	SpinStartRate=15000
	TransientSoundRadius=255
	}
