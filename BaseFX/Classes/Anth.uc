//=============================================================================
// anthrax in some imaginary gaseous, brown/orange form
//=============================================================================
class Anth extends Wemitter;

var		float Damage;         
var		float DamageDistMag;		// How far the radius or trace should go to hurt stuff
									// Make it seperate from the official CollisionRadius 
									// because this is just for damage and the other is const
									// and this needs to change dynamically sometimes.

var	class<DamageType> MyDamageType;
var	vector CollisionLocation;

const SHOW_LINES = 1;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	CollisionLocation = Location;
}

function CheckToHitActors(float DeltaTime)
{
	HurtRadius(DeltaTime*Damage, DamageDistMag, MyDamageType, 0, CollisionLocation );
}

function Tick(float DeltaTime)
{
	// deal damage
	CheckToHitActors(DeltaTime);
}

simulated event RenderOverlays( canvas Canvas )
{
/*
	//local vector endline;
	local color tempcolor;

	if(SHOW_LINES==1)
	{
		// show collision radius
		//endline = Location + vect(200, 0, 200);
		tempcolor.B=255;
		Canvas.DrawColor = tempcolor;
		Canvas.Draw3Circle(CollisionLocation, DamageDistMag, 0);
	}
	*/
}

defaultproperties
{
	Damage=100
	DamageDistMag=120
    MyDamageType=Class'AnthDamage'
}