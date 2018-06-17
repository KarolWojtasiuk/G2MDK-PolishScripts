
instance DIA_ANDRE_EXIT(C_INFO)
{
	npc = mil_311_andre;
	nr = 999;
	condition = dia_andre_exit_condition;
	information = dia_andre_exit_info;
	permanent = TRUE;
	description = DIALOG_ENDE;
};


func int dia_andre_exit_condition()
{
	if(self.aivar[AIV_TALKEDTOPLAYER] == TRUE)
	{
		return TRUE;
	};
};

func void dia_andre_exit_info()
{
	AI_StopProcessInfos(self);
};


instance DIA_ANDRE_FIRSTEXIT(C_INFO)
{
	npc = mil_311_andre;
	nr = 999;
	condition = dia_andre_firstexit_condition;
	information = dia_andre_firstexit_info;
	permanent = FALSE;
	description = DIALOG_ENDE;
};


func int dia_andre_firstexit_condition()
{
	if(self.aivar[AIV_TALKEDTOPLAYER] == FALSE)
	{
		return TRUE;
	};
};

func void dia_andre_firstexit_info()
{
	AI_StopProcessInfos(self);
	Npc_ExchangeRoutine(self,"START");
	b_startotherroutine(wulfgar,"START");
};


var int andre_steckbrief;

func void b_andre_steckbrief()
{
	AI_Output(self,other,"DIA_Andre_Add_08_00");	//Jeden z moich ludzi m�wi�, �e bandyci rozprowadzaj� listy go�cze z twoim portretem.
	AI_Output(self,other,"DIA_Andre_Add_08_01");	//M�wi� te�, �e pocz�tkowo temu zaprzecza�e�.
	AI_Output(self,other,"DIA_Andre_Add_08_02");	//Wi�c o co tu chodzi?
	AI_Output(other,self,"DIA_Andre_Add_15_03");	//Nie wiem, dlaczego ci ludzie mnie szukaj�...
	AI_Output(self,other,"DIA_Andre_Add_08_04");	//Dla twojego dobra mam nadziej�, �e m�wisz prawd�.
	AI_Output(self,other,"DIA_Andre_Add_08_05");	//Nie mog� tolerowa� w stra�y kogo�, kto ma co� na sumieniu.
	AI_Output(self,other,"DIA_Andre_Add_08_06");	//Wi�kszo�� bandyt�w to dawni wi�niowie z kolonii g�rniczej.
	AI_Output(self,other,"DIA_Andre_Add_08_07");	//Mam nadziej�, �e nie zadawa�e� si� z tymi bandziorami!
	ANDRE_STECKBRIEF = TRUE;
};


var int andre_cantharfalle;

func void b_andre_cantharfalle()
{
	AI_Output(self,other,"B_Andre_CantharFalle_08_00");	//By� tu kupiec Canthar. M�wi�, �e jeste� zbiegiem z kolonii g�rniczej.
	AI_Output(self,other,"B_Andre_CantharFalle_08_01");	//Nie wiem, czy to prawda i wol� nie pyta�, ale sam powiniene� wyja�ni� t� spraw�.
	b_removenpc(sarah);
	b_startotherroutine(canthar,"MARKTSTAND");
	AI_Teleport(canthar,"NW_CITY_SARAH");
	if((CANTHAR_SPERRE == FALSE) && (CANTHAR_PAY == FALSE))
	{
		CANTHAR_SPERRE = TRUE;
	};
	MIS_CANTHARS_KOMPROBRIEF = LOG_OBSOLETE;
	b_checklog();
	ANDRE_CANTHARFALLE = TRUE;
};


instance DIA_ANDRE_CANTHARFALLE(C_INFO)
{
	npc = mil_311_andre;
	nr = 3;
	condition = dia_andre_cantharfalle_condition;
	information = dia_andre_cantharfalle_info;
	permanent = TRUE;
	important = TRUE;
};


func int dia_andre_cantharfalle_condition()
{
	if((MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING) && (MIS_CANTHARS_KOMPROBRIEF_DAY <= (Wld_GetDay() - 2)) && (ANDRE_CANTHARFALLE == FALSE))
	{
		return TRUE;
	};
	if((PABLO_ANDREMELDEN == TRUE) && !Npc_IsDead(pablo) && (ANDRE_STECKBRIEF == FALSE))
	{
		return TRUE;
	};
};

func int dia_andre_cantharfalle_info()
{
	if(ANDRE_STECKBRIEF == FALSE)
	{
		b_andre_steckbrief();
	};
	if((ANDRE_CANTHARFALLE == FALSE) && (MIS_CANTHARS_KOMPROBRIEF_DAY <= (Wld_GetDay() - 2)))
	{
		b_andre_cantharfalle();
	};
};


var int andre_lastpetzcounter;
var int andre_lastpetzcrime;

instance DIA_ANDRE_PMSCHULDEN(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_pmschulden_condition;
	information = dia_andre_pmschulden_info;
	permanent = TRUE;
	important = TRUE;
};


func int dia_andre_pmschulden_condition()
{
	if(Npc_IsInState(self,zs_talk) && (ANDRE_SCHULDEN > 0) && (b_getgreatestpetzcrime(self) <= ANDRE_LASTPETZCRIME))
	{
		return TRUE;
	};
};

func void dia_andre_pmschulden_info()
{
	var int diff;
	AI_Output(self,other,"DIA_Andre_PMSchulden_08_00");	//Przyszed�e�, �eby zap�aci� grzywn�?
	if((PABLO_ANDREMELDEN == TRUE) && !Npc_IsDead(pablo) && (ANDRE_STECKBRIEF == FALSE))
	{
		b_andre_steckbrief();
	};
	if((MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING) && (MIS_CANTHARS_KOMPROBRIEF_DAY <= (Wld_GetDay() - 2)) && (ANDRE_CANTHARFALLE == FALSE))
	{
		b_andre_cantharfalle();
	};
	if(b_gettotalpetzcounter(self) > ANDRE_LASTPETZCOUNTER)
	{
		AI_Output(self,other,"DIA_Andre_PMSchulden_08_01");	//Zastanawia�em si�, czy o�mielisz si� tu przyj��!
		AI_Output(self,other,"DIA_Andre_PMSchulden_08_02");	//Pojawi�y si� nowe oskar�enia pod twoim adresem!
		if(ANDRE_SCHULDEN < 1000)
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_03");	//Ostrzega�em ci�! Teraz musisz zap�aci� wi�ksz� grzywn�!
			AI_Output(other,self,"DIA_Andre_PMAdd_15_00");	//Ile?
			diff = b_gettotalpetzcounter(self) - ANDRE_LASTPETZCOUNTER;
			if(diff > 0)
			{
				ANDRE_SCHULDEN = ANDRE_SCHULDEN + (diff * 50);
			};
			if(ANDRE_SCHULDEN > 1000)
			{
				ANDRE_SCHULDEN = 1000;
			};
			b_say_gold(self,other,ANDRE_SCHULDEN);
		}
		else
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_04");	//Bardzo mnie rozczarowa�e�!
		};
	}
	else if(b_getgreatestpetzcrime(self) < ANDRE_LASTPETZCRIME)
	{
		AI_Output(self,other,"DIA_Andre_PMSchulden_08_05");	//Pojawi�y si� nowe okoliczno�ci.
		if(ANDRE_LASTPETZCRIME == CRIME_MURDER)
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_06");	//Nagle nikt ju� nie oskar�a ci� o morderstwo.
		};
		if((ANDRE_LASTPETZCRIME == CRIME_THEFT) || ((ANDRE_LASTPETZCRIME > CRIME_THEFT) && (b_getgreatestpetzcrime(self) < CRIME_THEFT)))
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_07");	//Nikt ju� sobie nie przypomina, �eby widzia� ci� podczas kradzie�y.
		};
		if((ANDRE_LASTPETZCRIME == CRIME_ATTACK) || ((ANDRE_LASTPETZCRIME > CRIME_ATTACK) && (b_getgreatestpetzcrime(self) < CRIME_ATTACK)))
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_08");	//Nie ma ju� �adnych �wiadk�w, kt�rzy by twierdzili, �e widzieli, jak bra�e� udzia� w b�jce.
		};
		if(b_getgreatestpetzcrime(self) == CRIME_NONE)
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_09");	//Najwyra�niej wycofano wszystkie oskar�enia pod twoim adresem.
		};
		AI_Output(self,other,"DIA_Andre_PMSchulden_08_10");	//Nie wiem, jak to si� sta�o, ale ostrzegam ci�: nie pogrywaj sobie ze mn�.
		if(b_getgreatestpetzcrime(self) == CRIME_NONE)
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_11");	//Tak czy inaczej, postanowi�em odst�pi� od egzekucji grzywny.
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_12");	//Zadbaj o to, �eby nie wpakowa� si� w nowe k�opoty.
			ANDRE_SCHULDEN = 0;
			ANDRE_LASTPETZCOUNTER = 0;
			ANDRE_LASTPETZCRIME = CRIME_NONE;
		}
		else
		{
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_13");	//Chc�, �eby jedno by�o jasne: i tak b�dziesz musia� zap�aci� ca�� grzywn�.
			b_say_gold(self,other,ANDRE_SCHULDEN);
			AI_Output(self,other,"DIA_Andre_PMSchulden_08_14");	//A wi�c, o co chodzi?
		};
	};
	if(b_getgreatestpetzcrime(self) != CRIME_NONE)
	{
		Info_ClearChoices(dia_andre_pmschulden);
		Info_ClearChoices(dia_andre_petzmaster);
		Info_AddChoice(dia_andre_pmschulden,"Nie mam tyle z�ota.",dia_andre_petzmaster_paylater);
		Info_AddChoice(dia_andre_pmschulden,"Ile to mia�o by�?",dia_andre_pmschulden_howmuchagain);
		if(Npc_HasItems(other,itmi_gold) >= ANDRE_SCHULDEN)
		{
			Info_AddChoice(dia_andre_pmschulden,"Chc� zap�aci� grzywn�!",dia_andre_petzmaster_paynow);
		};
	};
};

func void dia_andre_pmschulden_howmuchagain()
{
	AI_Output(other,self,"DIA_Andre_PMSchulden_HowMuchAgain_15_00");	//Ile to mia�o by�?
	b_say_gold(self,other,ANDRE_SCHULDEN);
	Info_ClearChoices(dia_andre_pmschulden);
	Info_ClearChoices(dia_andre_petzmaster);
	Info_AddChoice(dia_andre_pmschulden,"Nie mam tyle z�ota.",dia_andre_petzmaster_paylater);
	Info_AddChoice(dia_andre_pmschulden,"Ile to mia�o by�?",dia_andre_pmschulden_howmuchagain);
	if(Npc_HasItems(other,itmi_gold) >= ANDRE_SCHULDEN)
	{
		Info_AddChoice(dia_andre_pmschulden,"Chc� zap�aci� grzywn�!",dia_andre_petzmaster_paynow);
	};
};


instance DIA_ANDRE_PETZMASTER(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_petzmaster_condition;
	information = dia_andre_petzmaster_info;
	permanent = TRUE;
	important = TRUE;
};


func int dia_andre_petzmaster_condition()
{
	if(b_getgreatestpetzcrime(self) > ANDRE_LASTPETZCRIME)
	{
		return TRUE;
	};
};

