package enemies 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.utils.Timer;
	
	import projectiles.Bullet;
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Enemy extends Sprite 
	{
		// Objeto enemigo.
		protected var enemyImage:Image;
		protected var enemyObject:PhysicsObject;
		protected var enemyPhysics:PhysInjector;
		
		// Parámetros enemigo.
		protected var enemyStartX:Number;
		protected var enemyStartY:Number;
		protected var enemySpeed:b2Vec2;
		
		protected var bullet:Bullet;
		protected var playerObjective:Player;		
		protected var timer:Timer;
		
		public function Enemy(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
		{
			enemyPhysics = physics;
			playerObjective = player;
			enemyStartX = startX;
			enemyStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, initEnemy); // Creamos el enemigo.			
		}
		
		protected function initEnemy(event:Event):void
		{
			createEnemy("Player", 3, -1, "general"); // Esta función aplica los parámetros de imagen, velocidad en X e Y y el nombre del objeto.
		}
		
		protected function createEnemy(image:String, speedX:Number, speedY:Number, name:String):void
		{
			// La creación y posicionamiento de la imagen y objetos del enemigo será idéntica para todos los tipos.
			enemyImage = new Image(Media.getTexture(image));
			enemySpeed = new b2Vec2(speedX, speedY);
			
			enemyImage.pivotX = enemyImage.width/2; // Centramos el punto de ancla de la imagen.
			enemyImage.pivotY = enemyImage.height/2;
			enemyImage.scaleX = 0.5;
			enemyImage.scaleY = 0.5;
			this.addChild(enemyImage);
			
			// Creamos y posicionamos el objeto físico.
			enemyObject = enemyPhysics.injectPhysics(enemyImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			enemyObject.x = enemyStartX;
			enemyObject.y = enemyStartY;			
			enemyObject.physicsProperties.contactGroup = name;
			enemyObject.physicsProperties.isSensor = true;
	
			timer = new Timer(100, 0); // Temporizador que se usará para el patrón de ataque.
			
			this.addEventListener(Event.ENTER_FRAME, enemyLoop);
		}
		
		protected function enemyLoop(event:Event):void
		{
			movementPatternX(); // Movimiento en x del enemigo.
			movementPatternY(); // Movimiento en y del enemigo.
			//attack(); // Ataque del enemigo.
			checkDead(); // Comprobamos si el enemigo muere.
		}
		
		protected function movementPatternX():void
		{
			enemyObject.body.SetLinearVelocity(enemySpeed); // Aplicamos la velocidad al enemigo.
			
			// Cambiamos el sentido al llegar a la pared.
			if (enemyObject.x >= stage.stageWidth-Stage1.OFFSET-enemyImage.width/2-1) 
			{
				enemyObject.x -= enemyImage.width/5;
				enemyImage.scaleX *= -1;
				enemySpeed.x *= -1;
			}
			
			if (enemyObject.x <= Stage1.OFFSET+enemyImage.width/2+1) 
			{
				enemyObject.x += enemyImage.width/5;
				enemyImage.scaleX *= -1;
				enemySpeed.x *= -1;
			}
		}
		
		protected function movementPatternY():void
		{
			
		}
		
		protected function attack():void //Función dedicada a disparar hacia el jugador.
		{
			
		}
		
		protected function checkDead():void
		{
			if (enemyObject.physicsProperties.name == "dead") // Cuando un enemigo muera su nombre cambiará a "dead". Cuando esto pase lo eliminamos.
			{
				this.removeEventListener(Event.ENTER_FRAME, enemyLoop);
				enemyObject.physicsProperties.isDynamic = false;
				enemyObject.body.GetWorld().DestroyBody(enemyObject.body);
				this.removeChild(enemyImage);
			}
			
			if (enemyObject.physicsProperties.name == "slashed")
			{
				this.removeEventListener(Event.ENTER_FRAME, enemyLoop);
				enemyObject.physicsProperties.isDynamic = false;
				enemyObject.body.GetWorld().DestroyBody(enemyObject.body);
				timer.reset();
				timer.start();
				this.addEventListener(Event.ENTER_FRAME, enemyDeath);
			}
		}
		
		private function enemyDeath():void
		{
			// La imagen del enemigo parpadeará antes de desaparecer.
			if (enemyImage.alpha > 0) 
			{
				enemyImage.alpha -= 0.03;
				if (Math.round(timer.currentCount)%2 == 0) enemyImage.blendMode = BlendMode.NORMAL;
				else enemyImage.blendMode = BlendMode.SCREEN;
			}
			else this.removeEventListener(Event.ENTER_FRAME, enemyDeath);
			trace(timer.currentCount);
		}
	}
}