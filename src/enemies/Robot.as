package enemies 
{
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import feathers.controls.ImageLoader;
	
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

	public class Robot extends Enemy
	{
		private var enemyBoxObject:PhysicsObject;
		private var timerStop:Timer;
		private var robotBox:Image;
		private var robotStop:Boolean;
		private var blackRobot:Boolean;
		
		public function Robot(physics:PhysInjector, player:Player, startX:Number, startY:Number)
		{
			super(physics, player, startX, startY);
		}
		
		override protected function initEnemy(event:Event):void
		{
			createEnemy("WhiteRobot", 0, 0.5, "contactWeak");
		}
		
		override protected function createEnemy(image:String, speedX:Number, speedY:Number, name:String):void
		{
			// La creación y posicionamiento de la imagen y objetos del enemigo será idéntica para todos los tipos.
			if (Math.random() < 0.5) 
			{
				image = "WhiteRobot";
				blackRobot = new Boolean(false);
			}
			
			else 
			{
				image = "BlackRobot";
				blackRobot = new Boolean(true);
				
			}
			enemyImage = new Image(Media.getTexture(image));
			enemySpeed = new b2Vec2(speedX, speedY);
			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.2;
			enemyImage.scaleY = 0.2;
			
			this.addChild(enemyImage);
			
			enemyObject = enemyPhysics.injectPhysics(enemyImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			
			enemyObject.physicsProperties.contactGroup = name;
			
			if (enemyStartX <= 0.5)
			{
				enemyObject.x = Stage1.OFFSET + enemyImage.width/2;
			}
			else 
			{
				enemyObject.x = stage.stageWidth - Stage1.OFFSET - enemyImage.width / 2;
				enemyImage.scaleX *= -1;
			}
			
			enemyObject.y = enemyStartY;

			enemyObject.name = name + new String(Math.round(enemyObject.x*Math.random()));
			enemyObject.physicsProperties.isSensor = true;
	
			timer = new Timer(1000, 0);
			timerStop = new Timer(1000, 0);
			robotStop = new Boolean(false);
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		override protected function movementPatternX():void
		{
		
		}
		
		override protected function movementPatternY():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); //Aplicamos velocidad al enemigo.
		
			// Cambiamos el sentido cuando llega a un cierto rango.
			
			if (robotStop)
			{
				enemyObject.physicsProperties.isDynamic= false;
				
				if (timerStop.currentCount == 2) 
				{
					timerStop.reset();
					timerStop.stop();
					robotStop = false;
					
					enemyObject.physicsProperties.isDynamic = true;
				}
			}
	
			if (Math.round(enemyObject.y) > enemyStartY + 34) 
			{
				enemyObject.y -= 2;
				enemySpeed.y = -1;
				robotStop = true;
				timerStop.start();
			}
			
			if (Math.round(enemyObject.y) < enemyStartY - 35) 
			{
				enemyObject.y += 2;
				enemySpeed.y = 0.5;
				robotStop = true;
				timerStop.start();
			}
			
			if (timer.currentCount == 1)
			{
				if (blackRobot) enemyImage.texture = Media.getTexture("BlackRobot");
				else enemyImage.texture = Media.getTexture("WhiteRobot");
				timer.reset();
				timer.stop();
			}
			
			ContactManager.onContactBegin("contactWeak", "shot", robotShotContact, true);
		}
		
		private function robotShotContact(robotBox:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			shot.physicsProperties.name = "bounced";
			if (blackRobot) enemyImage.texture = Media.getTexture("BlackRobotCover");
			else enemyImage.texture = Media.getTexture("WhiteRobotCover");
			timer.start();
		}
		
	}

}