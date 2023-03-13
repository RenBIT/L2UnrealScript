/******************************************

	�����������: BITHACK

	Copyright (c) 1995,2022 ���� ��������

	�������� �������:.... ���� ������������� ������ � ������� �����

 *******************************************/

class BIT_AcpWnd extends UICommonAPI;
  const ID_TIMER = 1; //ID �������
  const TIME_TIMER = 100; //����� ������� �������
  const POINT_ID = "5591,5592,8639,22024,1539,8627,728,1061"; //const � ID ����������� �����
  const TAGLLE_NAME = "l2_skilltime.ToggleEffect.ToggleEffect001";//������ �� ��������� ������
  const MaxSlot = 7; //������� � ��� ������

  var WindowHandle BIT_AcpWnd;
  var ItemWindowHandle ItemSlotHorizontal,ItemSlotVertical;
  var ItemInfo EmptyItemInfo;//������ ������ �������
  var StatusBarHandle CPBar,HPBar,MPBar;
  var SliderCtrlHandle SliderCP,SliderHP,SliderMP;

  var array<String> ItemClassID; //������ � ID ����������� �����
  var array<int> TimePoint;//������ ����� ������� ������� �� �������
  var UserInfo MyUserInfo;
  var ItemWindowHandle InventoryWndItem;

/* ����������� ��� ������ ���� */
function OnLoad() {
     local int i;

	RegisterEvent(EV_Restart);
	RegisterEvent(EV_OpenDialogQuit);
	RegisterEvent(EV_UpdateUserInfo);
	RegisterEvent(EV_UpdateHennaInfo);
	RegisterEvent(EV_ChangeCharacterPawn );
	RegisterEvent(EV_SkillList);
	RegisterEvent(EV_InventoryAddItem);
	RegisterEvent(EV_InventoryUpdateItem);
	RegisterEvent(EV_InventoryClear);
	RegisterEvent(EV_InventoryItemListEnd);
	registerEvent(EV_StateChanged);
	InventoryWndItem = GetItemWindowHandle("InventoryWnd.InventoryItem");

//���������� ����
	BIT_AcpWnd = GetWindowHandle( "BIT_AcpWnd" );

//��������� ������ ����
	CPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.CPBar" );
	HPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.HPBar" );
	MPBar = GetStatusBarHandle( "BIT_AcpWnd.AcpOptions.MPBar" );

//��������� ��������
	SliderCP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.CPSlider" );
	SliderHP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.HPSlider" );
	SliderMP = GetSliderCtrlHandle("BIT_AcpWnd.AcpOptions.MPSlider" );

// ��������� ���������� ACP
	ItemSlotHorizontal = GetItemWindowHandle( "BIT_AcpWnd.AcpSlotHorizontalWnd.ItemSlotHorizontal" );
	ItemSlotVertical = GetItemWindowHandle( "BIT_AcpWnd.AcpSlotVerticalWnd.ItemSlotVertical" );

//�������� ������ ��� ������ ACP
 for ( i = 0; i < MaxSlot; i++) {
	ItemSlotHorizontal.AddItem(EmptyItemInfo);
	ItemSlotVertical.AddItem(EmptyItemInfo);
  }

//�������� ������ � ID ����������� ����� "��� ����������� ��������-("
	Split(POINT_ID, "," ,ItemClassID);
//�������� ����� ������� ��� ������� (������� �� ����� ������� ����������� ����� ItemClassID )
	TimePoint.Length = ItemClassID.Length;

  }

/* �������� ��������� */
function LoadINI(){
     local int i;
     local ItemInfo ItemPointInfo;
     local ItemID ID;
     local int ItemIndex;

 for ( i = 0; i < MaxSlot; i++) {
//�������� �����
	ItemSlotHorizontal.SetItem(i,EmptyItemInfo);
	ItemSlotVertical.SetItem(i,EmptyItemInfo);

	ID.ClassID = GetOptionInt( "BIT_AcpWnd", MyUserInfo.Name$i);

   if (ID.ClassID > 0){

class'UIDATA_ITEM'.static.GetItemInfo(ID, ItemPointInfo );

	ItemIndex = InventoryWndItem.Finditem(ItemPointInfo.ID); //��������� �� ������� �������� � ���������� ����� �� ��������

	InventoryWndItem.GetItem(ItemIndex,ItemPointInfo);
	ItemSlotVertical.SetItem(i,ItemPointInfo);
	ItemSlotHorizontal.SetItem(i,ItemPointInfo);
  }
  }
  }

