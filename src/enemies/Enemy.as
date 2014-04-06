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
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import projectiles.Bullet;
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Enemy extends Sprite 
	{
		//Imagen del enemigo.
		protected var enemyImage:Image;
		
		//Posición de inicio del enemigo.
		protected var enemyStartX:Number;
		protected var enemyStartY:Number;
		
		//
		protected var enemySpeed:Number;
		
		protected var bullet:Bullet;
		
		protected var playerObjective:Player;
		
		protected var attacking:Boolean;
		
		protected var timer:Timer;
		
		protected var enemyPhysics:PhysInjector;
		
		public function Enemy(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
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
			attacking = new Boolean(false); // Este booleano nos dirá si el enemigo está atacando.
			
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
			if (enemyImage.x + (enemyImage.width/2) >= (stage.stageWidth - Stage1.OFFSET))
			{
				enemyImage.scaleX *= -1;
				enemySpeed *= -1;
			}
			if (enemyImage.x - (enemyImage.width/2) <= Stage1.OFFSET)
			{
				enemyImage.scaleX *= -1;
				enemySpeed *= -1;
			}
		}
		
		protected function attack():void //Función dedicada a disparar hacia el jugador.
		{
			
			timer.start(); //El temporizador empieza.
			
			if (timer.currentCount == 2) //Cada dos segundos se creará un disparo.
			{
				//bullet = new Bullet(playerObjective, enemyImage.x, enemyImage.y+enemyImage.height);
				this.addChild(bullet);
				timer.reset();
			}

		}
	}
}