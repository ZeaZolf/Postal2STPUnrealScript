///////////////////////////////////////////////////////////////////////////////
// DialogFemale
// Copyright 2001 Running With Scissors, Inc.  All Rights Reserved.
//
// Dialog for all white females
//
//	History:
//		02/07/02 MJR	Started.
//
///////////////////////////////////////////////////////////////////////////////
class DialogFemale extends DialogGeneric;


///////////////////////////////////////////////////////////////////////////////
// Fill in this character's lines
///////////////////////////////////////////////////////////////////////////////
function FillInLines()
	{
	// Let super go first
	Super.FillInLines();

	Clear(lgreeting);
	Addto(lgreeting,							"WFemaleDialog.wf_hello", 1);
	Addto(lgreeting,							"WFemaleDialog.wf_hi", 1);
	Addto(lGreeting,							"WFemaleDialog.wf_hey", 2);

	Clear(lhotgreeting);
	Addto(lhotGreeting,							"WFemaleDialog.wf_hothello", 1);
	Addto(lhotGreeting,							"WFemaleDialog.wf_hothi", 2);
	Addto(lhotGreeting,							"WFemaleDialog.wf_hothey", 3);

	Clear(lgreetingquestions);
	Addto(lGreetingquestions,						"WFemaleDialog.wf_howsitgoing", 1);
	Addto(lGreetingquestions,						"WFemaleDialog.wf_howareyou", 1);
	Addto(lGreetingquestions,						"WFemaleDialog.wf_howyoudoin", 2);
	Addto(lGreetingquestions,						"WFemaleDialog.wf_sup", 2);

	Clear(lHotgreetingquestions);
	Addto(lHotGreetingquestions,						"WFemaleDialog.wf_hothowsitgoing", 1);
	Addto(lHotGreetingquestions,						"WFemaleDialog.wf_hothowareyou", 1);
	Addto(lHotGreetingquestions,						"WFemaleDialog.wf_hothowyoudoin", 2);
	Addto(lHotGreetingquestions,						"WFemaleDialog.wf_hotsup", 2);

	Clear(lrespondtohotgreeting);
	Addto(lrespondtohotgreeting,						"WFemaleDialog.wf_creep", 1);
	Addto(lrespondtohotgreeting,						"WFemaleDialog.wf_ugh", 1);
	Addto(lrespondtohotgreeting,						"WFemaleDialog.wf_loser", 2);
	Addto(lrespondtohotgreeting,						"WFemaleDialog.wf_moron", 3);
	Addto(lrespondtohotgreeting,						"WFemaleDialog.wf_dontmakemecallacop", 3);

	Clear(lRespondtogreeting);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_finethanks", 1);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_doinprettygood", 1);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_ohokayiguess", 2);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_beenbetter", 2);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_grandmawcamedown", 3);
	Addto(lrespondtogreeting,						"WFemaleDialog.wf_doiknowyou", 3);

	Clear(lrespondtogreetingresponse);
	Addto(lrespondtogreetingresponse,					"WFemaleDialog.wf_thatsnice", 1);
	Addto(lrespondtogreetingresponse,					"WFemaleDialog.wf_gladtohearit", 1);
	Addto(lrespondtogreetingresponse,					"WFemaleDialog.wf_welltakecare", 2);
	Addto(lrespondtogreetingresponse,					"WFemaleDialog.wf_ohhowawful", 3);
	Addto(lrespondtogreetingresponse,					"WFemaleDialog.wf_imsorry", 3);

	Clear(lHelloCop);
	Addto(lHelloCop,								"WFemaleDialog.wf_hellocop1", 1);
	Addto(lHelloCop,								"WFemaleDialog.wf_hellocop2", 1);
	Addto(lHelloCop,								"WFemaleDialog.wf_hellocop3", 3);

	Clear(lHelloGimp);
	Addto(lHelloGimp,								"WFemaleDialog.wf_hellogimp1", 1);
	Addto(lHelloGimp,								"WFemaleDialog.wf_hellogimp2", 1);
	Addto(lHelloGimp,								"WFemaleDialog.wf_hellogimp3", 2);
	Addto(lHelloGimp,								"WFemaleDialog.wf_hellogimp4", 3);
	Addto(lHelloGimp,								"WFemaleDialog.wf_hellogimp5", 3);

	Clear(lApologize);
	Addto(lApologize,								"WFemaleDialog.wf_imsorry", 1);

	Clear(lyourewelcome);
	Addto(lyourewelcome,							"WFemaleDialog.wf_yourewelcome", 1);

	Clear(lno);
	Addto(lno,								"WFemaleDialog.wf_nope", 1);
	Addto(lno,								"WFemaleDialog.wf_no", 1);
	Addto(lno,								"WFemaleDialog.wf_sorry", 2);
	Addto(lno,								"WFemaleDialog.wf_idontthinkso", 3);
	Addto(lno,								"WFemaleDialog.wf_not", 3);

	Clear(lyes);
	Addto(lyes,								"WFemaleDialog.wf_yup", 1);
	Addto(lyes,								"WFemaleDialog.wf_yes", 1);
	Addto(lyes,								"WFemaleDialog.wf_sure", 2);
	Addto(lyes,								"WFemaleDialog.wf_probably", 2);
	Addto(lyes,								"WFemaleDialog.wf_yeah", 2);
	Addto(lyes,								"WFemaleDialog.wf_uhhunh", 3);
	Addto(lyes,								"WFemaleDialog.wf_uhhuhgum", 3);

	Clear(lthanks);
	Addto(lthanks,								"WFemaleDialog.wf_thanks", 1);
	Addto(lthanks,								"WFemaleDialog.wf_great", 2);
	Addto(lthanks,								"WFemaleDialog.wf_yourule", 2);
	Addto(lthanks,								"WFemaleDialog.wf_kickass", 3);
	Addto(lthanks,								"WFemaleDialog.wf_thatrocks", 3);

	Clear(lThatsGreat);
	Addto(lThatsGreat,							"WFemaleDialog.wf_great", 1);
	Addto(lThatsGreat,							"WFemaleDialog.wf_kickass", 1);
	Addto(lThatsGreat,							"WFemaleDialog.wf_thatrocks", 3);

	Clear(lGetDown);
	AddTo(lGetDown,								"WFemaleDialog.wf_angrygetdown", 1);
	AddTo(lGetDown,								"WFemaleDialog.wf_angrygetdownifyou", 1);
	AddTo(lGetDown,								"WFemaleDialog.wf_angrygetonground", 3);

	Clear(lGetDownMP);
	AddTo(lGetDownMP,							"WFemaleDialog.wf_angrygetdown", 1);
	AddTo(lGetDownMP,							"WFemaleDialog.wf_angrygetdownifyou", 1);
	AddTo(lGetDownMP,							"WFemaleDialog.wf_angrygetonground", 3);

	Clear(lgetdownscared);
	Addto(lgetdownscared,							"WFemaleDialog.wf_scaredgetdown", 1);
	Addto(lgetdownscared,							"WFemaleDialog.wf_scaredgetonground", 2);
	Addto(lgetdownscared,							"WFemaleDialog.wf_scaredgetdownifyou", 3);
	Addto(lgetdownscared,							"WFemaleDialog.wf_scaredlookout", 3);

	Clear(ldefiant);
	Addto(ldefiant,								"WFemaleDialog.wf_goscrewyourself", 1);
	Addto(ldefiant,								"WFemaleDialog.wf_fuckyoubuddy", 1);
	Addto(ldefiant,								"WFemaleDialog.wf_yomomma", 2);
	Addto(ldefiant,								"WFemaleDialog.wf_upyourspig", 2);
	Addto(ldefiant,								"WFemaleDialog.wf_yourenottheboss", 2);
	Addto(ldefiant,								"WFemaleDialog.wf_biteme", 3);
	Addto(ldefiant,								"WFemaleDialog.wf_shutupmoron", 3);
	
	Clear(ldefiantline);
	Addto(ldefiantline,							"WFemaleDialog.wf_goscrewyourself", 1);
	Addto(ldefiantline,							"WFemaleDialog.wf_fuckyoubuddy", 1);
	Addto(ldefiantline,							"WFemaleDialog.wf_yomomma", 2);
	Addto(ldefiantline,							"WFemaleDialog.wf_upyourspig", 2);
	Addto(ldefiantline,							"WFemaleDialog.wf_biteme", 3);
	Addto(ldefiantline,							"WFemaleDialog.wf_shutupmoron", 3);
	
	Clear(lCloseToWeapon);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_christ", 1);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_eugh", 1);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_cop_jesus", 1);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_shit", 2);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_holyshit", 2);
	Addto(lCloseToWeapon,						"WFemaleDialog.wf_motherfucker", 3);

	Clear(ldecidetofight);
	Addto(ldecidetofight,							"WFemaleDialog.wf_imnotavictim", 1);
	Addto(ldecidetofight,							"WFemaleDialog.wf_youcantdothattomy", 1);
	Addto(ldecidetofight,							"WFemaleDialog.wf_illkillyou", 1);
	Addto(ldecidetofight,							"WFemaleDialog.wf_youcantdothattome", 2);
	Addto(ldecidetofight,							"WFemaleDialog.wf_ohnoyouarenotgonna", 3);

	Clear(llaughing);
	Addto(llaughing,								"WFemaleDialog.wf_laugh", 1);

	Clear(lSnickering);
	Addto(lSnickering,								"WFemaleDialog.wf_snicker", 1);

	Clear(lOutOfBreath);
	Addto(lOutOfBreath,								"WFemaleDialog.wf_outofbreath", 1);

	Clear(lWatchingCrazy);
	Addto(lWatchingCrazy,							"WFemaleDialog.wf_snicker", 1);
	Addto(lWatchingCrazy,							"WFemaleDialog.wf_areyouoncrack", 1);
	Addto(lWatchingCrazy,							"WFemaleDialog.wf_iseeyourecrazy", 1);
	Addto(lWatchingCrazy,							"WFemaleDialog.wf_freak", 2);

	//Clear(lGroupLaugh);
	//Addto(lGroupLaugh,								"WFemaleDialog.wf_group_laugh", 1);

	Clear(lshootingoverthere);
	Addto(lshootingoverthere,						"WFemaleDialog.wf_someoneshooting", 1);
	Addto(lshootingoverthere,						"WFemaleDialog.wf_someidiotisfiring", 1);

	Clear(lkillingoverthere);
	Addto(lkillingoverthere,						"WFemaleDialog.wf_someguysshooting", 1);
	Addto(lkillingoverthere,						"WFemaleDialog.wf_theresalunatic", 1);
	Addto(lkillingoverthere,						"WFemaleDialog.wf_stopthatguy", 2);
	Addto(lkillingoverthere,						"WFemaleDialog.wf_peoplearedying", 3);
	
	Clear(lscreaming);
	Addto(lscreaming,							"WFemaleDialog.wf_scream1", 1);
	Addto(lscreaming,							"WFemaleDialog.wf_scream2", 1);
	Addto(lscreaming,							"WFemaleDialog.wf_scream3", 1);
	Addto(lscreaming,							"WFemaleDialog.wf_scream4", 1);

	Clear(lscreamingonfire);
	Addto(lscreamingonfire,							"WFemaleDialog.wf_yeagh", 1);
	Addto(lscreamingonfire,							"WFemaleDialog.wf_awghelpme", 1);
	Addto(lscreamingonfire,							"WFemaleDialog.wf_imburning", 2);
	Addto(lscreamingonfire,							"WFemaleDialog.wf_putmeout", 3);
	
	Clear(lDoHeroics);
	Addto(lDoHeroics,						"WFemaleDialog.wf_youthinkthatcan", 1);
	Addto(lDoHeroics,						"WFemaleDialog.wf_rah", 1);
	Addto(lDoHeroics,						"WFemaleDialog.wf_howaboutsomeofthis", 2);
	Addto(lDoHeroics,						"WFemaleDialog.wf_youthinkimscared", 3);


	Clear(lgettingpissedon);
	Addto(lgettingpissedon,							"WFemaleDialog.wf_spitoutpiss", 1);

	Clear(laftergettingpissedon);
	Addto(laftergettingpissedon,						"WFemaleDialog.wf_christ", 1);
	Addto(laftergettingpissedon,						"WFemaleDialog.wf_eugh", 1);
	Addto(laftergettingpissedon,						"WFemaleDialog.wf_yousickbastard", 2);
	Addto(laftergettingpissedon,						"WFemaleDialog.wf_motherfucker", 3);
	
	Clear(lwhatthe);
	Addto(lwhatthe,								"WFemaleDialog.wf_whatthe", 1);
	Addto(lwhatthe,								"WFemaleDialog.wf_whuh", 1);
	Addto(lwhatthe,								"WFemaleDialog.wf_heey", 2);

	Clear(lseeingpisser);
	Addto(lseeingpisser,							"WFemaleDialog.wf_thatsdisgusting", 1);
	Addto(lseeingpisser,							"WFemaleDialog.wf_unsanitary", 1);
	Addto(lseeingpisser,							"WFemaleDialog.wf_howawful", 2);
	Addto(lseeingpisser,							"WFemaleDialog.wf_hemustbefrench", 3);
	Addto(lseeingpisser,							"WFemaleDialog.wf_animal", 3);

	Clear(lSomethingIsGross);
	Addto(lSomethingIsGross,							"WFemaleDialog.wf_thatsdisgusting", 1);
	Addto(lSomethingIsGross,							"WFemaleDialog.wf_unsanitary", 1);
	Addto(lSomethingIsGross,							"WFemaleDialog.wf_howawful", 2);

	Clear(lgothit);
	Addto(lgothit,								"WFemaleDialog.wf_aahimhit", 1);
	addto(lgothit,								"WFemaleDialog.wf_argh", 1);	
	addto(lgothit,								"WFemaleDialog.wf_ow", 1);
	addto(lgothit,								"WFemaleDialog.wf_shit", 2);
	addto(lgothit,								"WFemaleDialog.wf_aghk", 2);
	addto(lgothit,								"WFemaleDialog.wf_gak", 3);

	Clear(lAttacked);
	addto(lAttacked,								"WFemaleDialog.wf_argh", 1);	
	addto(lAttacked,								"WFemaleDialog.wf_ow", 1);
	addto(lAttacked,								"WFemaleDialog.wf_shit", 2);
	addto(lAttacked,								"WFemaleDialog.wf_aghk", 2);
	addto(lAttacked,								"WFemaleDialog.wf_gak", 3);

	Clear(lbegforlife);
	Addto(lbegforlife,							"WFemaleDialog.wf_pleasedontkillme", 1);
	Addto(lbegforlife,							"WFemaleDialog.wf_crying", 2);
	Addto(lbegforlife,							"WFemaleDialog.wf_sparemylifekids", 1);
	Addto(lbegforlife,							"WFemaleDialog.wf_dontkillvirgin", 2);
	Addto(lbegforlife,							"WFemaleDialog.wf_pleasepleaseno", 2);
	Addto(lbegforlife,							"WFemaleDialog.wf_crying1", 1);
	Addto(lbegforlife,							"WFemaleDialog.wf_crying2", 1);
	Addto(lbegforlife,							"WFemaleDialog.wf_crying3", 2);
	Addto(lbegforlife,							"WFemaleDialog.wf_crying4", 3);
	Addto(lbegforlife,							"WFemaleDialog.wf_snivel1", 1);
	Addto(lbegforlife,							"WFemaleDialog.wf_snivel2", 2);
	
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_pleasedontkillme", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_crying", 2);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_sparemylifekids", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_dontkillminority", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_dontkillvirgin", 2);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_pleasepleaseno", 2);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_crying1", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_crying2", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_crying3", 2);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_crying4", 3);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_snivel1", 1);
	Addto(lbegforlifeMin,							"WFemaleDialog.wf_snivel2", 2);
	
	Clear(ldying);
	Addto(ldying,								"WFemaleDialog.wf_mommy", 1);
	Addto(ldying,								"WFemaleDialog.wf_icantfeelmylegs", 1);
	Addto(ldying,								"WFemaleDialog.wf_deathcrawl1", 1);
	Addto(ldying,								"WFemaleDialog.wf_deathcrawl2", 2);
	Addto(ldying,								"WFemaleDialog.wf_deathcrawl3", 3);
	Addto(ldying,								"WFemaleDialog.wf_icantbreathe", 1);
	Addto(ldying,								"WFemaleDialog.wf_somebodypleasemake", 2);
	Addto(ldying,								"WFemaleDialog.wf_godithurts", 2);
	Addto(ldying,								"WFemaleDialog.wf_ohgod", 3);
	Addto(ldying,								"WFemaleDialog.wf_justfinishit", 3);

	Clear(lCrying);
	Addto(lCrying,								"WFemaleDialog.wf_crying", 1);
	Addto(lCrying,								"WFemaleDialog.wf_crying1", 1);
	Addto(lCrying,								"WFemaleDialog.wf_crying2", 2);
	Addto(lCrying,								"WFemaleDialog.wf_crying3", 3);
	Addto(lCrying,								"WFemaleDialog.wf_crying4", 3);

	Clear(lfrightenedapology);
	Addto(lfrightenedapology,						"WFemaleDialog.wf_ohimsorrysovery", 1);	
	Addto(lfrightenedapology,						"WFemaleDialog.wf_pleaseillneverdo", 2);
	Addto(lfrightenedapology,						"WFemaleDialog.wf_ididntmeanit", 3);

	Clear(ltrashtalk);
	Addto(ltrashtalk,							"WFemaleDialog.wf_yourenotsotough", 1);
	Addto(ltrashtalk,							"WFemaleDialog.wf_cmonfightlikeaman", 1);
	Addto(ltrashtalk,							"WFemaleDialog.wf_ohyeahbigmanwitha", 2);
	Addto(ltrashtalk,							"WFemaleDialog.wf_whereyougoingsissy", 3);

	Clear(lWhileFighting);
	Addto(lWhileFighting,							"WFemaleDialog.wf_yourenotsotough", 1);
	Addto(lWhileFighting,							"WFemaleDialog.wf_cmonfightlikeaman", 1);
	Addto(lWhileFighting,							"WFemaleDialog.wf_ohyeahbigmanwitha", 2);
	Addto(lWhileFighting,							"WFemaleDialog.wf_whereyougoingsissy", 3);
	
	Clear(laskcopwhatsup);
	Addto(laskcopwhatsup,							"WFemaleDialog.wf_whatseemstobethe", 1);
	Addto(laskcopwhatsup,							"WFemaleDialog.wf_isanythingwrong", 2);

	Clear(lratout);
	Addto(lratout,								"WFemaleDialog.wf_thatguyoverthere", 1);
	Addto(lratout,								"WFemaleDialog.wf_hedidit", 1);
	Addto(lratout,								"WFemaleDialog.wf_thatguy", 2);
	Addto(lratout,								"WFemaleDialog.wf_itwashim", 3);

	Clear(lfakeratout);
	Addto(lfakeratout,							"WFemaleDialog.wf_hediditisaw", 1);

	Clear(lcleanshot);
	Addto(lcleanshot,							"WFemaleDialog.wf_getouttatheway", 1);
	
	Clear(lCleanMeleeHit);
	Addto(lCleanMeleeHit,						"WFemaleDialog.wf_getouttatheway", 1);

	Clear(lInhale);
	Addto(lInhale,							"WFemaleDialog.wf_inhale", 1);
	
	Clear(lExhale);
	Addto(lExhale,							"WFemaleDialog.wf_exhale", 1);
	
	Clear(lEatingFood);
	Addto(lEatingFood,							"WFemaleDialog.wf_mmm", 1);
	Addto(lEatingFood,							"WFemaleDialog.wf_chewing", 1);
	Addto(lEatingFood,							"WFemaleDialog.wf_smacking", 2);
	Addto(lEatingFood,							"WFemaleDialog.wf_drinkingsucking", 3);

	Clear(lAfterEating);
	Addto(lAfterEating,							"WFemaleDialog.wf_thatwasprettytasty", 1);
	Addto(lAfterEating,							"WFemaleDialog.wf_ohyeahthattookayear", 1);
	Addto(lAfterEating,							"WFemaleDialog.wf_hardtobelievethat", 2);
	Addto(lAfterEating,							"WFemaleDialog.wf_heythatwasactually", 2);
	Addto(lAfterEating,							"WFemaleDialog.wf_goodgodwhatwasin", 3);
	Addto(lAfterEating,							"WFemaleDialog.wf_burp", 3);

	Clear(lpleasureresponse);					
	Addto(lpleasureresponse,						"WFemaleDialog.wf_ahh", 1);
	Addto(lpleasureresponse,						"WFemaleDialog.wf_ohyeah", 2);

	Clear(laftersitdown);
	Addto(laftersitdown,							"WFemaleDialog.wf_thatsaloadoff", 1);
	Addto(laftersitdown,							"WFemaleDialog.wf_satisfiedsigh", 2);

	Clear(lSpitting);
	Addto(lSpitting,							"WFemaleDialog.wf_shortingspitting", 1);
	Addto(lSpitting,							"WFemaleDialog.wf_spitting", 2);
	
	Clear(lhmm);
	Addto(lhmm,								"WFemaleDialog.wf_hmmmm", 1);

	Clear(lfollowme);
	Addto(lfollowme,							"WFemaleDialog.wf_followme", 1);	
	Addto(lfollowme,							"WFemaleDialog.wf_thisway", 1);
	Addto(lfollowme,							"WFemaleDialog.wf_overhere", 1);

	Clear(lStayHere);
	Addto(lStayHere,							"WFemaleDialog.wf_cop_stoprightthere", 1);

	Clear(lnoticedickout);
	Addto(lnoticedickout,							"WFemaleDialog.wf_xyz", 2);
	Addto(lnoticedickout,							"WFemaleDialog.wf_iveseenbigger", 1);	
	Addto(lnoticedickout,							"WFemaleDialog.wf_ohdear", 1);
	Addto(lnoticedickout,							"WFemaleDialog.wf_geezpullyourpants", 2);
	Addto(lnoticedickout,							"WFemaleDialog.wf_wellinever", 3);	
	Addto(lnoticedickout,							"WFemaleDialog.wf_noonesimpressed", 3);

	Clear(lilltakenumber);
	Addto(lilltakenumber,							"WFemaleDialog.wf_illtakeanumber", 1);

	Clear(lmakedeposit);
	Addto(lmakedeposit,								"WFemaleDialog.wf_idliketomakea", 1);

	Clear(lmakewithdrawal);
	Addto(lmakewithdrawal,							"WFemaleDialog.wf_ineedtowithdraw", 1);

	Clear(lconsumerbuy);
	Addto(lconsumerbuy,							"WFemaleDialog.wf_andthereyougo", 1);
	Addto(lconsumerbuy,							"WFemaleDialog.wf_letsseethatshould", 1);
	Addto(lconsumerbuy,							"WFemaleDialog.wf_hereyougo", 1);

	Clear(lconteststoretransaction);
	Addto(lconteststoretransaction,						"WFemaleDialog.wf_whatkindofaclip", 1);
	Addto(lconteststoretransaction,						"WFemaleDialog.wf_imnotpayingthat", 1);
	Addto(lconteststoretransaction,						"WFemaleDialog.wf_imnevershopping", 1);
	
	Clear(lcontestbanktransaction);
	Addto(lcontestbanktransaction,						"WFemaleDialog.wf_heyihadmoremoney", 1);
	Addto(lcontestbanktransaction,						"WFemaleDialog.wf_someonesembezzling", 1);	
	Addto(lcontestbanktransaction,						"WFemaleDialog.wf_theremustbesome", 1);

	Clear(lGoPostal);
	Addto(lGoPostal,								"WFemaleDialog.wf_postal_howaboutwe", 1);
	Addto(lGoPostal,								"WFemaleDialog.wf_postal_ifonemore", 1);	
	Addto(lGoPostal,								"WFemaleDialog.wf_postal_godsaidits", 1);
	Addto(lGoPostal,								"WFemaleDialog.wf_postal_forgiveme", 1);	
	Addto(lGoPostal,								"WFemaleDialog.wf_postal_imsorry", 1);

	Clear(lcarnageoccurred);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_thehorror", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_help", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_heseemedlikesuch", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_ohmygod", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_itshorrible", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_imgoingtobesick", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_forchristsake", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_pleasemakeitstop", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_icantbelievethis", 1);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_icantbelievehe", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_thiscantbereal", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_itslikeapocolypse", 2);
