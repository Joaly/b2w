package objects
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import screens.Stage1;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Wall extends Sprite
	{
		private var wallImage:Image;
		public var wallObject:PhysicsObject;
		private var wallPhysics:PhysInjector;
		private var wallX:Number;
		private var wallY:Number;
		private var wallName:String;
		
		public function Wall(physics:PhysInjector, x:Number, y:Number, name:String) // Pasamos por parámetros las físicas y la posición donde irá la pared.
		{
			wallPhysics = physics;
			wallX = x;
			wallY = y;
			wallName = name;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createWall);
		}
		
		//* CREACIÓN DE LA PARED *//
		private function createWall(event:Event):void
		{
			// Creamos la imagen de la pared.
			wallImage = new Image(Media.getTexture("Wall"));
			wallImage.width = Stage1.OFFSET;
			wallImage.height = stage.stageHeight-wallImage.height;
			this.addChild(wallImage);
			
			// Ajustamos la posición de la pared teniendo en cuenta que el pivote del objeto será diferente.
			wallX += wallImage.width/2;
			wallY += wallImage.height/2;
			if (wallX >= stage.stageWidth) wallX -= wallImage.width;
			
			// Añadimos físicas a la pared.
			wallObject = wallPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObject.name = wallName;
			wallObject.x = wallX; // Posicionamos el objeto.
			wallObject.y = wallY;
			wallImage.x = wallObject.x-wallImage.width/2; // Centramos la imagen en el objeto.
			wallImage.y = wallObject.y-wallImage.height/2;
		}
	}
}