func void dia_andre_petzmaster_info()
{
	ANDRE_SCHULDEN = 0;
	if(self.aivar[AIV_TALKEDTOPLAYER] == FALSE)
	{
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_00");	//Musisz by� tym nowym, kt�ry narobi� w mie�cie sporo zamieszania.
	};
	if((PABLO_ANDREMELDEN == TRUE) && !Npc_IsDead(pablo) && (ANDRE_STECKBRIEF == FALSE))
	{
		b_andre_steckbrief();
	};
	if((MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING) && (MIS_CANTHARS_KOMPROBRIEF_DAY <= (Wld_GetDay() - 2)) && (ANDRE_CANTHARFALLE == FALSE))
	{
		b_andre_cantharfalle();
	};
	if(b_getgreatestpetzcrime(self) == CRIME_MURDER)
	{
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_01");	//Dobrze, �e do mnie przyszed�e�, zanim twoja sytuacja sta�a si� beznadziejna.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_02");	//Morderstwo to powa�ne przest�pstwo!
		ANDRE_SCHULDEN = b_gettotalpetzcounter(self) * 50;
		ANDRE_SCHULDEN = ANDRE_SCHULDEN + 500;
		if((PETZCOUNTER_CITY_THEFT + PETZCOUNTER_CITY_ATTACK + PETZCOUNTER_CITY_SHEEPKILLER) > 0)
		{
			AI_Output(self,other,"DIA_Andre_PETZMASTER_08_03");	//Nie m�wi�c ju� o innych twoich wyst�pkach.
		};
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_04");	//Stra�nicy otrzymali rozkaz, by zabija� morderc�w bez s�du.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_05");	//Obywatele nie b�d� tolerowa� mordercy w mie�cie!
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_06");	//Nie mam zamiaru ci� wiesza�. Prowadzimy wojn� i potrzebny nam jest ka�dy cz�owiek.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_07");	//Ale nie�atwo b�dzie przekona� mieszka�c�w, �eby ci znowu zaufali.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_08");	//M�g�by� okaza� skruch�, p�ac�c grzywn� - oczywi�cie, odpowiednio wysok�.
	};
	if(b_getgreatestpetzcrime(self) == CRIME_THEFT)
	{
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_09");	//Dobrze, �e przyszed�e�! Jeste� oskar�ony o kradzie�! S� na to �wiadkowie.
		if((PETZCOUNTER_CITY_ATTACK + PETZCOUNTER_CITY_SHEEPKILLER) > 0)
		{
			AI_Output(self,other,"DIA_Andre_PETZMASTER_08_10");	//Nie b�d� wspomina� o innych sprawach, o kt�rych s�ysza�em.
		};
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_11");	//Nie mam zamiaru tolerowa� takich rzeczy w mie�cie!
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_12");	//�eby odpokutowa� za swoje winy, musisz zap�aci� grzywn�.
		ANDRE_SCHULDEN = b_gettotalpetzcounter(self) * 50;
	};
	if(b_getgreatestpetzcrime(self) == CRIME_ATTACK)
	{
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_13");	//Bijatyka z mot�ochem w porcie to jedno...
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_14");	//Ale je�li napadasz na obywateli, albo �o�nierzy Kr�la, to musisz stan�� przed obliczem sprawiedliwo�ci.
		if(PETZCOUNTER_CITY_SHEEPKILLER > 0)
		{
			AI_Output(self,other,"DIA_Andre_PETZMASTER_08_15");	//A ta sprawa z owcami te� niezbyt dobrze wp�yn�a na twoj� reputacj�.
		};
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_16");	//Je�li ci� za to nie ukarz�, wkr�tce wszyscy b�d� robili, co im tylko przyjdzie do g�owy.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_17");	//A wi�c musisz zap�aci� odpowiedni� grzywn� - i sprawa p�jdzie w zapomnienie.
		ANDRE_SCHULDEN = b_gettotalpetzcounter(self) * 50;
	};
	if(b_getgreatestpetzcrime(self) == CRIME_SHEEPKILLER)
	{
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_18");	//Dosz�o do mnie, �e polowa�e� na nasze owce.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_19");	//Chyba rozumiesz, �e nie mog� tego pu�ci� p�azem.
		AI_Output(self,other,"DIA_Andre_PETZMASTER_08_20");	//Musisz zap�aci� odszkodowanie!
		ANDRE_SCHULDEN = 100;
	};
	AI_Output(other,self,"DIA_Andre_PETZMASTER_15_21");	//Ile?
	if(ANDRE_SCHULDEN > 1000)
	{
		ANDRE_SCHULDEN = 1000;
	};
	b_say_gold(self,other,ANDRE_SCHULDEN);
	Info_ClearChoices(dia_andre_pmschulden);
	Info_ClearChoices(dia_andre_petzmaster);
	Info_AddChoice(dia_andre_petzmaster,"Nie mam tyle z�ota.",dia_andre_petzmaster_paylater);
	if(Npc_HasItems(other,itmi_gold) >= ANDRE_SCHULDEN)
	{
		Info_AddChoice(dia_andre_petzmaster,"Chc� zap�aci� grzywn�!",dia_andre_petzmaster_paynow);
	};
};

func void dia_andre_petzmaster_paynow()
{
	AI_Output(other,self,"DIA_Andre_PETZMASTER_PayNow_15_00");	//Chc� zap�aci� grzywn�.
	b_giveinvitems(other,self,itmi_gold,ANDRE_SCHULDEN);
	AI_Output(self,other,"DIA_Andre_PETZMASTER_PayNow_08_01");	//Dobrze! Dopilnuj�, �eby wszyscy mieszka�cy si� o tym dowiedzieli. W pewnym stopniu poprawi to twoj� reputacj�.
	b_grantabsolution(LOC_CITY);
	ANDRE_SCHULDEN = 0;
	ANDRE_LASTPETZCOUNTER = 0;
	ANDRE_LASTPETZCRIME = CRIME_NONE;
	Info_ClearChoices(dia_andre_petzmaster);
	Info_ClearChoices(dia_andre_pmschulden);
};

func void dia_andre_petzmaster_paylater()
{
	AI_Output(other,self,"DIA_Andre_PETZMASTER_PayLater_15_00");	//Nie mam tyle z�ota.
	AI_Output(self,other,"DIA_Andre_PETZMASTER_PayLater_08_01");	//A wi�c postaraj si� je zdoby� jak najszybciej.
	AI_Output(self,other,"DIA_Andre_PETZMASTER_PayLater_08_02");	//Ostrzegam ci� - je�li pope�nisz kolejne przest�pstwo, twoja sytuacja jeszcze bardziej si� pogorszy.
	ANDRE_LASTPETZCOUNTER = b_gettotalpetzcounter(self);
	ANDRE_LASTPETZCRIME = b_getgreatestpetzcrime(self);
	AI_StopProcessInfos(self);
};


instance DIA_ANDRE_HALLO(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_hallo_condition;
	information = dia_andre_hallo_info;
	permanent = FALSE;
	important = TRUE;
};


func int dia_andre_hallo_condition()
{
	if(Npc_IsInState(self,zs_talk) && (self.aivar[AIV_TALKEDTOPLAYER] == FALSE))
	{
		return TRUE;
	};
};

func void dia_andre_hallo_info()
{
	AI_Output(self,other,"DIA_Andre_Hallo_08_00");	//Niech Innos b�dzie z tob�, przybyszu! Co ci� do mnie sprowadza?
};


instance DIA_ANDRE_MESSAGE(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_message_condition;
	information = dia_andre_message_info;
	permanent = FALSE;
	description = "Mam wa�n� wiadomo�� dla Lorda Hagena.";
};


func int dia_andre_message_condition()
{
	if((KAPITEL < 3) && ((hero.guild == GIL_NONE) || (hero.guild == GIL_NOV)))
	{
		return TRUE;
	};
};

func void dia_andre_message_info()
{
	AI_Output(other,self,"DIA_Andre_Message_15_00");	//Mam wa�n� wiadomo�� dla Lorda Hagena.
	AI_Output(self,other,"DIA_Andre_Message_08_01");	//No c�, stoisz przed jednym z jego ludzi. O co chodzi?
	Info_ClearChoices(dia_andre_message);
	Info_AddChoice(dia_andre_message,"To mog� powiedzie� jedynie Lordowi Hagenowi.",dia_andre_message_personal);
	Info_AddChoice(dia_andre_message,"Watahy ork�w s� prowadzone przez SMO...",dia_andre_message_dragons);
	Info_AddChoice(dia_andre_message,"Chodzi o �wi�ty artefakt - Oko Innosa.",dia_andre_message_eyeinnos);
};

func void b_andre_lordhagennichtzusprechen()
{
	AI_Output(self,other,"B_Andre_LordHagenNichtZuSprechen_08_00");	//Lord Hagen przyjmuje tylko paladyn�w albo tych, kt�rzy s� na ich s�u�bie.
	AI_Output(self,other,"B_Andre_LordHagenNichtZuSprechen_08_01");	//Marnowanie czasu z prostymi lud�mi jest poni�ej jego godno�ci.
};

func void dia_andre_message_eyeinnos()
{
	AI_Output(other,self,"DIA_Andre_Message_EyeInnos_15_00");	//Chodzi o �wi�ty artefakt - Oko Innosa.
	AI_Output(self,other,"DIA_Andre_Message_EyeInnos_08_01");	//Oko Innosa - nigdy o czym� takim nie s�ysza�em. Ale to jeszcze nic nie znaczy.
	AI_Output(self,other,"DIA_Andre_Message_EyeInnos_08_02");	//Je�li naprawd� istnieje artefakt o takiej nazwie, b�d� o nim wiedzie� tylko najwa�niejsi przedstawiciele naszego zakonu.
	AI_Output(other,self,"DIA_Andre_Message_EyeInnos_15_03");	//Dlatego musz� porozmawia� z samym Lordem Hagenem.
	ANDRE_EYEINNOS = TRUE;
	b_andre_lordhagennichtzusprechen();
	Info_ClearChoices(dia_andre_message);
};

func void dia_andre_message_dragons()
{
	AI_Output(other,self,"DIA_Andre_Message_Dragons_15_00");	//Watahy ork�w s� prowadzone przez SMO...
	AI_Output(self,other,"DIA_Andre_Message_Dragons_08_01");	//WIEM, �e armie ork�w staj� si� coraz silniejsze.
	AI_Output(self,other,"DIA_Andre_Message_Dragons_08_02");	//Chyba nie chcesz mi powiedzie�, �e o TYM chcesz donie�� Lordowi Hagenowi?
	AI_Output(self,other,"DIA_Andre_Message_Dragons_08_03");	//Urwa�by ci g�ow� za marnowanie jego czasu takimi historiami.
	AI_Output(self,other,"DIA_Andre_Message_Dragons_08_04");	//S�dz�, �e jeste� do�� bystry, aby samemu zda� sobie z tego spraw�.
	AI_Output(self,other,"DIA_Andre_Message_Dragons_08_05");	//A wi�c, o co naprawd� chodzi?
};

func void dia_andre_message_personal()
{
	AI_Output(other,self,"DIA_Andre_Message_Personal_15_00");	//To mog� powiedzie� jedynie Lordowi Hagenowi.
	AI_Output(self,other,"DIA_Andre_Message_Personal_08_01");	//Jak chcesz. Ale pami�taj o jednym:
	b_andre_lordhagennichtzusprechen();
	Info_ClearChoices(dia_andre_message);
};