// Not applicable
//	Addto(lcarnageoccurred,							"WFemaleDialog.wf_niceparticlesman", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_holyshit", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_callthearmy", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_howcanthisbe", 2);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_heskillingeveryone", 3);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_runrun", 3);
//	Addto(lcarnageoccurred,							"WFemaleDialog.wf_hesgotagun", 3);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_sweetlordno", 3);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_cantwealljustget", 3);
	Addto(lcarnageoccurred,							"WFemaleDialog.wf_ghasp", 3);

	Clear(lCallCat);
	Addto(lCallCat, 							"WFemaleDialog.wf_herekitty", 1);
	Addto(lCallCat, 							"WFemaleDialog.wf_herekittyevil", 2);

	Clear(lHateCat);
	Addto(lHateCat, 							"WFemaleDialog.wf_getoutfurball", 1);
	Addto(lHateCat, 							"WFemaleDialog.wf_goddamcat", 2);

	Clear(lStartAttackingAnimal);
	Addto(lStartAttackingAnimal,				"WFemaleDialog.wf_whatthe", 1);
	Addto(lStartAttackingAnimal,				"WFemaleDialog.wf_cop_jesus", 1);
	Addto(lStartAttackingAnimal,				"WFemaleDialog.wf_cop_fuck", 1);

	Clear(lGettingRobbed);	
	Addto(lGettingRobbed,							"WFemaleDialog.wf_comebackherewith", 1);
	Addto(lGettingRobbed,							"WFemaleDialog.wf_hetookmymoney", 1);
	Addto(lGettingRobbed,							"WFemaleDialog.wf_hejustrippedme", 2);
	Addto(lGettingRobbed,							"WFemaleDialog.wf_somebodystophim", 3);

	Clear(lGettingMugged);	
	Addto(lGettingMugged,						"WFemaleDialog.wf_help", 1);
	Addto(lGettingMugged,						"WFemaleDialog.wf_snivel1", 1);
	Addto(lGettingMugged,						"WFemaleDialog.wf_pleasedontkillme", 1);
	Addto(lGettingMugged,						"WFemaleDialog.wf_snivel2", 2);
	Addto(lGettingMugged,						"WFemaleDialog.wf_ghasp", 3);

	Clear(lAfterMugged);	
	Addto(lAfterMugged,								"WFemaleDialog.wf_comebackherewith", 1);
	Addto(lAfterMugged,								"WFemaleDialog.wf_hetookmymoney", 1);
	Addto(lAfterMugged,								"WFemaleDialog.wf_somebodystophim", 3);

	Clear(lDoMugging);	
	Addto(lDoMugging,							"WFemaleDialog.wf_alrightbitchhand", 3);
	Addto(lDoMugging,							"WFemaleDialog.wf_gimmeallyermoney", 2);
	Addto(lDoMugging,							"WFemaleDialog.wf_handoverthedough", 1);
	Addto(lDoMugging,							"WFemaleDialog.wf_thisisastickup", 1);
	
	Clear(lQuestion);	
	Addto(lQuestion,							"WFemaleDialog.wf_whyyouvebeentold", 1);
	Addto(lQuestion,							"WFemaleDialog.wf_whatsomejustasked", 1);
	Addto(lQuestion,							"WFemaleDialog.wf_whatareyoutalking", 2);
	Addto(lQuestion,							"WFemaleDialog.wf_idontcare", 3);

	Clear(lGenericQuestion);	
	Addto(lGenericQuestion,						"WFemaleDialog.wf_wellwhatwereyou", 1);
	Addto(lGenericQuestion,						"WFemaleDialog.wf_sodoyouthink", 1);
	Addto(lGenericQuestion,						"WFemaleDialog.wf_doyouknowwhattime", 1);
	Addto(lGenericQuestion,						"WFemaleDialog.wf_sodoyouthinkthe", 2);
	Addto(lGenericQuestion,						"WFemaleDialog.wf_wherewereyouplan", 2);
	Addto(lGenericQuestion,						"WFemaleDialog.wf_heydidyouseethat", 3);


	Clear(lGenericAnswer);	
	Addto(lGenericAnswer,						"WFemaleDialog.wf_ifitwasupyourass", 1);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_ithinkineedadrink", 1);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_youthinkicould", 1);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_whatisabbaalex", 1);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_williwinaprize", 1);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_isthiscandid", 2);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_whyisitwhenyoure", 2);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_youkeeptalkingill", 2);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_ithinkineedsome", 3);
	Addto(lGenericAnswer,						"WFemaleDialog.wf_iforget", 3);

	Clear(lGenericFollowup);	
	Addto(lGenericFollowup,						"WFemaleDialog.wf_yourenotreally", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_listenjusttellme", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_areyouevenlistening", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_areyouoncrack", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_geezstopdoingthat", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_iseeyourecrazy", 1);
	Addto(lGenericFollowup,						"WFemaleDialog.wf_what", 1);

	Clear(linvadeshome);	
	Addto(linvadeshome,							"WFemaleDialog.wf_heywhoreyou", 1);
	Addto(linvadeshome,							"WFemaleDialog.wf_imcallingthecops", 1);
	Addto(linvadeshome,							"WFemaleDialog.wf_whatareyoudoing", 2);
	Addto(linvadeshome,							"WFemaleDialog.wf_getoutyoufreak", 2);
	Addto(linvadeshome,							"WFemaleDialog.wf_getthehelloutofmy", 3);
	Addto(linvadeshome,							"WFemaleDialog.wf_getoutnow", 3);
/*
	Clear(lactionoutsidehome);
	Addto(lactionoutsidehome,						"WFemaleDialog.wf_whatsalltheracket", 1);
	Addto(lactionoutsidehome,						"WFemaleDialog.wf_keepitdown", 1);
	Addto(lactionoutsidehome,						"WFemaleDialog.wf_thisisaquiet", 2);
	Addto(lactionoutsidehome,						"WFemaleDialog.wf_whosoutthere", 3);
	Addto(lactionoutsidehome,						"WFemaleDialog.wf_whatsgoingonout", 3);
*/
	Clear(lsomeoneonfire);
	Addto(lsomeoneonfire,							"WFemaleDialog.wf_waitillgetabucket", 1);
//	Addto(lsomeoneonfire,							"WFemaleDialog.wf_ohtoobadwehaveno", 1);
	Addto(lsomeoneonfire,							"WFemaleDialog.wf_ohmygodtheyreon", 2);
	Addto(lsomeoneonfire,							"WFemaleDialog.wf_heystopdropandroll", 3);
	Addto(lsomeoneonfire,							"WFemaleDialog.wf_ohmygodtheyreall", 3);
	Addto(lsomeoneonfire,							"WFemaleDialog.wf_everyonesonfire", 3);

	Clear(labouttopuke);
	Addto(labouttopuke,							"WFemaleDialog.wf_idontfeelsogood", 1);
	Addto(labouttopuke,							"WFemaleDialog.wf_ohmanimgonnabesick", 1);
	Addto(labouttopuke,							"WFemaleDialog.wf_ohgodim", 1);

	Clear(lbodyfunctions);
	Addto(lbodyfunctions,							"WFemaleDialog.wf_vomit", 1);
	
	Clear(lGettingShocked);
	Addto(lGettingShocked,							"WFemaleDialog.wf_vomit", 1);

	// This sounds so much like a girl, the Kumquat wives (of Habib's) use this too
	Clear(lBattleCry);
	Addto(lBattleCry,								"HabibDialog.habib_ailili", 1);

	Clear(lCellPhoneTalk);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_uhhuh", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_nono", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_nohappy", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_yourekidding", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_okay", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_thatsgreat", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_greatbored", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_icantwait", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_hmm", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_stophappy", 1);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_wellimnotsurebut", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_ohyouwouldnt", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_welldidyouseeem", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_iwasthinkingthe", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_yeahbuticanttell", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_thatsfunnyiwas", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_ohtheyalwaysdothat", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_itriedsixoncebuti", 2);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_youdidntohmygawd", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_youknowittakessix", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_didyouhearthatkid", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_didyouhearsomeone", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_haveyouheardtheres", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_yeahiveheardthe", 3);
	Addto(lCellPhoneTalk,							"WFemaleDialog.wf_sohowmuchdoesa", 3);
	
	Clear(lZealots);
	Addto(lZealots,							"WFemaleDialog.wf_werenotzealots", 1);
	Addto(lZealots,							"WFemaleDialog.wf_thegoodbooktoldme", 1);
	Addto(lZealots,							"WFemaleDialog.wf_stopoppressingus", 1);
	
