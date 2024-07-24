///////////////////////////////////////////////////////////////////////////////
// DialogMale
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Dialog for all white males
//
// If a new dialog class is added and it references a new sound package
// (like SuperHeroDialog.uax) then in order for those sounds to play on the
// client, you either need a hard reference in the code to one of those files
// Sound'SuperHeroDialog.DieScum', or you need to put that package in the
// ini's with serverpackages (cheesier version).
//
//	History:
//		02/07/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class DialogMale extends DialogGeneric;


///////////////////////////////////////////////////////////////////////////////
// Fill in this character's lines
///////////////////////////////////////////////////////////////////////////////
function FillInLines()
	{
	// Let super go first
	Super.FillInLines();

	Clear(lgreeting);
	Addto(lgreeting,							"WMaleDialog.wm_hello", 1);
	Addto(lgreeting,							"WMaleDialog.wm_hi", 1);
	Addto(lGreeting,							"WMaleDialog.wm_hey", 2);

	Clear(lhotgreeting);
	Addto(lhotGreeting,							"WMaleDialog.wm_hothello", 1);
	Addto(lhotGreeting,							"WMaleDialog.wm_hothi", 2);
	Addto(lhotGreeting,							"WMaleDialog.wm_hothey", 3);

	Clear(lgreetingquestions);
	Addto(lGreetingquestions,						"WMaleDialog.wm_howsitgoing", 1);
	Addto(lGreetingquestions,						"WMaleDialog.wm_howareyou", 1);
	Addto(lGreetingquestions,						"WMaleDialog.wm_howyoudoin", 2);
	Addto(lGreetingquestions,						"WMaleDialog.wm_sup", 2);

	Clear(lHotgreetingquestions);
	Addto(lHotGreetingquestions,						"WMaleDialog.wm_hothowsitgoing", 1);
	Addto(lHotGreetingquestions,						"WMaleDialog.wm_hothowareyou", 1);
	Addto(lHotGreetingquestions,						"WMaleDialog.wm_hothowyoudoin", 2);
	Addto(lHotGreetingquestions,						"WMaleDialog.wm_hotsup", 2);

	Clear(lrespondtohotgreeting);
	Addto(lrespondtohotgreeting,						"WMaleDialog.wm_creep", 1);
	Addto(lrespondtohotgreeting,						"WMaleDialog.wm_ugh", 1);
	Addto(lrespondtohotgreeting,						"WMaleDialog.wm_loser", 2);
	Addto(lrespondtohotgreeting,						"WMaleDialog.wm_moron", 3);
	Addto(lrespondtohotgreeting,						"WMaleDialog.wm_dontmakemecallacop", 3);

	Clear(lRespondtogreeting);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_finethanks", 1);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_doinprettygood", 1);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_ohokayiguess", 2);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_beenbetter", 2);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_grandmawcamedown", 3);
	Addto(lrespondtogreeting,						"WMaleDialog.wm_doiknowyou", 3);

	Clear(lrespondtogreetingresponse);
	Addto(lrespondtogreetingresponse,					"WMaleDialog.wm_thatsnice", 1);
	Addto(lrespondtogreetingresponse,					"WMaleDialog.wm_gladtohearit", 1);
	Addto(lrespondtogreetingresponse,					"WMaleDialog.wm_welltakecare", 2);
	Addto(lrespondtogreetingresponse,					"WMaleDialog.wm_ohhowawful", 3);
	Addto(lrespondtogreetingresponse,					"WMaleDialog.wm_imsorry", 3);

	Clear(lHelloCop);
	Addto(lHelloCop,								"WMaleDialog.wm_hellocop1", 1);
	Addto(lHelloCop,								"WMaleDialog.wm_hellocop2", 1);
	Addto(lHelloCop,								"WMaleDialog.wm_hellocop3", 3);

	Clear(lHelloGimp);
	Addto(lHelloGimp,								"WMaleDialog.wm_hellogimp1", 1);
	Addto(lHelloGimp,								"WMaleDialog.wm_hellogimp2", 1);
	Addto(lHelloGimp,								"WMaleDialog.wm_hellogimp3", 2);
	Addto(lHelloGimp,								"WMaleDialog.wm_hellogimp4", 3);
	Addto(lHelloGimp,								"WMaleDialog.wm_hellogimp5", 3);

	Clear(lApologize);
	Addto(lApologize,								"WMaleDialog.wm_imsorry", 1);

	Clear(lyourewelcome);
	Addto(lyourewelcome,							"WMaleDialog.wm_yourewelcome", 1);

	Clear(lno);
	Addto(lno,								"WMaleDialog.wm_nope", 1);
	Addto(lno,								"WMaleDialog.wm_no", 1);
	Addto(lno,								"WMaleDialog.wm_sorry", 2);
	Addto(lno,								"WMaleDialog.wm_idontthinkso", 3);
	Addto(lno,								"WMaleDialog.wm_not", 3);

	Clear(lyes);
	Addto(lyes,								"WMaleDialog.wm_yup", 1);
	Addto(lyes,								"WMaleDialog.wm_yes", 1);
	Addto(lyes,								"WMaleDialog.wm_sure", 2);
	Addto(lyes,								"WMaleDialog.wm_probably", 2);
	Addto(lyes,								"WMaleDialog.wm_yeah", 2);
	Addto(lyes,								"WMaleDialog.wm_uhhunh", 3);
	Addto(lyes,								"WMaleDialog.wm_uhhuhgum", 3);

	Clear(lthanks);
	Addto(lthanks,								"WMaleDialog.wm_thanks", 1);
	Addto(lthanks,								"WMaleDialog.wm_great", 1);
	Addto(lthanks,								"WMaleDialog.wm_kickass", 1);
	Addto(lthanks,								"WMaleDialog.wm_yourule", 2);
	Addto(lthanks,								"WMaleDialog.wm_thatrocks", 3);

	Clear(lThatsGreat);
	Addto(lThatsGreat,							"WMaleDialog.wm_great", 1);
	Addto(lThatsGreat,							"WMaleDialog.wm_kickass", 1);
	Addto(lThatsGreat,							"WMaleDialog.wm_thatrocks", 3);

	Clear(lGetDown);
	AddTo(lGetDown,								"WMaleDialog.wm_angrygetdown", 1);
	AddTo(lGetDown,								"WMaleDialog.wm_angrygetdownifyou", 1);
	AddTo(lGetDown,								"WMaleDialog.wm_angrygetonground", 1);

	Clear(lGetDownMP);
	AddTo(lGetDownMP,								"WMaleDialog.wm_angrygetdown", 1);
	AddTo(lGetDownMP,								"WMaleDialog.wm_angrygetdownifyou", 1);
	AddTo(lGetDownMP,								"WMaleDialog.wm_angrygetonground", 1);

	Clear(lCussing);
	Addto(lCussing,								"WMaleDialog.wm_christ", 1);
	Addto(lCussing,								"WMaleDialog.wm_shit", 2);
	Addto(lCussing,								"WMaleDialog.wm_holyshit", 2);
	Addto(lCussing,								"WMaleDialog.wm_motherfucker", 3);

	Clear(lgetdownscared);
	Addto(lgetdownscared,							"WMaleDialog.wm_scaredgetdown", 1);
	Addto(lgetdownscared,							"WMaleDialog.wm_scaredgetonground", 2);
	Addto(lgetdownscared,							"WMaleDialog.wm_scaredgetdownifyou", 3);
	Addto(lgetdownscared,							"WMaleDialog.wm_scaredlookout", 3);

	Clear(ldefiant);
	Addto(ldefiant,								"WMaleDialog.wm_goscrewyourself", 1);
	Addto(ldefiant,								"WMaleDialog.wm_fuckyoubuddy", 1);
	Addto(ldefiant,								"WMaleDialog.wm_yomomma", 2);
	Addto(ldefiant,								"WMaleDialog.wm_upyourspig", 2);
	Addto(ldefiant,								"WMaleDialog.wm_yourenottheboss", 2);
	Addto(ldefiant,								"WMaleDialog.wm_biteme", 3);
	Addto(ldefiant,								"WMaleDialog.wm_shutupmoron", 3);

	Clear(ldefiantline);
	Addto(ldefiantline,							"WMaleDialog.wm_goscrewyourself", 1);
	Addto(ldefiantline,							"WMaleDialog.wm_fuckyoubuddy", 1);
	Addto(ldefiantline,							"WMaleDialog.wm_yomomma", 2);
	Addto(ldefiantline,							"WMaleDialog.wm_upyourspig", 2);
	Addto(ldefiantline,							"WMaleDialog.wm_biteme", 3);
	Addto(ldefiantline,							"WMaleDialog.wm_shutupmoron", 3);
	
	Clear(lCloseToWeapon);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_christ", 1);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_eugh", 1);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_cop_jesus", 1);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_shit", 2);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_holyshit", 2);
	Addto(lCloseToWeapon,						"WMaleDialog.wm_motherfucker", 3);

	Clear(ldecidetofight);
	Addto(ldecidetofight,							"WMaleDialog.wm_imnotavictim", 1);
	Addto(ldecidetofight,							"WMaleDialog.wm_youcantdothattomy", 1);
	Addto(ldecidetofight,							"WMaleDialog.wm_illkillyou", 1);
	Addto(ldecidetofight,							"WMaleDialog.wm_youcantdothattome", 2);
	Addto(ldecidetofight,							"WMaleDialog.wm_ohnoyouarenotgonna", 3);

	Clear(llaughing);
	Addto(llaughing,								"WMaleDialog.wm_laugh", 1);

	Clear(lSnickering);
	Addto(lSnickering,								"WMaleDialog.wm_snicker", 1);

	Clear(lOutOfBreath);
	Addto(lOutOfBreath,								"WMaleDialog.wm_outofbreath", 1);

	Clear(lWatchingCrazy);
	Addto(lWatchingCrazy,							"WMaleDialog.wm_snicker", 1);
	Addto(lWatchingCrazy,							"WMaleDialog.wm_areyouoncrack", 1);
	Addto(lWatchingCrazy,							"WMaleDialog.wm_iseeyourecrazy", 1);
	Addto(lWatchingCrazy,							"WMaleDialog.wm_freak", 2);

	//Clear(lGroupLaugh);
	//Addto(lGroupLaugh,								"WMaleDialog.wm_group_laugh", 1);

	Clear(lshootingoverthere);
	Addto(lshootingoverthere,						"WMaleDialog.wm_someoneshooting", 1);
	Addto(lshootingoverthere,						"WMaleDialog.wm_someidiotisfiring", 1);

	Clear(lkillingoverthere);
	Addto(lkillingoverthere,						"WMaleDialog.wm_someguysshooting", 1);
	Addto(lkillingoverthere,						"WMaleDialog.wm_theresalunatic", 1);
	Addto(lkillingoverthere,						"WMaleDialog.wm_stopthatguy", 2);
	Addto(lkillingoverthere,						"WMaleDialog.wm_peoplearedying", 3);
	
	Clear(lscreaming);
	Addto(lscreaming,								"WMaleDialog.wm_scream1", 1);
	Addto(lscreaming,								"WMaleDialog.wm_scream2", 1);
	Addto(lscreaming,								"WMaleDialog.wm_scream3", 1);
	Addto(lscreaming,								"WMaleDialog.wm_scream4", 1);

	Clear(lscreamingonfire);
	Addto(lscreamingonfire,							"WMaleDialog.wm_yeagh", 1);
	Addto(lscreamingonfire,							"WMaleDialog.wm_awghelpme", 1);
	Addto(lscreamingonfire,							"WMaleDialog.wm_imburning", 2);
	Addto(lscreamingonfire,							"WMaleDialog.wm_putmeout", 3);
	
	Clear(lDoHeroics);
	Addto(lDoHeroics,								"WMaleDialog.wm_youthinkthatcan", 1);
	Addto(lDoHeroics,								"WMaleDialog.wm_rah", 1);
	Addto(lDoHeroics,								"WMaleDialog.wm_howaboutsomeofthis", 2);
	Addto(lDoHeroics,								"WMaleDialog.wm_youthinkimscared", 3);


	Clear(lgettingpissedon);
	Addto(lgettingpissedon,							"WMaleDialog.wm_spitoutpiss", 1);

	Clear(laftergettingpissedon);
	Addto(laftergettingpissedon,						"WMaleDialog.wm_christ", 1);
	Addto(laftergettingpissedon,						"WMaleDialog.wm_eugh", 1);
	Addto(laftergettingpissedon,						"WMaleDialog.wm_yousickbastard", 2);
	Addto(laftergettingpissedon,						"WMaleDialog.wm_motherfucker", 3);
	
	Clear(lwhatthe);
	Addto(lwhatthe,								"WMaleDialog.wm_whatthe", 1);
	Addto(lwhatthe,								"WMaleDialog.wm_whuh", 1);
	Addto(lwhatthe,								"WMaleDialog.wm_heey", 2);

	Clear(lseeingpisser);
	Addto(lseeingpisser,							"WMaleDialog.wm_thatsdisgusting", 1);
	Addto(lseeingpisser,							"WMaleDialog.wm_unsanitary", 1);
	Addto(lseeingpisser,							"WMaleDialog.wm_howawful", 2);
	Addto(lseeingpisser,							"WMaleDialog.wm_hemustbefrench", 3);
	Addto(lseeingpisser,							"WMaleDialog.wm_animal", 3);

	Clear(lSomethingIsGross);
	Addto(lSomethingIsGross,							"WMaleDialog.wm_thatsdisgusting", 1);
	Addto(lSomethingIsGross,							"WMaleDialog.wm_unsanitary", 1);
	Addto(lSomethingIsGross,							"WMaleDialog.wm_howawful", 2);

	Clear(lgothit);
	Addto(lgothit,								"WMaleDialog.wm_aahimhit", 1);
	addto(lgothit,								"WMaleDialog.wm_argh", 1);	
	addto(lgothit,								"WMaleDialog.wm_ow", 1);
	addto(lgothit,								"WMaleDialog.wm_shit", 2);
	addto(lgothit,								"WMaleDialog.wm_aghk", 2);
	addto(lgothit,								"WMaleDialog.wm_gak", 3);

	Clear(lAttacked);
	addto(lAttacked,								"WMaleDialog.wm_argh", 1);	
	addto(lAttacked,								"WMaleDialog.wm_ow", 1);
	addto(lAttacked,								"WMaleDialog.wm_shit", 2);
	addto(lAttacked,								"WMaleDialog.wm_aghk", 2);
	addto(lAttacked,								"WMaleDialog.wm_gak", 3);

	Clear(lGrunt);
	addto(lGrunt,								"WMaleDialog.wm_argh", 1);	
	addto(lGrunt,								"WMaleDialog.wm_ow", 1);
	addto(lGrunt,								"WMaleDialog.wm_aghk", 2);
	addto(lGrunt,								"WMaleDialog.wm_gak", 3);

	// no pissing talking
	Clear(lPissing);
	Addto(lPissing,								"WMaleDialog.wm_ahh", 1);
	Addto(lPissing,								"WMaleDialog.wm_ohyeah", 2);
	Addto(lPissing,								"WMaleDialog.wm_satisfiedsigh", 2);

	Clear(lPissOnSelf);
	Addto(lPissOnSelf,							"WMaleDialog.wm_spitting", 2);
	
	// no pissing myself out talking
	Clear(lPissOutFireOnSelf);
	Addto(lPissOutFireOnSelf,					"WMaleDialog.wm_ahh", 1);
	
	Clear(lDude_SniperBreathing);
	AddTo(lDude_SniperBreathing,					"WeaponSounds.sniper_zoombreathing", 1);

	Clear(lGotHealth);
	Addto(lGotHealth,							"WMaleDialog.wm_ahh", 1);

	Clear(lGotHealthFood);
	Addto(lGotHealthFood,						"WMaleDialog.wm_thatwasprettytasty", 1);
	Addto(lGotHealthFood,						"WMaleDialog.wm_hardtobelievethat", 2);
	Addto(lGotHealthFood,						"WMaleDialog.wm_heythatwasactually", 2);
	Addto(lGotHealthFood,						"WMaleDialog.wm_goodgodwhatwasin", 3);
	Addto(lGotHealthFood,						"WMaleDialog.wm_burp", 3);

	Clear(lGotCrackHealth);
	Addto(lGotCrackHealth,						"WMaleDialog.wm_ohyeahthattookayear", 1);

	Clear(lGotHitInCrotch);	
	addto(lGotHitInCrotch,						"WMaleDialog.wm_argh", 1);	

	Clear(lbegforlife);
	Addto(lbegforlife,							"WMaleDialog.wm_pleasedontkillme", 1);
	Addto(lbegforlife,							"WMaleDialog.wm_crying", 2);
	Addto(lbegforlife,							"WMaleDialog.wm_sparemylifekids", 1);
	Addto(lbegforlife,							"WMaleDialog.wm_dontkillvirgin", 2);
	Addto(lbegforlife,							"WMaleDialog.wm_pleasepleaseno", 2);
	Addto(lbegforlife,							"WMaleDialog.wm_crying1", 1);
	Addto(lbegforlife,							"WMaleDialog.wm_crying2", 1);
	Addto(lbegforlife,							"WMaleDialog.wm_crying3", 2);
	Addto(lbegforlife,							"WMaleDialog.wm_crying4", 3);
	Addto(lbegforlife,							"WMaleDialog.wm_snivel1", 1);
	Addto(lbegforlife,							"WMaleDialog.wm_snivel2", 2);
	
	Clear(lbegforlifeMin);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_pleasedontkillme", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_crying", 2);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_sparemylifekids", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_dontkillminority", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_dontkillvirgin", 2);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_pleasepleaseno", 2);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_crying1", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_crying2", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_crying3", 2);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_crying4", 3);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_snivel1", 1);
	Addto(lbegforlifeMin,							"WMaleDialog.wm_snivel2", 2);
	
	Clear(ldying);
	Addto(ldying,								"WMaleDialog.wm_mommy", 1);
	Addto(ldying,								"WMaleDialog.wm_icantfeelmylegs", 1);
	Addto(ldying,								"WMaleDialog.wm_deathcrawl1", 1);
	Addto(ldying,								"WMaleDialog.wm_deathcrawl2", 2);
	Addto(ldying,								"WMaleDialog.wm_deathcrawl3", 3);
	Addto(ldying,								"WMaleDialog.wm_icantbreathe", 1);
	Addto(ldying,								"WMaleDialog.wm_somebodypleasemake", 2);
	Addto(ldying,								"WMaleDialog.wm_godithurts", 2);
	Addto(ldying,								"WMaleDialog.wm_ohgod", 3);
	Addto(ldying,								"WMaleDialog.wm_justfinishit", 3);

	Clear(lCrying);
	Addto(lCrying,								"WMaleDialog.wm_crying", 1);
	Addto(lCrying,								"WMaleDialog.wm_crying1", 1);
	Addto(lCrying,								"WMaleDialog.wm_crying2", 2);
	Addto(lCrying,								"WMaleDialog.wm_crying3", 3);
	Addto(lCrying,								"WMaleDialog.wm_crying4", 3);

	Clear(lfrightenedapology);
	Addto(lfrightenedapology,						"WMaleDialog.wm_ohimsorrysovery", 1);	
	Addto(lfrightenedapology,						"WMaleDialog.wm_pleaseillneverdo", 2);
	Addto(lfrightenedapology,						"WMaleDialog.wm_ididntmeanit", 3);

	Clear(ltrashtalk);
	Addto(ltrashtalk,							"WMaleDialog.wm_yourenotsotough", 1);
	Addto(ltrashtalk,							"WMaleDialog.wm_cmonfightlikeaman", 1);
	Addto(ltrashtalk,							"WMaleDialog.wm_ohyeahbigmanwitha", 2);
	Addto(ltrashtalk,							"WMaleDialog.wm_whereyougoingsissy", 3);

	Clear(lWhileFighting);
	Addto(lWhileFighting,							"WMaleDialog.wm_yourenotsotough", 1);
	Addto(lWhileFighting,							"WMaleDialog.wm_cmonfightlikeaman", 1);
	Addto(lWhileFighting,							"WMaleDialog.wm_ohyeahbigmanwitha", 2);
	Addto(lWhileFighting,							"WMaleDialog.wm_whereyougoingsissy", 3);
	
	Clear(laskcopwhatsup);
	Addto(laskcopwhatsup,							"WMaleDialog.wm_whatseemstobethe", 1);
	Addto(laskcopwhatsup,							"WMaleDialog.wm_isanythingwrong", 2);

	Clear(lratout);
	Addto(lratout,								"WMaleDialog.wm_thatguyoverthere", 1);
	Addto(lratout,								"WMaleDialog.wm_hedidit", 1);
	Addto(lratout,								"WMaleDialog.wm_thatguy", 2);
	Addto(lratout,								"WMaleDialog.wm_itwashim", 3);

	Clear(lfakeratout);
	Addto(lfakeratout,							"WMaleDialog.wm_hediditisaw", 1);

	Clear(lcleanshot);
	Addto(lcleanshot,							"WMaleDialog.wm_getouttatheway", 1);
	
	Clear(lCleanMeleeHit);
	Addto(lCleanMeleeHit,						"WMaleDialog.wm_getouttatheway", 1);

	Clear(lInhale);
	Addto(lInhale,								"WMaleDialog.wm_inhale", 1);
												
	Clear(lExhale);								
	Addto(lExhale,								"WMaleDialog.wm_exhale", 1);
	
	Clear(lEatingFood);
	Addto(lEatingFood,							"WMaleDialog.wm_mmm", 1);
	Addto(lEatingFood,							"WMaleDialog.wm_chewing", 1);
	Addto(lEatingFood,							"WMaleDialog.wm_smacking", 2);
	Addto(lEatingFood,							"WMaleDialog.wm_drinkingsucking", 3);

	Clear(lAfterEating);
	Addto(lAfterEating,							"WMaleDialog.wm_thatwasprettytasty", 1);
	Addto(lAfterEating,							"WMaleDialog.wm_ohyeahthattookayear", 1);
	Addto(lAfterEating,							"WMaleDialog.wm_hardtobelievethat", 2);
	Addto(lAfterEating,							"WMaleDialog.wm_heythatwasactually", 2);
	Addto(lAfterEating,							"WMaleDialog.wm_goodgodwhatwasin", 3);
	Addto(lAfterEating,							"WMaleDialog.wm_burp", 3);

	Clear(lpleasureresponse);					
	Addto(lpleasureresponse,						"WMaleDialog.wm_ahh", 1);
	Addto(lpleasureresponse,						"WMaleDialog.wm_ohyeah", 2);

	Clear(laftersitdown);
	Addto(laftersitdown,							"WMaleDialog.wm_thatsaloadoff", 1);
	Addto(laftersitdown,							"WMaleDialog.wm_satisfiedsigh", 2);

	Clear(lSpitting);
	Addto(lSpitting,							"WMaleDialog.wm_shortingspitting", 1);
	Addto(lSpitting,							"WMaleDialog.wm_spitting", 2);
	
	Clear(lhmm);
	Addto(lhmm,									"WMaleDialog.wm_hmmmm", 1);

	Clear(lfollowme);
	Addto(lfollowme,							"WMaleDialog.wm_followme", 1);	
	Addto(lfollowme,							"WMaleDialog.wm_thisway", 1);
