package projectiles
{
	import starling.animation.Tween;
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
		private var touch:Touch;
		private var tween:Tween;
		
		//Esto es una prueba.
		
		public function PlayerShot(x:Number, y:Number, touchPos:Touch)
		{
			startX = x;
			startY = y;
			touch = touchPos;
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, createShot);
		}
		
		private function createShot(event:Event):void
		{
			shotImage = new Image(Media.getTexture("PlayerShot"));
			shotImage.pivotX = shotImage.width/2;
			shotImage.pivotY = shotImage.height/2;
			shotImage.x = startX;
			shotImage.y = startY;
		}
	}
}