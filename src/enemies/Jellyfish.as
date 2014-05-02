package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	
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
		
		public function Jellyfish(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			super(physics, player, startX, startY);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("MedusaEnemigo", 0.5, 20/-60, "shotWeak");
			speedY = new Number(0);
		}
		
		override protected function movementPatternY():void
		{
			enemyObject.y += ( 1.5 * (Math.sin((2 * Math.PI * speedY) /10))); //Movimiento armónico simple deseado para el enemigo.
			speedY += 0.1;

		}
		
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