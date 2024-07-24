///////////////////////////////////////////////////////////////////////////////
// DialogDude
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Dialog for Dude
//
//	History:
//		02/09/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class DialogDude extends DialogMale;


///////////////////////////////////////////////////////////////////////////////
// Fill in this character's lines
///////////////////////////////////////////////////////////////////////////////
function FillInLines()
	{
	// Let super go first
	Super.FillInLines();

	Clear(lGreeting);
	AddTo(lGreeting,								"DudeDialog.dude_hithere", 1);
	
	Clear(lRespondToGreeting);
	AddTo(lRespondToGreeting,						"DudeDialog.dude_hi", 1);

	Clear(lYes);
	AddTo(lYes,										"DudeDialog.dude_yes", 1);

	Clear(lNo);
	AddTo(lNo,										"DudeDialog.dude_no", 1);

	Clear(lThanks);
	AddTo(lThanks,										"DudeDialog.dude_thanks2", 1);

	Clear(lDude_Arrested);
	AddTo(lDude_Arrested,							"DudeDialog.dude_okaytakemein", 1);
	AddTo(lDude_Arrested,							"DudeDialog.dude_yeahblahjustcuff", 1);
	AddTo(lDude_Arrested,							"DudeDialog.dude_ihavefaithinsys", 1);
	AddTo(lDude_Arrested,							"DudeDialog.dude_ineededavacation", 2);
	AddTo(lDude_Arrested,							"DudeDialog.dude_cmonhurryup", 2);
	AddTo(lDude_Arrested,							"DudeDialog.dude_heyitsnotmyfault", 3);

	Clear(lDude_EscapeJail);
	AddTo(lDude_EscapeJail,							"DudeDialog.dude_ahjail", 1);
	AddTo(lDude_EscapeJail,							"DudeDialog.dude_imboredalready", 1);
	AddTo(lDude_EscapeJail,							"DudeDialog.dude_nojailcanholdme", 2);
//	AddTo(lDude_EscapeJail,							"DudeDialog.dude_ohlooktheyleft", 1); Makes no sense
//	AddTo(lDude_EscapeJail,							"DudeDialog.dude_heytheyleftthe", 2);
//	AddTo(lDude_EscapeJail,							"DudeDialog.dude_illbetthatdooris", 3);
//	AddTo(lDude_EscapeJail,							"DudeDialog.dude_maybeishouldtry", 3);

	Clear(lDude_JailHint);
	AddTo(lDude_JailHint,							"DudeDialog.dude_ohlookistill", 1);

//	Clear(lDude_BecomeCop1);
//	AddTo(lDude_BecomeCop1,							"DudeDialog.dude_saywhatsthis", 1);

	Clear(lDude_BecomingCop);
	AddTo(lDude_BecomingCop,						"DudeDialog.dude_thisisgonnabe", 1);

	Clear(lDude_NowIsCop);
	AddTo(lDude_NowIsCop,							"DudeDialog.dude_iamthelaw", 1);

	Clear(lDude_NowIsDude);
	AddTo(lDude_NowIsDude,							"DudeDialog.dude_gunsdontkill", 1);

	Clear(lDude_AttackAsCop);
	AddTo(lDude_AttackAsCop,							"DudeDialog.dude_nothingtoseehere", 1);
	AddTo(lDude_AttackAsCop,							"DudeDialog.dude_movealong", 1);
	AddTo(lDude_AttackAsCop,							"DudeDialog.dude_geeisurehope", 2);
	AddTo(lDude_AttackAsCop,							"DudeDialog.dude_someonestolemy", 2);

	Clear(lDude_FirstSeenWithWeapon);
	Addto(lDude_FirstSeenWithWeapon,				"DudeDialog.dude_heyimJustexercise", 1);

	Clear(lDude_WeaponFirstUse);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_sothatswhatthat", 1);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_fascinating", 1);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_ohigetit", 1);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_yess", 2);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_sweet", 2);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_ohlikethatsnot", 3);
	AddTo(lDude_WeaponFirstUse,						"DudeDialog.dude_viagraworks", 3);

	Clear(lDude_ThrowGrenade);
	AddTo(lDude_ThrowGrenade,						"DudeDialog.dude_herecatch", 1);
	AddTo(lDude_ThrowGrenade,						"DudeDialog.dude_golong", 1);

	Clear(lDude_KillWithGun);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_gunsdontkill", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_mypresidentis", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_onlymyweapon", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_isupposeitwould", 1);