//	Clear(lNormalFastFood);
//	Addto(lNormalFastFood,							"WFemaleDialog.wf_helloandwelcome", 1);
//	Addto(lNormalFastFood,							"WFemaleDialog.wf_haveaniceday", 1);
//	Addto(lNormalFastFood,							"WFemaleDialog.wf_mayilargifythat", 1);
//	Addto(lNormalFastFood,							"WFemaleDialog.wf_hereyouareenjoy", 1);
//	Addto(lNormalFastFood,							"WFemaleDialog.wf_pleasehelpyourself", 1);

	
	Clear(lKrotchyCustomerComment);
	Addto(lKrotchyCustomerComment,					"WFemaleDialog.wf_heyarethereanymore", 1);
	Addto(lKrotchyCustomerComment,					"WFemaleDialog.wf_arentyouabitdark", 1);

	Clear(lKrotchyCustomerWant);
	Addto(lKrotchyCustomerWant,						"WFemaleDialog.wf_ineedakrotchyformy", 1);
	Addto(lKrotchyCustomerWant,						"WFemaleDialog.wf_anykrotchysleft", 1);
	Addto(lKrotchyCustomerWant,						"WFemaleDialog.wf_icantfindanybad", 3);

	Clear(lGaryAutograph);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_iwastrulymovedby", 1);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_ihaveeveryepisode", 1);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_heywebstergimme", 1);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_ilovedyouaswebster", 1);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_heygarywewenttothe", 2);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_saythatwillisthing", 2);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_itsformymother", 2);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_itsformysister", 3);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_itsformygirluncle", 3);
	Addto(lGaryAutograph,							"WFemaleDialog.wf_itsformykidbrother", 3);

	
	Clear(lProtestorCut);
	Addto(lProtestorCut,							"WFemaleDialog.wf_heybuddyifyourenot", 1);
	Addto(lProtestorCut,							"WFemaleDialog.wf_yeahyouprobablyeat", 1);
	
	Clear(ldudedead);
	Addto(ldudedead,							"WFemaleDialog.wf_whatanasshole", 1);
	Addto(ldudedead,							"WFemaleDialog.wf_freak", 2);
	Addto(ldudedead,							"WFemaleDialog.wf_heseemedlikesucha", 1);
	Addto(ldudedead,							"WFemaleDialog.wf_iblamedoom", 1);
	Addto(ldudedead,							"WFemaleDialog.wf_somebodycalllieber", 1);
	Addto(ldudedead,							"WFemaleDialog.wf_ltgrossmantried", 2);
	Addto(ldudedead,							"WFemaleDialog.wf_illbethewasgay", 2);
	Addto(ldudedead,							"WFemaleDialog.wf_goddamliberal", 3);
	Addto(ldudedead,							"WFemaleDialog.wf_iftherewerenoguns", 3);

	Clear(lKickDead);
	Addto(lKickDead,							"WFemaleDialog.wf_heresoneforyer", 1);
	Addto(lKickDead,							"WFemaleDialog.wf_hereyouforgotone", 1);
	Addto(lKickDead,							"WFemaleDialog.wf_takethiswithyou", 1);

	Clear(lNameCalling);
	Addto(lNameCalling,							"WFemaleDialog.wf_freak", 1);
	Addto(lNameCalling,							"WFemaleDialog.wf_creep", 1);
	Addto(lNameCalling,							"WFemaleDialog.wf_loser", 1);

	Clear(lRogueCop);
	Addto(lRogueCop,							"WFemaleDialog.wf_ivelostmyfaithin", 1);
	Addto(lRogueCop,							"WFemaleDialog.wf_thatcopsgoneinsane", 1);
	Addto(lRogueCop,							"WFemaleDialog.wf_wheresmyvideocam", 1);
	Addto(lRogueCop,							"WFemaleDialog.wf_ifihadacameraidbe", 1);
	Addto(lRogueCop,							"WFemaleDialog.wf_lookathimoppress", 1);
	Addto(lRogueCop,							"WFemaleDialog.wf_attica", 1);

	Clear(lgetbumped);
	Addto(lgetbumped,							"WFemaleDialog.wf_heywatchit", 1);
	Addto(lgetbumped,							"WFemaleDialog.wf_oofidiot", 1);
	Addto(lgetbumped,							"WFemaleDialog.wf_lookout", 1);
	Addto(lgetbumped,							"WFemaleDialog.wf_oneside", 1);
	Addto(lgetbumped,							"WFemaleDialog.wf_cominthrough", 1);

	Clear(lGetMad);
	Addto(lGetMad,								"WFemaleDialog.wf_heywatchit", 1);
	Addto(lGetMad,								"WFemaleDialog.wf_oofidiot", 1);
	Addto(lGetMad,								"WFemaleDialog.wf_lookout", 1);
	addto(lGetMad,								"WFemaleDialog.wf_ow", 1);

	Clear(lLynchMob);
	Addto(lLynchMob,							"WFemaleDialog.wf_thereheis", 1);
	Addto(lLynchMob,							"WFemaleDialog.wf_theresthekiller", 1);
	Addto(lLynchMob,							"WFemaleDialog.wf_thatstheone", 1);
	Addto(lLynchMob,							"WFemaleDialog.wf_heyyou", 1);
	Addto(lLynchMob,							"WFemaleDialog.wf_gethim", 2);
