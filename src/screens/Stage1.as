package screens
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import com.greensock.plugins.AutoAlphaPlugin;
	import enemies.DisparoEnemigo;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.utils.deg2rad;
	
	import flash.utils.getTimer;
	
	import enemies.Enemigo;
	
	public class Stage1 extends Sprite
	{
		// Fondo.
		private var stageBg:Image;
		
		// Suelo.
		private var floor:Image;
		private var floorObject:PhysicsObject
		
		// Paredes.
		private var wallObjectLeft:PhysicsObject;
		private var wallLeft:Image;
		
		private var wallObjectRight:PhysicsObject;
		private var wallRight:Image;
		
		// Jugador.
		private var player:Player;
		private var playerObject:PhysicsObject;
		
		// Enemigo y disparo.
		private var enemigo:Enemigo;
		private var disparo:DisparoEnemigo;
		
		//Comprueba si existe el disparo.
		private var existeDisparo:Boolean;
		
		// Físicas del mundo.
		private var physics:PhysInjector;
		
		
		public function Stage1()
		{
			super();
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, initializeStage);
			this.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		
		//* CLICK / TOCAR PANTALLA *//
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(stage, TouchPhase.BEGAN); // Variable que almacena los datos del toque en la pantalla.
			if (touch)
			{
				var force:b2Vec2 = new b2Vec2(touch.globalX-playerObject.x, touch.globalY-playerObject.y*1.2); // Creamos la fuerza para el salto según la distancia del toque.
				playerObject.body.ApplyForce(force, playerObject.body.GetWorldCenter()); // Aplicamos la fuerza al jugador para que salte.
			}
		}
		
		//* CREACIÓN DE LA PANTALLA *//
		private function initializeStage(event:Event):void
		{
			drawScreen(); // Función que creará los elementos gráficos.
			injectPhysics(); // Aplicación de físicas.
			
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
			
			// Creación del suelo.
			floor = new Image(Media.getTexture("Floor"));
			floor.width = stage.stageWidth;
			floor.alpha = 0.5;
			this.addChild(floor);
			
			// Creación de las paredes
			wallLeft = new Image(Media.getTexture("Floor"));
			wallLeft.height = stage.stageHeight-floor.height;
			wallLeft.width = 50;
			this.addChild(wallLeft);
			
			wallRight = new Image(Media.getTexture("Floor"));
			wallRight.height = stage.stageHeight-floor.height;
			wallRight.width = 50;
			this.addChild(wallRight);
			
			// Creación del jugador.
			player = new Player(0,0);
			this.addChild(player);
			
			// Creación del enemigo.
			enemigo = new Enemigo(65,200,player);
			this.addChild(enemigo);
			
			//Asignamos valor al booleano.
			existeDisparo = new Boolean(false);
			
			
			
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 60), false); // Creamos la gravedad del escenario.
			
			// Añadimos físicas al suelo.
			floorObject = physics.injectPhysics(floor, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			floorObject.x = stage.stageWidth/2;
			floorObject.y = stage.stageHeight - (floor.height/2);
			
			// Añadimos físicas a las paredes.
			wallObjectRight = physics.injectPhysics(wallRight, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObjectRight.x = stage.stageWidth - (wallRight.width/2);
			
			wallObjectLeft = physics.injectPhysics(wallLeft, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			wallObjectLeft.x = (wallLeft.width/2);
			
			// Añadimos físicas al jugador.
			playerObject = physics.injectPhysics(player, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			playerObject.x = 100;
		}
		
		private function loop(event:Event):void
		{
			physics.update(); // Actualizamos las físicas a cada frame.
			
			// Actualizamos la posición de los objetos estáticos.
			floor.x = floorObject.x - (floor.width/2);
			floor.y = floorObject.y - (floor.height/2);
			wallRight.x = wallObjectRight.x - (wallRight.width/2);;
			wallRight.y = 0;
			wallLeft.x = wallObjectLeft.x - (wallLeft.width/2);;
			wallLeft.y = 0;
			
			ataqueEnemigo(); //Función que realiza el ataque del enemigo.
			colisiones();
			
			if (player.touchPos)
			{
				//if (player.touchPos.x > playerObject.x) playerObject.x += 2;
				//if (player.touchPos.x < playerObject.x) playerObject.x -= 2;
			}
			
		}
		
		private function colisiones():void //Comprueba las colisiones del jugador y otros objetos.
		{
			//Si el disparo choca contra alguna de las paredes entonces desaparece y se vuelve a crear otro disparo.
			if (disparo.bounds.intersects(floor.bounds) || disparo.bounds.intersects(wallLeft.bounds) || disparo.bounds.intersects(wallRight.bounds)) 
			{
				removeChild(disparo);
				existeDisparo = false;
			}
			
			if (player.bounds.intersects(enemigo.bounds) || disparo.bounds.intersects(player.bounds)) // Si colisiona el jugador contra el enemigo o la bala muere.
			{
				trace("Has muerto. :(");
				this.removeChild(player);
				removeEventListener(Event.ENTER_FRAME, loop);
			}
		}
		
		
		private function ataqueEnemigo():void //Función dedicada a realizar el ataque del enemigo.
		{
			
			if (!existeDisparo) //Esta condición la usamos para crear, de momento, una bala cuando no haya ninguna en pantalla.
			{
				disparo = new DisparoEnemigo(120,0,enemigo, player);
				this.addChild(disparo); 
				existeDisparo = true;
			}
	
		}
	}	
}