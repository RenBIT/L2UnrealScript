/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:....

 *******************************************/
class BIT_DopShortcut extends UIScriptEx;
  const MAX_ShortcutPerPage = 12;
  const FTShortcutPage = 10;

  var int i;
   var int l;

function OnLoad() { /* Выполняется при старте игры */

	RegisterEvent( EV_ShortcutUpdate );
	RegisterEvent( EV_ShortcutCommandSlot );

//Активировать При старте
	ShortCutUpdateAll();
  }

function OnEvent( int a_EventID, String a_Param )
{

  switch( a_EventID )
{
   case EV_ShortcutCommandSlot:
	ExecuteShortcutCommandBySlot(a_Param);
break;

   case EV_ShortcutUpdate:
	HandleShortcutUpdate( a_Param );
break;

  }

  }

function ShortCutUpdateAll()
{
  local int nShortcutID;

	nShortcutID = MAX_ShortcutPerPage * FTShortcutPage;

  for( i = 0; i < MAX_ShortcutPerPage; ++i )
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "BIT_DopShortcut.Shortcut" $ ( i + 1 ), nShortcutID );
	nShortcutID++;

  }

  }

function HandleShortcutUpdate(string param)
{
  local int nShortcutID;
  local int nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ( nShortcutID - MAX_ShortcutPerPage * FTShortcutPage) + 1;

  if((nShortcutNum > 0 ) && ( nShortcutNum < MAX_ShortcutPerPage + 1 ))
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "BIT_DopShortcut.Shortcut" $ nShortcutNum, nShortcutID );


  }

  }


function ExecuteShortcutCommandBySlot( string a_Param )
{
  local int slot;

class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);

  }


	defaultproperties{}
