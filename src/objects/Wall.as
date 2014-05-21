package objects
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import feathers.display.TiledImage;
	
	import screens.Stage1;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Wall extends Sprite
	{
		private var wallTile:Texture;
		private var wallImage:TiledImage;
		public var wallObject:PhysicsObject;
		private var wallPhysics:PhysInjector;
		private var wallX:Number;
		private var wallY:Number;
		private var wallName:String;
		
		public function Wall(physics:PhysInjector, name:String) // Pasamos por parámetros las físicas y la posición donde irá la pared.
		{
			wallPhysics = physics;
			wallName = name;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createWall);
		}
		
		//* CREACIÓN DE LA PARED 1 *//
		private function createWall(event:Event):void
		{
			// Creamos la imagen de la pared.
			wallTile = Media.getTexture("WallTile");
			wallImage = new TiledImage(wallTile);
			wallImage.width = Stage1.OFFSET;
			wallImage.height = stage.stageHeight * 5;
			wallImage.pivotX = wallImage.width/2;
			wallImage.pivotY = wallImage.height/2;
			if (wallName == "Right") wallImage.scaleX *= -1;
			this.addChild(wallImage);
			
			// Añadimos físicas a la pared.
			wallObject = wallPhysics.injectPhysics(this, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObject.name = wallName;
			wallObject.physicsProperties.contactGroup = "wall";
			wallObject.x = wallX; // Posicionamos el objeto.
			wallObject.y = wallY;
			if (wallName == "Left") wallObject.x = wallImage.width/2;
			if (wallName == "Right") wallObject.x = stage.stageWidth-wallImage.width/2;
			wallObject.y = stage.stageHeight/2;
			wallImage.x = wallObject.x; // Centramos la imagen en el objeto.
			wallImage.y = wallObject.y;
		}
	}
}