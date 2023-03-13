/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2020 Ваша компания

	Описание скрипта:Панелька Shortcut

 *******************************************/

class BIT_ShortcutWnd extends UICommonAPI;
  const MAX_Page = 10;
  const MAX_ShortcutPerPage = 12;
  const MAX_Pnel = 7;
  var int CurrentShortcutPage[MAX_Pnel];
  var int VisiblePagesCount;
  var bool m_IsLocked;
  var bool m_IsVertical;
  var bool m_IsShortcutExpand;
  var String m_ShortcutWndName;
  var WindowHandle Me;

function OnLoad()
{
     local bool bMinTooltip;
     local Tooltip Script;
     local int i;

	RegisterEvent( EV_ShortcutUpdate );
	RegisterEvent( EV_ShortcutPageUpdate );
	RegisterEvent( EV_ShortcutClear );
	RegisterEvent( EV_ShortcutCommandSlot );
	RegisterEvent( EV_ShortcutkeyassignChanged );
	RegisterEvent( EV_SetEnterChatting );
	RegisterEvent( EV_UnSetEnterChatting );

	Me = GetWindowHandle( "ShortcutWnd" );

//Load Ini
	m_IsLocked = GetOptionBool( "Game", "IsLockShortcutWnd" );

 for( i=1; i <= MAX_Pnel; i++ )
{

   if (GetOptionBool( "Game", "Is"$i$"ExpandShortcutWnd" )){
	VisiblePagesCount++;
  }
  }
	m_IsVertical = GetOptionBool( "Game", "IsShortcutWndVertical" );
	InitShortPageNum();

	bMinTooltip = GetOptionBool( "Game", "IsShortcutWndMinTooltip" );
	Script = Tooltip( GetScript( "Tooltip" ) );
	Script.setBoolSelect( !bMinTooltip );

   if( bMinTooltip )
{
	HideWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn" );
	ShowWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn" );
	ShowWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMinBtn" );
  }
    else
{
	ShowWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn" );
	ShowWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMinBtn" );
  }

  }

//По умолчанию

function OnDefaultPosition()
{
	Reduce();
	SetVertical(true);
	InitShortPageNum();
	ArrangeWnd();
	ExpandWnd();

   if (GetOptionInt( "Game", "LayoutDF" ) == 1)
{

	SetVertical(false);
  }
  }

function OnEnterState( name a_PreStateName )
{
	ArrangeWnd();
	ExpandWnd();
	AcpItem(0);
	HandleExpandButton();

   if( a_PreStateName == 'LoadingState' )
	InitShortPageNum();
//Если панельки были открыты покажем их
   if (GetOptionBool( "BIT_DopShortcut", "Visible" )){
class'UIAPI_WINDOW'.static.ShowWindow( "BIT_DopShortcut" );
class'UIAPI_WINDOW'.static.ShowWindow( "BIT_DopPanelTalismanWnd" );
  }
  }

//Инстализация нумерация панельки

function InitShortPageNum()
{
     local int i;

 for( i=0; i < MAX_Pnel; i++ )
{
	CurrentShortcutPage[i] = i;

  }
	AcpItem(VisiblePagesCount);
  }

function OnEvent( int a_EventID, String a_Param )
{

  switch( a_EventID )
{
    case EV_ShortcutCommandSlot:
	ExecuteShortcutCommandBySlot(a_Param);
      break;
    case EV_ShortcutPageUpdate:
	HandleShortcutPageUpdate( a_Param );
      break;

    case EV_ShortcutUpdate:
	HandleShortcutUpdate( a_Param );
      break;

    case EV_ShortcutClear:
// HandleShortcutClear();
// ArrangeWnd();
// ExpandWnd();

      break;
    case EV_ShortcutkeyassignChanged:
    case EV_SetEnterChatting:
    case EV_UnSetEnterChatting:
	ClearAllShortcutItemTooltip();
      break;
  }
  }

function ClearAllShortcutItemTooltip()
{
	Me.ClearAllChildShortcutItemTooltip();
  }

//Кпоки перелистывания шоркутов

function HandleShortcutPageUpdate(string param)
{
     local int nShortcutID;
     local int ShortcutPage;
     local int i;
// AddSystemMessageString("HandleShortcutPageUpdate"); // Вывыод системных сообщений в чат
   if( ParseInt(param, "ShortcutPage", ShortcutPage) )
{

   if( 0 > ShortcutPage || MAX_Page <= ShortcutPage )
    return;

	CurrentShortcutPage[0] = ShortcutPage;

class'UIAPI_TEXTBOX'.static.SetText( "ShortcutWnd." $ m_ShortcutWndName $ ".PageNumTextBox", string( CurrentShortcutPage[0]+ 1 ) );

	nShortcutID = CurrentShortcutPage[0] * MAX_ShortcutPerPage;

 for( i =0; i <= MAX_ShortcutPerPage; ++i )
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "ShortcutWnd." $ m_ShortcutWndName $ ".Shortcut" $ ( i + 1 ), nShortcutID );
	nShortcutID++;

  }
  }

  }

