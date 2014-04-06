package projectiles
{
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class Bullet extends Sprite
	{
		//Imagen disparo.
		private var bulletImage:Image;
		
		//Posición de inició del disparo.
		private var bulletStartX:Number;
		private var bulletStartY:Number;
		
		//Velocidad del disparo.
		private var bulletSpeed:Number;
		
		//Variable jugador.
		private var playerObjective:Player;
		
		//Posición donde el disparo debe ir.
		private var positionX:Number;
		private var positionY:Number;
		
		private var tween:Tween;
		
		//Físicas de la bala.
		private var bulletObject:PhysicsObject;
		private var bulletPhysics:PhysInjector;
		
		
		
		public function Bullet(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			bulletPhysics = physics;
			playerObjective = player; // Objetivo de la bala.
			bulletStartX = startX; // Posición origen de la bala.
			bulletStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createBullet); // Creamos la bala.
		}
		
		private function createBullet(event:Event):void
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, createBullet);
			
			bulletImage = new Image(Media.getTexture("Bala1"));			
			bulletImage.rotation = deg2rad(-90);
			bulletImage.x = bulletStartX; // Ponemos las coordenadas de inicio de la bala.
			bulletImage.y = bulletStartY;			
			bulletImage.scaleX = 0.04;
			bulletImage.scaleY = 0.04;
			this.addChild(bulletImage);
			
			positionX = new Number(playerObjective.position.x);
			positionY = new Number(playerObjective.position.y);
			
			bulletSpeed = new Number(20); // Inicializamos la velocidad.			
			
			bulletObject = bulletPhysics.injectPhysics(bulletImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			bulletObject.name = "bullet";
			
			tween = new Tween(bulletObject,bulletSpeed);
			
			Starling.juggler.add(tween);
			
			this.addEventListener(Event.ENTER_FRAME, movement);	// Determinamos el movimiento de la bala.
		}
		
		private function movement():void
		{
			
			tween.moveTo(positionX, positionY); //La bala irá hasta la posición donde el jugador estaba cuando el enemigo ataca.
			
			ContactManager.onContactBegin("bullet","player",playerContact);
			
			if (Math.round(tween.currentTime) == 3) //Si la bala falla (pasará como 2-3 segundos) entonces es eliminada.
			{
				this.removeEventListener(Event.ENTER_FRAME, movement);
				bulletObject.physicsProperties.isDynamic = false;
				//bulletObject.dispose();
				this.removeChild(bulletImage);
			}
		}
		
		private function playerContact(bullet:PhysicsObject, player:PhysicsObject, contact:b2Contact):void
		{
			playerObjective.isDead = true;
			this.removeFromParent();
			playerObjective.visible = false;
		}
	}
}