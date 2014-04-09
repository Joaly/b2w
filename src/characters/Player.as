package characters
{
	
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import objects.Wall;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Player extends Sprite
	{
		private var playerImage:Image;
		private var playerX:Number;
		private var playerY:Number;
		public var playerObject:PhysicsObject;
		private var playerPhysics:PhysInjector;
		private var touchPos:Point;
		public var position:Point;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var onJump:Boolean;
		private var timer:Timer;
		private var shotsFired:Number;
		private var coolDown:Boolean;
		private var jumpForce:b2Vec2;
		private var touchBegin:Touch;
		private var touchEnd:Touch;
		private var slideAllowed:Boolean;
		private var slideSpeed:Number;
		private var slideDistance:Number;
		
		public var isDead:Boolean;
		
		public function Player(physics:PhysInjector, x:Number, y:Number, wallL:Wall, wallR:Wall)
		{
			playerPhysics = physics;
			playerX = x;
			playerY = y;
			wallLeft = wallL;
			wallRight = wallR;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createPlayer);
		}

		private function createPlayer(event:Event):void
		{
			// Creamos el sprite.
			playerImage = new Image(Media.getTexture("Character"));
			playerImage.pivotX = playerImage.width/2;
			playerImage.pivotY = playerImage.height/2;
			playerImage.scaleX = 0.3;
			playerImage.scaleY = 0.3;
			this.addChild(playerImage);
			
			playerObject = playerPhysics.injectPhysics(playerImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			playerObject.x = playerX;
			playerObject.y = playerY;
			playerObject.name = "player";
			
			position = new Point(playerImage.x, playerImage.y);
			onJump = new Boolean(false);
			isDead = new Boolean(false);
			coolDown = new Boolean(false);
			shotsFired = new Number(0);
			timer = new Timer(100, 0);
			jumpForce = new b2Vec2(0,0);
			
			playerObject.body.ApplyForce(new b2Vec2(100, -200), playerObject.body.GetWorldCenter());
			
			//stage.addEventListener(TouchEvent.TOUCH, onTouch);
			stage.addEventListener(TouchEvent.TOUCH, playerTouch);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		//* CLICK / TOCAR PANTALLA *//
		/*private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN); // Variable que almacena los datos del toque en la pantalla.
			if (touch && !onJump) // Cuando tocamos la pantalla y el jugador no está saltando.
			{
				if ((touch.globalY < playerObject.y) && ((playerObject.x > stage.stageWidth/2 && (touch.globalX < Stage1.OFFSET))
					|| (playerObject.x < stage.stageWidth/2 && touch.globalX > stage.stageWidth-Stage1.OFFSET)))
				// Si tocamos en la pared contraria saltamos.
				jump(touch);
				
				// En caso contrario disparamos.
				else shoot(touch);
			}
		}*/
		
		private function playerTouch(event:TouchEvent):void
		{
			if (event.getTouch(stage, TouchPhase.BEGAN))
			{
				// Si tocamos cerca del jugador almacenamos las coordenadas.
				if ((event.getTouch(stage, TouchPhase.BEGAN).globalX >= playerObject.x-playerImage.width)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalX <= playerObject.x+playerImage.width)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY >= playerObject.y-playerImage.height)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY <= playerObject.y+playerImage.height))
				{
					touchBegin = event.getTouch(stage, TouchPhase.BEGAN);
					jumpForce.x = new Number(touchBegin.globalX);
					jumpForce.y = new Number(touchBegin.globalY);
				}
				
				// En caso contario, realizamos un disparo.
				else if (!onJump) shoot(event.getTouch(stage, TouchPhase.BEGAN));
			}
			
			if (event.getTouch(stage, TouchPhase.ENDED)) 
			{
				// Si hemos tocado cerca del jugador, al finalizar el toque realizamos un salto.
				if (touchBegin && event.getTouch(stage, TouchPhase.ENDED).globalY < playerObject.y-playerImage.height
					&& ((playerObject.x < stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX > Stage1.OFFSET)
					|| (playerObject.x > stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX < stage.stageWidth-Stage1.OFFSET)))
				{
					touchEnd = event.getTouch(stage, TouchPhase.ENDED);
					jumpForce.x = (touchEnd.globalX - jumpForce.x) * 1.5;
					jumpForce.y = (touchEnd.globalY - jumpForce.y) * 1.5;
					touchBegin = null;
					touchEnd = null;
					jump(jumpForce);
				}
				
				else if (event.getTouch(stage, TouchPhase.ENDED).globalY > playerObject.y+playerImage.height && touchBegin)
				{
					if (slideAllowed)
					{
						touchBegin = null;
						slideSpeed = 5;
						slideDistance = 0;
						slideAllowed = false;
						this.addEventListener(Event.ENTER_FRAME, slideDown);
					}
				}
			}
		}
		
		private function update(event:Event):void
		{
			position.x = playerImage.x;
			position.y = playerImage.y;
			ContactManager.onContactBegin("player", wallLeft.wallObject.name, wallContact);
			ContactManager.onContactBegin("player", wallRight.wallObject.name, wallContact);
		}
		
		private function wallContact(player:PhysicsObject, wall:PhysicsObject, contact:b2Contact):void
		{
			playerObject.physicsProperties.isDynamic = false;
			onJump = false;
			slideAllowed = true;
		}
		
		private function jump(force:b2Vec2):void
		{
			playerObject.physicsProperties.isDynamic = true;
			onJump = true;
			//var force:b2Vec2 = new b2Vec2(touch.globalX-playerObject.x, touch.globalY-playerObject.y*1.2); // Creamos la fuerza para el salto según la distancia del toque.
			if (force.y < -200) force.y = -200;
			if (force.y > 0) 
			{
				force.y = 0;
				force.x = 0;
			}
			if (force.x < -200) force.x = -200;
			if (force.x > 200) force.x = 200;
			playerObject.body.ApplyForce(force, playerObject.body.GetWorldCenter()); // Aplicamos la fuerza al jugador para que salte.
		}
		
		private function shoot(touchPos:Touch):void
		{
			if (!coolDown)
			{
				var shot:PlayerShot = new PlayerShot(playerPhysics, playerObject.x, playerObject.y, 15, touchPos);
				this.addChild(shot);
				
				if (timer.currentCount <= 5) shotsFired++;				
				else if (timer.currentCount >= 30) shotsFired = 0;				
				timer.reset();
				timer.start();	
				if (shotsFired >= 5)
				{
					coolDown = true;
					timer.reset();
					timer.start();
				}
			}			
			
			if (coolDown && timer.currentCount >= 20)
			{
				timer.reset();
				timer.stop();
				coolDown = false;
				shotsFired = 0;
				shoot(touchPos);
			}
		}
		
		private function slideDown():void
		{
			if (slideDistance < 100)
			{
				playerObject.y += slideSpeed;
				slideDistance += slideSpeed;
				playerImage.y = playerObject.y;
				slideSpeed += 1;
			}
			
			else this.removeEventListener(Event.ENTER_FRAME, slideDown);
		}
	}
}