//	Addto(lLynchMob,							"WFemaleDialog.wf_youdontbelonghere", 2);
	Addto(lLynchMob,							"WFemaleDialog.wf_idontlikethelook", 3);
	Addto(lLynchMob,							"WFemaleDialog.wf_theressomething", 3);

	Addto(lSeesEnemy,							"WFemaleDialog.wf_illkillyou", 1);
	Addto(lSeesEnemy,							"WFemaleDialog.wf_rah", 1);
	Addto(lSeesEnemy,							"WFemaleDialog.wf_heyyou", 1);
	Addto(lSeesEnemy,							"WFemaleDialog.wf_howaboutsomeofthis", 2);
	Addto(lSeesEnemy,							"WFemaleDialog.wf_gethim", 2);

	Clear(lnextinline);
	Addto(lnextinline,							"WFemaleDialog.wf_illtakethenext", 1);
	
	Clear(lhelpyouoverhere);
	Addto(lhelpyouoverhere,							"WFemaleDialog.wf_icanhelpyouover", 1);

	Clear(lsomeonecuts);
	Addto(lsomeonecuts,							"WFemaleDialog.wf_imsorrybutyoull", 1);

	Clear(lpleasemoveforward);
	Addto(lpleasemoveforward,						"WFemaleDialog.wf_pleasemoveforward", 1);

	Clear(lcanihelpyou);
	Addto(lcanihelpyou,							"WFemaleDialog.wf_howcanihelpyou", 1);
	Addto(lcanihelpyou,							"WFemaleDialog.wf_cananyonehelpyou", 1);

	Clear(lNumbers_Thatllbe);
	Addto(lNumbers_Thatllbe,					"WFemaleDialog.wf_thatllbe", 1);

	Clear(lNumbers_a);
	Addto(lNumbers_a,							"WFemaleDialog.wf_a", 1);

	Clear(lNumbers_1);
	Addto(lNumbers_1,							"WFemaleDialog.wf_1", 1);

	Clear(lNumbers_2);
	Addto(lNumbers_2,							"WFemaleDialog.wf_2", 1);

	Clear(lNumbers_3);
	Addto(lNumbers_3,							"WFemaleDialog.wf_3", 1);

	Clear(lNumbers_4);
	Addto(lNumbers_4,							"WFemaleDialog.wf_4", 1);

	Clear(lNumbers_5);
	Addto(lNumbers_5,							"WFemaleDialog.wf_5", 1);

	Clear(lNumbers_10);
	Addto(lNumbers_10,							"WFemaleDialog.wf_10", 1);

	Clear(lNumbers_20);
	Addto(lNumbers_20,							"WFemaleDialog.wf_20", 1);

	Clear(lNumbers_40);
	Addto(lNumbers_40,							"WFemaleDialog.wf_40", 1);

	Clear(lNumbers_60);
	Addto(lNumbers_60,							"WFemaleDialog.wf_60", 1);

	Clear(lNumbers_80);
	Addto(lNumbers_80,							"WFemaleDialog.wf_80", 1);

	Clear(lNumbers_100);
	Addto(lNumbers_100,							"WFemaleDialog.wf_100", 1);

	Clear(lNumbers_200);
	Addto(lNumbers_200,							"WFemaleDialog.wf_200", 1);

	Clear(lNumbers_300);
	Addto(lNumbers_300,							"WFemaleDialog.wf_300", 1);

	Clear(lNumbers_400);
	Addto(lNumbers_400,							"WFemaleDialog.wf_400", 1);

	Clear(lNumbers_500);
	Addto(lNumbers_500,							"WFemaleDialog.wf_500", 1);

	Clear(lNumbers_Dollars);
	Addto(lNumbers_Dollars,						"WFemaleDialog.wf_dollars", 1);
	Addto(lNumbers_Dollars,						"WFemaleDialog.wf_bucks", 1);

	Clear(lNumbers_SingleDollar);
	Addto(lNumbers_SingleDollar,				"WFemaleDialog.wf_dollar", 1);
	Addto(lNumbers_SingleDollar,				"WFemaleDialog.wf_buck", 1);

	Clear(lsellingitem);
	Addto(lsellingitem,							"WFemaleDialog.wf_okaygreatandthank", 1);
	Addto(lsellingitem,							"WFemaleDialog.wf_andcomeagain", 1);
	Addto(lsellingitem,							"WFemaleDialog.wf_thatllworkthanks", 2);

	Clear(lIsThisEverything);
	Addto(lIsThisEverything,						"WFemaleDialog.wf_isthiseverything", 1);
	
	Clear(llackofmoney);
	Addto(llackofmoney,							"WFemaleDialog.wf_comebackwhenyou", 1);
	Addto(llackofmoney,							"WFemaleDialog.wf_imsorrybutyouneed", 1);

	Clear(lSignPetition);							
	Addto(lSignPetition,							"WFemaleDialog.wf_signpetition", 1);

	Clear(lDontSignPetition);
	Addto(lDontSignPetition,						"WFemaleDialog.wf_dontsignpetition", 1);

	Clear(lPetitionBother);
	Addto(lPetitionBother,							"WFemaleDialog.wf_buzzoffcreep", 1);
	Addto(lPetitionBother,							"WFemaleDialog.wf_leavemealone", 2);

	Clear(lcallsecurity);
	Addto(lcallsecurity,							"WFemaleDialog.wf_security", 1);
	Addto(lcallsecurity,							"WFemaleDialog.wf_someonegetthisguy", 1);
	Addto(lcallsecurity,							"WFemaleDialog.wf_willsomeoneplease", 2);
	
	Clear(lrowdycustomer);
	Addto(lrowdycustomer,							"WFemaleDialog.wf_pleasecalmdown", 1);
	Addto(lrowdycustomer,							"WFemaleDialog.wf_letsworkthisout", 1);
	Addto(lrowdycustomer,							"WFemaleDialog.wf_dontmakemecallsec", 2);
	Addto(lrowdycustomer,							"WFemaleDialog.wf_dontmakemecallpol", 2);
	
	Clear(lTeller_Withdrawal);
	addto(lTeller_Withdrawal,							"WFemaleDialog.wf_teller_howmuch", 1);

	Clear(lTeller_Deposit);
	addto(lTeller_Deposit,								"WFemaleDialog.wf_teller_howmuchdeposit", 1);

	Clear(lTeller_UpdateAccount);
	Addto(lTeller_UpdateAccount,						"WFemaleDialog.wf_teller_letsupdate", 1);
	Addto(lTeller_UpdateAccount,						"WFemaleDialog.wf_teller_letschange", 2);

