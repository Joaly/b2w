package obstacles 
{
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import feathers.controls.ImageLoader;
	
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
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
			mineBoxImage.scaleX = 0.8;
			mineBoxImage.scaleY = 0.8;
			
			this.addChild(mineImage);
			this.addChild(mineBoxImage);
			
			//Ponemos las físicas a los objetos.
			mineObject = minePhysics.injectPhysics(mineImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			mineObject.physicsProperties.contactGroup = "mine";
			mineObject.physicsProperties.isSensor = true;		
			Stage1.physicsObjects.push(mineObject);
			
			mineBoxObject = minePhysics.injectPhysics(mineBoxImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			mineBoxObject.physicsProperties.contactGroup = "mineBox";
			mineBoxObject.physicsProperties.isSensor = true;
			Stage1.physicsObjects.push(mineBoxObject);
			
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
			ContactManager.onContactBegin("mine", "shot", mineShotContact, true);
			ContactManager.onContactBegin("mineBox", "player", mineExplosion, true);
			
			mineObject.body.SetLinearVelocity(new b2Vec2(0,-0.34));
			mineBoxObject.body.SetLinearVelocity(new b2Vec2(0,-0.34));
			
			mineImage.y = mineObject.y;
			mineBoxImage.y = mineBoxObject.y;
			
			if (alreadyContact || mineBoxObject.name == "explosion") mineDeath();
			
			/*mineImage.y = mineObject.y;
			mineBoxImage.y = mineBoxObject.y;*/
		}
		
		private function mineShotContact(mine:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			shot.physicsProperties.name = "bounced";
			alreadyContact = true;
		}
		
		private function mineExplosion(mine:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			player.name = "respawn";
			mine.name = "explosion";
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
			
			mineObject.physicsProperties.isDynamic = false;
			mineObject.body.GetWorld().DestroyBody(mineObject.body);
			mineObject.dispose();
			this.removeChild(mineImage);
		
			mineBoxObject.physicsProperties.isDynamic = false;
			mineBoxObject.body.GetWorld().DestroyBody(mineBoxObject.body);
			mineBoxObject.dispose();
			this.removeChild(mineBoxImage);
			
			for (var i:int; i < Stage1.physicsObjects.length; i++)
			{
				if (Stage1.physicsObjects[i] == mineObject) 
				{
					Stage1.physicsObjects.splice(i,1);
				}
				
				if (Stage1.physicsObjects[i] == mineBoxObject) 
				{
					Stage1.physicsObjects.splice(i,1);
				}
			}
			
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