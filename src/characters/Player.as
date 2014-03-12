package characters
{
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import screens.Stage1;
	
	import starling.core.starling_internal;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class Player extends Sprite
	{
		// Player attributes.		
		private var sprite:Image;
		
		// Start position of the player.
		private var _startX:Number;
		private var _startY:Number;
		
		// Position of touch.
		private var _touchPos:Point;
		
		public function Player(startX:Number, startY:Number)
		{
			super();
			
			_startX = startX;
			_startY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initializePlayer);
		}
		
		private function initializePlayer(event:Event):void
		{
			// Create sprite.
			sprite = new Image(Media.getTexture("Character"));
			//sprite.scaleX = 0.3;
			//sprite.scaleY = 0.3;
			sprite.x = _startX;
			sprite.y = _startY;
			x = _startX;
			y = _startY;
			this.addChild(sprite);
			
			//stage.addEventListener(TouchEvent.TOUCH, onTouch); // Receiving touch events on the screen.
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		//   PLAYER LOOP   //
		private function loop():void
		{
			// Moving the player horizontaly.
			if (_touchPos)
			{
				if (_touchPos.x > (x + sprite.width * 0.5)) sprite.x += 2;
				if (_touchPos.x < (x + sprite.width * 0.5)) sprite.x -= 2;
			}
		}
		
		//   ON TOUCH   //
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN);
			if (touch)
			{
				if ((touch.getLocation(this).y >= sprite.y) && (touch.getLocation(this).y <= (sprite.y + sprite.height))) // Touch is in the horizontal line of the player.
				{
					_touchPos = touch.getLocation(stage);
				}
			}
			
		}
			
	}
}