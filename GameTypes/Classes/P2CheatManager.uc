///////////////////////////////////////////////////////////////////////////////
// P2CheatManager
//
// Most Postal 2 cheats
//
///////////////////////////////////////////////////////////////////////////////

class P2CheatManager extends CheatManager;


var Sound FanaticsTalking;


// Assumed maxes.. could be outdated
const MAX_RAGDOLLS	=	10;
const RAGDOLL_BONES	=	17;
const BODY_MAX		=	400;
const MODEL_MAX		=	800;

const MAX_AMMO_NUM	=	999;

///////////////////////////////////////////////////////////////////////////////
// Count the total number of actors (dynamic and static) in the entire level
///////////////////////////////////////////////////////////////////////////////
exec function CountAll()
{
	local Actor checkA;
	local int i;

	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
	i=0;
	ForEach AllActors(class'Actor', checkA)
	{
		i++;
	}
	log("CountAll: Total number of actors in this level: "$i);
	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
}

///////////////////////////////////////////////////////////////////////////////
// Count the total number dynamic actors in the level (one's that don't
// have bStatic set)
///////////////////////////////////////////////////////////////////////////////
exec function CountDynamic()
{
	local Actor checkA;
	local int i;

	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
	i=0;
	ForEach DynamicActors(class'Actor', checkA)
	{
		i++;
	}
	log("CountDynamic: Total number of dynamic actors in this level: "$i);
	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
}

///////////////////////////////////////////////////////////////////////////////
// Count how much karma memory that's taken up.
// This is only for level designers so they know how many actors (and which) that
// count against the two memory pool counts of karma-using objects.
///////////////////////////////////////////////////////////////////////////////
exec function CountKarma()
{
	local Actor checkA;
	local int i, j, max;

	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
	log("CountKarma: Counting all actors Karma memory.");
	i=0;

	ForEach AllActors(class'Actor', checkA)
	{
		if(checkA.Physics == PHYS_Karma
			|| checkA.Physics == PHYS_KarmaRagDoll)
		{
			i++;
			j++;
			log("CountKarma: actor with Karma physics (body/model pool):	"$checkA);
		}
		else if(checkA.bBlockKarma)
		{
			j++;
			log("CountKarma: actor has bBlockKarma true (model only pool):	"$checkA);
		}
	}

	// We believe our skeletons have 17 bones that matter when it comes to karma memory allocation
	// We assume a max forever of 10 ragdolls.
	max = RAGDOLL_BONES*MAX_RAGDOLLS;
	log("CountKarma: Dynamic ragdoll allocation is body and model "$max);
	i+=max;
	j+=max;
	log("CountKarma: Karma 'Body' pool used:	"$i$" current max "$BODY_MAX);
	log("CountKarma: Karma 'Model' pool used:	"$j$" curret max  "$MODEL_MAX);
	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
}
exec function ListKarma()
{
	local Actor checkA;
	local int i, j, max;

	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
	log("CountKarma: Counting all actors Karma memory.");
	i=0;

	ForEach AllActors(class'Actor', checkA)
	{
		if(checkA.Physics == PHYS_Karma
			|| checkA.Physics == PHYS_KarmaRagDoll)
		{
			i++;
			j++;
			//log("CountKarma: actor with Karma physics (body/model pool):	"$checkA);
		}
		else if(checkA.bBlockKarma)
		{
			j++;
			//log("CountKarma: actor has bBlockKarma true (model only pool):	"$checkA);
		}
	}

	// We believe our skeletons have 17 bones that matter when it comes to karma memory allocation
	// We assume a max forever of 10 ragdolls.
	max = RAGDOLL_BONES*MAX_RAGDOLLS;
	log("CountKarma: Dynamic ragdoll allocation is body and model "$max);
	i+=max;
	j+=max;
	log("CountKarma: Karma 'Body' pool used:	"$i$" current max "$BODY_MAX);
	log("CountKarma: Karma 'Model' pool used:	"$j$" curret max  "$MODEL_MAX);
	log("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
}



///////////////////////////////////////////////////////////////////////////////
// Give the player this item
///////////////////////////////////////////////////////////////////////////////
exec function GrantItem(class<Inventory> NewInv)
{
	local Inventory thisinv;
	local P2PowerupInv pinv;
	local byte CreatedNow;

	thisinv = P2Pawn(Pawn).CreateInventoryByClass(NewInv, CreatedNow);

	if(CreatedNow == 0)
	{
		pinv = P2PowerupInv(thisinv);

		if(pinv != None)
		{
			pinv.AddAmount(1);
			P2Player(Outer).CommentOnCheating();
		}
	}
}

///////////////////////////////////////////////////////////////////////////////
// Stubs to make the engine level codes invalid
///////////////////////////////////////////////////////////////////////////////
exec function AllWeapons()
{
}
exec function AllAmmo()
{
}
exec function Invisible(bool B)
{
}
exec function God()
{
}
exec function SetJumpZ( float F )
{
}
exec function SetGravity( float F )
{
}
exec function SetSpeed( float F )
{
}
exec function KillAll(class<actor> aClass)
{
}
exec function KillPawns()
{
}
exec function Avatar( string ClassName )
{
}
exec function Loaded()
{
}
exec function Summon( string ClassName )
{
}
///////////////////////////////////////////////////////////////////////////////
// Used to be slomo.. appropriately now it's gamespeed
///////////////////////////////////////////////////////////////////////////////
exec function GameSpeed( float T )
{
	Level.Game.SetGameSpeed(T);
}

///////////////////////////////////////////////////////////////////////////////
// Player goes in to god mode
///////////////////////////////////////////////////////////////////////////////
exec function Alamode()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: Alamode");

	if ( bGodMode )
	{
		bGodMode = false;
		ClientMessage("God mode off");
		return;
	}

	bGodMode = true; 
	ClientMessage("God Mode on");

	P2Player(Outer).CommentOnCheating();
}