// This line needs to be when he just hurts someone, but we don't have enough of those, maybe?
//	AddTo(lDude_KillWithGun,						"DudeDialog.dude_imsorryimeantto", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_youprobablythink", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_andonetogrowon", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_dontcrowdtheres", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_todaysthefirst", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_howwouldyoulike", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_yougogirl", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_haveaniceday", 1);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_damnhereiwas", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_youthoughtyou", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_thatstheone", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_iknowwhatyoure", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_yeahthatswhat", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_thisgenepoolis", 2);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_hehhehheh", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_sorry", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_justkiddin", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_ohthatsgottahurt", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_thatsgoingto", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_buttsauce", 3);
	AddTo(lDude_KillWithGun,						"DudeDialog.dude_imsoryapparently", 3);

	Clear(lDude_KillWithProjectile);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_nicecatch", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_isupposeitwould", 1);
// This line needs to be when he just hurts someone, but we don't have enough of those, maybe?
//	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_imsorryimeantto", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_youprobablythink", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_andonetogrowon", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_dontcrowdtheres", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_todaysthefirst", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_howwouldyoulike", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_damnhereiwas", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_yougogirl", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_haveaniceday", 1);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_youthoughtyou", 2);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_thatstheone", 2);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_iknowwhatyoure", 2);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_yeahthatswhat", 2);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_hehhehheh", 3);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_sorry", 3);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_justkiddin", 3);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_ohthatsgottahurt", 3);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_thatsgoingto", 3);
	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_buttsauce", 3);
//	AddTo(lDude_KillWithProjectile,					"DudeDialog.dude_iseedeadpeople", 1);

	Clear(lDude_KillWithMelee);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_isupposeitwould", 1);
// This line needs to be when he just hurts someone, but we don't have enough of those, maybe?
//	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_imsorryimeantto", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_youprobablythink", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_andonetogrowon", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_dontcrowdtheres", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_todaysthefirst", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_howwouldyoulike", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_damnhereiwas", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_yougogirl", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_haveaniceday", 1);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_youthoughtyou", 2);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_thatstheone", 2);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_iknowwhatyoure", 2);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_yeahthatswhat", 2);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_hehhehheh", 2);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_sorry", 3);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_justkiddin", 3);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_ohthatsgottahurt", 3);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_thatsgoingto", 3);
	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_buttsauce", 3);
