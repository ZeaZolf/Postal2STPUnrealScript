///////////////////////////////////////////////////////////////////////////////
// CopClothesInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Clothing inventory item. You're not wearing this, you have it
// folded up right now, so it's not active.
//
// This is the dudes original clothes for when he's wearing some other
// outfit.
//
///////////////////////////////////////////////////////////////////////////////

class CopClothesInv extends ClothesInv;


///////////////////////////////////////////////////////////////////////////////
// Record that we used dressed up like a cop
///////////////////////////////////////////////////////////////////////////////
function ChangeWorked(P2Player p2p)
{
	if(P2GameInfoSingle(Level.Game) != None
		&& P2GameInfoSingle(Level.Game).TheGameState != None)
	{
		P2GameInfoSingle(Level.Game).TheGameState.DressedAsCop++;
		p2p.BecomingCop();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'CopClothesPickup'
	Icon=Texture'HUDPack.Icon_Inv_CopUniform'
	InventoryGroup =108
	Price=0
	bPaidFor=true
	LegalOwnerTag=""
	HudSplats[0]=Texture'nathans.Inventory.b_Star_Shield'
	HudSplats[1]=Texture'nathans.Inventory.b_Star_Shield'
	HudSplats[2]=Texture'nathans.Inventory.b_Star_Shield'
	HandsTexture=Texture'MP_FPArms.LS_hands_robber'
	FootTexture = Texture'ChameleonSkins.Dude_Cop'
	BodyMesh = SkeletalMesh'Characters.Avg_M_SS_Pants'
	BodySkin = Texture'ChameleonSkins.Dude_Cop'
	HeadMesh = SkeletalMesh'Heads.AvgDude'
	HeadSkin = Texture'ChamelHeadSkins.Special.Dude'
	Hint1="Press Enter to wear"
	Hint2="police uniform."
	Hint3=""
	bAllowKeep=false
	}