instance DIA_ANDRE_PALADINE(C_INFO)
{
	npc = mil_311_andre;
	nr = 3;
	condition = dia_andre_paladine_condition;
	information = dia_andre_paladine_info;
	permanent = FALSE;
	description = "Co robicie w mie�cie?";
};


func int dia_andre_paladine_condition()
{
	if((other.guild != GIL_MIL) && (KAPITEL < 3))
	{
		return TRUE;
	};
};

func void dia_andre_paladine_info()
{
	AI_Output(other,self,"DIA_Andre_Paladine_15_00");	//Co robicie w mie�cie?
	AI_Output(self,other,"DIA_Andre_Paladine_08_01");	//Nasze zadanie jest tajne.
	AI_Output(self,other,"DIA_Andre_Paladine_08_02");	//Mog� ci� tylko zapewni�, �e nic nie grozi mieszka�com miasta.
	AI_Output(self,other,"DIA_Andre_Paladine_08_03");	//Nie musisz si� martwi�.
};


instance DIA_ANDRE_PALADINEAGAIN(C_INFO)
{
	npc = mil_311_andre;
	nr = 3;
	condition = dia_andre_paladineagain_condition;
	information = dia_andre_paladineagain_info;
	permanent = FALSE;
	description = "Co robicie w mie�cie?";
};


func int dia_andre_paladineagain_condition()
{
	if((other.guild == GIL_MIL) && (KAPITEL < 3))
	{
		return TRUE;
	};
};

func void dia_andre_paladineagain_info()
{
	if(Npc_KnowsInfo(other,dia_andre_paladine))
	{
		AI_Output(other,self,"DIA_Andre_PaladineAgain_15_00");	//Czy mo�esz mi powiedzie�, dlaczego przybyli�cie do Khorinis?
	}
	else
	{
		AI_Output(other,self,"DIA_Andre_PaladineAgain_15_01");	//Co robicie w mie�cie?
	};
	AI_Output(self,other,"DIA_Andre_PaladineAgain_08_02");	//Teraz, skoro nale�ysz do stra�y miejskiej, jeste� te� podw�adnym paladyn�w.
	AI_Output(self,other,"DIA_Andre_PaladineAgain_08_03");	//A zatem mog� wtajemniczy� ci� w pewne sprawy.
	AI_Output(self,other,"DIA_Andre_PaladineAgain_08_04");	//Kr�l Rhobar wyznaczy� nam zadanie. Po zniszczeniu Bariery zmniejszy�y si� dostawy rudy.
	AI_Output(self,other,"DIA_Andre_PaladineAgain_08_05");	//Dlatego sprowadzamy j� na kontynent. Z rudy �elaza wykujemy now� bro� i odeprzemy ork�w.
	KNOWSPALADINS_ORE = TRUE;
};


instance DIA_ANDRE_ASKTOJOIN(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_asktojoin_condition;
	information = dia_andre_asktojoin_info;
	permanent = FALSE;
	description = "Chc� wst�pi� na s�u�b� u paladyn�w!";
};


func int dia_andre_asktojoin_condition()
{
	if(hero.guild == GIL_NONE)
	{
		return TRUE;
	};
};

func void dia_andre_asktojoin_info()
{
	AI_Output(other,self,"DIA_Andre_AskToJoin_15_00");	//Chc� wst�pi� na s�u�b� u paladyn�w!
	if(Npc_KnowsInfo(other,dia_andre_message))
	{
		AI_Output(self,other,"DIA_Andre_AskToJoin_08_01");	//Dobrze. Przyda mi si� tu ka�dy zdolny cz�owiek. Niewa�ne, jakie ma powody, �eby do nas do��czy�.
		AI_Output(self,other,"DIA_Andre_AskToJoin_08_02");	//Je�li wst�pisz na s�u�b� u paladyn�w, pomog� ci uzyska� audiencj� u Lorda Hagena.
	}
	else
	{
		AI_Output(self,other,"DIA_Andre_AskToJoin_08_03");	//Szlachetny zamiar.
	};
	AI_Output(self,other,"DIA_Andre_AskToJoin_08_04");	//Niestety, rozkazy pozwalaj� mi przyjmowa� na s�u�b� w stra�y tylko obywateli miasta.
	AI_Output(self,other,"DIA_Andre_AskToJoin_08_05");	//M�j komandant boi si�, �e w szeregi stra�y mogliby si� zakra�� szpiedzy albo dywersanci.
	AI_Output(self,other,"DIA_Andre_AskToJoin_08_06");	//Chce w ten spos�b zmniejszy� ryzyko zdrady.
	AI_Output(self,other,"DIA_Andre_AskToJoin_08_07");	//Dlatego musisz najpierw zosta� obywatelem miasta. Rozkaz to rozkaz, niewa�ne, czy ma sens.
	Log_CreateTopic(TOPIC_BECOMEMIL,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_BECOMEMIL,LOG_RUNNING);
	b_logentry(TOPIC_BECOMEMIL,"Zanim b�d� m�g� wst�pi� do stra�y, musz� zosta� obywatelem miasta.");
};


instance DIA_ANDRE_ABOUTMILIZ(C_INFO)
{
	npc = mil_311_andre;
	nr = 5;
	condition = dia_andre_aboutmiliz_condition;
	information = dia_andre_aboutmiliz_info;
	permanent = FALSE;
	description = "Czego mog� si� spodziewa� w stra�y?";
};


func int dia_andre_aboutmiliz_condition()
{
	if((other.guild == GIL_NONE) && Npc_KnowsInfo(other,dia_andre_asktojoin))
	{
		return TRUE;
	};
};

func void dia_andre_aboutmiliz_info()
{
	AI_Output(other,self,"DIA_Andre_AboutMiliz_15_00");	//Czego mog� si� spodziewa� w stra�y?
	AI_Output(self,other,"DIA_Andre_AboutMiliz_08_01");	//Postawmy spraw� jasno. Bycie cz�onkiem stra�y nie oznacza, �e przez ca�y dzie� mo�na w��czy� si� w mundurze po mie�cie.
	AI_Output(self,other,"DIA_Andre_AboutMiliz_08_02");	//To brudna, a czasem nawet krwawa robota. Kiedy b�dziesz jednym z nas, czeka ci� sporo pracy.
	AI_Output(self,other,"DIA_Andre_AboutMiliz_08_03");	//Ale warto. Mo�e pewnego dnia, opr�cz zap�aty, b�dziesz mia� okazj� zosta� jednym ze �wi�tych wojownik�w Innosa.
};


instance DIA_ADDON_ANDRE_MARTINEMPFEHLUNG(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_addon_andre_martinempfehlung_condition;
	information = dia_addon_andre_martinempfehlung_info;
	description = "Mam tu list polecaj�cy od waszego kwatermistrza.";
};


func int dia_addon_andre_martinempfehlung_condition()
{
	if(Npc_HasItems(other,itwr_martin_milizempfehlung_addon) && Npc_KnowsInfo(other,dia_andre_asktojoin))
	{
		return TRUE;
	};
};

func void dia_addon_andre_martinempfehlung_info()
{
	AI_Output(other,self,"DIA_Addon_Andre_MartinEmpfehlung_15_00");	//Mam tu list polecaj�cy od waszego kwatermistrza.
	AI_Output(self,other,"DIA_Addon_Andre_MartinEmpfehlung_08_01");	//Co? Poka� mi go natychmiast!
	b_giveinvitems(other,self,itwr_martin_milizempfehlung_addon,1);
	b_usefakescroll();
	AI_Output(self,other,"DIA_Addon_Andre_MartinEmpfehlung_08_02");	//Niesamowite! Musia�e� si� nie�le przys�u�y�, �eby wywrze� na nim a� takie wra�enie... Martin rzadko tak hojnie rozdaje pochwa�y.
	AI_Output(self,other,"DIA_Addon_Andre_MartinEmpfehlung_08_03");	//Przekona�e� mnie - je�li masz poparcie Martina, to i my ci� nie odrzucimy. Daj zna�, gdy b�dziesz got�w.
	ANDRE_KNOWS_MARTINEMPFEHLUNG = TRUE;
};


instance DIA_ANDRE_ALTERNATIVE(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_alternative_condition;
	information = dia_andre_alternative_info;
	permanent = FALSE;
	description = "Nie ma jakiego� szybszego sposobu, �eby do was do��czy�?";
};


func int dia_andre_alternative_condition()
{
	if(Npc_KnowsInfo(other,dia_andre_asktojoin) && (other.guild == GIL_NONE))
	{
		return TRUE;
	};
};

func void dia_andre_alternative_info()
{
	AI_Output(other,self,"DIA_Andre_Alternative_15_00");	//Nie ma jakiego� szybszego sposobu, �eby do was do��czy�?
	AI_Output(self,other,"DIA_Andre_Alternative_08_01");	//Hmmm - widz�, �e ci na tym zale�y.
	AI_Output(self,other,"DIA_Andre_Alternative_08_02");	//Dobrze, s�uchaj. Mam k�opot. Je�li go dla mnie rozwi��esz, dopilnuj�, �eby� zosta� przyj�ty do stra�y.
	AI_Output(self,other,"DIA_Andre_Alternative_08_03");	//Ale najwa�niejsze, �eby� nikomu nie szepn�� ani s�owa na ten temat!
};


instance DIA_ANDRE_GUILDOFTHIEVES(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_guildofthieves_condition;
	information = dia_andre_guildofthieves_info;
	permanent = FALSE;
	description = "W czym problem?";
};


func int dia_andre_guildofthieves_condition()
{
	if(Npc_KnowsInfo(other,dia_andre_alternative))
	{
		return TRUE;
	};
};

func void dia_andre_guildofthieves_info()
{
	AI_Output(other,self,"DIA_Andre_GuildOfThieves_15_00");	//Jaki masz problem?
	AI_Output(self,other,"DIA_Andre_GuildOfThieves_08_01");	//Ostatnio w mie�cie by�o sporo kradzie�y. Na razie nie uda�o nam si� nikogo z�apa�. Z�odzieje s� po prostu za dobrzy.
	AI_Output(self,other,"DIA_Andre_GuildOfThieves_08_02");	//Szumowiny, znaj� si� na swojej robocie. Jestem pewien, �e mamy do czynienia ze zorganizowan� band�.
	AI_Output(self,other,"DIA_Andre_GuildOfThieves_08_03");	//Nie zdziwi�bym si�, gdyby�my mieli w Khorinis gildi� z�odziei. Znajd� przyw�dc�w tej bandy i z�ap ich.
	if(other.guild == GIL_NONE)
	{
		AI_Output(self,other,"DIA_Andre_GuildOfThieves_08_04");	//Wtedy dopilnuj�, �eby przyj�to ci� do stra�y - niewa�ne, czy jeste� obywatelem, czy nie.
		AI_Output(self,other,"DIA_Andre_GuildOfThieves_08_05");	//Ale nikomu nie wolno ci m�wi� o naszej umowie!
	};
	MIS_ANDRE_GUILDOFTHIEVES = LOG_RUNNING;
	b_logentry(TOPIC_BECOMEMIL,"Istnieje inna droga wst�pienia w szeregi stra�y. Musz� tylko rozprawi� si� z gildi� z�odziei w Khorinis.");
};


instance DIA_ANDRE_WHERETHIEVES(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_wherethieves_condition;
	information = dia_andre_wherethieves_info;
	permanent = FALSE;
	description = "Gdzie powinienem szuka� tych z�odziei?";
};


