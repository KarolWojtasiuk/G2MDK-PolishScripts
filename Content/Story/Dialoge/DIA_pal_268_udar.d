
instance DIA_UDAR_EXIT(C_INFO)
{
	npc = pal_268_udar;
	nr = 999;
	condition = dia_udar_exit_condition;
	information = dia_udar_exit_info;
	permanent = TRUE;
	description = DIALOG_ENDE;
};


func int dia_udar_exit_condition()
{
	if(KAPITEL < 4)
	{
		return TRUE;
	};
};

func void dia_udar_exit_info()
{
	AI_StopProcessInfos(self);
};


instance DIA_UDAR_HELLO(C_INFO)
{
	npc = pal_268_udar;
	nr = 2;
	condition = dia_udar_hello_condition;
	information = dia_udar_hello_info;
	important = TRUE;
};


func int dia_udar_hello_condition()
{
	if(Npc_IsInState(self,zs_talk) && (self.aivar[AIV_TALKEDTOPLAYER] == FALSE) && (KAPITEL < 4))
	{
		return TRUE;
	};
};

func void dia_udar_hello_info()
{
	AI_Output(self,other,"DIA_Udar_Hello_09_00");	//Mia�e� cholerne szcz�cie, kiedy wszed�e�. Prawie ci� zastrzeli�em.
	AI_Output(other,self,"DIA_Udar_Hello_15_01");	//W takim razie powinienem si� cieszy�, �e masz taki bystry wzrok.
	AI_Output(self,other,"DIA_Udar_Hello_09_02");	//Oszcz�dzaj oddech. Porozmawiaj z Sengrathem, je�li czego� chcesz.
	AI_StopProcessInfos(self);
};


instance DIA_UDAR_YOUAREBEST(C_INFO)
{
	npc = pal_268_udar;
	nr = 3;
	condition = dia_udar_youarebest_condition;
	information = dia_udar_youarebest_info;
	permanent = FALSE;
	description = "S�ysza�em, �e jeste� NAJLEPSZYM kusznikiem w kr�lestwie.";
};


func int dia_udar_youarebest_condition()
{
	if(Npc_KnowsInfo(other,dia_keroloth_udar))
	{
		return 1;
	};
};

func void dia_udar_youarebest_info()
{
	AI_Output(other,self,"DIA_Udar_YouAreBest_15_00");	//S�ysza�em, �e jeste� NAJLEPSZYM kusznikiem w kr�lestwie.
	AI_Output(self,other,"DIA_Udar_YouAreBest_09_01");	//Skoro tak m�wi�, to musi by� prawda. Czego chcesz?
};


instance DIA_UDAR_TEACHME(C_INFO)
{
	npc = pal_268_udar;
	nr = 3;
	condition = dia_udar_teachme_condition;
	information = dia_udar_teachme_info;
	permanent = FALSE;
	description = "Naucz mnie, jak strzela� z kuszy.";
};


func int dia_udar_teachme_condition()
{
	if(Npc_KnowsInfo(other,dia_udar_youarebest) && (UDAR_TEACHPLAYER != TRUE))
	{
		return 1;
	};
};

func void dia_udar_teachme_info()
{
	AI_Output(other,self,"DIA_Udar_Teacher_15_00");	//Naucz mnie, jak strzela� z kuszy.
	AI_Output(self,other,"DIA_Udar_Teacher_09_01");	//Zje�d�aj! Dooko�a zamku biega do�� cel�w. Po�wicz sobie na nich.
};


instance DIA_UDAR_IMGOOD(C_INFO)
{
	npc = pal_268_udar;
	nr = 3;
	condition = dia_udar_imgood_condition;
	information = dia_udar_imgood_info;
	permanent = FALSE;
	description = "Ja jestem najlepszy...";
};


func int dia_udar_imgood_condition()
{
	if(Npc_KnowsInfo(other,dia_udar_youarebest))
	{
		return 1;
	};
};

func void dia_udar_imgood_info()
{
	AI_Output(other,self,"DIA_Udar_ImGood_15_00");	//Ja jestem najlepszy...
	AI_Output(self,other,"DIA_Udar_ImGood_09_01");	//Masz racj�!
	AI_Output(self,other,"DIA_Udar_ImGood_09_02");	//No c�, skoro chcesz si� uczy�, to ci pomog�.
	UDAR_TEACHPLAYER = TRUE;
	b_logentry(TOPIC_TEACHER_OC,"Udar mo�e mnie nauczy�, jak pos�ugiwa� si� kusz�.");
};


instance DIA_UDAR_TEACH(C_INFO)
{
	npc = pal_268_udar;
	nr = 3;
	condition = dia_udar_teach_condition;
	information = dia_udar_teach_info;
	permanent = TRUE;
	description = "Chc� si� od ciebie uczy�.";
};


