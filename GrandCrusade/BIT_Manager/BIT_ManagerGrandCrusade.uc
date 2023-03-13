class BIT_ManagerGrandCrusade extends UICommonAPI;
  var StatusIconInfo f_IconInfo;
  var ItemInfo f_ToItemInfo;
  var StatusIconHandle f_StatusIcon;
  var ItemWindowHandle f_InventoryItem;
  var ItemWindowHandle f_ASkill_5;

//Перечисление ACP
	enum f_ACPenum{
	CP,HP,MP
	};

//Подключаем окна

function f_initialization(){
	f_StatusIcon = GetStatusIconHandle( "AbnormalStatusWnd.StatusIcon" );
	f_InventoryItem = GetItemWindowHandle( "InventoryWnd.InventoryItem");
	f_ASkill_5 = GetItemWindowHandle( "MagicSkillWnd.ASkill.ASkill5.ASkillScroll.ASkillItem5");
	}

//ACP если CP HP MP меньше задоного процента используем интем

function f_ACP(f_ACPenum name, int Percent, ItemID Item_Id, UserInfo MyUserInfo)
	{

    switch( name )
	{
	case CP:

    if(MyUserInfo.nCurCP < MyUserInfo.nMaxCP*Percent/100){
	RequestUseItem( Item_Id );
	}
	break;
	case HP:

    if(MyUserInfo.nCurHP < MyUserInfo.nMaxHP*Percent/100){
	RequestUseItem( Item_Id );
	}
	break;
	case MP:

    if(MyUserInfo.nCurMP < MyUserInfo.nMaxMP*Percent/100){
	RequestUseItem( Item_Id );
	}
	break;
	}
	}

//Поиск интема в инвенторе

function bool f_InventarSearchItem(int Item_Id){
 local ItemID id;
 local bool Result;
	id.ClassID = Item_Id;
	f_initialization();
	f_InventoryItem.FindItem( id );

    if (f_InventoryItem.FindItem( id ) > 0)
	Result = True;
	return Result;
	}

//Бафф откат

function Bool f_BaffStatus(ItemInfo BaffItem){ //откат бафа в бафах
 local int i, j;
	Local bool NoIconInfo;
	f_initialization();
	for (i=0; i<f_StatusIcon.GetRowCount(); i++)
	{
	for (j = 0 ; j < f_StatusIcon.GetColCount(i) ; j++ )
	{
	f_StatusIcon.GetItem(i, j, f_IconInfo);

    if ( BaffItem.itemSubType == 2 && f_IconInfo.id == BaffItem.ID){ //Если скил && BaffItem.ID == f_IconInfo.Id
	NoIconInfo = True;

    if (f_IconInfo.RemainTime < 5 ){
	return True;
	}else{
	return False;
	}
	}

    if(BaffItem.itemSubType == 3 && f_IconInfo.IconName == BaffItem.IconName){ //Если бутыли Авто припасы
	NoIconInfo = True;

    if (f_IconInfo.RemainTime < 5 ){
	return True;
	}else{
	return False;
	}
	}
	}}
	If (!NoIconInfo && f_IconInfo.id != BaffItem.ID){//Если интема нет на панеле баф и ID не совподает (не бафнут)
	return True;
	}
	}

//Скил Disabled Enabled проверяет можно ли использовать скилл

function f_ApplySkillAvailability(ItemWindowHandle IntemWindow){
 local int Count;
 local int f;
 local UserInfo user;
 local int i;
 local array<ItemInfo> ItemDisabled[200];//Пришлось добавить размер массива иначе не работает
	Count = user.nJewelNum;
	for (i = 0; i < IntemWindow.GetItemNum(); i++) {
	IntemWindow.GetItem(i, ItemDisabled[i]);

    if (ItemDisabled[i].ItemSubType == 2){
	IntemWindow.SetItemSkillDisabled(i,GetSkillAvailability(ItemDisabled[i].ID.ClassID, ItemDisabled[i].level, ItemDisabled[i].subLevel) );
	}

//Проверк Камней , брошек шмот одет или нет

    if ( f_InventarSearchItem(ItemDisabled[i].id.ClassID) && ItemDisabled[i].ItemSubType == 1){

// IntemWindow.SetItemSkillDisabled(i,4 );
	ItemDisabled[i].bDisabled = 4;
	IntemWindow.SetItem(i,ItemDisabled[i]);

// AddSystemMessageString("ddd"); // Вывыод системных сообщений в чат
	}else{
	ItemDisabled[i].bDisabled = 0;
	IntemWindow.SetItem(i,ItemDisabled[i]);
	}
	}
	}
/*
	Работа с панелью ItemWindow
*/

//Очистить всю панель при стаарте игры (Обязательно!!!)