func int dia_andre_wherethieves_condition()
{
	if(Npc_KnowsInfo(other,dia_andre_guildofthieves) && (MIS_ANDRE_GUILDOFTHIEVES == LOG_RUNNING))
	{
		return TRUE;
	};
};

func void dia_andre_wherethieves_info()
{
	AI_Output(other,self,"DIA_Andre_WhereThieves_15_00");	//Gdzie powinienem szuka� tych z�odziei?
	AI_Output(self,other,"DIA_Andre_WhereThieves_08_01");	//Gdybym to wiedzia�, sam bym ich z�apa�!
	AI_Output(self,other,"DIA_Andre_WhereThieves_08_02");	//Mog� ci powiedzie� tylko jedno: ostatnio przewr�cili�my do g�ry nogami ca�� dzielnic� portow� i nie znale�li�my nic, absolutnie nic.
	AI_Output(self,other,"DIA_Andre_WhereThieves_08_03");	//Tamtejsi mieszka�cy nie s� zbyt rozmowni, szczeg�lnie je�li paradujesz w zbroi paladyna.
	AI_Output(self,other,"DIA_Andre_WhereThieves_08_04");	//Ale ty jeste� cz�owiekiem z zewn�trz, tobie szybciej zaufaj�.
	AI_Output(self,other,"DIA_Andre_WhereThieves_08_05");	//Na pocz�tek mo�esz popyta� wok� portu. Ale b�d� ostro�ny. Je�li kto� si� zorientuje, �e pracujesz dla paladyn�w, NICZEGO si� nie dowiesz!
	b_logentry(TOPIC_BECOMEMIL,"Poszukiwania gildii z�odziei najrozs�dniej b�dzie chyba zacz�� w dzielnicy portowej.");
};


instance DIA_ANDRE_WHATTODO(C_INFO)
{
	npc = mil_311_andre;
	nr = 3;
	condition = dia_andre_whattodo_condition;
	information = dia_andre_whattodo_info;
	permanent = FALSE;
	description = "Co mam zrobi�, kiedy znajd� jednego ze z�odziei?";
};


func int dia_andre_whattodo_condition()
{
	if(Npc_KnowsInfo(other,dia_andre_guildofthieves) && (MIS_ANDRE_GUILDOFTHIEVES == LOG_RUNNING))
	{
		return TRUE;
	};
};

func void dia_andre_whattodo_info()
{
	AI_Output(other,self,"DIA_Andre_WhatToDo_15_00");	//Co mam zrobi�, kiedy znajd� jednego ze z�odziei?
	AI_Output(self,other,"DIA_Andre_WhatToDo_08_01");	//Je�li spotkasz jakiego� s�u��cego, pasera albo inn� p�otk�, lepiej �eby� nie wdawa� si� w bijatyk�.
	AI_Output(self,other,"DIA_Andre_WhatToDo_08_02");	//Przyjd� do mnie i o tym zamelduj. Ja dopilnuj�, �eby taki kto� wyl�dowa� za kratami.
	AI_Output(self,other,"DIA_Andre_WhatToDo_08_03");	//Podczas zamieszania mo�e zainterweniowa� stra� miejska i nie b�dziesz mia� okazji, �eby im wyja�ni�, o co chodzi.
	AI_Output(self,other,"DIA_Andre_WhatToDo_08_04");	//Poza tym jest nagroda za ka�d� czarn� owc�, kt�r� wpakujesz za kratki.
	AI_Output(self,other,"DIA_Andre_WhatToDo_08_05");	//Ale je�li uda ci si� znale�� kryj�wk� szef�w, c�, wtedy zapewne nie uda ci si� unikn�� walki.
	b_logentry(TOPIC_BECOMEMIL,"Je�li znajd� kogo� z gildii z�odziei, powinienem zabra� go do Lorda Andre. Jednak aby ostatecznie sko�czy� z gildi�, b�d� musia� znale�� jej centrum operacyjne.");
};


instance DIA_ANDRE_AUSLIEFERUNG(C_INFO)
{
	npc = mil_311_andre;
	nr = 200;
	condition = dia_andre_auslieferung_condition;
	information = dia_andre_auslieferung_info;
	permanent = TRUE;
	description = "Chc� odebra� nagrod� za przest�pc�.";
};


func int dia_andre_auslieferung_condition()
{
	if((RENGARU_AUSGELIEFERT == FALSE) || (HALVOR_AUSGELIEFERT == FALSE) || (NAGUR_AUSGELIEFERT == FALSE) || (MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING))
	{
		return TRUE;
	};
};

func void dia_andre_auslieferung_info()
{
	AI_Output(other,self,"DIA_Andre_Auslieferung_15_00");	//Chc� odebra� nagrod� za przest�pc�.
	Info_ClearChoices(dia_andre_auslieferung);
	Info_AddChoice(dia_andre_auslieferung,"Wr�c� tu jeszcze (POWR�T)",dia_andre_auslieferung_back);
	if((RENGARU_INKNAST == TRUE) && (RENGARU_AUSGELIEFERT == FALSE))
	{
		Info_AddChoice(dia_andre_auslieferung,"Rengaru okrad� kupca Jor�.",dia_andre_auslieferung_rengaru);
	};
	if((BETRAYAL_HALVOR == TRUE) && (HALVOR_AUSGELIEFERT == FALSE))
	{
		Info_AddChoice(dia_andre_auslieferung,"Halvor sprzedaje towary pochodz�ce z kradzie�y.",dia_andre_auslieferung_halvor);
	};
	if((MIS_NAGUR_BOTE == LOG_RUNNING) && (NAGUR_AUSGELIEFERT == FALSE))
	{
		Info_AddChoice(dia_andre_auslieferung,"Nagur zabi� wys�annika Baltrama.",dia_andre_auslieferung_nagur);
	};
	if((MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING) && (MIS_CANTHARS_KOMPROBRIEF_DAY > (Wld_GetDay() - 2)))
	{
		Info_AddChoice(dia_andre_auslieferung,"Canthar usi�uje si� pozby� Sary!",dia_andre_auslieferung_canthar);
	};
	if((MIS_CANTHARS_KOMPROBRIEF == LOG_RUNNING) && (Npc_HasItems(sarah,itwr_canthars_komprobrief_mis) >= 1) && (MIS_CANTHARS_KOMPROBRIEF_DAY > (Wld_GetDay() - 2)))
	{
		Info_AddChoice(dia_andre_auslieferung,"Sara sprzedaje bro� Onarowi.",dia_andre_auslieferung_sarah);
	};
};

func void dia_andre_auslieferung_back()
{
	Info_ClearChoices(dia_andre_auslieferung);
};

func void dia_andre_auslieferung_rengaru()
{
	AI_Teleport(rengaru,"NW_CITY_HABOUR_KASERN_RENGARU");
	AI_Output(other,self,"DIA_Andre_Auslieferung_Rengaru_15_00");	//Rengar okrad� kupca Jor�. Chcia� si� ulotni�, ale go z�apa�em.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Rengaru_08_01");	//Dobrze, moi ludzie ju� go zamkn�li. W najbli�szym czasie nikogo nie okradnie.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Rengaru_08_02");	//Oto twoje pieni�dze.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD);
	RENGARU_AUSGELIEFERT = TRUE;
	MIS_THIEFGUILD_SUCKED = TRUE;
	b_giveplayerxp(XP_ANDRE_AUSLIEFERUNG);
	Info_ClearChoices(dia_andre_auslieferung);
	b_startotherroutine(rengaru,"PRISON");
};

func void dia_andre_auslieferung_halvor()
{
	AI_Teleport(halvor,"NW_CITY_HABOUR_KASERN_HALVOR");
	AI_Output(other,self,"DIA_Andre_Auslieferung_Halvor_15_00");	//Halvor to paser. Sprzedaje to, co bandyci zrabuj� kupcom.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Halvor_08_01");	//A wi�c to on za tym stoi. Moi ludzie zaraz go zamkn�.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Halvor_08_02");	//W�tpi�, �eby sprawia� jeszcze jakie� k�opoty. Od razu wyp�ac� ci nagrod�.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD);
	b_startotherroutine(halvor,"PRISON");
	MIS_THIEFGUILD_SUCKED = TRUE;
	HALVOR_AUSGELIEFERT = TRUE;
	b_giveplayerxp(XP_ANDRE_AUSLIEFERUNG);
	Info_ClearChoices(dia_andre_auslieferung);
};

func void dia_andre_auslieferung_nagur()
{
	AI_Teleport(nagur,"NW_CITY_HABOUR_KASERN_NAGUR");
	AI_Output(other,self,"DIA_Andre_Auslieferung_Nagur_15_00");	//Nagur zabi� pos�a�ca Baltrama. Chcia� wykorzysta� mnie jako nowego go�ca, abym przechwyci� dostaw� Akila.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Nagur_08_01");	//Spotka go za to sprawiedliwa kara. Zaraz ka�� go zamkn��.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Nagur_08_02");	//Prosz�, we� nagrod�. Nale�y ci si�.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD);
	b_startotherroutine(nagur,"PRISON");
	MIS_THIEFGUILD_SUCKED = TRUE;
	NAGUR_AUSGELIEFERT = TRUE;
	b_giveplayerxp(XP_ANDRE_AUSLIEFERUNG);
	Info_ClearChoices(dia_andre_auslieferung);
};

func void dia_andre_auslieferung_canthar()
{
	AI_Teleport(canthar,"NW_CITY_HABOUR_KASERN_RENGARU");
	AI_Output(other,self,"DIA_Andre_Auslieferung_Canthar_15_00");	//Kupiec Canthar chce si� pozby� Sary!
	AI_Output(self,other,"DIA_Andre_Auslieferung_Canthar_08_01");	//Sary? Tej, kt�ra sprzedaje bro� na targowisku?
	AI_Output(other,self,"DIA_Andre_Auslieferung_Canthar_15_02");	//Mia�em podrzuci� jej list, dow�d na to, �e Sara sprzedaje bro� Onarowi.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Canthar_08_03");	//Rozumiem. Z rado�ci� wyp�ac� nagrod� za tego drania. Mo�esz uzna�, �e ju� siedzi za kratami.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD);
	b_startotherroutine(canthar,"KNAST");
	MIS_CANTHARS_KOMPROBRIEF = LOG_FAILED;
	b_checklog();
	CANTHAR_AUSGELIEFERT = TRUE;
	b_giveplayerxp(XP_ANDRE_AUSLIEFERUNG);
	Info_ClearChoices(dia_andre_auslieferung);
};

func void dia_andre_auslieferung_sarah()
{
	AI_Teleport(sarah,"NW_CITY_HABOUR_KASERN_RENGARU");
	AI_Teleport(canthar,"NW_CITY_SARAH");
	AI_Output(other,self,"DIA_Andre_Auslieferung_Sarah_15_00");	//Sara sprzedaje bro� Onarowi.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Sarah_08_01");	//Sara? Ta, kt�ra handluje broni� na targowisku? Masz na to jaki� dow�d?
	AI_Output(other,self,"DIA_Andre_Auslieferung_Sarah_15_02");	//Ma w kieszeni list, kt�ry dotyczy dostawy broni dla Onara.
	AI_Output(self,other,"DIA_Andre_Auslieferung_Sarah_08_03");	//Nie ujdzie jej to na sucho. Ka�� j� aresztowa�.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD);
	b_startotherroutine(sarah,"KNAST");
	b_startotherroutine(canthar,"MARKTSTAND");
	SARAH_AUSGELIEFERT = TRUE;
	MIS_CANTHARS_KOMPROBRIEF = LOG_SUCCESS;
	b_giveplayerxp(XP_ANDRE_AUSLIEFERUNG);
	Info_ClearChoices(dia_andre_auslieferung);
};


