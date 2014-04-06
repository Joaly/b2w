package enemies 
{
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	
	import flash.utils.Timer;
	
	import projectiles.Bullet;
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	

	public class Butterfly extends Enemy
	{

		private var tween:Tween;
			
		public function Butterfly(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
		{
			super(enemyPhysics, playerObjective,startX,startY);
			
			playerObjective = player; // Jugador al que atacará el enemigo.
			enemyStartX = startX; // Posición inicial del enemigo.
			enemyStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createEnemy);
		}
		
		override protected function createEnemy(event:Event):void 
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, createEnemy);
			
			enemyImage = new Image(Media.getTexture("MariposaEnemigo"));			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.17;
			enemyImage.scaleY = 0.17;
			enemyImage.x = enemyStartX; // Inicializamos la posición del enemigo.
			enemyImage.y = enemyStartY;
			this.addChild(enemyImage);
			
			timer = new Timer(1000, 0);
			
			enemySpeed = new Number(2); // Inicializamos la velocidad.
			
			tween = new Tween(enemyImage,enemySpeed);
			
			Starling.juggler.add(tween);
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		override protected function enemyLoop(event:Event):void
		{
			movementPattern(); // Movimiento del enemigo.
			
			if (playerObjective.isDead) //Si el jugador está muerto, entonces se acaba el bucle del enemigo.
			{
				removeEventListener(Event.ENTER_FRAME, enemyLoop);
			}
		}
	}

}