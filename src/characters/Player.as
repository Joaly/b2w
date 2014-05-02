package characters
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import objects.Wall;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;

	public class Player extends Sprite
	{
		private const forceLimit:Number = 120;
		private var playerImage:Image;
		private var playerX:Number;
		private var playerY:Number;
		public var playerObject:PhysicsObject;
		private var playerPhysics:PhysInjector;
		private var touchPos:Point;
		public var position:Point;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		private var onJump:Boolean;
		private var timer:Timer;
		private var shotsFired:Number;
		private var coolDown:Boolean;
		private var jumpForce:b2Vec2;
		private var touchBegin:Touch;
		private var touchEnd:Touch;
		private var slideAllowed:Boolean;
		private var slideSpeed:Number;
		private var slideDistance:Number;
		private var particleConfig:XML;
		private var particle:Texture;
		private var particleSystem:PDParticleSystem;
		private var particleTimer:Timer;
		private var attacking:Boolean;

		public var isDead:Boolean;

		public function Player(physics:PhysInjector, x:Number, y:Number, wallL:Wall, wallR:Wall)
		{
			playerPhysics = physics;
			playerX = x;
			playerY = y;
			wallLeft = wallL;
			wallRight = wallR;

			this.addEventListener(Event.ADDED_TO_STAGE, createPlayer);
		}

		private function createPlayer(event:Event):void
		{
			// Creamos el sprite.
			playerImage = new Image(Media.getTexture("Character"));
			playerImage.pivotX = playerImage.width/2;
			playerImage.pivotY = playerImage.height/2;
			playerImage.scaleX = 0.3;
			playerImage.scaleY = 0.3;
			this.addChild(playerImage);

			playerObject = playerPhysics.injectPhysics(playerImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			playerObject.x = playerX;
			playerObject.y = playerY;
			playerObject.name = "player";
			playerObject.physicsProperties.contactGroup = "player";

			position = new Point(playerImage.x, playerImage.y);
			onJump = new Boolean(true);
			isDead = new Boolean(false);
			coolDown = new Boolean(false);
			shotsFired = new Number(0);
			timer = new Timer(100, 0);
			particleTimer = new Timer(10, 0);
			jumpForce = new b2Vec2(0,0);
			attacking = false;

			playerObject.body.ApplyForce(new b2Vec2(forceLimit/2, -forceLimit), playerObject.body.GetWorldCenter());

			stage.addEventListener(TouchEvent.TOUCH, playerTouch);
			this.addEventListener(Event.ENTER_FRAME, update);
		}

		private function playerTouch(event:TouchEvent):void
		{
			if (event.getTouch(stage, TouchPhase.BEGAN))
			{
				// Si tocamos cerca del jugador almacenamos las coordenadas.
				if ((event.getTouch(stage, TouchPhase.BEGAN).globalX >= playerObject.x-playerImage.width)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalX <= playerObject.x+playerImage.width)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY >= playerObject.y-playerImage.height)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY <= playerObject.y+playerImage.height))
				{
					touchBegin = event.getTouch(stage, TouchPhase.BEGAN);
					jumpForce.x = new Number(touchBegin.globalX);
					jumpForce.y = new Number(touchBegin.globalY);
				}

				// En caso contario, realizamos un disparo.
				else if (!onJump) shoot(event.getTouch(stage, TouchPhase.BEGAN));
				else attack();
			}

			if (event.getTouch(stage, TouchPhase.ENDED)) 
			{
				// Si hemos tocado cerca del jugador, al finalizar el toque realizamos un salto.
				if (jumpForce.x == event.getTouch(stage, TouchPhase.ENDED).globalX
					&& jumpForce.y == event.getTouch(stage, TouchPhase.ENDED).globalY) touchBegin = null;
				if (touchBegin && event.getTouch(stage, TouchPhase.ENDED).globalY < playerObject.y-playerImage.height
					&& ((playerObject.x < stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX > Stage1.OFFSET)
					|| (playerObject.x > stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX < stage.stageWidth-Stage1.OFFSET)))
				{
					touchEnd = event.getTouch(stage, TouchPhase.ENDED);
					jumpForce.x = (touchEnd.globalX - jumpForce.x) * 1.5;
					jumpForce.y = (touchEnd.globalY - jumpForce.y) * 1.5;
					touchBegin = null;
					touchEnd = null;
					jump(jumpForce);
				}

				else if (event.getTouch(stage, TouchPhase.ENDED).globalY > playerObject.y+playerImage.height && touchBegin)
				{
					if (slideAllowed)
					{
						touchBegin = null;
						slideSpeed = 5;
						slideDistance = 0;
						slideAllowed = false;
						this.addEventListener(Event.ENTER_FRAME, slideDown);
					}
				}
			}
		}

		private function update(event:Event):void
		{
			position.x = playerObject.x;
			position.y = playerObject.y;
			
			if (playerObject.name == "respawn") playerDeath();
			if (playerObject.y > stage.stageHeight+playerImage.height*2) playerObject.name = "respawn";
			
			ContactManager.onContactBegin("player", "wall", wallContact, true);
			ContactManager.onContactBegin("player", "enemy", enemyContact, true);
			ContactManager.onContactBegin("player", "enemyShot", enemyContact, true);
		}

		private function wallContact(player:PhysicsObject, wall:PhysicsObject, contact:b2Contact):void
		{
			playerObject.physicsProperties.isDynamic = false;
			onJump = false;
			slideAllowed = true;
			playerImage.blendMode = BlendMode.NORMAL;
			attacking = false;

			if (wall.name == "Left") playerObject.x = Stage1.OFFSET+playerImage.width/2;
			else playerObject.x = stage.stageWidth-Stage1.OFFSET-playerImage.width/2;
			playerImage.x = playerObject.x;
		}

		private function enemyContact(player:PhysicsObject, enemy:PhysicsObject, contact:b2Contact):void
		{
			if (!attacking) playerObject.name = "respawn";
			if (enemy.name.substr(0,4) == "shot") enemy.physicsProperties.name = "bounced";
			if (enemy.name == "MineBox") enemy.name = "explosion";
			else enemy.physicsProperties.name = "slashed";
		}

		private function jump(force:b2Vec2):void
		{
			playerObject.physicsProperties.isDynamic = true;
			onJump = true;
			//var force:b2Vec2 = new b2Vec2(touch.globalX-playerObject.x, touch.globalY-playerObject.y*1.2); // Creamos la fuerza para el salto según la distancia del toque.
			if (force.y < -forceLimit) force.y = -forceLimit;
			if (force.y > 0) 
			{
				force.y = 0;
				force.x = 0;
			}
			if (force.x < -forceLimit) force.x = -forceLimit;
			if (force.x > forceLimit) force.x = forceLimit;
			playerObject.body.ApplyForce(force, playerObject.body.GetWorldCenter()); // Aplicamos la fuerza al jugador para que salte.
		}

		private function shoot(touchPos:Touch):void
		{
			if (!coolDown)
			{
				var shot:PlayerShot = new PlayerShot(playerPhysics, playerObject.x, playerObject.y, 15, new Point(touchPos.globalX, touchPos.globalY), false);
				this.addChild(shot);

				if (timer.currentCount <= 5) shotsFired++;				
				else if (timer.currentCount >= 30) shotsFired = 0;				
				timer.reset();
				timer.start();	
				if (shotsFired >= 5)
				{
					coolDown = true;
					timer.reset();
					timer.start();
				}
			}			

			if (coolDown && timer.currentCount >= 20)
			{
				timer.reset();
				timer.stop();
				coolDown = false;
				shotsFired = 0;
				shoot(touchPos);
			}
		}

		private function slideDown():void
		{
			if (slideDistance < 100)
			{
				playerObject.y += slideSpeed;
				slideDistance += slideSpeed;
				playerImage.y = playerObject.y;
				slideSpeed += 1;
			}

			else this.removeEventListener(Event.ENTER_FRAME, slideDown);
		}

		private function playerDeath():void			
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			onJump = true;
			playerObject.name = "player";
			playerImage.visible = false;
			playerObject.physicsProperties.awake = false;
			particleConfig = new XML(Media.getXML("ParticleConfig"));
			particle = Media.getTexture("Particle");
			particleSystem = new PDParticleSystem(particleConfig, particle);
			this.addChild(particleSystem);
			particleSystem.x = playerObject.x;
			particleSystem.y = playerObject.y;
			Starling.juggler.add(particleSystem);
			particleSystem.startSize *= 2;
			particleSystem.emitAngleVariance = 10;
			particleSystem.startColor = new ColorArgb(0,0.5,2.5,2);
			particleSystem.endColor = new ColorArgb(0,0,2.5,2);
			particleSystem.lifespan *= 0.6;
			particleSystem.start();		
			this.addEventListener(Event.ENTER_FRAME, particleFade);
			particleTimer.reset();
			particleTimer.start();
			playerObject.x = stage.stageWidth/2;
			playerObject.y = stage.stageHeight;
			playerImage.x = playerObject.x;
			playerImage.y = playerObject.y;
		}

		private function particleFade(event:Event):void
		{
			if (particleTimer.currentCount >= 10) particleSystem.stop(false);			
			if (particleTimer.currentCount >= 50)
			{
				playerImage.visible = true;
				playerObject.physicsProperties.isDynamic = true;
				this.addEventListener(Event.ENTER_FRAME, update);
				particleSystem.dispose();
				playerObject.body.ApplyForce(new b2Vec2(forceLimit/2, -forceLimit), playerObject.body.GetWorldCenter());
				this.removeEventListener(Event.ENTER_FRAME, particleFade);
			}
		}
		
		private function attack():void
		{
			playerImage.blendMode = BlendMode.SCREEN;
			attacking = true;
		}
	}
}