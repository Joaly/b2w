package objects
{
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Floor extends Sprite
	{
		private var floorImage:Image;
		private var floorObject:PhysicsObject;
		private var floorPhysics:PhysInjector;
		private var floorX:Number;
		private var floorY:Number;
		
		public function Floor(physics:PhysInjector, x:Number, y:Number)
		{
			floorPhysics = physics;
			floorX = x;
			floorY = y;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createFloor);
		}
		
		private function createFloor(event:Event):void
		{
			floorImage = new Image(Media.getTexture("Floor"));
			floorImage.width = stage.stageWidth;
			floorImage.height = 50;
			this.addChild(floorImage);
			
			floorX += floorImage.width/2;
			floorY -= floorImage.height/2;
			
			floorObject = floorPhysics.injectPhysics(floorImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			floorObject.x = floorX;
			floorObject.y = floorY;
			floorImage.x = floorObject.x-floorImage.width/2;
			floorImage.y = floorObject.y-floorImage.height/2;
			trace(floorImage.y, floorObject.y)
		}
	}
}