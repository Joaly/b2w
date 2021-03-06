package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import flash.display.MovieClip;
	
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
		private var butterTimer:Timer;
		
		private var buttArt:starling.display.MovieClip;
		
		public function Butterfly(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			super(physics, player, startX, startY);
			this.addEventListener(Event.ADDED_TO_STAGE, initEnemy);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("Mariposa2Enemigo", 1, 20/-60, "contactWeakB", 200);
			shotsToBounce = new Vector.<PlayerShot>;
			speedY = new Number(2);
			butterTimer = new Timer(100,0);
			butterTimer.start();
			this.addEventListener(Event.ENTER_FRAME, update);
			
			enemyImage.visible = false;
			
			this.removeEventListener(Event.ADDED_TO_STAGE, initEnemy);
			createButtArt();
		}
		
		private function createButtArt():void
		{
			buttArt = new starling.display.MovieClip(Media.getCharAtlas().getTextures("ButterStand__"), 20);
			buttArt.scaleX = 0.5;
			buttArt.scaleY = 0.5;
			buttArt.pivotX = buttArt.width;
			buttArt.pivotY = buttArt.height / 2;
			Starling.juggler.add(buttArt);
			this.addChild(buttArt);
		}
		
		override protected function movementPatternX():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); // Aplicamos la velocidad al enemigo.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyObject.x >= stage.stageWidth-Stage1.OFFSET-enemyImage.width/2-1) 
			{
				enemyObject.x -= enemyImage.width / 5;
				enemyImage.scaleX *= -1;
				buttArt.scaleX *= -1;
				enemySpeed.x *= -1;
			}
			
			if (enemyObject.x <= Stage1.OFFSET+enemyImage.width/2+1) 
			{
				enemyObject.x += enemyImage.width / 5;
				enemyImage.scaleX *= -1;
				buttArt.scaleX *= -1;
				enemySpeed.x *= -1;
			}
		}
		
		override protected function movementPatternY():void
		{
			//Movimiento "aleteo" de la mariposa.
			enemyObject.y += speedY;
			if (butterTimer.currentCount < 3) speedY = -2.5;
			else if (butterTimer.currentCount < 18) speedY = 0.5;
			else 
			{
				butterTimer.reset();
				butterTimer.start();
			}
		}
		
		private function update(event:Event):void
		{
			ContactManager.onContactBegin("contactWeakB", "shot", bounceShot, true);
			
			if (shotsToBounce.length > 0)
			{
				for (var i:int; i < shotsToBounce.length; i++)
				{
					this.addChild(shotsToBounce[i]);
					shotsToBounce.splice(0,1);
				}
			}
			
			buttArt.x = enemyObject.x;
			buttArt.y = enemyObject.y;
			
		}
		
		private function bounceShot(enemy:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void //Entonces se borra esa bala y se crea otra que apunte al jugador, pues la mariposa repele los disparos.
		{
			shot.physicsProperties.name = "bounced";
			var shotBounced:PlayerShot = new PlayerShot(enemyPhysics, shot.x, shot.y, 3, new Point(playerObjective.playerObject.x, playerObjective.playerObject.y), true);
			shotsToBounce.push(shotBounced);
		}
		
		override protected function enemyDeath():void
		{
			this.removeChild(buttArt);
		}
	}
}