function f_ItemNewEmpty(ItemWindowHandle IntemWindow, int ItemMaxNum){
 local int i;
 local ItemInfo Empty;
	for (i = 0; i < ItemMaxNum; i++ ){
	IntemWindow.AddItem(Empty);//Создадим пустые массивы (иначе не работает)
	}
	}

//Удалить интемы с панели

function f_ItemDeleteAll(ItemWindowHandle IntemWindow, int ItemMaxNum){
 local int i;
 local ItemInfo Empty;
	for (i = 0; i < ItemMaxNum; i++ ){
	IntemWindow.SetItem(i, Empty);//Создадим пустые массивы (иначе не работает)
	}
	}

//Очистить по index item

function f_ItemClearIndex(ItemWindowHandle IntemWindow, int ItemIndex){
 local ItemInfo Empty;
	IntemWindow.SetItem(ItemIndex, Empty);//Создадим пустые массивы (иначе не работает)
	}

//Вставить интем

function f_SetItem(ItemWindowHandle IntemWindow, ItemInfo infItem, int x, int y ){
 local int ToIndex, fromIndex;

//Меняем местами ячейки
	ToIndex = IntemWindow.GetIndexAt(x, y, 1, 1);
	fromIndex = IntemWindow.FindItem(infItem.ID);
	IntemWindow.SwapItems( fromIndex, ToIndex );

//Вставим интем в ячеку
	IntemWindow.SetItem(ToIndex,infItem);
	}

//Удалить выбрасываемый интем

function f_ItemOutDrop(ItemWindowHandle IntemWindow,ItemInfo infItem){
 local ItemInfo Empty;
	IntemWindow.SetItem(IntemWindow.FindItem(infItem.ID),Empty);
	}
/*
	Конец Работа с панелью ItemWindow
*/

//Нажать на ячейку шоркут

function f_ShortcutPress(int Slot_id ){
class'ShortcutAPI'.static.ExecuteShortcutBySlot(Slot_id);
	}

//Чужое CP HP MP

function int f_TargetInfo(f_ACPenum name , UserInfo TargetInfo){

    switch( name )
	{
	case CP:
	return TargetInfo.nCurCP;
	break;
	case HP:
	return TargetInfo.nCurHP;
	break;
	case MP:
	return TargetInfo.nCurMP;
	break;
	}
	}

//Получить актор

function Actor f_GetActor(){
 local Actor Act;
	Act = class'UIDATA_TARGET'.static.GetTargetActor();
	return Act;
	}

//Склеим Имя и субкласc (Требуется при сохранение в INI)

function string f_NickTogetherSubClass(UserInfo MyUserInfo){
 local string NickSubClass;
	NickSubClass = f_ReplaceText(MyUserInfo.Name, " ", "");
	NickSubClass = NickSubClass$f_ReplaceText(GetClassType(MyUserInfo.nSubClass), " ", "");
	return NickSubClass;
	}

// Подготовим Скилл для добавления на панель

function ItemInfo f_MagicSkillInfo(ItemID GetID){
 local SkillInfo SkillInfoItem;
 local ItemInfo Intem;
	Class 'UIDATA_ITEM'.static.GetItemInfo(GetID, Intem);//Получим инфу интема по ид
	GetSkillInfo(Intem.ID.ClassID, Intem.Level, Intem.SubLevel, SkillInfoItem ); //bool MagicSkill
	Intem.Name = SkillInfoItem.SkillName;
	Intem.Level = SkillInfoItem.SkillLevel;
	Intem.SubLevel = SkillInfoItem.SkillSubLevel;
	Intem.IconName = SkillInfoItem.TexName;
	Intem.Description = SkillInfoItem.SkillDesc;
	Intem.AdditionalName = SkillInfoItem.EnchantName;
	Intem.IconNameEx1 = SkillInfoItem.AnimName;
	Intem.MpConsume = SkillInfoItem.MpConsume;
	Intem.ItemSubType = int(EShortCutItemType.SCIT_SKILL);

//Если у интема нет рамки

    if (SkillInfoItem.IconPanel == "") {
	Intem.IconPanel = "";//Не добавляем рамку
	} else {
	Intem.IconPanel = SkillInfoItem.IconPanel; //если есть рамка у иконки добавим
	SkillInfoItem.IconPanel = "";
	}

//Выведим на панель
	return Intem;
	}

//функция ReplaceText

function string f_ReplaceText(string Text, string Replace, string With)
	{
 local int i;
 local string Input;
	Input = Text;
	Text = "";
	i = InStr(Input, Replace);
	while(i != -1)
	{
	Text = Text $ Left(Input, i) $ With;
	Input = Mid(Input, i + Len(Replace));
	i = InStr(Input, Replace);
	}
	return Text $ Input;
	}
	defaultproperties{}
