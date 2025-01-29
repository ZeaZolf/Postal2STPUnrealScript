class ACTION_StopMusic extends ScriptedAction;

// Make sure to call StopMusic within the same ScriptedSequence as the PlayMusic that started
// this because PlayMusic gets the songhandle we need to stop the music.

var(Action) bool				bAffectAllPlayers;
var(Action) float				FadeOutSongTime;

function bool InitActionFor(ScriptedController C)
{
	local PlayerController P;
	local Controller A;

	if( bAffectAllPlayers )
	{
		For ( A=C.Level.ControllerList; A!=None; A=A.nextController )
			if ( A.IsA('PlayerController') )
			{
			if (C.SongHandle != 0)
				{
				FPSGameInfo(C.Level.Game).StopMusicExt(C.SongHandle, FadeOutSongTime);
				C.SongHandle = 0;
				}
			}
	}
	else
	{
		// Only affect the one player.
		P = PlayerController(C.GetInstigator().Controller);
		if( P==None )
			return false;
			
		// Go to music.
		if (C.SongHandle != 0)
			{
			FPSGameInfo(C.Level.Game).StopMusicExt(C.SongHandle, FadeOutSongTime);
			C.SongHandle = 0;
			}
	}
	return false;	
}

defaultproperties
{
	 bAffectAllPlayers=True
	 FadeOutSongTime=1.0
	 ActionString="Stop song"
}