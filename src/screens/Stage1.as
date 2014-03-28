package screens
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	import enemies.Enemigo;
	
	public class Stage1 extends Sprite
	{
		// Stage background.
		private var stageBg:Image;
		
		// Stage floor.
		private var floor:Image;
		private var floorObject:PhysicsObject
		
		// Walls.
		private var wallObjectLeft:PhysicsObject;
		private var wallObjectRight:PhysicsObject;
		
		// Player.
		private var wallRight:Image;
		private var wallLeft:Image;
		private var player:Player;
		private var playerObject:PhysicsObject;
		
		// Physics.
		private var physics:PhysInjector;
		
		private var enemigo:Enemigo;
		
		public function Stage1()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, initializeStage);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				var force:b2Vec2 = new b2Vec2(touch.globalX-playerObject.x, touch.globalY-playerObject.y*1.2);
				playerObject.body.ApplyForce(force, playerObject.body.GetWorldCenter());
			}
		}
		
		private function initializeStage(event:Event):void
		{
			drawScreen();
			injectPhysics();
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function drawScreen():void
		{
			// Drawing the background.
			stageBg = new Image(Media.getTexture("Stage1Bg"));
			stageBg.width /= 2; // REDIMENSION
			stageBg.height /= 2; // REDIMENSION
			stageBg.y = -stageBg.height/2;
			this.addChild(stageBg);
			
			// Drawing the floor.
			floor = new Image(Media.getTexture("Floor"));
			floor.width = stage.stageWidth;
			floor.alpha = 0.5;
			this.addChild(floor);
			
			wallLeft = new Image(Media.getTexture("Floor"));
			wallLeft.height = stage.stageHeight;
			wallLeft.width = 50;
			this.addChild(wallLeft);
			
			wallRight = new Image(Media.getTexture("Floor"));
			wallRight.height = stage.stageHeight;
			wallRight.width = 50;
			this.addChild(wallRight);
			
			// Drawing the player.
			player = new Player(0,0);
			this.addChild(player);
			
			enemigo = new Enemigo(65, 0);
			this.addChild(enemigo);
			
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 60), false);
			
			// Add physics to floor.
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			floorObject.x = stage.stageWidth/2;
			floorObject.y = stage.stageHeight - (floor.height/2);
			
			// Add physics to walls.
			wallObjectRight = physics.injectPhysics(wallRight, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObjectRight.x = stage.stageWidth - (wallRight.width/2);
			
			wallObjectLeft = physics.injectPhysics(wallLeft, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObjectLeft.x = (wallLeft.width/2);
			
			// Add physics to player.
			playerObject = physics.injectPhysics(player, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			playerObject.x = 100;
		}
		
		private function loop(event:Event):void
		{
			physics.update();
			floor.x = floorObject.x - (floor.width/2);
			floor.y = floorObject.y - (floor.height/2);
			wallRight.x = wallObjectRight.x - (wallRight.width/2);;
			wallRight.y = 0;
			wallLeft.x = wallObjectLeft.x - (wallLeft.width/2);;
			wallLeft.y = 0;
			
			if (player.touchPos)
			{
				//if (player.touchPos.x > playerObject.x) playerObject.x += 2;
				//if (player.touchPos.x < playerObject.x) playerObject.x -= 2;
			}
	}
}
}