package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.utils.Timer;
	import projectiles.Bullet;
	
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
	import flash.utils.getTimer;
	
	public class Enemy extends Sprite 
	{
		//Imagen del enemigo.
		protected var enemyImage:Image;
		
		//Posición de inicio del enemigo.
		protected var enemyStartX:Number;
		protected var enemyStartY:Number;
		
		//Velocidad del enemigo.
		protected var enemySpeed:Number;
		
		//Variable bala.
		protected var bullet:Bullet;
		
		//Variable jugador.
		protected var playerObjective:Player;
		
		//Variable Timer para realizar el ataque cada cierto tiempo.
		protected var timer:Timer;
		
		public function Enemy(player:Player, startX:Number, startY:Number) 
		{
			playerObjective = player; // Jugador al que atacará el enemigo.
			enemyStartX = startX; // Posición inicial del enemigo.
			enemyStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createEnemy); // Creamos el enemigo.			
		}
		
		protected function createEnemy(event:Event):void
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
			
			timer = new Timer(1000, 0);
			
			enemySpeed = new Number(3); // Inicializamos la velocidad.

			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		protected function enemyLoop(event:Event):void
		{
			movementPattern(); // Movimiento del enemigo.
			attack(); // Ataque del enemigo.
			if (playerObjective.isDead) //Si el jugador está muerto, entonces se acaba el bucle del enemigo.
			{
				trace("Has muerto.");
				removeEventListener(Event.ENTER_FRAME, enemyLoop);
			}
		}
		
		protected function movementPattern():void
		{
			enemyImage.x += enemySpeed; // Movemos el enemigo en horizontal.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyImage.x + (enemyImage.width/2) >= (stage.stageWidth - Stage1.OFFSET)) enemySpeed *= -1;
			if (enemyImage.x - (enemyImage.width/2) <= Stage1.OFFSET) enemySpeed *= -1;
		}
		
		private function attack():void //Función dedicada a realizar el ataque cada 2 segundos.
		{
			timer.start(); //Empieza el temporizador
			
			if (timer.currentCount == 2) //Si llega a dos segundos, realizará un disparo.
			{
				bullet = new Bullet(playerObjective, enemyImage.x, enemyImage.y+enemyImage.height);
				this.addChild(bullet);
				timer.reset();
			}
		}
	}
}