instance DIA_ANDRE_DGRUNNING(C_INFO)
{
	npc = mil_311_andre;
	nr = 4;
	condition = dia_andre_dgrunning_condition;
	information = dia_andre_dgrunning_info;
	permanent = TRUE;
	description = "Co do gildii z�odziei...";
};


func int dia_andre_dgrunning_condition()
{
	if(MIS_ANDRE_GUILDOFTHIEVES == LOG_RUNNING)
	{
		return TRUE;
	};
};

func void dia_andre_dgrunning_info()
{
	AI_Output(other,self,"DIA_Andre_DGRunning_15_00");	//Co do gildii z�odziei...
	if(ANDRE_DIEBESGILDE_AUFGERAEUMT == TRUE)
	{
		AI_Output(self,other,"DIA_Andre_DGRunning_08_01");	//Mo�esz zapomnie� o tej sprawie. Wys�a�em kilku ludzi do kana��w.
		AI_Output(self,other,"DIA_Andre_DGRunning_08_02");	//Gildia z�odziei to ju� tylko smutny rozdzia� w historii tego miasta.
		MIS_ANDRE_GUILDOFTHIEVES = LOG_OBSOLETE;
		if(MIS_CASSIAKELCHE == LOG_RUNNING)
		{
			MIS_CASSIAKELCHE = LOG_OBSOLETE;
		};
		if(MIS_RAMIREZSEXTANT == LOG_RUNNING)
		{
			MIS_RAMIREZSEXTANT = LOG_OBSOLETE;
		};
		return;
	};
	AI_Output(self,other,"DIA_Andre_DGRunning_08_03");	//Tak?
	Info_ClearChoices(dia_andre_dgrunning);
	Info_AddChoice(dia_andre_dgrunning,"Pracuj� nad tym...",dia_andre_dgrunning_back);
	if(Npc_IsDead(cassia) && Npc_IsDead(jesper) && Npc_IsDead(ramirez))
	{
		Info_AddChoice(dia_andre_dgrunning,"Wytropi�em ich wszystkich!",dia_andre_dgrunning_success);
	};
	if(((cassia.aivar[AIV_TALKEDTOPLAYER] == TRUE) || (jesper.aivar[AIV_TALKEDTOPLAYER] == TRUE) || (ramirez.aivar[AIV_TALKEDTOPLAYER] == TRUE)) && (DIEBESGILDE_VERRATEN == FALSE))
	{
		Info_AddChoice(dia_andre_dgrunning,"Znalaz�em kryj�wk� gildii z�odziei!",dia_andre_dgrunning_verrat);
	};
};

func void dia_andre_dgrunning_back()
{
	AI_Output(other,self,"DIA_Andre_DGRunning_BACK_15_00");	//Pracuj� nad tym...
	if(DIEBESGILDE_VERRATEN == TRUE)
	{
		AI_Output(self,other,"DIA_Andre_DGRunning_BACK_08_01");	//Dobrze. Dam ci jeszcze troch� czasu na wykonanie tego zadania.
	}
	else
	{
		AI_Output(self,other,"DIA_Andre_DGRunning_BACK_08_02");	//Dobrze! Informuj mnie o post�pach.
	};
	Info_ClearChoices(dia_andre_dgrunning);
};

func void dia_andre_dgrunning_verrat()
{
	AI_Output(other,self,"DIA_Andre_DGRunning_Verrat_15_00");	//Znalaz�em kryj�wk� gildii z�odziei!
	AI_Output(self,other,"DIA_Andre_DGRunning_Verrat_08_01");	//Gdzie?
	AI_Output(other,self,"DIA_Andre_DGRunning_Verrat_15_02");	//Jest w kana�ach pod miastem.
	AI_Output(self,other,"DIA_Andre_DGRunning_Verrat_08_03");	//Co? Zamkn�li�my kana�y...
	AI_Output(other,self,"DIA_Andre_DGRunning_Verrat_15_04");	//Wygl�da jednak na to, �e to wcale nie ograniczy�o ich dost�pu do miasta.
	AI_Output(self,other,"DIA_Andre_DGRunning_Verrat_08_05");	//Odnalaz�e� przest�pc�w?
	DIEBESGILDE_VERRATEN = TRUE;
	DG_GEFUNDEN = TRUE;
};

func void dia_andre_dgrunning_success()
{
	AI_Output(other,self,"DIA_Andre_DGRunning_Success_15_00");	//Wytropi�em ich wszystkich!
	AI_Output(self,other,"DIA_Andre_DGRunning_Success_08_01");	//Wy�wiadczy�e� temu miastu wielk� przys�ug�.
	DG_GEFUNDEN = TRUE;
	MIS_ANDRE_GUILDOFTHIEVES = LOG_SUCCESS;
	b_giveplayerxp(XP_GUILDOFTHIEVESPLATT);
	if(MIS_CASSIAKELCHE == LOG_RUNNING)
	{
		MIS_CASSIAKELCHE = LOG_OBSOLETE;
	};
	if(other.guild == GIL_NONE)
	{
		AI_Output(self,other,"DIA_Andre_DGRunning_Success_08_02");	//Je�li nadal interesuje ci� stanowisko w stra�y, daj mi zna�.
	}
	else if((other.guild == GIL_MIL) || (other.guild == GIL_PAL))
	{
		AI_Output(self,other,"DIA_Andre_DGRunning_Success_08_03");	//Wype�ni�e� sw�j obowi�zek, jak przysta�o na s�ug� Innosa i �o�nierza Kr�la.
	};
	AI_Output(self,other,"DIA_Andre_DGRunning_Success_08_04");	//Nale�y ci si� nagroda za bandyt�w. Prosz�, we� to.
	b_giveinvitems(self,other,itmi_gold,KOPFGELD * 3);
	Info_ClearChoices(dia_andre_dgrunning);
};


instance DIA_ANDRE_JOIN(C_INFO)
{
	npc = mil_311_andre;
	nr = 100;
	condition = dia_andre_join_condition;
	information = dia_andre_join_info;
	permanent = TRUE;
	description = "Jestem got�w wst�pi� do stra�y!";
};


func int dia_andre_join_condition()
{
	if((hero.guild == GIL_NONE) && Npc_KnowsInfo(other,dia_andre_asktojoin))
	{
		return TRUE;
	};
};

func void dia_andre_join_info()
{
	AI_Output(other,self,"DIA_Andre_JOIN_15_00");	//Jestem got�w wst�pi� do stra�y!
	if(ANDRE_KNOWS_MARTINEMPFEHLUNG == TRUE)
	{
		AI_Output(self,other,"DIA_Addon_Andre_JOIN_08_00");	//Martin - nasz kwatermistrz - nie tylko za ciebie r�czy, ale i gor�co nam ci� poleca. To mnie przekonuje.
	}
	else if((MIS_ANDRE_GUILDOFTHIEVES == LOG_SUCCESS) && (PLAYER_ISAPPRENTICE == APP_NONE))
	{
		AI_Output(self,other,"DIA_Andre_JOIN_08_01");	//Dotrzymam swojej cz�ci umowy i przyjm� ci� do stra�y, chocia� nie jeste� obywatelem miasta.
		AI_Output(self,other,"DIA_Andre_JOIN_08_02");	//Ale nie rozpowiadaj o tym wszystkim naoko�o! Im mniej ludzi o tym wie, tym mniej b�d� si� musia� t�umaczy�.
	}
	else if(PLAYER_ISAPPRENTICE > APP_NONE)
	{
		AI_Output(self,other,"DIA_Andre_JOIN_08_03");	//A wi�c jeste� obywatelem Khorinis?
		if(PLAYER_ISAPPRENTICE == APP_HARAD)
		{
			AI_Output(other,self,"DIA_Andre_JOIN_15_04");	//Kowal przyj�� mnie na czeladnika.
			AI_Output(self,other,"DIA_Andre_JOIN_08_05");	//Harad? Znam go. Pracuje dla nas. To dobry cz�owiek.
		};
		if(PLAYER_ISAPPRENTICE == APP_CONSTANTINO)
		{
			AI_Output(other,self,"DIA_Andre_JOIN_15_06");	//Jestem uczniem alchemika!
			AI_Output(self,other,"DIA_Andre_JOIN_08_07");	//W�a�ciwie to nie mamy w stra�y zbyt wielu uczonych. By� mo�e twoje umiej�tno�ci bardzo nam si� przydadz�.
			AI_Output(self,other,"DIA_Andre_JOIN_08_08");	//Niewiele wiem o alchemiku. Ale ludzie m�wi�, �e to uczciwy cz�owiek.
		};
		if(PLAYER_ISAPPRENTICE == APP_BOSPER)
		{
			AI_Output(other,self,"DIA_Andre_JOIN_15_09");	//Bosper, �uczarz, przyj�� mnie na swego ucznia.
			AI_Output(self,other,"DIA_Andre_JOIN_08_10");	//A wi�c wiesz te� co nieco o �yciu w dziczy? To dobrze, bo stra� pe�ni s�u�b� nie tylko w obr�bie mur�w miasta.
			AI_Output(self,other,"DIA_Andre_JOIN_08_11");	//Przydadz� si� nam ludzie, kt�rzy potrafi� sobie poradzi� na pustkowiu.
			AI_Output(self,other,"DIA_Andre_JOIN_08_12");	//A �uczarz jest wa�n� osob� w mie�cie.
		};
		AI_Output(self,other,"DIA_Andre_JOIN_08_13");	//Je�li on za ciebie por�czy�, to nic nie stoi na przeszkodzie, �eby� wst�pi� w szeregi stra�y.
		if(MIS_ANDRE_GUILDOFTHIEVES == LOG_SUCCESS)
		{
			AI_Output(self,other,"DIA_Andre_JOIN_08_14");	//Ponadto, uwolni�e� nas od k�opot�w z gildi� z�odziei. Za samo to bym ci� przyj��.
		};
	}
	else
	{
		AI_Output(self,other,"DIA_Andre_JOIN_08_15");	//Mo�liwe - ale nie jeste� obywatelem miasta, a ja mam swoje rozkazy.
		return;
	};
	AI_Output(self,other,"DIA_Andre_JOIN_08_16");	//Je�li chcesz, mo�esz si� do nas zaci�gn��. Ale twoja decyzja b�dzie ostateczna.
	AI_Output(self,other,"DIA_Andre_JOIN_08_17");	//Kiedy za�o�ysz zbroj� stra�nika, nie b�dziesz m�g� tak po prostu jej zdj�� i porzuci� s�u�by.
	AI_Output(self,other,"DIA_Andre_JOIN_08_18");	//Czy jeste� got�w, by walczy� w naszych szeregach za Innosa i Kr�la?
	Info_ClearChoices(dia_andre_join);
	Info_AddChoice(dia_andre_join,"Nie jestem ca�kiem pewien...",dia_andre_join_no);
	Info_AddChoice(dia_andre_join,"Jestem gotowy!",dia_andre_join_yes);
};

