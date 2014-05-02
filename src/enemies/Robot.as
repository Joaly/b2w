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
		
		private var speedY:Number;
		private var robotBox:Image;
		
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
			
			this.addChild(robotBox);
			this.addChild(enemyImage);
			
			enemyObject = enemyPhysics.injectPhysics(enemyImage, PhysInjector.SQUARE, new PhysicsProperties( { isDynamic:true, friction:0.5, restitution:0 } ));
			
			if (enemyStartX <= 0.5)
			{
				enemyObject.x = Stage1.OFFSET + enemyImage.width/2;
				robotBox.x = Stage1.OFFSET - enemyImage.width/2;
			}
			else 
			{
				enemyObject.x = stage.stageWidth - Stage1.OFFSET - enemyImage.width / 2;
				robotBox.x = stage.stageWidth - Stage1.OFFSET + enemyImage.width/2;
				enemyImage.scaleX *= -1;
				robotBox.scaleX *= -1;
			}
			
			enemyObject.y  = robotBox.y = enemyStartY;

			enemyObject.name = name + new String(Math.round(enemyObject.x*Math.random()));
			enemyObject.physicsProperties.isSensor = true;
			
			robotBox.visible = false;
	
			timer = new Timer(100, 0);
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		override protected function movementPatternX():void
		{
		
		}
		
		override protected function movementPatternY():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); //Aplicamos velocidad al enemigo.
			
			robotBox.y = enemyObject.y - robotBox.width/2; //La posición "y" de la caja que seguirá al enemigo debe ser calculada en todo momento.
			
			trace(enemyObject.y, enemyImage.y, robotBox.y);
			
			// Cambiamos el sentido cuando llega a un cierto rango.
			if (enemyObject.y > enemyStartY + 50) 
			{
				enemyObject.y -= 2;
				enemySpeed.y = -1;
			}
			
			if (enemyObject.y < enemyStartY - 50) 
			{
				enemyObject.y += 2;
				enemySpeed.y = 0.5;
			}
		}
		
		private function robotShotContact(mine:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void
		{
			shot.physicsProperties.name = "bounced";

		}
		
	}

}