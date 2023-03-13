/******************************************

	Разработчик: BITHACK

	Copyright (c) 1995,2022 Ваша компания

	Описание скрипта:....

 *******************************************/
class BIT_TargetEffect extends Emitter;
  var Texture ProjectorTexture;
  var DynamicProjector TestDynamicProjector;

function PostBeginPlay(){
	Super.PostNetBeginPlay();
	TestDynamicProjector = Spawn(class'DynamicProjector', , , , Rotation);
	TestDynamicProjector.FrameBufferBlendingOp = PB_AlphaBlend;
	TestDynamicProjector.MaterialBlendingOp = PB_None;
	TestDynamicProjector.FOV = 1;

	SetTimer(0.05, false);
  }

function Tick(float deltatime){
     local rotator projectorRotation;

	TestDynamicProjector.SetDrawScale(Emitters[0].StartLocationOffset.Z/600);
	projectorRotation.Pitch = -16400;
	projectorRotation.roll = 0;
	projectorRotation.Yaw = TestDynamicProjector.Rotation.Yaw + 50;
	super.Tick(deltatime);
	TestDynamicProjector.DetachProjector();
	TestDynamicProjector.SetLocation(Location);
	TestDynamicProjector.SetRotation(projectorRotation);
	TestDynamicProjector.AttachProjector();
  }

function Timer(){
   if (TestDynamicProjector.ProjTexture.Name == 'None'){
	Emitters[0].Texture.UClampMode = TC_Clamp;
	Emitters[0].Texture.VClampMode = TC_Clamp;
	Emitters[0].Texture.bAlphaTexture = true;
	TestDynamicProjector.ProjTexture = Emitters[0].Texture;
  }
  }

event Destroyed(){
	Level.ObjectPool.FreeObject(TestDynamicProjector.ProjTexture);
	TestDynamicProjector.ProjTexture = None;
	TestDynamicProjector.NDestroy();
	Super.Destroyed();
  }

	defaultproperties{
	Begin Object class=SpriteEmitter name=SpriteEmitter0
	StartLocationOffset = (X=0,Y=0,Z=70)
	Name="SpriteEmitter0"
	End Object
	Emitters(0)=SpriteEmitter0
      bLightChanged=true
	bNoDelete=false

	Begin Object class=SpriteEmitter name=SpriteEmitter1
	Name="SpriteEmitter1"


Opacity=0.28
		FadeOutStartTime=2.7
		FadeOut=true
		FadeInEndTime=0.03
		FadeIn=true
		MaxParticles=2
		AlwaysFullSpawnRate=true
		RespawnDeadParticles=false
		StartSizeRange=(X=(Min=6.000000,Max=6.000000))
		InitialParticlesPerSecond=1000.0
		AutomaticInitialSpawning=false
		LifetimeRange=(Min=3.0,Max=3.0)

	End Object
	Emitters(1)=SpriteEmitter1


     }
     //	StartSizeRange=(X=(Min=6.000000,Max=6.000000))