//	Clear(lNapalm_Directions);
//	Addto(lNapalm_Directions,						"WFemaleDialog.wf_napalm_downthehall", 1);

	Clear(lLibrarian_Quiet);
	Addto(lLibrarian_Quiet,							"WFemaleDialog.wf_lib_quiet", 1);
	Addto(lLibrarian_Quiet,							"WFemaleDialog.wf_lib_pleasebequiet", 1);

	Clear(lLibrarian_QuietNoKilling);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_quiet", 1);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_shh", 1);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_pleasebequiet", 1);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_peoplearetrying", 2);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_pleasekeepit", 2);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_nomurderingin", 3);
	Addto(lLibrarian_QuietNoKilling,				"WFemaleDialog.wf_lib_ifyoudontstop", 3);

	Clear(lLibrarian_LateFee);
	Addto(lLibrarian_LateFee,							"WFemaleDialog.wf_lib_theresalatefeeon", 1);

	Clear(lNapalm_Directions);							
	Addto(lNapalm_Directions,						"WFemaleDialog.wf_napalm_downthehall", 1);

	Clear(lNapalm_Police);
	Addto(lNapalm_Police,							"WFemaleDialog.wf_napalm_heyyoucant", 1);
//	Addto(lNapalm_Police,							"WFemaleDialog.wf_napalm_police", 1);

	Clear(lNurse_Gonorrhea);
	Addto(lNurse_Gonorrhea,							"WFemaleDialog.wf_nurse_gonorrhea", 1);

	Clear(lNurse_CheckProblem);
	Addto(lNurse_CheckProblem,						"WFemaleDialog.wf_nurse_couldyoupull", 1);

	Clear(lPostalReception_GotPackage1);
	Addto(lPostalReception_GotPackage1,				"WFemaleDialog.wf_post_gotpackage", 1);

	Clear(lPostalReception_GotPackage2);
	Addto(lPostalReception_GotPackage2,				"WFemaleDialog.wf_post_getpackage", 1);
	}


///////////////////////////////////////////////////////////////////////////////
// Default properties
///////////////////////////////////////////////////////////////////////////////
defaultproperties
	{
	}