//Активация скила - перетаскивание

function HandleShortcutUpdate(string param)
{
     local int i;
     local int nShortcutID;
     local int nShortcutNum;

	ParseInt(param, "ShortcutID", nShortcutID);
	nShortcutNum = ( nShortcutID % MAX_ShortcutPerPage ) + 1;

   if( IsShortcutIDInCurPage( CurrentShortcutPage[0], nShortcutID ) )
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "ShortcutWnd." $ m_ShortcutWndName $ ".Shortcut" $ nShortcutNum, nShortcutID );
  }

 for( i= 0; i <= MAX_Pnel ; ++i )
{

   if( IsShortcutIDInCurPage( CurrentShortcutPage[i+1], nShortcutID ) ){
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "ShortcutWnd." $ m_ShortcutWndName $ "_"$i+ 1$".Shortcut" $ nShortcutNum, nShortcutID );

  }
  }

  }

//Отчиска чегото

function HandleShortcutClear()
{
     local int i;

 for( i=0; i <= MAX_ShortcutPerPage ; ++i )
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear( "ShortcutWnd.ShortcutWndVertical.Shortcut" $ (i+1));
class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear( "ShortcutWnd.ShortcutWndHorizontal.Shortcut" $ (i+1));
class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear( "ShortcutWnd.ShortcutWndVertical_"$i$".Shortcut" $ (i+1));
class'UIAPI_SHORTCUTITEMWINDOW'.static.Clear( "ShortcutWnd.ShortcutWndHorizontal_"$i$".Shortcut" $ (i+1));
  }
  }

function OnClickButton( string a_strID )
{
     local string PrevBtn,NextBtn;
     local int nNewPage;
     local int i;

 for( i=0; i <= MAX_Pnel; i++ )
{
	PrevBtn= "PrevBtn"$i;
	NextBtn= "NextBtn"$i;

   if (a_strID == PrevBtn) {
	nNewPage = CurrentShortcutPage[i] - 1;

   if( 0 > nNewPage )
	nNewPage = MAX_Page - 1;
	MyOnPrevBtn(i,nNewPage);
  }

   if (a_strID == NextBtn) {
	nNewPage = CurrentShortcutPage[i] + 1;

   if( MAX_Page <= nNewPage )
	nNewPage = 0;
	MyOnPrevBtn(i,nNewPage);
  }
  }

  switch( a_strID )
{

    case "LockBtn":
	OnClickLockBtn();
      break;

    case "UnlockBtn":
	OnClickUnlockBtn();
      break;

    case "RotateBtn":
	OnRotateBtn();
      break;

    case "ExpandBtn":
	OnExpandBtn();
      break;

    case "ExpandButton":
	OnClickExpandShortcutButton();
      break;

    case "ReduceButton":
	OnClickExpandShortcutButton();
      break;

    case "TooltipMinBtn":
	OnMinBtn();
      break;

    case "TooltipMaxBtn":
	OnMaxBtn();
      break;

//Открооем доп панельки
    case "DopPanelBtn":
   if (class'UIAPI_WINDOW'.static.IsShowWindow("BIT_DopShortcut")){
class'UIAPI_WINDOW'.static.HideWindow( "BIT_DopShortcut" );
class'UIAPI_WINDOW'.static.HideWindow( "BIT_DopPanelTalismanWnd" );
  }else{
class'UIAPI_WINDOW'.static.ShowWindow( "BIT_DopShortcut" );
class'UIAPI_WINDOW'.static.ShowWindow( "BIT_DopPanelTalismanWnd" );

  }

      break;

  }
  }

//Моя функция перелистывание панелек внутри

function MyOnPrevBtn(int Page,int nNewPage){
     local int nShortcutID;
     local int i;

   if (Page == 0){
// AddSystemMessageString("Page 0"); // Вывыод системных сообщений в чат
class'ShortcutAPI'.static.SetShortcutPage( nNewPage );

  }else{

   if(0 > nNewPage || MAX_Page <= nNewPage )
    return;

	CurrentShortcutPage[Page] = nNewPage;

// AddSystemMessageString("Page"@Page); // Вывыод системных сообщений в чат

class'UIAPI_TEXTBOX'.static.SetText( "ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_"$Page $ ".PageNumTextBox", string( CurrentShortcutPage[Page]+1 ) );
	nShortcutID = CurrentShortcutPage[Page] * MAX_ShortcutPerPage;

 for( i = 0; i < MAX_ShortcutPerPage; ++i )
{
class'UIAPI_SHORTCUTITEMWINDOW'.static.UpdateShortcut( "ShortcutWnd." $ m_ShortcutWndName $ "." $ m_ShortcutWndName $ "_"$Page $".Shortcut" $( i+1 ), nShortcutID );
	nShortcutID++;

  }
  }

  }

