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
	import enemies.Robot;
	
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import objects.Wall;
	
	import obstacles.Barrier;
	import obstacles.Mine;
	import obstacles.Nut;
	
	import starling.animation.IAnimatable;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Stage1 extends Sprite
	{
		// Constante que proporciona la anchura de las paredes.
		public static const OFFSET:Number = 50;
		
		// Fondo del escenario.
		private var stageBg:Image;
		
		// Rectángulo (área de la pantalla)
		//private var stageArea:Image;
		private var timerDeath:Timer;
		private var isDead:Boolean;
				
		// Variables para el spawn
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
		
		private var coord:Number;
		private var coordPrev:Number;
		public static var cameraOn:Boolean;
		public static var physicsObjects:Vector.<PhysicsObject>;
		public static var imagesToMove:Vector.<Image>;
		
		private var retryButton:Button;
		
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
			timerDeath = new Timer(1000, 0);
			
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function drawScreen():void
		{
			// Creación del fondo.
			stageBg = new Image(Media.getTexture("BG"));
			this.addChild(stageBg);
			
			/*stageArea = new Image(Media.getTexture("Rect"));
			stageArea.y = 640;
			this.addChild(stageArea);*/
		}
		
		private function injectPhysics():void
		{
			PhysInjector.STARLING = true;
			physics = new PhysInjector(Starling.current.nativeStage, new b2Vec2(0, 20), false); // Creamos la gravedad del escenario.
			
			physicsObjects = new Vector.<PhysicsObject>;
			imagesToMove = new Vector.<Image>;
			
			// Creamos las paredes.
			wallLeft = new Wall(physics, "Left");
			this.addChild(wallLeft);
			wallRight = new Wall(physics, "Right");
			this.addChild(wallRight);
			
			// Creamos el jugador.
			player = new Player(physics, stage.stageWidth/2, stage.stageHeight, wallLeft, wallRight);
			this.addChild(player);
			
			coordPrev = player.playerObject.y;
			coord = 0;			
		}
		
		private function loop(event:Event):void
		{
			
			if (coord != 0 && cameraOn)
			{
				player.playerObject.y += coord;
				for (var ii:int; ii < physicsObjects.length; ii++)	
				{
					if (physicsObjects[ii].physicsProperties.active) physicsObjects[ii].y += coord;
				}
				for (var jj:int; jj < imagesToMove.length; jj++)	
				{
					imagesToMove[jj].y += coord;
				}
				if (coord > 0)
				{
					spawnObstacleY += 1;
					spawnEnemyY += 1;
				}
				wallLeft.wallImage2.y += coord;
				wallLeft.wallImage3.y += coord;
				wallRight.wallImage2.y += coord;
				wallRight.wallImage3.y += coord;
			}
			
			if (player.sliding)
			{
				//player.playerObject.y -= 5;
				for (var i:int; i < physicsObjects.length; i++)	
				{
					if (physicsObjects[i].physicsProperties.active) physicsObjects[i].y -= player.slideSpeed;
				}
				for (var j:int; j < imagesToMove.length; j++)	
				{
					imagesToMove[j].y -= player.slideSpeed;
				}
			}
			
			if (spawnObstacleY >= 80) //Si pasa de 60 entonces...
			{
				spawnObstacleY = 0;
				
				switch(randomRange(0,2)) //Según el valor random que saldrá del rango 0-2, se creará un enemigo u otro.
				{
					case 0: nut = new Nut(physics, player, Math.random(), GeneralSpawn);  //Creamos una tuerca.
						this.addChild(nut);
						break;
					
					case 1: barrier = new Barrier(physics, player, randomRange(70,200), GeneralSpawn); //Creamos una barrera.
						this.addChild(barrier);
						break;
					
					case 2: mine = new Mine(physics, player, Math.random(), GeneralSpawn); //Creamos una mina.
						this.addChild(mine);
						break;
					
					default: break;
				}
			}
			
			if (spawnEnemyY >= 40) //Si pasa de 60 entonces...
			{
				spawnEnemyY = 0;
				
				switch(randomRange(0,2)) //Según el valor random que saldrá del rango 0-2, se creará un enemigo u otro.
				{
					case 0: enemy1 = new Jellyfish(physics, player, 150, GeneralSpawn); //Creamos una medusa.
						this.addChild(enemy1);
						break;
					
					case 1: enemy2 = new Butterfly(physics, player, 150, GeneralSpawn); //Creamos una mariposa.
						this.addChild(enemy2);
						break;
					
					case 2: enemy3 = new Robot(physics, player, Math.random(), GeneralSpawn); //Creamos un robot.
						this.addChild(enemy3);
						break;
					
					default: break;
				}
			}
			
			coordPrev = player.playerObject.y;
			physics.update(); // Actualizamos las físicas a cada frame.
			coord = coordPrev - player.playerObject.y;
			if (player.isDead) 
			{
				cameraOn = false;
				
				retryButton = new Button(Media.getTexture("Retry"));
				retryButton.scaleX = 0.5;
				retryButton.scaleY = 0.5;
				retryButton.x = stage.stageWidth/2 - retryButton.width/2;
				retryButton.y = stage.stageHeight/2 - retryButton.height/2;
				this.addChild(retryButton);
				retryButton.addEventListener(Event.TRIGGERED, retry);
			}
		}
		
		private function retry(event:Event):void
		{
			var newStage:Stage1 = new Stage1();
			stage.addChild(newStage);
			this.removeFromParent(true);
		}
		
		private function randomRange(minNum:Number, maxNum:Number):Number 
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
	}
}