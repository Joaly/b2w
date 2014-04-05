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
		private var playerObject:PhysicsObject;
		private var playerPhysics:PhysInjector;
		private var touchPos:Point;
		public var position:Point;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var onJump:Boolean;
		
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
			
			playerObject.body.ApplyForce(new b2Vec2(100, -200), playerObject.body.GetWorldCenter());
			
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		//* CLICK / TOCAR PANTALLA *//
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN); // Variable que almacena los datos del toque en la pantalla.
			if (touch && !onJump)
			{
				if ((touch.globalY < playerObject.y) && 
					((playerObject.x > stage.stageWidth/2 && (touch.globalX < Stage1.OFFSET)) || 
						(playerObject.x < stage.stageWidth/2 && touch.globalX > stage.stageWidth-Stage1.OFFSET)))
				{
					playerObject.physicsProperties.isDynamic = true;
					onJump = true;
					var force:b2Vec2 = new b2Vec2(touch.globalX-playerObject.x, touch.globalY-playerObject.y*1.2); // Creamos la fuerza para el salto según la distancia del toque.
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
				
				else
				{
					shoot(touch);
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
		}
		
		private function shoot(touchPos:Touch):void
		{
			var shot:PlayerShot = new PlayerShot(playerObject.x, playerObject.y, 3, touchPos);
			this.addChild(shot);
		}
	}
}