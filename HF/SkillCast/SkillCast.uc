/******************************************
Дата 09.04.2024 18:21

  Разработчик: BITHACK 

  Copyright (c) Ваша компания

 Описание скрипта: Вывод иконки откат скилла под окном таргета с прогресс баром.

*******************************************/    

class SkillCast extends UICommonAPI;

// Структура для представления цвета HSV
struct HSVColor {var float H, S, V, A;};

const TIMER_SKILL_ID = 15512;
const TIMER_SKILL_TIME = 500;

const COLOR_NAME = "_BLACK,_BLUE,_BROWN,_CYAN,_GREEN,_ORANGE,_PINK,_PURPLE,_RED,_YELLOW"; //const с ID цветами окончание имени скилла в utx, пример : "InkedSkills.Skill0001_BLACK"

 var array<string> ColorNameSkill;

 var WindowHandle Me;
 var ProgressCtrlHandle progressCast;
 var TextBoxHandle skillName;
 var TextureHandle skillTex;
 var TextureHandle detectColor;

function OnRegisterEvent() {
	RegisterEvent(EV_ReceiveMagicSkillUse);
	RegisterEvent(EV_GamingStateEnter);
	}

function OnLoad() {

	Me = GetWindowHandle("SkillCast");
	progressCast = GetProgressCtrlHandle("SkillCast.progressCast");
	skillName = GetTextBoxHandle("SkillCast.skillName");
	skillTex = GetTextureHandle("SkillCast.skillTex");
	detectColor = GetTextureHandle("SkillCast.detectColor");

      //Заполним Массив с ID разрешенных цветов"
	Split(COLOR_NAME, "," ,ColorNameSkill);
	}

function OnEvent(int a_EventID, string a_Param) {
 switch (a_EventID) {
	case EV_ReceiveMagicSkillUse:
	HandleReceiveMagicSkillUse(a_Param);
 break;
	case EV_GamingStateEnter:
	Me.HideWindow();
 break;
	default:
 break;
	}
	}

function OnTimer(int TimerID) {
 if (TimerID == TIMER_SKILL_ID) {
	Me.KillTimer(TIMER_SKILL_ID);
	Me.HideWindow();
	}
	}

function HandleReceiveMagicSkillUse(string a_Param) {
 local int AttackerID;
 local int DefenderID;
 local int SkillID;
 local int SkillLevel;
 local float SkillHitTime;
 local UserInfo PlayerInfo;
 local UserInfo AttackerInfo;
 local UserInfo DefenderInfo;
 local UserInfo TargetInfo;
 local SkillInfo UsedSkillInfo;
 local int SkillHitTime_ms;

	ParseInt(a_Param, "AttackerID", AttackerID);
	ParseInt(a_Param, "DefenderID", DefenderID);
	ParseInt(a_Param, "SkillID", SkillID);
	ParseInt(a_Param, "SkillLevel", SkillLevel);
	ParseFloat(a_Param, "SkillHitTime", SkillHitTime);

 if (SkillHitTime > 0) {
	SkillHitTime_ms = int(SkillHitTime * 1000) + 300;
	} else {
	SkillHitTime_ms = 100;
	}

	GetUserInfo(AttackerID, AttackerInfo);
	GetUserInfo(DefenderID, DefenderInfo);
	GetPlayerInfo(PlayerInfo);
	GetTargetInfo(TargetInfo);
	GetSkillInfo(SkillID, SkillLevel, UsedSkillInfo);

 if (!IsNotDisplaySkill(SkillID) && (TargetInfo.nID == AttackerID)) {
	SetCastInfo(AttackerInfo, UsedSkillInfo, SkillHitTime_ms);
	}
	}

