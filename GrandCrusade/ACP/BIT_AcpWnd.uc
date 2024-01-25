/******************************************
	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:.... Авто востановление жизней с помощью банок
*******************************************/

class BIT_AcpWnd extends UICommonAPI;

/* Добавить этот код в function bool IsVertical()  в скрипт ShortcutWnd.uc
    if(!m_IsVertical ){
//AcpSlotHorizontal выводим над первой панедькой
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }

  if(m_IsVertical){

//AcpSlotVertical
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
 }

*/

  const ID_TIMER = 1; //ID таймера
  const TIME_TIMER = 100; //Время повтора таймера
  var int CONT_TIMER;
  const POINT_ID = "5591,5592,1539,728,10410"; //const с ID разрешенных банок
  const TAGLLE_NAME = "l2_skilltime.ToggleEffect.ToggleEffect001";//Иконка на включения интема
  const MaxSlot = 5; //Сколько у нас слотов

  var WindowHandle BIT_AcpWnd;
  var ItemWindowHandle ItemSlotHorizontal,ItemSlotVertical;
  var ItemInfo EmptyItemInfo;//Пустой массив интемов
  var StatusBarHandle CPBar,HPBar,MPBar;
  var SliderCtrlHandle SliderCP,SliderHP,SliderMP;

  var array<String> ItemClassID; //Массив с ID разрешенных банок
  var array<int> TimePoint;//Массив время повтора нажатий на бутылки
  var UserInfo MyUserInfo;
  var InventoryWnd InventoryWndItem;
  var() string Message;

function OnRegisterEvent(){

	RegisterEvent(EV_Restart);
	RegisterEvent(EV_OpenDialogQuit);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateHennaInfo);
	registerEvent(EV_StateChanged);

  }

/* Выполняется при старте игры */
function OnLoad() {

     local int i;

//Получим скрипт InventoryWnd
	InventoryWndItem = InventoryWnd(GetScript("InventoryWnd"));

//Подключаем окна
	BIT_AcpWnd = GetWindowHandle( "BIT_AcpWnd" );

//Подключим статус бары
	CPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.CPBar" );
	HPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.HPBar" );
	MPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.MPBar" );

//Подключим слайдеры
	SliderCP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.CPSlider" );
	SliderHP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.HPSlider" );
	SliderMP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.MPSlider" );

// Подключим панелькьки ACP
	ItemSlotHorizontal = GetItemWindowHandle( "BIT_AcpWnd.AcpSlotHorizontalWnd.ItemSlotHorizontal" );
	ItemSlotVertical = GetItemWindowHandle( "BIT_AcpWnd.AcpSlotVerticalWnd.ItemSlotVertical" );

//Создадим ячейки для панели ACP
	ClearItemID( EmptyItemInfo.ID );//Почистим ID = -1
 for ( i = 0; i < MaxSlot; i++) {
	ItemSlotHorizontal.AddItem(EmptyItemInfo);
	ItemSlotVertical.AddItem(EmptyItemInfo);
  }

//Заполним Массив с ID разрешенных банок "Нет многомерных массивов-("
	Split(POINT_ID, "," ,ItemClassID);
//Присвоим длину массива для таймера (Берется из длины массива разрешенных банок ItemClassID )
	TimePoint.Length = ItemClassID.Length;
    Message = "Test";
  }

/* Загрузим настройки */
function LoadINI(){

     local int i;
     local ItemInfo ItemPointInfo;
     local ItemID ID;
     local int ItemIndex;

 for ( i = 0; i < MaxSlot; i++) {
//Почистим слоты
	ItemSlotHorizontal.SetItem(i,EmptyItemInfo);
	ItemSlotVertical.SetItem(i,EmptyItemInfo);

	ID.ClassID = GetOptionInt( "BIT_AcpWnd", MyUserInfo.Name$i);

   if (ID.ClassID > 0){

class'UIDATA_ITEM'.static.GetItemInfo(ID, ItemPointInfo );

	ItemIndex = InventoryWndItem.m_invenItem.Finditem(ItemPointInfo.ID); //Непонятно но просить записать в переменную иначе не работает

	InventoryWndItem.m_invenItem.GetItem(ItemIndex,ItemPointInfo);

	ItemSlotVertical.SetItem(i,ItemPointInfo);
	ItemSlotHorizontal.SetItem(i,ItemPointInfo);

	ItemPointInfo = EmptyItemInfo;
  }
  }
  }

/* Сохранить настройки */
function SaveINI(){

     local int i;
     local ItemInfo ItemPointInfo;

 for ( i = 0; i < MaxSlot; i++) { //Бежим по слотам ACP

	ItemSlotHorizontal.GetItem(i,ItemPointInfo);//Получим инфу с ячейки, панельки ACP
	SetOptionInt( "BIT_AcpWnd", MyUserInfo.Name$i,ItemPointInfo.ID.ClassID);
  }
  }

