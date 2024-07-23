///////////////////////////////////////////////////////////////////////////////
// PartDrip
// 
//	Area of fluid drips on part of a person
//
///////////////////////////////////////////////////////////////////////////////
class PartDrip extends Fluid;

const FINISH_TIME	=	3;

///////////////////////////////////////////////////////////////////////////////
// Set when you fade
///////////////////////////////////////////////////////////////////////////////
function PostBeginPlay()
{
	Super.PostBeginPlay();

	SetTimer(LifeSpan - FINISH_TIME, false);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function AddOffset(vector noffset)
{
	local int i;
	for(i=0; i<Emitters.Length; i++)
	{
		Emitters[i].StartLocationRange.X.Max += noffset.x;
		Emitters[i].StartLocationRange.X.Min += noffset.x;
		Emitters[i].StartLocationRange.Y.Max += noffset.y;
		Emitters[i].StartLocationRange.Y.Min += noffset.y;
		Emitters[i].StartLocationRange.Z.Max += noffset.z;
		Emitters[i].StartLocationRange.Z.Min += noffset.z;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Force a stop soon
///////////////////////////////////////////////////////////////////////////////
function SlowlyDestroy()
{
	if(LifeSpan > FINISH_TIME)
		LifeSpan=FINISH_TIME;
	Super.SlowlyDestroy();
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function Timer()
{
	if(LifeSpan <= 1.0)
		Destroy();
	else
		SlowlyDestroy();
}

defaultproperties
{
	bReplicateMovement=true
}