func void dia_andre_join_yes()
{
	AI_Output(other,self,"DIA_Andre_JOIN_Yes_15_00");	//Jestem got�w!
	AI_Output(self,other,"DIA_Andre_JOIN_Yes_08_01");	//A wi�c niech tak b�dzie. Witaj w stra�y.
	Npc_SetTrueGuild(other,GIL_MIL);
	other.guild = GIL_MIL;
	Snd_Play("LEVELUP");
	Npc_ExchangeRoutine(lothar,"START");
	AI_Output(self,other,"DIA_Andre_JOIN_Yes_08_02");	//Oto twoja zbroja.
	b_giveinvitems(self,other,itar_mil_l,1);
	AI_Output(self,other,"DIA_Andre_JOIN_Yes_08_03");	//No� j� z dum� i godno�ci�.
	SLD_AUFNAHME = LOG_OBSOLETE;
	KDF_AUFNAHME = LOG_OBSOLETE;
	MIL_AUFNAHME = LOG_SUCCESS;
	b_giveplayerxp(XP_BECOMEMILIZ);
	Info_ClearChoices(dia_andre_join);
};

func void dia_andre_join_no()
{
	AI_Output(other,self,"DIA_Andre_JOIN_No_15_00");	//Nie jestem ca�kiem pewien...
	AI_Output(self,other,"DIA_Andre_JOIN_No_08_01");	//Dop�ki masz w�tpliwo�ci, nie mog� przyj�� ci� do stra�y.
	Info_ClearChoices(dia_andre_join);
};


instance DIA_ANDRE_LORDHAGEN(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_lordhagen_condition;
	information = dia_andre_lordhagen_info;
	permanent = FALSE;
	description = "Czy teraz mog� si� w ko�cu zobaczy� z Lordem Hagenem?";
};


func int dia_andre_lordhagen_condition()
{
	if((other.guild == GIL_MIL) && (KAPITEL < 3))
	{
		return TRUE;
	};
};

func void dia_andre_lordhagen_info()
{
	AI_Output(other,self,"DIA_Andre_LORDHAGEN_15_00");	//Czy teraz mog� si� w ko�cu zobaczy� z Lordem Hagenem?
	AI_Output(self,other,"DIA_Andre_LORDHAGEN_08_01");	//Jeste� teraz na s�u�bie paladyn�w. Pozwol� ci wej��. Ale lepiej, �eby� mia� co� wa�nego do powiedzenia.
	AI_Output(other,self,"DIA_Andre_LORDHAGEN_15_02");	//Nie martw si�, mam...
	AI_Output(self,other,"DIA_Andre_LORDHAGEN_08_03");	//Pami�taj, �e spotkasz si� paladynem najwy�szym rang�. Zachowuj si� odpowiednio. Reprezentujesz nie tylko siebie, ale te� ca�� stra�.
};


instance DIA_ANDRE_WAFFE(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_waffe_condition;
	information = dia_andre_waffe_info;
	permanent = FALSE;
	description = "Czy ja te� dostan� bro�?";
};


func int dia_andre_waffe_condition()
{
	if((other.guild == GIL_MIL) && (KAPITEL < 3))
	{
		return TRUE;
	};
};

func void dia_andre_waffe_info()
{
	AI_Output(other,self,"DIA_Andre_Waffe_15_00");	//Czy ja te� dostan� bro�?
	AI_Output(self,other,"DIA_Andre_Waffe_08_01");	//Oczywi�cie. Zazwyczaj zajmuje si� tym Peck. Ale w�a�nie skojarzy�em, �e od jakiego� czasu go nie widzia�em.
	AI_Output(self,other,"DIA_Andre_Waffe_08_02");	//Dowiedz si�, gdzie si� zaszy� i przyprowad� go do mnie. Wtedy da ci bro�.
	AI_Output(self,other,"DIA_Andre_Waffe_08_03");	//A je�li b�dziesz chcia� si� przespa�, skorzystaj z ��ka w sypialni.
	MIS_ANDRE_PECK = LOG_RUNNING;
	Log_CreateTopic(TOPIC_PECK,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_PECK,LOG_RUNNING);
	b_logentry(TOPIC_PECK,"Peck przebywa gdzie� w mie�cie. Je�li zabior� go z powrotem do koszar, dostan� od niego bro�.");
	AI_StopProcessInfos(self);
};


instance DIA_ANDRE_FOUND_PECK(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_found_peck_condition;
	information = dia_andre_found_peck_info;
	permanent = FALSE;
	description = "Uda�o mi si� znale�� Pecka.";
};


func int dia_andre_found_peck_condition()
{
	if(Npc_KnowsInfo(hero,dia_peck_found_peck) && (MIS_ANDRE_PECK == LOG_RUNNING) && (Npc_IsDead(peck) == FALSE))
	{
		return TRUE;
	};
};

func void dia_andre_found_peck_info()
{
	AI_Output(other,self,"DIA_Andre_FOUND_PECK_15_00");	//Uda�o mi si� znale�� Pecka.
	AI_Output(self,other,"DIA_Andre_FOUND_PECK_08_01");	//Tak, jest z powrotem na posterunku i robi, co do niego nale�y. Gdzie go znalaz�e�?
	Info_ClearChoices(dia_andre_found_peck);
	Info_AddChoice(dia_andre_found_peck,"Wszed� mi w drog�...",dia_andre_found_peck_somewhere);
	Info_AddChoice(dia_andre_found_peck,"W 'Czerwonej Latarni'...",dia_andre_found_peck_redlight);
};

func void dia_andre_found_peck_somewhere()
{
	AI_Output(other,self,"DIA_Andre_FOUND_PECK_SOMEWHERE_15_00");	//Wszed� mi w drog� na mie�cie.
	AI_Output(self,other,"DIA_Andre_FOUND_PECK_SOMEWHERE_08_01");	//W porz�dku, wi�c id� do niego i we� bro�.
	MIS_ANDRE_PECK = LOG_OBSOLETE;
	b_giveplayerxp(XP_FOUNDPECK);
	Info_ClearChoices(dia_andre_found_peck);
};

func void dia_andre_found_peck_redlight()
{
	AI_Output(other,self,"DIA_Andre_FOUND_PECK_REDLIGHT_15_00");	//By� w 'Czerwonej Latarni'.
	AI_Output(self,other,"DIA_Andre_FOUND_PECK_REDLIGHT_08_01");	//Prosz�... A wi�c kr�ci si� ko�o dziewczynek, zamiast pe�ni� s�u�b�.
	AI_Output(self,other,"DIA_Andre_FOUND_PECK_REDLIGHT_08_02");	//Wydaje mi si�, �e musz� z nim zamieni� s��wko.
	b_giveplayerxp(XP_FOUNDPECK * 2);
	MIS_ANDRE_PECK = LOG_SUCCESS;
	Info_ClearChoices(dia_andre_found_peck);
};

func void b_andresold()
{
	AI_Output(self,other,"DIA_Andre_Sold_08_00");	//Oto twoja zap�ata.
	b_giveinvitems(self,other,itmi_gold,ANDRE_SOLD);
};


instance DIA_ANDRE_FIRSTMISSION(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_firstmission_condition;
	information = dia_andre_firstmission_info;
	permanent = FALSE;
	description = "Masz dla mnie jakie� zadanie?";
};


func int dia_andre_firstmission_condition()
{
	if(other.guild == GIL_MIL)
	{
		return TRUE;
	};
};

func void dia_andre_firstmission_info()
{
	AI_Output(other,self,"DIA_Andre_FIRSTMISSION_15_00");	//Masz dla mnie jakie� zadanie?
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_01");	//Ostatnio w mie�cie wzros�a sprzeda� bagiennego ziela.
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_02");	//Nie mo�emy pozwoli�, �eby to paskudztwo sta�o si� �atwo dost�pne.
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_03");	//Bo inaczej wszyscy zaczn� popala� i nikt nie b�dzie w stanie pracowa�, nie m�wi�c ju� o noszeniu broni.
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_04");	//Szczeg�lnie teraz, kiedy istnieje zagro�enie ze strony ork�w albo najemnik�w.
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_05");	//Podejrzewam, �e stoj� za tym najemnicy. Za�o�� si�, �e to oni przemycaj� towar do miasta.
	AI_Output(other,self,"DIA_Andre_FIRSTMISSION_15_06");	//Co trzeba zrobi�?
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_07");	//Mortis, jeden z naszych ludzi, s�ysza� w tawernie, �e w dzielnicy portowej pojawi� si� transport bagiennego ziela.
	AI_Output(self,other,"DIA_Andre_FIRSTMISSION_08_08");	//Rozejrzyj si� tam i przynie� mi paczk� z zielskiem.
	MIS_ANDRE_WAREHOUSE = LOG_RUNNING;
	Log_CreateTopic(TOPIC_WAREHOUSE,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_WAREHOUSE,LOG_RUNNING);
	b_logentry(TOPIC_WAREHOUSE,"W porcie pojawi�a si� paczka bagiennego ziela. Mortis natkn�� si� na ni� w tamtejszej knajpie. Musz� znale�� t� paczk� i zanie�� j� Lordowi Andre.");
};


instance DIA_ANDRE_FOUND_STUFF(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_found_stuff_condition;
	information = dia_andre_found_stuff_info;
	permanent = TRUE;
	description = "Co do tej paczki...";
};


func int dia_andre_found_stuff_condition()
{
	if(MIS_ANDRE_WAREHOUSE == LOG_RUNNING)
	{
		return TRUE;
	};
};

func void dia_andre_found_stuff_info()
{
	AI_Output(other,self,"DIA_Andre_FOUND_STUFF_15_00");	//Co do tej paczki...
	AI_Output(self,other,"DIA_Andre_FOUND_STUFF_08_01");	//Znalaz�e� j�?
	if((Npc_HasItems(other,itmi_herbpaket) > 0) || (MIS_CIPHER_PAKET == LOG_SUCCESS))
	{
		Info_ClearChoices(dia_andre_found_stuff);
		if(Npc_HasItems(other,itmi_herbpaket) > 0)
		{
			Info_AddChoice(dia_andre_found_stuff,"Tak, oto ona.",dia_andre_found_stuff_ja);
		};
		Info_AddChoice(dia_andre_found_stuff,"Wrzuci�em j� do basenu portowego.",dia_andre_found_stuff_becken);
	}
	else
	{
		AI_Output(other,self,"DIA_Andre_FOUND_STUFF_15_02");	//Jeszcze nie...
	};
};

func void dia_andre_found_stuff_ja()
{
	AI_Output(other,self,"DIA_Andre_FOUND_STUFF_Ja_15_00");	//Tak, oto ona.
	b_giveinvitems(other,self,itmi_herbpaket,1);
	AI_Output(self,other,"DIA_Andre_FOUND_STUFF_Ja_08_01");	//Dobra robota. B�dziemy dobrze pilnowa� tego zielska.
	b_andresold();
	MIS_ANDRE_WAREHOUSE = LOG_SUCCESS;
	MIS_CIPHER_PAKET = LOG_FAILED;
	b_giveplayerxp(XP_WAREHOUSE_SUPER * 2);
	Info_ClearChoices(dia_andre_found_stuff);
};

