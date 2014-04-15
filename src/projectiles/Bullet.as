package projectiles
{
	import Box2D.Common.Math.b2Vec2;
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
		
		//Físicas de la bala.
		private var bulletObject:PhysicsObject;
		private var bulletPhysics:PhysInjector;
		
		//Posición de inicio del disparo.
		private var bulletStartX:Number;
		private var bulletStartY:Number;
		
		//Velocidad del disparo.
		private var bulletSpeed:b2Vec2;
		
		//Variable jugador.
		private var playerObjective:Player;		
		
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
			
			// Creamos la imagen de la bala.
			bulletImage = new Image(Media.getTexture("Bala1"));			
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
			
			// Inicializamos la posición de la bala.
			bulletSpeed = new b2Vec2((playerObjective.position.x-bulletStartX)/50, 3);
			
			this.addEventListener(Event.ENTER_FRAME, movement);	// Determinamos el movimiento de la bala.
		}
		
		private function movement():void
		{
			bulletObject.body.SetLinearVelocity(bulletSpeed); // Actualizamos la posición de la bala según la velocidad.
			
			ContactManager.onContactBegin(bulletObject.name,"player",playerContact); // Comprobamos si la bala colisiona con el jugador.
			
			if (bulletObject.name == "destroyed")
			{
				this.removeEventListener(Event.ENTER_FRAME, movement);
				bulletObject.physicsProperties.isDynamic = false;
				bulletObject.body.GetWorld().DestroyBody(bulletObject.body);
				bulletObject.dispose();
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