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
			enemyImage = new Image(Media.getTexture(image));
			robotBox = new Image(Media.getTexture("WhiteRobotBox"));
			enemySpeed = new b2Vec2(speedX, speedY);
			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.2;
			enemyImage.scaleY = 0.2;
			
			robotBox.pivotX = enemyImage.width/2;
			robotBox.pivotY = enemyImage.height/2;
			robotBox.scaleX = 0.2;
			robotBox.scaleY = 0.2;
			
			robotBox.visible = false;
			
			this.addChild(robotBox);
			this.addChild(enemyImage);
			
			enemyObject = enemyPhysics.injectPhysics(enemyImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			enemyBoxObject = enemyPhysics.injectPhysics(robotBox, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			
			enemyBoxObject.physicsProperties.contactGroup = "robotBox";
			
			if (enemyStartX <= 0.5)
			{
				enemyObject.x = Stage1.OFFSET + enemyImage.width/2;
				enemyBoxObject.x = Stage1.OFFSET - 10;
			}
			else 
			{
				enemyObject.x = stage.stageWidth - Stage1.OFFSET - enemyImage.width / 2;
				enemyBoxObject.x = stage.stageWidth - Stage1.OFFSET - 10;
				enemyImage.scaleX *= -1;
				robotBox.scaleX *= -1;
			}
			
			enemyObject.y = enemyStartY;
			enemyBoxObject.y = enemyStartY - enemyImage.width/1.5;

			enemyObject.name = name + new String(Math.round(enemyObject.x*Math.random()));
			enemyObject.physicsProperties.isSensor = true;
			enemyBoxObject.physicsProperties.isSensor = true;
	
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
			enemyBoxObject.body.SetLinearVelocity(enemySpeed);
		
			// Cambiamos el sentido cuando llega a un cierto rango.
			
			if (robotStop)
			{
				enemyObject.physicsProperties.isDynamic= false;
				enemyBoxObject.physicsProperties.isDynamic = false;
				
				if (timerStop.currentCount == 2) 
				{
					timerStop.reset();
					timerStop.stop();
					robotStop = false;
					
					enemyObject.physicsProperties.isDynamic = true;
					enemyBoxObject.physicsProperties.isDynamic = true;
				}
			}
	
			if (Math.round(enemyObject.y) > enemyStartY + 34) 
			{
				enemyObject.y -= 2;
				enemyBoxObject.y -= 2;
				enemySpeed.y = -1;
				robotStop = true;
				timerStop.start();
			}
			
			if (Math.round(enemyObject.y) < enemyStartY - 35) 
			{
				enemyObject.y += 2;
				enemyBoxObject.y += 2;
				enemySpeed.y = 0.5;
				robotStop = true;
				timerStop.start();
			}
			
			if (timer.currentCount == 1)
			{
				enemyImage.texture = Media.getTexture("WhiteRobot");
				timer.reset();
				timer.stop();
			}
			
			ContactManager.onContactBegin("robotBox", "shot", robotShotContact, true);
		}
		
		private function robotShotContact(robotBox:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			shot.physicsProperties.name = "bounced";
			enemyImage.texture = Media.getTexture("WhiteRobotCover");
			timer.start();

		}
		
	}

}