func int dia_udar_teach_condition()
{
	if(UDAR_TEACHPLAYER == TRUE)
	{
		return 1;
	};
};

func void dia_udar_teach_info()
{
	AI_Output(other,self,"DIA_Udar_Teach_15_00");	//Chc� si� od ciebie uczy�.
	AI_Output(self,other,"DIA_Udar_Teach_09_01");	//Dobra, strzelaj.
	Info_ClearChoices(dia_udar_teach);
	Info_AddChoice(dia_udar_teach,DIALOG_BACK,dia_udar_teach_back);
	Info_AddChoice(dia_udar_teach,b_buildlearnstring(PRINT_LEARNCROSSBOW1,b_getlearncosttalent(other,NPC_TALENT_CROSSBOW,1)),dia_udar_teach_crossbow_1);
	Info_AddChoice(dia_udar_teach,b_buildlearnstring(PRINT_LEARNCROSSBOW5,b_getlearncosttalent(other,NPC_TALENT_CROSSBOW,5)),dia_udar_teach_crossbow_5);
};

func void dia_udar_teach_back()
{
	Info_ClearChoices(dia_udar_teach);
};

func void b_udar_teachnomore1()
{
	AI_Output(self,other,"B_Udar_TeachNoMore1_09_00");	//Znasz ju� podstawy. Nie mamy czasu na wi�cej.
};

func void b_udar_teachnomore2()
{
	AI_Output(self,other,"B_Udar_TeachNoMore2_09_00");	//Aby sprawniej w�ada� broni�, musisz znale�� odpowiedniego nauczyciela.
};

func void dia_udar_teach_crossbow_1()
{
	b_teachfighttalentpercent(self,other,NPC_TALENT_CROSSBOW,1,60);
	if(other.hitchance[NPC_TALENT_CROSSBOW] >= 60)
	{
		b_udar_teachnomore1();
		if(Npc_GetTalentSkill(other,NPC_TALENT_CROSSBOW) == 1)
		{
			b_udar_teachnomore2();
		};
	};
	Info_AddChoice(dia_udar_teach,b_buildlearnstring(PRINT_LEARNCROSSBOW1,b_getlearncosttalent(other,NPC_TALENT_CROSSBOW,1)),dia_udar_teach_crossbow_1);
};

func void dia_udar_teach_crossbow_5()
{
	b_teachfighttalentpercent(self,other,NPC_TALENT_CROSSBOW,5,60);
	if(other.hitchance[NPC_TALENT_CROSSBOW] >= 60)
	{
		b_udar_teachnomore1();
		if(Npc_GetTalentSkill(other,NPC_TALENT_CROSSBOW) == 1)
		{
			b_udar_teachnomore2();
		};
	};
	Info_AddChoice(dia_udar_teach,b_buildlearnstring(PRINT_LEARNCROSSBOW5,b_getlearncosttalent(other,NPC_TALENT_CROSSBOW,5)),dia_udar_teach_crossbow_5);
};


instance DIA_UDAR_PERM(C_INFO)
{
	npc = pal_268_udar;
	nr = 11;
	condition = dia_udar_perm_condition;
	information = dia_udar_perm_info;
	permanent = FALSE;
	description = "Jak si� maj� sprawy w zamku?";
};


func int dia_udar_perm_condition()
{
	if(KAPITEL <= 3)
	{
		return TRUE;
	};
};

func void dia_udar_perm_info()
{
	AI_Output(other,self,"DIA_Udar_Perm_15_00");	//Jak maj� si� sprawy w zamku?
	AI_Output(self,other,"DIA_Udar_Perm_09_01");	//Paru ch�opak�w �wiczy, ale generalnie rzecz bior�c, wszyscy czekamy, a� co� si� stanie.
	AI_Output(self,other,"DIA_Udar_Perm_09_02");	//Ta niepewno�� nas dobija. To strategia tych przekl�tych ork�w. Poczekaj�, a� b�dziemy mieli nerwy w strz�pach.
};


instance DIA_UDAR_RING(C_INFO)
{
	npc = pal_268_udar;
	nr = 11;
	condition = dia_udar_ring_condition;
	information = dia_udar_ring_info;
	permanent = FALSE;
	description = "Prosz�, przynosz� ci pier�cie� Tengrona.";
};


func int dia_udar_ring_condition()
{
	if(Npc_HasItems(other,itri_tengron) >= 1)
	{
		return TRUE;
	};
};

