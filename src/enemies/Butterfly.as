package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	
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
			super(physics, player, startX, startY);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("MariposaEnemigo", 1, -1, "shotWeak");
		}
		
		override protected function movementPatternY():void
		{
			
		}
		
		override protected function attack():void //Función dedicada a disparar hacia el jugador.
		{
			
			timer.start(); //El temporizador empieza.
			
			if (timer.currentCount == 2) //Cada dos segundos se creará un disparo.
			{
				bullet = new Bullet(enemyPhysics, playerObjective, enemyImage.x, enemyImage.y+enemyImage.height);
				this.addChild(bullet);
				timer.reset();
			}			
		}
	}
}