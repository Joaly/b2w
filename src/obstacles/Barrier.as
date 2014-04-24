package obstacles 
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import feathers.controls.ImageLoader;
	import flash.events.TimerEvent;
	
	import characters.Player;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Rectangle;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import flash.utils.Timer;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class Barrier extends Sprite 
	{
		//Variables para el obstáculo.
		private var leftBarrierImage:Image;
		private var rightBarrierImage:Image;
		private var barrierImage:Image;
		
		//Físicas del obstáculo.
		private var leftBarrierObject:PhysicsObject;
		private var rightBarrierObject:PhysicsObject;
		private var barrierObject:PhysicsObject;
		private var barrierPhysics:PhysInjector;
		
		//Variables sobre la posición inicial del obstáculo.
		private var barrierStartX:Number;
		private var barrierStartY:Number;
		
		//Variable jugador para realizar el posible contacto con el obstáculo.
		private var playerObjective:Player;
		
		//Contador para que la barrera se vuelva a activar.
		private var timerLeft:Timer;
		private var timerRight:Timer;
		private var timerBarrier:Timer;
		
		//Booleanos para comprobar si hemos dado a ambos objetos y quitar el rayo.
		private var contactLeft:Boolean;
		private var contactRight:Boolean;
		
		//Variables para las partículas.
		private var barrierParticleConfig:XML;
		private var barrierParticle:Texture;
		private var barrierParticleSystem:PDParticleSystem;
		
		
		
		public function Barrier(physics:PhysInjector, player:Player, startX:Number, startY:Number) 
		{
			super();
			
			barrierPhysics = physics;
			playerObjective = player;
			barrierStartX = startX;
			barrierStartY = startY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, createBarrier);
		}
		
		private function createBarrier(event:Event):void
		{
			
			barrierParticleConfig = new XML(Media.getXML("ParticleConfigBarrier"));
			barrierParticle = Media.getTexture("ParticleBarrier");
			barrierParticleSystem = new PDParticleSystem(barrierParticleConfig, barrierParticle);
			this.addChild(barrierParticleSystem);
			
			//Asignamos las imágenes.
			barrierImage = new Image(Media.getTexture("BarreraRayo"));
			leftBarrierImage = new Image(Media.getTexture("BarreraEncendido"));
			rightBarrierImage = new Image(Media.getTexture("BarreraEncendido"));

			//Asignamos las propiedades a las variables imágenes.
			barrierImage.pivotX = barrierImage.width/2; // Centramos el punto de ancla de la imagen.
			barrierImage.pivotY = barrierImage.height/2;
			barrierImage.scaleX = 0.3;
			barrierImage.scaleY = 0.2;
			
			leftBarrierImage.pivotX = leftBarrierImage.width/2; // Centramos el punto de ancla de la imagen.
			leftBarrierImage.pivotY = leftBarrierImage.height/2;
			leftBarrierImage.scaleX = 0.6;
			leftBarrierImage.scaleY = 0.6;
			
			rightBarrierImage.pivotX = rightBarrierImage.width/2; // Centramos el punto de ancla de la imagen.
			rightBarrierImage.pivotY = rightBarrierImage.height/2;
			rightBarrierImage.scaleX = 0.6;
			rightBarrierImage.scaleY = 0.6;
			
			this.addChild(barrierImage);
			this.addChild(leftBarrierImage);
			this.addChild(rightBarrierImage);
			
			//Empezamos a aplicar las físicas y ponemos las coordenadas a los objetos.
			leftBarrierObject = barrierPhysics.injectPhysics(leftBarrierImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			leftBarrierImage.x = leftBarrierObject.x = barrierStartX;
			leftBarrierImage.y = leftBarrierObject.y = barrierStartY;
			leftBarrierObject.name = "Left";
			leftBarrierObject.physicsProperties.isSensor = true;
			
			barrierObject = barrierPhysics.injectPhysics(barrierImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			barrierImage.x = barrierObject.x = leftBarrierObject.x + barrierImage.width/2;
			barrierImage.y = barrierObject.y = barrierStartY;
			barrierObject.physicsProperties.isSensor = true;
	
			rightBarrierObject = barrierPhysics.injectPhysics(rightBarrierImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:false, friction:0.5, restitution:0}));
			rightBarrierImage.x = rightBarrierObject.x = barrierImage.x + barrierImage.width/2;
			rightBarrierImage.y = rightBarrierObject.y = barrierStartY;
			rightBarrierObject.name = "Right";
			rightBarrierObject.physicsProperties.isSensor = true;
			
			barrierParticleSystem.x = barrierObject.x;
			barrierParticleSystem.y = barrierObject.y;
			barrierParticleSystem.maxNumParticles = 200;
			barrierParticleSystem.scaleX = 0.25;
			barrierParticleSystem.scaleY = 0.3;
			barrierParticleSystem.speed = 5;
			Starling.juggler.add(barrierParticleSystem);
			barrierParticleSystem.start();
			
			//Declaramos otras variables necesarias.
			timerLeft = new Timer(1000, 0);
			timerRight = new Timer(1000, 0);
			timerBarrier = new Timer(1000, 0);
			
			contactLeft = new Boolean(false);
			contactRight = new Boolean(false);
			
			this.addEventListener(Event.ENTER_FRAME, barrierLoop);
			
		}
		
		private function barrierLoop(event:Event):void
		{
			contactLoop();
		}
		
		private function contactLoop():void
		{
			trace(timerLeft.currentCount, timerRight.currentCount, timerBarrier.currentCount);
			
			ContactManager.onContactBegin(barrierObject.name, playerObjective.name, playerContact); //Si la barrera contacta con el jugador, muere.
			
			for (var i:int = 0; i < Stage1.shots.length; i++) //Comprobamos si alguno de los disparos colisiona con la parte izquierda.
			{
				if (!contactLeft) ContactManager.onContactBegin(leftBarrierObject.name, Stage1.shots[i].name, leftContact);//Si hay contacto entonces no comprueba los demás contactos.
				
				if (!contactRight) ContactManager.onContactBegin(rightBarrierObject.name, Stage1.shots[i].name, rightContact);//Si hay contacto entonces no comprueba los demás contactos.
			}
			
			if (timerLeft.currentCount == 5) //si el temporizador de la parte izquierda llega a 5, entonces reseteamos.
			{
				leftBarrierImage.texture = Media.getTexture("BarreraEncendido");
				timerLeft.stop();
				timerLeft.reset();
				contactLeft = false;
			}
			
			if (timerRight.currentCount == 5) //si el temporizador de la parte derecha llega a 5, entonces reseteamos.
			{
				rightBarrierImage.texture = Media.getTexture("BarreraEncendido");
				timerRight.stop();
				timerRight.reset();
				contactRight = false;
			}
			
			if (contactLeft && contactRight)  //Si las dos partes han sido dadas, entonces hacemos invisible la barrera
			{
				timerBarrier.start();
				timerLeft.stop();
				timerLeft.reset();
				timerRight.stop();
				timerRight.reset();
				
				barrierParticleSystem.stop();
				barrierImage.visible = false;
				barrierObject.physicsProperties.active = false;
			}
			
			if (timerBarrier.currentCount == 5) //Si llega el contador de la barrera a 5, la hacemos visible otra vez.
			{
				timerBarrier.stop();
				timerBarrier.reset();
				
				
				contactLeft = false;
				contactRight = false;
				
				leftBarrierImage.texture = Media.getTexture("BarreraEncendido");
				rightBarrierImage.texture = Media.getTexture("BarreraEncendido");
				
				barrierImage.visible = true;
				barrierObject.physicsProperties.active = true;
				barrierParticleSystem.start();
			}
		}
		
		private function leftContact(leftBarrier:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void //Si contacta con la parte izquierda, se borra el disparo y se pone a verde la imagen.
		{
			if (leftBarrier.name == "Left" && !contactLeft)
			{
				timerLeft.start();
				leftBarrierImage.texture = Media.getTexture("BarreraApagado");
				shot.physicsProperties.name = "bounced";
				contactLeft = true;
			}
		}
		
		private function rightContact(rightBarrier:PhysicsObject, shot:PhysicsObject, contact:b2Contact):void //Si contacta con la parte derecha, se borra el disparo y se pone a verde la imagen.
		{
			if (rightBarrier.name == "Right" && !contactRight)
			{
				timerRight.start();
				rightBarrierImage.texture = Media.getTexture("BarreraApagado");
				shot.physicsProperties.name = "bounced";
				contactRight = true;
			}
		}
		
		private function playerContact(barrier:PhysicsObject, player:PhysicsObject, contact:b2Contact):void //Si contacta con la barrera, el jugador muere.
		{
			player.physicsProperties.name = "respawn";
		}
	}

}