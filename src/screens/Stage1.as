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
	import com.reyco1.physinjector.engines.sliceengine.SliceEngineUtils;
	
	import enemies.Butterfly;
	import enemies.Enemy;
	import enemies.Jellyfish;
	
	import flash.utils.Timer;
	
	import objects.Floor;
	import objects.Wall;
	
	import obstacles.Barrier;
	import obstacles.Mine;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Stage1 extends Sprite
	{
		// Constante que proporciona la anchura de las paredes.
		public static const OFFSET:Number = 50;
		
		// Fondo del escenario.
		private var stageBg:Image;
		
		// Objetos de la partida.
		private var floor:Floor;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var player:Player;
		private var enemy1:Jellyfish;
		private var enemy2:Butterfly;
		private var timer:Timer;
		private var barrier:Barrier;
		private var mine:Mine;
		
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
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 20), false); // Creamos la gravedad del escenario.
			
			// Creamos el suelo.
			//floor = new Floor(physics, 0, stage.stageHeight);
			//this.addChild(floor);
			
			// Creamos las paredes.
			wallLeft = new Wall(physics, "Left");
			this.addChild(wallLeft);
			wallRight = new Wall(physics, "Right");
			this.addChild(wallRight);
			
			// Creamos el jugador.
			player = new Player(physics, stage.stageWidth/2, stage.stageHeight, wallLeft, wallRight);
			this.addChild(player);
			
			//Creamos al enemigo Medusa.
			enemy1 = new Jellyfish(physics, player, 150, 150);
			this.addChild(enemy1);
			
			//Creamos al enemigo Mariposa.
			enemy2 = new Butterfly(physics, player, 150, 50);
			this.addChild(enemy2);
			
			//Creamos una barrerra.
			barrier = new Barrier(physics, player, 120, 200);
			this.addChild(barrier);
			
			//Creamos una mina.
			mine = new Mine(physics, player, Math.random(), 300);
			this.addChild(mine);
		}
		
		private function loop(event:Event):void
		{
			physics.update(); // Actualizamos las físicas a cada frame.
		}
	}	
}