//	AddTo(lDude_KillWithMelee,						"DudeDialog.dude_iseedeadpeople", 1);

	Clear(lDude_QuickKills);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_oneforyourmother", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_oneforthepope", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_oneforjohnny", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_oneforbebo", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_onecauseugly", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_onebecauseican", 1);
	AddTo(lDude_QuickKills,							"DudeDialog.dude_onebecauseihave", 1);

	Clear(lDude_PlayerCheating);
	AddTo(lDude_PlayerCheating,						"DudeDialog.dude_yougogirl", 1);
	AddTo(lDude_PlayerCheating,						"DudeDialog.dude_youvegottabekid", 1);
	AddTo(lDude_PlayerCheating,						"DudeDialog.dude_buttsauce", 3);

	Clear(lDude_PlayerSissy);
	AddTo(lDude_PlayerSissy,						"DudeDialog.dude_sissy", 1);

	Clear(lDude_ReusedPeople);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_damndothesepeople", 1);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_definitelysome", 1);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_heylookitsuncle", 1);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_holyshitimnot", 2);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_thisgenepoolis", 2);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_andjoebobsonof", 2);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_grandfatherof", 3);
	AddTo(lDude_ReusedPeople,						"DudeDialog.dude_woulditbesafeto", 3);

	Clear(lDude_BurningPeople);
	AddTo(lDude_BurningPeople,						"DudeDialog.dude_saythatactually", 1);
	AddTo(lDude_BurningPeople,						"DudeDialog.dude_slowroastedgood", 1);
	AddTo(lDude_BurningPeople,						"DudeDialog.dude_smellslikechick", 1);

	Clear(lDude_ShootMinorities);
	AddTo(lDude_ShootMinorities,						"DudeDialog.dude_igotyeraffirm", 1);
	AddTo(lDude_ShootMinorities,						"DudeDialog.dude_pleasedontthink", 1);
	AddTo(lDude_ShootMinorities,						"DudeDialog.dude_imanequalopport", 2);
	AddTo(lDude_ShootMinorities,						"DudeDialog.dude_nowthatswhaticall", 2);

	Clear(lDude_ShootGays);
	AddTo(lDude_ShootGays,						"DudeDialog.dude_sorryfolksbible", 1);

	Clear(lDude_ShootOlds);
	AddTo(lDude_ShootOlds,						"DudeDialog.dude_justcallmedr", 1);
	AddTo(lDude_ShootOlds,						"DudeDialog.dude_rightaboutnow", 1);
	AddTo(lDude_ShootOlds,						"DudeDialog.dude_hehiknowyouve", 2);
	AddTo(lDude_ShootOlds,						"DudeDialog.dude_oohmedicareaint", 2);

	Clear(lDude_ShootBum);
	AddTo(lDude_ShootBum,						"DudeDialog.dude_heressomeleadfor", 1);
	AddTo(lDude_ShootBum,						"DudeDialog.dude_heresyertaxrelief", 2);
	AddTo(lDude_ShootBum,						"DudeDialog.dude_nowthatswhaticall", 3);

	Clear(lDude_DidSomethingCool);
	AddTo(lDude_DidSomethingCool,						"DudeDialog.dude_wellwhodathought", 1);
	AddTo(lDude_DidSomethingCool,						"DudeDialog.dude_thatsdefinitely", 1);
	AddTo(lDude_DidSomethingCool,						"DudeDialog.dude_geethatwasntso", 2);

	Clear(lPissing);
	AddTo(lPissing,						"DudeDialog.dude_ohyeah", 1);
	AddTo(lPissing,						"DudeDialog.dude_thatstheticket", 1);
	AddTo(lPissing,						"DudeDialog.dude_sigh", 2);
	AddTo(lPissing,						"DudeDialog.dude_nowtheflowers", 2);

	Clear(lPissOnSelf);
	AddTo(lPissOnSelf,						"DudeDialog.dude_pissingonself", 1);
	
	Clear(lPissOutFireOnSelf);
	AddTo(lPissOutFireOnSelf,				"DudeDialog.dude_thatstheticket", 1);
	AddTo(lPissOutFireOnSelf,				"DudeDialog.dude_ohyeah", 1);
	AddTo(lPissOutFireOnSelf,				"DudeDialog.dude_sigh", 2);
	
	Clear(lDude_SniperBreathing);
	AddTo(lDude_SniperBreathing,					"WeaponSounds.sniper_zoombreathing", 1);

	Clear(lDude_RetortToNameCalling);
	AddTo(lDude_RetortToNameCalling,				"DudeDialog.dude_howwouldyoulike", 1);

	Clear(lDude_LongLine);
	AddTo(lDude_LongLine,						"DudeDialog.dude_everyonesameidea", 1);
	AddTo(lDude_LongLine,						"DudeDialog.dude_quiteawait", 1);
	AddTo(lDude_LongLine,						"DudeDialog.dude_donttheyhavejobs", 1);
	AddTo(lDude_LongLine,						"DudeDialog.dude_lineinevitable", 2);
	AddTo(lDude_LongLine,						"DudeDialog.dude_lookslikemeeting", 2);

	Clear(lLackOfMoney);	
	AddTo(lLackOfMoney,						"DudeDialog.dude_hmmalloutofcash", 1);
	AddTo(lLackOfMoney,						"DudeDialog.dude_hmmalloutofcash2", 2);

	Clear(lDude_RandomLevel);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_ifeellikeillget", 1);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_nothingacoatof", 1);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_whoeverdesigned", 2);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_doesmyvoiceannoy", 2);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_noreallydoesthe", 3);
	AddTo(lDude_RandomLevel,						"DudeDialog.dude_ifthesheriff", 3);

	Clear(lDude_CantBeGood);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_wasthatsupposed", 1);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_youvegottabe", 1);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_thatsclearly", 2);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_thatcantbegood", 2);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_ididntexpectthat", 3);
	AddTo(lDude_CantBeGood,						"DudeDialog.dude_howconvenient", 3);

	Clear(lGotHitInCrotch);	
	AddTo(lGotHitInCrotch,						"DudeDialog.dude_ohmynads", 1);

	Clear(lGotHit);	
	AddTo(lGotHit,							"DudeDialog.dude_damnthatstings", 1);
	AddTo(lGotHit,							"DudeDialog.dude_owmyclavichord", 1);
	AddTo(lGotHit,							"DudeDialog.dude_ohrightinthestuff", 1);
	AddTo(lGotHit,							"DudeDialog.dude_ohthatcanthave", 1);
	AddTo(lGotHit,							"DudeDialog.dude_ohmommy", 1);
	AddTo(lGotHit,							"DudeDialog.dude_aughthatsgonnabe2", 1);
	AddTo(lGotHit,							"DudeDialog.dude_heynowicantfeel", 1);
	AddTo(lGotHit,							"DudeDialog.dude_ughnowmyspleens", 1);
	AddTo(lGotHit,							"DudeDialog.dude_owsothatswhatthat", 1);
	AddTo(lGotHit,							"DudeDialog.dude_excusemewhilei", 1);

	Clear(lGrunt);
	AddTo(lGrunt,						"DudeDialog.dude_oof", 1);
	AddTo(lGrunt,						"DudeDialog.dude_augh", 1);
	AddTo(lGrunt,						"DudeDialog.dude_augh2", 1);
	AddTo(lGrunt,						"DudeDialog.dude_ow", 1);
	AddTo(lGrunt,						"DudeDialog.dude_whuff", 2);
	AddTo(lGrunt,						"DudeDialog.dude_ak", 2);
	AddTo(lGrunt,						"DudeDialog.dude_augh3", 3);

	Clear(lCussing);
	AddTo(lCussing,						"DudeDialog.dude_shit", 1);
	AddTo(lCussing,						"DudeDialog.dude_fuck", 1);

	Clear(lGetDown);
	AddTo(lGetDown,								"DudeDialog.dude_getdown", 1);
	AddTo(lGetDown,								"DudeDialog.dude_getdownifyoudont", 1);
	AddTo(lGetDown,								"DudeDialog.dude_getthefuckdown", 1);
												
	Clear(lGetDownMP);
	AddTo(lGetDownMP,							"DudeDialog.dude_getdown", 1);
	AddTo(lGetDownMP,							"DudeDialog.dude_getdownifyoudont", 1);
	AddTo(lGetDownMP,							"DudeDialog.dude_getthefuckdown", 1);
												
	Clear(lFollowMe);
	AddTo(lFollowMe,							"DudeDialog.dude_movealong", 1);
												
	Clear(lStayHere);
	Addto(lStayHere,							"DudeDialog.dude_getdown", 1);

	Clear(lDude_CloseEnough);
	AddTo(lDude_CloseEnough,						"DudeDialog.dude_closeenough", 1);

	Clear(lLastWords);
	AddTo(lLastWords,						"DudeDialog.dude_alliwantedwas", 1);
	AddTo(lLastWords,						"DudeDialog.dude_ifthereweregun", 1);
	AddTo(lLastWords,						"DudeDialog.dude_cantwealljustget", 1);
	
