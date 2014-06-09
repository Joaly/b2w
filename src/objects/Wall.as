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
		public var wallImage:TiledImage;
		public var wallImage2:TiledImage;
		public var wallImage3:TiledImage;
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
			wallImage.height = stage.stageHeight;
			wallImage.pivotX = wallImage.width/2;
			wallImage.pivotY = wallImage.height/2;
			if (wallName == "Right") wallImage.scaleX *= -1;
			this.addChild(wallImage);
			
			wallImage2 = new TiledImage(wallTile);
			wallImage2.width = Stage1.OFFSET;
			wallImage2.height = stage.stageHeight;
			wallImage2.pivotX = wallImage2.width/2;
			wallImage2.pivotY = wallImage2.height/2;
			if (wallName == "Right") wallImage2.scaleX *= -1;
			this.addChild(wallImage2);
			
			wallImage3 = new TiledImage(wallTile);
			wallImage3.width = Stage1.OFFSET;
			wallImage3.height = stage.stageHeight;
			wallImage3.pivotX = wallImage3.width/2;
			wallImage3.pivotY = wallImage3.height/2;
			if (wallName == "Right") wallImage3.scaleX *= -1;
			this.addChild(wallImage3);
			
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
			wallImage.visible = false;
			
			wallImage2.x = wallObject.x;
			wallImage2.y = wallObject.y;
			
			wallImage3.x = wallObject.x;
			wallImage3.y = -wallObject.y;
			
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function update(event:Event):void
		{
			if (wallImage2.y > stage.stageHeight + wallImage2.height/2) wallImage2.y = wallImage3.y - wallImage2.height;
			if (wallImage3.y > stage.stageHeight + wallImage3.height/2) wallImage3.y = wallImage2.y - wallImage3.height;
			if (wallImage2.y < -stage.stageHeight/2) wallImage2.y = wallImage3.y + wallImage2.height;			
			if (wallImage3.y < -stage.stageHeight/2) wallImage3.y = wallImage2.y + wallImage3.height;
		}
	}
}