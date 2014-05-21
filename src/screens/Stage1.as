package screens
{
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.*;
	import Box2D.Dynamics.Contacts.b2Contact;
	import enemies.Robot;
	import obstacles.Nut;
	
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
		
		private var spawnEnemyY:Number;
		private var spawnObstacleY:Number;
		private var GeneralSpawn:Number;
		
		// Objetos de la partida.
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var player:Player;
		private var enemy1:Jellyfish;
		private var enemy2:Butterfly;
		private var enemy3:Robot;
		private var timer:Timer;
		private var barrier:Barrier;
		private var mine:Mine;
		private var nut:Nut;
		
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
			
			spawnEnemyY = new Number(0);//Creamos las variables que pondrán el límite donde se creará el obstáculo o enemigo aleatorio.
			spawnObstacleY = new Number(0);
			GeneralSpawn = new Number(0);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function drawScreen():void
		{
			// Creación del fondo.
			stageBg = new Image(Media.getTexture("Stage1Bg"));
			stageBg.width /= 2; // TEMPORAL
			stageBg.height /= 2; // TEMPORAL
			stageBg.y = -stageBg.height/2;
			this.addChild(stageBg);
			
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 20), false); // Creamos la gravedad del escenario.
			
			/*//Creamos una tuerca.
			nut = new Nut(physics, player, Math.random(), 300);
			this.addChild(nut);*/
			
			// Creamos las paredes.
			wallLeft = new Wall(physics, "Left");
			this.addChild(wallLeft);
			wallRight = new Wall(physics, "Right");
			this.addChild(wallRight);
			
			// Creamos el jugador.
			player = new Player(physics, stage.stageWidth/2, stage.stageHeight, wallLeft, wallRight);
			this.addChild(player);
			
			/*//Creamos al enemigo Medusa.
			enemy1 = new Jellyfish(physics, player, 150, 150);
			this.addChild(enemy1);
			
			//Creamos al enemigo Mariposa.
			enemy2 = new Butterfly(physics, player, 150, 50);
			this.addChild(enemy2);
			
			//Creamos al enemigo Robot.
			enemy3 = new Robot(physics, player, Math.random(), 100);
			this.addChild(enemy3);
			
			//Creamos una barrerra.
			barrier = new Barrier(physics, player, 120, 200);
			this.addChild(barrier);
			
			//Creamos una mina.
			mine = new Mine(physics, player, Math.random(), 75);
			this.addChild(mine);*/
			
		}
		
		private function loop(event:Event):void
		{
			
			//trace(spawnEnemyY, spawnObstacleY);
			
			if (player.onJump) 
			{
				y += 1;
				physics.globalOffsetY += 1;
				spawnEnemyY += 1;
				spawnObstacleY += 1;
				GeneralSpawn -= 1;

				if (spawnObstacleY >= 80) //Si pasa de 60 entonces...
				{
					spawnObstacleY = 0;
					
					trace("hola");
					
					switch(randomRange(0,2)) //Según el valor random que saldrá del rango 0-2, se creará un enemigo u otro.
					{
						case 0: nut = new Nut(physics, player, Math.random(), GeneralSpawn - 120);  //Creamos una tuerca.
								this.addChild(nut);
								break;
										 
						case 1: barrier = new Barrier(physics, player, randomRange(70,200), GeneralSpawn - 70); //Creamos una barrera.
								this.addChild(barrier);
								break;
			
						case 2: mine = new Mine(physics, player, Math.random(), GeneralSpawn - 70); //Creamos una mina.
								this.addChild(mine);
								break;
								
						default: break;
					}
				}
				
				if (spawnEnemyY >= 40) //Si pasa de 60 entonces...
				{
					spawnEnemyY = 0;
					
					trace("hola");
					
					switch(randomRange(0,2)) //Según el valor random que saldrá del rango 0-2, se creará un enemigo u otro.
					{
						case 0: enemy1 = new Jellyfish(physics, player, 150, GeneralSpawn - 70); //Creamos una medusa.
								this.addChild(enemy1)
								break;
										 
						case 1: enemy2 = new Butterfly(physics, player, 150, GeneralSpawn - 70); //Creamos una mariposa.
								this.addChild(enemy2);
								break;
	
						case 2: enemy3 = new Robot(physics, player, Math.random(), GeneralSpawn - 70); //Creamos un robot.
								this.addChild(enemy3);
								break;
								
						default: break;
					}
				}
			}
			physics.update(); // Actualizamos las físicas a cada frame.
		}
		
		private function randomRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}	
}