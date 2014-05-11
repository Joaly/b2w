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
			nutCoverImage = new Image(Media.getTexture("CoverNut"));
			
			nutImage.pivotX = nutImage.width/2; // Centramos el punto de ancla de la imagen.
			nutImage.pivotY = nutImage.height/2;
			nutImage.scaleX = 0.26;
			nutImage.scaleY = 0.26;
			
			nutCoverImage.pivotX = nutCoverImage.width / 2; //Centramos el punto de ancla de la imagen.
			nutCoverImage.pivotY = nutCoverImage.height / 2;
			nutCoverImage.scaleX = 0.25;
			nutCoverImage.scaleY = 0.35;
			
			this.addChild(nutImage);
			this.addChild(nutCoverImage);
			
			//Ponemos las físicas al objeto.
			nutObject = nutPhysics.injectPhysics(nutImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			nutObject.physicsProperties.contactGroup = "nut";
			nutObject.physicsProperties.isSensor = true;
			
			//Si el random al crear el obstaculo es menor o igual a 0.5, aparecerá a la izquierda, sino aparecerá a la derecha.
			
			if (nutStartX <= 0.5) 
			{
				nutCoverImage.x =  Stage1.OFFSET + nutCoverImage.width / 2;
				nutObject.x = nutImage.x = nutCoverImage.x;
				angle = new Number(3);
			}
			else 
			{
				nutCoverImage.x = stage.stageWidth - Stage1.OFFSET - nutCoverImage.width / 2;
				nutObject.x = nutImage.x = nutCoverImage.x;
				angle = new Number(-3);
			}
			
			nutCoverImage.y = nutObject.y = nutImage.y = nutStartY;
			
			
			speedX = new Number(0);
			speedY = new Number(0.25);
			
			nutSpeed = new b2Vec2(speedX, speedY);
			
			nutParticleSystem.x = nutObject.x;
			nutParticleSystem.y = nutObject.y;
			nutParticleSystem.scaleX = 0.4;
			nutParticleSystem.scaleY = 0.46;
			Starling.juggler.add(nutParticleSystem);
			nutParticleSystem.start();
			
			this.addEventListener(Event.ENTER_FRAME, nutLoop);
		}
		
		private function nutLoop(event:Event):void
		{
			nutObject.body.SetLinearVelocity(nutSpeed); //Aplicamos velocidad a la tuerca.
			nutParticleSystem.y = nutObject.y;
			nutObject.rotation += angle;
			
			if (Math.round(nutObject.y) >= nutStartY + nutCoverImage.height/2 - nutImage.height/4) 
			{
				nutObject.y -= 1;
				nutSpeed.y = -1;
				if (nutStartX <= 0.5) angle = -3;
				else angle = 3;
			}
			
			if (Math.round(nutObject.y) <= nutStartY - nutCoverImage.height/2 + nutImage.height/4) 
			{
				nutObject.y += 1;
				nutSpeed.y = 0.25;
				if (nutStartX <= 0.5) angle = 3;
				else angle = -3;
			}
			
			ContactManager.onContactBegin("nut", "player", playerDeath, true);
		}
		
		private function playerDeath(nut:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			player.name = "respawn";
		}
		
	}
}