//	Addto(lfollowme,							"WMaleDialog.wm_overhere", 1);

	Clear(lStayHere);
	Addto(lStayHere,							"WMaleDialog.wm_cop_stoprightthere", 1);

	Clear(lnoticedickout);
	Addto(lnoticedickout,							"WMaleDialog.wm_xyz", 1);
//	Addto(lnoticedickout,							"WMaleDialog.wm_iveseenbigger", 1);	
//	Addto(lnoticedickout,							"WMaleDialog.wm_ohdear", 1);
	Addto(lnoticedickout,							"WMaleDialog.wm_geezpullyourpants", 1);
//	Addto(lnoticedickout,							"WMaleDialog.wm_wellinever", 2);	
	Addto(lnoticedickout,							"WMaleDialog.wm_noonesimpressed", 2);

	Clear(lilltakenumber);
	Addto(lilltakenumber,							"WMaleDialog.wm_illtakeanumber", 1);

	Clear(lmakedeposit);
	Addto(lmakedeposit,								"WMaleDialog.wm_idliketomakea", 1);

	Clear(lmakewithdrawal);
	Addto(lmakewithdrawal,							"WMaleDialog.wm_ineedtowithdraw", 1);

	Clear(lconsumerbuy);
	Addto(lconsumerbuy,							"WMaleDialog.wm_andthereyougo", 1);
	Addto(lconsumerbuy,							"WMaleDialog.wm_letsseethatshould", 1);
	Addto(lconsumerbuy,							"WMaleDialog.wm_hereyougo", 1);

	Clear(lconteststoretransaction);
	Addto(lconteststoretransaction,						"WMaleDialog.wm_whatkindofaclip", 1);
	Addto(lconteststoretransaction,						"WMaleDialog.wm_imnotpayingthat", 1);
	Addto(lconteststoretransaction,						"WMaleDialog.wm_imnevershopping", 1);
	
	Clear(lcontestbanktransaction);
	Addto(lcontestbanktransaction,						"WMaleDialog.wm_heyihadmoremoney", 1);
	Addto(lcontestbanktransaction,						"WMaleDialog.wm_someonesembezzling", 1);	
	Addto(lcontestbanktransaction,						"WMaleDialog.wm_theremustbesome", 1);

	Clear(lGoPostal);
	Addto(lGoPostal,								"WMaleDialog.wm_postal_howaboutwe", 1);
	Addto(lGoPostal,								"WMaleDialog.wm_postal_ifonemore", 1);	
	Addto(lGoPostal,								"WMaleDialog.wm_postal_godsaidits", 1);
	Addto(lGoPostal,								"WMaleDialog.wm_postal_forgiveme", 1);	
	Addto(lGoPostal,								"WMaleDialog.wm_postal_imsorry", 1);

	Clear(lcarnageoccurred);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_thehorror", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_help", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_heseemedlikesuch", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_ohmygod", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_itshorrible", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_imgoingtobesick", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_forchristsake", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_pleasemakeitstop", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_icantbelievethis", 1);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_icantbelievehe", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_thiscantbereal", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_itslikeapocolypse", 2);
