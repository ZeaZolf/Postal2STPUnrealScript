///////////////////////////////////////////////////////////////////////////////
// GimpClothesInv
// Copyright 2002 Running With Scissors, Inc.  All Rights Reserved.
//
// Clothing inventory item. You're not wearing this, you have it
// folded up right now, so it's not active.
//
// Wear this to act like the Gimp.
//
///////////////////////////////////////////////////////////////////////////////

class GimpClothesInv extends ClothesInv;


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	PickupClass=class'GimpClothesPickup'
	Icon=Texture'hudpack.icons.Icon_Inv_GimpUniform'
	InventoryGroup =110
	Price=0
	bPaidFor=true
	LegalOwnerTag=""
	HudSplats[0]=Texture'nathans.Inventory.b_Spike_Collar'
	HudSplats[1]=Texture'nathans.Inventory.b_Spike_Collar'
	HudSplats[2]=Texture'nathans.Inventory.b_Spike_Collar'
	HandsTexture=Texture'MP_FPArms.LS_arms.LS_hands_gimp'
	FootTexture=Texture'ChameleonSkins.Special.Gimp'
	BodyMesh=Mesh'Characters.Avg_Gimp'
	BodySkin=Texture'ChameleonSkins.Special.Gimp'
	HeadMesh = SkeletalMesh'Heads.Masked'
	HeadSkin = Texture'ChamelHeadSkins.Special.Gimp'
	Hint1="Press Enter to wear"
	Hint2="gimp outfit."
	Hint3=""
	}
