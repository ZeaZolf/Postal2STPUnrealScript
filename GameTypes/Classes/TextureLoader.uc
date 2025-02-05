///////////////////////////////////////////////////////////////////////////////
// TextureLoader.uc
// Copyright 2003 Running With Scissors, Inc.  All Rights Reserved.
//
// By placing
// this in Entry, it maintains a reference to textures to keep them from being
// loaded over and over.
//
///////////////////////////////////////////////////////////////////////////////
class TextureLoader extends Info
	config(system)
	placeable;

///////////////////////////////////////////////////////////////////////////////
// Vars, structs, consts, enums...
///////////////////////////////////////////////////////////////////////////////

// 1 means it will maintain references to a lot of textures using the TextureLoader in the Entry level. 
// 0 means it won't let the TextureLoader do anything.
var ()globalconfig int PreloadTexturesOnStartup;

var() array<Material> CheckTextures;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ClearArray()
{
	CheckTextures.Remove(0, CheckTextures.Length);
	log(self$" cleared array ");
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function AddTexture(Material addme)
{
	local int i;

	if(PreloadTexturesOnStartup != 0)
	{
		// Check first if it's already in there
		for(i=0; i<CheckTextures.Length; i++)
		{
			// It's already in there, so get out
			if(CheckTextures[i] == addme)
			{
				//log(self$" already have "$addme$" at "$i);
				return;
			}
		}

		i = CheckTextures.Length;
		CheckTextures.Insert(i, 1);
		CheckTextures[i] = addme;
		log(self$" added "$addme$" at "$i);
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PreloadTexturesOnStartup=1
	}