// Функция установки информации о скилле
function SetCastInfo(UserInfo DefenderInfo, SkillInfo CastInfo, int SkillHitTime_ms) {
 local array<String> arrNameSkill,arrNameSkillColor; // Локальные массивы для хранения имени скилла и цвета
 local int i; // Локальная переменная для использования в цикле

	detectColor.HideWindow(); // Скрыть окно цветового сигнала
	Me.KillTimer(TIMER_SKILL_ID); // Остановить таймер по идентификатору навыка

 if (CastInfo.IconType <= 2 ){ // Если тип иконки скилла меньше или равен 2 (0-скиллы мобов, 1-маг, 2-воин)

	Split(CastInfo.TexName, "." ,arrNameSkill); // Разделить имя текстуры скилла по символу "."

	skillName.SetText(CastInfo.SkillName); // Установить текст имени скилла

 for ( i = 0; i < ColorNameSkill.length; i++) { // Цикл по цветам для скилла
	skillTex.SetTexture("InkedSkills."$arrNameSkill[1]$ColorNameSkill[i]); // Установить текстуру для скилла используя имя скилла и цвет
 if (skillTex.GetTextureName() != "BlackTexture") // Если текстура не равна "BlackTexture"
 break; // Прервать цикл
	}

	detectColor.SetTexture(skillTex.GetTextureName()); // Текстуру для цветового сигнала

	Split(skillTex.GetTextureName(), "_" ,arrNameSkillColor); // Разделить имя текстуры для получения цвета

	SetProgressTexture(Caps(arrNameSkillColor[1])); // Установить текстуру прогресса скилла с указанием цвета

	progressCast.SetProgressTime(SkillHitTime_ms); // Установить время прогресса скилла
	progressCast.SetPos(SkillHitTime_ms); // Установить позицию прогресса
	progressCast.Reset(); // Сбросить прогресс
	progressCast.Start(); // Начать прогресс

	SkillSize(); // Изменить размер скилл окна
	Me.SetAnchor("TargetStatusWnd", "BottomLeft", "BottomLeft", 0, 40); // Установить привязку окна к конкретной позиции
	Me.ShowWindow(); // Показать окно
	}
	}

//!Функция Изменить размер скилл окна по ширине окна TargetStatusWnd
function SkillSize(){
 local int w,h;
	GetWindowHandle("TargetStatusWnd").GetWindowSize(w,h);
	Me.SetWindowSize(w,36);
	}

//Вывод прогресс бара с выброным цветом текстуры
function SetProgressTexture(string ColorIcon) {
 local string UTXPath;

	UTXPath = "MercTex.ProgressBar.progress_";

 switch (ColorIcon) {
	case "BLACK":
	case "WHITE":
	case "GRAY":
	progressCast.SetBackTex(UTXPath $ "White_mid" $ "_bg", UTXPath $ "White_mid" $ "_bg", UTXPath $ "White_mid" $ "_bg");
	progressCast.SetBarTex(UTXPath $ "White_mid" $ "", UTXPath $ "White_mid" $ "", UTXPath $ "White_mid" $ "");
 break;
	case "RED":
	case "ORANGE":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
 break;
	case "PINK":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
 break;
	case "BROWN":
	progressCast.SetBackTex(UTXPath $ "Orange_mid" $ "_bg", UTXPath $ "Orange_mid" $ "_bg", UTXPath $ "Orange_mid" $ "_bg");
	progressCast.SetBarTex(UTXPath $ "Orange_mid" $ "", UTXPath $ "Orange_mid" $ "", UTXPath $ "Orange_mid" $ "");
 break;
	case "YELLOW":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
      // sysDebug("ColorIcon" @ ColorIcon @ "add Yellow");
 break;
	case "GREEN":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
      // sysDebug("ColorIcon" @ ColorIcon @ "add Green");
 break;
	case "CYAN":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
 break;
	case "BLUE":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
 break;
	case "PURPLE":
	progressCast.SetBackTex(UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg", UTXPath $ ColorIcon $ "_mid_bg");
	progressCast.SetBarTex(UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid", UTXPath $ ColorIcon $ "_mid");
 break;
	default:
	progressCast.SetBackTex(UTXPath $ "White_mid" $ "_bg", UTXPath $ "White_mid" $ "_bg", UTXPath $ "White_mid" $ "_bg");
	progressCast.SetBarTex(UTXPath $ "White_mid" $ "", UTXPath $ "White_mid" $ "", UTXPath $ "White_mid" $ "");
	skillTex.SetTexture("icon.skill0000");
 break;
	}
	}

function OnProgressTimeUp(string strID) {
 switch (strID) {
	case "progressCast":
	Me.KillTimer(TIMER_SKILL_ID);
	Me.SetTimer(TIMER_SKILL_ID, TIMER_SKILL_TIME);
 break;
	}
	}

	defaultproperties {}