function OnMinBtn()
{
     local Tooltip Script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();

	Script = Tooltip( GetScript( "Tooltip" ) );
	Script.setBoolSelect( true );

// 2010.8.23 - winkey
	ShowWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn" );
	ShowWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMinBtn" );

	SetOptionBool( "Game", "IsShortcutWndMinTooltip", false );
  }

function OnMaxBtn()
{
     local Tooltip Script;

	HandleShortcutClear();
	ArrangeWnd();
	ExpandWnd();

	Script = Tooltip( GetScript( "Tooltip" ) );
	Script.setBoolSelect( false );

// 2010.8.23 - winkey
	ShowWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMinBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndHorizontal.TooltipMaxBtn" );
	ShowWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMinBtn" );
	HideWindow( "ShortcutWnd.ShortcutWndVertical.TooltipMaxBtn" );

	SetOptionBool( "Game", "IsShortcutWndMinTooltip", true );
  }

function OnClickLockBtn()
{
	UnLock();
  }

function OnClickUnlockBtn()
{
	Lock();
  }

function OnRotateBtn()
{
	SetVertical( !m_IsVertical );

   if( m_IsVertical )
{
class'UIAPI_WINDOW'.static.SetAnchor( "ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0 );
class'UIAPI_WINDOW'.static.ClearAnchor( "ShortcutWnd.ShortcutWndVertical" );
class'UIAPI_WINDOW'.static.SetAnchor( "ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0 );
	AcpItem(VisiblePagesCount);

// ChatMessageSystem( "Horizontal" );
  }
    else
{

// ChatMessageSystem( "Vertical" );
class'UIAPI_WINDOW'.static.SetAnchor( "ShortcutWnd.ShortcutWndHorizontal", "ShortcutWnd.ShortcutWndVertical", "BottomRight", "BottomRight", 0, 0 );
class'UIAPI_WINDOW'.static.ClearAnchor( "ShortcutWnd.ShortcutWndHorizontal" );
class'UIAPI_WINDOW'.static.SetAnchor( "ShortcutWnd.ShortcutWndVertical", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0, 0 );
	AcpItem(VisiblePagesCount);
  }
class'UIAPI_WINDOW'.static.SetFocus( "ShortcutWnd." $ m_ShortcutWndName );
	HandleExpandButton();
  }

function OnExpandBtn()
{
class'UIAPI_WINDOW'.static.SetFocus( "ShortcutWnd." $ m_ShortcutWndName );
	ArrangeWnd();
  }

function bool IsShortcutIDInCurPage( int PageNum, int a_nShortcutID )
{

   if( PageNum * MAX_ShortcutPerPage > a_nShortcutID )
    return false;

   if( ( PageNum + 1 ) * MAX_ShortcutPerPage <= a_nShortcutID )
    return false;
    return true;
  }

function Lock()
{
	m_IsLocked = true;
	SetOptionBool( "Game", "IsLockShortcutWnd", true );

   if( IsShowWindow( "ShortcutWnd" ) )
{
	ShowWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".LockBtn" );
	HideWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".UnlockBtn" );
  }
  }

function UnLock()
{
	m_IsLocked = false;
	SetOptionBool( "Game", "IsLockShortcutWnd", false );

   if( IsShowWindow( "ShortcutWnd" ) )
{
	ShowWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".UnlockBtn" );
	HideWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".LockBtn" );
  }
  }

//Вертикальная панелька включить выключить

function SetVertical( bool a_IsVertical )
{
	m_IsVertical = a_IsVertical;
	SetOptionBool( "Game", "IsShortcutWndVertical", m_IsVertical );
	ArrangeWnd();
	ExpandWnd();

  }

//Поворот панелек вертикаль горизонталь

function ArrangeWnd()
{
     local Rect WindowRect;
     local int i ;
// AddSystemMessageString("ArrangeWnd"@++msg); // Вывыод системных сообщений в чат
   if( m_IsVertical )
{
	m_ShortcutWndName = "ShortcutWndVertical";
	WindowRect = class'UIAPI_WINDOW'.static.GetRect( "ShortcutWnd.ShortcutWndVertical" );

   if( WindowRect.nY < 0 )
class'UIAPI_WINDOW'.static.MoveTo( "ShortcutWnd.ShortcutWndVertical", WindowRect.nX, 0 );
	HideWindow( "ShortcutWnd.ShortcutWndHorizontal" );
	ShowWindow( "ShortcutWnd.ShortcutWndVertical" );
  }
    else
{
	m_ShortcutWndName = "ShortcutWndHorizontal";
	WindowRect = class'UIAPI_WINDOW'.static.GetRect( "ShortcutWnd.ShortcutWndHorizontal" );

   if( WindowRect.nX < 0 )
class'UIAPI_WINDOW'.static.MoveTo( "ShortcutWnd.ShortcutWndHorizontal", 0, WindowRect.nY );
	HideWindow( "ShortcutWnd.ShortcutWndVertical" );
	ShowWindow( "ShortcutWnd.ShortcutWndHorizontal" );
  }

   if( m_IsLocked )
	Lock();
    else
	UnLock();

 for( i=0; i <= MAX_Pnel; i++ )
{
	MyOnPrevBtn(i,CurrentShortcutPage[i]);
  }
  }