function SaveINI(){
     local int i;
     local ItemInfo ItemPointInfo;
 for ( i = 0; i < MaxSlot; i++) { //����� �� ������ ACP

	ItemSlotHorizontal.GetItem(i,ItemPointInfo);//������� ���� � ������, �������� ACP
	SetOptionInt( "BIT_AcpWnd", MyUserInfo.Name$i,ItemPointInfo.ID.ClassID);
  }

  }
/* ���������� ������� ������� */
function OnEvent(int Event_ID, string param) {

  switch( Event_ID ){

    case EV_OpenDialogQuit:
    case EV_Restart:
	SaveINI();
      break;

    case EV_UpdateHennaInfo:
//������� ���� � ���������
	GetPlayerInfo(MyUserInfo);
//�������� ���������
	LoadINI();
//�������� ������
	BIT_AcpWnd.SetTimer(ID_TIMER,TIME_TIMER);
	BIT_AcpWnd.SetTimer(2,1000);
	AddSystemMessageString("L2HELIOS.NET"); // ������ ��������� ��������� � ���
      break;

    case EV_UpdateUserInfo:
//������� ���� � ��������� �� ������� ������
	GetPlayerInfo(MyUserInfo);
// CurentPoint();
      break;
  }

  }

/* �������� �� ������������� ����� � ���������*/
function CurentPoint(int i, ItemInfo ItemPointInfo){ //�������� ����� � ��������� ���� ���� ������ � ������ ACP

     local int ItemIndex;
     local ItemInfo Item;
//� ���� ������� �� �������� (�������!!!)
   if (ItemPointInfo.ID.ClassID > -1){
	ItemIndex = InventoryWndItem.Finditem(ItemPointInfo.ID); //��������� �� ������� �������� � ���������� ����� �� ��������
	InventoryWndItem.GetItem(ItemIndex,Item);
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

/* ���������� ������� */
function OnTimer( int TimerID ) {
     local int i;
     local ItemInfo ItemPointInfo;

   if(TimerID == 2){//���� ���������� ��������� (����� ������ �� �����)
	LoadINI();
	BIT_AcpWnd.KillTimer(2);
  }

   if(TimerID == ID_TIMER) {

 for ( i = 0; i < MaxSlot; i++) { //����� �� ������ ACP

	ItemSlotHorizontal.GetItem(i,ItemPointInfo);//������� ���� � ������, �������� ACP

   if (ValidateClassID(ItemPointInfo.ID.ClassID)) { //�������� �� ����������� ID

	GetPlayerInfo(MyUserInfo);

	CurentPoint(i,ItemPointInfo);//�������� ����� � ���������
   if ( MyUserInfo.nCurHP <= 0 )//���� ������ ������� �� �������
    return;

  switch(ItemPointInfo.ID.ClassID){ //������� � ID , ���� ��������� ���������� �������

    case 5591: //Potion of Will ��������������� 50 CP
   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*(10*SliderCP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[0]++*100 == 500) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[0] = 0;
  }
  }
      break;

    case 5592: //Greater CP Potion ��������������� 200 CP
   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*(10*SliderCP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[1]++*100 == 800) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[1] = 0;
  }
  }
      break;

    case 8639: //Battle CP Recovery Potion ��� ������������� ��������������� �P.
   if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*(10*SliderCP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[2]++*100 == 300000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[2] = 0;
  }
  }
      break;
//MP
    case 728:
   if(MyUserInfo.nCurMP < MyUserInfo.nMaxMP*(10*SliderMP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[3]++*100 == 10000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[3] = 0;
  }
  }
      break;
//HP
    case 8627:
   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[4]++*100 == 300000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[4] = 0;
  }
  }
      break;

    case 22024:
   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[5]++*100 == 15000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[5] = 0;
  }
  }
      break;
    case 1539: //Greater Healing Potion

   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[6]++*100 == 10000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[6] = 0;
  }
  }
      break;
    case 1061: //Greater Healing Potion

   if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*(10*SliderHP.GetCurrentTick())/100 && ItemPointInfo.IconPanel == TAGLLE_NAME) {

   if (TimePoint[6]++*100 == 10000) { //����� �������
	RequestUseItem(ItemPointInfo.ID);
	TimePoint[6] = 0;
  }
  }
      break;
  }
  }
  }
  }
  }

/* ������� �������� �� ����������� ID */
function bool ValidateClassID( int id ) {
     local int i;

 for ( i = 0; i < ItemClassID.Length; i++){

   if (int(ItemClassID[i]) == id)
{
    return true;
  }
  }
  }

