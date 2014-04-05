package projectiles
{
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
		private var startX:Number;
		private var startY:Number;
		private var speed:Number;
		private var target:Point;
		private var tween:Tween;
		
		
		public function PlayerShot(x:Number, y:Number, shotSpeed:Number, touchPos:Touch)
		{
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
			shotImage.x = startX;
			shotImage.y = startY;
			this.addChild(shotImage);
			
			tween = new Tween(shotImage, speed);
			Starling.juggler.add(tween);
			
			this.addEventListener(Event.ENTER_FRAME, movement);
		}
		
		private function movement(event:Event):void
		{
			tween.moveTo(target.x, target.y);
		}
	}
}