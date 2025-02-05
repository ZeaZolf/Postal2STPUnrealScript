///////////////////////////////////////////////////////////////////////////////
// MarchingInfo
//
// Handles path for marching band and those who march
//
///////////////////////////////////////////////////////////////////////////////
class MarchingInfo extends ProtestorInfo;

///////////////////////////////////////////////////////////////////////////////
// VARS
///////////////////////////////////////////////////////////////////////////////
// ext
var ()bool bAlertBystanders;		// Whether or not to generate markers for bystanders to see/hear

// int
var float UpdateTime;	// How often to tell people around you that the parade
						// is coming through

var class<ParadeMarker>	TellThemMarker;	// Tell people around you with this marker
						// that the parade is coming--do it every UpdateTime seconds.


///////////////////////////////////////////////////////////////////////////////
// Alert everyone to the presence of the parade
///////////////////////////////////////////////////////////////////////////////
function Timer()
{
	local int i;
	local ParadeMarker mkr;

	i = Rand(PawnList.Length);
	if(i >= 0)
	{
		mkr = spawn(TellThemMarker,PawnList[i],,PawnList[i].Location);
	}
}

///////////////////////////////////////////////////////////////////////////////
// When triggered, if our sound isn't on, then we set it on, if it is, then
// we trigger like normal (disrupts group)
///////////////////////////////////////////////////////////////////////////////
function Trigger( actor Other, pawn EventInstigator )
{
	if(bMusicStartsOff)
	{
		bMusicStartsOff=false;
		StartupMusic();
	}
	else
		Super.Trigger(Other, EventInstigator);
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Prep all the arrays and pawns
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
auto state Init
{
	///////////////////////////////////////////////////////////////////////////////
	// Setup what this pawn will do, protesting, marching, etc.
	///////////////////////////////////////////////////////////////////////////////
	function SetupPawnStates(FPSPawn CheckPawn)
	{
		local LambController lambc;

		lambc = LambController(CheckPawn.Controller);
		// Figure out our home nodes, if we have any
		if(CheckPawn.bCanEnterHomes)
			lambc.FindHomeList(CheckPawn.HomeTag);
		// Link to the remaining path nodes
		lambc.FindPathList();

		CheckPawn.SetMarching(true);
		lambc.GotoState('Thinking'); // Initialization
		lambc.GotoState('BeginMarching');
	}
	///////////////////////////////////////////////////////////////////////////////
	// If we're still here, then setup our notifiers
	///////////////////////////////////////////////////////////////////////////////
	function SetupInfo()
	{
		Super.SetupInfo();

		if(!bDeleteMe)
		{
			if(bAlertBystanders)
				SetTimer(UpdateTime, true);
		}
	}
}


defaultproperties
{
	UpdateTime=1.0
	TellThemMarker=class'ParadeMarker'
}	bAlertBystanders=true
