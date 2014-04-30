package obstacles 
{
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import feathers.controls.ImageLoader;
	import flash.events.TimerEvent;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Rectangle;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import flash.utils.Timer;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	

	public class Mine extends Sprite 
	{
		//Parámetros de la mina.
		private var mineImage:Image;
		private var mineBoxImage:Image;
		private var mineBoxObject:PhysicsObject;
		private var mineObject:PhysicsObject;
		private var minePhysics:PhysInjector;
		
		//Inicio de la mina.
		private var mineStartX:Number;
		private var mineStartY:Number;
		
		private var playerObjective:Player;	
		
		private var alreadyContact:Boolean;
		
		private var timer:Timer;
		
		private var particleConfig:XML;
		private var particle:Texture;
		private var particleSystem:PDParticleSystem;
		
		public function Mine(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
		{
			super();
			
			minePhysics = physics;
			playerObjective = player;
			mineStartX = startX;
			mineStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createMine);
			
		}
		
		private function createMine(event:Event):void
		{
			
			mineImage = new Image(Media.getTexture("Mine"));
			mineBoxImage = new Image(Media.getTexture("MineBox"));
			
			mineImage.pivotX = mineImage.width/2; // Centramos el punto de ancla de la imagen.
			mineImage.pivotY = mineImage.height/2;
			mineImage.scaleX = 0.5;
			mineImage.scaleY = 0.5;
			
			mineBoxImage.pivotX = mineBoxImage.width / 2; //Centramos el punto de ancla de la imagen.
			mineBoxImage.pivotY = mineBoxImage.height / 2;
			mineBoxImage.scaleX = 0.6;
			mineBoxImage.scaleY = 0.6;
			
			this.addChild(mineImage);
			this.addChild(mineBoxImage);
			
			//Ponemos las físicas a los objetos.
			mineObject = minePhysics.injectPhysics(mineImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			mineObject.name = "Mine";
			mineObject.physicsProperties.isSensor = true;
			
			mineBoxObject = minePhysics.injectPhysics(mineBoxImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:false, friction:0.5, restitution:0 } ));
			mineBoxObject.name = "MineBox";
			mineBoxObject.physicsProperties.isSensor = true;
			
			//Si el random al crear el obstaculo es menor o igual a 0.5, aparecerá a la izquierda, sino aparecerá a la derecha.
			if (mineStartX <= 0.5) mineBoxObject.x = mineBoxImage.x = mineImage.x =  mineObject.x = Stage1.OFFSET + mineImage.width / 2;
			else 
			{
				mineBoxObject.x = mineBoxImage.x = mineImage.x = mineObject.x = stage.stageWidth - Stage1.OFFSET - mineImage.width / 2;
				mineImage.scaleX *= -1;
				mineBoxImage.scaleX *= -1;
			}
			
			mineBoxImage.y = mineBoxObject.y = mineImage.y = mineObject.y = mineStartY;
			
			mineBoxImage.visible = false;
			
			timer = new Timer(10, 0);
			
			alreadyContact = new Boolean(false);
			
			this.addEventListener(Event.ENTER_FRAME, mineLoop);
		}
		
		private function mineLoop(event:Event):void
		{
			
			ContactManager.onContactBegin(mineBoxObject.name,playerObjective.name, mineContact);//Comprobamos si el jugador colisiona con la mina.
			
			for (var i:int = 0; i < Stage1.shots.length; i++) //Comprobamos si alguno de los disparos colisiona con la mina.
			{
				ContactManager.onContactBegin(mineObject.name, Stage1.shots[i].name, mineShotContact);
				if (alreadyContact) break;
			}
			if(alreadyContact) mineDeath();
		}
		
		private function mineContact(mineBox:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			player.physicsProperties.name = "respawn";
			alreadyContact = true;
		}
		
		private function mineShotContact(mine:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			shot.physicsProperties.name = "bounced";
			alreadyContact = true;
		}
		
		private function mineDeath():void //Función dedicada a realizar las partículas de la explosión para luego eliminar los objetos.
		{
			particleConfig = new XML(Media.getXML("ParticleConfig"));
			particle = Media.getTexture("Particle");
			particleSystem = new PDParticleSystem(particleConfig, particle);
			this.addChild(particleSystem);
			particleSystem.x = mineObject.x;
			particleSystem.y = mineObject.y;
			Starling.juggler.add(particleSystem);
			
			this.removeEventListener(Event.ENTER_FRAME, mineLoop);
			
			mineObject.body.GetWorld().DestroyBody(mineObject.body);
			mineObject.dispose();
			this.removeChild(mineImage);
		
			mineBoxObject.body.GetWorld().DestroyBody(mineBoxObject.body);
			mineBoxObject.dispose();
			this.removeChild(mineBoxImage);
			
			particleSystem.startSize *= 2;
			particleSystem.emitAngleVariance = 360;
			particleSystem.startColor = new ColorArgb(1.0,0.3,0.0,0.6);
			particleSystem.endColor = new ColorArgb(1.0,0.3,0.1,0.4);
			particleSystem.lifespan *= 0.5;
			particleSystem.start();
			timer.start();
			
			this.addEventListener(Event.ENTER_FRAME, particleDeath);
			
		}
		
		private function particleDeath(event:Event):void
		{
			if (timer.currentCount >= 3) particleSystem.stop();
			
			if (timer.currentCount >= 20)
			{
				particleSystem.dispose();
				this.removeEventListener(Event.ENTER_FRAME, particleDeath);
			}
		}
	}

}