// Not applicable
//	Addto(lcarnageoccurred,							"WMaleDialog.wm_niceparticlesman", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_holyshit", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_callthearmy", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_howcanthisbe", 2);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_heskillingeveryone", 3);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_runrun", 3);
//	Addto(lcarnageoccurred,							"WMaleDialog.wm_hesgotagun", 3);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_sweetlordno", 3);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_cantwealljustget", 3);
	Addto(lcarnageoccurred,							"WMaleDialog.wm_ghasp", 3);

	Clear(lCallCat);
	Addto(lCallCat, 							"WMaleDialog.wm_herekitty", 1);
	Addto(lCallCat, 							"WMaleDialog.wm_herekittyevil", 2);

	Clear(lHateCat);
	Addto(lHateCat, 							"WMaleDialog.wm_getoutfurball", 1);
	Addto(lHateCat, 							"WMaleDialog.wm_goddamcat", 2);

	Clear(lStartAttackingAnimal);
	Addto(lStartAttackingAnimal,				"WMaleDialog.wm_whatthe", 1);
	Addto(lStartAttackingAnimal,				"WMaleDialog.wm_cop_jesus", 1);
	Addto(lStartAttackingAnimal,				"WMaleDialog.wm_cop_fuck", 1);

	Clear(lGettingRobbed);	
	Addto(lGettingRobbed,							"WMaleDialog.wm_comebackherewith", 1);
	Addto(lGettingRobbed,							"WMaleDialog.wm_hetookmymoney", 1);
	Addto(lGettingRobbed,							"WMaleDialog.wm_hejustrippedme", 2);
	Addto(lGettingRobbed,							"WMaleDialog.wm_somebodystophim", 3);

	Clear(lGettingMugged);	
	Addto(lGettingMugged,						"WMaleDialog.wm_help", 1);
	Addto(lGettingMugged,						"WMaleDialog.wm_snivel1", 1);
	Addto(lGettingMugged,						"WMaleDialog.wm_pleasedontkillme", 1);
	Addto(lGettingMugged,						"WMaleDialog.wm_snivel2", 2);
	Addto(lGettingMugged,						"WMaleDialog.wm_ghasp", 3);

	Clear(lAfterMugged);	
	Addto(lAfterMugged,							"WMaleDialog.wm_comebackherewith", 1);
	Addto(lAfterMugged,							"WMaleDialog.wm_hetookmymoney", 1);
	Addto(lAfterMugged,							"WMaleDialog.wm_somebodystophim", 3);

	Clear(lDoMugging);	
	Addto(lDoMugging,							"WMaleDialog.wm_alrightbitchhand", 3);
	Addto(lDoMugging,							"WMaleDialog.wm_gimmeallyermoney", 2);
	Addto(lDoMugging,							"WMaleDialog.wm_handoverthedough", 1);
	Addto(lDoMugging,							"WMaleDialog.wm_thisisastickup", 1);
	
	Clear(lQuestion);	
	Addto(lQuestion,							"WMaleDialog.wm_whyyouvebeentold", 1);
	Addto(lQuestion,							"WMaleDialog.wm_whatsomejustasked", 1);
	Addto(lQuestion,							"WMaleDialog.wm_whatareyoutalking", 2);
	Addto(lQuestion,							"WMaleDialog.wm_idontcare", 3);

	Clear(lGenericQuestion);	
	Addto(lGenericQuestion,						"WMaleDialog.wm_wellwhatwereyou", 1);
	Addto(lGenericQuestion,						"WMaleDialog.wm_sodoyouthink", 1);
	Addto(lGenericQuestion,						"WMaleDialog.wm_doyouknowwhattime", 1);
	Addto(lGenericQuestion,						"WMaleDialog.wm_sodoyouthinkthe", 2);
	Addto(lGenericQuestion,						"WMaleDialog.wm_wherewereyouplan", 2);
	Addto(lGenericQuestion,						"WMaleDialog.wm_heydidyouseethat", 3);


	Clear(lGenericAnswer);	
	Addto(lGenericAnswer,						"WMaleDialog.wm_ifitwasupyourass", 1);
	Addto(lGenericAnswer,						"WMaleDialog.wm_ithinkineedadrink", 1);
	Addto(lGenericAnswer,						"WMaleDialog.wm_youthinkicould", 1);
	Addto(lGenericAnswer,						"WMaleDialog.wm_whatisabbaalex", 1);
	Addto(lGenericAnswer,						"WMaleDialog.wm_williwinaprize", 1);
	Addto(lGenericAnswer,						"WMaleDialog.wm_isthiscandid", 2);
	Addto(lGenericAnswer,						"WMaleDialog.wm_whyisitwhenyoure", 2);
	Addto(lGenericAnswer,						"WMaleDialog.wm_youkeeptalkingill", 2);
	Addto(lGenericAnswer,						"WMaleDialog.wm_ithinkineedmesome", 3);
	Addto(lGenericAnswer,						"WMaleDialog.wm_iforget", 3);

	Clear(lGenericFollowup);	
	Addto(lGenericFollowup,						"WMaleDialog.wm_yourenotreally", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_listenjusttellme", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_areyouevenlistening", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_areyouoncrack", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_geezstopdoingthat", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_iseeyourecrazy", 1);
	Addto(lGenericFollowup,						"WMaleDialog.wm_what", 1);

	Clear(linvadeshome);	
	Addto(linvadeshome,							"WMaleDialog.wm_heywhoreyou", 1);
	Addto(linvadeshome,							"WMaleDialog.wm_imcallingthecops", 1);
	Addto(linvadeshome,							"WMaleDialog.wm_whatareyoudoing", 2);
	Addto(linvadeshome,							"WMaleDialog.wm_getoutyoufreak", 2);
	Addto(linvadeshome,							"WMaleDialog.wm_getthehelloutofmy", 3);
	Addto(linvadeshome,							"WMaleDialog.wm_getoutnow", 3);
/*
never used
	Clear(lactionoutsidehome);
	Addto(lactionoutsidehome,						"WMaleDialog.wm_whatsalltheracket", 1);
	Addto(lactionoutsidehome,						"WMaleDialog.wm_keepitdown", 1);
	Addto(lactionoutsidehome,						"WMaleDialog.wm_thisisaquiet", 2);
	Addto(lactionoutsidehome,						"WMaleDialog.wm_whosoutthere", 3);
	Addto(lactionoutsidehome,						"WMaleDialog.wm_whatsgoingonout", 3);
*/
	Clear(lsomeoneonfire);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_waitillgetabucket", 1);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_ohtoobadwehaveno", 1);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_ohmygodtheyreon", 2);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_heystopdropandroll", 3);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_ohmygodtheyreall", 3);
	Addto(lsomeoneonfire,							"WMaleDialog.wm_everyonesonfire", 3);

	Clear(labouttopuke);
	Addto(labouttopuke,							"WMaleDialog.wm_idontfeelsogood", 1);
	Addto(labouttopuke,							"WMaleDialog.wm_ohmanimgonnabesick", 1);
	Addto(labouttopuke,							"WMaleDialog.wm_ohgodim", 1);

	Clear(lbodyfunctions);
	Addto(lbodyfunctions,							"WMaleDialog.wm_vomit", 1);

	Clear(lGettingShocked);
	Addto(lGettingShocked,							"WMaleDialog.wm_vomit", 1);

	// This sounds so much like a girl, the Kumquat wives (of Habib's) use this too
	Clear(lBattleCry);
	Addto(lBattleCry,								"HabibDialog.habib_ailili", 1);

	Clear(lCellPhoneTalk);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_uhhuh", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_nono", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_nohappy", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_yourekidding", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_okay", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_thatsgreat", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_greatbored", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_icantwait", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_hmm", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_stophappy", 1);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_wellimnotsurebut", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_ohyouwouldnt", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_welldidyouseeem", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_iwasthinkingthe", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_yeahbuticanttell", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_thatsfunnyiwas", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_ohtheyalwaysdothat", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_itriedsixoncebuti", 2);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_youdidntohmygawd", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_youknowittakessix", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_didyouhearthatkid", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_didyouhearsomeone", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_havyouheardtheres", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_yeahiveheardthe", 3);
	Addto(lCellPhoneTalk,							"WMaleDialog.wm_sohowmuchdoesa", 3);
	
	Clear(lZealots);
	Addto(lZealots,							"WMaleDialog.wm_werenotzealots", 1);
	Addto(lZealots,							"WMaleDialog.wm_thegoodbooktoldme", 1);
	Addto(lZealots,							"WMaleDialog.wm_stopoppressingus", 1);
	
