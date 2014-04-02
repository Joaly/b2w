package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Rectangle;
	
	import screens.Stage1;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Enemigo extends Sprite 
	{
		private var enemyImage:Image;
		private var enemyStartX:Number;
		private var enemyStartY:Number;
		private var enemySpeed:Number;
		private var bullet:DisparoEnemigo;
		private var playerObjective:Player;
		private var attacking:Boolean;
		
		public function Enemigo(player:Player, startX:Number, startY:Number) 
		{
			playerObjective = player; // Jugador al que atacará el enemigo.
			enemyStartX = startX; // Posición inicial del enemigo.
			enemyStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createEnemy); // Creamos el enemigo.			
		}
		
		private function createEnemy(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, createEnemy);
			
			enemyImage = new Image(Media.getTexture("Enemigo1"));			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.15;
			enemyImage.scaleY = 0.15;
			enemyImage.x = enemyStartX; // Inicializamos la posición del enemigo.
			enemyImage.y = enemyStartY;
			this.addChild(enemyImage);
			
			enemySpeed = new Number(3); // Inicializamos la velocidad.
			attacking = new Boolean(false); // Este booleano nos dirá si el enemigo está atacando.
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		private function enemyLoop(event:Event):void
		{
			movementPattern(); // Movimiento del enemigo.
			attack(); // Ataque del enemigo.
		}
		
		private function movementPattern():void
		{
			enemyImage.x += enemySpeed; // Movemos el enemigo en horizontal.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyImage.x + (enemyImage.width/2) >= (stage.stageWidth - Stage1.OFFSET)) enemySpeed *= -1;
			if (enemyImage.x - (enemyImage.width/2) <= Stage1.OFFSET) enemySpeed *= -1;
		}
		
		private function attack():void
		{
			if (!this.contains(bullet)) attacking = false; // Si no hay ninguna bala en escena el enemigo no está atacando.
			if (!attacking && playerObjective.visible) // Si el enemigo no está atacando, lanzamos una bala.
			{
				attacking = true;
				bullet = new DisparoEnemigo(playerObjective, enemyImage.x, enemyImage.y+enemyImage.height);
				this.addChild(bullet);
			}
		}
	}
}