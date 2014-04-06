package enemies 
{
	import characters.Player;
	import flash.utils.Timer;
	import projectiles.Bullet;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.core.Starling;
	import starling.animation.Tween;
	import screens.Stage1;
	import projectiles.Bullet;
	import starling.animation.Transitions;
	import projectiles.PlayerShot;

	public class Jellyfish extends Enemy
	{
		
		private var tween:Tween;
		private var speedY:Number;

		public function Jellyfish(player:Player, startX:Number, startY:Number) 
		{
			super(playerObjective, startX, startY);
			
			playerObjective = player; // Jugador al que atacará el enemigo.
			enemyStartX = startX; // Posición inicial del enemigo.
			enemyStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createEnemy);
		}
		
		override protected function createEnemy(event:Event):void 
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, createEnemy);
			
			enemyImage = new Image(Media.getTexture("MedusaEnemigo"));			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.13;
			enemyImage.scaleY = 0.13;
			enemyImage.x = enemyStartX; // Inicializamos la posición del enemigo.
			enemyImage.y = enemyStartY;
			this.addChild(enemyImage);
			
			timer = new Timer(1000, 0);
			speedY = new Number(30);
			
			enemySpeed = new Number(1.4); // Inicializamos la velocidad.
			
			tween = new Tween(enemyImage,enemySpeed,Transitions.EASE_IN_OUT);
			
			Starling.juggler.add(tween);
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		override protected function movementPattern():void
		{
			enemyImage.x += enemySpeed; // Movemos el enemigo en horizontal.
			enemyImage.y += Math.sin(enemyImage.x) * speedY;
			
			//Hacemos un movimiento de subida-bajada del enemigo.
			//if (enemyImage.y <= 140) speedY *= -1;
			//if (enemyImage.y >= 160) speedY *= -1;
			
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
	}

}