//загрузить панельки при старте

function ExpandWnd()
{
     local int i;

 for( i=0; i <= VisiblePagesCount; i++ )
{
	AddPanel(i);
  }
  }

//Добавление и сброс панелек до первой если показаны все панельки

function OnClickExpandShortcutButton()
{
	VisiblePagesCount++;

   if (MAX_Pnel <= VisiblePagesCount) {
	Reduce();
  } else{
	AddPanel(VisiblePagesCount);
  }
  }

//Сбросить панельки до первой

function Reduce()
{
     local int i;

 for( i=1; i <= MAX_Pnel; i++ )
{
	SetOptionBool( "Game", "Is"$i$"ExpandShortcutWnd", False );
class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndVertical_"$i);
class'UIAPI_WINDOW'.static.HideWindow("ShortcutWnd.ShortcutWndHorizontal_"$i);
  }
	VisiblePagesCount = 0;
	HandleExpandButton();
	AcpItem(0);
  }

//Добавить панельку +1

function AddPanel(int count)
{

// m_IsExpand[count] = int(true);
	SetOptionBool( "Game", "Is"$count$"ExpandShortcutWnd", True );
class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndVertical_"$count);
class'UIAPI_WINDOW'.static.ShowWindow("ShortcutWnd.ShortcutWndHorizontal_"$count);
	HandleExpandButton();
	AcpItem(count);
  }

//AcpItem И поворот панелек

function AcpItem(int count){

   if(count==0 && !m_IsVertical ){

//AcpSlotHorizontal выводим над первой панедькой
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpSlotHorizontalWnd", "ShortcutWnd.ShortcutWndHorizontal", "BottomRight", "BottomRight", 0,-50 );
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else if(!m_IsVertical){

//выводим над Остальными
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpSlotHorizontalWnd", "ShortcutWnd.ShortcutWndHorizontal_"$count, "BottomRight", "BottomRight", 0,-50 );
  }

   if(count==0 && m_IsVertical ){

//AcpSlotVertical
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpSlotVerticalWnd", "ShortcutWnd.ShortcutWndVertical", "TopLeft", "TopLeft", -30,0 );
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpOptions");
  }else if(m_IsVertical){

//выводим над Остальными
class'UIAPI_WINDOW'.static.ShowWindow("BIT_AcpWnd.AcpSlotVerticalWnd");
class'UIAPI_WINDOW'.static.HideWindow("BIT_AcpWnd.AcpSlotHorizontalWnd");
class'UIAPI_WINDOW'.static.SetAnchor( "BIT_AcpWnd.AcpSlotVerticalWnd", "ShortcutWnd.ShortcutWndVertical_"$count, "TopLeft", "TopLeft", -30,0 );
  }
  }

//Иконка добавления панельки и сброс

function HandleExpandButton()
{
	m_IsShortcutExpand = true;

   if (VisiblePagesCount+1 == MAX_Pnel) {
	m_IsShortcutExpand = false;
  }

   if( m_IsShortcutExpand )
{
	ShowWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".ExpandButton" );
	HideWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".ReduceButton" );
  }
    else
{
	HideWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".ExpandButton" );
	ShowWindow( "ShortcutWnd." $ m_ShortcutWndName $ ".ReduceButton" );
  }
  }

//Нажатие на слот f1-f12
function ExecuteShortcutCommandBySlot(string param)
{
     local int slot;
	ParseInt(param, "Slot", slot);
class'ShortcutAPI'.static.ExecuteShortcutBySlot(slot);

  }
/*
function ExecuteShortcutCommandBySlot(string param)
{
     local int slot,i;
	ParseInt(param, "Slot", slot);

 for( i = 0; i < MAX_ShortcutPerPage; ++i )
{
   if( slot >=0 && slot < MAX_ShortcutPerPage ) // bottom
{
class'ShortcutAPI'.static.ExecuteShortcutBySlot(CurrentShortcutPage[i]*MAX_ShortcutPerPage + slot);
  }
  }
  } */


	defaultproperties
{
	m_IsVertical=True
  }