/* Обработчик игровых событий */
function OnEvent(int Event_ID, string param) {

  switch( Event_ID ){

    case EV_OpenDialogQuit:
    case EV_Restart:
	SaveINI();
      break;

    case EV_UpdateHennaInfo:
//Получим инфу о персонаже
	GetPlayerInfo(MyUserInfo);
//Загрузим настройки
	LoadINI();
//Запустим таймер
	BIT_AcpWnd.SetTimer(ID_TIMER,TIME_TIMER);
	BIT_AcpWnd.SetTimer(2,1000);
      break;

    case EV_UpdateUserInfo:
//Получим инфу о персонаже на всяукий случай
	GetPlayerInfo(MyUserInfo);
      break;
  }
  }

/* Проверка на существование банок в инвентаре*/
function CurentPoint(int i, ItemInfo ItemPointInfo){

     local int ItemIndex;
     local ItemInfo Item;
//В одно условие не работает
   if (ItemPointInfo.ID.ClassID > -1){
	ItemIndex = InventoryWndItem.m_invenItem.Finditem(ItemPointInfo.ID); //Непонятно но просить записать в переменную иначе не работает
	InventoryWndItem.m_invenItem.GetItem(ItemIndex,Item);
	Item.IconPanel = ItemPointInfo.IconPanel;
	ItemSlotHorizontal.SetItem(i,Item);
	ItemSlotVertical.SetItem(i,Item);
   if (ItemIndex > -1){
  }else{

	ItemSlotHorizontal.SetItem(i,EmptyItemInfo);
	ItemSlotVertical.SetItem(i,EmptyItemInfo);
  }
  }
  }

/* Обработчик таймера */
function OnTimer( int TimerID ) {

     local int i;
     local ItemInfo ItemPointInfo;

   if( TimerID == 2 ){//Ждем обновление инвенторя (Лучше способ не нашел, в хрниках выше HF работает и без таймера)
	LoadINI();
	BIT_AcpWnd.KillTimer(2);
  }

   if( TimerID == ID_TIMER ) {

 for ( i = 0; i < MaxSlot; i++) { //Бежим по слотам ACP

	ItemSlotHorizontal.GetItem(i,ItemPointInfo);//Получим инфу с ячейки, панельки ACP

   if ( ItemPointInfo.ID.ClassID > 0 ){

	UsePotions(ItemPointInfo);//Выпить зелье

   if ( CONT_TIMER > 50 ){ //Проверим интем в инвентаре
	CurentPoint(i,ItemPointInfo);
	CONT_TIMER = 0;
  }
	CONT_TIMER++;

  }
  }
  }
  }

/* Выпить зелье */
function UsePotions(ItemInfo ItemPointInfo){

	GetPlayerInfo(MyUserInfo);

   if ( MyUserInfo.nCurHP <= 0 )//Если мертвы выходим из функции
    return;

  switch(ItemPointInfo.ID.ClassID){ //Сверяем с ID , если совпадает используем бутылки

    case 5591: //Potion of Will Восстанавливает 50 CP
   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*(10*SliderCP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[0]++*100 == 500) { //Время повтора
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[0] = 0;
  }
  }
      break;

    case 5592: //Greater CP Potion Восстанавливает 200 CP
   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*(10*SliderCP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[1]++*100 == 800) { //Время повтора
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[1] = 0;
// AddSystemMessageString("CONT"@CONT_TIMER); //Вывыод системных сообщений в чат
  }
  }
      break;

//MP
    case 728:
   if(MyUserInfo.nCurMP < MyUserInfo.nMaxMP*(10*SliderMP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[2]++*100 == 10000) { //Время повтора
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[2] = 0;
  }
  }
      break;

    case 10410:
   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[3]++*100 == 15000) { //Время повтора
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[3] = 0;
  }
  }
      break;
    case 1539: //Greater Healing Potion

   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[4]++*100 == 10000) { //Время повтора
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[4] = 0;

  }
  }
      break;
  }
  }

/* Функция проверки на разрешенный ID */
function bool ValidateClassID( int id ) {

     local int i;

 for ( i = 0; i < ItemClassID.Length; i++){

   if (int(ItemClassID[i]) == id)
{
    return true;
  }
  }
  }

/* Обраподчик ячейки (что кинули) */
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y) {

     local int ToIndex,fromIndex;

   if(!ValidateClassID(a_ItemInfo.ID.ClassID) ) {
    return;//Выходим из функции если интем не разрешен
  }

  switch (a_WindowID) {

    case "ItemSlotHorizontal":
	ToIndex = ItemSlotHorizontal.GetIndexAt( x, y, 1, 1 );
	fromIndex = ItemSlotHorizontal.FindItem(a_ItemInfo.ID);
	ItemSlotHorizontal.SwapItems( fromIndex, ToIndex );
	ItemSlotHorizontal.SetItem(ToIndex,a_ItemInfo);

	ItemSlotVertical.SwapItems( fromIndex, ToIndex );
	ItemSlotVertical.SetItem(ToIndex,a_ItemInfo);
      break;

    case "ItemSlotVertical":
	ToIndex = ItemSlotVertical.GetIndexAt( x, y, 1, 1 );
	fromIndex = ItemSlotVertical.FindItem(a_ItemInfo.ID);

	ItemSlotVertical.SwapItems( fromIndex, ToIndex );
	ItemSlotVertical.SetItem(ToIndex,a_ItemInfo);

	ItemSlotHorizontal.SwapItems( fromIndex, ToIndex );
	ItemSlotHorizontal.SetItem(ToIndex,a_ItemInfo);
      break;
  }
	SaveINI();
  }