/* ���������� ������ (��� ������) */
function OnDropItem( String a_WindowID, ItemInfo a_ItemInfo, int X, int Y) {
     local int ToIndex,fromIndex;

   if(!ValidateClassID(a_ItemInfo.ID.ClassID) ) {
    return;//������� �� ������� ���� ����� �� ��������
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

/* �������� ���� ������ ������� */
function OnDropItemSource( String strTarget, ItemInfo info ) {
     local int DeleteIndexItem;

   if ( strTarget == "Console" ) { //Console ��������� ������� ���� ������ �� ��������� ����� ��������

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

/* ����������, ���� �� ������ */
function OnClickItem( String strID, int index ) {

	TaggleItem( strID, index );
  }

/* ����������, ���� �� ������ ������ ������� ���� */
function OnRClickItem( String strID, int index ) {

	TaggleItem( strID, index );
  }

/* �������� ��������� ����� (������) */
function TaggleItem( String strID, int index ) {
     local ItemInfo infoItem;

	ItemSlotHorizontal.GetItem(index, infoItem);

   if ( !ValidateClassID(infoItem.ID.ClassID) )
    return;

  switch (strID) {

    case "ItemSlotHorizontal":

   if (infoItem.IconPanel == TAGLLE_NAME)//���� ������ ��������� ������ ����������� ������ �� ���� ��� ���������
{
	infoItem.IconPanel = "";//������ ������ ��������� ������
	ItemSlotHorizontal.SetItem(index,infoItem);
	ItemSlotVertical.SetItem(index,infoItem);
  }else{
	infoItem.IconPanel = TAGLLE_NAME; //��������� ������ �� ��������� ������
	ItemSlotHorizontal.SetItem(index,infoItem);
	ItemSlotVertical.SetItem(index,infoItem);
  }
      break;

    case "ItemSlotVertical":

   if (infoItem.IconPanel == TAGLLE_NAME) { //���� ������ ��������� ������ ����������� ������ �� ���� ��� ���������

	infoItem.IconPanel = "";//������ ������ ��������� ������
	ItemSlotVertical.SetItem(index,infoItem);
	ItemSlotHorizontal.SetItem(index,infoItem);

  }else{

	infoItem.IconPanel = TAGLLE_NAME; //��������� ������ �� ��������� ������
	ItemSlotVertical.SetItem(index,infoItem);
	ItemSlotHorizontal.SetItem(index,infoItem);
  }
      break;
  }
  }

/* ���������� ������� �� ������ */
function OnClickButton( String strID ) {

   if (strID=="OptionsAcpBtn") {

	InstalBar();//�������� ������ ����
	AddSystemMessageString("L2HELIOS.NET"); // ������ ��������� ��������� � ���
   if (IsShowWindow("BIT_AcpWnd.AcpSlotHorizontalWnd")) {
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpOptions", "BIT_AcpWnd.AcpSlotHorizontalWnd", "BottomLeft", "BottomLeft", 15,-40 );

   if (IsShowWindow("BIT_AcpWnd.AcpOptions")) {
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else{
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpOptions");
  }
  }else{
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpOptions", "BIT_AcpWnd.AcpSlotVerticalWnd", "TopLeft", "TopLeft", -200, 0 );

   if (IsShowWindow("BIT_AcpWnd.AcpOptions")) {
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else{
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpOptions");
  }
  }
  }
  }

/* �������� ������ ���� */
function InstalBar() {
 
//������� � ���������
	CPBar.SetPointPercent(IntToInt64(10*SliderCP.GetCurrentTick()), IntToInt64(0), IntToInt64(100));
	HPBar.SetPointPercent(IntToInt64(10*SliderHP.GetCurrentTick()), IntToInt64(0), IntToInt64(100));
	MPBar.SetPointPercent(IntToInt64(10*SliderMP.GetCurrentTick()), IntToInt64(0), IntToInt64(100));
  }

/* ���������� Slider */
function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick) {

  switch (strID) {

    case "CPSlider":
	CPBar.SetPointPercent(IntToInt64(100*(10*iCurrentTick)/100), IntToInt64(0), IntToInt64(100));
      break;

    case "HPSlider":
	HPBar.SetPointPercent(IntToInt64(100*(10*iCurrentTick)/100), IntToInt64(0), IntToInt64(100));
      break;

    case "MPSlider":
	MPBar.SetPointPercent(IntToInt64(100*(10*iCurrentTick)/100), IntToInt64(0), IntToInt64(100));
      break;
  }
  }

	defaultproperties{}
