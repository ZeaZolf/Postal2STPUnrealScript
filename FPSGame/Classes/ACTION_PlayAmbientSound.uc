class ACTION_PlayAmbientSound extends ScriptedAction;

var(Action)		sound	AmbientSound;
var(Action)		byte	SoundVolume;
var(Action)		byte	SoundPitch;
var(Action)		float	SoundRadius;

function bool InitActionFor(ScriptedController C)
{
	// play appropriate sound
	if ( AmbientSound != None )
	{
		C.SequenceScript.AmbientSound = AmbientSound;
		C.SequenceScript.SoundVolume = SoundVolume;
		C.SequenceScript.SoundPitch = SoundPitch;
		C.SequenceScript.SoundRadius = SoundRadius;
	}
	return false;	
}

function string GetActionString()
{
	return ActionString@AmbientSound;
}

defaultproperties
{
	ActionString="play ambient sound"
    SoundRadius=64
    SoundVolume=128
    SoundPitch=64
}
