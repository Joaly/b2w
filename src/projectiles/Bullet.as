package projectiles
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.deg2rad;
	
	public class Bullet extends Sprite
	{
		//Imagen disparo.
		private var bulletImage:Image;
		
		//Físicas de la bala.
		private var bulletObject:PhysicsObject;
		private var bulletPhysics:PhysInjector;
		
		//Posición de inicio del disparo.
		private var bulletStartX:Number;
		private var bulletStartY:Number;
		
		//Velocidad del disparo.
		private var direction:b2Vec2;
		private var speed:Number;
		
		//Variable jugador.
		private var playerObjective:Player;
		
		//Variables para las partículas.
		private var bulletParticleConfig:XML;
		private var bulletParticle:Texture;
		private var bulletParticleSystem:PDParticleSystem;
		
		public function Bullet(physics:PhysInjector, player:Player, startX:Number, startY:Number, speed:Number)
		{
			bulletPhysics = physics;
			playerObjective = player; // Objetivo de la bala.
			bulletStartX = startX; // Posición origen de la bala.
			bulletStartY = startY;
			this.speed = speed;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createBullet); // Creamos la bala.
		}
		
		private function createBullet(event:Event):void
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, createBullet);
			
			bulletParticleConfig = new XML(Media.getXML("ParticleConfigBullet"));
			bulletParticle = Media.getTexture("ParticleBullet");
			bulletParticleSystem = new PDParticleSystem(bulletParticleConfig, bulletParticle);
			this.addChild(bulletParticleSystem);
			
			// Creamos la imagen de la bala.
			bulletImage = new Image(Media.getTexture("PlayerShot"));			
			bulletImage.scaleX = 0.04;
			bulletImage.scaleY = 0.04;
			bulletImage.pivotX = bulletImage.width/2;
			bulletImage.pivotY = bulletImage.height/2;
			this.addChild(bulletImage);
			
			// Creamos el objeto de la bala.
			bulletObject = bulletPhysics.injectPhysics(bulletImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			bulletObject.name = "bullet"+new String(Math.round(bulletStartX));
			bulletObject.physicsProperties.isSensor = true;
			bulletObject.x = bulletStartX;
			bulletObject.y = bulletStartY;			
			
			bulletParticleSystem.x = bulletObject.x;
			bulletParticleSystem.y = bulletObject.y;
			Starling.juggler.add(bulletParticleSystem);
			bulletParticleSystem.emitAngleVariance = 0;
			bulletParticleSystem.maxNumParticles = 150;
			bulletParticleSystem.scaleX = 0.6;
			bulletParticleSystem.scaleY = 0.6;
			bulletParticleSystem.speed = 1;
			bulletParticleSystem.startSize *= 0.1;
			bulletParticleSystem.emitAngle = Math.atan((bulletStartY-playerObjective.position.y)/(bulletStartX-playerObjective.position.x));
			if (bulletStartX-playerObjective.position.x < 0) bulletParticleSystem.emitAngle = Math.atan((bulletStartY-playerObjective.position.y)/(bulletStartX-playerObjective.position.x))-deg2rad(180);
			bulletParticleSystem.start();
			
			// Inicializamos la posición de la bala.			
			var speedModule:Number = new Number(Math.sqrt(Math.pow(playerObjective.position.x-bulletStartX,2)+Math.pow(playerObjective.position.y-bulletStartY,2)));
			direction = new b2Vec2((playerObjective.position.x - bulletStartX) / speedModule * speed, (playerObjective.position.y - bulletStartY) / speedModule * speed);
			
			this.addEventListener(Event.ENTER_FRAME, movement);	// Determinamos el movimiento de la bala.
		}
		
		private function movement():void
		{
			bulletObject.body.SetLinearVelocity(direction); // Actualizamos la posición de la bala según la velocidad.
			
			ContactManager.onContactBegin(bulletObject.name,"player",playerContact); // Comprobamos si la bala colisiona con el jugador.
			
			bulletParticleSystem.x = bulletObject.x;				
			bulletParticleSystem.y = bulletObject.y;
			
			if (bulletObject.name == "destroyed" || bulletObject.x < -100 || bulletObject.x > stage.stageWidth+100 || bulletObject.y < -100 || bulletObject.y > stage.stageHeight+100)
			{
				this.removeEventListener(Event.ENTER_FRAME, movement);
				bulletObject.physicsProperties.isDynamic = false;
				bulletObject.body.GetWorld().DestroyBody(bulletObject.body);
				bulletObject.dispose();
				bulletParticleSystem.stop(true);
				this.removeChild(bulletImage);
			}
		}
		
		private function playerContact(bullet:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			player.name = "respawn";
			bullet.name = "destroyed";
		}
	}
}