func void dia_udar_ring_info()
{
	AI_Output(other,self,"DIA_Udar_Ring_15_00");	//Prosz�, przynosz� ci pier�cie� Tengrona. Powinien ci� ochroni�. Tengron powiedzia�, �e przyjdzie po niego, kiedy tylko wr�ci.
	AI_Output(self,other,"DIA_Udar_Ring_09_01");	//Co? Wiesz, co to za pier�cie�? Dosta� go w nagrod� za odwag� w bitwie.
	AI_Output(self,other,"DIA_Udar_Ring_09_02");	//M�wisz, �e chce go z powrotem? Je�li taka jest wola Innosa, to tak si� stanie. Je�li taka jest wola Innosa...
	b_giveinvitems(other,self,itri_tengron,1);
	TENGRONRING = TRUE;
	b_giveplayerxp(XP_TENGRONRING);
};


instance DIA_UDAR_KAP4_EXIT(C_INFO)
{
	npc = pal_268_udar;
	nr = 999;
	condition = dia_udar_kap4_exit_condition;
	information = dia_udar_kap4_exit_info;
	permanent = TRUE;
	description = DIALOG_ENDE;
};


func int dia_udar_kap4_exit_condition()
{
	if(KAPITEL == 4)
	{
		return TRUE;
	};
};

func void dia_udar_kap4_exit_info()
{
	AI_StopProcessInfos(self);
};


instance DIA_UDAR_KAP4WIEDERDA(C_INFO)
{
	npc = pal_268_udar;
	nr = 40;
	condition = dia_udar_kap4wiederda_condition;
	information = dia_udar_kap4wiederda_info;
	important = TRUE;
};


func int dia_udar_kap4wiederda_condition()
{
	if(KAPITEL >= 4)
	{
		return TRUE;
	};
};

func void dia_udar_kap4wiederda_info()
{
	AI_Output(self,other,"DIA_Udar_Kap4WiederDa_09_00");	//Dobrze, �e przyszed�e�. Mamy tu istne piek�o.
	if(hero.guild != GIL_DJG)
	{
		AI_Output(other,self,"DIA_Udar_Kap4WiederDa_15_01");	//Co si� sta�o?
		AI_Output(self,other,"DIA_Udar_Kap4WiederDa_09_02");	//�owcy pusz� si� w zamku i przechwalaj�, �e potrafi� za�atwi� problem ze smokiem.
		AI_Output(self,other,"DIA_Udar_Kap4WiederDa_09_03");	//Powiem ci jednak, �e nie wygl�daj� na takich, co by sobie poradzili cho�by ze starym, schorowanym z�baczem.
	};
	AI_Output(self,other,"DIA_Udar_Kap4WiederDa_09_04");	//Coraz wi�cej z nas zaczyna si� powa�nie obawia�, czy uda nam si� wyj�� z tego ca�o.
};


instance DIA_UDAR_SENGRATH(C_INFO)
{
	npc = pal_268_udar;
	nr = 41;
	condition = dia_udar_sengrath_condition;
	information = dia_udar_sengrath_info;
	description = "Czy nie jest was tutaj dw�ch na stra�y?";
};


func int dia_udar_sengrath_condition()
{
	if((KAPITEL >= 4) && Npc_KnowsInfo(other,dia_udar_kap4wiederda) && (SENGRATH_MISSING == TRUE))
	{
		return TRUE;
	};
};

func void dia_udar_sengrath_info()
{
	AI_Output(other,self,"DIA_Udar_Sengrath_15_00");	//Czy nie jest was tutaj dw�ch na stra�y?
	AI_Output(self,other,"DIA_Udar_Sengrath_09_01");	//Ju� nie. Sengrath sta� tutaj, na blankach, gdy nagle zasn��.
	AI_Output(self,other,"DIA_Udar_Sengrath_09_02");	//Gdy to si� sta�o, jego kusza spad�a na d�.
	AI_Output(self,other,"DIA_Udar_Sengrath_09_03");	//Widzieli�my, jak jeden z ork�w j� z�apa� i znikn�� w ciemno�ciach.
	AI_Output(self,other,"DIA_Udar_Sengrath_09_04");	//Wtedy Sengrath obudzi� si� i pobieg� w noc, w stron� orkowskiej palisady. Od tamtej pory go nie widziano.
	AI_Output(self,other,"DIA_Udar_Sengrath_09_05");	//Chro� nas Innosie!
	Log_CreateTopic(TOPIC_SENGRATH_MISSING,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_SENGRATH_MISSING,LOG_RUNNING);
	b_logentry(TOPIC_SENGRATH_MISSING,"Udar, stra�nik na zamku, t�skni za Sengrathem. Ostatnio widzia� go p�n� noc�, kiedy ten bieg� w stron� orkowych umocnie�, aby odzyska� sw� kusz�.");
};


instance DIA_UDAR_SENGRATHGEFUNDEN(C_INFO)
{
	npc = pal_268_udar;
	nr = 42;
	condition = dia_udar_sengrathgefunden_condition;
	information = dia_udar_sengrathgefunden_info;
	description = "Znalaz�em Sengratha.";
};


