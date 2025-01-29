///////////////////////////////////////////////////////////////////////////////
// P2GameInfoMulti.uc
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for multi player games
//
///////////////////////////////////////////////////////////////////////////////
class P2GameInfoMulti extends P2GameInfo;


///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////
// Spawn any default inventory for the player.
///////////////////////////////////////////////////////////////////////////////
function AddDefaultInventory( pawn PlayerPawn )
	{
	// For multiplayer games, we add this to the player here
	P2Pawn(PlayerPawn).AddDefaultInventory();

	Super.AddDefaultInventory(PlayerPawn);
	}

function P2Player GetPlayer()
{
	local controller con;

	for(con = Level.ControllerList; con != None; con = con.NextController)
		if(P2Player(con) != None && con.Pawn.RemoteRole == ROLE_AutonomousProxy)
			return P2Player(con);

	return None;
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	bIsSingleplayer=false;
	}