func void dia_andre_found_stuff_becken()
{
	AI_Output(other,self,"DIA_Andre_FOUND_STUFF_Becken_15_00");	//Wrzuci�em j� do basenu portowego.
	AI_Output(self,other,"DIA_Andre_FOUND_STUFF_Becken_08_01");	//Tak? C�, g��wnie chodzi�o o to, �eby nie wpad�a w niepowo�ane r�ce.
	b_andresold();
	MIS_ANDRE_WAREHOUSE = LOG_SUCCESS;
	b_giveplayerxp(XP_WAREHOUSE_SUPER);
	Info_ClearChoices(dia_andre_found_stuff);
};


instance DIA_ANDRE_FIND_DEALER(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_find_dealer_condition;
	information = dia_andre_find_dealer_info;
	permanent = FALSE;
	description = "Masz dla mnie inne zadanie?";
};


func int dia_andre_find_dealer_condition()
{
	if((MIS_ANDRE_WAREHOUSE == LOG_SUCCESS) && (Npc_IsDead(borka) == FALSE))
	{
		return TRUE;
	};
};

func void dia_andre_find_dealer_info()
{
	AI_Output(other,self,"DIA_Andre_FIND_DEALER_15_00");	//Masz dla mnie inne zadanie?
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_01");	//Wy��czy�e� transport bagiennego ziela z obiegu - to dobrze.
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_02");	//Ale wola�bym wiedzie�, kto rozprowadza to paskudztwo mi�dzy lud�mi.
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_03");	//To musi by� kto� z dzielnicy portowej.
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_04");	//Gdyby handlarz regularnie przyje�d�a� spoza miasta, ju� dawno by�my go z�apali.
	AI_Output(other,self,"DIA_Andre_FIND_DEALER_15_05");	//Co w�a�ciwie mam zrobi�?
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_06");	//Znajd� sprzedawc� i kup od niego troch� tego ziela. To nie b�dzie �atwe, ale bez tego nie mo�emy go aresztowa�.
	AI_Output(self,other,"DIA_Andre_FIND_DEALER_08_07");	//Pogadaj z Mortisem, on zna dzielnic� portow�. Mo�e b�dzie ci w stanie pom�c.
	MIS_ANDRE_REDLIGHT = LOG_RUNNING;
	b_startotherroutine(nadja,"SMOKE");
	Log_CreateTopic(TOPIC_REDLIGHT,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_REDLIGHT,LOG_RUNNING);
	b_logentry(TOPIC_REDLIGHT,"Musz� znale�� cz�owieka, kt�ry sprzedaje w porcie bagienne ziele, i kupi� od niego troch� towaru. Mortis mo�e mi w tym pom�c.");
};


instance DIA_ANDRE_REDLIGHT_SUCCESS(C_INFO)
{
	npc = mil_311_andre;
	nr = 2;
	condition = dia_andre_redlight_success_condition;
	information = dia_andre_redlight_success_info;
	permanent = TRUE;
	description = "Co do tego ziela...";
};


func int dia_andre_redlight_success_condition()
{
	if(MIS_ANDRE_REDLIGHT == LOG_RUNNING)
	{
		return TRUE;
	};
};

func void dia_andre_redlight_success_info()
{
	AI_Output(other,self,"DIA_Andre_REDLIGHT_SUCCESS_15_00");	//Co do tego ziela...
	if((Npc_IsDead(borka) == TRUE) || (UNDERCOVER_FAILED == TRUE))
	{
		AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_01");	//W�tpi�, �eby�my teraz dowiedzieli si� czego� w dzielnicy portowej.
		if(Npc_IsDead(borka) == TRUE)
		{
			AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_02");	//Skoro ten wykidaj�o nie �yje...
		};
		if(NADJA_VICTIM == TRUE)
		{
			AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_03");	//Ta dziewczyna z 'Czerwonej Latarni', Nadia, nie �yje. To by� pewnie jaki� dziwaczny wypadek.
			b_removenpc(nadja);
		};
		if(UNDERCOVER_FAILED == TRUE)
		{
			AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_04");	//By�e� za ma�o dyskretny.
		};
		MIS_ANDRE_REDLIGHT = LOG_FAILED;
		b_checklog();
	}
	else if(BORKA_DEAL == 2)
	{
		AI_Output(other,self,"DIA_Andre_REDLIGHT_SUCCESS_15_05");	//Wiem, kto sprzedaje ziele w mie�cie. To Borka, od�wierny z 'Czerwonej Latarni'.
		AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_06");	//Naprawd�? A mamy jaki� dow�d?
		AI_Output(other,self,"DIA_Andre_REDLIGHT_SUCCESS_15_07");	//Sprzeda� mi troch� bagiennego ziela.
		AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_08");	//Dobrze, to nam wystarczy. Zaraz ka�� go aresztowa�.
		b_startotherroutine(borka,"PRISON");
		MIS_ANDRE_REDLIGHT = LOG_SUCCESS;
		b_giveplayerxp(XP_REDLIGHT);
		b_andresold();
	}
	else
	{
		AI_Output(other,self,"DIA_Andre_REDLIGHT_SUCCESS_15_09");	//...ci�gle nad tym pracuj�.
		AI_Output(self,other,"DIA_Andre_REDLIGHT_SUCCESS_08_10");	//Dobrze, pami�taj, �e musisz go nam�wi�, aby ubi� z tob� interes.
	};
};


instance DIA_ANDRE_HILFBAUERLOBART(C_INFO)
{
	npc = mil_311_andre;
	nr = 3;
	condition = dia_andre_hilfbauerlobart_condition;
	information = dia_andre_hilfbauerlobart_info;
	description = "Masz dla mnie jakie� nowe zadanie?";
};


func int dia_andre_hilfbauerlobart_condition()
{
	if(MIS_ANDRE_WAREHOUSE == LOG_SUCCESS)
	{
		return TRUE;
	};
};

func void dia_andre_hilfbauerlobart_info()
{
	AI_Output(other,self,"DIA_Andre_HILFBAUERLOBART_15_00");	//Masz dla mnie jakie� nowe zadanie?
	AI_Output(self,other,"DIA_Andre_HILFBAUERLOBART_08_01");	//Lobart, hodowca rzepy, ma pewne k�opoty.
	AI_Output(self,other,"DIA_Andre_HILFBAUERLOBART_08_02");	//Je�li mu pomo�emy, poprawi� si� jego stosunki z miastem. Id� wi�c do niego i dowiedz si�, co mu przeszkadza.
	Log_CreateTopic(TOPIC_FELDRAEUBER,LOG_MISSION);
	Log_SetTopicStatus(TOPIC_FELDRAEUBER,LOG_RUNNING);
	b_logentry(TOPIC_FELDRAEUBER,"Andre wys�a� mnie na farm� Lobarta i nakaza� mu pom�c.");
	MIS_ANDREHELPLOBART = LOG_RUNNING;
	Wld_InsertNpc(lobarts_giant_bug1,"NW_FARM1_FIELD_06");
	Wld_InsertNpc(lobarts_giant_bug2,"NW_FARM1_FIELD_06");
	Wld_InsertNpc(lobarts_giant_bug3,"NW_FARM1_FIELD_05");
	Wld_InsertNpc(lobarts_giant_bug4,"NW_FARM1_FIELD_05");
	Wld_InsertNpc(lobarts_giant_bug5,"NW_FARM1_FIELD_04");
	Wld_InsertNpc(lobarts_giant_bug6,"NW_FARM1_FIELD_04");
	Wld_InsertNpc(lobarts_giant_bug7,"NW_FARM1_FIELD_03");
	b_startotherroutine(vino,"BUGSTHERE");
	b_startotherroutine(lobartsbauer1,"BUGSTHERE");
	b_startotherroutine(lobartsbauer2,"BUGSTHERE");
	AI_StopProcessInfos(self);
};


instance DIA_ANDRE_LOBART_SUCCESS(C_INFO)
{
	npc = mil_311_andre;
	condition = dia_andre_lobart_success_condition;
	information = dia_andre_lobart_success_info;
	description = "Pomog�em Lobartowi.";
};


func int dia_andre_lobart_success_condition()
{
	if(MIS_ANDREHELPLOBART == LOG_SUCCESS)
	{
		return TRUE;
	};
};

func void dia_andre_lobart_success_info()
{
	AI_Output(other,self,"DIA_Andre_LOBART_SUCCESS_15_00");	//Pomog�em Lobartowi.
	AI_Output(self,other,"DIA_Andre_LOBART_SUCCESS_08_01");	//Doskonale. Skoro Lobart jest zadowolony, to b�dzie nadal sprzedawa� swoje rzepy w mie�cie.
	b_giveplayerxp(XP_LOBARTBUGS);
	b_andresold();
};


instance DIA_ADDON_ANDRE_MISSINGPEOPLE(C_INFO)
{
	npc = mil_311_andre;
	nr = 5;
	condition = dia_addon_andre_missingpeople_condition;
	information = dia_addon_andre_missingpeople_info;
	description = "Co z tymi zaginionymi?";
};


func int dia_addon_andre_missingpeople_condition()
{
	if((MIS_ADDON_VATRAS_WHEREAREMISSINGPEOPLE == LOG_RUNNING) && (other.guild == GIL_MIL))
	{
		return TRUE;
	};
};

func void dia_addon_andre_missingpeople_info()
{
	AI_Output(other,self,"DIA_Addon_Andre_MissingPeople_15_00");	//Co z tymi zaginionymi?
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople_08_01");	//Nie rozumiem. Co z nimi?
	AI_Output(other,self,"DIA_Addon_Andre_MissingPeople_15_02");	//Nie powinni�my spr�bowa� ich znale��?
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople_08_03");	//Lord Hagen nakaza� mi ochron� miasta i otaczaj�cych je teren�w.
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople_08_04");	//To oznacza, �e mamy chroni� ludzi, kt�rzy nadal tu s�.
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople_08_05");	//Wzmocni�em nocne patrole. Nic wi�cej nie mog� zrobi�.
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople_08_06");	//A ty lepiej martw si� zadaniami, kt�re ci zlecam - zrozumiano?
	MIS_ADDON_ANDRE_MISSINGPEOPLE = LOG_RUNNING;
};


instance DIA_ADDON_ANDRE_MISSINGPEOPLE2(C_INFO)
{
	npc = mil_311_andre;
	nr = 5;
	condition = dia_addon_andre_missingpeople2_condition;
	information = dia_addon_andre_missingpeople2_info;
	description = "Co do tych zaginionych...";
};


func int dia_addon_andre_missingpeople2_condition()
{
	if((MIS_ADDON_VATRAS_WHEREAREMISSINGPEOPLE == LOG_RUNNING) && (other.guild != GIL_MIL) && (SCKNOWSMISSINGPEOPLEAREINADDONWORLD == FALSE))
	{
		return TRUE;
	};
};

func void dia_addon_andre_missingpeople2_info()
{
	AI_Output(other,self,"DIA_Addon_Andre_MissingPeople2_15_00");	//Co do tych zaginionych...
	AI_Output(self,other,"DIA_Addon_Andre_MissingPeople2_08_01");	//Odpu�� sobie wreszcie t� spraw�! Mam inne rzeczy na g�owie!
	MIS_ADDON_ANDRE_MISSINGPEOPLE = LOG_RUNNING;
};


instance DIA_ADDON_ANDRE_RETURNEDMISSINGPEOPLE(C_INFO)
{
	npc = mil_311_andre;
	nr = 5;
	condition = dia_addon_andre_returnedmissingpeople_condition;
	information = dia_addon_andre_returnedmissingpeople_info;
	description = "Uda�o mi si� uratowa� kilkoro z zaginionych.";
};


