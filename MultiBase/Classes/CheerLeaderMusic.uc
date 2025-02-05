///////////////////////////////////////////////////////////////////////////////
// CheerLeaderMusic.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// Play music for dancing cheerleaders at end of MP game
//
///////////////////////////////////////////////////////////////////////////////
class CheerLeaderMusic extends Actor
	placeable;

var Sound musicsounds[3];

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	AmbientSound=musicsounds[Rand(3)];
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function Reset()
{
	Destroy();
}

defaultproperties
{
	bHidden=true
	musicsounds[0]=Sound'AmbientSounds.hornyClub'
	musicsounds[1]=Sound'AmbientSounds.technoClub2'
	musicsounds[2]=Sound'AmbientSounds.ghettoBeat'
}
 