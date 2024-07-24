class ACTION_Say extends LatentScriptedAction;

var(Action)		sound	Sound;
var(Action)		float	Volume;
var				bool	bAttenuate;	// no longer used but not deleted to avoid possible load/save problems
var(Action)		bool	bYell;
var(Action)		bool	bWaitUntilFinished;
var(Action)		float	Radius;

function bool InitActionFor(ScriptedController C)
{
	local PersonPawn pp;
	local float duration;
	local bool bWait;

	pp = PersonPawn(C.GetSoundSource());
	if (pp != None && pp.MyHead != None && Sound != None)
	{
		pp.PlaySound(Sound, SLOT_Interact, Volume, false, Radius, pp.VoicePitch);
		duration = pp.GetSoundDuration(Sound) / pp.VoicePitch;
		if(bYell)
			Head(pp.MyHead).Yell(duration);
		else
			Head(pp.MyHead).Talk(duration);

		if (bWaitUntilFinished)
			{
			C.CurrentAction = self;
			C.SetTimer(duration, false);
			bWait = true;
			}
	}

	return bWait;
}

function bool CompleteWhenTimer()
{
	return bWaitUntilFinished;
}

function string GetActionString()
{
	return ActionString@Sound;
}

defaultproperties
{
	ActionString="say"
	Volume=+1.0
	Radius=300
}