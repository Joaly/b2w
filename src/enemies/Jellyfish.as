package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import starling.display.MovieClip;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
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

	public class Jellyfish extends Enemy
	{
		private var speedY:Number;
		public static const points:Number = new Number(100);
		
		private var jellyArt:MovieClip;
		
		public function Jellyfish(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			super(physics, player, startX, startY);
			this.addEventListener(Event.ADDED_TO_STAGE, initEnemy);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("Medusa2Enemigo", 0.5, 20/-60, "shotWeak", 100);
			speedY = new Number(0);
			
			enemyImage.visible = false;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initEnemy);
			createJellyArt();
		}
		
		private function createJellyArt():void
		{
			jellyArt = new MovieClip(Media.getCharAtlas().getTextures("JellyStand/JellyStand__"), 20);
			jellyArt.scaleX = -0.5;
			jellyArt.scaleY = 0.5;
			jellyArt.pivotX = jellyArt.width;
			jellyArt.pivotY = jellyArt.height / 2;
			Starling.juggler.add(jellyArt);
			this.addChild(jellyArt);
		}
		
		override protected function movementPatternX():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); // Aplicamos la velocidad al enemigo.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyObject.x >= stage.stageWidth-Stage1.OFFSET-enemyImage.width/2-1) 
			{
				enemyObject.x -= enemyImage.width / 5;
				enemyImage.scaleX *= -1;
				jellyArt.scaleX *= -1;
				enemySpeed.x *= -1;
			}
			
			if (enemyObject.x <= Stage1.OFFSET+enemyImage.width/2+1) 
			{
				enemyObject.x += enemyImage.width / 5;
				enemyImage.scaleX *= -1;
				jellyArt.scaleX *= -1;
				enemySpeed.x *= -1;
			}
		}
		
		override protected function movementPatternY():void
		{
			enemyObject.y += ( 1.5 * (Math.sin((2 * Math.PI * speedY) /10))); //Movimiento armónico simple deseado para el enemigo.
			speedY += 0.1;
			
			jellyArt.x = enemyObject.x;
			jellyArt.y = enemyObject.y;
		}
		
		override protected function enemyDeath():void{}
		
		override protected function attack():void //Función dedicada a disparar hacia el jugador.
		{
			timer.start(); //El temporizador empieza.
			
			if (timer.currentCount == 20) //Cada dos segundos se creará un disparo.
			{
				bullet = new Bullet(enemyPhysics, playerObjective, enemyImage.x, enemyImage.y+enemyImage.height/2, 2);
				this.addChild(bullet);
				timer.reset();
			}			
		}
	}
}