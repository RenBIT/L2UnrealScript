/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:....

 *******************************************/
class BIT_ManagerHF extends UICommonAPI;

//Перечисление ACP
enum ACP{
	CP,HP,MP
  };

//ACP если CP HP MP меньше задоного процента используем интем
function HF_ACP(ACP Name, int Percent, int Item_Id, UserInfo MyUserInfo){

     local int ItemIndx;
     local ItemID ID;
     local ItemInfo ItemPointInfo,infItem;

   if ( MyUserInfo.nCurHP <= 0 )//Если мертвы выходим из функции
    return;

	ID.ClassID = Item_Id;
class'UIDATA_ITEM'.static.GetItemInfo(ID, ItemPointInfo );
	ItemIndx = class'UIAPI_ITEMWINDOW'.static.FindItem( "InventoryWnd.InventoryItem", ItemPointInfo.ID );

   if ( class'UIAPI_ITEMWINDOW'.static.GetItem( "InventoryWnd.InventoryItem", ItemIndx, infItem) ) {
  switch( name )
{
    case CP:

   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*Percent/100){
	RequestUseItem( infItem.ID );
  }
      break;
    case HP:

   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*Percent/100){
	RequestUseItem( infItem.ID );
  }
      break;
    case MP:

   if(MyUserInfo.nCurMP < MyUserInfo.nMaxMP*Percent/100){
	RequestUseItem( infItem.ID );
  }
      break;
  }
  }

  }


//Поиск интема в инвенторе

function bool FindItemHF(int Item_Id){
     local ItemID id;
     local bool Result;
	id.ClassID = Item_Id;

   if (class'UIAPI_ITEMWINDOW'.static.FindItem( "InventoryWnd.InventoryItem", id ) > 0)
	Result = True;
    return Result;
  }

/*
	Работа с панелью ItemWindow
 */

//Очистить всю панель при стаарте игры

function ItemClearAllHF(ItemWindowHandle IntemWindow, int ItemMaxNum){
     local int i;
     local ItemInfo Empty;
 for (i = 0; i < ItemMaxNum; i++ ){
	IntemWindow.AddItem(Empty);//Создадим пустые массивы (иначе не работает)
  }
  }

//Удалить интемы с панели

function ItemDeleteAllHF(ItemWindowHandle IntemWindow, int ItemMaxNum){
     local int i;
     local ItemInfo Empty;
 for (i = 0; i < ItemMaxNum; i++ ){
	IntemWindow.SetItem(i, Empty);//Создадим пустые массивы (иначе не работает)
  }
  }

//Очистить по index item

function ItemClearIndexHF(ItemWindowHandle IntemWindow, int ItemIndex){
     local ItemInfo Empty;
	IntemWindow.SetItem(ItemIndex, Empty);//Создадим пустые массивы (иначе не работает)
  }

//Вставить интем

function SetItemHF(ItemWindowHandle IntemWindow, ItemInfo infItem, int x, int y ){
     local int ToIndex, fromIndex;

//Меняем местами ячейки
	ToIndex = IntemWindow.GetIndexAt(x, y, 1, 1);
	fromIndex = IntemWindow.FindItem(infItem.ID);
	IntemWindow.SwapItems( fromIndex, ToIndex );

//Вставим интем в ячеку
	IntemWindow.SetItem(ToIndex,infItem);
  }

//Удалить выбрасываемый интем

function ItemOutDropHF(ItemWindowHandle IntemWindow,ItemInfo infItem){
     local ItemInfo Empty;
	IntemWindow.SetItem(IntemWindow.FindItem(infItem.ID),Empty);
  }
/*
	Конец Работа с панелью ItemWindow
 */

	defaultproperties{}