func int dia_udar_sengrathgefunden_condition()
{
	if((KAPITEL >= 4) && Npc_KnowsInfo(other,dia_udar_sengrath) && Npc_HasItems(other,itrw_sengrathsarmbrust_mis))
	{
		return TRUE;
	};
};

func void dia_udar_sengrathgefunden_info()
{
	AI_Output(other,self,"DIA_Udar_SENGRATHGEFUNDEN_15_00");	//Znalaz�em Sengratha.
	AI_Output(self,other,"DIA_Udar_SENGRATHGEFUNDEN_09_01");	//Naprawd�? Gdzie on jest?
	AI_Output(other,self,"DIA_Udar_SENGRATHGEFUNDEN_15_02");	//Nie �yje. Oto jego kusza. Mia� j� przy sobie.
	AI_Output(self,other,"DIA_Udar_SENGRATHGEFUNDEN_09_03");	//Musia� odzyska� swoj� kusz�, ale wygl�da na to, �e orkowie jednak go zabili.
	AI_Output(self,other,"DIA_Udar_SENGRATHGEFUNDEN_09_04");	//Przekl�ty g�upiec. Wiedzia�em, �e tak b�dzie. Wszyscy zginiemy.
	TOPIC_END_SENGRATH_MISSING = TRUE;
	b_giveplayerxp(XP_SENGRATHFOUND);
};


instance DIA_UDAR_BADFEELING(C_INFO)
{
	npc = pal_268_udar;
	nr = 50;
	condition = dia_udar_badfeeling_condition;
	information = dia_udar_badfeeling_info;
	important = TRUE;
	permanent = TRUE;
};


func int dia_udar_badfeeling_condition()
{
	if((Npc_RefuseTalk(self) == FALSE) && Npc_IsInState(self,zs_talk) && Npc_KnowsInfo(other,dia_udar_sengrathgefunden) && (KAPITEL >= 4))
	{
		return TRUE;
	};
};

func void dia_udar_badfeeling_info()
{
	if(MIS_OCGATEOPEN == TRUE)
	{
		AI_Output(self,other,"DIA_Udar_BADFEELING_09_00");	//Jeszcze jeden taki atak i b�dzie po nas.
	}
	else if(MIS_ALLDRAGONSDEAD == TRUE)
	{
		AI_Output(self,other,"DIA_Udar_BADFEELING_09_01");	//Orkowie s� bardzo zaniepokojeni. Co� ich nie�le przestraszy�o. Czuj� to.
	}
	else
	{
		AI_Output(self,other,"DIA_Udar_BADFEELING_09_02");	//Mam co do tego naprawd� z�e przeczucia.
	};
	Npc_SetRefuseTalk(self,30);
};


instance DIA_UDAR_KAP5_EXIT(C_INFO)
{
	npc = pal_268_udar;
	nr = 999;
	condition = dia_udar_kap5_exit_condition;
	information = dia_udar_kap5_exit_info;
	permanent = TRUE;
	description = DIALOG_ENDE;
};


func int dia_udar_kap5_exit_condition()
{
	if(KAPITEL == 5)
	{
		return TRUE;
	};
};

func void dia_udar_kap5_exit_info()
{
	AI_StopProcessInfos(self);
};


instance DIA_UDAR_KAP6_EXIT(C_INFO)
{
	npc = pal_268_udar;
	nr = 999;
	condition = dia_udar_kap6_exit_condition;
	information = dia_udar_kap6_exit_info;
	permanent = TRUE;
	description = DIALOG_ENDE;
};


func int dia_udar_kap6_exit_condition()
{
	if(KAPITEL == 6)
	{
		return TRUE;
	};
};

func void dia_udar_kap6_exit_info()
{
	AI_StopProcessInfos(self);
};


instance DIA_UDAR_PICKPOCKET(C_INFO)
{
	npc = pal_268_udar;
	nr = 900;
	condition = dia_udar_pickpocket_condition;
	information = dia_udar_pickpocket_info;
	permanent = TRUE;
	description = PICKPOCKET_20;
};


func int dia_udar_pickpocket_condition()
{
	return c_beklauen(20,15);
};

func void dia_udar_pickpocket_info()
{
	Info_ClearChoices(dia_udar_pickpocket);
	Info_AddChoice(dia_udar_pickpocket,DIALOG_BACK,dia_udar_pickpocket_back);
	Info_AddChoice(dia_udar_pickpocket,DIALOG_PICKPOCKET,dia_udar_pickpocket_doit);
};

func void dia_udar_pickpocket_doit()
{
	b_beklauen();
	Info_ClearChoices(dia_udar_pickpocket);
};

func void dia_udar_pickpocket_back()
{
	Info_ClearChoices(dia_udar_pickpocket);
};