//	Clear(lDude_Suicide);
//	AddTo(lDude_Suicide,						"DudeDialog.dude_iregretnothing", 1);

	Clear(lDude_Arcade);	
	AddTo(lDude_Arcade,					"DudeDialog.dude_videogamesdont", 1);

//	Clear(lDude_Bum);	
//	AddTo(dude_itsyourluckyday,					"DudeDialog.dude_itsyourluckyday", 1);

	Clear(lDude_GottaBeKidding);	
	AddTo(lDude_GottaBeKidding,						"DudeDialog.dude_youvegottabekid", 1);

	Clear(lNegativeResponse);	
	AddTo(lNegativeResponse,						"DudeDialog.dude_youvegottabekid", 1);
	AddTo(lNegativeResponse,						"DudeDialog.dude_fuckyou", 1);
	AddTo(lNegativeResponse,						"DudeDialog.dude_shutupmoron", 1);
	AddTo(lNegativeResponse,						"DudeDialog.dude_idontthinkso", 2);
	AddTo(lNegativeResponse,						"DudeDialog.dude_notachance", 2);
	AddTo(lNegativeResponse,						"DudeDialog.dude_idontthinkso2", 3);

	Clear(lPositiveResponse);
	AddTo(lPositiveResponse,						"DudeDialog.dude_sure", 1);
	AddTo(lPositiveResponse,						"DudeDialog.dude_ifyousayso", 1);
	//AddTo(lPositiveResponse,						"DudeDialog.dude_icanbuythat", 1);
	AddTo(lPositiveResponse,						"DudeDialog.dude_soundsreasonable", 2);
	AddTo(lPositiveResponse,						"DudeDialog.dude_okay", 2);

	Clear(lNegativeResponseCashier);	
	AddTo(lNegativeResponseCashier,					"DudeDialog.dude_youvegottabekid", 1);
	AddTo(lNegativeResponseCashier,					"DudeDialog.dude_fuckyou", 1);
	AddTo(lNegativeResponseCashier,					"DudeDialog.dude_shit", 1);

	Clear(lApologize);
	AddTo(lApologize,								"DudeDialog.dude_imsowrong", 1);
	AddTo(lApologize,								"DudeDialog.dude_imsorry", 1);
	AddTo(lApologize,								"DudeDialog.dude_oops", 2);
	AddTo(lApologize,								"DudeDialog.dude_mybad", 2);
	AddTo(lApologize,								"DudeDialog.dude_thatwasbadofme", 3);

	Clear(lDude_GetFired);
	AddTo(lDude_GetFired,						"DudeDialog.dude_butijuststarted", 1);

	Clear(lDude_HaveToPee);
	AddTo(lDude_HaveToPee,						"DudeDialog.dude_ivegottatakea", 1);
	AddTo(lDude_HaveToPee,						"DudeDialog.dude_ivereallygotta", 1);
	AddTo(lDude_HaveToPee,						"DudeDialog.dude_ineedtotakeapiss", 1);
	AddTo(lDude_HaveToPee,						"DudeDialog.dude_imreallygonna", 2);

	Clear(lDude_HasDisease);
	AddTo(lDude_HasDisease,						"DudeDialog.dude_owoohthatcantbe", 1);
	AddTo(lDude_HasDisease,						"DudeDialog.dude_jeezbetterget", 2);

	Clear(lGotHealth);
	AddTo(lGotHealth,							"DudeDialog.dude_thatstuffreally", 1);
	AddTo(lGotHealth,							"DudeDialog.dude_ifeelbetter", 1);
	AddTo(lGotHealth,							"DudeDialog.dude_aahthatsthestuff", 2);
	AddTo(lGotHealth,							"DudeDialog.dude_idefinitelyneed", 2);
	AddTo(lGotHealth,							"DudeDialog.dude_igottafindmore", 3);

	Clear(lGotHealthFood);
	AddTo(lGotHealthFood,						"DudeDialog.dude_thatstuffreally", 1);
	AddTo(lGotHealthFood,						"DudeDialog.dude_ifeelbetter", 1);
	AddTo(lGotHealthFood,						"DudeDialog.dude_aahthatsthestuff", 2);
	AddTo(lGotHealthFood,						"DudeDialog.dude_idefinitelyneed", 2);
	AddTo(lGotHealthFood,						"DudeDialog.dude_igottafindmore", 3);

	Clear(lDude_CuredGonorrhea);
	AddTo(lDude_CuredGonorrhea,					"DudeDialog.dude_ifeelbetter", 1);

	Clear(lDude_SmokedCatnip);
	AddTo(lDude_SmokedCatnip,					"DudeDialog.dude_thewallsare", 1);
	AddTo(lDude_SmokedCatnip,					"DudeDialog.dude_yeahbabyiam", 1);
	AddTo(lDude_SmokedCatnip,					"DudeDialog.dude_innagadda", 2);
	
	Clear(lGotCrackHealth);
	AddTo(lGotCrackHealth,					"DudeDialog.dude_healthcantbegood", 1);
	
	Clear(lDude_NeedMoreCrackHealth);
	AddTo(lDude_NeedMoreCrackHealth,			"DudeDialog.dude_stuffwasntgood", 1);
	AddTo(lDude_NeedMoreCrackHealth,			"DudeDialog.dude_gottastopsmoking", 1);
	AddTo(lDude_NeedMoreCrackHealth,			"DudeDialog.dude_idontfeelsogood", 1);
	AddTo(lDude_NeedMoreCrackHealth,			"DudeDialog.dude_ifeellikeshit", 2);

	Clear(lDude_GotHurtByCrack);	
	AddTo(lDude_GotHurtByCrack,					"DudeDialog.dude_coldturkey", 1);
	AddTo(lDude_GotHurtByCrack,					"DudeDialog.dude_healthpipemy", 1);
	AddTo(lDude_GotHurtByCrack,					"DudeDialog.dude_withdrawalisa", 2);

	Clear(lDude_LowHealth);
	AddTo(lDude_LowHealth,						"DudeDialog.dude_idontfeelsogood", 1);
	AddTo(lDude_LowHealth,						"DudeDialog.dude_ifeellikeshit", 1);
	AddTo(lDude_LowHealth,						"DudeDialog.dude_igottafindmore", 2);

	Clear(lDude_EnterHabibs);
	AddTo(lDude_EnterHabibs,						"DudeDialog.dude_whatsthataweful", 1);
	AddTo(lDude_EnterHabibs,						"DudeDialog.dude_didslaughtergoat", 1);
	AddTo(lDude_EnterHabibs,						"DudeDialog.dude_youjustknowtheres", 1);
	AddTo(lDude_EnterHabibs,						"DudeDialog.dude_areyousotring", 1);

	Clear(lDude_enterhabibstestes);
	Addto(lDude_enterhabibstestes,						"DudeDialog.dude_youjustknowtheres", 1);

	Clear(lDude_seeTestes);
	AddTo(lDude_seeTestes,						"DudeDialog.dude_iknewit", 1);

	Clear(lDude_CallForHabib);
	AddTo(lDude_CallForHabib,						"DudeDialog.dude_heyayatollah", 1);

	Clear(lDude_KillHabib);
	AddTo(lDude_KillHabib,						"DudeDialog.dude_welliguessidont", 1);
	
	Clear(lDude_DropOffBook);
	AddTo(lDude_DropOffBook,						"DudeDialog.dude_wonderwherethebox", 1);
	AddTo(lDude_DropOffBook,						"DudeDialog.dude_stupidbook", 1);
	
	Clear(lDude_CashingPaycheck);
	AddTo(lDude_CashingPaycheck,						"DudeDialog.dude_idliketocash", 1);

	Clear(lDude_KillBankTeller);	
	AddTo(lDude_KillBankTeller,						"DudeDialog.dude_whowillcash", 1);
	
	Clear(lDude_RobbersShowUp);
	AddTo(lDude_RobbersShowUp,						"DudeDialog.dude_nowmydayis", 1);
	
	Clear(lDude_EmptyVault);
	AddTo(lDude_EmptyVault,						"DudeDialog.dude_whydoesthisnot", 1);

	Clear(lDude_DayChallenge);
	AddTo(lDude_DayChallenge,						"DudeDialog.dude_bettergethome", 1);
	AddTo(lDude_DayChallenge,						"DudeDialog.dude_bettergetoutta", 1);
	
	Clear(lDude_NeedsItem);
	AddTo(lDude_NeedsItem,						"DudeDialog.dude_ithinkineedthat", 1);
	AddTo(lDude_NeedsItem,						"DudeDialog.dude_maybeishouldkeep", 1);

	Clear(lDude_KillLibrary);
	AddTo(lDude_KillLibrary,						"DudeDialog.dude_findthedropbox", 1);

	Clear(lDude_Petition1);	
	AddTo(lDude_Petition1,							"DudeDialog.dude_petition1a", 1);
	AddTo(lDude_Petition1,							"DudeDialog.dude_petition1b", 1);

	Clear(lDude_Petition2);	
	AddTo(lDude_Petition2,							"DudeDialog.dude_petition2a", 1);
	AddTo(lDude_Petition2,							"DudeDialog.dude_petition2b", 1);

	Clear(lDude_Petition3);	
	AddTo(lDude_Petition3,							"DudeDialog.dude_petition3a", 1);
	AddTo(lDude_Petition3,							"DudeDialog.dude_petition3b", 1);

	Clear(lDude_CollectBalk);	
	AddTo(lDude_CollectBalk,						"DudeDialog.dude_shit", 1);
