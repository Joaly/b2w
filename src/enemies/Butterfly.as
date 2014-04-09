package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import com.reyco1.physinjector.data.PhysicsObject;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	
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
			createEnemy("MariposaEnemigo", 1, -1, "contactWeak");
		}
		
		override protected function movementPatternX():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); // Aplicamos la velocidad al enemigo.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyObject.x >= stage.stageWidth-Stage1.OFFSET-enemyImage.width/2-1) 
			{
				enemyObject.x -= enemyImage.width/5;
				enemyImage.scaleX *= -1;
				enemySpeed.x *= -1;
			}
			
			if (enemyObject.x <= Stage1.OFFSET+enemyImage.width/2+1) 
			{
				enemyObject.x += enemyImage.width/5;
				enemyImage.scaleX *= -1;
				enemySpeed.x *= -1;
			}
			
			for (var i:int = 0; i < Stage1.shots.length; i++) 
			{
				ContactManager.onContactBegin(enemyObject.name, Stage1.shots[i].name, shotContact);
			}
		}
		
		private function shotContact(enemy:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			Stage1.Bounce = true;
			shot.body.SetLinearVelocity(new b2Vec2( -shot.body.GetLinearVelocity().x, -shot.body.GetLinearVelocity().y));
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