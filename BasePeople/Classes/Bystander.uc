//=============================================================================
// Bystander
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Base class for all bystander characters.
//
//=============================================================================
class Bystander extends PersonPawn
	notplaceable
	Abstract;


defaultproperties
	{
	Conscience=0.2
	SafeRangeMin=1024
	HealthMax=55
	ControllerClass=class'BystanderController'
	bIsTrained=false

	ChamelHeadSkins(0)="ChamelHeadSkins.MWA__001__AvgMale"
	ChamelHeadSkins(1)="ChamelHeadSkins.MBA__013__AvgBrotha"
	ChamelHeadSkins(2)="ChamelHeadSkins.MBA__014__AvgBrotha"
	ChamelHeadSkins(3)="ChamelHeadSkins.MMA__016__AvgMale"
	ChamelHeadSkins(4)="ChamelHeadSkins.MMF__024__FatMale"
	ChamelHeadSkins(5)="ChamelHeadSkins.MWA__002__AvgMale"
	ChamelHeadSkins(6)="ChamelHeadSkins.MMA__003__AvgMale"
	ChamelHeadSkins(7)="ChamelHeadSkins.MWA__004__AvgMale"
	ChamelHeadSkins(8)="ChamelHeadSkins.MWA__005__AvgMale"
	ChamelHeadSkins(9)="ChamelHeadSkins.MWA__006__AvgMale"
	ChamelHeadSkins(10)="ChamelHeadSkins.MWA__007__AvgMale"
	ChamelHeadSkins(11)="ChamelHeadSkins.MWA__008__AvgMale"
	ChamelHeadSkins(12)="ChamelHeadSkins.MWA__009__AvgMale"
	ChamelHeadSkins(13)="ChamelHeadSkins.MWA__010__AvgMale"
	ChamelHeadSkins(14)="ChamelHeadSkins.MWA__011__AvgMale"
	ChamelHeadSkins(15)="ChamelHeadSkins.MWA__015__AvgMale"
	ChamelHeadSkins(16)="ChamelHeadSkins.MWA__021__AvgMaleBig"
	ChamelHeadSkins(17)="ChamelHeadSkins.MWA__035__AvgMale"
	ChamelHeadSkins(18)="ChamelHeadSkins.MWF__025__FatMale"
	ChamelHeadSkins(19)="ChamelHeadSkins.MWA__022__AvgMaleBig"
	ChamelHeadSkins(20)="ChamelHeadSkins.FBA__033__FemSH"
	ChamelHeadSkins(21)="ChamelHeadSkins.FMA__028__FemSH"
	ChamelHeadSkins(22)="ChamelHeadSkins.FMA__034__FemSH"
	ChamelHeadSkins(23)="ChamelHeadSkins.FWA__026__FemLH"
	ChamelHeadSkins(24)="ChamelHeadSkins.FWA__027__FemLH"
	ChamelHeadSkins(25)="ChamelHeadSkins.FWA__029__FemSH"
	ChamelHeadSkins(26)="ChamelHeadSkins.FWA__032__FemSH"
	ChamelHeadSkins(27)="ChamelHeadSkins.FWF__023__FatFem"
	ChamelHeadSkins(28)="ChamelHeadSkins.FWA__037__FemSHcropped"
	ChamelHeadSkins(29)="ChamelHeadSkins.FMA__038__FemSHcropped"
	ChamelHeadSkins(30)="ChamelHeadSkins.FMA__039__FemSHcropped"
	ChamelHeadSkins(31)="ChamelHeadSkins.FWA__040__FemSHcropped"
	ChamelHeadSkins(32)="ChamelHeadSkins.MBF__042__FatMale"
	ChamelHeadSkins(33)="ChamelHeadSkins.FBF__043__FatFem"
	ChamelHeadSkins(34)="ChamelHeadSkins.FMF__044__FatFem"
	ChamelHeadSkins(35)="ChamelHeadSkins.FWA__031__FemSH"
	ChamelHeadSkins(36)="ChamelHeadSkins.FBA__063__FemSH"
	ChamelHeadSkins(37)="end"	// end-of-list marker (in case super defines more skins)
	}
