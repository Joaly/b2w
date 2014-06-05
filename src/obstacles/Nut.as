package obstacles 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import feathers.controls.ImageLoader;
	import feathers.controls.NumericStepper;
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
	
	public class Nut extends Sprite 
	{
		//Parámetros de la tuerca.
		private var nutImage:Image;
		private var nutCoverImage:Image;
		private var nutAgarreImage:Image;
		private var nutObject:PhysicsObject;
		private var nutPhysics:PhysInjector;
		
		//Inicio de la tuerca.
		private var nutStartX:Number;
		private var nutStartY:Number;
		
		private var playerObjective:Player;
		
		private var speedX:Number;
		private var speedY:Number;
		private var nutSpeed:b2Vec2;
		private var angle:Number;
		
		private var nutParticleConfig:XML;
		private var nutParticle:Texture;
		private var nutParticleSystem:PDParticleSystem;
		
		public function Nut(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
		{
			super();
			
			nutPhysics = physics;
			playerObjective = player;
			nutStartX = startX;
			nutStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createNut);
		}
		
		private function createNut(event:Event):void
		{
			nutParticleConfig = new XML(Media.getXML("ParticleConfigNut"));
			nutParticle = Media.getTexture("ParticleNut");
			nutParticleSystem = new PDParticleSystem(nutParticleConfig, nutParticle);
			this.addChild(nutParticleSystem);
			
			nutImage = new Image(Media.getTexture("Nut"));
			nutAgarreImage = new Image(Media.getTexture("AgarreNut"));
			nutCoverImage = new Image(Media.getTexture("CoverNut"));
			Stage1.imagesToMove.push(nutCoverImage);
			
			nutImage.pivotX = nutImage.width/2; // Centramos el punto de ancla de la imagen.
			nutImage.pivotY = nutImage.height/2;
			nutImage.scaleX = 0.23;
			nutImage.scaleY = 0.23;
			
			nutAgarreImage.pivotX = nutAgarreImage.width/2; // Centramos el punto de ancla de la imagen.
			nutAgarreImage.pivotY = nutAgarreImage.height/2;
			nutAgarreImage.scaleX = 0.2;
			nutAgarreImage.scaleY = 0.2;
			
			nutCoverImage.pivotX = nutCoverImage.width / 2; //Centramos el punto de ancla de la imagen.
			nutCoverImage.pivotY = nutCoverImage.height / 2;
			nutCoverImage.scaleX = 0.2;
			nutCoverImage.scaleY = 0.3;
			
			this.addChild(nutImage);
			this.addChild(nutCoverImage);
			this.addChild(nutAgarreImage);
			
			//Ponemos las físicas al objeto.
			nutObject = nutPhysics.injectPhysics(nutImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			nutObject.physicsProperties.contactGroup = "nut";
			nutObject.physicsProperties.isSensor = true;
			Stage1.physicsObjects.push(nutObject);
			
			//Si el random al crear el obstaculo es menor o igual a 0.5, aparecerá a la izquierda, sino aparecerá a la derecha.
			
			if (nutStartX <= 0.5) 
			{
				nutCoverImage.x =  Stage1.OFFSET + nutCoverImage.width / 2;
				nutAgarreImage.x = nutCoverImage.x + nutAgarreImage.width / 4;
				nutObject.x = nutImage.x = nutAgarreImage.x + nutAgarreImage.width / 2,
				angle = new Number(2);
			}
			else 
			{
				nutCoverImage.x = stage.stageWidth - Stage1.OFFSET - nutCoverImage.width / 2;
				nutCoverImage.scaleX *= -1;
				nutAgarreImage.x = nutCoverImage.x - nutAgarreImage.width / 4;
				nutObject.x = nutImage.x = nutAgarreImage.x - nutAgarreImage.width / 2;
				angle = new Number(-2);
			}
			
			nutCoverImage.y = nutObject.y = nutImage.y = nutStartY;
			
			
			speedX = new Number(0);
			speedY = new Number(0.25);
			
			nutSpeed = new b2Vec2(speedX, speedY);
			
			nutParticleSystem.x = nutObject.x;
			nutParticleSystem.y = nutObject.y;
			nutParticleSystem.scaleX = 0.5;
			nutParticleSystem.scaleY = 0.47;
			Starling.juggler.add(nutParticleSystem);
			nutParticleSystem.start();
			
			this.addEventListener(Event.ENTER_FRAME, nutLoop);
		}
		
		private function nutLoop(event:Event):void
		{
			nutAgarreImage.y = nutObject.y;
			nutParticleSystem.y = nutObject.y;
			nutObject.rotation += angle;
			
			nutObject.body.SetLinearVelocity(nutSpeed); //Aplicamos velocidad a la tuerca.
			
			if (Math.round(nutObject.y) >= nutCoverImage.y + nutCoverImage.height/2 - 20) 
			{
				nutObject.y -= 1;
				nutSpeed.y = -1;
				if (nutStartX <= 0.5) angle = -2;
				else angle = 2;
			}
			
			if (Math.round(nutObject.y) <= nutCoverImage.y - nutCoverImage.height/2 + 20) 
			{
				nutObject.y += 1;
				nutSpeed.y = 0.25;
				if (nutStartX <= 0.5) angle = 2;
				else angle = -2;
			}
			
			ContactManager.onContactBegin("nut", "player", playerDeath, true);
		}
		
		private function playerDeath(nut:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			player.name = "respawn";
		}
		
	}
}