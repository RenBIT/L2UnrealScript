/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта: Панелька с талисманами + доп настройки в BIT_ShortcutWnd.uc

 *******************************************/

class BIT_DopPanelTalismanWnd extends UICommonAPI;
  const MAX_SLOT = 6;
  var WindowHandle BIT_DopPanelTalismanWnd;
  var ItemWindowHandle BIT_DopPanelTalismanWnd_Item;
  var ItemInfo EmptyItemInfo;
  var ItemWindowHandle MagiSkillItem;

function OnLoad() { /* Выполняется при старте игры */
  local int i;
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_Restart);
	RegisterEvent(EV_OpenDialogQuit);
	MagiSkillItem = GetItemWindowHandle( "MagicSkillWnd.ASkill.ASkillScroll.ASkill5.ASkillItem5" );

	BIT_DopPanelTalismanWnd = GetWindowHandle( "BIT_DopPanelTalismanWnd" );//WindowHandle
	BIT_DopPanelTalismanWnd_Item = GetItemWindowHandle( "BIT_DopPanelTalismanWnd.DopItemTalisman" );//ItemWindowHandl

  for (i =0; i < MAX_SLOT; i++)//Создадим 6 ячейки для панельки талисманов
{
	BIT_DopPanelTalismanWnd_Item.AddItem(EmptyItemInfo);
  }
	SkillTalismanAdd();
class'ShortcutAPI'.static.ActivateGroup("BIT_DopPanelTalismanWnd");
  }

//Нажатие клавиш
/*
function OnKeyDown( WindowHandle a_WindowHandle, EInputKey Key ){

  local ItemInfo infoItem;
	AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат

  if( IsKeyDown( IK_ALT ) && Key == 35 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",0, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }

  if( IsKeyDown( IK_ALT ) && Key == 40 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",1, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }

  if( IsKeyDown( IK_ALT ) && Key == 34 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",2, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }

  if( IsKeyDown( IK_ALT ) && Key == 37 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",3, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }
  if( IsKeyDown( IK_ALT ) && Key == 12 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",4, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }

  if( IsKeyDown( IK_ALT ) && Key == 39 )
{       AddSystemMessageString(string(Key)); // Вывыод системных сообщений в чат
class'UIAPI_ITEMWINDOW'.static.GetItem("BIT_DopPanelTalismanWnd.DopItemTalisman",5, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
  }
  }
 */
function ClearItem(){ //Чистим ячейки панельки талисманов
  local int i;

  for (i =0; i < MAX_SLOT; i++)//Создадим 6 ячейки
{
	BIT_DopPanelTalismanWnd_Item.SetItem(i,EmptyItemInfo);
  }
  }

function OnEvent(int Event_ID, string param) { /* Обработчик игровых событий */

  if (Event_ID == EV_SkillList || Event_ID == EV_InventoryUpdateItem) {

	ClearItem();
	SkillTalismanAdd();
  }

  if(Event_ID == EV_OpenDialogQuit || Event_ID == EV_Restart){

	SetOptionBool( "BIT_DopShortcut", "Visible",IsShowWindow("BIT_DopShortcut")); }
  }

function OnClickItem( String strID, int index ){ //Кликаем по интему
  local ItemInfo infoItem;

  switch( strID){

   case "DopItemTalisman":
	BIT_DopPanelTalismanWnd_Item.GetItem(index, infoItem);
	UseSkill( infoItem.ID , infoItem.itemSubType );
break;
  }
  }

function SkillTalismanAdd(){
  local int i;
  local ItemInfo SkillEquipItem;
  local int inc;

  for (i = 0; i < MagiSkillItem.GetItemNum(); i++)
{
	MagiSkillItem.GetItem(i, SkillEquipItem);

  if (GetTalismanSkillID(SkillEquipItem.ID.ClassID)){

	BIT_DopPanelTalismanWnd_Item.SetItem( inc++ , SkillEquipItem);
  }
  }
  }

function bool GetTalismanSkillID(int id)
{
  switch (id)
{
   case 8270: return True; break;
   case 3288: return True; break;
   case 3289: return True; break;
   case 3292: return True; break;
   case 3286: return True; break;
   case 3287: return True; break;
   case 3290: return True; break;
   case 3291: return True; break;
   case 8331: return True; break;
   case 8332: return True; break;
   case 3272: return True; break;
   case 3285: return True; break;
   case 3284: return True; break;
   case 3321: return True; break;
   case 3428: return True; break;
   case 3438: return True; break;
   case 3283: return True; break;
   case 3280: return True; break;
   case 8334: return True; break;
   case 3276: return True; break;
   case 3437: return True; break;
   case 3487: return True; break;
   case 3271: return True; break;
   case 3488: return True; break;
   case 3274: return True; break;
   case 3275: return True; break;
   case 3410: return True; break;
   case 3436: return True; break;
   case 3277: return True; break;
   case 8267: return True; break;
   case 8268: return True; break;
   case 8266: return True; break;
   case 8272: return True; break;
   case 3315: return True; break;
   case 3314: return True; break;
   case 8271: return True; break;
   case 22391: return True; break;
   case 3333: return True; break;
   case 3334: return True; break;
   case 3332: return True; break;
   case 8269: return True; break;
   case 8508: return True; break;
   case 8500: return True; break;
   case 8499: return True; break;
   case 8506: return True; break;
   case 8501: return True; break;
   case 8503: return True; break;
   case 8507: return True; break;
   case 8505: return True; break;
   case 8498: return True; break;
   case 8504: return True; break;
   case 8502: return True; break;
   case 3429: return True; break;
   case 3664: return True; break;
   case 3282: return True; break;
   case 3279: return True; break;
   case 3278: return True; break;
   case 3281: return True; break;
   case 3496: return True; break;
   case 3273: return True; break;
   case 8309: return True; break;
   case 8333: return True; break;
   case 8308: return True; break;
   case 22276: return True; break;
   case 8273: return True; break;
   case 8274: return True; break;
   case 5695: return True; break;
   case 3304: return True; break;
   case 8335: return True; break;
   case 3303: return True; break;
   case 3306: return True; break;
   case 3430: return True; break;
   case 3434: return True; break;
   case 3433: return True; break;
   case 3308: return True; break;
   case 3305: return True; break;
   case 3435: return True; break;
   case 3307: return True; break;
   case 3309: return True; break;
   case 3431: return True; break;
   case 3432: return True; break;
   case 3297: return True; break;
   case 3313: return True; break;
   case 3302: return True; break;
   case 3489: return True; break;
   case 3294: return True; break;
   case 3494: return True; break;
   case 3311: return True; break;
   case 3299: return True; break;
   case 3316: return True; break;
   case 3317: return True; break;
   case 3667: return True; break;
   case 3490: return True; break;
   case 3295: return True; break;
   case 3491: return True; break;
   case 3298: return True; break;
   case 3495: return True; break;
   case 3312: return True; break;
   case 3666: return True; break;
   case 3296: return True; break;
   case 3320: return True; break;
   case 3497: return True; break;
   case 3310: return True; break;
   case 3293: return True; break;
   case 3493: return True; break;
   case 3492: return True; break;
   case 3300: return True; break;
   case 3301: return True; break;
	default:
	return False;
break;
  }
  }
	defaultproperties{}