///////////////////////////////////////////////////////////////////////////////
// Gives player every destructive weapon in the game
///////////////////////////////////////////////////////////////////////////////
exec function PackNHeat()
{
	local Inventory thisinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: PackNHeat");

	P2Pawn(Pawn).CreateInventory("Inventory.BatonWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.ShovelWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.ShockerWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.PistolWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.ShotgunWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.MachinegunWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.GasCanWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.CowHeadWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.GrenadeWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.ScissorsWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.MolotovWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.RifleWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.LauncherWeapon");
	P2Pawn(Pawn).CreateInventory("Inventory.NapalmWeapon");

	if(P2GameInfoSingle(Level.Game) == None
		|| P2GameInfoSingle(Level.Game).CheckCoolness())
	{
		P2Pawn(Pawn).CreateInventory("Inventory.PlagueWeapon");
	}
	
	thisinv = P2Pawn(Pawn).Inventory;
	while(thisinv != None)
	{
		if(P2Weapon(thisinv) != None)
		{
			P2Weapon(thisinv).bJustMade=false;
		}
		thisinv = thisinv.inventory;
	}

	P2Player(Outer).CommentOnCheating();
}	

///////////////////////////////////////////////////////////////////////////////
// Sets all current weapons to have lots of ammo
///////////////////////////////////////////////////////////////////////////////
exec function PayLoad()
{
	local Inventory Inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: PayLoad");

	for( Inv=Pawn.Inventory; Inv!=None; Inv=Inv.Inventory ) 
		if (Ammunition(Inv)!=None) 
		{
			Ammunition(Inv).AmmoAmount  = MAX_AMMO_NUM;
			Ammunition(Inv).MaxAmmo  = MAX_AMMO_NUM;
		}
	P2Player(Outer).CommentOnCheating();
}	