/* Проверим куда кинули предмет */
function OnDropItemSource( String strTarget, ItemInfo info ) {

     local int DeleteIndexItem;

   if ( strTarget == "Console" ) { //Console Выкидывам предмет если кинули за пределами нашей панельки

  switch( info.DragSrcName){

    case "ItemSlotHorizontal":

	DeleteIndexItem = ItemSlotHorizontal.FindItem(info.ID);
	ItemSlotHorizontal.SetItem(DeleteIndexItem,EmptyItemInfo);
	ItemSlotVertical.SetItem(DeleteIndexItem,EmptyItemInfo);
      break;

    case "ItemSlotVertical":

	DeleteIndexItem = ItemSlotVertical.FindItem(info.ID);
	ItemSlotVertical.SetItem(DeleteIndexItem,EmptyItemInfo);
	ItemSlotHorizontal.SetItem(DeleteIndexItem,EmptyItemInfo);
      break;
  }
  }
  }

/* обработчик, клик по интему */
function OnClickItem( String strID, int index ) {

	TaggleItem( strID, index );

  }

/* обработчик, клик по интему правой кнопкой мышю */
function OnRClickItem( String strID, int index ) {

	TaggleItem( strID, index );
  }

/* Включена выключена Банка (Иконка) уневерсально для всех хроник*/
function TaggleItem( String strID, int index ) {

     local ItemInfo infoItem;

	ItemSlotHorizontal.GetItem(index, infoItem);

   if ( !ValidateClassID(infoItem.ID.ClassID) )
    return;

  switch (strID) {

    case "ItemSlotHorizontal":

   if (infoItem.IconPanel == TAGLLE_NAME)//Если иконка включения интема установлена удалим ее если нет установим
{
	infoItem.IconPanel = "";//Удалим иконку включения интема
	ItemSlotHorizontal.SetItem(index,infoItem);
	ItemSlotVertical.SetItem(index,infoItem);
  }else{
	infoItem.IconPanel = TAGLLE_NAME; //Установим иконку на включения интема
	ItemSlotHorizontal.SetItem(index,infoItem);
	ItemSlotVertical.SetItem(index,infoItem);
  }
      break;

    case "ItemSlotVertical":

   if (infoItem.IconPanel == TAGLLE_NAME) { //Если иконка включения интема установлена удалим ее если нет установим

	infoItem.IconPanel = "";//Удалим иконку включения интема
	ItemSlotVertical.SetItem(index,infoItem);
	ItemSlotHorizontal.SetItem(index,infoItem);

  }else{

	infoItem.IconPanel = TAGLLE_NAME; //Установим иконку на включения интема
	ItemSlotVertical.SetItem(index,infoItem);
	ItemSlotHorizontal.SetItem(index,infoItem);
  }
      break;
  }
  }

/* Оброботчик нажатий на кнопки */
function OnClickButton( String strID ) {

   if (strID=="OptionsAcpBtn") {
	IsOptionsShowWindow();//Показать окно с настройками

  }
  }

/* //Показать окно с настройками */
function IsOptionsShowWindow (){

//Заполним статус бары Выведим В процентах
	CPBar.SetPointPercent(10*SliderCP.GetCurrentTick(), 0, 100);
	HPBar.SetPointPercent(10*SliderHP.GetCurrentTick(), 0, 100);
	MPBar.SetPointPercent(10*SliderMP.GetCurrentTick(), 0, 100);

//Показать окно с настройками
   if (IsShowWindow("BIT_AcpWnd.AcpSlotHorizontalWnd")) {
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpOptions", "BIT_AcpWnd.AcpSlotHorizontalWnd", "BottomLeft", "BottomLeft", 15,-40 );

   if (IsShowWindow("BIT_AcpWnd.AcpOptions")) {
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else{
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpOptions");
  }
  }else{
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpOptions", "BIT_AcpWnd.AcpSlotVerticalWnd", "TopLeft", "TopLeft", -169, 14 );

   if (IsShowWindow("BIT_AcpWnd.AcpOptions")) {
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else{
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpOptions");
  }
  }
  }

/* Обработчик Slider */
function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick) {

  switch (strID) {

    case "CPSlider":
	CPBar.SetPointPercent(100*(10*iCurrentTick)/100, 0, 100);
      break;

    case "HPSlider":
	HPBar.SetPointPercent(100*(10*iCurrentTick)/100, 0, 100);
      break;

    case "MPSlider":
	MPBar.SetPointPercent(100*(10*iCurrentTick)/100, 0, 100);
      break;
  }
  }
	defaultproperties{}