func int dia_addon_andre_returnedmissingpeople_condition()
{
	if((MISSINGPEOPLERETURNEDHOME == TRUE) && (MIS_ADDON_ANDRE_MISSINGPEOPLE == LOG_RUNNING))
	{
		return TRUE;
	};
};

func void dia_addon_andre_returnedmissingpeople_info()
{
	AI_Output(other,self,"DIA_Addon_Andre_ReturnedMissingPeople_15_00");	//Uda�o mi si� uratowa� kilkoro z zaginionych.
	if(other.guild == GIL_MIL)
	{
		AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_01");	//A w�a�nie si� zastanawia�em, gdzie si� tak d�ugo podziewa�e�.
		AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_02");	//Pami�taj, �e jeste� cz�onkiem stra�y! Nie wydano ci rozkazu do podj�cia takich dzia�a�!
		AI_Output(other,self,"DIA_Addon_Andre_ReturnedMissingPeople_15_03");	//Ale...
	};
	AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_04");	//Ilu uda�o ci si� odnale��?
	AI_Output(other,self,"DIA_Addon_Andre_ReturnedMissingPeople_15_05");	//Wszystkich, kt�rzy nadal �yli.
	AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_06");	//Wszystkich? Ja... Eee...
	if(other.guild == GIL_MIL)
	{
		AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_07");	//Jestem z ciebie dumny! Ciesz� si�, �e przyj�li�my ci� w nasze szeregi.
		b_andresold();
	};
	AI_Output(self,other,"DIA_Addon_Andre_ReturnedMissingPeople_08_08");	//To wspania�e osi�gni�cie.
	MIS_ADDON_ANDRE_MISSINGPEOPLE = LOG_SUCCESS;
	b_giveplayerxp(XP_ADDON_ANDRE_MISSINGPEOPLE);
};

func void b_andre_gotolordhagen()
{
	AI_Output(self,other,"DIA_Andre_Add_08_11");	//Lepiej id� prosto do niego.
};


instance DIA_ANDRE_BERICHTDRACHEN(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_berichtdrachen_condition;
	information = dia_andre_berichtdrachen_info;
	permanent = FALSE;
	description = "By�em w G�rniczej Dolinie i widzia�em smoki!";
};


func int dia_andre_berichtdrachen_condition()
{
	if((ENTEROW_KAPITEL2 == TRUE) && (MIS_OLDWORLD != LOG_SUCCESS))
	{
		return TRUE;
	};
};

func void dia_andre_berichtdrachen_info()
{
	AI_Output(other,self,"DIA_Andre_Add_15_13");	//By�em w G�rniczej Dolinie i widzia�em smoki!
	if(Npc_HasItems(hero,itwr_paladinletter_mis) > 0)
	{
		AI_Output(other,self,"DIA_Andre_Add_15_14");	//Mam list od kapitana Garonda, kt�ry potwierdza to, co m�wi�em.
	};
	AI_Output(self,other,"DIA_Andre_Add_08_10");	//To zainteresuje Lorda Hagena!
	b_andre_gotolordhagen();
};


instance DIA_ANDRE_BENNETINPRISON(C_INFO)
{
	npc = mil_311_andre;
	condition = dia_andre_bennetinprison_condition;
	information = dia_andre_bennetinprison_info;
	permanent = TRUE;
	description = "Co si� dzieje z kowalem Bennetem?";
};


func int dia_andre_bennetinprison_condition()
{
	if(MIS_RESCUEBENNET == LOG_RUNNING)
	{
		return TRUE;
	};
};

func void dia_andre_bennetinprison_info()
{
	AI_Output(other,self,"DIA_Andre_BennetInPrison_15_00");	//A co z kowalem Bennetem?
	AI_Output(self,other,"DIA_Andre_BennetInPrison_08_01");	//Z tym najemnikiem? Siedzi w wi�zieniu, tam gdzie jego miejsce.
	AI_Output(other,self,"DIA_Andre_BennetInPrison_Talk_15_00");	//Mog� z nim porozmawia�?
	AI_Output(self,other,"DIA_Andre_BennetInPrison_Talk_08_01");	//Jasne, id�. Ale je�li pomo�esz mu uciec, zajmiesz jego miejsce.
};


instance DIA_ANDRE_CORNELIUS_LIAR(C_INFO)
{
	npc = mil_311_andre;
	condition = dia_andre_cornelius_liar_condition;
	information = dia_andre_cornelius_liar_info;
	permanent = TRUE;
	description = "My�l�, �e Cornelius k�amie.";
};


func int dia_andre_cornelius_liar_condition()
{
	if((CORNELIUS_THREATENBYMILSC == TRUE) && (CORNELIUSFLEE != TRUE))
	{
		return TRUE;
	};
};

func void dia_andre_cornelius_liar_info()
{
	AI_Output(other,self,"DIA_Andre_Cornelius_Liar_15_00");	//My�l�, �e Cornelius k�amie.
	AI_Output(self,other,"DIA_Andre_Cornelius_Liar_08_01");	//Jeste� pewien?
	Info_ClearChoices(dia_andre_cornelius_liar);
	Info_AddChoice(dia_andre_cornelius_liar,"Nie.",dia_andre_cornelius_liar_no);
	Info_AddChoice(dia_andre_cornelius_liar,"Tak.",dia_andre_cornelius_liar_yes);
};

func void dia_andre_cornelius_liar_no()
{
	AI_Output(other,self,"DIA_Andre_Cornelius_Liar_No_15_00");	//Nie.
	AI_Output(self,other,"DIA_Andre_Cornelius_Liar_No_08_01");	//Wi�c nie powiniene� wyst�powa� z tak powa�nym oskar�eniem.
	AI_Output(self,other,"DIA_Andre_Cornelius_Liar_No_08_02");	//Cornelius to wp�ywowy cz�owiek. Je�li b�dzie chcia�, zamieni twoje �ycie w piek�o.
	AI_Output(self,other,"DIA_Andre_Cornelius_Liar_No_08_03");	//Nie mog� ci pom�c, dop�ki nie b�dziesz mia� dowod�w.
	Info_ClearChoices(dia_andre_cornelius_liar);
};

func void dia_andre_cornelius_liar_yes()
{
	AI_Output(other,self,"DIA_Andre_Cornelius_Liar_Yes_15_00");	//Tak.
	AI_Output(self,other,"DIA_Andre_Cornelius_Liar_Yes_08_01");	//Jaki masz na to dow�d?
	if(CORNELIUS_ISLIAR == TRUE)
	{
		AI_Output(other,self,"DIA_Andre_Cornelius_Liar_Yes_15_02");	//Czyta�em jego dziennik! Przekupili go. To wszystko by� stek k�amstw.
		AI_Output(self,other,"DIA_Andre_Cornelius_Liar_Yes_08_03");	//Skoro tak, musisz natychmiast i�� do Lorda Hagena.
		AI_Output(self,other,"DIA_Andre_Cornelius_Liar_Yes_08_04");	//Poka� mu ten dziennik. On si� zajmie reszt�.
	}
	else
	{
		AI_Output(other,self,"DIA_Andre_Cornelius_Liar_Yes_15_05");	//Ekhm, c�, my�l�...
		AI_Output(self,other,"DIA_Andre_Cornelius_Liar_Yes_08_06");	//Potrzebne mi dowody, a nie podejrzenia. Zdob�d� dow�d, wtedy b�d� m�g� co� zrobi�.
		AI_Output(self,other,"DIA_Andre_Cornelius_Liar_Yes_08_07");	//A do tego czasu powiniene� bardziej uwa�a� na to, co m�wisz.
	};
	Info_ClearChoices(dia_andre_cornelius_liar);
};


instance DIA_ANDRE_PALADIN(C_INFO)
{
	npc = mil_311_andre;
	condition = dia_andre_paladin_condition;
	information = dia_andre_paladin_info;
	permanent = FALSE;
	important = TRUE;
};


func int dia_andre_paladin_condition()
{
	if(other.guild == GIL_PAL)
	{
		return TRUE;
	};
};

func void dia_andre_paladin_info()
{
	AI_Output(self,other,"DIA_Andre_Paladin_08_00");	//A wi�c teraz jeste� paladynem! Moje gratulacje!
	AI_Output(self,other,"DIA_Andre_Paladin_08_01");	//Od pocz�tku wiedzia�em, �e nie zagrzejesz d�ugo miejsca w stra�y.
};


instance DIA_ANDRE_PERM(C_INFO)
{
	npc = mil_311_andre;
	nr = 100;
	condition = dia_andre_perm_condition;
	information = dia_andre_perm_info;
	permanent = TRUE;
	description = "Jak wygl�da sytuacja w mie�cie?";
};


func int dia_andre_perm_condition()
{
	if(other.guild != GIL_NONE)
	{
		return TRUE;
	};
};

func void dia_andre_perm_info()
{
	AI_Output(other,self,"DIA_Andre_PERM_15_00");	//Jak wygl�da sytuacja w mie�cie?
	AI_Output(self,other,"DIA_Andre_PERM_08_01");	//Wszystko jest pod kontrol�.
	if(other.guild == GIL_MIL)
	{
		AI_Output(self,other,"DIA_Andre_PERM_08_02");	//Kontynuuj swoje zadanie.
	};
	if(other.guild == GIL_PAL)
	{
		AI_Output(self,other,"DIA_Andre_PERM_08_03");	//Od tej pory meldujesz si� bezpo�rednio Lordowi Hagenowi. Id� do niego.
	};
};


instance DIA_ANDRE_BERICHTDRACHENTOT(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_berichtdrachentot_condition;
	information = dia_andre_berichtdrachentot_info;
	permanent = FALSE;
	description = "Zabi�em wszystkie smoki w G�rniczej Dolinie!";
};


func int dia_andre_berichtdrachentot_condition()
{
	if(KAPITEL == 5)
	{
		return TRUE;
	};
};

func void dia_andre_berichtdrachentot_info()
{
	AI_Output(other,self,"DIA_Andre_Add_15_15");	//Zabi�em wszystkie smoki w G�rniczej Dolinie!
	AI_Output(self,other,"DIA_Andre_Add_08_08");	//Je�li to prawda, musisz o tym opowiedzie� Lordowi Hagenowi.
	b_andre_gotolordhagen();
};


instance DIA_ANDRE_BERICHTTORAUF(C_INFO)
{
	npc = mil_311_andre;
	nr = 1;
	condition = dia_andre_berichttorauf_condition;
	information = dia_andre_berichttorauf_info;
	permanent = FALSE;
	description = "Zamek w G�rniczej Dolinie zosta� zaatakowany przez ork�w!";
};


func int dia_andre_berichttorauf_condition()
{
	if((KAPITEL == 5) && (MIS_OCGATEOPEN == TRUE) && Npc_KnowsInfo(other,dia_andre_berichtdrachentot))
	{
		return TRUE;
	};
};

func void dia_andre_berichttorauf_info()
{
	AI_Output(other,self,"DIA_Andre_Add_15_16");	//Zamek w G�rniczej Dolinie zosta� zaatakowany przez ork�w!
	AI_Output(self,other,"DIA_Andre_Add_08_09");	//Nie! Lord Hagen musi o tym us�ysze�.
	b_andre_gotolordhagen();
};
