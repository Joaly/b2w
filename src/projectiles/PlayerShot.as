package projectiles
{
	import Box2D.Common.Math.b2Vec2;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	
	public class PlayerShot extends Sprite
	{
		private var shotImage:Image;
		private var shotObject:PhysicsObject;
		private var shotPhysics:PhysInjector;
		private var startX:Number;
		private var startY:Number;
		private var speed:Number;
		private var target:Point;
		
		
		public function PlayerShot(physics:PhysInjector, x:Number, y:Number, shotSpeed:Number, touchPos:Touch)
		{
			shotPhysics = physics;
			startX = x;
			startY = y;
			speed = shotSpeed;
			target = new Point(touchPos.globalX, touchPos.globalY);
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, createShot);
		}
		
		private function createShot(event:Event):void
		{
			shotImage = new Image(Media.getTexture("PlayerShot"));
			shotImage.pivotX = shotImage.width/2;
			shotImage.pivotY = shotImage.height/2;
			this.addChild(shotImage);
			
			shotObject = shotPhysics.injectPhysics(shotImage, PhysInjector.CIRCLE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			shotObject.physicsProperties.isSensor = true;
			shotObject.x = startX;
			shotObject.y = startY;
			shotImage.x = startX;
			shotImage.y = startY;
			
			this.addEventListener(Event.ENTER_FRAME, movement);
		}
		
		private function movement(event:Event):void
		{
			shotObject.body.SetLinearVelocity(new b2Vec2((target.x-startX)/10, (target.y-startY)/10));
			trace(shotObject.body.GetLinearVelocity().x, shotObject.body.GetLinearVelocity().y);
			if (shotObject.x < 0 || shotObject.x > stage.stageWidth || shotObject.y < 0 || shotObject.y > stage.stageHeight)
			{
				this.removeEventListener(Event.ENTER_FRAME, movement);
				shotObject.physicsProperties.isDynamic = false;
				shotObject.dispose();
				this.removeChild(shotImage);
			}
		}
	}
}