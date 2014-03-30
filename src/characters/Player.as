package characters
{
	
	import Box2D.Dynamics.b2Body;
	
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
		// Imagen jugador.
		private var sprite:Image;
		
		// Posición de inicio.
		private var _startX:Number;
		private var _startY:Number;
		
		// Posición del toque (VARIABLE PÚBLICA).
		public var touchPos:Point;
		
		public function Player(startX:Number, startY:Number)
		{
			_startX = startX;
			_startY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initializePlayer); //Inicialización del jugador.
		}

		private function initializePlayer(event:Event):void
		{
			// Creamos el sprite.
			sprite = new Image(Media.getTexture("Character"));
			sprite.scaleX = 0.3;
			sprite.scaleY = 0.3;
			this.addChild(sprite);

			//this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		//*   BUCLE JUGADOR   *//
		private function loop():void
		{
			
		}
			
	}
}