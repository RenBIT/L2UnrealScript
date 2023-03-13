/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:....

 *******************************************/
class BIT_TargetLoad extends UICommonAPI;

	#exec Texture Import File=Textures/damage/Indicator.dds Name=Indicator Mips=Off MASKED=1
	#exec Texture Import File=Textures/Target/Target.dds Name=Target Mips=Off MASKED=1

  var Emitter MyEmitter;

function OnRegisterEvent(){ /* Регистрация игровых событий */
	RegisterEvent( EV_ReceiveTargetLevelDiff );
	RegisterEvent( EV_TargetUpdate );
  }

function OnEvent(int Event_ID, string param) { /* Обработчик игровых событий */
  switch( Event_ID ){
    case EV_ReceiveTargetLevelDiff:
	SpawnTargetEffect();
      break;
    case EV_TargetUpdate:
	DestroyTargetEffect();
      break;
  }
  }

function Load() { /* Выполняется при старте игры */
// AddSystemMessageString("TEST"); //Вывыод системных сообщений в чат
	OnRegisterEvent();
  }



function SpawnTargetEffect(){
     local UserInfo info;
     local Actor MyActor;

	MyActor = class'UIDATA_TARGET'.static.GetTargetActor();
	GetUserInfo(class'UIDATA_TARGET'.static.GetTargetID() , info);

	MyEmitter = Pawn(MyActor).Spawn(class'BIT_TargetEffect', Pawn(MyActor), , info.Loc, rot(0,0,0));
	MyEmitter.SetBase(Pawn(MyActor));

	MyEmitter.Emitters[0].StartLocationOffset.Z = Pawn(MyActor).CollisionRadius*10;//Задается размер картинки CollisionRadius*10
	MyEmitter.Emitters[0].Texture = Texture'Target';//Текстру можно взять и из своего UTX
	MyEmitter.Emitters[0].Disabled = true; //Отключаем частицы выводим 1 картинку

 MyEmitter.Emitters[1].StartLocationOffset.Z = Pawn(MyActor).CollisionHeight+12;

 //Texture(DynamicLoadObject("Indicator");
 MyEmitter.Emitters[1].Texture = Texture(DynamicLoadObject("bit.bit.Indicator", class'Texture'));//Текстру можно взять и из своего UTX
  }

function DestroyTargetEffect() {


   if(class'UIAPI_WINDOW'.static.IsShowWindow("TargetStatusWnd") )
{
	MyEmitter.NDestroy();
	MyEmitter = None;

  }
  }
	defaultproperties{}

