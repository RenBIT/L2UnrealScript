/******************************************
Дата 06.01.2024 10:33

  Разработчик: BITHACK 

  Copyright (c) Ваша компания

 Описание скрипта:....

*******************************************/
class BIT_AutologinWnd extends UICommonAPI;

const MAX_SAVE_LOGIN = 10;

 var WindowHandle Me;
 var ListCtrlHandle LoginListCtrl;
 var CheckBoxHandle AutoSaveCheckBox;

function OnLoad() {

	Me = GetWindowHandle( "BIT_AutologinWnd" );
	LoginListCtrl = GetListCtrlHandle( "BIT_AutologinWnd.LoginListCtrl" );
	AutoSaveCheckBox = GetCheckBoxHandle ( "BIT_AutologinWnd.AutoSaveCheckBox" );
	}

function OnShow() { /* Выполняется при загрузки игры */

 local int i;
 local string Login;

 local array<string> SplitStr, emty;

 local LVDataRecord Record;

	SortInI();

	LoginListCtrl.DeleteAllItem();

	Record.LVDataList.length = 2;
	record.LVDataList[1].buseTextColor = True;
	record.LVDataList[1].TextColor = getInstanceL2Util().Yellow;

 for( i = 0 ; i <= MAX_SAVE_LOGIN ; i++ )
	{

	GetINIString( "BIT_AUTO_LOGIN", string(i), Login, "AUTOLOGIN.ini");//Логин из Ini

	Split(Login, ",",SplitStr);

	record.LVDataList[0].szData = String(i);

	record.LVDataList[1].szData = SplitStr[0];
	LoginListCtrl.InsertRecord( Record );

	SplitStr = emty;
	}

	}

function SortInI(){//Сортировка

 local int i,inc;
 local string Login,SortLogin[MAX_SAVE_LOGIN];

 for( i = 0 ; i <= MAX_SAVE_LOGIN ; i++ )
	{

	GetINIString( "BIT_AUTO_LOGIN", string(i), Login, "AUTOLOGIN.ini");//Логин из Ini
 if (Login != "") {

	SortLogin[inc] = Login;
	inc++;
	}
	}

 for( i = 0 ; i <= MAX_SAVE_LOGIN ; i++ )
	{
	SetINIString( "BIT_AUTO_LOGIN", string(i), SortLogin[i], "AUTOLOGIN.ini");//Логин из Ini

	}
	RefreshINI( "AUTOLOGIN.ini");
	}

function AutoSaveLogin(String LoginID, String Pass){ //Автосохранение логина
	
 local int i;
 local string Login;
 local array<string> SplitStr, emty;

 if ( AutoSaveCheckBox.IsChecked() ){ //Если включена галочка автосохранение
 for( i = 0 ; i <= MAX_SAVE_LOGIN ; i++ )
	{

	GetINIString( "BIT_AUTO_LOGIN", string(i), Login, "AUTOLOGIN.ini");//Логин из Ini

	Split(Login, ",",SplitStr);

 if (SplitStr[0] == LoginID)//Если такой логин уже есть выходим не сохроняем
	return;

	SplitStr = emty;

 if (Login == "") {
	SetINIString( "BIT_AUTO_LOGIN", string(i), LoginID$","$Pass, "AUTOLOGIN.ini");//Логин из Ini
	RefreshINI( "AUTOLOGIN.ini");
 break;
	}
	}
	}
	}

function OnClickButton( String strID ) { /* Оброботчики нажатий на кнопки */

 local string Login;

 local array<string> SplitStr;

 if (strID == "LoginBtn")
	{
	GetINIString( "BIT_AUTO_LOGIN", string(LoginListCtrl.GetSelectedIndex()), Login, "AUTOLOGIN.ini");//Войти из Ini

	Split(Login, ",",SplitStr);

	RequestLogin( SplitStr[0], SplitStr[1], 7 ); //Войдем в игру!
	}

 if (strID == "LoginDelBtn")
	{
	SetINIString( "BIT_AUTO_LOGIN", string(LoginListCtrl.GetSelectedIndex()), Login, "AUTOLOGIN.ini");//Удалить из Ini
	RefreshINI( "AUTOLOGIN.ini");
	OnShow();
	}

	}

function OnClickListCtrlRecord( String strID ){

 if (strID == "LoginListCtrl")
	{
	AddSystemMessageString("Mes"@strID); //string Вывыод системных сообщений в чат
	}
	}

	defaultproperties{}