//	AddTo(lDude_CollectBalk,						"DudeDialog.dude_fuck", 1);
	AddTo(lDude_CollectBalk,						"DudeDialog.dude_youvegottabekid", 1);

	Clear(lDude_GaryTalk1);	
	AddTo(lDude_GaryTalk1,						"DudeDialog.dude_hellomrcoleman", 1);
	
	Clear(lDude_GaryTalk2);	
	AddTo(lDude_GaryTalk2,						"DudeDialog.dude_itsformymother", 1);
	
	Clear(lDude_GaryBullhorn);	
	AddTo(lDude_GaryBullhorn,						"DudeDialog.dude_icanrelatebro", 1);
	
	Clear(lDude_KillGary);	
	AddTo(lDude_KillGary,						"DudeDialog.dude_shit", 1);

	Clear(lDude_ConfessSins);	
	AddTo(lDude_ConfessSins,					"DudeDialog.dude_blessmefather", 1);

	Clear(lDude_GetNormalClothes);	
	AddTo(lDude_GetNormalClothes,					"DudeDialog.dude_getnormalclothes", 1);

	Clear(lDude_BuySteaks);	
//	AddTo(lDude_BuySteaks,						"DudeDialog.dude_needsomesteaks", 1);

	Clear(lDude_KillReception);	
	AddTo(lDude_KillReception,					"DudeDialog.dude_thatwasimpetuous", 1);

	Clear(lDude_FindSteaks);	
	AddTo(lDude_FindSteaks,						"DudeDialog.dude_thesebetterbefine", 1);

	Clear(lDude_GiveToUncleDave);
	AddTo(lDude_GiveToUncleDave,				"DudeDialog.dude_hereuncledave", 1);

	Clear(lDude_PayTraffic);
	AddTo(lDude_PayTraffic,						"DudeDialog.dude_paytrafficticket", 1);

	Clear(lDude_PayTraffic2);
	AddTo(lDude_PayTraffic2,					"DudeDialog.dude_carsareprops", 1);

	Clear(lDude_BuyNapalm);	
	AddTo(lDude_BuyNapalm,						"DudeDialog.dude_ineedsomenapalm", 1);

	Clear(lDude_KillNapalm);	
	AddTo(lDude_KillNapalm,						"DudeDialog.dude_whereisnapalm", 1);

	Clear(lDude_FindNapalm);	
	AddTo(lDude_FindNapalm,						"DudeDialog.dude_partywithnapalm", 1);

	Clear(lDude_FreeHealth);	
	AddTo(lDude_FreeHealth,						"DudeDialog.dude_imexperiencinga", 1);

	Clear(lDude_CureSelf);	
	AddTo(lDude_CureSelf,						"DudeDialog.dude_nowimgoingto", 1);

	Clear(lDude_BuyAlternator);	
	AddTo(lDude_BuyAlternator,					"DudeDialog.dude_heychicoineedan", 1);

	Clear(lDude_GetPackage);	
	AddTo(lDude_GetPackage,						"DudeDialog.dude_hereforpackage", 1);

	Clear(lDude_TalkToKrotchy);	
	AddTo(lDude_TalkToKrotchy,					"DudeDialog.dude_heymascotineeda", 1);

	Clear(lDude_NoKrotchy);	
	AddTo(lDude_NoKrotchy,						"DudeDialog.dude_crapsoldout", 1);

	Clear(lDude_KillKrotchy);	
	AddTo(lDude_KillKrotchy,					"DudeDialog.dude_nowimgonnahaveto", 1);

	Clear(lDude_FindToy);	
	AddTo(lDude_FindToy,						"DudeDialog.dude_wonderhowmuchon", 1);

	Clear(lDude_BribeKrotchyMoney);	
	AddTo(lDude_BribeKrotchyMoney,				"DudeDialog.dude_lookwebothknow", 1);

	Clear(lDude_BribeKrotchyBook);	
	AddTo(lDude_BribeKrotchyBook,				"DudeDialog.dude_howsthissound", 1);

	Clear(lDude_SaveTooMuch);
	AddTo(lDude_SaveTooMuch,					"DudeDialog.dude_areyousaving", 1);
	AddTo(lDude_SaveTooMuch,					"DudeDialog.dude_mygrandmothercould", 1);
	AddTo(lDude_SaveTooMuch,					"DudeDialog.dude_didntyoujustsave", 2);
	}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	}

