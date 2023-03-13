/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:....

 *******************************************/

class BIT_DopPanelWnd extends UICommonAPI;

  var WindowHandle BIT_DopPanelWnd1, BIT_DopPanelWnd2,BIT_DopPanelTalismanWnd;
  var ItemWindowHandle  BIT_DopPanelWnd1_Item, BIT_DopPanelWnd2_Item,BIT_DopPanelTalismanWnd_Item;
  var ItemInfo EmptyItemInfo;

function OnLoad() { /* Выполняется при старте игры */
  local  int i;

	BIT_DopPanelWnd1 = GetWindowHandle( "BIT_DopPanelWnd1" );//WindowHandle
	BIT_DopPanelWnd2 = GetWindowHandle( "BIT_DopPanelWnd2" );//WindowHandle
	BIT_DopPanelTalismanWnd = GetWindowHandle( "BIT_DopPanelTalismanWnd" );//WindowHandle

	BIT_DopPanelWnd1_Item = GetItemWindowHandle( "BIT_DopPanelWnd1.DopItem1" );//ItemWindowHandle
	BIT_DopPanelWnd2_Item = GetItemWindowHandle( "BIT_DopPanelWnd2.DopItem2" );//ItemWindowHandl
	BIT_DopPanelTalismanWnd_Item = GetItemWindowHandle( "BIT_DopPanelTalismanWnd.DopItemTalisman" );//ItemWindowHandl

  for (i =0; i < 12; i++)//Создадим 12 ячейки
{
	BIT_DopPanelWnd1_Item.AddItem(EmptyItemInfo);
	BIT_DopPanelWnd2_Item.AddItem(EmptyItemInfo);

  }

  for (i =0; i < 4; i++)//Создадим 4 ячейки
{

	BIT_DopPanelTalismanWnd_Item.AddItem(EmptyItemInfo);

  }

  }

function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y){

  local int ToIndex,fromIndex;
          //AddSystemMessageString("Вывыод системных сообщений в чат  "); // Вывыод системных сообщений в чат
  if(a_ItemInfo.ID.ClassID < 1 ){
	return;//Выходим из функции если это не интем не скил и тп.
  }

  switch( a_WindowID){

   case "DopItem1":

	ToIndex = BIT_DopPanelWnd1_Item.GetIndexAt( x, y, 1, 1 );

	fromIndex = BIT_DopPanelWnd1_Item.FindItem(a_ItemInfo.ID);
	BIT_DopPanelWnd1_Item.SwapItems( fromIndex, ToIndex );

	BIT_DopPanelWnd1_Item.SetItem(ToIndex,a_ItemInfo);

break;
   case "DopItem2":
   
	ToIndex = BIT_DopPanelWnd2_Item.GetIndexAt( x, y, 1, 1 );

	fromIndex = BIT_DopPanelWnd2_Item.FindItem(a_ItemInfo.ID);
	BIT_DopPanelWnd2_Item.SwapItems( fromIndex, ToIndex );

	BIT_DopPanelWnd2_Item.SetItem(ToIndex,a_ItemInfo);

break;
   case "DopItemTalisman":

	ToIndex = BIT_DopPanelTalismanWnd_Item.GetIndexAt( x, y, 1, 1 );

	fromIndex = BIT_DopPanelTalismanWnd_Item.FindItem(a_ItemInfo.ID);
	BIT_DopPanelTalismanWnd_Item.SwapItems( fromIndex, ToIndex );

	BIT_DopPanelTalismanWnd_Item.SetItem(ToIndex,a_ItemInfo);

break;
  }

  }

function OnDropItemSource( String strTarget, ItemInfo info ){
  local int DeleteIndexItem;

  if( strTarget == "Console" ){ //Console Выкидывам предмет

  switch( info.DragSrcName){

   case "DopItem1":

	DeleteIndexItem = BIT_DopPanelWnd1_Item.FindItem(info.ID);
	BIT_DopPanelWnd1_Item.SetItem(DeleteIndexItem,EmptyItemInfo);
break;
   case "DopItem2":

	DeleteIndexItem = BIT_DopPanelWnd2_Item.FindItem(info.ID);
	BIT_DopPanelWnd2_Item.SetItem(DeleteIndexItem,EmptyItemInfo);

break;
   case "DopItemTalisman":

	DeleteIndexItem = BIT_DopPanelTalismanWnd_Item.FindItem(info.ID);
	BIT_DopPanelTalismanWnd_Item.SetItem(DeleteIndexItem,EmptyItemInfo);
break;
  }

  }
  }

function OnClickItem( String strID, int index ){ //Кликаем по интему
  local ItemInfo infoItem;



  switch( strID){

   case "DopItem1":
	BIT_DopPanelWnd1_Item.GetItem(index, infoItem);
	RequestUseItem(infoItem.ID);

	UseSkill( infoItem.ID , infoItem.itemSubType );

class'MacroAPI'.static.RequestUseMacro(infoItem.ID);
break;
   case "DopItem2":
	BIT_DopPanelWnd2_Item.GetItem(index, infoItem);
	RequestUseItem(infoItem.ID);
	UseSkill( infoItem.ID , infoItem.itemSubType );
class'MacroAPI'.static.RequestUseMacro(infoItem.ID);

break;
   case "DopItemTalisman":
	BIT_DopPanelTalismanWnd_Item.GetItem(index, infoItem);
	RequestUseItem(infoItem.ID);
	UseSkill( infoItem.ID , infoItem.itemSubType );
class'MacroAPI'.static.RequestUseMacro(infoItem.ID);
break;
  }
  }

	defaultproperties{}
