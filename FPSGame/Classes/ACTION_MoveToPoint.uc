///////////////////////////////////////////////////////////////////////////////
// Action
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
///////////////////////////////////////////////////////////////////////////////
class ACTION_MoveToPoint extends LatentScriptedAction;

var(Action) name DestinationTag;	// tag of destination - if none, then use the ScriptedSequence
var transient Actor Movetarget;

function bool MoveToGoal()
{
	return true;
}

function Actor GetMoveTargetFor(ScriptedController C)
{
	if ( Movetarget != None )
		return MoveTarget;

	MoveTarget = C.SequenceScript.GetMoveTarget();
	if ( (DestinationTag != 'None') && (DestinationTag != '') )
		{
		ForEach C.AllActors(class'Actor',MoveTarget,DestinationTag)
			break;
		}
	if ( AIScript(MoveTarget) != None )
		MoveTarget = AIScript(MoveTarget).GetMoveTarget();
	return MoveTarget;
}


function string GetActionString()
{
	return ActionString@DestinationTag;
}

defaultproperties
{
	ActionString="Move to point"
	bValidForTrigger=false
}