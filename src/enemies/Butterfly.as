package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	
	import flash.geom.Point;
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
		private var bounce:Boolean;
		private var shotsToBounce:Vector.<PlayerShot>;
		private	var speedY:Number;
		public function Butterfly(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			super(physics, player, startX, startY);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("MariposaEnemigo", 1, 20/-60, "contactWeak");
			shotsToBounce = new Vector.<PlayerShot>;
			speedY = new Number(2);
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
			
			for (var i:int = 0; i < Stage1.shots.length; i++) //Si colisiona alguna de las balas del jugador...
			{
				ContactManager.onContactBegin(enemyObject.name, Stage1.shots[i].name, shotContact);
			}
		}
		
		private function shotContact(enemy:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void //Entonces se borra esa bala y se crea otra que apunte al jugador, pues la mariposa repele los disparos.
		{
			shot.physicsProperties.name = "bounced";
			var shotBounced:PlayerShot = new PlayerShot(enemyPhysics, shot.x, shot.y, 3, new Point(playerObjective.playerObject.x, playerObjective.playerObject.y));
			shotsToBounce.push(shotBounced);
		}
		
		override protected function movementPatternY():void
		{
			//Movimiento "aleteo" de la mariposa.
			enemyObject.y += speedY; 
			if (enemyObject.y >= enemyStartY + 30) speedY = -2.5;
			else if (enemyObject.y <= enemyStartY) speedY = 0.5;

			
			if (shotsToBounce.length > 0)
			{
				for (var i:int; i < shotsToBounce.length; i++)
				{
					this.addChild(shotsToBounce[i]);
					Stage1.shotsBounced.push(shotsToBounce[i].shotObject);
					shotsToBounce.splice(0,1);
				}
			}
		}
	}
}