///////////////////////////////////////////////////////////////////////////////
// Super-delux cheat gives you all weapons, with max ammo and turns you invincible.
///////////////////////////////////////////////////////////////////////////////
exec function IAmSoLame()
{
	local Inventory Inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: IAmSoLame");

	bGodMode=true;

	PackNHeat();

	PayLoad();
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player lots of doughnuts
///////////////////////////////////////////////////////////////////////////////
exec function PiggyTreats()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: PiggyTreats");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.DonutInv");

	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(19);
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give the player lots of cash
///////////////////////////////////////////////////////////////////////////////
exec function JewsForJesus()
{
	local P2PowerupInv mycash;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: JewsForJesus");

	mycash = P2PowerupInv(P2Pawn(Pawn).CreateInventoryByClass(class'MoneyInv'));

	if(mycash != None)
	{
		mycash.AddAmount(4990);
		P2Player(Outer).CommentOnCheating();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Give player lots of dog treats
///////////////////////////////////////////////////////////////////////////////
exec function BoyAndHisDog()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: BoyAndHisDog");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.DogTreatInv");

	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(19);
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player lots of health pipes
///////////////////////////////////////////////////////////////////////////////
exec function Jones()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: Jones");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.CrackInv");

	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(19);
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player all radar related items
///////////////////////////////////////////////////////////////////////////////
exec function SwimWithFishes()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: SwimWithFishes");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.RadarInv");
	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(440);
	invadd = P2Pawn(Pawn).CreateInventory("Inventory.CopRadarPlugInv");
	invadd = P2Pawn(Pawn).CreateInventory("Inventory.GunRadarPlugInv");
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Say that you're using rocket cameras
///////////////////////////////////////////////////////////////////////////////
exec function FireInYourHole()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: FireInYourHole");

	P2Player(Outer).bUseRocketCameras = !P2Player(Outer).bUseRocketCameras;
	P2Player(Outer).OldViewRotation = Rotation;
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player lots of catnip
///////////////////////////////////////////////////////////////////////////////
exec function IAmTheOne()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: IAmTheOne");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.CatnipInv");

	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(19);
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player lots of cats
///////////////////////////////////////////////////////////////////////////////
exec function LotsAPussy()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: LotsAPussy");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.CatInv");

	ppinv = P2PowerupInv(invadd);
	if(ppinv != None)
		ppinv.AddAmount(19);
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player body armor
///////////////////////////////////////////////////////////////////////////////
exec function BlockMyAss()
{
	local Inventory invadd;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: BlockMyAss");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.BodyArmorInv");
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player the gimp suit
///////////////////////////////////////////////////////////////////////////////
exec function SmackDatAss()
{
	local Inventory invadd;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: SmackDatAss");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.GimpClothesInv");

	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player the cop clothes
///////////////////////////////////////////////////////////////////////////////
exec function IAmTheLaw()
{
	local Inventory invadd;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: IAmTheLaw");

	invadd = P2Pawn(Pawn).CreateInventory("Inventory.CopClothesInv");

	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Give player full health with several medkits
///////////////////////////////////////////////////////////////////////////////
exec function Healthful()
{
	local Inventory invadd;
	local P2PowerupInv ppinv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: Healthful");

	P2Pawn(Pawn).CreateInventory("Inventory.MedKitInv");
	P2Pawn(Pawn).CreateInventory("Inventory.MedKitInv");
	P2Pawn(Pawn).CreateInventory("Inventory.MedKitInv");
	P2Pawn(Pawn).CreateInventory("Inventory.MedKitInv");
	P2Player(Outer).CommentOnCheating();
}

///////////////////////////////////////////////////////////////////////////////
// Turns every current non-player, bystander pawns into Gary Colemans
///////////////////////////////////////////////////////////////////////////////
exec function Whatchutalkinbout()
{
	DudePlayer(Outer).GarySize();
}

///////////////////////////////////////////////////////////////////////////////
// Turns every current non-player, bystander pawns into Fanatics
///////////////////////////////////////////////////////////////////////////////
exec function Osama()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: Osama");

	ClientMessage("Fanaticizing your bystanders--please wait.");

	DudePlayer(Outer).ConvertNonImportants(class'Fanatics',,,true,,true);
	DudePlayer(Outer).ConvertNonImportants(class'Kumquat',,,true,true);

	DudePlayer(Outer).MyPawn.PlaySound(FanaticsTalking);
}