//	Clear(lNormalFastFood);
//	Addto(lNormalFastFood,							"WMaleDialog.wm_helloandwelcome", 1);
//	Addto(lNormalFastFood,							"WMaleDialog.wm_haveaniceday", 1);
//	Addto(lNormalFastFood,							"WMaleDialog.wm_mayilargifythat", 1);
//	Addto(lNormalFastFood,							"WMaleDialog.wm_hereyouareenjoy", 1);
//	Addto(lNormalFastFood,							"WMaleDialog.wm_pleasehelpyourself", 1);

	
	Clear(lKrotchyCustomerComment);
	Addto(lKrotchyCustomerComment,					"WMaleDialog.wm_heyarethereanymore", 1);
	Addto(lKrotchyCustomerComment,					"WMaleDialog.wm_arentyouabitdark", 1);

	Clear(lKrotchyCustomerWant);
	Addto(lKrotchyCustomerWant,						"WMaleDialog.wm_ineedakrotchyformy", 1);
	Addto(lKrotchyCustomerWant,						"WMaleDialog.wm_anykrotchysleft", 1);
	Addto(lKrotchyCustomerWant,						"WMaleDialog.wm_icantfindanybad", 3);

	Clear(lGaryAutograph);
	Addto(lGaryAutograph,							"WMaleDialog.wm_iwastrulymovedby", 1);
	Addto(lGaryAutograph,							"WMaleDialog.wm_ihaveeveryepisode", 1);
	Addto(lGaryAutograph,							"WMaleDialog.wm_heywebstergimme", 1);
	Addto(lGaryAutograph,							"WMaleDialog.wm_ilovedyouaswebster", 1);
	Addto(lGaryAutograph,							"WMaleDialog.wm_heygarywewenttothe", 2);
	Addto(lGaryAutograph,							"WMaleDialog.wm_saythatwillisthing", 2);
	Addto(lGaryAutograph,							"WMaleDialog.wm_itsformymother", 2);
	Addto(lGaryAutograph,							"WMaleDialog.wm_itsformysister", 3);
	Addto(lGaryAutograph,							"WMaleDialog.wm_itsformygirluncle", 3);
	Addto(lGaryAutograph,							"WMaleDialog.wm_itsformykidbrother", 3);

	
	Clear(lProtestorCut);
	Addto(lProtestorCut,							"WMaleDialog.wm_heybuddyifyourenot", 1);
	Addto(lProtestorCut,							"WMaleDialog.wm_yeahyouprobablyeat", 1);
	
	Clear(ldudedead);
	Addto(ldudedead,							"WMaleDialog.wm_whatanasshole", 1);
	Addto(ldudedead,							"WMaleDialog.wm_freak", 2);
	Addto(ldudedead,							"WMaleDialog.wm_heseemedlikesucha", 1);
	Addto(ldudedead,							"WMaleDialog.wm_iblamedoom", 1);
	Addto(ldudedead,							"WMaleDialog.wm_somebodycalllieber", 1);
	Addto(ldudedead,							"WMaleDialog.wm_ltgrossmantried", 2);
	Addto(ldudedead,							"WMaleDialog.wm_illbethewasgay", 2);
	Addto(ldudedead,							"WMaleDialog.wm_goddamliberal", 3);
	Addto(ldudedead,							"WMaleDialog.wm_iftherewerenoguns", 3);

	Clear(lKickDead);
	Addto(lKickDead,							"WMaleDialog.wm_heresoneforyer", 1);
	Addto(lKickDead,							"WMaleDialog.wm_hereyouforgotone", 1);
	Addto(lKickDead,							"WMaleDialog.wm_takethiswithyou", 1);

	Clear(lNameCalling);
	Addto(lNameCalling,							"WMaleDialog.wm_freak", 1);
	Addto(lNameCalling,							"WMaleDialog.wm_creep", 1);
	Addto(lNameCalling,							"WMaleDialog.wm_loser", 1);

	Clear(lRogueCop);
	Addto(lRogueCop,							"WMaleDialog.wm_ivelostmyfaithin", 1);
	Addto(lRogueCop,							"WMaleDialog.wm_thatcopsgoneinsane", 1);
	Addto(lRogueCop,							"WMaleDialog.wm_wheresmyvideocam", 1);
	Addto(lRogueCop,							"WMaleDialog.wm_ifihadacameraidbe", 1);
	Addto(lRogueCop,							"WMaleDialog.wm_lookathimoppress", 1);
	/// Sounded bad.. he chanted it, instead of screamed it (scared)
