class ACTION_SetViewTarget extends ScriptedAction;

var(Action) name ViewTargetTag;
var transient Actor ViewTarget;

function bool InitActionFor(ScriptedController C)
{
	if ( ViewTargetTag == 'Enemy' )
		C.ScriptedFocus = C.Enemy;
	else if ( (ViewTargetTag == 'None') || (ViewTargetTag == '') )
		C.ScriptedFocus = None;
	else
		{
		if ( (ViewTarget == None) && (ViewTargetTag != 'None') )
			ForEach C.AllActors(class'Actor',ViewTarget,ViewTargetTag)
				break;

		if ( ViewTarget == None )
			C.bBroken = true;
		C.ScriptedFocus = ViewTarget;
		}
	return false;	
}

function String GetActionString()
{
	return ActionString@ViewTargetTag;
}

defaultproperties
{
	ActionString="set viewtarget"
	bValidForTrigger=false
}
	