///////////////////////////////////////////////////////////////////////////////
// Change any guns that can have cats on them to constantly have a cat on 
// and shoot off the cat everytime with a new one magically reappearing.
///////////////////////////////////////////////////////////////////////////////
exec function RockinCats()
{
	local Inventory inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: RockinCats");

	inv = Pawn.Inventory;
	while(inv != None)
	{
		if(CatableWeapon(inv) != None)
			CatableWeapon(inv).ToggleRepeatCatGun(true);
		inv = inv.Inventory;
	}
	P2Player(Outer).CommentOnCheating();
}
// Removes cat repeating guns (turns them back to normal versions)
exec function DokkinCats()
{
	local Inventory inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: DokkinCats");

	inv = Pawn.Inventory;
	while(inv != None)
	{
		if(CatableWeapon(inv) != None)
			CatableWeapon(inv).ToggleRepeatCatGun(false);
		inv = inv.Inventory;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Makes cats that shoot off guns will bounce off walls or not. These
// cats will bounce for a good while before exploding. If they hit people though,
// they'll explode on contact.
///////////////////////////////////////////////////////////////////////////////
exec function BoppinCats()
{
	local Inventory inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: BoppinCats");

	inv = Pawn.Inventory;
	while(inv != None)
	{
		if(CatableWeapon(inv) != None)
			CatableWeapon(inv).BounceCat=1;
		inv = inv.Inventory;
	}
	P2Player(Outer).CommentOnCheating();
}
///////////////////////////////////////////////////////////////////////////////
// Turns off the BoppinCats power (makes cats like normal--they explode on contact
// after being launched off your gun).
///////////////////////////////////////////////////////////////////////////////
exec function SplodinCats()
{
	local Inventory inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: SplodinCats");

	inv = Pawn.Inventory;
	while(inv != None)
	{
		if(CatableWeapon(inv) != None)
			CatableWeapon(inv).BounceCat=0;
		inv = inv.Inventory;
	}
}

///////////////////////////////////////////////////////////////////////////////
// Shoot bouncing scissors from the machine gun! It's WaCKy!
///////////////////////////////////////////////////////////////////////////////
exec function NowWeDance()
{
	local MachinegunWeapon inv;

	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: NowWeDance");

	Inv = MachinegunWeapon(P2Player(Outer).MyPawn.FindInventoryType(class'MachineGunWeapon'));

	if(Inv != None)
	{
		if(inv.ShootScissors == 0)
		{
			P2Player(Outer).CommentOnCheating();
			inv.ShootScissors=1;
		}
		else
			inv.ShootScissors=0;
	}
}


///////////////////////////////////////////////////////////////////////////////
// Ghost mode
///////////////////////////////////////////////////////////////////////////////
exec function IFeelFree()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: IFeelFree");

	// Set ghost mode if you aren't exactly in ghost mode 
	if(!(bCheatFlying
		&& !Pawn.bCollideWorld))
	{
		Pawn.UnderWaterTime = -1.0;	
		ClientMessage("You feel free.");
		Pawn.SetCollision(false, false, false);
		Pawn.bCollideWorld = false;
		bCheatFlying = true;
		Outer.GotoState('PlayerFlying');
	}
	else
	{
		ResetFlying();
	}
}

///////////////////////////////////////////////////////////////////////////////
// Fly mode
///////////////////////////////////////////////////////////////////////////////
exec function LikeABirdy()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: LikeABirdy");

	// Set Fly mode if you aren't exactly in Fly mode 
	if(!(bCheatFlying
		&& Pawn.bCollideWorld))
	{
		Pawn.UnderWaterTime = Pawn.Default.UnderWaterTime;	
		ClientMessage("You feel much lighter.");
		Pawn.SetCollision(true, true , true);
		Pawn.bCollideWorld = true;
		bCheatFlying = true;
		Outer.GotoState('PlayerFlying');
	}
	else
	{
		ResetFlying();
	}
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
function ResetFlying()
{	
	if ( Pawn != None )
	{
		bCheatFlying = false;
		Pawn.UnderWaterTime = Pawn.Default.UnderWaterTime;	
		Pawn.SetCollision(true, true , true);
		Pawn.SetPhysics(PHYS_Walking);
		Pawn.bCollideWorld = true;
		ClientReStart();
	}
}

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
exec function ViewClass( class<actor> aClass, optional bool bQuiet, optional bool bCheat )
{
	local actor other, first;
	local bool bFound;

	if(P2GameInfo(Level.Game) == None
		|| !FPSPlayer(Outer).DebugEnabled())
		return;

	if ( !bCheat && (Level.Game != None) && !Level.Game.bCanViewOthers )
		return;

	first = None;

	ForEach AllActors( aClass, other )
	{
		if ( bFound || (first == None) )
		{
			first = other;
			if ( bFound )
				break;
		}
		if ( other == ViewTarget ) 
			bFound = true;
	}  

	if ( first != None )
	{
		if ( !bQuiet )
		{
			if ( Pawn(first) != None )
				ClientMessage(ViewingFrom@First.GetHumanReadableName(), 'Event');
			else
				ClientMessage(ViewingFrom@first, 'Event');
		}
		SetViewTarget(first);
		bBehindView = ( ViewTarget != outer );

		if ( bBehindView )
			ViewTarget.BecomeViewTarget();

		FixFOV();
	}
	else
		ViewSelf(bQuiet);
}

///////////////////////////////////////////////////////////////////////////////
// In addition to our goofy versions, we allow the old versions, if the cheats
// are enabled.
///////////////////////////////////////////////////////////////////////////////
exec function Fly()
{
	if(P2Player(Outer).CheatsAllowed())
		Super.Fly();	// Come on.. laugh! That's funny! The dude is SuperFly...
}
exec function Walk()
{	
	if(P2Player(Outer).CheatsAllowed())
		Super.Walk();
}
exec function Ghost()
{
	if(P2Player(Outer).CheatsAllowed())
		Super.Ghost();
}
exec function Slomo( float T )
{
	if(P2Player(Outer).CheatsAllowed())
		Level.Game.SetGameSpeed(T);
//		Level.Game.SaveConfig(); 
//		Level.Game.GameReplicationInfo.SaveConfig();
}

///////////////////////////////////////////////////////////////////////////////
// Dangerous! Who knows how things like the clipboard or whatever will act
// if you set the ammo on that.
// Set ammo directly (changes max also)
///////////////////////////////////////////////////////////////////////////////
exec function FeelLuckyPunk(int T)
{
	local P2Weapon p2w;
	if(!P2Player(Outer).CheatsAllowed()
		|| P2Player(Outer).MyPawn == None)
		return;

	p2w = P2Weapon(P2Player(Outer).MyPawn.Weapon);
	if(p2w != None
		&& p2w.AmmoType != None)
	{
		if(T < 0)
			T = 0;
		if(T > MAX_AMMO_NUM)
			T = MAX_AMMO_NUM;
		if(T > p2w.AmmoType.MaxAmmo)
			p2w.AmmoType.MaxAmmo = T;
		p2w.AmmoType.AmmoAmount = T;
	}

}

///////////////////////////////////////////////////////////////////////////////
// Put this in becuase some people we're whining about 'releastic body damage'.
// So anyway, this makes it so any bullet shot from a gun will kill any person
// in one shot if they get hit in the head by the bullet. With the exception
// of the rifle and the shotgun (they already have their own headshot kills).
// So gosh.. guess we're just down to the pistol and the machinegun. 
///////////////////////////////////////////////////////////////////////////////
exec function HeadShots()
{
	if(!P2Player(Outer).CheatsAllowed())
		return;

	log(self$" CHEAT: HeadShots");

	if(P2GameInfoSingle(Level.Game) != None
		&& P2GameInfoSingle(Level.Game).TheGameState != None)
	{
		if(!P2GameInfoSingle(Level.Game).TheGameState.bGetsHeadShots)
		{
			P2GameInfoSingle(Level.Game).TheGameState.bGetsHeadShots = true;
			ClientMessage("Increased head shot damage: enabled.");
		}
		else
		{
			P2GameInfoSingle(Level.Game).TheGameState.bGetsHeadShots = false;
			ClientMessage("Increased head shot damage: disabled.");
		}
	}
}


defaultproperties
{
	FanaticsTalking=Sound'HabibDialog.habib_ailili'
}