//	Addto(lRogueCop,							"WMaleDialog.wm_attica", 1);

	Clear(lgetbumped);
	Addto(lgetbumped,							"WMaleDialog.wm_heywatchit", 1);
	Addto(lgetbumped,							"WMaleDialog.wm_oofidiot", 1);
	Addto(lgetbumped,							"WMaleDialog.wm_lookout", 1);
	Addto(lgetbumped,							"WMaleDialog.wm_oneside", 1);
	//Addto(lgetbumped,							"WMaleDialog.wm_cominthrough", 1);

	Clear(lGetMad);
	Addto(lGetMad,								"WMaleDialog.wm_heywatchit", 1);
	Addto(lGetMad,								"WMaleDialog.wm_oofidiot", 1);
	Addto(lGetMad,								"WMaleDialog.wm_lookout", 1);
	addto(lGetMad,								"WMaleDialog.wm_ow", 1);

	Clear(lLynchMob);
	Addto(lLynchMob,							"WMaleDialog.wm_thereheis", 1);
	Addto(lLynchMob,							"WMaleDialog.wm_theresthekiller", 1);
	Addto(lLynchMob,							"WMaleDialog.wm_thatstheone", 1);
	Addto(lLynchMob,							"WMaleDialog.wm_heyyou", 1);
	Addto(lLynchMob,							"WMaleDialog.wm_gethim", 2);
	//Addto(lLynchMob,							"WMaleDialog.wm_youdontbelonghere", 2);
	Addto(lLynchMob,							"WMaleDialog.wm_idontlikethelook", 3);
	Addto(lLynchMob,							"WMaleDialog.wm_theressomething", 3);

	Addto(lSeesEnemy,							"WMaleDialog.wm_illkillyou", 1);
	Addto(lSeesEnemy,							"WMaleDialog.wm_rah", 1);
	Addto(lSeesEnemy,							"WMaleDialog.wm_heyyou", 1);
	Addto(lSeesEnemy,							"WMaleDialog.wm_howaboutsomeofthis", 2);
	Addto(lSeesEnemy,							"WMaleDialog.wm_gethim", 2);

	Clear(lnextinline);
	Addto(lnextinline,							"WMaleDialog.wm_illtakethenext", 1);
	
	Clear(lhelpyouoverhere);
	Addto(lhelpyouoverhere,							"WMaleDialog.wm_icanhelpyouover", 1);

	Clear(lsomeonecuts);
	Addto(lsomeonecuts,							"WMaleDialog.wm_imsorrybutyoull", 1);

	Clear(lpleasemoveforward);
	Addto(lpleasemoveforward,						"WMaleDialog.wm_pleasemoveforward", 1);

	Clear(lcanihelpyou);
	Addto(lcanihelpyou,							"WMaleDialog.wm_howcanihelpyou", 1);
	Addto(lcanihelpyou,							"WMaleDialog.wm_cananyonehelpyou", 1);

	Clear(lNumbers_Thatllbe);
	Addto(lNumbers_Thatllbe,					"WMaleDialog.wm_thatllbe", 1);

	Clear(lNumbers_a);
	Addto(lNumbers_a,							"WMaleDialog.wm_a", 1);

	Clear(lNumbers_1);
	Addto(lNumbers_1,							"WMaleDialog.wm_1", 1);

	Clear(lNumbers_2);
	Addto(lNumbers_2,							"WMaleDialog.wm_2", 1);

	Clear(lNumbers_3);
	Addto(lNumbers_3,							"WMaleDialog.wm_3", 1);

	Clear(lNumbers_4);
	Addto(lNumbers_4,							"WMaleDialog.wm_4", 1);

	Clear(lNumbers_5);
	Addto(lNumbers_5,							"WMaleDialog.wm_5", 1);

	Clear(lNumbers_10);
	Addto(lNumbers_10,							"WMaleDialog.wm_10", 1);

	Clear(lNumbers_20);
	Addto(lNumbers_20,							"WMaleDialog.wm_20", 1);

	Clear(lNumbers_40);
	Addto(lNumbers_40,							"WMaleDialog.wm_40", 1);

	Clear(lNumbers_60);
	Addto(lNumbers_60,							"WMaleDialog.wm_60", 1);

	Clear(lNumbers_80);
	Addto(lNumbers_80,							"WMaleDialog.wm_80", 1);

	Clear(lNumbers_100);
	Addto(lNumbers_100,							"WMaleDialog.wm_100", 1);

	Clear(lNumbers_200);
	Addto(lNumbers_200,							"WMaleDialog.wm_200", 1);

	Clear(lNumbers_300);
	Addto(lNumbers_300,							"WMaleDialog.wm_300", 1);

	Clear(lNumbers_400);
	Addto(lNumbers_400,							"WMaleDialog.wm_400", 1);

	Clear(lNumbers_500);
	Addto(lNumbers_500,							"WMaleDialog.wm_500", 1);

	Clear(lNumbers_Dollars);
	Addto(lNumbers_Dollars,						"WMaleDialog.wm_dollars", 1);
	Addto(lNumbers_Dollars,						"WMaleDialog.wm_bucks", 1);

	Clear(lNumbers_SingleDollar);
	Addto(lNumbers_SingleDollar,				"WMaleDialog.wm_dollar", 1);
	Addto(lNumbers_SingleDollar,				"WMaleDialog.wm_buck", 1);

	Clear(lsellingitem);
	Addto(lsellingitem,							"WMaleDialog.wm_okaygreatandthank", 1);
	Addto(lsellingitem,							"WMaleDialog.wm_andcomeagain", 1);
	Addto(lsellingitem,							"WMaleDialog.wm_thatllworkthanks", 2);

	Clear(lIsThisEverything);
	Addto(lIsThisEverything,						"WMaleDialog.wm_isthiseverything", 1);
	
	Clear(llackofmoney);
	Addto(llackofmoney,							"WMaleDialog.wm_comebackwhenyou", 1);
	Addto(llackofmoney,							"WMaleDialog.wm_imsorrybutyouneed", 1);

	Clear(lSignPetition);							
	Addto(lSignPetition,							"WMaleDialog.wm_signpetition", 1);

	Clear(lDontSignPetition);
	Addto(lDontSignPetition,						"WMaleDialog.wm_dontsignpetition", 1);

	Clear(lPetitionBother);
	Addto(lPetitionBother,							"WMaleDialog.wm_buzzoffcreep", 1);
	Addto(lPetitionBother,							"WMaleDialog.wm_leavemealone", 2);

	Clear(lcallsecurity);
	Addto(lcallsecurity,							"WMaleDialog.wm_security", 1);
	Addto(lcallsecurity,							"WMaleDialog.wm_someonegetthisguy", 1);
	Addto(lcallsecurity,							"WMaleDialog.wm_willsomeoneplease", 2);
	
	Clear(lrowdycustomer);
	Addto(lrowdycustomer,							"WMaleDialog.wm_pleasecalmdown", 1);
	Addto(lrowdycustomer,							"WMaleDialog.wm_letsworkthisout", 1);
	Addto(lrowdycustomer,							"WMaleDialog.wm_dontmakemecallsec", 2);
	Addto(lrowdycustomer,							"WMaleDialog.wm_dontmakemecallpol", 2);
	
	Clear(lRWSemployee);
	Addto(lRWSemployee,							"WMaleDialog.wm_heydudeseevince", 1);
	Addto(lrwsemployee,							"WMaleDialog.wm_vinceneedstoseeyou", 1);

	Clear(lCityWorker);
	Addto(lCityWorker,							"WMaleDialog.wm_city_andletthatbe", 1);

	Clear(lJunkyard_DudeBuyingPart);
	Addto(lJunkyard_DudeBuyingPart,				"WMaleDialog.wm_junkyard_yeahivegot", 1);

	Clear(lJunkyard_DogsGotOut);
	Addto(lJunkyard_DogsGotOut,					"WMaleDialog.wm_junkyard_wholetthedogsou", 1);
	}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	}
