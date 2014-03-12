package screens
{
	import Box2D.Common.Math.b2Vec2;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.deg2rad;
	
	public class Stage1 extends Sprite
	{
		private var stageBg:Image;
		private var player:Player;
		private var playerObject:PhysicsObject;
		
		private var floor:Image;
		private var floorObject:PhysicsObject
		
		private var touchPos:Point;
		
		private var physics:PhysInjector;
		
		public function Stage1()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, initializeStage);
		}
		
		private function initializeStage(event:Event):void
		{
			drawScreen();
			injectPhysics();
			
			floor.x = 0;
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function drawScreen():void
		{
			stageBg = new Image(Media.getTexture("Stage1Bg"));
			stageBg.width /= 2; // REDIMENSION
			stageBg.height /= 2; // REDIMENSION
			stageBg.y = -stageBg.height/2;
			this.addChild(stageBg);
			
			floor = new Image(Media.getTexture("Floor"));
			floor.width = stage.stageWidth;
			this.addChild(floor);
			
			player = new Player(0,0);
			this.addChild(player);
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 60), true);
			
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0.2}));
			floorObject.x = 0;
			floorObject.y = stage.stageHeight-floor.height;
			
			playerObject = physics.injectPhysics(player, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0.1}));
		}
		
		private function loop(event:Event):void
		{
			physics.update();
			floor.y = floorObject.y;
			player.y = playerObject.y;
		}
	}
}