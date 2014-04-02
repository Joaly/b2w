package screens
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import enemies.DisparoEnemigo;
	import enemies.Enemigo;
	
	import objects.Floor;
	import objects.Wall;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Stage1 extends Sprite
	{
		// Constante que proporciona la anchura de las paredes.
		public static const OFFSET:Number = 62;
		
		// Fondo del escenario.
		private var stageBg:Image;
		
		// Objetos de la partida.
		private var floor:Floor;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var player:Player;
		private var enemy:Enemigo;
		
		// Físicas del mundo.
		private var physics:PhysInjector;		
		
		public function Stage1()
		{
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, initializeStage);
		}
		
		//* CREACIÓN DE LA PANTALLA *//
		private function initializeStage(event:Event):void
		{
			drawScreen(); // Creación de los elementos gráficos.
			injectPhysics(); // Creación de los objetos físicos.
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function drawScreen():void
		{
			// Creación del fondo.
			stageBg = new Image(Media.getTexture("Stage1Bg"));
			stageBg.width /= 2; // REDIMENSION
			stageBg.height /= 2; // REDIMENSION
			stageBg.y = -stageBg.height/2;
			this.addChild(stageBg);
			
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 60), false); // Creamos la gravedad del escenario.
			
			// Creamos el suelo.
			floor = new Floor(physics, 0, stage.stageHeight);
			this.addChild(floor);
			
			// Creamos las paredes.
			wallLeft = new Wall(physics, 0, 0, "Left");
			this.addChild(wallLeft);
			wallRight = new Wall(physics, stage.stageWidth, 0, "Right");
			this.addChild(wallRight);
			
			// Creamos el jugador.
			player = new Player(physics, 150, 300, wallLeft, wallRight);
			this.addChild(player);
			
			// Creamos un enemigo.
			enemy = new Enemigo(player, 150, 100);
			this.addChild(enemy);
		}
		
		private function loop(event:Event):void
		{
			physics.update(); // Actualizamos las físicas a cada frame.
		}
	}	
}